//
//  Common.m
//  iSinooil
//
//  Created by вадим on 1/2/14.
//  Copyright (c) 2014 Zul. All rights reserved.
//

#import "Common.h"
#import <MapKit/MapKit.h>
#import "PriceCell.h"

@implementation Common

+ (Common*) instance  {
	
	static Common* instance;
	
	@synchronized(self) {
		
		if(!instance) {
			
			instance = [[Common alloc] init];
            
		}
	}
	return instance;
}

- (id) init {
	
	self = [super init];
	if(self !=nil) {

        [self loadData];
        [self parseData];
        
        self.fuelSelected = 0;
	}
	return self;
}

- (void) parseData {
    
    NSArray* sp = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString* docpath = [sp objectAtIndex: 0];
    
    NSString* azsPath = [docpath stringByAppendingPathComponent:@"azs.json"];
    BOOL fe = [[NSFileManager defaultManager] fileExistsAtPath:azsPath];
    if(!fe) {
        
        NSString *appFile = [[NSBundle mainBundle] pathForResource:@"azs" ofType:@"json"];
        NSFileManager *fileManager = [NSFileManager defaultManager];
        NSError *error;
        [fileManager copyItemAtPath:appFile toPath:azsPath error:&error];
    }
    
    NSString *azs= [NSString stringWithContentsOfFile:azsPath encoding:NSUTF8StringEncoding error:nil];
    NSData* tardata = [azs dataUsingEncoding:NSUTF8StringEncoding];
    NSError* error;
    self.azsjson = [NSJSONSerialization JSONObjectWithData:tardata options:NSDataReadingUncached error:&error];
    
    if (!self.azsjson) {
        
        NSLog(@"Error parsing azs: %@", error);
        
    } else {
        
        NSLog(@"Parsing azs: OK!");
        //        NSLog(@"azsjson: %@", [self.azsjson objectAtIndex:2]);
    }
    
    NSString* azsFuel = [docpath stringByAppendingPathComponent:@"fuel.json"];
    fe = [[NSFileManager defaultManager] fileExistsAtPath:azsFuel];
    if(!fe) {
        
        NSString *appFile = [[NSBundle mainBundle] pathForResource:@"fuel" ofType:@"json"];
        NSFileManager *fileManager = [NSFileManager defaultManager];
        NSError *error;
        [fileManager copyItemAtPath:appFile toPath:azsFuel error:&error];
    }
    
    NSString *fuel= [NSString stringWithContentsOfFile:azsFuel encoding:NSUTF8StringEncoding error:nil];
    tardata = [fuel dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary* d = [NSJSONSerialization JSONObjectWithData:tardata options:NSDataReadingUncached error:&error];
    self.fueljson = [d objectForKey:FUEL_VALUES];
    
    if (!self.fueljson) {
        
        NSLog(@"Error parsing fuel: %@", error);
        
    } else {
        
        NSLog(@"Parsing fuel: OK!");
        //        NSLog(@"fueljson: %@", self.fueljson);
    }
    
    
    [self parseNews];
}

- (void) parseNews {

    NSArray* sp = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString* docpath = [sp objectAtIndex: 0];
    NSString* news = [docpath stringByAppendingPathComponent:@"news.json"];
    BOOL fe = [[NSFileManager defaultManager] fileExistsAtPath:news];
    if(!fe) {
        
        NSString *appFile = [[NSBundle mainBundle] pathForResource:@"news" ofType:@"json"];
        NSFileManager *fileManager = [NSFileManager defaultManager];
        NSError *error;
        [fileManager copyItemAtPath:appFile toPath:news error:&error];
    }
    
    NSString *fnews= [NSString stringWithContentsOfFile:news encoding:NSUTF8StringEncoding error:nil];
    NSData* tardata = [fnews dataUsingEncoding:NSUTF8StringEncoding];
    NSError* error;

    self.newsjson = [NSJSONSerialization JSONObjectWithData:tardata options:NSDataReadingUncached error:&error];
    
    //    NSLog(@"news = %@", d);
    if (!self.newsjson) {
        
        NSLog(@"Error parsing news: %@", error);
        
    } else {
        
        NSLog(@"Parsing news: OK!");
        
        if(!self.lastNews) {

            int m = 0;
            for(NSDictionary* d in self.newsjson) {
                
                NSNumber* n = [d valueForKey:NEWS_ID];
                if(n.intValue > m) {
                    
                    m = n.intValue;
                    self.topnews = d;
                }
            }
        }

    }

}

- (void) loadData {
    
    NSArray* sp = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString* docpath = [sp objectAtIndex: 0];
    
    NSString* filePath = [docpath stringByAppendingPathComponent:@"news.json"];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    if(self.lastNews)
        [request setURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%d", NEWS_URL_LAST, self.lastNews]]];
    else
        [request setURL:[NSURL URLWithString:NEWS_URL]];
    
    NSHTTPURLResponse* urlResponse = nil;
    NSError *error = nil;
    NSData* responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&urlResponse error:&error];
    if (responseData == nil) {
        if (error != nil) {
            
            UIAlertView* dialog = [[UIAlertView alloc] init];
            [dialog setTitle:NSLocalizedString(@"title_network_error", nil)];
            [dialog setMessage:NSLocalizedString(@"network_error", nil)];
            [dialog addButtonWithTitle:@"OK"];
            [dialog show];
        }
    }
    else {
        
        [responseData writeToFile:filePath atomically:YES];
        NSLog(@"news loaded OK!");
    }
    
    
}

- (int) getNewsCount {
    
    return self.newsjson.count;
}

- (NSDictionary*) getNewsAt:(int)n {
    
    return [self.newsjson objectAtIndex:n];
}

- (NSString*) getNewsFullText:(int)n {
    
    NSString* res = @"";
//    NSDictionary* d = [self.newsjson objectAtIndex:n];
//    NSNumber* num = [d valueForKey:NEWS_ID];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];

    [request setURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%d", NEWS_URL_FULL, n]]];
    
    NSHTTPURLResponse* urlResponse = nil;
    NSError *error = nil;
    NSData* responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&urlResponse error:&error];
    if (responseData == nil) {
        if (error != nil) {
            
            UIAlertView* dialog = [[UIAlertView alloc] init];
            [dialog setTitle:NSLocalizedString(@"title_network_error", nil)];
            [dialog setMessage:NSLocalizedString(@"network_error", nil)];
            [dialog addButtonWithTitle:@"OK"];
            [dialog show];
        }
    }
    else {
        
        NSArray* arr = [NSJSONSerialization JSONObjectWithData:responseData options:NSDataReadingUncached error:&error];
        
//        NSLog(@"dic = %@", dic);
        if (!arr) {
            
            NSLog(@"Error parsing FULL news: %@", error);
            
        } else {
            
            NSLog(@"Parsing FULL news: OK!");
            NSDictionary* dic = [arr objectAtIndex:0];
            res = [dic objectForKey:NEWS_FULLTEXT];
        }
    }

    NSString *myHTML = [NSString stringWithFormat:@"<html> \n"
                        "<head> \n"
                        "<style type=\"text/css\"> \n"
                        "body {font-family: \"%@\"; font-size: %@;}\n"
                        "</style> \n"
                        "</head> \n"
                        "<body>%@</body> \n"
                        "</html>", @"HelveticaNeueCyr-Light", [NSNumber numberWithInt:11], res];
    return myHTML;
}

+ (CGSize) currentScreenBoundsDependOnOrientation:(UIInterfaceOrientation) interfaceOrientation {
    
    CGRect screenBounds = [UIScreen mainScreen].bounds ;
    CGFloat width = CGRectGetWidth(screenBounds)  ;
    CGFloat height = CGRectGetHeight(screenBounds) ;
    //    UIInterfaceOrientation interfaceOrientation = [UIApplication sharedApplication].statusBarOrientation;
    
    if(UIInterfaceOrientationIsPortrait(interfaceOrientation))
        return CGSizeMake(width, height);
    
    return CGSizeMake(height, width);
}

+ (CGSize) currentScreenBounds {
    
    CGRect screenBounds = [UIScreen mainScreen].bounds ;
    CGFloat width = CGRectGetWidth(screenBounds)  ;
    CGFloat height = CGRectGetHeight(screenBounds) ;
    
    UIInterfaceOrientation interfaceOrientation = [UIApplication sharedApplication].statusBarOrientation;
    
    if(UIInterfaceOrientationIsPortrait(interfaceOrientation))
        return CGSizeMake(width, height);
    
    return CGSizeMake(height, width);
}

//for iOS 7 routing
//- (float) calculateDistTo: (CLLocationCoordinate2D) t {
//
//    MKPlacemark *placemark = [[MKPlacemark alloc] initWithCoordinate:t addressDictionary:nil];
//    MKMapItem *destination = [[MKMapItem alloc] initWithPlacemark:placemark];
//    
//    MKDirectionsRequest *request = [[MKDirectionsRequest alloc] init];
//    request.source = [MKMapItem mapItemForCurrentLocation];
//    request.destination = destination;
//    request.requestsAlternateRoutes = NO;
//    request.transportType = MKDirectionsTransportTypeAutomobile;
//    MKDirections *directions = [[MKDirections alloc] initWithRequest:request];
//    
//    __block float dist = 0;
//    [directions calculateDirectionsWithCompletionHandler:
//     ^(MKDirectionsResponse *response, NSError *error) {
//         if (error) {
//             // Handle Error
//         } else {
//             if (response.routes.count) {
//                 
//                 dist = ((MKRoute*)[response.routes objectAtIndex:0]).distance;
//             }
//         }
//     }];
//
//    return dist;
//}

//for iOS 6 routing
+ (NSMutableArray *)decodePolyLine: (NSMutableString *)encoded {
    
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
        //		printf("[%f,", [latitude doubleValue]);
        //		printf("%f]", [longitude doubleValue]);
		CLLocation *loc = [[CLLocation alloc] initWithLatitude:[latitude floatValue] longitude:[longitude floatValue]];
		[array addObject:loc];
	}
	
	return array;
}

