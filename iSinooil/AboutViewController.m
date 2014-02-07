//
//  AboutViewController.m
//  iSinooil
//
//  Created by Admin on 07.02.14.
//  Copyright (c) 2014 Zul. All rights reserved.
//

#import "AboutViewController.h"
#import "Common.h"

@implementation AboutViewController

- (void) willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    
    CGSize s = [Common currentScreenBoundsDependOnOrientation:toInterfaceOrientation];
    self.view.frame = CGRectMake(0, 0, s.width, s.height);
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    UILabel* labelPrices = (UILabel*)[self.topView viewWithTag:TITLELABEL_TAG];
    labelPrices.font = FONT_STD_TOP_MENU;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
