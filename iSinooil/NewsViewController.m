//
//  NewsViewController.m
//  iSinooil
//
//  Created by вадим on 2/2/14.
//  Copyright (c) 2014 Zul. All rights reserved.
//

#import "NewsViewController.h"
#import "Common.h"
#import "NewsDataSource.h"
#import "NewsDetailViewController.h"

@implementation NewsViewController

- (void) willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    
    //    NSLog(@"will rotate news");
    
    CGSize s = [Common currentScreenBoundsDependOnOrientation:toInterfaceOrientation];
    self.topView.frame = CGRectMake(0, 0, s.width, s.height);
}



- (void)viewDidLoad {
    
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    self.newssour = [[NewsDataSource alloc] init];
    self.newsTable.dataSource = self.newssour;
    self.newsTable.delegate = self;
}

- (void)didReceiveMemoryWarning
{
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
    detailViewController.news = [[Common instance] getNewsAt:indexPath.row];
    [self.navigationController pushViewController:detailViewController animated:YES];
}

@end
