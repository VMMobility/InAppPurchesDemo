//
//  ChangePasswordViewController.m
//  VNote
//
//  Created by Purushottam Kumar on 13/01/16.
//  Copyright © 2016 Vmoksha Technologies Pvt Ltd. All rights reserved.
//

#import "ChangePasswordViewController.h"
#import <QuartzCore/QuartzCore.h>


@interface ChangePasswordViewController ()
{
    UIImage *myImage;
    NSString *email;
}

@property (weak, nonatomic) IBOutlet UITextField *passwordNewOneTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordOldOneTextField;
- (IBAction)changePasswordActionButton:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UIView *mynewPasswordView;
@property (weak, nonatomic) IBOutlet UIView *myOldPasswordView;
@property (weak, nonatomic) IBOutlet UIView *myChangePasswordView;
@property (weak, nonatomic) IBOutlet UIButton *myChange;
- (IBAction)hideKeyPad:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *muChange;

@end

@implementation ChangePasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.hidesBackButton=YES;
    self.navigationItem.title=@"Password";
    
    self.navigationController.navigationBar.titleTextAttributes=@{NSForegroundColorAttributeName: [UIColor whiteColor]};
    
    
    //Gardient color use in background color
    UIColor *darkColor=[UIColor colorWithRed:0.21 green:0.17 blue:0.13 alpha:1.00];
    UIColor *lightColor=[UIColor colorWithRed:0.21 green:0.23 blue:0.23 alpha:1.00];
    
    CAGradientLayer *gardient=[CAGradientLayer layer];
    
    gardient.colors=[NSArray arrayWithObjects:(id)darkColor.CGColor,(id)lightColor.CGColor, nil];
    gardient.frame=self.view.bounds;
    [self.view.layer insertSublayer:gardient atIndex:0];
    
    _mynewPasswordView.layer.cornerRadius=5;
    _mynewPasswordView.layer.borderWidth=1;
    
    
    _myOldPasswordView.layer.cornerRadius=5;
    _myOldPasswordView.layer.borderWidth=1;
    
    _myChangePasswordView.layer.cornerRadius=5;
    _myChangePasswordView.layer.borderWidth=1;
    
    _myChange.layer.cornerRadius=5;
    _myChange.layer.borderWidth=1;
    
    _passwordOldOneTextField.hidden=YES;
    _myOldPasswordView.hidden=YES;
    
    _muChange.backgroundColor=[UIColor colorWithRed:0.65 green:0.11 blue:0.71 alpha:1.00];
    self.navigationController.navigationBarHidden = NO;
    self.navigationItem.title=@"Change Password";
    self.navigationController.navigationBar.titleTextAttributes=@{NSForegroundColorAttributeName: [UIColor whiteColor]};
    
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:0.65 green:0.11 blue:0.71 alpha:1.00];    self.navigationItem.hidesBackButton=YES;
    
    myImage = [UIImage imageNamed:@"direction196"];
    UIButton *myButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [myButton setImage:myImage forState:UIControlStateNormal];
    
    // myButton.showsTouchWhenHighlighted = YES;
    myButton.frame = CGRectMake(10.0, 0.0,24,24);
    
    [myButton addTarget:self action:@selector(tapped) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc] initWithCustomView:myButton];
    self.navigationItem.leftBarButtonItem = leftButton;
    

    

    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)changePasswordActionButton:(UIButton *)sender
{
    
    email=_passwordNewOneTextField.text;
    
    
    
    NSMutableString *mutableString=[[NSMutableString alloc]init];
    BOOL goToGo=YES;
    
    if (email.length==0)
    
    {
        goToGo=NO;
        [mutableString appendString:@"New Password is required\n"];
    }
    
    
    if ((!goToGo))
    {
        
        
        UIAlertController *alertController = [UIAlertController
                                              alertControllerWithTitle:@"Alert!"
                                              message:mutableString
                                              preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *cancelAction = [UIAlertAction
                                       actionWithTitle:NSLocalizedString(@"Cancel", @"Cancel action")
                                       style:UIAlertActionStyleCancel
                                       handler:^(UIAlertAction *action)
                                       {
                                           NSLog(@"Cancel action");
                                           
                                       }];
        
        
        UIAlertAction *okAction = [UIAlertAction
                                   actionWithTitle:NSLocalizedString(@"OK", @"OK action")
                                   style:UIAlertActionStyleDefault
                                   handler:^(UIAlertAction *action)
                                   {
                                       NSLog(@"OK action");
                                   }];
        
        [alertController addAction:okAction];
        [alertController addAction:cancelAction];
        
        
        [self presentViewController:alertController animated:YES completion:nil];
    }
    
    if (goToGo)
    {
        
        [self sendEmail:email];
        
        
        UIAlertController *alertController = [UIAlertController
                                              alertControllerWithTitle:@"Alerts"
                                              message:@"Password change using Email-id"
                                              preferredStyle:UIAlertControllerStyleAlert];
        
        
        
        UIAlertAction *okAction = [UIAlertAction
                                   actionWithTitle:NSLocalizedString(@"OK", @"OK action")
                                   style:UIAlertActionStyleDefault
                                   handler:^(UIAlertAction *action)
                                   {
                                       NSLog(@"OK action");
                                       
                                       [self.view endEditing:YES];
                                       [self.navigationController popToRootViewControllerAnimated:YES];
                                       
                                       
                                   }];
        
        
        [alertController addAction:okAction];
        
        [self presentViewController:alertController animated:YES completion:nil];

       
    }
    
    
}
- (IBAction)hideKeyPad:(id)sender
{
    [self.view endEditing:YES];
}
-(void)tapped
{
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (void)sendEmail:(NSString *)email
{
//    [PFUser requestPasswordResetForEmailInBackground:email];
}




@end
