//
//  FlashviewController.m
//  VNote
//
//  Created by vmoksha on 12/10/16.
//  Copyright © 2016 Vmoksha Technologies Pvt Ltd. All rights reserved.
//

#import "FlashviewController.h"
#import "BuyAppViewController.h"
@interface FlashviewController ()

@end

@implementation FlashviewController

- (void)viewDidLoad
{
    [super viewDidLoad];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)backBtn:(id)sender
{

    UIStoryboard * story = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    BuyAppViewController * buy = [story instantiateViewControllerWithIdentifier:@"Buy"];
    
    [[[[UIApplication sharedApplication] delegate] window] setRootViewController:buy];
    
    [self popoverPresentationController];

}
@end
