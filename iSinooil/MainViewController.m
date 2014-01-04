//
//  ViewController.m
//  iSinooil
//
//  Created by Zul on 11/24/13.
//  Copyright (c) 2013 Zul. All rights reserved.
//

#import "MainViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "Common.h"
#import "MenuViewController.h"
#import "MapSource.h"

@interface MainViewController ()

@end

@implementation MainViewController

//- (void) didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
//
//    CGSize s = [Common currentScreenBounds];
//
//    self.topView.frame = CGRectMake(0, 0, s.width, s.height);
//    
//    CGRect fr = self.mapView.frame;
//    self.mapView.frame = CGRectMake(fr.origin.x, fr.origin.y, s.width - 20, fr.size.height);
//    
//}

- (void) willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    
//    NSLog(@"will rotate main");
    
    CGSize s = [Common currentScreenBoundsDependOnOrientation:toInterfaceOrientation];
    self.topView.frame = CGRectMake(0, 0, s.width, s.height);

    CGRect fr = self.mapView.frame;
    self.mapView.frame = CGRectMake(fr.origin.x, fr.origin.y, s.width - 20, fr.size.height);
    
    float max = (s.width > s.height)?s.width:s.height;
    self.backgr.frame = CGRectMake(0, 0, max, max);
    
    fr = self.logo.frame;
    self.logo.frame = CGRectMake((s.width - fr.size.width) / 2, fr.origin.y, fr.size.width, fr.size.height);
    
//    NSLog(@"width = %f", s.width);
}

- (void)viewWillAppear:(BOOL)animated {

    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    self.mapView.userTrackingMode = MKUserTrackingModeFollow;
    CLLocationCoordinate2D noLocation;
    MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(noLocation, 500, 500);
    MKCoordinateRegion adjustedRegion = [self.mapView regionThatFits:viewRegion];
    [self.mapView setRegion:adjustedRegion animated:YES];
    
    self.mapView.layer.cornerRadius = 5;
    self.mapView.layer.masksToBounds = YES;
  
//    CGSize s = [Common currentScreenBoundsDependOnOrientation:toInterfaceOrientation];
    self.vertScroll.contentSize = CGSizeMake(320, 2000);

    self.mapsour = [[MapSource alloc] initWithType:MAPTYPE_MAINMENU];
    self.mapView.delegate = self.mapsour;
}

- (BOOL)shouldAutorotate
{
    return YES;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)menu:(id)sender {
    
    CGRect fr = self.view.frame;
    BOOL b = (fr.origin.x < 1);
    [UIView animateWithDuration:anim_delay delay:0.0 options:UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         
                         self.view.frame = CGRectMake(b?(fr.size.width - deltaX):0, fr.origin.y, fr.size.width, fr.size.height);
                         
                     }
                     completion:^(BOOL finished) {
                     }];
}

- (IBAction)tapMap:(id)sender {
    
    [((MenuViewController*)self.parentViewController) showMaps];
}

@end
