//
//  BranchesDataSource.h
//  iSinooil
//
//  Created by вадим on 2/8/14.
//  Copyright (c) 2014 Zul. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BranchCell.h"

@protocol BranchCellDelegate;

@interface BranchesDataSource : NSObject <UITableViewDataSource, BranchCellDelegate>

@property (strong, nonatomic) UITableView * tableView1;

@end
