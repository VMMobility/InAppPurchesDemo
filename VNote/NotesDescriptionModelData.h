//
//  NotesDescriptionModelData.h
//  VNote
//
//  Created by Purushottam Kumar on 19/01/16.
//  Copyright © 2016 Vmoksha Technologies Pvt Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface NotesDescriptionModelData : NSObject
@property(strong,nonatomic)NSString *fileName;
@property(strong,nonatomic)NSString *fileContent;
@property(strong,nonatomic)UIImage *imageName;
@property(strong,nonatomic)NSString *folderName;
@property(strong,nonatomic)NSString *infoText;
@end
