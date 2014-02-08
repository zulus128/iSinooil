//
//  SettingsCell.h
//  iSinooil
//
//  Created by вадим on 2/8/14.
//  Copyright (c) 2014 Zul. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SettingsCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *img;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *value;
@property (weak, nonatomic) IBOutlet UIImageView *arrUp;
@property (weak, nonatomic) IBOutlet UIImageView *arrDown;

@end
