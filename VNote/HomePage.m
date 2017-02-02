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
#import "HomeModelData.h"
#import <MBProgressHUD/MBProgressHUD.h>
#import <Dropbox/Dropbox.h>
#import "GoogleDriveFolder.h"
#import "NSData+EncryptData.h"
#import "GTLDrive.h"
#import "GTLQueryDrive.h"
#import <PassKit/PassKit.h>
static NSString *const kClientSecret = @"Your Project Secret Key";

@interface HomePage ()<UITableViewDelegate,UITableViewDataSource,WYPopoverControllerDelegate,popViewControllerDelegate,UIAlertViewDelegate,PKPaymentAuthorizationViewControllerDelegate>
{
    NSMutableArray *tabArray;
    FolderModelData *cModel;
    NSArray *folderAll;
    NSIndexPath *indexpath;
    UIImage *myImage1;
    WYPopoverController *popOverController;
    UIImage *myImage;
    NSMutableArray *folderNameTableArray;
    HomeModelData *hModel;
    NSMutableArray *homeTableArray;
    NSMutableArray *fileNameTableArray;
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
@property(strong,nonatomic)NSMutableArray *notes;
@property (nonatomic, retain) NSNumber *isAppAuthorized;
@end

@implementation HomePage

@synthesize service=_service;
@synthesize createAuthController=_createAuthController;
@synthesize output=_output;
@synthesize title=_title;
@synthesize folderTitle=_folderTitle;
@synthesize isAuthorized=_isAuthorized;
- (void)viewDidLoad {
    
    
    [super viewDidLoad];
    [self.view endEditing:YES];
    
 
    homeTableArray=[[NSMutableArray alloc]init];
    folderNameTableArray=[[NSMutableArray alloc]init];
    fileNameTableArray=[[NSMutableArray alloc]init];
 
    [self.myTableView1 reloadData];
    self.navigationController.navigationBarHidden = NO;
    self.navigationItem.title=@"Home";
    self.navigationController.navigationBar.titleTextAttributes=@{NSForegroundColorAttributeName: [UIColor whiteColor]};
    
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:0.65 green:0.11 blue:0.71 alpha:1.00];
    self.navigationItem.hidesBackButton=YES;
    
    

    UIColor *darkColor=[UIColor colorWithRed:0.21 green:0.17 blue:0.13 alpha:1.00];
    UIColor *lightColor=[UIColor colorWithRed:0.21 green:0.23 blue:0.23 alpha:1.00];
    
    CAGradientLayer *gardient=[CAGradientLayer layer];
    gardient.colors=[NSArray arrayWithObjects:(id)darkColor.CGColor,(id)lightColor.CGColor, nil];
    gardient.frame=self.view.bounds;
    [self.view.layer insertSublayer:gardient atIndex:0];
    
     
    
    myImage = [UIImage imageNamed:@"2016-01-06(1)"];
    UIButton *myButton1 = [UIButton buttonWithType:UIButtonTypeCustom];
    [myButton1 setImage:myImage forState:UIControlStateNormal];
    myButton1.frame = CGRectMake(10.0, 0.0,24, 24);
    [myButton1 addTarget:self action:@selector(tapped :) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc] initWithCustomView:myButton1];
    self.navigationItem.rightBarButtonItem = leftButton;
    
    
    myImage1 = [UIImage imageNamed:@"share-arrow"];
    UIButton *myButton2 = [UIButton buttonWithType:UIButtonTypeCustom];
    [myButton2 setImage:myImage1 forState:UIControlStateNormal];
    myButton2.frame = CGRectMake(10.0,0.0,80.0,24.0);
    [myButton2 addTarget:self action:@selector(tappedShareButton) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithCustomView:myButton2];

    self.navigationItem.rightBarButtonItems = [[NSArray alloc] initWithObjects:leftButton, rightButton, nil];
    _tapToCreateNote.layer.cornerRadius=5;
    _tapToCreateNote.layer.borderWidth=1;
    
    
    _tapToCreate.layer.cornerRadius=5;
    _tapToCreate.layer.borderWidth=1;
    
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

- (GTLServiceDrive *)driveService
{
    static GTLServiceDrive *service = nil;
    if (!service)
    {
        service = [[GTLServiceDrive alloc] init];
        service.shouldFetchNextPages = YES;
        service.retryEnabled=YES;
      
    }
    return service;
}


- (void)viewController:(GTMOAuth2ViewControllerTouch *)viewController
      finishedWithAuth:(GTMOAuth2Authentication *)authResult
                 error:(NSError *)error
{
     NSLog(@"%@",error);
    [self dismissViewControllerAnimated:YES completion:nil];
    if (error == nil)
    {
        [self isAuthorizedWithAuthentication:authResult];
        NSLog(@"%@",authResult);
         [self parentFolder];
         [self performSegueWithIdentifier:@"seg" sender:self];
    
    }
         self.service.authorizer=authResult;
    }
    
