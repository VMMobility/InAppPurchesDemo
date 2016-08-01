//
//  HomePage.m
//  VNote
//
//  Created by Purushottam Kumar on 06/01/16.
//  Copyright © 2016 Vmoksha Technologies Pvt Ltd. All rights reserved.
//

#import "HomePage.h"
#import <QuartzCore/QuartzCore.h>
#import "FolderViewController.h"
#import "FolderModelData.h"
#import "HomePageTableViewCell.h"
#import "AppDelegate.h"
#import "NotesDetail.h"
#import <WYPopoverController/WYPopoverController.h>
#import "PopViewController.h"
#import <Parse/Parse.h>
#import "HomeModelData.h"
#import <MBProgressHUD/MBProgressHUD.h>


@interface HomePage ()<UITableViewDelegate,UITableViewDataSource,WYPopoverControllerDelegate,popViewControllerDelegate,UIAlertViewDelegate>
{
    NSMutableArray *tabArray;
    FolderModelData *cModel;
    NSArray *folderAll;
    NSIndexPath *indexpath;
    WYPopoverController *popOverController;
    UIImage *myImage;
    
    
    HomeModelData *hModel;
    NSMutableArray *homeTableArray;
    
   
    
}
@property (weak, nonatomic) IBOutlet UITableView *myTableView;

- (IBAction)addNoteButtonAction:(UIButton *)sender;

@property (weak, nonatomic) IBOutlet UIView *tapToCreateNote;
- (IBAction)rightBarButtonAction:(UIBarButtonItem *)sender;
@property (weak, nonatomic) IBOutlet UITableView *myTableView1;
@property (weak, nonatomic) IBOutlet UILabel *tapToCreate;

@property (weak, nonatomic) IBOutlet UIImageView *noteImage;
@property (weak, nonatomic) IBOutlet UILabel *itsAllAboutNotesLabel;
@property (weak, nonatomic) IBOutlet UIView *tapToCreateView;
- (IBAction)wypPopViewAction:(UIBarButtonItem *)sender;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *popButton;

@end

@implementation HomePage



- (void)viewDidLoad {
    
    
    [super viewDidLoad];
    [self.view endEditing:YES];
    tabArray=[[NSMutableArray alloc]init];
   
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"Processing data....";
    hud.labelColor=[UIColor whiteColor];

   
   
    // Do any additional setup after loading the view.
    
    //Navigation hide,title,title color,hide navigation back button
    self.navigationController.navigationBarHidden = NO;
    self.navigationItem.title=@"Home";
    self.navigationController.navigationBar.titleTextAttributes=@{NSForegroundColorAttributeName: [UIColor whiteColor]};
    
   self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:0.65 green:0.11 blue:0.71 alpha:1.00];    self.navigationItem.hidesBackButton=YES;
    
    
    //Gardient color use in background color
    UIColor *darkColor=[UIColor colorWithRed:0.21 green:0.17 blue:0.13 alpha:1.00];
    UIColor *lightColor=[UIColor colorWithRed:0.21 green:0.23 blue:0.23 alpha:1.00];
    
    CAGradientLayer *gardient=[CAGradientLayer layer];
    
    gardient.colors=[NSArray arrayWithObjects:(id)darkColor.CGColor,(id)lightColor.CGColor, nil];
    gardient.frame=self.view.bounds;
    [self.view.layer insertSublayer:gardient atIndex:0];
    
     
    
    myImage = [UIImage imageNamed:@"2016-01-06(1)"];
    UIButton *myButton1 = [UIButton buttonWithType:UIButtonTypeCustom];
    [myButton1 setImage:myImage forState:UIControlStateNormal];
    
    // myButton.showsTouchWhenHighlighted = YES;
    myButton1.frame = CGRectMake(10.0, 0.0,24, 24);
    
    [myButton1 addTarget:self action:@selector(tapped :) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc] initWithCustomView:myButton1];
    self.navigationItem.rightBarButtonItem = leftButton;


    //Set the label corner
    _tapToCreateNote.layer.cornerRadius=5;
    _tapToCreateNote.layer.borderWidth=1;
    
    
    _tapToCreate.layer.cornerRadius=5;
    _tapToCreate.layer.borderWidth=1;
}
-(void)viewWillDisappear:(BOOL)animated{
 [self.view endEditing:YES];
}





- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.view endEditing:YES];
    
    
    homeTableArray=[[NSMutableArray alloc]init];
    [_myTableView1 reloadData];
    
    
    [self showWholeInfooftable];
    
  
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
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    return 1;

}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
//    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//    hud.labelText = @"Processing data....";
//    hud.labelColor=[UIColor whiteColor];

    
    if ([homeTableArray count]==0)
    {
        
        self.myTableView1.hidden=YES;
        
        
    }
    else
    {
        
        
       
        self.myTableView1.hidden=NO;
        self.tapToCreate.hidden=YES;
        self.noteImage.hidden=YES;
        self.itsAllAboutNotesLabel.hidden=YES;
        self.tapToCreateView.hidden=YES;
    }
    

    return [homeTableArray count];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{


    HomePageTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"hometabelcell" forIndexPath:indexPath];
    hModel=[homeTableArray objectAtIndex:indexPath.row];
    cell.nameLabel.text=hModel.folderName;
    
    
   
    
    UIView *v = [[UIView alloc] init];
    v.backgroundColor = [UIColor clearColor];
    cell.selectedBackgroundView = v;
    
    return cell;
}




