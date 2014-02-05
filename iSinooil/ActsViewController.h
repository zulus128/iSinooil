//
//  ActsViewController.h
//  iSinooil
//
//  Created by Admin on 05.02.14.
//  Copyright (c) 2014 Zul. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ActsDataSource;

@interface ActsViewController : UIViewController <UITableViewDelegate>

- (IBAction)toMenu:(id)sender;
@property (weak, nonatomic) IBOutlet UITableView *actTable;

@property (nonatomic, strong) ActsDataSource* actsour;

@end
