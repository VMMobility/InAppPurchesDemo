//
//  SignUp.m
//  VNote
//
//  Created by Purushottam Kumar on 06/01/16.
//  Copyright © 2016 Vmoksha Technologies Pvt Ltd. All rights reserved.
//

#import "SignUp.h"
#import <QuartzCore/QuartzCore.h>



@interface SignUp ()<UIAlertViewDelegate>
{
    NSString *firstName;
    NSString *lastName;
    NSString *userName;
    NSString *email;
    NSString *password;
}
- (IBAction)alreadyHaveAccountButtonAction:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UITextField *firstNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *lastNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *userNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
- (IBAction)signUpButtonAction:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UIButton *signUpButton;
@property (weak, nonatomic) IBOutlet UIView *firstName;
@property (weak, nonatomic) IBOutlet UIView *lastName;
@property (weak, nonatomic) IBOutlet UIView *userName;
@property (weak, nonatomic) IBOutlet UIView *emailText;
@property (weak, nonatomic) IBOutlet UIView *password;
@property (weak, nonatomic) IBOutlet UIButton *signUp;
@property (weak, nonatomic) IBOutlet UIButton *mySignup;

@end

@implementation SignUp

- (void)viewDidLoad {
    [super viewDidLoad];
   
   
  
    
    
    UIColor *darkColor=[UIColor colorWithRed:0.21 green:0.17 blue:0.13 alpha:1.00];
    UIColor *lightColor=[UIColor colorWithRed:0.21 green:0.23 blue:0.23 alpha:1.00];
    
    CAGradientLayer *gardient=[CAGradientLayer layer];
    
    gardient.colors=[NSArray arrayWithObjects:(id)darkColor.CGColor,(id)lightColor.CGColor, nil];
    gardient.frame=self.view.bounds;
    [self.view.layer insertSublayer:gardient atIndex:0];

    
    _firstName.layer.cornerRadius=5;
    _firstName.layer.borderWidth=1;
    
    
    _lastName.layer.cornerRadius=5;
    _lastName.layer.borderWidth=1;
    
    _userName.layer.cornerRadius=5;
    _userName.layer.borderWidth=1;
    
    _emailText.layer.cornerRadius=5;
    _emailText.layer.borderWidth=1;
    
    _password.layer.cornerRadius=5;
    _password.layer.borderWidth=1;

    _signUp.layer.cornerRadius=5;
    _signUp.layer.borderWidth=1;

   _mySignup.backgroundColor=[UIColor colorWithRed:0.65 green:0.11 blue:0.71 alpha:1.00];
    _mySignup.layer.cornerRadius=5;
    _mySignup.layer.borderWidth=1;

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

- (IBAction)alreadyHaveAccountButtonAction:(UIButton *)sender
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}
- (IBAction)signUpButtonAction:(UIButton *)sender
{
    

   [self myMethod];

    
    NSMutableString *mutableString=[[NSMutableString alloc]init];
    BOOL goToGo=YES;
    if (firstName.length==0)
    {
        goToGo=NO;
        [mutableString appendString:@"First name is required\n"];
    }
    if (lastName.length==0)
    {
        goToGo=NO;
        [mutableString appendString:@"Last name is required\n"];
    }
    if (userName.length==0)
    {
        goToGo=NO;
        [mutableString appendString:@"Username is required\n"];
    }
    
    else if (![self NSStringIsValidUserName:userName])
    {
        goToGo=NO;
        [mutableString appendString:@"Invalid username\n"];
    }
    if (email.length==0)
    {
        goToGo=NO;
        [mutableString appendString:@"Email is required\n"];
    }
    else if (![self NSStringIsValidEmail:email])
    {
        goToGo=NO;
        [mutableString appendString:@"Invalid EmailID\n"];
    }

    if (password.length==0)
    {
        goToGo=NO;
        [mutableString appendString:@"Password is required"];
    }
    else if (password.length<5)
    {
        goToGo=NO;
        [mutableString appendString:@"Password should be  min 5 character\n"];
    }

    if ((!goToGo))
    {
        
        
        UIAlertController *alertController = [UIAlertController
                                              alertControllerWithTitle:@"Alert!"
                                              message:mutableString
                                              preferredStyle:UIAlertControllerStyleAlert];
              
        
        UIAlertAction *okAction = [UIAlertAction
                                   actionWithTitle:NSLocalizedString(@"OK", @"OK action")
                                   style:UIAlertActionStyleDefault
                                   handler:^(UIAlertAction *action)
                                   {
                                       NSLog(@"OK action");
                                   }];
        
        [alertController addAction:okAction];
      
        
        
        [self presentViewController:alertController animated:YES completion:nil];
        
    }
    if (goToGo)
    {
        
        [self myMethod];
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Successfully !!" message:@"You have sign up successfully" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    }

       
    }



- (IBAction)hideKeypad:(id)sender
{
    [self.view endEditing:YES];
}
- (void)myMethod {
    
    firstName=_firstNameTextField.text;
    lastName=_lastNameTextField.text;
    userName=_userNameTextField.text;
    email=_emailTextField.text;
    password=_passwordTextField.text;
  
        
   
//    PFUser *signUp=[PFUser user];
//    signUp.username=userName;
//    signUp.password=password;
//    signUp.email = email;
//
//    signUp[@"FirstNmae"]=firstName;
//    signUp[@"LastName"]=lastName;
//   
//
    
    
    // other fields can be set just like with PFObject
    
//    [signUp signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
//        if (!error)
//        {
//            // Hooray! Let them use the app now.
//        }
//        else
//        {   NSString *errorString = [error userInfo][@"error"];
//            // Show the errorString somewhere and let the user try again.
//        }
//    }];
//



}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 0:
            [self.navigationController popViewControllerAnimated:YES];
            
            break;
            
        default:
            break;
    }
}


-(BOOL) NSStringIsValidEmail:(NSString *)checkString
{
    BOOL stricterFilter = NO;
    NSString *stricterFilterString = @"^[A-Z0-9a-z\\._%+-]+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2,4}$";
    NSString *laxString = @"^.+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2}[A-Za-z]*$";
    NSString *emailRegex = stricterFilter ? stricterFilterString : laxString;
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:checkString];
}


-(BOOL)NSStringIsValidUserName:(NSString *)checkUserName
{
    NSString *username1 = @"[a-zA-Z0-9]*$";
    NSPredicate *predicate= [NSPredicate predicateWithFormat:@"SELF MATCHES %@", username1];
    BOOL isValid = [predicate evaluateWithObject:checkUserName];
    return isValid;
}

-(BOOL)NSStringIsValidPassword:(NSString *)checkPassword
{
    
    NSString *password1 = @"^\w*(?=\w*\d)(?=\w*[A-Z])(?=\w*[a-z])(?=\w*[@#$%^&+=])\w*$";
    NSPredicate *predicate= [NSPredicate predicateWithFormat:@"SELF MATCHES %@", password1];
    BOOL isValid = [predicate evaluateWithObject:checkPassword];
    return isValid;
}








@end
