//
//  ForgetPasswordViewController.m
//  VNote
//
//  Created by Purushottam Kumar on 19/01/16.
//  Copyright © 2016 Vmoksha Technologies Pvt Ltd. All rights reserved.
//

#import "ForgetPasswordViewController.h"
#import <QuartzCore/QuartzCore.h>

@interface ForgetPasswordViewController ()<UITextFieldDelegate,UIAlertViewDelegate>
{
    UIImage *myImage;
    NSString *email;
}
@property (weak, nonatomic) IBOutlet UIView *myView;
@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (weak, nonatomic) IBOutlet UIButton *passwordButton;
- (IBAction)sentPasswordButtonAction:(UIButton *)sender;
- (IBAction)hideKaypad:(UITapGestureRecognizer *)sender;
@property (weak, nonatomic) IBOutlet UIButton *myPassword;
- (IBAction)hideKeypad:(id)sender;

@end

@implementation ForgetPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _myView.layer.cornerRadius=5;
    _myView.layer.borderWidth=1;
    
    _emailTextField.layer.cornerRadius=5;
    
    myImage = [UIImage imageNamed:@"direction196"];
    UIButton *myButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [myButton setImage:myImage forState:UIControlStateNormal];
    
    // myButton.showsTouchWhenHighlighted = YES;
    myButton.frame = CGRectMake(10.0, 0.0,24,24);
    
    [myButton addTarget:self action:@selector(tapped) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc] initWithCustomView:myButton];
    self.navigationItem.leftBarButtonItem = leftButton;

    
    //Gardient color use in background color
    
    UIColor *darkColor=[UIColor colorWithRed:0.21 green:0.17 blue:0.13 alpha:1.00];
    UIColor *lightColor=[UIColor colorWithRed:0.21 green:0.23 blue:0.23 alpha:1.00];
    
    CAGradientLayer *gardient=[CAGradientLayer layer];
    
    gardient.colors=[NSArray arrayWithObjects:(id)darkColor.CGColor,(id)lightColor.CGColor, nil];
    gardient.frame=self.view.bounds;
    [self.view.layer insertSublayer:gardient atIndex:0];
    
    self.navigationController.navigationBarHidden = NO;
    self.navigationItem.title=@"Forget Password";
    self.navigationController.navigationBar.titleTextAttributes=@{NSForegroundColorAttributeName: [UIColor whiteColor]};
    
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:0.65 green:0.11 blue:0.71 alpha:1.00];    self.navigationItem.hidesBackButton=YES;
    
    
    _passwordButton.layer.cornerRadius=5;
    _passwordButton.layer.borderWidth=1;
    
    
    _passwordButton.backgroundColor=[UIColor colorWithRed:0.65 green:0.11 blue:0.71 alpha:1.00];
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
-(void)tapped
{
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (IBAction)sentPasswordButtonAction:(UIButton *)sender
{
    
    email=_emailTextField.text;
    
    
    
    
    
    NSMutableString *mutableString=[[NSMutableString alloc]init];
    BOOL goToGo=YES;
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
    if (goToGo)
    {

       [self getEmail];
        
        
        
        
        
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



- (void)getEmail
{


UIAlertController *alertControllerSed = [UIAlertController
                                          alertControllerWithTitle:@"Alert!"
                                          message:@"Password sent to your register Email-id"
                                          preferredStyle:UIAlertControllerStyleAlert];
    
    
    
    
    UIAlertAction *okAction = [UIAlertAction
                               actionWithTitle:NSLocalizedString(@"OK", @"OK action")
                               style:UIAlertActionStyleDefault
                               handler:^(UIAlertAction *action)
                               {
                                   NSLog(@"OK action");
                                   
                                   [self sendEmail:email];
                                   [self okButtonAction];
                                   [self.view endEditing:YES];
                               }];
    
    [alertControllerSed addAction:okAction];
    
    
    
    [self presentViewController:alertControllerSed animated:YES completion:nil];
    
}

-(void)okButtonAction
{

    [self.navigationController popViewControllerAnimated:YES];
    
    
}




- (void)sendEmail:(NSString *)email
{
    
    
//    [PFUser requestPasswordResetForEmailInBackground:email];
}

- (IBAction)hideKeypad:(id)sender
{
    [self.view endEditing:YES];
}
@end
