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
@property (weak, nonatomic) IBOutlet UIView *contView;
@property (weak, nonatomic) IBOutlet UIImageView *backgr;
@property (weak, nonatomic) IBOutlet UIImageView *logo;
@property (nonatomic, strong) MapSource* mapsour;
@property (weak, nonatomic) IBOutlet UIView *priceView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentViewH;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentViewW;


- (IBAction)tapMap:(id)sender;
- (IBAction)menu:(id)sender;
- (IBAction)tapPrice:(id)sender;
- (IBAction)tapNews:(id)sender;

@property (weak, nonatomic) IBOutlet UILabel *distLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *aiLabel;
@property (weak, nonatomic) IBOutlet UIView *newsView;
@property (weak, nonatomic) IBOutlet UIView *actView;
@property (weak, nonatomic) IBOutlet UIImageView *newsImage;
@property (weak, nonatomic) IBOutlet UILabel *ttlLabel;
@property (weak, nonatomic) IBOutlet UILabel *briefLabel;
@property (weak, nonatomic) IBOutlet UILabel *hotlineLabel;
@property (weak, nonatomic) IBOutlet UILabel *settingsLabel;
@property (weak, nonatomic) IBOutlet UILabel *seealsoLabel;
@property (weak, nonatomic) IBOutlet UILabel *ishopLabel;
@property (weak, nonatomic) IBOutlet UILabel *siteLabel;
@property (weak, nonatomic) IBOutlet UILabel *netwLabel;

@end
