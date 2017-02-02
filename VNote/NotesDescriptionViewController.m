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
#import "NotesDescriptionModelData.h"
#import "NotesModelData.h"
#import <WYPopoverController/WYPopoverController.h>
#import "NotesDetailPopView.h"
#import "NotesDetailPopViewModelData.h"
#import "NSData+EncryptData.h"

@interface NotesDescriptionViewController ()<UITextViewDelegate,UIActionSheetDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate,WYPopoverControllerDelegate,popViewControllerDelegate>
{
    UIImage *myImage;
    UIImage *myImage1;
    AppDelegate *appDel;
    NSMutableArray *notesDescTableArray;
    NotesDescriptionModelData *notesDesc;
    WYPopoverController *popOverController;
    NSMutableArray *infoTextTableArray;
    UIImagePickerController *picker;
    NSString *infoData;
    
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
    
    
    
    [self infoTextDataFetching];
    infoTextTableArray=[[NSMutableArray alloc]init];
    notesDescTableArray=[[NSMutableArray alloc]init];
 
    
    _myTextView.textColor=[UIColor whiteColor];
    _myTextView.text=@"";
    _myTextView.textColor=[UIColor whiteColor];
    _myTextView.delegate=self;
    
    
    
    self.myFileNameLabel.text=_descModel.fileName;
    self.myTextView.text=notesDesc.infoText;
        _shareButton.hidden=NO;
    
    self.navigationItem.title=@"Note Details";
    self.navigationController.navigationBar.titleTextAttributes=@{NSForegroundColorAttributeName: [UIColor whiteColor]};
    

    self.navigationItem.hidesBackButton=YES;
    myImage = [UIImage imageNamed:@"direction196"];
    UIButton *myButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [myButton setImage:myImage forState:UIControlStateNormal];
    myButton.frame = CGRectMake(10.0, 0.0,24,24);
    [myButton addTarget:self action:@selector(tapped1) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc] initWithCustomView:myButton];
    self.navigationItem.leftBarButtonItem = leftButton;
    
    
    myImage = [UIImage imageNamed:@"2016-01-06(1)"];
    UIButton *myButton1 = [UIButton buttonWithType:UIButtonTypeCustom];
    [myButton1 setImage:myImage forState:UIControlStateNormal];
    myButton1.frame = CGRectMake(10.0, 0.0,24, 24);
    [myButton1 addTarget:self action:@selector(tapped :) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightButton1 = [[UIBarButtonItem alloc] initWithCustomView:myButton1];
    //self.navigationItem.rightBarButtonItem = rightButton1;
    
    myImage1 = [UIImage imageNamed:@"save-in-folder-button"];
    UIButton *myButton2 = [UIButton buttonWithType:UIButtonTypeCustom];
    [myButton2 setImage:myImage1 forState:UIControlStateNormal];
    myButton2.frame = CGRectMake(10.0,0.0,50.0,24.0);
    [myButton2 addTarget:self action:@selector(tapped) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithCustomView:myButton2];
    //self.navigationItem.rightBarButtonItem = rightButton;
    
    self.navigationItem.rightBarButtonItems = [[NSArray alloc] initWithObjects:rightButton1, rightButton, nil];


    
    UIColor *darkColor=[UIColor colorWithRed:0.21 green:0.17 blue:0.13 alpha:1.00];
    UIColor *lightColor=[UIColor colorWithRed:0.21 green:0.23 blue:0.23 alpha:1.00];
    CAGradientLayer *gardient=[CAGradientLayer layer];
    gardient.colors=[NSArray arrayWithObjects:(id)darkColor.CGColor,(id)lightColor.CGColor, nil];
    gardient.frame=self.view.bounds;
    [self.view.layer insertSublayer:gardient atIndex:0];
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(BOOL)canBecomeFirstResponder
{
    return NO;
}


- (IBAction)HideKeypad:(id)sender
{
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
                                          alertControllerWithTitle:@"Warning !"
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
                                   [self updateData];
                                   [self dataUpdateAlert];
                                   
                               }];
    [alertController addAction:okAction];
    [alertController addAction:cancelAction];
    [self presentViewController:alertController animated:NO completion:nil];
    
    
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
        popOverController.popoverLayoutMargins = UIEdgeInsetsMake(0, 0, 0, 0);
        popOverController.theme = [WYPopoverTheme themeForIOS7];
        popOverController.theme.outerCornerRadius = 2;
        popOverController.theme.borderWidth = 2;
        popOverController.theme.outerStrokeColor = [UIColor lightGrayColor];
        popOverController.theme.arrowHeight = 8;
        popOverController.theme.arrowBase= 15;
        popOverController.theme.fillTopColor = [UIColor grayColor];
        popOverController.theme.overlayColor= [UIColor clearColor];
        CGRect biggerBounds = CGRectInset(sender.bounds, -6, -6);
        
        [popOverController presentPopoverFromRect:biggerBounds inView:sender permittedArrowDirections:(WYPopoverArrowDirectionUp) animated:YES options:(WYPopoverAnimationOptionFadeWithScale)];
        
        
        
    }
    else
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


