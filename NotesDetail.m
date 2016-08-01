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
#import <Parse/Parse.h>
#import "NotesModelData.h"
#import "FolderViewController.h"
#import <MBProgressHUD/MBProgressHUD.h>
#import <WYPopoverController/WYPopoverController.h>
#import "NotesPopViewViewController.h"
#import "NotePopTableCellTableViewCell.h"

@interface NotesDetail ()<UITableViewDataSource,UITableViewDelegate,popViewControllerDelegate>
{
    UIImage *myImage;
    NSMutableArray *tabArray;
    NSIndexPath *indexpath;
    AppDelegate *appDel;
    UIImage *image1;
    
    NSMutableArray *notesTableArray;
    NotesModelData *noteData;
     WYPopoverController *popOverController;

}
@property (weak, nonatomic) IBOutlet UIView *myLabelView;
- (IBAction)notesBackButton:(UIButton *)sender;

@property (weak, nonatomic) IBOutlet UITableView *myTableFileView;

- (IBAction)addFileButtonClick:(UIButton *)sender;

@property (weak, nonatomic) IBOutlet UILabel *folderNameLabel;
@property (weak, nonatomic) IBOutlet UIView *tapToCreateAgain;

@end

@implementation NotesDetail

- (void)viewDidLoad {
   
     [super viewDidLoad];
    
    
       

    //Gardient color use in background color
    UIColor *darkColor=[UIColor colorWithRed:0.21 green:0.17 blue:0.13 alpha:1.00];
    UIColor *lightColor=[UIColor colorWithRed:0.21 green:0.23 blue:0.23 alpha:1.00];
    
    CAGradientLayer *gardient=[CAGradientLayer layer];
    
    gardient.colors=[NSArray arrayWithObjects:(id)darkColor.CGColor,(id)lightColor.CGColor, nil];
    gardient.frame=self.view.bounds;
    [self.view.layer insertSublayer:gardient atIndex:0];
    
     //Set the corner of the view
    _myLabelView.layer.cornerRadius=5;
    _myLabelView.layer.borderWidth=1;
    
    //Set the title and color
    self.navigationItem.title=@"Notes";
    self.navigationController.navigationBar.titleTextAttributes=@{NSForegroundColorAttributeName: [UIColor whiteColor]};
    
    //Hide backBar Button
     self.navigationItem.hidesBackButton=YES;
    
    self.folderNameLabel.text = self.foldername;
    
    
    
    myImage = [UIImage imageNamed:@"direction196"];
    UIButton *myButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [myButton setImage:myImage forState:UIControlStateNormal];
    
    // myButton.showsTouchWhenHighlighted = YES;
    myButton.frame = CGRectMake(10.0, 0.0,24, 24);
    
[myButton addTarget:self action:@selector(tapped) forControlEvents:UIControlEventTouchUpInside];
    
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

-(void)viewWillDisappear:(BOOL)animated{
    [self.view endEditing:YES];
}


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //[tabArray removeAllObjects];
    
    [self.view endEditing:YES];
    notesTableArray=[[NSMutableArray alloc]init];
  
    [self callFileData];
    
    

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



//Editing table cell data
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

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        
//            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Warning !!" message:@"Do you want to delete this file" delegate:self cancelButtonTitle:@"YES" otherButtonTitles:@"NO", nil];
//            [alert show];
//       
    
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
                                           
                                       }];
        
        
        UIAlertAction *okAction = [UIAlertAction
                                   actionWithTitle:NSLocalizedString(@"YES", @"YES action")
                                   style:UIAlertActionStyleDefault
                                   handler:^(UIAlertAction *action)
                                   {
                                       NSLog(@"YES action");
                                   
                                       [self deletRowwithobjectId:indexPath];
                                       
                                       
                                      
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

-(void)callFileData
{

    PFQuery *query = [PFQuery queryWithClassName:@"FileData"];
    [query whereKey:@"Parent" equalTo:_foldername];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            NSLog(@"%@",objects);
            [self responseObject:objects];
            [_myTableFileView reloadData];
              } else {
            // Log details of the failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
        
    }];
  
  
}
-(void)responseObject:(NSArray *)objects
{
    for (NSDictionary *dict in objects)
    {
        noteData=[[NotesModelData alloc]init];
        noteData.fileName=dict[@"FileName"];
        noteData.fileContent=dict[@"FileContent"];
        noteData.imageDataa = dict[@"profilePicture"];
        noteData.folderName = dict[@"Parent"];
        PFObject *myObject1 = [objects objectAtIndex:indexpath.row];
        NSString *FileobjectId = [myObject1 objectId];
        NSLog(@"File object id is %@",FileobjectId);
        noteData.fileobjectId=FileobjectId;
        NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
        [defaults setObject:FileobjectId forKey:@"FILEOBJECTID"];
        [defaults synchronize];
        [notesTableArray addObject:noteData];
    }

//    [self.myTableFileView reloadData];

}










-(void)deletRowwithobjectId:(NSIndexPath *)indexPath
{
   
   noteData = notesTableArray[indexPath.row];
      [notesTableArray removeObjectAtIndex:indexPath.row];
    
    PFQuery *query = [PFQuery queryWithClassName:@"FileData"];
    [query whereKey:@"FileName" notEqualTo:noteData.fileobjectId];
    
    PFObject *obj = [query getObjectWithId:noteData.fileobjectId];
    NSLog(@"removeObject : %@",obj);
    [obj deleteInBackground];
    [_myTableFileView endUpdates];
    [_myTableFileView reloadData];
    
    
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

@end
