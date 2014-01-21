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

@implementation PriceViewController

- (void) willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    
    //    NSLog(@"will rotate price");
    
    CGSize s = [Common currentScreenBoundsDependOnOrientation:toInterfaceOrientation];
    self.topView.frame = CGRectMake(0, 0, s.width, s.height);
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    UILabel* labelPrices = (UILabel*)[self.topView viewWithTag:TITLELABEL_TAG];
    labelPrices.font = FONT_STD;
    
    self.listsour = [[PricesDataSource alloc] init];
    self.pricesListTable.dataSource = self.listsour;
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

@end
