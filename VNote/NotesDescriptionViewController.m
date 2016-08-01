//
//  NotesDescriptionViewController.m
//  VNote
//
//  Created by Purushottam Kumar on 11/01/16.
//  Copyright © 2016 Vmoksha Technologies Pvt Ltd. All rights reserved.
//

#import "NotesDescriptionViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "AppDelegate.h"
#import "NotesDetail.h"
#import <Parse/Parse.h>
#import "NotesDescriptionModelData.h"
#import "NotesModelData.h"
#import <WYPopoverController/WYPopoverController.h>
#import "NotesDetailPopView.h"
#import "NotesDetailPopViewModelData.h"

@interface NotesDescriptionViewController ()<UITextViewDelegate,UIActionSheetDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate,WYPopoverControllerDelegate,popViewControllerDelegate>
{
    UIImage *myImage;
    AppDelegate *appDel;
    
    NSMutableArray *notesDescTableArray;
    NotesDescriptionModelData *dModel;
     WYPopoverController *popOverController;
    
    UIImagePickerController *picker;
    
    IBOutletCollection(UITapGestureRecognizer) NSArray *tap;
    IBOutlet UITapGestureRecognizer *hideKayed;
}
- (IBAction)hidekeyPad:(UITapGestureRecognizer *)sender;

@property (weak, nonatomic) IBOutlet UITextView *myNotesDescTextView;
@property (weak, nonatomic) IBOutlet UILabel *myFileNameLabel;
@property (weak, nonatomic) IBOutlet UITextView *myTextView;
@property (weak, nonatomic) IBOutlet UIImageView *myImageNotesDesc;
- (IBAction)hideKeyPad:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *shareButton;
@property (weak, nonatomic) IBOutlet UIButton *shareButtonAction;
- (IBAction)shareButtonAction:(UIButton *)sender;

@end

