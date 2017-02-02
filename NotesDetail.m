//
//  NotesDetail.m
//  VNote
//
//  Created by Purushottam Kumar on 08/01/16.
//  Copyright © 2016 Vmoksha Technologies Pvt Ltd. All rights reserved.
//

#import "NotesDetail.h"
#import <QuartzCore/QuartzCore.h>
#import "FolderModelData.h"
#import "HomePage.h"
#import "FileModelData.h"
#import "AppDelegate.h"
#import "NoteTableViewCell.h"
#import "FileViewController.h"
#import "NotesDescriptionViewController.h"
#import "NotesModelData.h"
#import "FolderViewController.h"
#import <MBProgressHUD/MBProgressHUD.h>
#import <WYPopoverController/WYPopoverController.h>
#import "NotesPopViewViewController.h"
#import "NotePopTableCellTableViewCell.h"
#import "Notes.h"
#import "NSData+EncryptData.h"

@interface NotesDetail ()<UITableViewDataSource,UITableViewDelegate,popViewControllerDelegate,WYPopoverControllerDelegate>
{
    UIImage *myImage;
    NSMutableArray *tabArray;
    NSIndexPath *indexpath;
    AppDelegate *appDel;
    UIImage *image1;
    
    NSMutableArray *notesTableArray;
    NotesModelData *noteData;
     WYPopoverController *popOverController;
    NSMutableArray *fileNameTableArray;
    

}
@property (weak, nonatomic) IBOutlet UIView *myLabelView;
- (IBAction)notesBackButton:(UIButton *)sender;

@property (weak, nonatomic) IBOutlet UITableView *myTableFileView;

- (IBAction)addFileButtonClick:(UIButton *)sender;

@property (weak, nonatomic) IBOutlet UILabel *folderNameLabel;
@property (weak, nonatomic) IBOutlet UIView *tapToCreateAgain;
@property(strong,nonatomic)NSMutableArray *notes;
@end

@implementation NotesDetail

- (void)viewDidLoad
{
   [super viewDidLoad];
 
    UIColor *darkColor=[UIColor colorWithRed:0.21 green:0.17 blue:0.13 alpha:1.00];
    UIColor *lightColor=[UIColor colorWithRed:0.21 green:0.23 blue:0.23 alpha:1.00];
    
    CAGradientLayer *gardient=[CAGradientLayer layer];
    gardient.colors=[NSArray arrayWithObjects:(id)darkColor.CGColor,(id)lightColor.CGColor, nil];
    gardient.frame=self.view.bounds;
    [self.view.layer insertSublayer:gardient atIndex:0];
    
    
    _myLabelView.layer.cornerRadius=5;
    _myLabelView.layer.borderWidth=1;
    
   
    self.navigationItem.title=@"Notes";
    self.navigationController.navigationBar.titleTextAttributes=@{NSForegroundColorAttributeName: [UIColor whiteColor]};
    
    self.navigationItem.hidesBackButton=YES;
    self.folderNameLabel.text = self.foldername;
    
    myImage = [UIImage imageNamed:@"direction196"];
    UIButton *myButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [myButton setImage:myImage forState:UIControlStateNormal];
    
    
    myButton.frame = CGRectMake(10.0, 0.0,24, 24);
    [myButton addTarget:self action:@selector(tapped) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc] initWithCustomView:myButton];
    self.navigationItem.leftBarButtonItem = leftButton;
    
    myImage = [UIImage imageNamed:@"2016-01-06(1)"];
    UIButton *myButton1 = [UIButton buttonWithType:UIButtonTypeCustom];
    [myButton1 setImage:myImage forState:UIControlStateNormal];
     myButton1.frame = CGRectMake(10.0, 0.0,24, 24);
    [myButton1 addTarget:self action:@selector(tapped :) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftButton1 = [[UIBarButtonItem alloc] initWithCustomView:myButton1];
    self.navigationItem.rightBarButtonItem = leftButton1;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [self.view endEditing:YES];
}


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.view endEditing:YES];
    fileNameTableArray=[[NSMutableArray alloc]init];
    notesTableArray=[[NSMutableArray alloc]init];
    [self fileNameDataFetching];
    [self.myTableFileView reloadData];
}

- (IBAction)notesBackButton:(UIButton *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)tapped
{
    [self.navigationController popViewControllerAnimated:YES];

}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([notesTableArray count]==0)
    {
        self.myTableFileView.hidden=YES;
        
    }
    else
    {
        
        self.myTableFileView.hidden=NO;
        self.tapToCreateAgain.hidden=YES;
        self.tapToCreateAgain.hidden=YES;
    }

    return[notesTableArray count];
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"Processing data....";
    hud.labelColor=[UIColor whiteColor];
   
    noteData = notesTableArray[indexPath.row];
    NoteTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"not" forIndexPath:indexPath];
    cell.fileNameLabel.text = noteData.fileName;
  
    
    [hud hide:YES];
    UIView *v = [[UIView alloc] init];
    v.backgroundColor = [UIColor clearColor];
    cell.selectedBackgroundView = v;
    

     return cell;
}

-(void)setEditing:(BOOL)editing animated:(BOOL)animated
{
    [super setEditing:editing animated:animated];
    [_myTableFileView setEditing:editing animated:YES];
    if (editing)
    {
//                addButton.enabled = NO;
    }
    else {
//                addButton.enabled = YES;
    }
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}


- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
     
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        
        UIAlertController *alertController = [UIAlertController
                                              alertControllerWithTitle:@"Warning!"
                                              message:@"Do you want to delete this file"
                                              preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *cancelAction = [UIAlertAction
                                       actionWithTitle:NSLocalizedString(@"NO", @"NO action")
                                       style:UIAlertActionStyleCancel
                                       handler:^(UIAlertAction *action)
                                       {
                                           NSLog(@"NO action");
                                           [self.myTableFileView reloadData];
                                       }];
        
        
        UIAlertAction *okAction = [UIAlertAction
                                   actionWithTitle:NSLocalizedString(@"YES", @"YES action")
                                   style:UIAlertActionStyleDefault
                                   handler:^(UIAlertAction *action)
                                   {
                                       NSLog(@"YES action");
                                       [self deleteFileName:indexPath];
                                    }];
        
        [alertController addAction:okAction];
        [alertController addAction:cancelAction];
        [self presentViewController:alertController animated:YES completion:nil];
        
       }
        else
        {
      
        }
    }

- (IBAction)addFileButtonClick:(UIButton *)sender
{
    [self performSegueWithIdentifier:@"file" sender:indexpath];
}


-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"notesDesc"])
    {
        
        indexpath=sender;
        noteData=notesTableArray[indexpath.row];
        NotesDescriptionViewController *notesDesc=segue.destinationViewController;
        notesDesc.descModel = notesTableArray[indexpath.row];

    }

if ([segue.identifier isEqualToString:@"file"])
{
    FileViewController *file = segue.destinationViewController;
    file.currentFoldername = self.foldername;

}
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self performSegueWithIdentifier:@"notesDesc" sender:indexPath];
}

-(void)tapped:(UIButton*)sender
{
    
    UIView *btn = (UIView *)sender;
    
    if (popOverController == nil)
    {
        NotesPopViewViewController  *popUpVC = [self.storyboard instantiateViewControllerWithIdentifier:@"notesPop"];
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


-(void)logOutAction
{
    [popOverController dismissPopoverAnimated:NO];
    [self.navigationController popToRootViewControllerAnimated:YES];
}

-(void)homeAction
{
    [popOverController dismissPopoverAnimated:NO];
    NSArray *viewController=self.navigationController.viewControllers;
    UIViewController *homeController=viewController[1];
    [self.navigationController popToViewController:homeController animated:YES];
}

-(void)deleteFileName:(NSIndexPath *)indexPath
{
    noteData=[notesTableArray objectAtIndex:indexPath.row];
    [notesTableArray removeObjectAtIndex:indexPath.row];
    [_myTableFileView endUpdates];
    [_myTableFileView reloadData];
    
    
    NSString *strFolder=noteData.folderName;
    NSString *keyFolder=@"my secret key";
    NSData *dataFolder = [strFolder dataUsingEncoding:[NSString defaultCStringEncoding]];
    NSData *encpryptedDataFolder = [dataFolder Encrypt:keyFolder];
    NSString *encryptedStringFolder = [[NSString alloc] initWithData:encpryptedDataFolder encoding:[NSString defaultCStringEncoding]];
    
    
    NSString *strFile=noteData.fileName;
    NSString *keyFile=@"my secret key";
    NSData *dataFile = [strFile dataUsingEncoding:[NSString defaultCStringEncoding]];
    NSData *encpryptedDataFile = [dataFile Encrypt:keyFile];
    NSString *encryptedStringFile = [[NSString alloc] initWithData:encpryptedDataFile encoding:[NSString defaultCStringEncoding]];
    


    
    NSString *path;
    NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    path=[[paths objectAtIndex:0]stringByAppendingPathComponent:@"Notes"];
    path=[path stringByAppendingPathComponent:encryptedStringFolder];
    path=[path stringByAppendingPathComponent:encryptedStringFile];
    NSFileManager *fileManager=[NSFileManager defaultManager];
    NSError *error;
    if ([[NSFileManager defaultManager] fileExistsAtPath:path])
    {
        if (![[NSFileManager defaultManager] removeItemAtPath:path error:&error])
        {
            NSLog(@"Delete file error: %@", error);
        }
    }

    
}


-(void)fileNameDataFetching
{
    NSString *myStr =self.foldername;
    NSString *key = @"my secret key";
    NSData *data = [myStr dataUsingEncoding:[NSString defaultCStringEncoding]];
    NSData *decpryptedData = [data Encrypt:key];
    NSString *decryptedString = [[NSString alloc] initWithData:decpryptedData encoding:[NSString defaultCStringEncoding]];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [[paths objectAtIndex:0]stringByAppendingPathComponent:[NSString stringWithFormat:@"Notes/%@", decryptedString]];
    
    fileNameTableArray=[[NSFileManager defaultManager] contentsOfDirectoryAtPath:documentsDirectory  error:nil];
   
    for (int Count=0; Count<(int)[fileNameTableArray count]; Count++)
    {
        NSLog(@"File name %d: %@",(Count+1), [fileNameTableArray objectAtIndex:Count]);
        
        noteData=[[NotesModelData alloc]init];
        noteData.folderName = self.foldername;
        noteData.fileName=fileNameTableArray[Count];
        
        NSString *myString =noteData.fileName;
        NSString *key = @"my secret key";
        NSData *data = [myString dataUsingEncoding:[NSString defaultCStringEncoding]];
        NSData *decpryptedData = [data Decrypt:key];
        NSString *decryptedString = [[NSString alloc] initWithData:decpryptedData encoding:NSASCIIStringEncoding];
        noteData.fileName=decryptedString;
        NSLog(@"Encrypted data:%@",decpryptedData);
        [notesTableArray addObject:noteData];
        
    }
    [self.myTableFileView reloadData];
}

@end
