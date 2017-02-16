//
//  BuyAppViewController.m
//  VNote
//
//  Created by vmoksha mobility on 9/21/16.
//  Copyright © 2016 Vmoksha Technologies Pvt Ltd. All rights reserved.
//

#import "BuyAppViewController.h"
#import "AppPurchaseProductProcess.h"
#import "AppPurchaseProduct.h"
#import "AppPurchase.h"
#import "ContentViewController.h"
#import <StoreKit/StoreKit.h>
@interface BuyAppViewController ()
{
    NSNumberFormatter *priceFormatter;
    
    ContentViewController * contentVC;
}

@property (weak, nonatomic) IBOutlet UILabel *appNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *appVersionLabel;
@property (weak, nonatomic) IBOutlet UILabel *appPriceLabel;
@property (weak, nonatomic) IBOutlet UITextView *appDescriptionTextView;

@end

@implementation BuyAppViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationController.navigationBarHidden=NO;
   
    self.view.backgroundColor = [UIColor brownColor];
                                 
    priceFormatter = [[NSNumberFormatter alloc] init];
    [priceFormatter setFormatterBehavior:NSNumberFormatterBehavior10_4];
    [priceFormatter setNumberStyle:NSNumberFormatterCurrencyStyle];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)refresh
{
    self.title = _product.skProduct.localizedTitle;
    
    self.appNameLabel.text = _product.skProduct.localizedTitle;
    self.appDescriptionTextView.text =_product.skProduct.localizedDescription;
    [priceFormatter setLocale:_product.skProduct.priceLocale];
    self.appPriceLabel.text = [priceFormatter stringFromNumber:_product.skProduct.price];
    self.appVersionLabel.text = @"Version 1.0";
    
    if (_product.allowedToPurchase)
    {
        self.navigationItem.rightBarButtonItem =
        [[UIBarButtonItem alloc] initWithTitle:@"Buy" style:UIBarButtonItemStyleBordered target:self action:@selector(buyTapped:)];
        
        self.navigationItem.rightBarButtonItem.enabled = YES;
    }
    else
    {
            self.navigationItem.rightBarButtonItem = nil;
    }
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self refresh];
}

- (void)buyTapped:(id)sender
{
    NSLog(@"Buy tapped");
    
    [[AppPurchaseProduct sharedInstance] buyProduct:self.product];
}
-(void)goToContentVC
{
  
    [self performSegueWithIdentifier:@"toContentVC" sender:self];
    
}


@end
