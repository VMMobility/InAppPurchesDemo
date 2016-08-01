//
//  ViewController.m
//  VNote
//
//  Created by Purushottam Kumar on 06/01/16.
//  Copyright © 2016 Vmoksha Technologies Pvt Ltd. All rights reserved.
//

#import "ViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "SignUp.h"
#import <Parse/Parse.h>
#import <MBProgressHUD/MBProgressHUD.h>
@interface ViewController ()
{
    NSString *userNmae;
    NSString *pasword;
    __weak IBOutlet UIButton *showPassword;
}
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UITextField *userNameTextField;
- (IBAction)loginButtonAction:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;
- (IBAction)hideKeyPad:(UIControl *)sender;

- (IBAction)forgetPasswordButtonAction:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UIView *usernameView;
@property (weak, nonatomic) IBOutlet UIView *passwordView;
@property (weak, nonatomic) IBOutlet UIButton *muLogin;


@end

@implementation ViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    
    UILongPressGestureRecognizer *gesture=[[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(showPasswordButtonClick:)];
    [showPassword addGestureRecognizer:gesture];
    
//    _userNameTextField.text=nil;
//    _passwordTextField.text=nil;
//    
    
//    //Inside text field image set programatically
//    UIImage *image1=[UIImage imageNamed:@"envelope32"];
//    UIImageView *imgView=[[UIImageView alloc]initWithImage:image1];
//    self.userNameTextField.leftView=imgView;
//    imgView.frame=CGRectMake(0, 2, 15, 15);
//    self.userNameTextField.leftViewMode= UITextFieldViewModeAlways;
//    
//    UIImage *image2=[UIImage imageNamed:@"key21"];
//    UIImageView *imgView2=[[UIImageView alloc]initWithImage:image2];
//    imgView2.frame=CGRectMake(0, 2, 15, 15);
//    self.passwordTextField.leftView = imgView2;
//    self.passwordTextField.leftViewMode = UITextFieldViewModeAlways;

    
    //Gardient color use in background color
    UIColor *darkColor=[UIColor colorWithRed:0.21 green:0.17 blue:0.13 alpha:1.00];
    UIColor *lightColor=[UIColor colorWithRed:0.21 green:0.23 blue:0.23 alpha:1.00];
    
    CAGradientLayer *gardient=[CAGradientLayer layer];
    
    gardient.colors=[NSArray arrayWithObjects:(id)darkColor.CGColor,(id)lightColor.CGColor, nil];
    gardient.frame=self.view.bounds;
    [self.view.layer insertSublayer:gardient atIndex:0];
    
    
    //Text field corner setting
    _usernameView.layer.cornerRadius=5;
    _usernameView.layer.borderWidth=1;
    
    _passwordView.layer.cornerRadius=5;
    _passwordView.layer.borderWidth=1;
    
    _loginButton.layer.cornerRadius=5;
    _loginButton.layer.borderWidth=1;
    
    
    _muLogin.backgroundColor=[UIColor colorWithRed:0.65 green:0.11 blue:0.71 alpha:1.00];
    _muLogin.layer.cornerRadius=5;
    _muLogin.layer.borderWidth=1;
    
     }

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
   
}


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
    
    
    //Clear the text field when returning from other view controller
   self.userNameTextField.text=@"";
   self.passwordTextField.text=@"";

}




//Sign up button action
- (IBAction)signUpButtonAction:(UIButton *)sender
{
    [self performSegueWithIdentifier:@"signup" sender:self];
}

//Login button action
- (IBAction)loginButtonAction:(UIButton *)sender
{
    [self.view endEditing:YES];
    userNmae=_userNameTextField.text;
    pasword=_passwordTextField.text;
    
    

    
    NSMutableString *mutableString=[[NSMutableString alloc]init];
    BOOL gotoGo=YES;
    if (userNmae.length==0)
    {
        gotoGo=NO;
        [mutableString appendString:@"Username is required\n"];
    }
    
    if (pasword.length==0)
    {
        gotoGo=NO;
        [mutableString appendString:@"Password is required"];
    }
    

    if (gotoGo)
    {
        
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.labelText = @"Authentication....";
        hud.labelColor=[UIColor whiteColor];

        
        
        
        
        [PFUser logInWithUsernameInBackground:userNmae password:pasword
    block:^(PFUser *user, NSError *error) {
        if (user)
        {
            NSString *LoginObjectId=user.objectId;
            NSLog(@"%@",LoginObjectId);
            
           
            
            
            NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
            [defaults setObject:LoginObjectId forKey:@"LOGINOBJECTID"];
            [defaults synchronize];
            
            
            
            [hud hide:YES];
             [self performSegueWithIdentifier:@"homePAge" sender:self];
        } else
        {
           
            
            [hud hide:YES];
            
            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Authentication Failed" message:@"Invalid Username or Password" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alert show];
        }
    }];
        
       
    }
    
    
    if ((!gotoGo))
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
    
}

//Keypad hide
- (IBAction)endEditing:(id)sender {
    [self.view endEditing:YES];
}


- (void)showPasswordButtonClick:(UIButton *)sender
{
    if (self.passwordTextField.secureTextEntry == YES) {
        
        self.passwordTextField.secureTextEntry = NO;
        
    }
    
    else
    {
        self.passwordTextField.secureTextEntry = YES;
    }
    
    
}

- (IBAction)forgetPasswordButtonAction:(UIButton *)sender
{
    [self performSegueWithIdentifier:@"forget" sender:self];
}


@end
