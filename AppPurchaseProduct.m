//
//  AppPurchaseProduct.m
//  VNote
//
//  Created by vmoksha mobility on 9/19/16.
//  Copyright © 2016 Vmoksha Technologies Pvt Ltd. All rights reserved.
//

#import "AppPurchaseProduct.h"
#import "AppPurchaseProductProcess.h"
#import "AppPurchase.h"
#import <StoreKit/StoreKit.h>




@implementation AppPurchaseProduct

+ (AppPurchaseProduct *)sharedInstance
{
    static dispatch_once_t once;
    static AppPurchaseProduct * sharedInstance;
    dispatch_once(&once, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

-(id)init
{

    AppPurchaseProductProcess * productPurchaseAutoRenewable =[[AppPurchaseProductProcess alloc]initWithProductIdentifier:@"InAppPurchase_Project_Id_Auto_Renewable"];
    
  // AppPurchaseProductProcess * productPurchaseNonAutoRenewable =[[AppPurchaseProductProcess alloc]initWithProductIdentifier:@"Com_Vmoksha_Biomag_6Months_Subscription"];
    
   // AppPurchaseProductProcess * productPurchaseNonConsuable1 =[[AppPurchaseProductProcess alloc]initWithProductIdentifier:@"com_vmoksha_ProductID_consumable"];
    
    //AppPurchaseProductProcess * productPurchaseConsuable =[[AppPurchaseProductProcess alloc]initWithProductIdentifier:@"InAppPurchase_Project_Id_Consuable"];
    
    NSMutableDictionary * dictProduct =[@{productPurchaseAutoRenewable.productIdentifier:productPurchaseAutoRenewable}mutableCopy];
    
    if ((self = [super initWithProducts:dictProduct]))
    {
        
    }
    return self;

}

/*
- (void)provideContentForProductIdentifier: (NSString *)productIdentifier {
   
    if ([productIdentifier isEqualToString:@""]) {
        int curHints =
        
        [HMContentController sharedInstance].hints;
        [[HMContentController sharedInstance] setHints: curHints + 10];
    }
    else if ([productIdentifier isEqualToString:@"com.razeware.hangman.hundredhints"]) {
        int curHints =
        
        [HMContentController sharedInstance].hints;
        
        [[HMContentController sharedInstance] setHints: curHints + 100];
    } }

*/
//- (void)notifyStatusForProduct:(IAPProduct *)product string:(NSString *)string
//{
//    NSString * message = [NSString stringWithFormat:@"%@: %@", product.skProduct.localizedTitle, string];
//    JSNotifier *notify =
//    [[JSNotifier alloc]initWithTitle:message];
//    [notify showFor:2.0];
//}

- (void)provideContentWithURL:(NSURL *)URL
{
    
    //[[HMContentController sharedInstance]
//                                        unlockContentWithDirURL:URL];
}


@end

