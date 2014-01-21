//
//  ViewController.h
//  iSinooil
//
//  Created by Zul on 11/24/13.
//  Copyright (c) 2013 Zul. All rights reserved.
//

#import <UIKit/UIKit.h> 
#import <MapKit/MapKit.h>

#define METERS_PER_MILE 1609.344
#define VERT_SIZE 1835

@class MapSource;

@interface MainViewController : UIViewController

@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (weak, nonatomic) IBOutlet UIScrollView *vertScroll;
@property (weak, nonatomic) IBOutlet UIView *topView;
@property (weak, nonatomic) IBOutlet UIImageView *backgr;
@property (weak, nonatomic) IBOutlet UIImageView *logo;
@property (nonatomic, strong) MapSource* mapsour;
@property (weak, nonatomic) IBOutlet UIView *priceView;

- (IBAction)tapMap:(id)sender;
- (IBAction)menu:(id)sender;

@end
