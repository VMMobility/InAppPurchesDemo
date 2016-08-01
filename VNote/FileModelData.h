//
//  FileModelData.h
//  VNote
//
//  Created by Purushottam Kumar on 09/01/16.
//  Copyright © 2016 Vmoksha Technologies Pvt Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface FileModelData : NSObject

@property(nonatomic,strong)NSString *foldername;
@property(strong,nonatomic)NSString *titleName;
@property(strong,nonatomic)NSString *texTName;
@property(strong,nonatomic)UIImage *imageName;

@end
