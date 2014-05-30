//
//  BranchCell.h
//  iSinooil
//
//  Created by вадим on 2/8/14.
//  Copyright (c) 2014 Zul. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol BranchCellDelegate;

@interface BranchCell : UITableViewCell <UIWebViewDelegate>

- (void)checkHeight;

@property (weak, nonatomic) IBOutlet UILabel *branchLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@property (weak, nonatomic) IBOutlet UIWebView *addrWebview;

@property (nonatomic, assign) id <BranchCellDelegate> delegate;

@end

@protocol BranchCellDelegate <NSObject>

@optional

- (void)branchCell:(BranchCell *)cell shouldAssignHeight:(CGFloat)newHeight;

@end