//
//  MapSource.m
//  iSinooil
//
//  Created by вадим on 1/3/14.
//  Copyright (c) 2014 Zul. All rights reserved.
//

#import "MapSource.h"
#import "MapPoint.h"
#import "StationAnnotationView.h"
#import "Common.h"
#import "MyMapView.h"

@implementation MapSource

-(id) initWithType:(int)typ {

	self = [super init];
	if(self !=nil) {
        
        type = typ;
	}
	return self;
}

//- (void)mapViewWillStartLocatingUser:(MKMapView *)mapView {
//
//    NSLog(@"mapViewWillStartLocatingUser");
//}

- (void) addPoints:(MKMapView *)mv {

    NSArray* arr = [Common instance].azsjson;
    for (NSDictionary* d in arr) {
      
        NSNumber* n = [d valueForKey:STATION_LAT];
        CLLocationDegrees lat = n.doubleValue;
        n = [d valueForKey:STATION_LON];
        CLLocationDegrees lon = n.doubleValue;
        CLLocationCoordinate2D coord = { lat, lon };
        NSString* tit = [d valueForKey:STATION_TITLE];
        NSString* subtit = [d valueForKey:STATION_DESCR];

        MapPoint *mp = [[MapPoint alloc] initWithCoordinate:coord title:tit subTitle:subtit];
        [mv addAnnotation:mp];
    }
}

- (void)mapView:(MKMapView *)mv didUpdateUserLocation:(MKUserLocation *)userLocation {

    if(!fsttime) {
        
        fsttime = YES;
        [self addPoints:mv];
    }

    userCoordinate = userLocation.location.coordinate;

#if TARGET_IPHONE_SIMULATOR
    
    
    for(int i = 1; i <= 5;i++) {
        
        CGFloat latDelta = rand()*.0035/RAND_MAX -.002;
        CGFloat longDelta = rand()*.003/RAND_MAX -.0015;
        
        CLLocationCoordinate2D newCoord = { userCoordinate.latitude + latDelta, userCoordinate.longitude + longDelta };
        MapPoint *mp = [[MapPoint alloc] initWithCoordinate:newCoord title:[NSString stringWithFormat:@"Azam Home %d",i] subTitle:@"Home Sweet Home"];
        [mv addAnnotation:mp];
    }
    
#endif
    
}

- (MKAnnotationView *)mapView:(MKMapView *)mv viewForAnnotation:(id <MKAnnotation>)annotation {
    
    if([annotation isKindOfClass:[MKUserLocation class]])
        return nil;
    
    NSString *annotationIdentifier = @"PinViewAnnotation";
    
    StationAnnotationView *pinView = (StationAnnotationView *) [mv
                                                          dequeueReusableAnnotationViewWithIdentifier:annotationIdentifier];
    
    
    if (!pinView) {
        
        pinView = [[StationAnnotationView alloc]
                    initWithAnnotation:annotation
                    reuseIdentifier:annotationIdentifier];
        
        //[pinView setPinColor:MKPinAnnotationColorGreen];
        // pinView.animatesDrop = YES;
        pinView.canShowCallout = YES;
        
        UIImageView *houseIconView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_fuel.png"]];
        [houseIconView setFrame:CGRectMake(0, 0, 30, 30)];
        pinView.leftCalloutAccessoryView = houseIconView;
    }
    else {
        
        pinView.annotation = annotation;
    }
    switch (type) {
        case MAPTYPE_MAINMENU:
            pinView.enabled = NO;
            break;
        case MAPTYPE_FULLWINDOW:
            pinView.enabled = YES;
            break;
    }
    
    return pinView;
    
}

- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view {
    
    CLLocationCoordinate2D c = view.annotation.coordinate;
    NSLog(@"didSel %f %f", c.latitude, c.longitude);

    MapPoint* me = [[MapPoint alloc] initWithCoordinate:userCoordinate title:@"me" subTitle:@"meme"];
    MapPoint* to = [[MapPoint alloc] initWithCoordinate:c title:@"to" subTitle:@"toto"];
    
    [((MyMapView *)mapView) showRouteFrom:me to:to];
    
}

- (MKOverlayView *)mapView:(MKMapView *)mapView viewForOverlay:(id <MKOverlay>)overlay {
    
    MKPolylineView *polylineView = [[MKPolylineView alloc] initWithPolyline:overlay];
    polylineView.strokeColor = [UIColor greenColor];
    polylineView.lineWidth = 5.0;
    
    return polylineView;
    
}

@end
