//
//  Common.h
//  iSinooil
//
//  Created by вадим on 1/2/14.
//  Copyright (c) 2014 Zul. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

//urls
#define NEWS_URL_LAST @"http://sinoapp.4design.asia/out.php?action=news&last="
#define NEWS_URL @"http://sinoapp.4design.asia/out.php?action=news"

//azs.json
#define STATION_ID @"id"
#define STATION_TITLE @"ttl"
#define STATION_DESCR @"desc"
#define STATION_LAT @"lat"
#define STATION_LON @"lng"
#define STATION_FUEL @"fuel"
#define STATION_SERV @"serv"
#define STATION_CARD @"card"
#define STATION_PHONE @"phone"
#define PHONE_NUMBER @"n"

//fuel.json
#define FUEL_VALUES @"value"
#define FUEL_BITS @"bits"
#define FUEL_COST @"cost"
#define FUEL_NAME @"fuel"

//news.json
#define NEWS_ID @"id"
#define NEWS_PIC @"pic"
#define NEWS_TTL @"ttl"
#define NEWS_BRIEF @"brief"

@class PriceCell;

@interface Common : NSObject

+ (Common*) instance;

+ (CGSize) currentScreenBoundsDependOnOrientation:(UIInterfaceOrientation) interfaceOrientation;
+ (CGSize) currentScreenBounds;

+ (NSArray*) calculateRoutesFrom:(CLLocationCoordinate2D) f to: (CLLocationCoordinate2D) t;
- (float) calculateDistTo: (CLLocationCoordinate2D) t;
- (float) distToNearestStaionWithFuelBit:(int)bit forCell:(PriceCell*)pc;

@property (nonatomic, strong) NSArray* azsjson;
@property (nonatomic, strong) NSArray* fueljson;
@property (nonatomic, strong) NSArray* newsjson;
@property (assign, readwrite) CLLocationCoordinate2D userCoordinate;
@property (nonatomic, strong) MKMapView* mymapview;
@property (assign, readwrite) int fuelSelected;
@property (assign, readwrite) int lastNews;
@property (nonatomic, strong) NSDictionary* topnews;

@end
