//
//  HomePage.h
//  VNote
//
//  Created by Purushottam Kumar on 06/01/16.
//  Copyright © 2016 Vmoksha Technologies Pvt Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FolderModelData.h"
#import <GTMOAuth2ViewControllerTouch.h>
#import <GTLDrive.h>

static NSString *const kKeychainItemName = @"Drive API";
static NSString *const kClientID = @"299366871113-dr8rs3nr9lmrbvrji8lnj222ejck0900.apps.googleusercontent.com";

@interface HomePage : UIViewController
@property(strong,nonatomic)FolderModelData *cModel;
@property(strong,nonatomic)GTLServiceDrive *service;
@property(strong,nonatomic)UITextView *output;
@property(strong,nonatomic)GTMOAuth2ViewControllerTouch *createAuthController;
@property(strong,nonatomic)GTLDriveFile *title;
@property BOOL isAuthorized;
@property(strong,nonatomic)NSString *folderTitle;
@end
