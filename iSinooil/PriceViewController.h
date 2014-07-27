//
//  PriceViewController.h
//  iSinooil
//
//  Created by Admin on 21.01.14.
//  Copyright (c) 2014 Zul. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommonViewController.h"

@class PricesDataSource;

@interface PriceViewController : CommonViewController <UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UIView *topView;
- (IBAction)toMenu:(id)sender;
@property (weak, nonatomic) IBOutlet UITableView *pricesListTable;

@property (nonatomic, strong) PricesDataSource* listsour;

@end
