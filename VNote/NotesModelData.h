//
//  NotesModelData.h
//  VNote
//
//  Created by Purushottam Kumar on 18/01/16.
//  Copyright © 2016 Vmoksha Technologies Pvt Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


@interface NotesModelData : NSObject
@property(strong,nonatomic)NSString *fileName;
@property(strong,nonatomic)NSString *fileContent;
@property(strong,nonatomic)UIImage *imageName;
@property(strong,nonatomic)NSString *folderName;
@property(strong,nonatomic)NSString *fileobjectId;
@property(strong,nonatomic)NSString *infoText;

@property(strong,nonatomic)NSData *imagedata;





@end
