//
//  ViewController.m
//  VNote
//
//  Created by Purushottam Kumar on 06/01/16.
//  Copyright © 2016 Vmoksha Technologies Pvt Ltd. All rights reserved.
//
@class AppPurchaseProductProcess;
#import "ViewController.h"
#import <QuartzCore/QuartzCore.h>
#import <MBProgressHUD/MBProgressHUD.h>
#import "AppPurchaseProduct.h"
#import "AppPurchase.h"
#import <StoreKit/StoreKit.h>
#import "HomeTable.h"
#import "AppPurchaseProductProcess.h"
#import "BuyAppViewController.h"

@interface ViewController ()<SKProductsRequestDelegate,SKPaymentTransactionObserver,UITableViewDataSource,UITableViewDelegate>
{
    
    NSArray * products;
    NSNumberFormatter *priceFormatter;
    
    UIRefreshControl *refreshControl;
   
}
@property (weak, nonatomic) IBOutlet UITableView *myHomeTable;


- (IBAction)appPurchaseButtonAction:(UIButton *)sender;
@property (nonatomic, strong) SKProduct * skProduct;
@property(nonatomic,strong)SKPaymentTransaction *completeTransaction;
@property (weak, nonatomic) IBOutlet UIImageView *aapImage;

@end

@implementation ViewController
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.myHomeTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    UILongPressGestureRecognizer *gesture=[[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(showPasswordButtonClick:)];
    
    
    priceFormatter=[[NSNumberFormatter alloc]init];
    [priceFormatter setFormatterBehavior:NSNumberFormatterBehavior10_4];
    [priceFormatter setNumberStyle:NSNumberFormatterCurrencyStyle];
    
    
    
    refreshControl=[[UIRefreshControl alloc]init];
    [refreshControl addTarget:self action:@selector(reload)
                  forControlEvents:UIControlEventValueChanged];
    
    [self reload];
    
//    [refreshControl beginRefreshing];
    
    
    
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
   
}


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
    self.navigationItem.title=@"In App Purchase";
    self.navigationController.navigationBar.titleTextAttributes=@{NSForegroundColorAttributeName: [UIColor whiteColor]};
    
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:0.65 green:0.11 blue:0.71 alpha:1.00];    self.navigationItem.hidesBackButton=YES;
    
}

-(void)reload
{
    
  [self.myHomeTable reloadData];
    [[AppPurchaseProduct sharedInstance]
     requestProductsWithCompletionHandler:^(BOOL success, NSArray *product)
    {
         if (success)
         {
             products=product;
             
             [self.myHomeTable reloadData];
        
         }
        
            
    }];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [products count];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    

    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"Processing data....";
    hud.labelColor=[UIColor whiteColor];
    
    static NSString *CellIdentifier = @"homeCell";
    HomeTable *cell=[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    AppPurchaseProductProcess *productss=products[indexPath.row];
    cell.appName.text=productss.skProduct.localizedTitle;
    cell.appDescription.text=productss.skProduct.localizedDescription;
    cell.appPrice.text=[priceFormatter stringFromNumber:productss.skProduct.price];
   // cell.appImage.image = [UIImage imageNamed:productss.info.icon];
    
    UIView *v = [[UIView alloc] init];
    v.backgroundColor = [UIColor clearColor];
    cell.selectedBackgroundView = v;
    
    self.myHomeTable.separatorStyle = UITableViewCellSeparatorStyleNone;
     [hud hide:YES];

    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self performSegueWithIdentifier:@"buyApp" sender:indexPath];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"buyApp"])
{
    
    BuyAppViewController *detailViewController =(BuyAppViewController *) segue.destinationViewController;
    NSIndexPath * indexPath = (NSIndexPath *)sender;
    AppPurchaseProductProcess *product = products[indexPath.row];
    detailViewController.product = product;
}
}


@end
