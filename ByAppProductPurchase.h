//
//  ByAppProductPurchase.h
//  VNote
//
//  Created by vmoksha mobility on 9/22/16.
//  Copyright © 2016 Vmoksha Technologies Pvt Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ByAppProductPurchase : NSObject <NSCoding>

- (id)initWithProductIdentifier:(NSString *)productIdentifier consumable:(BOOL)consumable timesPurchased:(int)timesPurchased libraryRelativePath:(NSString *)libraryRelativePath contentVersion:(NSString *)contentVersion;

@property(nonatomic,strong)NSString *productIdentifier;
@property(nonatomic,assign)BOOL consumable;
@property(nonatomic,assign)int timesPurchased;
@property(nonatomic,strong)NSString *libraryRelativePath;
@property(nonatomic,strong)NSString *contentVersion;

@end
