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
}

- (void) refresh {
    
    UILabel* labelPrices = (UILabel*)[self.topView viewWithTag:TITLELABEL_TAG];
    labelPrices.font = FONT_STD_TOP_MENU;
    labelPrices.text = NSLocalizedString(@"About", nil);
    [self.bcontacts setTitle:NSLocalizedString(@"Contacts", nil) forState:UIControlStateNormal];

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
                                "</html>", @"HelveticaNeueCyr-Light", [NSNumber numberWithInt:12], [d valueForKey:ABOUT_TXT]];
            
            [self.webview loadHTMLString:myHTML baseURL:nil];
            break;
        }
    }

}

- (void)viewDidLoad {
    
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    [self refresh];
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

- (IBAction)showDetails:(id)sender {
    
    AboutDetailViewController* detailViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"aboutDetailController"];
    [self.navigationController pushViewController:detailViewController animated:YES];

}

@end
