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
#import "ViewController.h"
#import "SignUp.h"
#import <MBProgressHUD/MBProgressHUD.h>
#import "Notes.h"
#import "NSData+EncryptData.h"


@interface FolderViewController ()<UINavigationControllerDelegate,UIImagePickerControllerDelegate,UIActionSheetDelegate,UITextViewDelegate,UIAlertViewDelegate>
{
    NSMutableArray *tabArray;
    FolderModelData *bModel;
    NSString *folderName;
    NSString *fileName;
    NSString *notesText;
    UIImage *img1;
    FolderModelData *cModel;
    AppDelegate *app;
    NSManagedObjectContext *myContext;
    
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
@synthesize managedobject;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    app=[[UIApplication sharedApplication]delegate];
    myContext=app.managedObjectContext;
    
    
    
    self.navigationItem.title=@"Folder";
    self.navigationItem.hidesBackButton=YES;
    self.navigationController.navigationBar.titleTextAttributes=@{NSForegroundColorAttributeName: [UIColor whiteColor]};
   
    UIColor *darkColor=[UIColor colorWithRed:0.21 green:0.17 blue:0.13 alpha:1.00];
    UIColor *lightColor=[UIColor colorWithRed:0.21 green:0.23 blue:0.23 alpha:1.00];
    
    CAGradientLayer *gardient=[CAGradientLayer layer];
    gardient.colors=[NSArray arrayWithObjects:(id)darkColor.CGColor,(id)lightColor.CGColor, nil];
    gardient.frame=self.view.bounds;
    [self.view.layer insertSublayer:gardient atIndex:0];
    
    _tapToAttachFile.layer.cornerRadius=5;
    _tapToAttachFile.layer.borderWidth=1;
    
 
    _folderNameTextField.textColor=[UIColor whiteColor];
    _fileNameTextField.textColor=[UIColor whiteColor];
    _textViewField.textColor=[UIColor whiteColor];
    
    
    _textViewField.text=@"";
    _textViewField.textColor=[UIColor whiteColor];
    _textViewField.delegate=self;
    
    _textViewField.layer.cornerRadius=5;
    _textViewField.layer.borderWidth=1;
    _textViewField.layer.borderColor=([UIColor colorWithRed:0.22 green:0.59 blue:0.85 alpha:1.0].CGColor);

}

-(void)viewWillAppear:(BOOL)animated
{
    [self.view endEditing:YES];
    Notes *nt=(Notes *)self.managedobject;
    if (managedobject !=nil)
    {
        [self.managedobject valueForKey:@"foldername"];
        [self.managedobject valueForKey:@"filename"];
        [self.managedobject valueForKey:@"info"];
       
    }

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

- (IBAction)attachmentButtonAction:(UIButton *)sender
{
    
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Attach file from:"
                                                             delegate:self
                                                    cancelButtonTitle:@"Cancel"
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:@"Gallery", @"Camera", nil];
    
  
    
    [actionSheet showInView:self.view];
    [actionSheet showFromRect:[(UIButton *)sender frame] inView:self.view animated:YES];

    
}


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
    folderName=_folderNameTextField.text;
    fileName=_fileNameTextField.text;
    notesText=_textViewField.text;
    img1=_uploadImage.image;
    
    NSString *myString =folderName;
    NSString *key = @"my secret key";
    NSData *data = [myString dataUsingEncoding:NSUTF8StringEncoding];
    NSData *encryptedData = [data Encrypt:key];
    
    
    NSString *myString2=fileName;
    NSString *key2=@"my secret key";
    NSData *data2=[myString2 dataUsingEncoding:NSUTF8StringEncoding];
    NSData *encryptedData2=[data2 Encrypt:key2];
    
    
    NSString *myString3=notesText;
    NSString *key3=@"my secret key";
    NSData *data3=[myString3 dataUsingEncoding:NSUTF8StringEncoding];
    NSData *encryptedData3=[data3 Encrypt:key3];
    
    NSArray *path2 = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask,
                                                         YES);
    NSString *documentsPath = [path2 objectAtIndex:0];
    NSString *myPath = [documentsPath stringByAppendingPathComponent:@"/Notes"];
    if (![[NSFileManager defaultManager] fileExistsAtPath:myPath])
        [[NSFileManager defaultManager] createDirectoryAtPath:myPath withIntermediateDirectories:NO
                                                   attributes:nil error:NULL];
  
   
    NSString *newStr = [[NSString alloc] initWithData:encryptedData encoding:[NSString defaultCStringEncoding]];
    NSLog(@"new str:%@",newStr);
    NSLog(@"Encrypted data:%@",encryptedData);
    
    
    NSString *myString4=newStr;
    NSString *key4=@"my secret key";
//    NSData *data4=[myString4 dataUsingEncoding:NSASCIIStringEncoding];
    NSData *data4 = [myString4 dataUsingEncoding:[NSString defaultCStringEncoding]];

    NSData *decrptedData=[data4 Decrypt:key4];
    NSString *decryptFolderName = [[NSString alloc] initWithData:decrptedData encoding:NSASCIIStringEncoding];
    NSLog(@"%@",decryptFolderName);
    
    NSString *folderPath = [myPath stringByAppendingPathComponent:newStr];
    if (![[NSFileManager defaultManager] fileExistsAtPath:folderPath])
        [[NSFileManager defaultManager] createDirectoryAtPath:folderPath withIntermediateDirectories:NO
                                                   attributes:nil error:NULL];
    NSString *newStr2=[[NSString alloc] initWithData:encryptedData2 encoding:[NSString defaultCStringEncoding]];
    NSString *pathFileName = [folderPath stringByAppendingPathComponent:newStr2];
    
    
    NSString *newStr3=[[NSString alloc] initWithData:encryptedData3 encoding:[NSString defaultCStringEncoding]];
    NSString *str=newStr3;
    NSData *nsData= [str dataUsingEncoding:NSUTF8StringEncoding];
    [nsData writeToFile:pathFileName atomically:YES];
    
    NSMutableString *mutableString=[[NSMutableString alloc]init];
    BOOL goodToGo=YES;
    if (folderName.length==0)
    {
        goodToGo=NO;
        [mutableString appendString:@"Folder name is required\n"];
    }
    
    if (fileName.length==0)
    {
         goodToGo=NO;
         [mutableString appendString:@"File name is required\n"];
    }
        if(notesText.length==0)
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
                                       
                                        [self.view endEditing:YES];
                                       [self.navigationController popViewControllerAnimated:YES];
                                   }];
        
        [alertController addAction:okAction];
        [self presentViewController:alertController animated:NO completion:nil];
        [hud hide:YES];
}

    if ((!goodToGo))
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


- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    
    UIImage *chosenImage = info[UIImagePickerControllerEditedImage];
    _uploadImage.image = chosenImage;
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
}


@end
