//
//  BranchesDataSource.m
//  iSinooil
//
//  Created by вадим on 2/8/14.
//  Copyright (c) 2014 Zul. All rights reserved.
//

#import "BranchesDataSource.h"
#import "Common.h"
//#import "BranchCell.h"

@implementation BranchesDataSource

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    self.tableView1 = tableView;
    
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
    cell.branchLabel.text = NSLocalizedString(@"Branch", nil);

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
    
    cell.delegate = self; // <-- add this
    cell.addrWebview.delegate = cell;
    [cell.addrWebview loadHTMLString:myHTML baseURL:nil];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
//    [cell AssignWebView:[ListOfQuestions objectAtIndex:indexPath.row]];
//
//    NSLog(@"indexPath = %ld", (long)indexPath.row);

//    if([[[Common instance].didReloadRowsBools objectForKey:[NSString stringWithFormat:@"%ld",(long)indexPath.row]] boolValue] != YES) {
//
//    [cell checkHeight];
//    
//    }
    return cell;
}

- (void) branchCell:(BranchCell *)cell shouldAssignHeight:(CGFloat)newHeight {
    
//    NSLog(@"newH = %f", newHeight);
//    NSLog(@"Class of Cell: %@", NSStringFromClass(cell.class));
    
//    NSIndexPath *indexPath = [self.tableView1 indexPathForCell:cell];
    newHeight += 50.0f;
    
    CGPoint pos = [cell convertPoint:CGPointZero toView:self.tableView1];
    NSIndexPath *indexPath = [self.tableView1 indexPathForRowAtPoint:pos];
//    NSIndexPath *indexPath = [self.tableView1 cellForRowAtIndexPath:indexPath1];
    
//    NSLog(@"indexPath = %ld", (long)indexPath.row);
//    NSLog(@"indexPath = %@", indexPath);
  
    
    if([[[Common instance].didReloadRowsBools objectForKey:[NSString stringWithFormat:@"%ld",(long)indexPath.row]] boolValue] == YES) {
        
        return;
    }

    
    [[Common instance].cellHeights setObject:[NSNumber numberWithFloat:newHeight] forKey:[NSString stringWithFormat:@"%ld",(long)indexPath.row]];
    [[Common instance].didReloadRowsBools setObject:[NSNumber numberWithBool:YES] forKey:[NSString stringWithFormat:@"%ld",(long)indexPath.row]];

    [self.tableView1 beginUpdates];
    [self.tableView1 reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    [self.tableView1 endUpdates];
    
//    [self.tableView1 reloadData];
}

@end
