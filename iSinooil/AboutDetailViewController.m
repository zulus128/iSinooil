//
//  AboutDetailViewController.m
//  iSinooil
//
//  Created by вадим on 2/8/14.
//  Copyright (c) 2014 Zul. All rights reserved.
//

#import "AboutDetailViewController.h"
#import "MapPoint.h"

@implementation AboutDetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    UILabel* labelPrices = (UILabel*)[self.topView viewWithTag:TITLELABEL_TAG];
    labelPrices.font = FONT_STD_TOP_MENU;

    self.centralLabel.font = FONT_ABOUT_CENTRALOFFICE;
    self.addrLabel.font = FONT_ABOUT_ADDR;
    
    self.map.userTrackingMode = MKUserTrackingModeNone;
    CLLocationCoordinate2D officeLoc = { 43.27143, 76.95885 };
    MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(officeLoc, 1500, 1500);
    MKCoordinateRegion adjustedRegion = [self.map regionThatFits:viewRegion];
    [self.map setRegion:adjustedRegion animated:YES];
    
    MapPoint *mp = [[MapPoint alloc] initWithCoordinate:officeLoc title:@"SINOOIL" subTitle:NSLocalizedString(@"centraloffice", nil)];
	[self.map addAnnotation:mp];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)back:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];

}

- (IBAction)callOffice:(id)sender {
    
    NSString* tel = @"+7 701 123-45-67";
    NSString *phoneNumber = [@"telprompt://" stringByAppendingString:tel];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:phoneNumber]];

}

@end
