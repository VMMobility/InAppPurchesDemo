//
//  FolderViewController.m
//  VNote
//
//  Created by Purushottam Kumar on 07/01/16.
//  Copyright © 2016 Vmoksha Technologies Pvt Ltd. All rights reserved.
//

#import "FolderViewController.h"
#import "FolderModelData.h"
#import "HomePage.h"
#import <QuartzCore/QuartzCore.h>
#import "AppDelegate.h"
#import <Parse/Parse.h>
#import "ViewController.h"
#import "SignUp.h"
#import <MBProgressHUD/MBProgressHUD.h>


@interface FolderViewController ()<UINavigationControllerDelegate,UIImagePickerControllerDelegate,UIActionSheetDelegate,UITextViewDelegate,UIAlertViewDelegate>
{
    NSMutableArray *tabArray;
    FolderModelData *bModel;
    NSString *folder1;
    NSString *title1;
    NSString *text1;
    UIImage *img1;
    FolderModelData *cModel;
    
   
    
}
- (IBAction)attachmentButtonAction:(UIButton *)sender;
- (IBAction)homeBackButtonAction:(UIButton *)sender;
- (IBAction)hideKeyPad:(id)sender;


@property (weak, nonatomic) IBOutlet UIView *folder;
@property (weak, nonatomic) IBOutlet UIView *titleView;
@property (weak, nonatomic) IBOutlet UIView *textView;
- (IBAction)folderRightBarButtonAction:(UIBarButtonItem *)sender;
@property (weak, nonatomic) IBOutlet UIView *tapToAttachFile;
- (IBAction)saveFolderButoonAction:(UIButton *)sender;


@property (weak, nonatomic) IBOutlet UITextField *folderNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *fileNameTextField;
@property (weak, nonatomic) IBOutlet UITextView *textViewField;
@property (weak, nonatomic) IBOutlet UILabel *placeholderNameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *uploadImage;

@end

@implementation FolderViewController
{
    UIImagePickerController *picker;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    
    self.navigationItem.title=@"Folder";
    self.navigationItem.hidesBackButton=YES;
    self.navigationController.navigationBar.titleTextAttributes=@{NSForegroundColorAttributeName: [UIColor whiteColor]};
   
    //Gardient color use in background color

    UIColor *darkColor=[UIColor colorWithRed:0.21 green:0.17 blue:0.13 alpha:1.00];
    UIColor *lightColor=[UIColor colorWithRed:0.21 green:0.23 blue:0.23 alpha:1.00];
    
    CAGradientLayer *gardient=[CAGradientLayer layer];
    
    gardient.colors=[NSArray arrayWithObjects:(id)darkColor.CGColor,(id)lightColor.CGColor, nil];
    gardient.frame=self.view.bounds;
    [self.view.layer insertSublayer:gardient atIndex:0];
    
    
    //Set view corner
    _tapToAttachFile.layer.cornerRadius=5;
    _tapToAttachFile.layer.borderWidth=1;
    
    //Change the text field value color
    _folderNameTextField.textColor=[UIColor whiteColor];
    _fileNameTextField.textColor=[UIColor whiteColor];
    _textViewField.textColor=[UIColor whiteColor];
    
    
    _textViewField.text=@"";
    _textViewField.textColor=[UIColor whiteColor];
    _textViewField.delegate=self;
    
    _textViewField.layer.cornerRadius=5;
    _textViewField.layer.borderWidth=1;
    _textViewField.layer.borderColor=([UIColor colorWithRed:0.22 green:0.59 blue:0.85 alpha:1.0].CGColor);
//    
//    AppDelegate *appDel = [UIApplication sharedApplication].delegate;
//           tabArray=[[NSMutableArray alloc]init];
//        [tabArray addObjectsFromArray: appDel.allNotes];
    
//    _folder.layer.cornerRadius=5;
//    _folder.layer.borderWidth=1;
    
    
//    _textView.layer.cornerRadius=5;
//    _textView.layer.borderWidth=1;
    
//    _titleView.layer.cornerRadius=5;
//    _titleView.layer.borderWidth=1;

    // Do any additional setup after loading the view.
}
-(void)viewWillDisappear:(BOOL)animated
{
      [self.view endEditing:YES];
    [_folderNameTextField resignFirstResponder];
    [_fileNameTextField resignFirstResponder];
    [_textViewField resignFirstResponder];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)textViewDidBeginEditing:(UITextView *)textView
{
   

    
            self.placeholderNameLabel.hidden=YES;
    
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text

{
    NSString *strText=self.textViewField.text;
    
    self.placeholderNameLabel.hidden=YES;
       
    if (strText.length==0)
    {
        
        
        self.placeholderNameLabel.hidden=NO;
        [textView addSubview:_placeholderNameLabel];
        

        
    }

    
        
    
    

    return YES;
}




/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


//Attachment of image from camera gallery
- (IBAction)attachmentButtonAction:(UIButton *)sender
{
//    UIImagePickerController *picker=[[UIImagePickerController alloc]init];
//    picker.delegate=self;
//    picker.allowsEditing=YES;
//    picker.sourceType=UIImagePickerControllerSourceTypePhotoLibrary;
//    [self presentViewController:picker animated:YES completion:Nil];
//    
    
    
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Attach file from:"
                                                             delegate:self
                                                    cancelButtonTitle:@"Cancel"
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:@"Gallery", @"Camera", nil];
    
  
    
    [actionSheet showInView:self.view];
    [actionSheet showFromRect:[(UIButton *)sender frame] inView:self.view animated:YES];

    
}

