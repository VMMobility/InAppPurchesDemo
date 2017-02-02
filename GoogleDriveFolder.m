//
//  GoogleDriveFolder.m
//  VNote
//
//  Created by vmoksha mobility on 8/17/16.
//  Copyright © 2016 Vmoksha Technologies Pvt Ltd. All rights reserved.
//

#import "GoogleDriveFolder.h"
#import "HomePage.h"
#import "GoogleDriveTableFolderTable.h"
#import "GoogleDriveFolderModel.h"
#import <GTMOAuth2ViewControllerTouch.h>
#import <GTLDrive.h>
@interface GoogleDriveFolder ()<UITableViewDataSource,UITableViewDelegate>
{
    UIImage *myImage;
    NSMutableArray *folderDriveTableArray;
    GoogleDriveFolderModel *folderDriveModel;
}
@property (weak, nonatomic) IBOutlet UITableView *myFolderTable;
@property (weak, nonatomic) IBOutlet UIToolbar *myToolBar;
@property (weak, nonatomic) IBOutlet UIView *myView;
- (IBAction)addFolderButtonAction:(id)sender;
- (IBAction)deleteFolderButtonAction:(id)sender;

@end

@implementation GoogleDriveFolder
@synthesize folderTitle=_folderTitle;
- (void)viewDidLoad {
    [super viewDidLoad];
    
    folderDriveTableArray=[[NSMutableArray alloc]init];
    [self folderDriveData];
    self.navigationController.navigationBarHidden = NO;
    self.navigationItem.title=@"GoogleDrive Folder";
    self.navigationController.navigationBar.titleTextAttributes=@{NSForegroundColorAttributeName: [UIColor whiteColor]};
    
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:0.65 green:0.11 blue:0.71 alpha:1.00];  self.navigationItem.hidesBackButton=YES;
    
    
    
    UIColor *darkColor=[UIColor colorWithRed:0.21 green:0.17 blue:0.13 alpha:1.00];
    UIColor *lightColor=[UIColor colorWithRed:0.21 green:0.23 blue:0.23 alpha:1.00];
    
    CAGradientLayer *gardient=[CAGradientLayer layer];
    gardient.colors=[NSArray arrayWithObjects:(id)darkColor.CGColor,(id)lightColor.CGColor, nil];
    gardient.frame=self.view.bounds;
    [self.view.layer insertSublayer:gardient atIndex:0];
    
    
    myImage = [UIImage imageNamed:@"logout 2"];
    UIButton *myButton1 = [UIButton buttonWithType:UIButtonTypeCustom];
    [myButton1 setImage:myImage forState:UIControlStateNormal];
    myButton1.frame = CGRectMake(10.0, 0.0,32.0, 32.0);
    [myButton1 addTarget:self action:@selector(logOutButtontapped) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc] initWithCustomView:myButton1];
    self.navigationItem.rightBarButtonItem = leftButton;
    
    self.myFolderTable.separatorColor=[UIColor clearColor];
    _myView.backgroundColor=[UIColor colorWithRed:0.65 green:0.11 blue:0.71 alpha:1.00];
    _myToolBar.barTintColor=[UIColor colorWithRed:0.65 green:0.11 blue:0.71 alpha:1.00];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

