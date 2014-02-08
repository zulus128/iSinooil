//
//  Common.h
//  iSinooil
//
//  Created by вадим on 1/2/14.
//  Copyright (c) 2014 Zul. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

enum {L_RU, L_ENG, L_KZ};
enum {M_KM, M_MI, M_MT}; //km, miles, metres

//#define NSLocalizedString(@"AIGAS", nil)

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
#define ABOUT_URL @"http://sinoapp.4design.asia/out.php?action=content"
#define AZS_URL @"http://sinoapp.4design.asia/out.php?action=stations"
#define FUEL_URL @"http://sinoapp.4design.asia/out.php?action=prices"

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
#define AZS_VALUES @"items"

//about.json
#define ABOUT_VALUES @"pages"
#define ABOUT_ID @"id"
#define ABOUT_TXT @"txt"
#define ABOUT_TTL @"ttl"

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
//@class MenuViewController;
#import "MenuViewController.h"

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

- (int) getBranchesCount;
- (NSDictionary*) getBranchAt:(int)n;

- (NSString*) getStringForKey:(NSString*)key;

@property (nonatomic, strong) NSArray* azsjson;
@property (nonatomic, strong) NSArray* fueljson;
@property (nonatomic, strong) NSArray* aboutjson;
@property (nonatomic, strong) NSArray* newsjson;
@property (nonatomic, strong) NSArray* actsjson;
@property (assign, readwrite) CLLocationCoordinate2D userCoordinate;
@property (nonatomic, strong) MKMapView* mymapview;
@property (assign, readwrite) int fuelSelected;
@property (assign, readwrite) int lastNews;
@property (assign, readwrite) int lastAct;
@property (nonatomic, strong) NSDictionary* topnews;
@property (nonatomic, strong) NSDictionary* topact;
@property (assign, readwrite) int lang;
@property (assign, readwrite) int metrics;
@property (nonatomic, retain) NSBundle* languageBundle;
@property (nonatomic, weak) MenuViewController* menucontr;

@end
