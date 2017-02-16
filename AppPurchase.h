//
//  AppPurchase.h
//  VNote
//
//  Created by vmoksha mobility on 9/19/16.
//  Copyright © 2016 Vmoksha Technologies Pvt Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BuyAppViewController.h"

typedef void(^RequestProductsCompletionHandler)
(BOOL success,NSArray *products);
@class AppPurchaseProductProcess;

@interface AppPurchase : NSObject
{
    BuyAppViewController *buyApp;
}
@property (nonatomic, strong) NSMutableDictionary *products;

//- (void)requestProductsWithProductIdentifiers:
//(NSSet *)productIdentifiers;

- (id)initWithProducts:(NSMutableDictionary *)products;

- (void)requestProductsWithCompletionHandler:
(RequestProductsCompletionHandler)completionHandler;
- (void)buyProduct:(AppPurchaseProductProcess *)product;

//New Code For Non Auto RenewAble Subscription
//- (int)daysRemainingOnSubscription;
//- (NSString *)getExpirationDateString;
//- (NSDate *)getExpirationDateForMonths:(int)months;
//- (void)purchaseSubscriptionWithMonths:(int)months;



@end
