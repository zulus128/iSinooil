//
//  ViewController.m
//  iSinooil
//
//  Created by Zul on 11/24/13.
//  Copyright (c) 2013 Zul. All rights reserved.
//

#import "ViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "WildcardGestureRecognizer.h"

@interface ViewController ()

@end

@implementation ViewController

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

//    WildcardGestureRecognizer * tapInterceptor = [[WildcardGestureRecognizer alloc] init];
//    tapInterceptor.touchesBeganCallback = ^(NSSet * touches, UIEvent * event) {
//    
//        NSLog(@"mapview clicked");
//    };
//    
//    [self.mapView addGestureRecognizer:tapInterceptor];
    
//    self.navigationController.navigationBarHidden = YES;

}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
