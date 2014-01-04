//
//  MyMapView.m
//  iSinooil
//
//  Created by вадим on 12/8/13.
//  Copyright (c) 2013 Zul. All rights reserved.
//

#import "MyMapView.h"

//@interface MyMapView()
//
//-(NSMutableArray *)decodePolyLine: (NSMutableString *)encoded;
//-(void) updateRouteView;
//-(NSArray*) calculateRoutesFrom:(CLLocationCoordinate2D) from to: (CLLocationCoordinate2D) to;
//-(void) centerMap;
//
//@end

@implementation MyMapView

-(NSMutableArray *)decodePolyLine: (NSMutableString *)encoded {
    
	[encoded replaceOccurrencesOfString:@"\\\\" withString:@"\\"
								options:NSLiteralSearch
								  range:NSMakeRange(0, [encoded length])];
	NSInteger len = [encoded length];
	NSInteger index = 0;
	NSMutableArray *array = [[NSMutableArray alloc] init];
	NSInteger lat=0;
	NSInteger lng=0;
	while (index < len) {
		NSInteger b;
		NSInteger shift = 0;
		NSInteger result = 0;
		do {
			b = [encoded characterAtIndex:index++] - 63;
			result |= (b & 0x1f) << shift;
			shift += 5;
		} while (b >= 0x20);
		NSInteger dlat = ((result & 1) ? ~(result >> 1) : (result >> 1));
		lat += dlat;
		shift = 0;
		result = 0;
		do {
			b = [encoded characterAtIndex:index++] - 63;
			result |= (b & 0x1f) << shift;
			shift += 5;
		} while (b >= 0x20);
		NSInteger dlng = ((result & 1) ? ~(result >> 1) : (result >> 1));
		lng += dlng;
		NSNumber *latitude = [[NSNumber alloc] initWithFloat:lat * 1e-5];
		NSNumber *longitude = [[NSNumber alloc] initWithFloat:lng * 1e-5];
		printf("[%f,", [latitude doubleValue]);
		printf("%f]", [longitude doubleValue]);
		CLLocation *loc = [[CLLocation alloc] initWithLatitude:[latitude floatValue] longitude:[longitude floatValue]];
		[array addObject:loc];
	}
	
	return array;
}

-(NSArray*) calculateRoutesFrom:(CLLocationCoordinate2D) f to: (CLLocationCoordinate2D) t {
    
	NSString* saddr = [NSString stringWithFormat:@"%f,%f", f.latitude, f.longitude];
	NSString* daddr = [NSString stringWithFormat:@"%f,%f", t.latitude, t.longitude];
	
	NSString* apiUrlStr = [NSString stringWithFormat:@"http://maps.google.com/maps?output=dragdir&saddr=%@&daddr=%@", saddr, daddr];
	NSURL* apiUrl = [NSURL URLWithString:apiUrlStr];
	NSLog(@"api url: %@", apiUrl);
	NSString *apiResponse = [NSString stringWithContentsOfURL:apiUrl encoding:NSASCIIStringEncoding error:nil];
	NSLog(@"resp: %@", apiResponse);
    NSRange r1 = [apiResponse rangeOfString:@"points:" options:NSCaseInsensitiveSearch];
    NSRange r2 = [apiResponse rangeOfString:@"levels:" options:NSCaseInsensitiveSearch];
	NSString* encodedPoints = [apiResponse substringWithRange:NSMakeRange(r1.location + 8, r2.location - r1.location - 10)];
//	NSString* encodedPoints = @"s_seF|nbjVCcB??Pi@|EwG??NDvCbE";//nil;//[apiResponse stringByMatching:@"points:\\\"([^\\\"]*)\\\"" capture:1L];
	NSLog(@"encoded: %@", encodedPoints);
	
	return [self decodePolyLine:[encodedPoints mutableCopy]];
}

//-(void) centerMap {
//    
//	MKCoordinateRegion region;
//    
//	CLLocationDegrees maxLat = -90;
//	CLLocationDegrees maxLon = -180;
//	CLLocationDegrees minLat = 90;
//	CLLocationDegrees minLon = 180;
//	for(int idx = 0; idx < routes.count; idx++)
//	{
//		CLLocation* currentLocation = [routes objectAtIndex:idx];
//		if(currentLocation.coordinate.latitude > maxLat)
//			maxLat = currentLocation.coordinate.latitude;
//		if(currentLocation.coordinate.latitude < minLat)
//			minLat = currentLocation.coordinate.latitude;
//		if(currentLocation.coordinate.longitude > maxLon)
//			maxLon = currentLocation.coordinate.longitude;
//		if(currentLocation.coordinate.longitude < minLon)
//			minLon = currentLocation.coordinate.longitude;
//	}
//	region.center.latitude     = (maxLat + minLat) / 2;
//	region.center.longitude    = (maxLon + minLon) / 2;
//	region.span.latitudeDelta  = maxLat - minLat;
//	region.span.longitudeDelta = maxLon - minLon;
//	
//	[self setRegion:region animated:YES];
//}

-(void) showRouteFrom: (MapPoint*) f to:(MapPoint*) t {
	
    if(!routeView) {
        
        routeView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
		routeView.userInteractionEnabled = NO;
//		[self addSubview:routeView];
		
		lineColor = [UIColor colorWithWhite:0.2 alpha:0.5];

    }
    
	routes = [self calculateRoutesFrom:f.coordinate to:t.coordinate];
	
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
