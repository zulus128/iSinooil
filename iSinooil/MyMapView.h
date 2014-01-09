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
    
	UIImageView* routeView;
	NSArray* routes;
	UIColor* lineColor;
}

-(void) showRouteFrom: (MapPoint*) f to:(MapPoint*) t;
//-(void) showRouteTo:(CLLocationCoordinate2D) t;

//@property (nonatomic, strong) NSArray* prevRoutes;
@property (nonatomic, strong) MKPolyline* prevRoute;

@end
