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


@end