-(void)parentFolder
{
    GTLServiceDrive *serviceDrive=[[GTLServiceDrive alloc]init];
    GTLDriveFile *parentFolder=[GTLDriveFile object];
    parentFolder.name=hModel.folderName;
    parentFolder.mimeType=@"application/vnd.google-apps.folder";
    
    
    GTLQueryDrive *queryDrive=[GTLQueryDrive queryForFilesCreateWithObject:parentFolder uploadParameters:nil];
    [serviceDrive executeQuery:queryDrive completionHandler:^(GTLServiceTicket *ticket,
                                                              GTLDriveFile *updatedFile,
                                                              NSError *error)
    {
        if (error == nil)
        {
            NSLog(@"Created folder");
        }
        else
        {
            NSLog(@"An error occurred: %@", error);
        }
    }];
}

- (void)isAuthorizedWithAuthentication:(GTMOAuth2Authentication *)auth
{
    [[self driveService] setAuthorizer:auth];
}

-(void)viewWillDisappear:(BOOL)animated
{
 [self.view endEditing:YES];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.view endEditing:YES];
    
    [self folderNameDataFetching];
    [self showWholeInfooftable];
    [self.myTableView1 reloadData];
    
//    if ([PKPaymentAuthorizationViewController canMakePayments])
//    {
//        PKPaymentRequest *requestPayment=[[PKPaymentRequest alloc]init];
//        requestPayment.countryCode=@"US";
//        requestPayment.countryCode=@"USD";
//    requestPayment.supportedNetworks=@[@"PKPaymentNetworkMasterCard,PKPaymentNetworkVisa,PKPaymentMethodTypeDebit,PKPaymentMethodTypeCredit"];
//        requestPayment.merchantCapabilities=PKMerchantCapabilityEMV;
//        requestPayment.merchantIdentifier=@"merchant.com.VNotes";
//        
//        PKPaymentSummaryItem *item1=[PKPaymentSummaryItem summaryItemWithLabel:@"Widget 1" amount:[NSDecimalNumber decimalNumberWithString:@"0.99"]];
//        
//        PKPaymentSummaryItem *item2=[PKPaymentSummaryItem summaryItemWithLabel:@"Widget 2" amount:[NSDecimalNumber decimalNumberWithString:@"0.88"]];
//        
//         PKPaymentSummaryItem *total=[PKPaymentSummaryItem summaryItemWithLabel:@"Grand Total" amount:[NSDecimalNumber decimalNumberWithString:@"1.00"]];
//        requestPayment.paymentSummaryItems=@[item1,item2,total];
//        
//      
//        PKPaymentAuthorizationViewController *paymentPanel=[[PKPaymentAuthorizationViewController alloc] initWithPaymentRequest:requestPayment];
//        paymentPanel.delegate=self;
//        [self presentViewController:paymentPanel animated:YES completion:nil];
//    }
}
- (void)paymentAuthorizationViewController:(PKPaymentAuthorizationViewController *)controller
                       didAuthorizePayment:(PKPayment *)payment
                                completion:(void (^)(PKPaymentAuthorizationStatus status))completion
{
    NSLog(@"Payment was authorized: %@", payment);
    
    // do an async call to the server to complete the payment.
    // See PKPayment class reference for object parameters that can be passed
    BOOL asyncSuccessful = FALSE;
    
    // When the async call is done, send the callback.
    // Available cases are:
    //    PKPaymentAuthorizationStatusSuccess, // Merchant auth'd (or expects to auth) the transaction successfully.
    //    PKPaymentAuthorizationStatusFailure, // Merchant failed to auth the transaction.
    //
    //    PKPaymentAuthorizationStatusInvalidBillingPostalAddress,  // Merchant refuses service to this billing address.
    //    PKPaymentAuthorizationStatusInvalidShippingPostalAddress, // Merchant refuses service to this shipping address.
    //    PKPaymentAuthorizationStatusInvalidShippingContact        // Supplied contact information is insufficient.
    
    if(asyncSuccessful) {
        completion(PKPaymentAuthorizationStatusSuccess);
        
        // do something to let the user know the status
        
        NSLog(@"Payment was successful");
        
        //        [Crittercism endTransaction:@"checkout"];
        
    } else {
        completion(PKPaymentAuthorizationStatusFailure);
        
        // do something to let the user know the status
        
        NSLog(@"Payment was unsuccessful");
        
        //        [Crittercism failTransaction:@"checkout"];
    }
    
}

