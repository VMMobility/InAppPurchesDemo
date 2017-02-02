#import "VerificationController.h"
#import "NSData+Base64.h"


static VerificationController *singleton;


struct signature_blob {
    uint8_t version;
    uint8_t signature[128];
    uint32_t cert_len;
    uint8_t certificate[];
};

uint8_t signature_bytes;
uint8_t signature_blob_ptr;
uint32_t certificate_len;
uint32_t signature_length;



@implementation VerificationController {
    NSMutableDictionary * _completionHandlers;
}

+ (VerificationController *)sharedInstance
{
	if (singleton == nil)
    {
		singleton = [[VerificationController alloc] init];
	}
	return singleton;
}


- (id)init
{
	self = [super init];
	if (self != nil)
    {
        transactionsReceiptStorageDictionary = [[NSMutableDictionary alloc] init];
        _completionHandlers = [[NSMutableDictionary alloc] init];
	}
	return self;
}


- (NSDictionary *)dictionaryFromPlistData:(NSData *)data
{
    NSError *error;
    NSDictionary *dictionaryParsed = [NSPropertyListSerialization propertyListWithData:data
                                                                               options:NSPropertyListImmutable
                                                                                format:nil
                                                                                 error:&error];
    if (!dictionaryParsed)
    {
        if (error)
        {
            NSLog(@"Error parsing plist");
        }
        return nil;
    }
    return dictionaryParsed;
}


- (NSDictionary *)dictionaryFromJSONData:(NSData *)data
{
    NSError *error;
    NSDictionary *dictionaryParsed = [NSJSONSerialization JSONObjectWithData:data
                                                                     options:0
                                                                       error:&error];
    if (!dictionaryParsed)
    {
        if (error)
        {
            NSLog(@"Error parsing dictionary");
        }
        return nil;
    }
    return dictionaryParsed;
}


#pragma mark Receipt Verification

// This method should be called once a transaction gets to the SKPaymentTransactionStatePurchased or SKPaymentTransactionStateRestored state
// Call it with the SKPaymentTransaction.transactionReceipt
- (void)verifyPurchase:(SKPaymentTransaction *)transaction completionHandler:(VerifyCompletionHandler)completionHandler
{    
    BOOL isOk = [self isTransactionAndItsReceiptValid:transaction];
    if (!isOk)
    {
        // There was something wrong with the transaction we got back, so no need to call verifyReceipt.
        NSLog(@"Invalid transacion");
        completionHandler(FALSE);
        return;
    }
    
    // The transaction looks ok, so start the verify process.
    
    // Encode the receiptData for the itms receipt verification POST request.
//    NSString *jsonObjectString = [self encodeBase64:(uint8_t *)transaction.transactionReceipt.bytes
//                                             length:transaction.transactionReceipt.length];
//    
//    // Create the POST request payload.
//    NSString *payload = [NSString stringWithFormat:@"{\"receipt-data\" : \"%@\", \"password\" : \"%@\"}",
//                         jsonObjectString, ITC_CONTENT_PROVIDER_SHARED_SECRET];
//    
//    NSData *payloadData = [payload dataUsingEncoding:NSUTF8StringEncoding];
//    
//    // Use ITMS_SANDBOX_VERIFY_RECEIPT_URL while testing against the sandbox.
//    NSString *serverURL = ITMS_SANDBOX_VERIFY_RECEIPT_URL; //ITMS_PROD_VERIFY_RECEIPT_URL;
//    
//    // Create the POST request to the server.
//    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:serverURL]];
//    [request setHTTPMethod:@"POST"];
//    [request setHTTPBody:payloadData];
//    NSURLConnection *conn = [[NSURLConnection alloc]initWithRequest:request delegate:self];
//    
//    _completionHandlers[[NSValue valueWithNonretainedObject:conn]] = completionHandler;
//    
//    [conn start];
//    
    // The transation receipt has not been validated yet.  That is done from the NSURLConnection callback.
}
    
