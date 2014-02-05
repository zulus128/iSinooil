//
//  ActsViewController.m
//  iSinooil
//
//  Created by Admin on 05.02.14.
//  Copyright (c) 2014 Zul. All rights reserved.
//

#import "ActsViewController.h"
#import "Common.h"
#import "ActsDataSource.h"
#import "UIScrollView+SVInfiniteScrolling.h"
#import "NewsDetailViewController.h"

@implementation ActsViewController

- (void) willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    
    CGSize s = [Common currentScreenBoundsDependOnOrientation:toInterfaceOrientation];
    self.view.frame = CGRectMake(0, 0, s.width, s.height);
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    self.actsour = [[ActsDataSource alloc] init];
    self.actTable.dataSource = self.actsour;
    self.actTable.delegate = self;
    
    [self.actTable addInfiniteScrollingWithActionHandler:^{
        
        //        NSLog(@"end of table");
        [[Common instance] loadActsData];
        [self.actTable.infiniteScrollingView stopAnimating];
        [self.actTable reloadData];
    }];
}

- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)toMenu:(id)sender {
    
    self.view.hidden = NO;
    
    CGRect fr = self.view.frame;
    BOOL b = (fr.origin.x < 1);
    [UIView animateWithDuration:anim_delay delay:0.0 options:UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         
                         self.view.frame = CGRectMake(b?(fr.size.width - deltaX):0, fr.origin.y, fr.size.width, fr.size.height);
                         
                     }
                     completion:^(BOOL finished) {
                     }];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return NEWSCELL_HEIGHT;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NewsDetailViewController* detailViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"newsDetailController"];
    detailViewController.news = [[Common instance] getActAt:indexPath.row];
    [self.navigationController pushViewController:detailViewController animated:YES];
}



@end
