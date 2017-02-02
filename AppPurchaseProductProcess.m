//
//  AppPurchaseProductProcess.m
//  VNote
//
//  Created by vmoksha mobility on 9/20/16.
//  Copyright © 2016 Vmoksha Technologies Pvt Ltd. All rights reserved.
//

#import "AppPurchaseProductProcess.h"

@implementation AppPurchaseProductProcess

-(id)initWithProductIdentifier:(NSString *)productIdentifier
{
    if ((self=[super init]))
    {
        self.isAvilableForPurchase=YES;
        self.productIdentifier=productIdentifier;
        self.skProduct=nil;
    }
    return self;
}

- (BOOL)allowedToPurchase
{
    if (!self.isAvilableForPurchase)
        return NO;
    if (self.purchaseInProgress)
        return NO;
        return YES;
}
@end
