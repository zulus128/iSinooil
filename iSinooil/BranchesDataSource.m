//
//  BranchesDataSource.m
//  iSinooil
//
//  Created by вадим on 2/8/14.
//  Copyright (c) 2014 Zul. All rights reserved.
//

#import "BranchesDataSource.h"
#import "Common.h"
#import "BranchCell.h"

@implementation BranchesDataSource

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    int c = [[Common instance] getBranchesCount];
    //    NSLog(@"-news count = %d", c);
    return c;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    static NSString *CellIdentifier = @"branchCell";
    BranchCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    NSDictionary* branch = [[Common instance] getBranchAt:indexPath.row];
    
    cell.branchLabel.font = FONT_BRANCH_TITLE;
    cell.nameLabel.font = FONT_BRANCH_TITLE;
    cell.nameLabel.text = [branch valueForKey:ABOUT_TTL];
//    cell.addrLabel.font = FONT_BRANCH_ADDR;
//    cell.addrLabel.text = [branch valueForKey:ABOUT_TXT];
    
    NSString *myHTML = [NSString stringWithFormat:@"<html> \n"
                        "<head> \n"
                        "<style type=\"text/css\"> \n"
                        "body {font-family: \"%@\"; font-size: %@; line-height:1.0;}\n"
                        "</style> \n"
                        "</head> \n"
                        "<body>%@</body> \n"
                        "</html>", @"HelveticaNeueCyr-Light", [NSNumber numberWithInt:14], [branch valueForKey:ABOUT_TXT]];
    
    [cell.addrWebview loadHTMLString:myHTML baseURL:nil];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    return cell;
}


@end