- (void)paymentAuthorizationViewControllerDidFinish:(PKPaymentAuthorizationViewController *)controller
{
    NSLog(@"Finishing payment view controller");
    
    // hide the payment window
    [controller dismissViewControllerAnimated:TRUE completion:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
   
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
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

-(void)setEditing:(BOOL)editing animated:(BOOL)animated
{
    [super setEditing:editing animated:animated];
    [_myTableView1 setEditing:editing animated:YES];
    if (editing)
    {
        
    }
    else {
     
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
        
        if ([homeTableArray count]==0)
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
                                               [self.myTableView1 reloadData];
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
}


-(void)deleteFolderName:(NSIndexPath *)indexPath
{
    hModel=homeTableArray[indexPath.row];
    [homeTableArray removeObjectAtIndex:indexPath.row];
    [_myTableView1 endUpdates];
    [_myTableView1 reloadData];
    
    NSString *str=hModel.folderName;
    NSString *key=@"my secret key";
    NSData *data = [str dataUsingEncoding:[NSString defaultCStringEncoding]];
    NSData *decpryptedData = [data Encrypt:key];
    NSString *decryptedString = [[NSString alloc] initWithData:decpryptedData encoding:[NSString defaultCStringEncoding]];
    
    NSString *path;
    NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    path=[[paths objectAtIndex:0]stringByAppendingPathComponent:@"Notes"];
    path=[path stringByAppendingPathComponent:decryptedString];
    
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

-(void)folderNameDataFetching
{
    int Count;
    NSString *path;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    path = [[paths objectAtIndex:0] stringByAppendingPathComponent:@"Notes"];
    folderNameTableArray=[[NSFileManager defaultManager] contentsOfDirectoryAtPath:path error:NULL];
    [homeTableArray removeAllObjects];
    for (Count=0;Count<(int)[folderNameTableArray count];  Count++)
    {
        NSLog(@"Folder name %d: %@",(Count +1),[folderNameTableArray objectAtIndex:Count]);
        hModel=[[HomeModelData alloc]init];
        hModel.folderName=folderNameTableArray[Count];
        NSString *myString = hModel.folderName;
        NSString *key = @"my secret key";
        NSData *data = [myString dataUsingEncoding:[NSString defaultCStringEncoding]];
        NSData *decpryptedData = [data Decrypt:key];
        NSString *decryptedString = [[NSString alloc] initWithData:decpryptedData encoding:NSASCIIStringEncoding];
        hModel.folderName=decryptedString;
        NSLog(@"Encrypted data:%@",decpryptedData);
        [homeTableArray addObject:hModel];
        
    }
    
    [self.myTableView1 reloadData];
}

-(void)tappedShareButton
{
    UIAlertController *alertController=[UIAlertController alertControllerWithTitle:@" Warning !" message:@"Do you want share your folder with Google drive" preferredStyle:UIAlertControllerStyleAlert];
    
    
    UIAlertAction *CancelAction=[UIAlertAction actionWithTitle:NSLocalizedString(@"NO", @"No action") style:UIAlertActionStyleCancel handler:^(UIAlertAction *action)
                                 {
                                     NSLog(@"No action");
                                 }];
    
    UIAlertAction *okAction=[UIAlertAction actionWithTitle:NSLocalizedString(@"YES", @"Yes action") style:UIAlertActionStyleDefault handler:^(UIAlertAction *action)
                             {
                                 NSLog(@"Yes action");
                                [self signIn];
                                }];
                             
    [alertController addAction:CancelAction];
    [alertController addAction:okAction];
    [self presentViewController:alertController animated:YES completion:nil];
    
}

-(void)signIn
{
    SEL finishedSelector = @selector(viewController:finishedWithAuth:error:);
    GTMOAuth2ViewControllerTouch *authViewController =
    [[GTMOAuth2ViewControllerTouch alloc] initWithScope:kGTLAuthScopeDriveFile
                                               clientID:kClientID
                                           clientSecret:nil
                                       keychainItemName:kKeychainItemName
                                               delegate:self
                                       finishedSelector:finishedSelector];
   
    [self presentViewController:authViewController
                       animated:YES
                     completion:nil];

}


+ (void)insertFileWithService:(GTLServiceDrive *)service
                        title:(NSString *)title
                  description:(NSString *)description
                     parentId:(NSString *)parentId
                     mimeType:(NSString *)mimeType
                         data:(NSData *)data
              completionBlock:(void (^)(GTLDriveFile *, NSError *))completionBlock

{
    
    GTLDriveFile *driveFolder=[GTLDriveFile object];
    driveFolder.name=@"Notes Folder";
    driveFolder.mimeType=@"application/vnd.google-apps.folder";
    NSString *parentID=parentId;
    
    if (parentID !=NULL)
    {
        driveFolder.parents=[NSArray arrayWithObjects:parentID, nil];
    }
    GTLUploadParameters *uploadParameters=[GTLUploadParameters uploadParametersWithData:data MIMEType:mimeType];
    GTLQueryDrive *query =
    [GTLQueryDrive queryForFilesCreateWithObject:driveFolder uploadParameters:uploadParameters];
    GTLServiceTicket *queryTicket =
    [service executeQuery:query
        completionHandler:^(GTLServiceTicket *ticket,
                            GTLDriveFile *insertedFile, NSError *error) {
            if (error == nil)
            {
                NSLog(@"File ID: %@", insertedFile.identifier);
                completionBlock(insertedFile, nil);
            }
            else
            {
                NSLog(@"An error occurred: %@", error);
                completionBlock(nil, error);
            }
        }];
}

//-(void)logOutGoogleDrive
//{
//    [GTMOAuth2ViewControllerTouch removeAuthFromKeychainForName:kKeychainItemName];
//}
//


@end