// Check the validity of the receipt.  If it checks out then also ensure the transaction is something
// we haven't seen before and then decode and save the purchaseInfo from the receipt for later receipt validation.
- (BOOL)isTransactionAndItsReceiptValid:(SKPaymentTransaction *)transaction
{
    if (!(transaction && transaction.transactionReceipt && [transaction.transactionReceipt length] > 0))
    {
        // Transaction is not valid.
        return NO;
    }
    
    // Pull the purchase-info out of the transaction receipt, decode it, and save it for later so
    // it can be cross checked with the verifyReceipt.
    
    NSDictionary *receiptDict  =
    
    [self dictionaryFromPlistData:transaction.transactionReceipt];
    
    NSString *transactionPurchaseInfo = [receiptDict objectForKey:@"purchase-info"];
    
    NSString *decodedPurchaseInfo   = [self decodeBase64:transactionPurchaseInfo length:nil];
    
    NSDictionary *purchaseInfoDict  = [self dictionaryFromPlistData:[decodedPurchaseInfo dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSString *transactionId         = [purchaseInfoDict objectForKey:@"transaction-id"];
    
    NSString *purchaseDateString    = [purchaseInfoDict objectForKey:@"purchase-date"];
    
    NSString *signature             = [receiptDict objectForKey:@"signature"];
   
    
//    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
//    NSString *LoginObjectId=[defaults objectForKey:@"LOGINOBJECTID"];
//    [defaults synchronize];
//    
//    PFObject *fileData=[PFObject objectWithClassName:@"PurchaseDetails"];
//    fileData[@"PurchaseDate"]=purchaseDateString;
//    fileData[@"CreatedBy"]=LoginObjectId;
//    [fileData saveInBackground];
//    
    
    // Convert the string into a date
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm:ss z"];
    
    NSDate *purchaseDate = [dateFormat dateFromString:[purchaseDateString stringByReplacingOccurrencesOfString:@"Etc/" withString:@""]];
    
    
    if (![self isTransactionIdUnique:transactionId])
    {
        [transactionsReceiptStorageDictionary objectForKey:transactionId];
                 return NO;
    }
    
    // Check the authenticity of the receipt response/signature etc.

  BOOL result = (transactionPurchaseInfo, signature,
                                       (__bridge CFDateRef)(purchaseDate));
    
    if (!result)
    {
        return NO;
    }
    
    // Ensure the transaction itself is legit
    if (![self doTransactionDetailsMatchPurchaseInfo:transaction withPurchaseInfo:purchaseInfoDict])
    {
        return NO;
    }
    
    // Make a note of the fact that we've seen the transaction id already
    [self saveTransactionId:transactionId];
    
    // Save the transaction receipt's purchaseInfo in the transactionsReceiptStorageDictionary.
    [transactionsReceiptStorageDictionary setObject:purchaseInfoDict forKey:transactionId];
    
    return YES;
}


// Make sure the transaction details actually match the purchase info
- (BOOL)doTransactionDetailsMatchPurchaseInfo:(SKPaymentTransaction *)transaction withPurchaseInfo:(NSDictionary *)purchaseInfoDict

{
    if (!transaction || !purchaseInfoDict)
    {
        return NO;
    }
    
    int failCount = 0;
    
    if (![transaction.payment.productIdentifier isEqualToString:[purchaseInfoDict objectForKey:@"product-id"]])
    {
        
        failCount++;
    }
    
    if (transaction.payment.quantity != [[purchaseInfoDict objectForKey:@"quantity"] intValue])
    {
        failCount++;
    }
    
    if (![transaction.transactionIdentifier isEqualToString:[purchaseInfoDict objectForKey:@"transaction-id"]])
    {
        failCount++;
    }
    
    // Optionally check the bid and bvrs match this app's current bundle ID and bundle version.
    // Optionally check the requestData.
    // Optionally check the dates.
    
    if (failCount != 0)
    {
        return NO;
    }
    
    // The transaction and its signed content seem ok.
    return YES;
}



- (BOOL)isTransactionIdUnique:(NSString *)transactionId
{
    NSString *transactionDictionary = KNOWN_TRANSACTIONS_KEY;
    // Save the transactionId to the standardUserDefaults so we can check against that later
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults synchronize];
    
    if (![defaults objectForKey:transactionDictionary])
    {
        [defaults setObject:[[NSMutableDictionary alloc] init] forKey:transactionDictionary];
        [defaults synchronize];
    }
    
    if (![[defaults objectForKey:transactionDictionary] objectForKey:transactionId])
    {
        return YES;
    }
    // The transaction already exists in the defaults.
    return NO;
}


- (void)saveTransactionId:(NSString *)transactionId
{
    // Save the transactionId to the standardUserDefaults so we can check against that later
    // If dictionary exists already then retrieve it and add new transactionID
    // Regardless save transactionID to dictionary which gets saved to NSUserDefaults
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *transactionDictionary = KNOWN_TRANSACTIONS_KEY;
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionaryWithDictionary:
                                       [defaults objectForKey:transactionDictionary]];
    if (!dictionary)
    {
        dictionary = [[NSMutableDictionary alloc] initWithObjectsAndKeys:[NSNumber numberWithInt:1], transactionId, nil];
    } else {
        [dictionary setObject:[NSNumber numberWithInt:1] forKey:transactionId];
    }
    [defaults setObject:dictionary forKey:transactionDictionary];
    [defaults synchronize];
    
}


