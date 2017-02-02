//
//  HomeTable.h
//  VNote
//
//  Created by vmoksha mobility on 9/21/16.
//  Copyright © 2016 Vmoksha Technologies Pvt Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HomeTable : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *appImage;
@property (weak, nonatomic) IBOutlet UILabel *appName;
@property (weak, nonatomic) IBOutlet UILabel *appDescription;
@property (weak, nonatomic) IBOutlet UILabel *appPrice;

@end
