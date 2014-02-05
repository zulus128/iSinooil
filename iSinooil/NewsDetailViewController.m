//
//  NewsDetailViewController.m
//  iSinooil
//
//  Created by вадим on 2/2/14.
//  Copyright (c) 2014 Zul. All rights reserved.
//

#import "NewsDetailViewController.h"
#import "Common.h"
#import "UIImageView+WebCache.h"

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
    
    NSNumber* n = [self.news valueForKey:NEWS_START_DATE];
    NSDate* date = [NSDate dateWithTimeIntervalSince1970:n.longValue];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    [dateFormatter setLocale:[NSLocale currentLocale]];
    NSString *formattedDateString = [dateFormatter stringFromDate:date];
    self.date.font = FONT_NEWS_DATE;
    self.date.text = formattedDateString;

    self.ttl.font = FONT_NEWS_TITLE;
    self.ttl.text = [self.news valueForKey:NEWS_TTL];
    
    NSString* p = [self.news valueForKey:NEWS_PIC];
    [self.pic setImageWithURL:[NSURL URLWithString:p] placeholderImage:[UIImage imageNamed:@"placeholder-icon"]];

    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^(void) {
    
        NSNumber* i = [self.news valueForKey:NEWS_ID];
        NSString* s = [[Common instance] getNewsActFullText:i.intValue];
//        NSLog(@"text = %@", s);
        [self.webView loadHTMLString:s baseURL:nil];

    });

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