-(void)infoTextDataFetching
{
    NSString *folderStr=_descModel.folderName;
    NSString *key = @"my secret key";
    NSData *data = [folderStr dataUsingEncoding:[NSString defaultCStringEncoding]];
    NSData *decpryptedData = [data Encrypt:key];
    NSString *decryptedString = [[NSString alloc] initWithData:decpryptedData encoding:[NSString defaultCStringEncoding]];
    
    
    NSString *fileStr=_descModel.fileName;
    NSString *key2 = @"my secret key";
    NSData *data2 = [fileStr dataUsingEncoding:[NSString defaultCStringEncoding]];
    NSData *decpryptedData2 = [data2 Encrypt:key2];
    NSString *decryptedString2 = [[NSString alloc] initWithData:decpryptedData2 encoding:[NSString defaultCStringEncoding]];

    
    
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [[paths objectAtIndex:0] stringByAppendingPathComponent:[NSString stringWithFormat:@"Notes/%@/%@",decryptedString,decryptedString2]];
    
    NSString *text = [NSString stringWithContentsOfFile:documentsDirectory encoding:NSUTF8StringEncoding error:nil];
    notesDesc=[[NotesDescriptionModelData alloc]init];
    NSString *str=text;
    NSString *key3=@"my secret key";
    NSData *data3=[str dataUsingEncoding:[NSString defaultCStringEncoding]];
    NSData *decryptedData3=[data3 Decrypt:key3];
    NSString *decryptedString3 = [[NSString alloc] initWithData:decryptedData3 encoding:[NSString defaultCStringEncoding]];
    notesDesc.infoText=decryptedString3;
    NSLog(@"Decrypted text:%@",decryptedString3);
    [notesDescTableArray addObject:notesDesc];

}

-(void)updateData
{
    NSString *folderStr1=_descModel.folderName;
    NSString *key1 = @"my secret key";
    NSData *data1= [folderStr1 dataUsingEncoding:[NSString defaultCStringEncoding]];
    NSData *encryptedDataFolder = [data1 Encrypt:key1];
    NSString *encryptedStringFolder = [[NSString alloc] initWithData:encryptedDataFolder encoding:[NSString defaultCStringEncoding]];
    

    NSString *fileStr1=_descModel.fileName;
    NSString *key4 = @"my secret key";
    NSData *data4= [fileStr1 dataUsingEncoding:[NSString defaultCStringEncoding]];
    NSData *encryptedDataFile = [data4 Encrypt:key4];
    NSString *encryptedStringFile = [[NSString alloc] initWithData:encryptedDataFile encoding:[NSString defaultCStringEncoding]];
    
    infoData=_myTextView.text;
    NSString *textStr1=infoData;
    NSString *key5 = @"my secret key";
    NSData *data5= [textStr1 dataUsingEncoding:[NSString defaultCStringEncoding]];
    NSData *encryptedDataText = [data5 Encrypt:key5];
    NSString *encryptedStringText = [[NSString alloc] initWithData:encryptedDataText encoding:[NSString defaultCStringEncoding]];
    
    
    
    NSArray *path2 = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask,
                                                         YES);
    NSString *documentsDirectory = [[path2 objectAtIndex:0]stringByAppendingPathComponent:[NSString stringWithFormat:@"Notes/%@/%@",encryptedStringFolder,encryptedStringFile]];
    NSString *str=encryptedStringText;
    NSData *nsData= [str dataUsingEncoding:NSUTF8StringEncoding];
    [nsData writeToFile:documentsDirectory atomically:YES];
    
}
-(void)dataUpdateAlert
{
   
    UIAlertView *successAlert=[[UIAlertView alloc] initWithTitle:@"Successfully" message:@"Your data update sucessfully" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    
    [successAlert show];
}

-(void)dataUpdateErrorAlert
{
    UIAlertView *errorAlert=[[UIAlertView alloc] initWithTitle:@"Error !" message:@"Your data does not update" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    
    [errorAlert show];
    
}

-(void)dataUpdationError
{
    UIAlertView *erorAlerts=[[UIAlertView alloc]initWithTitle:@"Error" message:@"Error occour during your data update" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [erorAlerts show];
}

@end
