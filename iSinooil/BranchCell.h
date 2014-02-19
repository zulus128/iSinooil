//
//  BranchCell.h
//  iSinooil
//
//  Created by вадим on 2/8/14.
//  Copyright (c) 2014 Zul. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BranchCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *branchLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@property (weak, nonatomic) IBOutlet UIWebView *addrWebview;

@end
