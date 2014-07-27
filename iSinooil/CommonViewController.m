//
//  CommonViewController.m
//  iSinooil
//
//  Created by вадим on 7/27/14.
//  Copyright (c) 2014 Zul. All rights reserved.
//

#import "CommonViewController.h"

@interface CommonViewController ()

@end

@implementation CommonViewController

- (void) doMenu {
    
    self.view.hidden = NO;

    CGRect fr = self.view.frame;
    BOOL b = (fr.origin.x < 1);
    [UIView animateWithDuration:anim_delay delay:0.0 options:UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         
                         if(b)
                             [self addTransButton];
                         else
                             [self delTransButton];
                         
                         self.view.frame = CGRectMake(b?(fr.size.width - deltaX):0, fr.origin.y, fr.size.width, fr.size.height);
                         
                     }
                     completion:^(BOOL finished) {
                     }];
    
    [[UIApplication sharedApplication] setStatusBarStyle:!b?UIStatusBarStyleDefault:UIStatusBarStyleLightContent animated:YES];
    
}

- (void) delTransButton {
    
    UIView* v = [self.view viewWithTag:TRANSBUTTON_TAG];
    [v removeFromSuperview];
}

- (void) addTransButton {
    
    UIButton* button1 = [UIButton buttonWithType:UIButtonTypeCustom];
    [button1 addTarget:self action:@selector(transSelected:) forControlEvents:UIControlEventTouchUpInside];
    button1.frame = self.view.frame;
    button1.tag = TRANSBUTTON_TAG;
    [self.view addSubview:button1];
    
}

- (void) transSelected:(id)sender {
    
    [self doMenu];
}

@end