@implementation NotesDescriptionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    
    notesDescTableArray=[[NSMutableArray alloc]init];
    _myTextView.textColor=[UIColor whiteColor];
    _myTextView.text=@"";
    _myTextView.textColor=[UIColor whiteColor];
    _myTextView.delegate=self;
    self.myFileNameLabel.text=_descModel.fileName;
    self.myTextView.text=_descModel.fileContent;
        _shareButton.hidden=YES;
   [_descModel.imageDataa getDataInBackgroundWithBlock:^(NSData *imageData, NSError *error) {
        if (!error) {
            self.myImageNotesDesc.image  = [UIImage imageWithData:imageData];
        }
    }];

    
    
    
    
    
    
    self.navigationItem.hidesBackButton=YES;
    
    
    myImage = [UIImage imageNamed:@"direction196"];
    UIButton *myButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [myButton setImage:myImage forState:UIControlStateNormal];
    
    
    // myButton.showsTouchWhenHighlighted = YES;
    myButton.frame = CGRectMake(10.0, 0.0,24,24);
    [myButton addTarget:self action:@selector(tapped1) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc] initWithCustomView:myButton];
    self.navigationItem.leftBarButtonItem = leftButton;
    
    
    myImage = [UIImage imageNamed:@"2016-01-06(1)"];
    UIButton *myButton1 = [UIButton buttonWithType:UIButtonTypeCustom];
    [myButton1 setImage:myImage forState:UIControlStateNormal];
    
    // myButton.showsTouchWhenHighlighted = YES;
    myButton1.frame = CGRectMake(10.0, 0.0,24, 24);
    
    [myButton1 addTarget:self action:@selector(tapped :) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *leftButton1 = [[UIBarButtonItem alloc] initWithCustomView:myButton1];
    self.navigationItem.rightBarButtonItem = leftButton1;
    

    
    
    
    
    
//   UIImage *myImage2 = [UIImage imageNamed:@"refresh57 (1)"];
//    UIButton *myButton2 = [UIButton buttonWithType:UIButtonTypeCustom];
//    [myButton2 setImage:myImage2 forState:UIControlStateNormal];
//    
//    // myButton.showsTouchWhenHighlighted = YES;
//    myButton2.frame = CGRectMake(10.0, 0.0,24,24);
//    
//    [myButton2 addTarget:self action:@selector(tapped) forControlEvents:UIControlEventTouchUpInside];
//    
//    UIBarButtonItem *right = [[UIBarButtonItem alloc] initWithCustomView:myButton2];
//    self.navigationItem.rightBarButtonItem = right;
    
    self.navigationItem.title=@"Note Details";
    self.navigationController.navigationBar.titleTextAttributes=@{NSForegroundColorAttributeName: [UIColor whiteColor]};
    
    
    //Gardient color use in background color
    UIColor *darkColor=[UIColor colorWithRed:0.21 green:0.17 blue:0.13 alpha:1.00];
    UIColor *lightColor=[UIColor colorWithRed:0.21 green:0.23 blue:0.23 alpha:1.00];
    
    CAGradientLayer *gardient=[CAGradientLayer layer];
    
    gardient.colors=[NSArray arrayWithObjects:(id)darkColor.CGColor,(id)lightColor.CGColor, nil];
    gardient.frame=self.view.bounds;
    [self.view.layer insertSublayer:gardient atIndex:0];
    

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
- (IBAction)HideKeypad:(id)sender {

    [self.view endEditing:YES];

}

-(void)tapped1
{
    [self.navigationController popViewControllerAnimated:YES];;
}


-(void)tapped
{
    
    [self.view endEditing:YES];
 
    
    UIAlertController *alertController = [UIAlertController
                                          alertControllerWithTitle:@"Warning!"
                                          message:@"Do you want to update your data"
                                          preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction
                                   actionWithTitle:NSLocalizedString(@"NO", @"NO action")
                                   style:UIAlertActionStyleCancel
                                   handler:^(UIAlertAction *action)
                                   {
                                       NSLog(@"NO action");
                                       
                                   }];
    UIAlertAction *okAction = [UIAlertAction
                               actionWithTitle:NSLocalizedString(@"YES", @"YES action")
                               style:UIAlertActionStyleDefault
                               handler:^(UIAlertAction *action)
                               {
                                   NSLog(@"YES action");
                                   [self updatemethod];
                               }];
    [alertController addAction:okAction];
    [alertController addAction:cancelAction];
    [self presentViewController:alertController animated:NO completion:nil];
    
    
}


-(void)updatemethod
{
    
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    NSString *fileId=[defaults objectForKey:@"FILEOBJECTID"];
    PFQuery *query=[PFQuery queryWithClassName:@"FileData"];
    [query whereKey:@"FileName" equalTo:fileId];
    [query getObjectInBackgroundWithId:fileId
                                 block:^(PFObject *query, NSError *error) {
                                     if (!(error))
                                     {
                                         [query setObject:self.myTextView.text forKey:@"FileContent"];
                                         [query saveInBackground];
                                         
                                         
                                         UIAlertController *alertController1 = [UIAlertController
                                                                                alertControllerWithTitle:@"Successfully"
                                                                                message:@"Your data update successfully"
                                                                                preferredStyle:UIAlertControllerStyleAlert];
                                         
                                         UIAlertAction *okAction = [UIAlertAction
                                                                    actionWithTitle:NSLocalizedString(@"OK", @"OK action")
                                                                    style:UIAlertActionStyleDefault
                                                                    handler:^(UIAlertAction *action)
                                                                    {
                                                                        NSLog(@"OK action");
                                                                        
                                                                        
                                                                        [self.view endEditing:YES];
                                                                        [self.navigationController popViewControllerAnimated:YES];
                                                                    }];
                                         [alertController1 addAction:okAction];

                                         
                                         
                                         
                                         [self presentViewController:alertController1 animated:YES completion:nil];
                                         
                                     }
                                     else
                                     {
                                         NSLog(@"Error is%@",error);
                                         UIAlertController *alertController1 = [UIAlertController
                                                                                alertControllerWithTitle:@"Error"
                                                                                message:@"Your data does not update"
                                                                                preferredStyle:UIAlertControllerStyleAlert];
                                         [self presentViewController:alertController1 animated:YES completion:nil];
                                     }
                                 }];


}



- (IBAction)shareButtonAction:(UIButton *)sender
{
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Share photo with:"
                                                             delegate:self
                                                    cancelButtonTitle:@"Cancel"
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:@"Facebook", @"Email", nil];
    
    
    
    [actionSheet showInView:self.view];
    [actionSheet showFromRect:[(UIButton *)sender frame] inView:self.view animated:YES];
    

}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (picker == nil)
    {
        picker=[[UIImagePickerController alloc]init];
        picker.delegate=self;
        picker.allowsEditing=YES;
        
    }
    
    
    if (buttonIndex == 0)
        
    {
        
//        picker.sourceType=UIImagePickerControllerSourceTypePhotoLibrary;
//        [self presentViewController:picker animated:YES completion:Nil];
        
        
    }
    else if (buttonIndex == 1)
    {
//        picker.sourceType=UIImagePickerControllerSourceTypeCamera;
//        [self presentViewController:picker animated:YES completion:Nil];
    }
    else
    {
        
        //        picker.sourceType=UIImagePickerControllerSourceTypePhotoLibrary;
        //        [self presentViewController:picker animated:YES completion:Nil];
        
    }
    
    NSLog(@"Index = %ld - Title = %@", (long)buttonIndex, [actionSheet buttonTitleAtIndex:buttonIndex]);
}