-(void)logOutButtontapped
{
      [self logoutAlert];
}
-(void)logoutAlert
{
    UIAlertController *alertController = [UIAlertController
                                          alertControllerWithTitle:@"Warning !"
                                          message:@"Do you want to logout Google drive"
                                          preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *cancelAction = [UIAlertAction
                                   actionWithTitle:NSLocalizedString(@"NO", @"No action")
                                   style:UIAlertActionStyleCancel
                                   handler:^(UIAlertAction *action)
                                   {
                                       NSLog(@"Cancel action");
                                       
                                   }];
    
    
    UIAlertAction *okAction = [UIAlertAction
                               actionWithTitle:NSLocalizedString(@"Yes", @"OK action")
                               style:UIAlertActionStyleDefault
                               handler:^(UIAlertAction *action)
                               {
                                   NSLog(@"OK action");
                                   HomePage *homePage=[[HomePage alloc] init];
                                   [self.navigationController popViewControllerAnimated:YES];

                                   
                               }];
    
    [alertController addAction:okAction];
    [alertController addAction:cancelAction];
    [self presentViewController:alertController animated:YES completion:nil];
    
}
-(void)setEditing:(BOOL)editing animated:(BOOL)animated
{
    [super setEditing:editing animated:animated];
    [_myFolderTable setEditing:editing animated:YES];
    if (editing)
    {
        //                addButton.enabled = NO;
    }
    else {
        //                addButton.enabled = YES;
    }
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        
        if ([folderDriveTableArray count]==0)
        {
            
            UIAlertController *alertController = [UIAlertController
                                                  alertControllerWithTitle:@"Warning !"
                                                  message:@"Do you want to delete this Folder"
                                                  preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction *cancelAction = [UIAlertAction
                                           actionWithTitle:NSLocalizedString(@"NO", @"No action")
                                           style:UIAlertActionStyleCancel
                                           handler:^(UIAlertAction *action)
                                           {
                                               NSLog(@"Cancel action");
                                               
                                           }];
            
            
            UIAlertAction *okAction = [UIAlertAction
                                       actionWithTitle:NSLocalizedString(@"Yes", @"OK action")
                                       style:UIAlertActionStyleDefault
                                       handler:^(UIAlertAction *action)
                                       {
                                           NSLog(@"OK action");
                                           
                                           
                                           
                                       }];
            
            [alertController addAction:okAction];
            [alertController addAction:cancelAction];
            [self presentViewController:alertController animated:YES completion:nil];
            
            
        }
        else
        {
            NSMutableString *mutableString=[[NSMutableString alloc]init];
            [mutableString appendString:@"Do you want to delete this folder\n"];
            [mutableString appendString:@"Folder have some file"];
            
            UIAlertController *alertController = [UIAlertController
                                                  alertControllerWithTitle:@"Warning !"
                                                  message:mutableString
                                                  preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction *cancelAction = [UIAlertAction
                                           actionWithTitle:NSLocalizedString(@"No", @"No action")
                                           style:UIAlertActionStyleCancel
                                           handler:^(UIAlertAction *action)
                                           {
                                               NSLog(@"Cancel action");
                                               [self.myFolderTable reloadData];
                                           }];
            
            
            UIAlertAction *okAction = [UIAlertAction
                                       actionWithTitle:NSLocalizedString(@"Yes", @"Yes action")
                                       style:UIAlertActionStyleDefault
                                       handler:^(UIAlertAction *action)
                                       {
                                           NSLog(@"Yes action");
                                           [self deleteFolderName:indexPath];
                                           
                                       }];
            
            [alertController addAction:okAction];
            [alertController addAction:cancelAction];
            [self presentViewController:alertController animated:YES completion:nil];
            
            
        }
    }
}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [folderDriveTableArray count];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    GoogleDriveTableFolderTable *cell=[tableView dequeueReusableCellWithIdentifier:@"driveFolderTableCell" forIndexPath:indexPath];
    cell.googleFolderNameLabel.text=folderDriveModel.folderName;
    
    UIView *cellBackView=[[UIView alloc]init];
    cellBackView.backgroundColor=[UIColor clearColor];
    cell.selectedBackgroundView=cellBackView;
    

    return cell;
}
-(void)folderDriveData
{
    folderDriveModel=[[GoogleDriveFolderModel alloc]init];
    folderDriveModel.folderName=@"Purushottam";
    [folderDriveTableArray addObject:folderDriveModel];
    
    
    folderDriveModel=[[GoogleDriveFolderModel alloc]init];
    folderDriveModel.folderName=@"Purushottam";
    [folderDriveTableArray addObject:folderDriveModel];
    
    folderDriveModel=[[GoogleDriveFolderModel alloc]init];
    folderDriveModel.folderName=@"Purushottam";
    [folderDriveTableArray addObject:folderDriveModel];
}

-(void)deleteFolderName:(NSIndexPath *)indexPath
{
   folderDriveModel=folderDriveTableArray[indexPath.row];
    [folderDriveTableArray removeObjectAtIndex:indexPath.row];
    [_myFolderTable endUpdates];
    [_myFolderTable reloadData];
    
}
- (IBAction)addFolderButtonAction:(id)sender
{
    [self parentFolder];
}

- (IBAction)deleteFolderButtonAction:(id)sender
{
    UIAlertController *alertController = [UIAlertController
                                          alertControllerWithTitle:@"Warning !"
                                          message:@"Sharing google drive folder features will relase in next version"
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

-(void)parentFolder
{
    
    GTLServiceDrive *serviceDrive=[[GTLServiceDrive alloc]init];
    GTLDriveFile *parentFolder=[GTLDriveFile object];
    parentFolder.name=@"Notes Folder";
    parentFolder.mimeType=@"application/vnd.google-apps.folder";
   
    
    GTLQueryDrive *queryDrive=[GTLQueryDrive queryForFilesCreateWithObject:parentFolder uploadParameters:nil];
    [serviceDrive executeQuery:queryDrive completionHandler:^(GTLServiceTicket *ticket,
                                                  GTLDriveFile *updatedFile,
                                                  NSError *error) {
        if (error == nil) {
            NSLog(@"Created folder");
        } else {
            NSLog(@"An error occurred: %@", error);
        }
    }];
    
}

@end