+ (NSString*) callMapServiceFrom:(CLLocationCoordinate2D) f to: (CLLocationCoordinate2D) t {

    NSString* saddr = [NSString stringWithFormat:@"%f,%f", f.latitude, f.longitude];
	NSString* daddr = [NSString stringWithFormat:@"%f,%f", t.latitude, t.longitude];
	
	NSString* apiUrlStr = [NSString stringWithFormat:@"http://maps.google.com/maps?output=dragdir&saddr=%@&daddr=%@", saddr, daddr];
	NSURL* apiUrl = [NSURL URLWithString:apiUrlStr];
//	NSLog(@"api url: %@", apiUrl);
	NSString *apiResponse = [NSString stringWithContentsOfURL:apiUrl encoding:NSASCIIStringEncoding error:nil];
//	NSLog(@"resp: %@", apiResponse);

    return apiResponse;
}

- (float) calculateDistTo: (CLLocationCoordinate2D) t {

	NSString* apiResponse = [Common callMapServiceFrom:self.userCoordinate to:t];
    NSString* ar1 = [[apiResponse componentsSeparatedByString:@"("] objectAtIndex:1];
    NSString* ar2 = [[ar1 componentsSeparatedByString:@" "] objectAtIndex:0];
    NSString* ar3 = [ar2 stringByReplacingOccurrencesOfString:@"," withString:@"."];
    
    return [ar3 floatValue];
}

