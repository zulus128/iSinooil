//
//  PriceViewController.m
//  iSinooil
//
//  Created by Admin on 21.01.14.
//  Copyright (c) 2014 Zul. All rights reserved.
//

#import "PriceViewController.h"
#import "Common.h"
#import "PricesDataSource.h"
#import "MenuViewController.h"
#import "PriceCell.h"

@implementation PriceViewController

- (void) willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    
    //    NSLog(@"will rotate price");
    
    CGSize s = [Common currentScreenBoundsDependOnOrientation:toInterfaceOrientation];
    self.topView.frame = CGRectMake(0, 0, s.width, s.height);
}

- (void) refresh {
    
    UILabel* labelPrices = (UILabel*)[self.topView viewWithTag:TITLELABEL_TAG];
    labelPrices.font = FONT_STD_TOP_MENU;
    labelPrices.text = NSLocalizedString(@"Prices", nil);
    
    [self.pricesListTable reloadData];
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
//    [Common instance].pricecontr = self;

    self.listsour = [[PricesDataSource alloc] init];
    self.pricesListTable.dataSource = self.listsour;
    self.pricesListTable.delegate = self;

//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^(void) {
//        
//        dispatch_semaphore_wait([Common instance].allowSemaphore, DISPATCH_TIME_FOREVER);
//        
//        NSLog(@"go2");
//        [self.pricesListTable reloadData];
//
//    });
    
    [self refresh];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)toMenu:(id)sender {

//    self.view.hidden = NO;
//    
//    CGRect fr = self.view.frame;
//    BOOL b = (fr.origin.x < 1);
//    [UIView animateWithDuration:anim_delay delay:0.0 options:UIViewAnimationOptionCurveEaseIn
//                     animations:^{
//                         
//                         self.view.frame = CGRectMake(b?(fr.size.width - deltaX):0, fr.origin.y, fr.size.width, fr.size.height);
//                         
//                     }
//                     completion:^(BOOL finished) {
//                     }];
    
    [self doMenu];

}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return PRICECELL_HEIGHT;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    PriceCell *cell = (id)[tableView cellForRowAtIndexPath:indexPath];
    if (cell) {
        
        [((MenuViewController*)self.parentViewController) showStationWithId:cell.stationId];
    }

}

@end
