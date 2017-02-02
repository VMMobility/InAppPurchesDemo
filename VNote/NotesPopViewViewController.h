//
//  NotesPopViewViewController.h
//  VNote
//
//  Created by Purushottam Kumar on 01/02/16.
//  Copyright © 2016 Vmoksha Technologies Pvt Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol popViewControllerDelegate <NSObject>
-(void)logOutAction;
-(void)homeAction;
@end

@interface NotesPopViewViewController : UIViewController
@property(strong,nonatomic)id<popViewControllerDelegate>delegate;
@end