- (float) distToNearestStaionWithFuelBit:(int)bit forCell:(PriceCell*)pc {

    float mindist = 1e8;
    for (NSDictionary* d in self.azsjson) {
        
        int fuel = ((NSNumber*)[d valueForKey:STATION_FUEL]).intValue;
        if(! (fuel & bit))
            continue;
        
        NSNumber* n = [d valueForKey:STATION_LAT];
        CLLocationDegrees lat = n.doubleValue;
        n = [d valueForKey:STATION_LON];
        CLLocationDegrees lon = n.doubleValue;
        CLLocationCoordinate2D coord = { lat, lon };
        float dist = [self calculateDistTo:coord];
        if (dist < mindist) {
            
            mindist = dist;
            NSNumber* n = [d valueForKey:STATION_ID];
            pc.stationId = n.intValue;
        }
    }
    
    return mindist;
}

+ (NSArray*) calculateRoutesFrom:(CLLocationCoordinate2D) f to: (CLLocationCoordinate2D) t {
    
	NSString* apiResponse = [Common callMapServiceFrom:f to:t];
    NSRange r1 = [apiResponse rangeOfString:@"points:" options:NSCaseInsensitiveSearch];
    NSRange r2 = [apiResponse rangeOfString:@"levels:" options:NSCaseInsensitiveSearch];
	NSString* encodedPoints = [apiResponse substringWithRange:NSMakeRange(r1.location + 8, r2.location - r1.location - 10)];
	return [Common decodePolyLine:[encodedPoints mutableCopy]];
}

@end
