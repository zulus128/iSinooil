//
//  AboutViewController.h
//  iSinooil
//
//  Created by Admin on 07.02.14.
//  Copyright (c) 2014 Zul. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AboutViewController : UIViewController

- (IBAction)toMenu:(id)sender;

@property (weak, nonatomic) IBOutlet UIView *topView;

- (IBAction)showDetails:(id)sender;
@property (weak, nonatomic) IBOutlet UIWebView *webview;
@property (weak, nonatomic) IBOutlet UIButton *bcontacts;
@end