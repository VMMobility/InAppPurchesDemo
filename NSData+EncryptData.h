//
//  NSData+EncryptData.h
//  VNote
//
//  Created by vmoksha mobility on 8/19/16.
//  Copyright © 2016 Vmoksha Technologies Pvt Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CommonCrypto/CommonCryptor.h>
@interface NSData (EncryptData)
-(NSData *)Encrypt :(NSString *)key;
-(NSData *)Decrypt :(NSString *)key;




@end
