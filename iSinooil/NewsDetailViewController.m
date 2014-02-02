//
//  NewsDetailViewController.m
//  iSinooil
//
//  Created by вадим on 2/2/14.
//  Copyright (c) 2014 Zul. All rights reserved.
//

#import "NewsDetailViewController.h"
#import "Common.h"

@implementation NewsDetailViewController

//- (void) willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
//    
//    //    NSLog(@"will rotate detail news");
//    
//    CGSize s = [Common currentScreenBoundsDependOnOrientation:toInterfaceOrientation];
//    self.view.frame = CGRectMake(0, 0, s.width, s.height);
//}

- (void)viewDidLoad {
    
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    NSNumber* n = [self.news valueForKey:START_DATE];
    NSDate* date = [NSDate dateWithTimeIntervalSince1970:n.longValue];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    [dateFormatter setLocale:[NSLocale currentLocale]];
    NSString *formattedDateString = [dateFormatter stringFromDate:date];
    self.date.font = FONT_NEWS_DATE;
    self.date.text = formattedDateString;


}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)back:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];

}

@end
