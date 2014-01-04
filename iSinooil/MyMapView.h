//
//  MyMapView.h
//  iSinooil
//
//  Created by вадим on 12/8/13.
//  Copyright (c) 2013 Zul. All rights reserved.
//

#import <MapKit/MapKit.h>
#import "MapPoint.h"

@interface MyMapView : MKMapView {
    
//    MKMapView* mapView;
	UIImageView* routeView;
	NSArray* routes;
	UIColor* lineColor;
}

//@property (nonatomic, retain) UIColor* lineColor;
-(void) showRouteFrom: (MapPoint*) f to:(MapPoint*) t;

@end
