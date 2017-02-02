//
//  AppPurchaseProductProcess.h
//  VNote
//
//  Created by vmoksha mobility on 9/20/16.
//  Copyright © 2016 Vmoksha Technologies Pvt Ltd. All rights reserved.
//

@class SKProduct;
#import <Foundation/Foundation.h>

@interface AppPurchaseProductProcess : NSObject

- (id)initWithProductIdentifier:(NSString *)productIdentifier;

- (BOOL)allowedToPurchase;

@property(assign,nonatomic)BOOL isAvilableForPurchase;
@property(nonatomic,strong)NSString *productIdentifier;
@property(nonatomic,strong)SKProduct *skProduct;
@property (nonatomic, assign) BOOL purchaseInProgress;
@property (nonatomic, strong)NSString * icon;
@property (nonatomic, strong)AppPurchaseProductProcess * info;
@end
