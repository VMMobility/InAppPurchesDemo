//
//  AppPurchaseProduct.h
//  VNote
//
//  Created by vmoksha mobility on 9/19/16.
//  Copyright © 2016 Vmoksha Technologies Pvt Ltd. All rights reserved.
//

#import "AppPurchase.h"

@interface AppPurchaseProduct : AppPurchase

{
    NSMutableArray *severProIdentifierArray;
    NSMutableArray *itunnesProIdentifierArray;
}

+(AppPurchaseProduct *)sharedInstance;

@end
