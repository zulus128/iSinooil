//
//  AboutViewController.m
//  iSinooil
//
//  Created by Admin on 07.02.14.
//  Copyright (c) 2014 Zul. All rights reserved.
//

#import "AboutViewController.h"
#import "Common.h"
#import "AboutDetailViewController.h"

@implementation AboutViewController

- (void) willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    
    CGSize s = [Common currentScreenBoundsDependOnOrientation:toInterfaceOrientation];
    self.view.frame = CGRectMake(0, 0, s.width, s.height);
    
    self.webWidth.constant = s.width - 15;
    
}

- (void) didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
    
//    NSLog(@"wv = %f", self.webview.frame.size.width);
    self.webHeight.constant = 1;
    [self formWeb];
    
}

- (void) formWeb {
    
    for(NSDictionary* d in [Common instance].aboutjson) {
        
        NSNumber* n = [d valueForKey:ABOUT_ID];
        //        NSLog(@"id = %d", n.intValue);
        if(n.intValue == 1) {
            
            NSString *myHTML = [NSString stringWithFormat:@"<html> \n"
                                "<head> \n"
                                "<style type=\"text/css\"> \n"
                                "body {font-family: \"%@\"; font-size: %@; line-height:1.4;}\n"
                                "</style> \n"
                                "</head> \n"
                                "<body>%@</body> \n"
                                "</html>", @"HelveticaNeueCyr-Light", [NSNumber numberWithInt:14], [d valueForKey:ABOUT_TXT]];
            
            [self.webview loadHTMLString:myHTML baseURL:nil];
            break;
        }
    }

}

- (void) refresh {
    
    UILabel* labelPrices = (UILabel*)[self.topView viewWithTag:TITLELABEL_TAG];
    labelPrices.font = FONT_STD_TOP_MENU;
    labelPrices.text = NSLocalizedString(@"About", nil);
    [self.bcontacts setTitle:NSLocalizedString(@"Contacts", nil) forState:UIControlStateNormal];

    CGSize s = [Common currentScreenBounds];
    self.webWidth.constant = s.width - 15;

    [self formWeb];

}

- (void)viewDidLoad {
    
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];

    [self refresh];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)webViewDidFinishLoad:(UIWebView *)theWebView {

    CGFloat height = [[self.webview stringByEvaluatingJavaScriptFromString:@"document.height"] floatValue];
    self.webHeight.constant = height;//contentSize.height;
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

- (IBAction)showDetails:(id)sender {
    
    AboutDetailViewController* detailViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"aboutDetailController"];
    detailViewController.selectedBrunch = 1;
    [self.navigationController pushViewController:detailViewController animated:YES];

}

@end
