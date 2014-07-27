//
//  ActsViewController.h
//  iSinooil
//
//  Created by Admin on 05.02.14.
//  Copyright (c) 2014 Zul. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommonViewController.h"

@class ActsDataSource;

@interface ActsViewController : CommonViewController <UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UIView *topView;
- (IBAction)toMenu:(id)sender;
@property (weak, nonatomic) IBOutlet UITableView *actTable;

@property (nonatomic, strong) ActsDataSource* actsour;

@end
