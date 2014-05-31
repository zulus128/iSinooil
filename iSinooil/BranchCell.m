//
//  BranchCell.m
//  iSinooil
//
//  Created by вадим on 2/8/14.
//  Copyright (c) 2014 Zul. All rights reserved.
//
//http://stackoverflow.com/questions/6632596/find-uiwebview-height-dynamically-when-inside-uitableviewcell

#import "BranchCell.h"

@implementation BranchCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        
//        self.addrWebview.delegate = self;
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)webViewDidFinishLoad:(UIWebView *)aWebView {
    
    CGRect frame = aWebView.frame;
    frame.size.height = 1;
    aWebView.frame = frame;
    CGSize fittingSize = [aWebView sizeThatFits:CGSizeZero];
    frame.size = fittingSize;
    aWebView.frame = frame;
    
//    NSLog(@"webview frame size %f",aWebView.frame.size.height);
    
    [self checkHeight];
}

- (void)checkHeight {
    
    if([self.delegate respondsToSelector:@selector(branchCell:shouldAssignHeight:)]) {
       
        [self.delegate branchCell:self shouldAssignHeight:self.addrWebview.frame.size.height];
    }
}

@end
