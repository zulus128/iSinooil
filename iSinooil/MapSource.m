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
#import "MapViewController.h"

@implementation MapSource

-(id) initWithType:(int)typ {

	self = [super init];
	if(self !=nil) {
        
        type = typ;
	}
	return self;
}

- (void)refreshPinsAndCityChange {
    
    if([Common instance].selectedCity >= 0) {
        
        MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance([[Common instance] getCurrentCityCoord], 5000.0f, 5000.0f);
        [self.mapcontr.mapView setRegion:region animated:YES];
    }
    
    [self refreshPins];
}

- (void)refreshPins {

    id userLocation = [self.mapcontr.mapView userLocation];
    [self.mapcontr.mapView removeAnnotations:[self.mapcontr.mapView annotations]];
    
    if ( userLocation != nil ) {
//        [self.mapcontr.mapView addAnnotation:userLocation]; // will cause user location pin to blink
        self.mapcontr.mapView.showsUserLocation = YES;
    }
    
    [self addPoints:self.mapcontr.mapView];
    

}
//- (void)mapViewWillStartLocatingUser:(MKMapView *)mapView {
//
//    NSLog(@"mapViewWillStartLocatingUser");
//}

- (void) addPoints:(MKMapView *)mv {

    NSArray* arr = [Common instance].azsjson;
    int i = 0;
    for (NSDictionary* d in arr) {
      
        NSNumber* nf = [d valueForKey:STATION_FUEL];
        BOOL bf = [Common instance].fuel?((nf.intValue & [Common instance].fuel) == [Common instance].fuel):YES;
        NSNumber* ns = [d valueForKey:STATION_SERV];
        BOOL bs = [Common instance].serv?((ns.intValue & [Common instance].serv) == [Common instance].serv):YES;
        NSNumber* nc = [d valueForKey:STATION_CARD];
        BOOL bc = [Common instance].card?((nc.intValue & [Common instance].card) == [Common instance].card):YES;
        NSNumber* ncity = [d valueForKey:STATION_CITY];
        BOOL bct = ([Common instance].selectedCity >= 0)?(ncity.intValue == [[Common instance] getCurrentCityId]):YES;
        
        if(bf && bs && bc && bct) {

            NSNumber* n = [d valueForKey:STATION_LAT];
            CLLocationDegrees lat = n.doubleValue;
            n = [d valueForKey:STATION_LON];
            CLLocationDegrees lon = n.doubleValue;
            CLLocationCoordinate2D coord = { lat, lon };
            NSString* tit = [d valueForKey:STATION_TITLE];
            NSString* subtit = [d valueForKey:STATION_DESCR];

            MapPoint *mp = [[MapPoint alloc] initWithCoordinate:coord title:tit subTitle:subtit];
            
            mp.number = i++;
            
            n = [d valueForKey:STATION_ID];
            mp.stationId = n.intValue;
            
            [mv addAnnotation:mp];
        }
    }
}

- (void)mapView:(MKMapView *)mv didUpdateUserLocation:(MKUserLocation *)userLocation {

    
    if(![Common instance].fsttime) {
        
        MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(userLocation.coordinate, 500.0f, 500.0f);
        [mv setRegion:region animated:YES];

        [Common instance].fsttime = YES;
        [self addPoints:mv];
//        NSLog(@"uc = %f %f", [Common instance].userCoordinate.latitude, [Common instance].userCoordinate.longitude);
        [Common instance].userCoordinate = userLocation.location.coordinate;
        [[Common instance] fillDists];
        
#if TARGET_IPHONE_SIMULATOR
        
        
        for(int i = 0; i < 4;i++) {
            
            CGFloat latDelta = rand()*.0035/RAND_MAX -.002;
            CGFloat longDelta = rand()*.003/RAND_MAX -.0015;
            
            CLLocationCoordinate2D newCoord = { [Common instance].userCoordinate.latitude + latDelta, [Common instance].userCoordinate.longitude + longDelta };
            MapPoint *mp = [[MapPoint alloc] initWithCoordinate:newCoord title:[NSString stringWithFormat:@"Azam Home %d",i] subTitle:@"Home Sweet Home"];
            mp.number = i;
            [mv addAnnotation:mp];
            

//            CLLocationCoordinate2D vLoc = { 43.27143, 76.95885 };
//            [Common instance].userCoordinate = vLoc;
//            [[Common instance] fillDists];
            

        }
        
#endif
        
//        dispatch_semaphore_signal([Common instance].allowSemaphore);

        return;
    }

    CLLocation *oldLocation = [[CLLocation alloc] initWithCoordinate:[Common instance].userCoordinate altitude:1 horizontalAccuracy:1 verticalAccuracy:-1 timestamp:nil];
    [Common instance].userCoordinate = userLocation.location.coordinate;
    CLLocation* newLocation = userLocation.location;
    CLLocationDistance distance = [newLocation distanceFromLocation:oldLocation];
//    NSLog(@"change location to %f meters", distance);
    if(distance > 100) {
        
        [[Common instance] setAllNeedDistancesUpdate];
    }
    
}

- (MKAnnotationView *)mapView:(MKMapView *)mv viewForAnnotation:(id <MKAnnotation>)annotation {
    
    if([annotation isKindOfClass:[MKUserLocation class]]) {

        return nil;
    }
    
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
    
    if(![view isKindOfClass:[StationAnnotationView class]])
         return;
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^(void) {
        
        CLLocationCoordinate2D c = view.annotation.coordinate;
        //    NSLog(@"didSel %f %f", c.latitude, c.longitude);
        
        MapPoint* me = [[MapPoint alloc] initWithCoordinate:[Common instance].userCoordinate title:@"me" subTitle:@"meme"];
        MapPoint* to = [[MapPoint alloc] initWithCoordinate:c title:@"to" subTitle:@"toto"];
        [((MyMapView *)mapView) showRouteFrom:me to:to];
        
        //for iOS7 routing    [((MyMapView *)mapView) showRouteTo:c];
    });

    
}

//- (MKOverlayView *)mapView:(MKMapView *)mapView viewForOverlay:(id <MKOverlay>)overlay {
//    
//    MKPolylineView *polylineView = [[MKPolylineView alloc] initWithPolyline:overlay];
//    polylineView.strokeColor = [UIColor greenColor];
//    polylineView.lineWidth = 5.0;
//    
//    return polylineView;
//    
//}

- (MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id < MKOverlay >)overlay {
    
    MKPolylineRenderer *renderer = [[MKPolylineRenderer alloc] initWithOverlay:overlay];
//    renderer.strokeColor = [UIColor blueColor];
    renderer.strokeColor = [UIColor colorWithRed:180/255.0 green:42/255.0 blue:42/255.0 alpha:1];
    renderer.lineWidth = 5.0;
    return renderer;
}

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control {
    
   if ([control isKindOfClass:[UIButton class]]) {
       
       MapPoint* mp = (MapPoint*) view.annotation;
//       NSLog(@"--- %d", mp.number);
       [self.mapcontr showDetail:mp.number];
   }
}

@end
