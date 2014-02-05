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
#define URL_SHOP @"http://sinooilshop.kz/"
#define URL_SITE @"http://www.sinooil.kz/"
#define URL_FB @"https://www.facebook.com/sinooil.kz"
#define URL_VK @"http://vk.com/sinooil"

#define NEWS_URL_LAST @"http://sinoapp.4design.asia/out.php?action=news&from="
#define NEWS_URL @"http://sinoapp.4design.asia/out.php?action=news"
#define NEWS_URL_FULL @"http://sinoapp.4design.asia/out.php?action=fulltext&id="

#define ACTS_URL_LAST @"http://sinoapp.4design.asia/out.php?action=actions&from="
#define ACTS_URL @"http://sinoapp.4design.asia/out.php?action=actions"

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
#define NEWS_START_DATE @"sd"
#define NEWS_END_DATE @"ed"
#define NEWS_FULLTEXT @"txt"

@class PriceCell;

@interface Common : NSObject

+ (Common*) instance;

+ (CGSize) currentScreenBoundsDependOnOrientation:(UIInterfaceOrientation) interfaceOrientation;
+ (CGSize) currentScreenBounds;

+ (NSArray*) calculateRoutesFrom:(CLLocationCoordinate2D) f to: (CLLocationCoordinate2D) t;
- (float) calculateDistTo: (CLLocationCoordinate2D) t;
- (float) distToNearestStaionWithFuelBit:(int)bit forCell:(PriceCell*)pc;

- (int) getNewsCount;
- (void) loadNewsData;
- (NSDictionary*) getNewsAt:(int)n;
- (NSString*) getNewsActFullText:(int)n;

- (int) getActsCount;
- (void) loadActsData;
- (NSDictionary*) getActAt:(int)n;

@property (nonatomic, strong) NSArray* azsjson;
@property (nonatomic, strong) NSArray* fueljson;
@property (nonatomic, strong) NSArray* newsjson;
@property (nonatomic, strong) NSArray* actsjson;
@property (assign, readwrite) CLLocationCoordinate2D userCoordinate;
@property (nonatomic, strong) MKMapView* mymapview;
@property (assign, readwrite) int fuelSelected;
@property (assign, readwrite) int lastNews;
@property (assign, readwrite) int lastAct;
@property (nonatomic, strong) NSDictionary* topnews;
@property (nonatomic, strong) NSDictionary* topact;

@end
