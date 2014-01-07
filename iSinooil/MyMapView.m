//
//  MyMapView.m
//  iSinooil
//
//  Created by вадим on 12/8/13.
//  Copyright (c) 2013 Zul. All rights reserved.
//

#import "MyMapView.h"
#import "Common.h"

@implementation MyMapView

-(void) showRouteFrom: (MapPoint*) f to:(MapPoint*) t {
	
    if(!routeView) {
        
        routeView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
		routeView.userInteractionEnabled = NO;
//		[self addSubview:routeView];
		
		lineColor = [UIColor colorWithWhite:0.2 alpha:0.5];

    }
    
//	routes = [self calculateRoutesFrom:f.coordinate to:t.coordinate];
	routes = [Common calculateRoutesFrom:f.coordinate to:t.coordinate];
	
	[self updateRouteView];

}

-(void) updateRouteView {
    
    CLLocationCoordinate2D coordinates[routes.count];
    
    int i = 0;
    for (CLLocation* ckpt in routes) {
        
        coordinates[i] = ckpt.coordinate;
        i++;
    }
    MKPolyline* mp = [MKPolyline polylineWithCoordinates:coordinates count:routes.count];
    [self addOverlay:mp];

//	CGContextRef context = 	CGBitmapContextCreate(nil,
//												  routeView.frame.size.width,
//												  routeView.frame.size.height,
//												  8,
//												  4 * routeView.frame.size.width,
//												  CGColorSpaceCreateDeviceRGB(),
//												  kCGImageAlphaPremultipliedLast);
//	
//	CGContextSetStrokeColorWithColor(context, lineColor.CGColor);
//	CGContextSetRGBFillColor(context, 0.0, 0.0, 1.0, 1.0);
//	CGContextSetLineWidth(context, 3.0);
//	
//	for(int i = 0; i < routes.count; i++) {
//		CLLocation* location = [routes objectAtIndex:i];
//		CGPoint point = [self convertCoordinate:location.coordinate toPointToView:routeView];
//		
//		if(i == 0) {
//			CGContextMoveToPoint(context, point.x, routeView.frame.size.height - point.y);
//		} else {
//			CGContextAddLineToPoint(context, point.x, routeView.frame.size.height - point.y);
//		}
//	}
//	
//	CGContextStrokePath(context);
//	
//	CGImageRef image = CGBitmapContextCreateImage(context);
//	UIImage* img = [UIImage imageWithCGImage:image];
//	
//	routeView.image = img;
//	CGContextRelease(context);
    
}

//#pragma mark mapView delegate functions
//- (void)mapView:(MKMapView *)mapView regionWillChangeAnimated:(BOOL)animated
//{
//	routeView.hidden = YES;
//}
//
//- (void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated
//{
//	[self updateRouteView];
//	routeView.hidden = NO;
//	[routeView setNeedsDisplay];
//}
//
//- (void)dealloc {
//	if(routes) {
//		[routes release];
//	}
//	[mapView release];
//	[routeView release];
//    [super dealloc];
//}

@end