-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

    [self performSegueWithIdentifier:@"note" sender:indexPath];
}
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"note"])
    {
        indexpath=sender;
        hModel = homeTableArray[indexpath.row];
        NotesDetail *nt=segue.destinationViewController;
        nt.foldername = hModel.folderName;
    }
}

//Editing table cell data
-(void)setEditing:(BOOL)editing animated:(BOOL)animated
{
    [super setEditing:editing animated:animated];
    [_myTableView1 setEditing:editing animated:YES];
    if (editing)
    {
      
    } else {
//        addButton.enabled = YES;
    }
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        
    
        if ([homeTableArray count]==0)
        {
           
            UIAlertController *alertController = [UIAlertController
                                                  alertControllerWithTitle:@"Warning !!"
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
//            [mutableString appendString:@"Warning\n"];
            [mutableString appendString:@"Do you want to delete this folder\n"];
            [mutableString appendString:@"Folder have some file"];
            
            UIAlertController *alertController = [UIAlertController
                                                  alertControllerWithTitle:@"Warning!"
                                                  message:mutableString
                                                  preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction *cancelAction = [UIAlertAction
                                           actionWithTitle:NSLocalizedString(@"No", @"No action")
                                           style:UIAlertActionStyleCancel
                                           handler:^(UIAlertAction *action)
                                           {
                                               NSLog(@"Cancel action");
                                               
                                           }];
            
            
            UIAlertAction *okAction = [UIAlertAction
                                       actionWithTitle:NSLocalizedString(@"Yes", @"Yes action")
                                       style:UIAlertActionStyleDefault
                                       handler:^(UIAlertAction *action)
                                       {
                                           NSLog(@"Yes action");
                                           
                                        [self deleteFolderName:indexPath];
                                           
//                                        [self performSegueWithIdentifier:@"note" sender:indexpath];
                                          // [self gotoNoteController];
                                           
                                       }];
            
            [alertController addAction:okAction];
            [alertController addAction:cancelAction];
            
            
            [self presentViewController:alertController animated:YES completion:nil];
            
    
        }
    }
}




- (IBAction)addNoteButtonAction:(UIButton *)sender
{
    [self performSegueWithIdentifier:@"Add" sender:self];
}

- (IBAction)rightBarButtonAction:(UIBarButtonItem *)sender
{
    
}

-(void)tapped:(UIButton*)sender
{
    
    UIView *btn = (UIView *)sender;
    
    if (popOverController == nil)
    {
        PopViewController  *popUpVC = [self.storyboard instantiateViewControllerWithIdentifier:@"PopUpStoryBoardID"];
       
        popUpVC.delegate = self;
        
        CGSize contentSize = CGSizeMake(200,130);
        
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


-(void)ChangePasswordAction
{
     [popOverController dismissPopoverAnimated:NO];
     [self performSegueWithIdentifier:@"changePassword" sender:self];
}
-(void)AboutUsAction
{
     [popOverController dismissPopoverAnimated:NO];
    [self performSegueWithIdentifier:@"aboutUs" sender:self];

}


-(void)showWholeInfooftable
{

    [self.view endEditing:YES];
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
   NSString *currentUser =  [defaults objectForKey:@"LOGINOBJECTID"];
    [defaults synchronize];

    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"Processing data....";
    hud.labelColor=[UIColor whiteColor];
    
   // [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    PFQuery *query = [PFQuery queryWithClassName:@"FolderData"];
    [query whereKey:@"CreatedBy" equalTo:currentUser];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            [self responseObject:objects];
               [self.myTableView1 reloadData];
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        }
        else {
            // Log details of the failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
          [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        }
    }];




}
-(void)responseObject:(NSArray *)objects
{
    for (NSDictionary *dic in objects)
    {
        hModel=[[HomeModelData alloc]init];
        hModel.folderName=dic[@"FolderName"];
        hModel.fileName=dic[@"FileName"];
        [homeTableArray addObject:hModel];
//        [self.myTableView1 reloadData];
        
        
        PFObject *myObject = [objects objectAtIndex:indexpath.row];
        NSString *FolderObjectId = [myObject objectId];
        NSLog(@"File object id is %@",FolderObjectId);
        
        hModel.FolderObjectId=FolderObjectId;
        
            }
    
    

    }



-(void)deleteFolderName:(NSIndexPath *)indexPath
{
    hModel=homeTableArray[indexPath.row];
    [homeTableArray removeObjectAtIndex:indexPath.row];
    
    PFQuery *query = [PFQuery queryWithClassName:@"FolderData"];
    [query whereKey:@"FolderName" notEqualTo:hModel.FolderObjectId];
    
    PFObject *obj = [query getObjectWithId:hModel.FolderObjectId];
    NSLog(@"removeObject : %@",obj);
    [obj deleteInBackground];
    
    [_myTableView1 endUpdates];
    [_myTableView1 reloadData];
    

    
}
@end