-(void)tapped:(UIButton*)sender
{
    
    UIView *btn = (UIView *)sender;
    
    if (popOverController == nil)
    {
        NotesDetailPopView  *popUpVC = [self.storyboard instantiateViewControllerWithIdentifier:@"PopUpStoryBoardID1"];
        
        popUpVC.delegate = self;
        
        CGSize contentSize = CGSizeMake(200,80);
        
        popUpVC.preferredContentSize = contentSize;
        
        
        
        popOverController = [[WYPopoverController alloc] initWithContentViewController:popUpVC];
        popOverController.delegate = self;
        popOverController.passthroughViews = @[btn];
        
        
        //        popOverController.popoverLayoutMargins = UIEdgeInsetsMake(CGFloat top, <#CGFloat left#>, <#CGFloat bottom#>, <#CGFloat right#>)
        
        popOverController.popoverLayoutMargins = UIEdgeInsetsMake(0, 0, 0, 0);
        
        
        popOverController.theme = [WYPopoverTheme themeForIOS7];
        popOverController.theme.outerCornerRadius = 2;
        
        
        popOverController.theme.borderWidth = 2;
        popOverController.theme.outerStrokeColor = [UIColor lightGrayColor];
        
        //        popOverController.theme.innerStrokeColor = [UIColor redColor];
        
        
        popOverController.theme.arrowHeight = 8;
        popOverController.theme.arrowBase= 15;
        popOverController.theme.fillTopColor = [UIColor grayColor];
        popOverController.theme.overlayColor= [UIColor clearColor];
        
        CGRect biggerBounds = CGRectInset(sender.bounds, -6, -6);
        
        [popOverController presentPopoverFromRect:biggerBounds inView:sender permittedArrowDirections:(WYPopoverArrowDirectionUp) animated:YES options:(WYPopoverAnimationOptionFadeWithScale)];
        
        //        [BlurEffect blurredImageOfView:self.view onBaseView:chatSubMenuVC.view withTintColor:[UIColor whiteColor]];
    }else
    {
        [popOverController dismissPopoverAnimated:YES completion:^{
            popOverController.delegate = nil;
            popOverController = nil;
        }];
    }
}
-(BOOL)popoverControllerShouldDismissPopover:(WYPopoverController *)popoverController
{
    return YES;
}
-(void)popoverControllerDidDismissPopover:(WYPopoverController *)popoverController
{
    popOverController.delegate=nil;
    popOverController=nil;
}
-(void)homeAction
{
    [popOverController dismissPopoverAnimated:NO];

    
    NSArray *viewController=self.navigationController.viewControllers;
    UIViewController *homeObject=viewController[1];
    [self.navigationController popToViewController:homeObject animated:YES];
}
-(void)logOutAction
{
    [popOverController dismissPopoverAnimated:NO];
    [self.navigationController popToRootViewControllerAnimated:YES];
}

@end
