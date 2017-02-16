//
//  AppPurchase.m
//  VNote
//
//  Created by vmoksha mobility on 9/19/16.
//  Copyright © 2016 Vmoksha Technologies Pvt Ltd. All rights reserved.
//

#import "AppPurchase.h"
#import <StoreKit/StoreKit.h>
#import "AppPurchaseProductProcess.h"
#import "VerificationController.h"

#import "BuyAppViewController.h"


@interface AppPurchase()<SKProductsRequestDelegate,SKPaymentTransactionObserver>


@end

@implementation AppPurchase
{
    SKProductsRequest *productsRequest;
    RequestProductsCompletionHandler _completionHandler;
    
    BuyAppViewController * buyVC;
    
}

- (id)initWithProducts:(NSMutableDictionary *)products
{
    if ((self = [super init]))
    {
    _products = products;
    [[SKPaymentQueue defaultQueue]
                           addTransactionObserver:self];
    }
        return self;
}

//1.Request for products

-(void)requestProductsWithCompletionHandler:(RequestProductsCompletionHandler)completionHandler
{
    _completionHandler=[completionHandler copy];
    NSMutableSet *productIdentifiers=[NSMutableSet setWithCapacity:_products.count];
    
    for (AppPurchaseProductProcess *product in _products.allValues)
    {
        product.isAvilableForPurchase = NO;
       [productIdentifiers addObject:product.productIdentifier];
       
    }
    
    productsRequest = [[SKProductsRequest alloc] initWithProductIdentifiers:productIdentifiers];
    productsRequest.delegate = self;
    [productsRequest start];
}

//2.Products response

- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response
{
    NSLog(@"In App Purchase app deatils:-");
    productsRequest=nil;
    NSArray *skProducts=response.products;
    
    for(SKProduct *skProduct in skProducts)
    {
        AppPurchaseProductProcess *product=_products[skProduct.productIdentifier];
        product.skProduct = skProduct;
        product.isAvilableForPurchase = YES;
        NSLog(@"Product identifier: %@", skProduct.productIdentifier);
        NSLog(@"Product title:%@",skProduct.localizedTitle);
        NSLog(@"Product price:%0.2f",skProduct.price.floatValue);
        NSLog(@"Product description:%@",skProduct.localizedDescription);
    }
    
    for (NSString *invalidProductIdentifier in response.invalidProductIdentifiers)
    {
        AppPurchaseProductProcess *product=_products[invalidProductIdentifier];
        product.isAvilableForPurchase = YES;
        NSLog(@"Invaliidentifier:%@",invalidProductIdentifier);
    }
      NSMutableArray *availableProducts=[NSMutableArray array];
    
    for (AppPurchaseProductProcess *product in _products.allValues )
    {
        if (product.isAvilableForPurchase)
        {
            [availableProducts addObject:product];
        }
    }
     _completionHandler(YES, availableProducts);
     _completionHandler=nil;
}

// Error in Response

- (void)request:(SKRequest *)request didFailWithError:(NSError *)error
{
    NSLog(@"Failed to load list of products.");
    productsRequest = nil;
    _completionHandler(FALSE, nil);
    _completionHandler = nil;
}

//3.For Buying Product

- (void)buyProduct:(AppPurchaseProductProcess *)product
{
   
    NSLog(@"Buying %@...", product.productIdentifier);
    product.purchaseInProgress = YES;
    SKPayment * payment = [SKPayment paymentWithProduct:product.skProduct];
    [[SKPaymentQueue defaultQueue] addPayment:payment];
}

//4.Payment Transaction

- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transactions
{
       for (SKPaymentTransaction * transaction in transactions)
       {
               switch (transaction.transactionState)
            {
                 case SKPaymentTransactionStatePurchased:
                 [self completeTransaction:transaction];
                 break;
            
                case SKPaymentTransactionStateFailed:
                [self failedTransaction:transaction];
                break;
        
                case SKPaymentTransactionStateRestored:
                [self restoreTransaction:transaction];
                default: break;
            }
       }
}

//4.1. Checking Trasation Completed Sucsefully r Not

- (void)completeTransaction:(SKPaymentTransaction *)transaction
{
    
    NSLog(@"completeTransaction...");
    
    
    [self validateReceiptForTransaction:transaction];
    
   // [self provideContentForProductIdentifier:transaction.payment.productIdentifier];
    
    //[self provideContentForTransaction:transaction productIdentifier:transaction.payment.productIdentifier];
    
    [[SKPaymentQueue defaultQueue] finishTransaction:transaction];

}

// validating Receipt for transaction ...
- (void)validateReceiptForTransaction:(SKPaymentTransaction *)transaction
{
    VerificationController * verifier = [VerificationController sharedInstance];
    [verifier verifyPurchase:transaction completionHandler:^(BOOL success)
     {
         if (success)
         {
             NSLog(@"Successfully verified receipt!");
             [self provideContentForProductIdentifier:transaction.payment.productIdentifier];
         }
         else
         {
             NSLog(@"Failed to validate receipt.");
             [[SKPaymentQueue defaultQueue] finishTransaction: transaction];
         }
     }];
}