- (BOOL)doesTransactionInfoMatchReceipt:(NSString*) receiptString
{
    // Convert the responseString into a dictionary and pull out the receipt data.
    NSDictionary *verifiedReceiptDictionary = [self dictionaryFromJSONData:[receiptString dataUsingEncoding:NSUTF8StringEncoding]];
    
    // Check the status of the verifyReceipt call
    id status = [verifiedReceiptDictionary objectForKey:@"status"];
    if (!status)
    {
        return NO;
    }
    int verifyReceiptStatus = [status integerValue];
    // 21006 = This receipt is valid but the subscription has expired.
    if (0 != verifyReceiptStatus && 21006 != verifyReceiptStatus)
    {
        return NO;
    }
    
    // The receipt is valid, so checked the receipt specifics now.
    
    NSDictionary *verifiedReceiptReceiptDictionary  = [verifiedReceiptDictionary objectForKey:@"receipt"];
    // NSString *verifiedReceiptUniqueIdentifier       = [verifiedReceiptReceiptDictionary objectForKey:@"unique_identifier"];
    NSString *transactionIdFromVerifiedReceipt      = [verifiedReceiptReceiptDictionary objectForKey:@"transaction_id"];
    
    // Get the transaction's receipt data from the transactionsReceiptStorageDictionary
    NSDictionary *purchaseInfoFromTransaction = [transactionsReceiptStorageDictionary objectForKey:transactionIdFromVerifiedReceipt];
    
    if (!purchaseInfoFromTransaction)
    {
        // We didn't find a receipt for this transaction.
        return NO;
    }
    
    
    // NOTE: Instead of counting errors you could just return early.
    int failCount = 0;
    
    // Verify all the receipt specifics to ensure everything matches up as expected
    if (![[verifiedReceiptReceiptDictionary objectForKey:@"bid"]
          isEqualToString:[purchaseInfoFromTransaction objectForKey:@"bid"]])
    {
        failCount++;
    }
    
    if (![[verifiedReceiptReceiptDictionary objectForKey:@"product_id"]
          isEqualToString:[purchaseInfoFromTransaction objectForKey:@"product-id"]])
    {
        failCount++;
    }
    
    if (![[verifiedReceiptReceiptDictionary objectForKey:@"quantity"]
          isEqualToString:[purchaseInfoFromTransaction objectForKey:@"quantity"]])
    {
        failCount++;
    }
    
    if (![[verifiedReceiptReceiptDictionary objectForKey:@"item_id"]
          isEqualToString:[purchaseInfoFromTransaction objectForKey:@"item-id"]])
    {
        failCount++;
    }
    
    if ([[UIDevice currentDevice] respondsToSelector:NSSelectorFromString(@"identifierForVendor")]) // iOS 6?
    {
        // iOS 6 (or later)
        NSString *localIdentifier                   = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
        NSString *purchaseInfoUniqueVendorId        = [purchaseInfoFromTransaction objectForKey:@"unique-vendor-identifier"];
        NSString *verifiedReceiptVendorIdentifier   = [verifiedReceiptReceiptDictionary objectForKey:@"unique_vendor_identifier"];
        
        
        if(verifiedReceiptVendorIdentifier)
        {
            if (![purchaseInfoUniqueVendorId isEqualToString:verifiedReceiptVendorIdentifier]
                || ![purchaseInfoUniqueVendorId isEqualToString:localIdentifier])
            {
                // Comment this line out to test in the Simulator.
                failCount++;
            }
        }
    }
    
    
    // Do addition time checks for the transaction and receipt.
    
    if(failCount != 0)
    {
        return NO;
    }
    
    return YES;
}


// Encoding and Decoding

- (NSString *)encodeBase64:(const uint8_t *)input length:(NSInteger)length
{
    NSData * data = [NSData dataWithBytes:input length:length];
    return [data base64EncodedString];
}


- (NSString *)decodeBase64:(NSString *)input length:(NSInteger *)length
{
    NSData * data = [NSData dataFromBase64String:input];
    return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
}


