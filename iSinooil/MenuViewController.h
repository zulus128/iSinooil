//
//  MenuViewController.h
//  iSinooil
//
//  Created by вадим on 1/2/14.
//  Copyright (c) 2014 Zul. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MenuViewController : UIViewController
- (IBAction)newsPressed:(id)sender;
- (IBAction)mainPressed:(id)sender;
- (IBAction)mapsPressed:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *news;

@end