// Restore transaction...
- (void)restoreTransaction:(SKPaymentTransaction *)transaction
{
    NSLog(@"restoreTransaction...");
    
    [self validateReceiptForTransaction:transaction];
    [[SKPaymentQueue defaultQueue] finishTransaction:transaction];


}
// Transaction fail ...
- (void)failedTransaction:(SKPaymentTransaction *)transaction
{
    NSLog(@"failedTransaction...");
    if (transaction.error.code != SKErrorPaymentCancelled)
    {
        NSLog(@"Transaction error: %@", transaction.error.localizedDescription);
    }
    AppPurchaseProductProcess * product = _products[transaction.payment.productIdentifier];
    [self notifyStatusForProductIdentifier: transaction.payment.productIdentifier string:@"Purchase failed."];
    product.purchaseInProgress = NO;
    [[SKPaymentQueue defaultQueue] finishTransaction: transaction];
}

- (void)notifyStatusForProductIdentifier:(NSString *)productIdentifier string:(NSString *)string
{
    AppPurchaseProductProcess * product = _products[productIdentifier];
    [self notifyStatusForProduct:product string:string];
}
- (void)notifyStatusForProduct:(AppPurchaseProductProcess *)product string:(NSString *)string
{

}

- (void)provideContentForTransaction: (SKPaymentTransaction *)transaction productIdentifier:(NSString *)productIdentifier
{
    AppPurchaseProductProcess *product=_products[productIdentifier];
    [self provideContentForProductIdentifier:productIdentifier];
    [self notifyStatusForProductIdentifier:productIdentifier string:@"Purchase complete!"];
    
    product.purchaseInProgress = NO;
    [[SKPaymentQueue defaultQueue] finishTransaction:transaction];

}

// Providing content for Particular product Identifiers :
- (void)provideContentForProductIdentifier: (NSString *)productIdentifier
{

    if ([productIdentifier isEqualToString:@"InAppPurchase_Project_Id_Auto_Renewable"])
    {
        
        NSLog(@"Unlock the content for User After subscribption done sucssefully");


    }
    
}

//New Code For Non Auto RenewAble Subscription

//- (int)daysRemainingOnSubscription {
//
//    NSDate *expirationDate = [[NSUserDefaults standardUserDefaults]
//                              objectForKey:kSubscriptionExpirationDateKey];
//    NSTimeInterval timeInt = [expirationDate timeIntervalSinceDate:[NSDate date]];
//    
//    int days = timeInt / 60 / 60 / 24;
//    
//    if (days > 0) {
//        return days;
//    } else {
//        return 0;
//    }
//}
//
//- (NSDate *)getExpirationDateForMonths:(int)months {
//    
//     NSDate *originDate = nil;
//    
//    if ([self daysRemainingOnSubscription] > 0) {
//        originDate = [[NSUserDefaults standardUserDefaults]
//                      objectForKey:kSubscriptionExpirationDateKey];
//    } else {
//        originDate = [NSDate date];
//    }
//
//    NSDateComponents *dateComp = [[NSDateComponents alloc] init];
//    [dateComp setMonth:months];
//
////    [dateComp setDay:1]; //add an extra day to subscription because      we love our users
//    
//    return [[NSCalendar currentCalendar] dateByAddingComponents:dateComp
//                                                         toDate:originDate
//                                                        options:0];
//}
//
//- (NSString *)getExpirationDateString {
//    
//    if ([self daysRemainingOnSubscription] > 0)
//    {
//        NSDate *today = [[NSUserDefaults standardUserDefaults] objectForKey:kSubscriptionExpirationDateKey];
//        NSDateFormatter * dateFormat = [[NSDateFormatter alloc] init];
//        [dateFormat setDateFormat:@"dd/MM/yyyy"];
//        
//       return [NSString stringWithFormat:@"Subscribed! \nExpires: %@ (%i Days)",[dateFormat stringFromDate:today],[self daysRemainingOnSubscription]];
//    } else
//    {
//        return @"Not Subscribed";
//    }
//}
//
//- (void)purchaseSubscriptionWithMonths:(int)months {
//
//    PFQuery * query = [PFQuery queryWithClassName:@"_User"];
//    
//    [query getObjectInBackgroundWithId:[PFUser currentUser].objectId block:^(PFObject *object, NSError *error)
//    {
//    NSDate * serverDate = [[object objectForKey:kSubscriptionExpirationDateKey] lastObject];
//    NSDate * localDate = [[NSUserDefaults standardUserDefaults] objectForKey:kSubscriptionExpirationDateKey];
//        
//           if ([serverDate compare:localDate] == NSOrderedDescending)
//           {
//            [[NSUserDefaults standardUserDefaults] setObject:serverDate forKey:kSubscriptionExpirationDateKey];
//            [[NSUserDefaults standardUserDefaults] synchronize];
//           }
//        
//         NSDate * expirationDate = [self getExpirationDateForMonths:months];
//        
//        [object addObject:expirationDate forKey:kSubscriptionExpirationDateKey];
//        [object saveInBackground];
//        
//        [[NSUserDefaults standardUserDefaults] setObject:expirationDate forKey:kSubscriptionExpirationDateKey];
//        [[NSUserDefaults standardUserDefaults] synchronize];
//        
//           NSLog(@"Subscription Complete!");
//    }];
//}

@end
