//
//  Common.h
//  iSinooil
//
//  Created by вадим on 1/2/14.
//  Copyright (c) 2014 Zul. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

//azs.json
#define STATION_TITLE @"ttl"
#define STATION_DESCR @"desc"
#define STATION_LAT @"lat"
#define STATION_LON @"lng"
#define STATION_FUEL @"fuel"
#define STATION_SERV @"serv"
#define STATION_CARD @"card"

@interface Common : NSObject

+ (Common*) instance;

+ (CGSize) currentScreenBoundsDependOnOrientation:(UIInterfaceOrientation) interfaceOrientation;
+ (CGSize) currentScreenBounds;
+ (NSArray*) calculateRoutesFrom:(CLLocationCoordinate2D) f to: (CLLocationCoordinate2D) t;

- (float) calculateDistTo: (CLLocationCoordinate2D) t;

@property (nonatomic, retain) NSArray* azsjson;
@property (assign, readwrite) CLLocationCoordinate2D userCoordinate;
//@property (readwrite) dispatch_semaphore_t userCoordUpdatedSem;


@end
