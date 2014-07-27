//
//  Common.h
//  iSinooil
//
//  Created by вадим on 1/2/14.
//  Copyright (c) 2014 Zul. All rights reserved.
//


//http://habrahabr.ru/company/ruswizards/blog/156811/
//https://developer.apple.com/library/ios/documentation/NetworkingInternet/Conceptual/RemoteNotificationsPG/RemoteNotificationsPG.pdf
//http://habrahabr.ru/post/178775/

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

enum {L_RU, L_ENG, L_KZ};
enum {M_KM, M_MI, M_MT}; //km, miles, metres

//#define NSLocalizedString(@"AIGAS", nil)

#define DEVICE_TOKEN @"deviceToken"
#define PUSH_ID_FOR_SIMULATOR @"11223344556678"
//urls
#define URL_SHOP @"http://sinooilshop.kz/"
#define URL_SITE @"http://www.sinooil.kz/"
#define URL_FB @"https://www.facebook.com/sinooil.kz"
#define URL_FB_SPEC @"fb://profile/377761332316296"
#define URL_VK @"http://vk.com/sinooil"
#define URL_VK_SPEC @"vk://vk.com/sinooil"
#define NEWS_URL_LAST @"http://sinoapp.4design.asia/out.php?action=news&from="
#define NEWS_URL @"http://sinoapp.4design.asia/out.php?action=news"
#define NEWS_URL_FULL @"http://sinoapp.4design.asia/out.php?action=fulltext&id="
#define ACTS_URL_LAST @"http://sinoapp.4design.asia/out.php?action=actions&from="
#define ACTS_URL @"http://sinoapp.4design.asia/out.php?action=actions"
#define ABOUT_URL @"http://sinoapp.4design.asia/out.php?action=content"
#define AZS_URL @"http://sinoapp.4design.asia/out.php?action=stations"
#define FUEL_URL @"http://sinoapp.4design.asia/out.php?action=prices"
#define DEVICE_REG_URL @"http://sinoapp.4design.asia/out.php?action=new&device_id=%@&type=ios"
#define RECV_MSG_URL @"http://sinoapp.4design.asia/out.php?action=message&imei=%@&id=%d"
#define SEND_MSG_URL @"http://sinoapp.4design.asia/out.php?action=message&imei=%@"
#define SEND_STATION_FEEDBACK_URL @"http://sinoapp.4design.asia/out.php?action=feedback&t=%@&m=%@"
#define CITIES_URL @"http://sinoapp.4design.asia/out.php?action=city"

//cities.json
#define CITY_NAME @"ttl"
#define CITY_ID @"id"
#define CITY_LAT @"lat"
#define CITY_LON @"lng"

//chat
#define CHAT_MESSAGE @"message"
#define CHAT_DIRECTION @"direction"
#define CHAT_ID @"id"
#define CHAT_TIME @"timestamp"

//azs.json
#define STATION_ID @"id"
#define STATION_TITLE @"ttl"
#define STATION_DESCR @"desc"
#define STATION_ADDR @"addr"
#define STATION_LAT @"lat"
#define STATION_LON @"lng"
#define STATION_FUEL @"fuel"
#define STATION_SERV @"serv"
#define STATION_CARD @"card"
#define STATION_PHONE @"phone"
#define STATION_PIC @"pic"
#define STATION_CITY @"city"
#define PHONE_NUMBER @"n"
#define AZS_VALUES @"items"

//about.json
#define ABOUT_VALUES @"pages"
#define ABOUT_ID @"id"
#define ABOUT_TXT @"txt"
#define ABOUT_TTL @"ttl"
#define ABOUT_PHONE @"phone"
#define ABOUT_ADDRESS @"address"
#define ABOUT_LAT @"lat"
#define ABOUT_LON @"lng"

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

#define AZS_ID @"id"
#define AZS_DIST @"azsdist"
#define AZS_NEEDUPDATE @"needupd"
#define AZS_LAT @"lat"
#define AZS_LON @"lng"

@class PriceCell;
//@class MenuViewController;
#import "MenuViewController.h"
#import "MapViewController.h"
#import "PriceViewController.h"

@interface Common : NSObject

+ (Common*) instance;

+ (CGSize) currentScreenBoundsDependOnOrientation:(UIInterfaceOrientation) interfaceOrientation;
+ (CGSize) currentScreenBounds;

+ (NSArray*) calculateRoutesFrom:(CLLocationCoordinate2D) f to: (CLLocationCoordinate2D) t;

- (void) regDeviceForPush:(NSString*)dev_id;

- (void) fillDists;
- (void) setAllNeedDistancesUpdate;

//- (float) calculateDistTo: (CLLocationCoordinate2D) t;
- (float) calculateDistToStation: (int) station_id;
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
- (NSDictionary*) getBranchWithId:(int)n;

- (NSString*) getStringForKey:(NSString*)key;
- (NSString*) getCurrentCityName;
- (int) getCurrentCityId;
- (CLLocationCoordinate2D) getCurrentCityCoord;

- (void) loadAndParse;
- (void) sendMessage:(NSString*) msg;
- (NSDictionary*) recvMessage;

- (void) sendStationFeedback:(NSString*) msg forStation:(NSString*)station;

- (void) filterOnSelectedCity;

@property (nonatomic, strong) NSArray* azsjson;
@property (nonatomic, strong) NSArray* sortedazsjson;
@property (nonatomic, strong) NSArray* fueljson;
@property (nonatomic, strong) NSArray* cityjson;
@property (nonatomic, strong) NSArray* aboutjson;
@property (nonatomic, strong) NSArray* newsjson;
@property (nonatomic, strong) NSArray* actsjson;
@property (assign, readwrite) CLLocationCoordinate2D userCoordinate;
@property (nonatomic, strong) MKMapView* mymapview;
@property (assign, readwrite) int fuelSelected;
@property (assign, readwrite) int stationRowSelected;
@property (assign, readwrite) int lastNews;
@property (assign, readwrite) int lastAct;
@property (nonatomic, strong) NSDictionary* topnews;
@property (nonatomic, strong) NSDictionary* topact;
@property (assign, readwrite) int lang;
@property (assign, readwrite) int metrics;
@property (nonatomic, retain) NSBundle* languageBundle;
@property (nonatomic, weak) MenuViewController* menucontr;
//@property (nonatomic, weak) PriceViewController* pricecontr;
@property (nonatomic, weak) MapViewController* mapcontr;
@property (assign, readwrite) BOOL internetActive;
@property (assign, readwrite) int fuel;
@property (assign, readwrite) int card;
@property (assign, readwrite) int serv;
//@property (assign, readwrite) BOOL needDistancesUpdate;
@property (nonatomic, strong) NSMutableDictionary* azsDistances;

@property (strong, readwrite) dispatch_semaphore_t allowSemaphore;
@property (assign, readwrite) int dist_upd_cnt;
@property (assign, readwrite) BOOL fsttime;
@property (assign, readwrite) BOOL freeOfSems;

@property (assign, readwrite) int selectedCity;
@property (assign, readwrite) int lastMsg;

@property(nonatomic, strong) NSString* deviceId;

@property(nonatomic, strong) NSMutableDictionary *cellHeights;
@property(nonatomic, strong) NSMutableDictionary *didReloadRowsBools;

@end

