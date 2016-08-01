//
//  PopViewController.h
//  VNote
//
//  Created by Purushottam Kumar on 12/01/16.
//  Copyright © 2016 Vmoksha Technologies Pvt Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
//Protocol declaration
@protocol popViewControllerDelegate <NSObject>

//Protocol method declaration
-(void)logOutAction;
-(void)DeleteAction;
-(void)ChangePasswordAction;
-(void)AboutUsAction;

@end



@interface PopViewController : UIViewController

@property(nonatomic,strong)id<popViewControllerDelegate>delegate;




@end
