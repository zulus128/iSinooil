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

@implementation MainViewController

- (void) willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {

//    NSLog(@"will rotate main");
    
    CGSize s = [Common currentScreenBoundsDependOnOrientation:toInterfaceOrientation];
    self.topView.frame = CGRectMake(0, 0, s.width, s.height);

    self.contentViewH.constant = s.height * 2;
    self.contentViewW.constant = s.width;

}

- (void)viewWillAppear:(BOOL)animated {

    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
}

- (void) updateFuelPrice {
 
    NSString* icon = NSLocalizedString(@"AI97", nil);
    switch ([Common instance].fuelSelected) {
        case 0://FUEL_BIT_97:
            icon = NSLocalizedString(@"AI97", nil);
            break;
        case 1://FUEL_BIT_96:
            icon = NSLocalizedString(@"AI96", nil);
            break;
        case 2://FUEL_BIT_93:
            icon = NSLocalizedString(@"AI93", nil);
            break;
        case 3://FUEL_BIT_92:
            icon = NSLocalizedString(@"AI92", nil);
            break;
        case 4://FUEL_BIT_80:
            icon = NSLocalizedString(@"AI80", nil);
            break;
        case 5://FUEL_BIT_DT:
            icon = NSLocalizedString(@"AIDI", nil);
            break;
        case 6://FUEL_BIT_GAS:
            icon = NSLocalizedString(@"AIGAS", nil);
            break;
    }
    
    self.aiLabel.text = icon;
    self.aiLabel.font = FONT_NAME_PRICE_LIST;
    
    for(NSDictionary* d in [Common instance].fueljson) {
        
        NSNumber* n = [d valueForKey:FUEL_BITS];
        if((n.intValue - 1) == [Common instance].fuelSelected) {
            
            NSNumber* cost = [d valueForKey:FUEL_COST];
            self.priceLabel.text = [NSString stringWithFormat:@"%d", cost.intValue];
            self.priceLabel.font = FONT_PRICE_LIST;
            break;
        }
    }
    
    self.distLabel.text = @"...";
    self.distLabel.font = FONT_KM_PRICE_LIST;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^(void) {
        
        float dist = [[Common instance] distToNearestStaionWithFuelBit:([Common instance].fuelSelected + 1) forCell:nil];
        
        dispatch_async(dispatch_get_main_queue(), ^{

            self.distLabel.text = [NSString stringWithFormat:@"%.1f %@", dist, NSLocalizedString(@"km", nil)];
        });
        
    });

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
    
    self.newsView.layer.cornerRadius = 5;
    self.newsView.layer.masksToBounds = YES;
    self.actView.layer.cornerRadius = 5;
    self.actView.layer.masksToBounds = YES;
    
    self.mapsour = [[MapSource alloc] initWithType:MAPTYPE_MAINMENU];
    self.mapView.delegate = self.mapsour;
    
    CGSize s = [Common currentScreenBounds];
    self.topView.frame = CGRectMake(0, 0, s.width, s.height);
    self.contentViewH.constant = s.height * 2;
    self.contentViewW.constant = s.width;

    [self updateFuelPrice];
}

- (BOOL)shouldAutorotate
{
//    NSLog(@"%s", __PRETTY_FUNCTION__);

    return YES;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
//    NSLog(@"%s", __PRETTY_FUNCTION__);
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

- (IBAction)tapPrice:(id)sender {
    
    [((MenuViewController*)self.parentViewController) showPrices];
}

- (IBAction)tapMap:(id)sender {
    
    [((MenuViewController*)self.parentViewController) showMaps];
}

@end