#pragma mark NSURLConnectionDelegate (for the verifyReceipt connection)

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    
    NSLog(@"Connection failure: %@", error);

    VerifyCompletionHandler completionHandler = _completionHandlers[[NSValue valueWithNonretainedObject:connection]];
    [_completionHandlers removeObjectForKey:[NSValue valueWithNonretainedObject:connection]];
    completionHandler(FALSE);
    
}

//- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
//{
//    NSString *responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
//    
//    // So we got some receipt data. Now does it all check out?
//    BOOL isOk = [self doesTransactionInfoMatchReceipt:responseString];
//
//    VerifyCompletionHandler completionHandler = _completionHandlers[[NSValue valueWithNonretainedObject:connection]];
//    [_completionHandlers removeObjectForKey:[NSValue valueWithNonretainedObject:connection]];
//    if (isOk)
//    {
//        //Validation suceeded. Unlock content here.
//        NSLog(@"Validation successful");
//        completionHandler(TRUE);
//
//    } else {
//        NSLog(@"Validation failed");
//        completionHandler(FALSE);
//    }
//}


//- (void)connection:(NSURLConnection *)connection willSendRequestForAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge
//{
//    if ([[[challenge protectionSpace] authenticationMethod] isEqualToString:NSURLAuthenticationMethodServerTrust])
//    {
//        SecTrustRef trust = [[challenge protectionSpace] serverTrust];
//        NSError *error = nil;
//        BOOL didUseCredential = NO;
//        BOOL isTrusted = [self validateTrust:trust error:&error];
//        if (isTrusted)
//        {
//            NSURLCredential *trust_credential = [NSURLCredential credentialForTrust:trust];
//            if (trust_credential)
//            {
//                [[challenge sender] useCredential:trust_credential forAuthenticationChallenge:challenge];
//                didUseCredential = YES;
//            }
//        }
//        if (!didUseCredential)
//        {
//            [[challenge sender] cancelAuthenticationChallenge:challenge];
//        }
//    } else {
//        [[challenge sender] performDefaultHandlingForAuthenticationChallenge:challenge];
//    }
//}

// NOTE: These are needed for 4.x (as willSendRequestForAuthenticationChallenge: is not supported)
- (BOOL)connection:(NSURLConnection *)connection canAuthenticateAgainstProtectionSpace:(NSURLProtectionSpace *)protectionSpace
{
    return [[protectionSpace authenticationMethod] isEqualToString:NSURLAuthenticationMethodServerTrust];
}


//- (void)connection:(NSURLConnection *)connection didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge
//{
//    if ([[[challenge protectionSpace] authenticationMethod] isEqualToString:NSURLAuthenticationMethodServerTrust])
//    {
//        SecTrustRef trust = [[challenge protectionSpace] serverTrust];
//        NSError *error = nil;
//        BOOL didUseCredential = NO;
//        BOOL isTrusted = [self validateTrust:trust error:&error];
//        if (isTrusted)
//        {
//            NSURLCredential *credential = [NSURLCredential credentialForTrust:trust];
//            if (credential)
//            {
//                [[challenge sender] useCredential:credential forAuthenticationChallenge:challenge];
//                didUseCredential = YES;
//            }
//        }
//        if (! didUseCredential) {
//            [[challenge sender] cancelAuthenticationChallenge:challenge];
//        }
//    }
//    else {
//        [[challenge sender] performDefaultHandlingForAuthenticationChallenge:challenge];
//    }
//}

//#pragma mark
//#pragma mark NSURLConnection - Trust validation
//
//- (BOOL)validateTrust:(SecTrustRef)trust error:(NSError **)error
//{
//    
//    // Include some Security framework SPIs
//    extern CFStringRef kSecTrustInfoExtendedValidationKey;
//    extern CFDictionaryRef SecTrustCopyInfo(SecTrustRef trust);
//    
//    BOOL trusted = NO;
//    SecTrustResultType trust_result;
//    if ((noErr == SecTrustEvaluate(trust, &trust_result)) && (trust_result == kSecTrustResultUnspecified))
//    {
//        NSDictionary *trust_info = (__bridge_transfer NSDictionary *)SecTrustCopyInfo(trust);
//        id hasEV = [trust_info objectForKey:(__bridge NSString *)kSecTrustInfoExtendedValidationKey];
//        trusted =  [hasEV isKindOfClass:[NSValue class]] && [hasEV boolValue];
//    }
//    
//    if (trust)
//    {
//        if (!trusted && error)
//        {
//            *error = [NSError errorWithDomain:@"kSecTrustError" code:(NSInteger)trust_result userInfo:nil];
//        }
//        return trusted;
//    }
//    return NO;
//}
//
//
//

@end
