//
//  MenuViewController.h
//  iSinooil
//
//  Created by вадим on 1/2/14.
//  Copyright (c) 2014 Zul. All rights reserved.
//

#import <UIKit/UIKit.h>

#define MENU_VERT_SIZE 480

@interface MenuViewController : UIViewController

- (IBAction)newsPressed:(id)sender;
- (IBAction)mainPressed:(id)sender;
- (IBAction)mapsPressed:(id)sender;
- (IBAction)aboutPressed:(id)sender;
- (IBAction)actionsPressed:(id)sender;
- (IBAction)hotlinePressed:(id)sender;
- (IBAction)settingsPressed:(id)sender;
- (IBAction)shopPressed:(id)sender;
- (IBAction)sitePressed:(id)sender;
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentViewW;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentViewH;

- (IBAction)tapFB:(id)sender;
- (IBAction)tapVK:(id)sender;

- (void) showMaps;
- (void) showPrices;
- (void) showNews;
- (void) showStationWithId:(int) sid;
- (void) showActions;
- (void) showAbout;
- (void) showSettings;
- (void) showHotline;
@property (weak, nonatomic) IBOutlet UIButton *bmain;
@property (weak, nonatomic) IBOutlet UIButton *babout;
@property (weak, nonatomic) IBOutlet UIButton *bmap;
@property (weak, nonatomic) IBOutlet UIButton *bnews;
@property (weak, nonatomic) IBOutlet UIButton *bacts;
@property (weak, nonatomic) IBOutlet UIButton *bhotline;
@property (weak, nonatomic) IBOutlet UIButton *bsettings;
@property (weak, nonatomic) IBOutlet UIButton *bshop;
@property (weak, nonatomic) IBOutlet UIButton *bsite;
@property (weak, nonatomic) IBOutlet UILabel *network;

@end