//Perform custom back button
- (IBAction)homeBackButtonAction:(UIButton *)sender
{
    [self.navigationController popViewControllerAnimated:YES];

}

- (IBAction)hideKeyPad:(id)sender
{
    [self.view endEditing:YES];
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
        
            picker.sourceType=UIImagePickerControllerSourceTypePhotoLibrary;
            [self presentViewController:picker animated:YES completion:Nil];
            

    }
    else if (buttonIndex == 1)
    {
        picker.sourceType=UIImagePickerControllerSourceTypeCamera;
        [self presentViewController:picker animated:YES completion:Nil];
    }
    else
    {
        
//        picker.sourceType=UIImagePickerControllerSourceTypePhotoLibrary;
//        [self presentViewController:picker animated:YES completion:Nil];
       
    }
    
    NSLog(@"Index = %ld - Title = %@", (long)buttonIndex, [actionSheet buttonTitleAtIndex:buttonIndex]);
}



    
- (IBAction)folderRightBarButtonAction:(UIBarButtonItem *)sender
{
    
}
- (IBAction)saveFolderButoonAction:(UIButton *)sender
{
    
    
    folder1=_folderNameTextField.text;
    title1=_fileNameTextField.text;
    text1=_textViewField.text;
    img1=_uploadImage.image;
    
    
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    NSString *LoginObjectId=[defaults objectForKey:@"LOGINOBJECTID"];
    [defaults synchronize];
    
    
    
    
    //Saving data on Parse for folder
    PFObject *folderData=[PFObject objectWithClassName:@"FolderData"];
    folderData[@"FolderName"]=folder1;
    folderData[@"CreatedBy"]=LoginObjectId;
   
    
    
    
    
    
    NSUserDefaults *defaults1=[NSUserDefaults standardUserDefaults];
    NSString *LoginObjectId1=[defaults1 objectForKey:@"LOGINOBJECTID"];
    [defaults1 synchronize];
   
    PFObject *fileData=[PFObject objectWithClassName:@"FileData"];
    fileData[@"Parent"]=folder1;
    fileData[@"FileName"]=title1;
    fileData[@"FileContent"]=text1;
    fileData[@"CreatedBy"]=LoginObjectId1;
   // fileData[@"FileImage"]=img1;
    [fileData saveInBackground];
    
 
   if (img1)
    {
        NSData *imageData=UIImagePNGRepresentation(img1);
        PFFile *imageFile = [PFFile fileWithName:@"img.png" data:imageData];
        [imageFile saveInBackground];
        [fileData setObject:imageFile forKey:@"profilePicture"];
        [fileData saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error)
        {
            
        if (!error)
        {
            //[fileData saveInBackground];
           
        }

        }];
    
    
    }
    
    
    
    
    NSMutableString *mutableString=[[NSMutableString alloc]init];
    BOOL goodToGo=YES;
    if (folder1.length==0)
    {
        goodToGo=NO;
        [mutableString appendString:@"Folder name is required\n"];
    }
    
    if (title1.length==0)
    {
         goodToGo=NO;
         [mutableString appendString:@"File name is required\n"];
    }
        if(text1.length==0)
    {
         goodToGo=NO;
         [mutableString appendString:@"Enter the text"];
    }
    
    
    if (goodToGo)
    {
        
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.labelText = @"Saving data....";
        hud.labelColor=[UIColor whiteColor];

    
        
        UIAlertController *alertController = [UIAlertController
                                              alertControllerWithTitle:@"Successfully"
                                              message:@"Your data have save successfully"
                                              preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okAction = [UIAlertAction
                                   actionWithTitle:NSLocalizedString(@"OK", @"OK action")
                                   style:UIAlertActionStyleDefault
                                   handler:^(UIAlertAction *action)
                                   {
                                       NSLog(@"OK action");
                                       
                                       [folderData saveInBackground];
                                       [fileData saveInBackground];
                                       

                                       [self.view endEditing:YES];
                                       [self.navigationController popViewControllerAnimated:YES];
                                   }];
        [alertController addAction:okAction];
        
        [self presentViewController:alertController animated:NO completion:nil];
        

        
        
        
        
        
       
//        [photoData saveInBackground];
        
//    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Successfully !!" message:@"Your data have save successfully" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
//        [alert show];
        
    [hud hide:YES];
        
    }

    if ((!goodToGo))
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


- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    UIImage *chosenImage = info[UIImagePickerControllerEditedImage];
    _uploadImage.image = chosenImage;
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
}


//-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
//{
//    switch (buttonIndex) {
//        case 0:
//            [self.view endEditing:YES];
//            [self.navigationController popViewControllerAnimated:YES];
//
//            break;
//            
//        default:
//            break;
//    }
//}


@end
