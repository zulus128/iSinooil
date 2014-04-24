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
#import "MenuViewController.h"
#import "Reachability.h"

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

//        self.needDistancesUpdate = YES;
        
        self.selectedCity = -1;
        
        self.allowSemaphore = dispatch_semaphore_create(0);

        int l = [[NSUserDefaults standardUserDefaults] integerForKey:@"language"];
//        NSLog(@"lang = %d", l);
        NSString* ls = @"ru";
        switch (l) {
            case L_RU:
                ls = @"ru";
                break;
            case L_ENG:
                ls = @"en";
                break;
            case L_KZ:
                ls = @"kk-KZ";
                break;
        }
        NSString* path = [[NSBundle mainBundle] pathForResource:ls ofType:@"lproj"];
        self.languageBundle = [NSBundle bundleWithPath:path];
        self.lang = l;
        
        CLLocationCoordinate2D noLocation = {-1e5, -1e5};
        self.userCoordinate = noLocation;
        
        Reachability* internetReachable = [Reachability reachabilityForInternetConnection];
        NetworkStatus internetStatus = [internetReachable currentReachabilityStatus];
        switch (internetStatus)
        {
            case NotReachable:
            {
                NSLog(@"The internet is down.");
                self.internetActive = NO;
                
                break;
            }
            case ReachableViaWiFi:
            {
                NSLog(@"The internet is working via WIFI.");
                self.internetActive = YES;
                
                break;
            }
            case ReachableViaWWAN:
            {
                NSLog(@"The internet is working via WWAN.");
                self.internetActive = YES;
                
                break;
            }
        }
        
        if(!self.internetActive) {
            
            UIAlertView* dialog = [[UIAlertView alloc] init];
            [dialog setTitle:NSLocalizedString1(@"title_network_error", nil)];
            [dialog setMessage:NSLocalizedString1(@"network_error", nil)];
            [dialog addButtonWithTitle:@"OK"];
            [dialog show];

        }
        
        self.fuelSelected = 0;
        self.newsjson = [NSArray array];
        self.actsjson = [NSArray array];

//        [self loadAboutData];
//        [self loadAzsData];
//        [self loadFuelData];
//        [self loadCityData];
//        
//        [self parseData];
//
//        [self loadNewsData];
//        [self loadActsData];
        
        [self loadAndParse];
        
        self.azsDistances = [NSMutableDictionary dictionary];
        for (NSDictionary* d in self.azsjson) {
            
            NSNumber* lat = [d valueForKey:STATION_LAT];
            NSNumber* lon = [d valueForKey:STATION_LON];
            NSString* n = [d valueForKey:STATION_ID];
            NSMutableDictionary* item = [NSMutableDictionary dictionary];
            [item setObject:[NSNumber numberWithFloat:0] forKey:AZS_DIST];
            [item setObject:[NSNumber numberWithInt:1] forKey:AZS_NEEDUPDATE];
            [item setObject:lat forKey:AZS_LAT];
            [item setObject:lon forKey:AZS_LON];
            
            [self.azsDistances setObject:item forKey:n];
        }
	}
	return self;
}

- (void) loadAndParse {
    
    self.lastNews = 0;
    self.lastAct = 0;
    self.newsjson = [NSArray array];
    self.actsjson = [NSArray array];
    
    [self loadAboutData];
    [self loadAzsData];
    [self loadFuelData];
    [self loadCityData];
    
    [self parseData];
    
    [self loadNewsData];
    [self loadActsData];
    
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
    NSDictionary* d = [NSJSONSerialization JSONObjectWithData:tardata options:NSDataReadingUncached error:&error];
    
    self.azsjson = [d objectForKey:AZS_VALUES];
    
    if (!self.azsjson) {
        
        NSLog(@"Error parsing azs: %@", error);
        
    } else {
        
        NSLog(@"Parsing azs: OK!");
        
//        NSArray *sortedArray;
//        sortedArray = [self.azsjson sortedArrayUsingComparator:^NSComparisonResult(id a, id b) {
//            NSDictionary *first = (NSDictionary*)a;
//            NSDictionary *second = (NSDictionary*)b;
//            NSString* s1 = [first valueForKey:STATION_TITLE];
//            NSString* s2 = [second valueForKey:STATION_TITLE];
//            return [s1 compare:s2];
//        }];
//
////        NSLog(@"azsjson: %@", sortedArray);
//        
//        self.sortedazsjson = sortedArray;

        [self filterOnSelectedCity];
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
    d = [NSJSONSerialization JSONObjectWithData:tardata options:NSDataReadingUncached error:&error];
    self.fueljson = [d objectForKey:FUEL_VALUES];
    
    if (!self.fueljson) {
        
        NSLog(@"Error parsing fuel: %@", error);
        
    } else {
        
        NSLog(@"Parsing fuel: OK!");
        //        NSLog(@"fueljson: %@", self.fueljson);
    }
    
    NSString* azsCity = [docpath stringByAppendingPathComponent:@"cities.json"];
    fe = [[NSFileManager defaultManager] fileExistsAtPath:azsCity];
    if(!fe) {
        
        NSString *appFile = [[NSBundle mainBundle] pathForResource:@"cities" ofType:@"json"];
        NSFileManager *fileManager = [NSFileManager defaultManager];
        NSError *error;
        [fileManager copyItemAtPath:appFile toPath:azsCity error:&error];
    }
    
    NSString *city= [NSString stringWithContentsOfFile:azsCity encoding:NSUTF8StringEncoding error:nil];
    tardata = [city dataUsingEncoding:NSUTF8StringEncoding];
    self.cityjson = [NSJSONSerialization JSONObjectWithData:tardata options:NSDataReadingUncached error:&error];
//    self.cityjson = [d objectForKey:FUEL_VALUES];
    
    if (!self.cityjson) {
        
        NSLog(@"Error parsing cities: %@", error);
        
    } else {
        
        NSLog(@"Parsing cities: OK!");
        //        NSLog(@"fueljson: %@", self.fueljson);
    }
    
    NSString* ab = [docpath stringByAppendingPathComponent:@"about.json"];
    fe = [[NSFileManager defaultManager] fileExistsAtPath:ab];
    if(!fe) {
        
        NSString *appFile = [[NSBundle mainBundle] pathForResource:@"about" ofType:@"json"];
        NSFileManager *fileManager = [NSFileManager defaultManager];
        NSError *error;
        [fileManager copyItemAtPath:appFile toPath:ab error:&error];
    }
    
    NSString* abf = [NSString stringWithContentsOfFile:ab encoding:NSUTF8StringEncoding error:nil];
    tardata = [abf dataUsingEncoding:NSUTF8StringEncoding];
    d = [NSJSONSerialization JSONObjectWithData:tardata options:NSDataReadingUncached error:&error];
    self.aboutjson = [d objectForKey:ABOUT_VALUES];
    
    if (!self.aboutjson) {
        
        NSLog(@"Error parsing about: %@", error);
        
    } else {
        
        NSLog(@"Parsing about: OK!");
//        NSLog(@"aboutjson: %@", self.aboutjson);
    }
    
    
//    [self parseNews];
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

    self.newsjson = [self.newsjson arrayByAddingObjectsFromArray:[NSJSONSerialization JSONObjectWithData:tardata options:NSDataReadingUncached error:&error]];
    
    //    NSLog(@"news = %@", d);
    if (!self.newsjson) {
        
        NSLog(@"Error parsing news: %@", error);
        
    } else {
        
        NSLog(@"Parsing news: OK!");
        
//        if(!self.lastNews) {

            int max = 0;
            int min = 1e4;
            for(NSDictionary* d in self.newsjson) {
                
                NSNumber* n = [d valueForKey:NEWS_ID];
                if(n.intValue > max) {
                    
                    max = n.intValue;
                    self.topnews = d;
                }
                if(n.intValue < min) {
                    
                    min = n.intValue;
                    self.lastNews = n.intValue;
                }
            }
            
//            NSLog(@"max = %d, min = %d", max, min);
//        }

    }
    
//    NSLog(@"topnews = %@", self.newsjson);

}

- (void) loadNewsData {
    
    NSArray* sp = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString* docpath = [sp objectAtIndex: 0];
    
    NSString* filePath = [docpath stringByAppendingPathComponent:@"news.json"];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
//    NSLog(@"--- load news from %d", self.lastNews);
    NSString* newsurl;
    if(self.lastNews) {
     
//        [request setURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%d", NEWS_URL_LAST, self.lastNews]]];
        newsurl = [NSString stringWithFormat:@"%@%d", NEWS_URL_LAST, self.lastNews];
    }
    else {

//        [request setURL:[NSURL URLWithString:NEWS_URL]];
        newsurl = NEWS_URL;
    }
    
    NSString* la = @"&lang=ru";
    switch (self.lang) {
        case L_ENG:
            la = @"&lang=en";
            break;
        case L_KZ:
            la = @"&lang=kz";
            break;
        case L_RU:
            la = @"&lang=ru";
            break;
    }
    
    NSString* req = [newsurl stringByAppendingString:la];
    [request setURL:[NSURL URLWithString:req]];

    NSHTTPURLResponse* urlResponse = nil;
    NSError *error = nil;
    NSData* responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&urlResponse error:&error];
    if (responseData == nil) {
        if ((error != nil) && self.internetActive) {
            
            UIAlertView* dialog = [[UIAlertView alloc] init];
            [dialog setTitle:NSLocalizedString1(@"title_network_error", nil)];
            [dialog setMessage:NSLocalizedString1(@"network_error", nil)];
            [dialog addButtonWithTitle:@"OK"];
            [dialog show];
        }
    }
    else {
        
        [responseData writeToFile:filePath atomically:YES];
        NSLog(@"news loaded OK!");
    }
    
    [self parseNews];
    
}

- (int) getNewsCount {
    
    return self.newsjson.count;
}

- (NSDictionary*) getNewsAt:(int)n {
    
    return [self.newsjson objectAtIndex:n];
}

- (NSString*) getNewsActFullText:(int)n {
    
    NSString* res = @"";
//    NSDictionary* d = [self.newsjson objectAtIndex:n];
//    NSNumber* num = [d valueForKey:NEWS_ID];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];

    NSString* newsurl = [NSString stringWithFormat:@"%@%d", NEWS_URL_FULL, n];
    
//    [request setURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%d", NEWS_URL_FULL, n]]];
    
    NSString* la = @"&lang=ru";
    switch (self.lang) {
        case L_ENG:
            la = @"&lang=en";
            break;
        case L_KZ:
            la = @"&lang=kz";
            break;
        case L_RU:
            la = @"&lang=ru";
            break;
    }
    
    NSString* req = [newsurl stringByAppendingString:la];
    [request setURL:[NSURL URLWithString:req]];
   
    NSHTTPURLResponse* urlResponse = nil;
    NSError *error = nil;
    NSData* responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&urlResponse error:&error];
    if (responseData == nil) {
        if ((error != nil) && self.internetActive) {
            
            UIAlertView* dialog = [[UIAlertView alloc] init];
            [dialog setTitle:NSLocalizedString1(@"title_network_error", nil)];
            [dialog setMessage:NSLocalizedString1(@"network_error", nil)];
            [dialog addButtonWithTitle:@"OK"];
            [dialog show];
        }
    }
    else {
        
        NSArray* arr = [NSJSONSerialization JSONObjectWithData:responseData options:NSDataReadingUncached error:&error];
        
//        NSLog(@"dic = %@", dic);
        if (!arr) {
            
            NSLog(@"Error parsing FULL text: %@", error);
            
        } else {
            
            NSLog(@"Parsing FULL text: OK!");
            NSDictionary* dic = [arr objectAtIndex:0];
            res = [dic objectForKey:NEWS_FULLTEXT];
        }
    }

    NSString *myHTML = [NSString stringWithFormat:@"<html> \n"
                        "<head> \n"
                        "<style type=\"text/css\"> \n"
                        "body {font-family: \"%@\"; font-size: %@; line-height:1.4;}\n"
                        "</style> \n"
                        "</head> \n"
                        "<body>%@</body> \n"
                        "</html>", @"HelveticaNeueCyr-Light", [NSNumber numberWithInt:13], res];
    return myHTML;
}

- (void) parseActs {
    
    NSArray* sp = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString* docpath = [sp objectAtIndex: 0];
    NSString* news = [docpath stringByAppendingPathComponent:@"acts.json"];
    BOOL fe = [[NSFileManager defaultManager] fileExistsAtPath:news];
    if(!fe) {
        
        NSString *appFile = [[NSBundle mainBundle] pathForResource:@"acts" ofType:@"json"];
        NSFileManager *fileManager = [NSFileManager defaultManager];
        NSError *error;
        [fileManager copyItemAtPath:appFile toPath:news error:&error];
    }
    
    NSString *fnews= [NSString stringWithContentsOfFile:news encoding:NSUTF8StringEncoding error:nil];
    NSData* tardata = [fnews dataUsingEncoding:NSUTF8StringEncoding];
    NSError* error;
    
    self.actsjson = [self.actsjson arrayByAddingObjectsFromArray:[NSJSONSerialization JSONObjectWithData:tardata options:NSDataReadingUncached error:&error]];
    
    if (!self.actsjson) {
        
        NSLog(@"Error parsing actions: %@", error);
        
    } else {
        
        NSLog(@"Parsing actions: OK!");
        
        int max = 0;
        int min = 1e4;
        for(NSDictionary* d in self.actsjson) {
            
            NSNumber* n = [d valueForKey:NEWS_ID];
            if(n.intValue > max) {
                
                max = n.intValue;
                self.topact = d;
            }
            if(n.intValue < min) {
                
                min = n.intValue;
                self.lastAct = n.intValue;
            }
        }
        
    }
    
}

- (void) loadActsData {
    
    NSArray* sp = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString* docpath = [sp objectAtIndex: 0];
    
    NSString* filePath = [docpath stringByAppendingPathComponent:@"acts.json"];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    NSString* actsurl;
    if(self.lastAct) {
        
//        [request setURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%d", ACTS_URL_LAST, self.lastAct]]];
        actsurl = [NSString stringWithFormat:@"%@%d", ACTS_URL_LAST, self.lastAct];
    }
    else {
     
//        [request setURL:[NSURL URLWithString:ACTS_URL]];
        actsurl = ACTS_URL;
    }
    
    NSString* la = @"&lang=ru";
    switch (self.lang) {
        case L_ENG:
            la = @"&lang=en";
            break;
        case L_KZ:
            la = @"&lang=kz";
            break;
        case L_RU:
            la = @"&lang=ru";
            break;
    }
    
    [request setURL:[NSURL URLWithString:[actsurl stringByAppendingString:la]]];

    NSHTTPURLResponse* urlResponse = nil;
    NSError *error = nil;
    NSData* responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&urlResponse error:&error];
    if (responseData == nil) {
        if ((error != nil) && self.internetActive) {
            
            UIAlertView* dialog = [[UIAlertView alloc] init];
            [dialog setTitle:NSLocalizedString1(@"title_network_error", nil)];
            [dialog setMessage:NSLocalizedString1(@"network_error", nil)];
            [dialog addButtonWithTitle:@"OK"];
            [dialog show];
        }
    }
    else {
        
        [responseData writeToFile:filePath atomically:YES];
        NSLog(@"actions loaded OK!");
    }
    
    [self parseActs];
    
}

- (int) getActsCount {
    
    return self.actsjson.count;
}

- (NSDictionary*) getActAt:(int)n {
    
    return [self.actsjson objectAtIndex:n];
}

- (int) getBranchesCount {
    
    return (self.aboutjson.count - 1);
}

- (NSDictionary*) getBranchAt:(int)n {
    
    int i = 0;
    NSDictionary* res = nil;
    for(NSDictionary* d in self.aboutjson) {
        
        NSNumber* nn = [d valueForKey:ABOUT_ID];
        if (nn.intValue == 1)
            continue;
        if(i == n) {
            res = d;
            break;
        }
        i++;
    }
    return res;
}

- (NSDictionary*) getBranchWithId:(int)n {
    
    NSDictionary* res = nil;
    for(NSDictionary* d in self.aboutjson) {
        
        NSNumber* nn = [d valueForKey:ABOUT_ID];
        if (nn.intValue == n) {
            
            res = d;
            break;
        }
    }
    return res;
}

- (void) loadAboutData {
    
    NSArray* sp = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString* docpath = [sp objectAtIndex: 0];
    
    NSString* filePath = [docpath stringByAppendingPathComponent:@"about.json"];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    
    NSString* la = @"&lang=ru";
    switch (self.lang) {
        case L_ENG:
            la = @"&lang=en";
            break;
        case L_KZ:
            la = @"&lang=kz";
            break;
        case L_RU:
            la = @"&lang=ru";
            break;
    }
    [request setURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", ABOUT_URL, la]]];
    
    NSHTTPURLResponse* urlResponse = nil;
    NSError *error = nil;
    NSData* responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&urlResponse error:&error];
    if (responseData == nil) {
        if ((error != nil) && self.internetActive) {
            
            UIAlertView* dialog = [[UIAlertView alloc] init];
            [dialog setTitle:NSLocalizedString1(@"title_network_error", nil)];
            [dialog setMessage:NSLocalizedString1(@"network_error", nil)];
            [dialog addButtonWithTitle:@"OK"];
            [dialog show];
        }
    }
    else {
        
        [responseData writeToFile:filePath atomically:YES];
        NSLog(@"abouts loaded OK!");
    }
    
}

- (void) loadAzsData {
    
    NSArray* sp = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString* docpath = [sp objectAtIndex: 0];
    
    NSString* filePath = [docpath stringByAppendingPathComponent:@"azs.json"];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    
//    [request setURL:[NSURL URLWithString:AZS_URL]];
    NSString* la = @"&lang=ru";
    switch (self.lang) {
        case L_ENG:
            la = @"&lang=en";
            break;
        case L_KZ:
            la = @"&lang=kz";
            break;
        case L_RU:
            la = @"&lang=ru";
            break;
    }
    [request setURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", AZS_URL, la]]];

    NSHTTPURLResponse* urlResponse = nil;
    NSError *error = nil;
    NSData* responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&urlResponse error:&error];
    if (responseData == nil) {
        if ((error != nil) && self.internetActive) {
            
            UIAlertView* dialog = [[UIAlertView alloc] init];
            [dialog setTitle:NSLocalizedString1(@"title_network_error", nil)];
            [dialog setMessage:NSLocalizedString1(@"network_error", nil)];
            [dialog addButtonWithTitle:@"OK"];
            [dialog show];
        }
    }
    else {
        
        [responseData writeToFile:filePath atomically:YES];
        NSLog(@"azss loaded OK!");
    }
    
}

- (void) loadFuelData {
    
    NSArray* sp = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString* docpath = [sp objectAtIndex: 0];
    
    NSString* filePath = [docpath stringByAppendingPathComponent:@"fuel.json"];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    
//    [request setURL:[NSURL URLWithString:FUEL_URL]];
    NSString* la = @"&lang=ru";
    switch (self.lang) {
        case L_ENG:
            la = @"&lang=en";
            break;
        case L_KZ:
            la = @"&lang=kz";
            break;
        case L_RU:
            la = @"&lang=ru";
            break;
    }
    [request setURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", FUEL_URL, la]]];
    
    NSHTTPURLResponse* urlResponse = nil;
    NSError *error = nil;
    NSData* responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&urlResponse error:&error];
    if (responseData == nil) {
        if ((error != nil) && self.internetActive) {
            
            UIAlertView* dialog = [[UIAlertView alloc] init];
            [dialog setTitle:NSLocalizedString1(@"title_network_error", nil)];
            [dialog setMessage:NSLocalizedString1(@"network_error", nil)];
            [dialog addButtonWithTitle:@"OK"];
            [dialog show];
        }
    }
    else {
        
        [responseData writeToFile:filePath atomically:YES];
        NSLog(@"fuels loaded OK!");
    }
    
}

- (void) loadCityData {
    
    NSArray* sp = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString* docpath = [sp objectAtIndex: 0];
    
    NSString* filePath = [docpath stringByAppendingPathComponent:@"cities.json"];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    
//    [request setURL:[NSURL URLWithString:CITIES_URL]];
    NSString* la = @"&lang=ru";
    switch (self.lang) {
        case L_ENG:
            la = @"&lang=en";
            break;
        case L_KZ:
            la = @"&lang=kz";
            break;
        case L_RU:
            la = @"&lang=ru";
            break;
    }
    [request setURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", CITIES_URL, la]]];
   
    NSHTTPURLResponse* urlResponse = nil;
    NSError *error = nil;
    NSData* responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&urlResponse error:&error];
    if (responseData == nil) {
        if ((error != nil) && self.internetActive) {
            
            UIAlertView* dialog = [[UIAlertView alloc] init];
            [dialog setTitle:NSLocalizedString1(@"title_network_error", nil)];
            [dialog setMessage:NSLocalizedString1(@"network_error", nil)];
            [dialog addButtonWithTitle:@"OK"];
            [dialog show];
        }
    }
    else {
        
        [responseData writeToFile:filePath atomically:YES];
        NSLog(@"cities loaded OK!");
    }
    
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

- (void) setAllNeedDistancesUpdate {
 
    NSLog(@"--Distances update!");
    
    NSMutableDictionary* new = [NSMutableDictionary dictionary];
    for (NSDictionary* d in self.azsjson) {
        
        NSNumber* lat = [d valueForKey:STATION_LAT];
        NSNumber* lon = [d valueForKey:STATION_LON];
        NSString* n = [d valueForKey:STATION_ID];

        NSDictionary* dcurr = [self.azsDistances objectForKey:n];
        NSNumber* res = [dcurr valueForKey:AZS_DIST];
        
        NSMutableDictionary* item = [NSMutableDictionary dictionary];
        [item setObject:res forKey:AZS_DIST];
        [item setObject:[NSNumber numberWithInt:1] forKey:AZS_NEEDUPDATE];
        [item setObject:lat forKey:AZS_LAT];
        [item setObject:lon forKey:AZS_LON];
        
        [new setObject:item forKey:n];
    }

    self.azsDistances = new;
}

//- (float) calculateDistTo: (CLLocationCoordinate2D) t {
- (float) calculateDistToStation: (int) station_id {
    
    float rrr;
    
//    @synchronized(self)
//	{
//    NSLog(@"dict = %@", self.azsDistances);
    
    NSNumber *n = [NSNumber numberWithInt:station_id];
    NSDictionary* d = [self.azsDistances objectForKey:n.stringValue];
//    NSLog(@"dict = %@", d);
    NSNumber* nu = [d valueForKey:AZS_NEEDUPDATE];
    
    if(!nu.intValue) {
        
        NSNumber* res = [d valueForKey:AZS_DIST];
        return res.floatValue;
    }
    
    NSNumber* nlat = [d valueForKey:AZS_LAT];
    CLLocationDegrees lat = nlat.doubleValue;
    NSNumber* nlon = [d valueForKey:AZS_LON];
    CLLocationDegrees lon = nlon.doubleValue;
    CLLocationCoordinate2D t = { lat, lon };
    
	NSString* apiResponse = [Common callMapServiceFrom:self.userCoordinate to:t];
    
    NSString* ar1 = [[apiResponse componentsSeparatedByString:@"("] objectAtIndex:1];
//    NSString* ar2 = [[ar1 componentsSeparatedByString:@" "] objectAtIndex:0];
    NSString* ar2 = [ar1 stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSString* ar3 = [ar2 stringByReplacingOccurrencesOfString:@"," withString:@"."];
    
    rrr = [ar3 floatValue];

//    NSLog(@"--- TO %d resp: %f", station_id, rrr);

    NSMutableDictionary* item = [NSMutableDictionary dictionary];
    [item setObject:[NSNumber numberWithFloat:rrr] forKey:AZS_DIST];
    [item setObject:[NSNumber numberWithInt:0] forKey:AZS_NEEDUPDATE];
    [item setObject:nlat forKey:AZS_LAT];
    [item setObject:nlon forKey:AZS_LON];
    
    [self.azsDistances setObject:item forKey:n.stringValue];
   
//    NSLog(@"calculateDistToStation: %@  %f", n, rrr);
//    }//synchronized
    return rrr;
}

- (float) distToNearestStaionWithFuelBit:(int)bit forCell:(PriceCell*)pc {
    
    float mindist = 1e8;
    for (NSDictionary* d in self.azsjson) {
        
        int fuel = ((NSNumber*)[d valueForKey:STATION_FUEL]).intValue;
        if(! (fuel & bit))
            continue;
        
//        NSNumber* n = [d valueForKey:STATION_LAT];
//        CLLocationDegrees lat = n.doubleValue;
//        n = [d valueForKey:STATION_LON];
//        CLLocationDegrees lon = n.doubleValue;
//        CLLocationCoordinate2D coord = { lat, lon };

        NSNumber* n = [d valueForKey:STATION_ID];
        
//        float dist = [self calculateDistTo:coord];
        float dist = [self calculateDistToStation:n.intValue];
        if (dist < mindist) {
            
            mindist = dist;
//            NSNumber* n = [d valueForKey:STATION_ID];
            pc.stationId = n.intValue;
            
//            NSLog(@"bit = %d, station = %d", bit, n.intValue);

        }
    }
    
    return mindist;
}

- (void) increment {
    
    @synchronized(self) {
        
        self.dist_upd_cnt ++;
//        NSLog(@"count = %d %d", self.dist_upd_cnt, self.azsjson.count);
        if (self.dist_upd_cnt >= self.azsjson.count) {
            
            for (int i = 0; i < 100; i++) {

                dispatch_semaphore_signal([Common instance].allowSemaphore);
            }

            NSLog(@"all dists updated");
            
            self.freeOfSems = YES;
        }
    }
}

- (void) fillDists {
//    int i = 0;
//    for (NSDictionary* d in self.azsjson) {
//        
//        NSNumber* n = [d valueForKey:STATION_ID];
//        i++;
//    }
//    NSLog(@"i = %d", i);
    
    self.dist_upd_cnt = 0;
    for (NSDictionary* d in self.azsjson) {
        
        NSNumber* n = [d valueForKey:STATION_ID];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^(void) {
       
//            NSLog(@"---- %d", n.intValue);
            [self calculateDistToStation:n.intValue];
//            NSLog(@"++++ %d", n.intValue);
            [self increment];
        });
    }
}

- (NSString*) getStringForKey:(NSString*)key {
    
//    NSLog(@"++");
//    if(self.languageBundle == nil)
//        return NSLocalizedString(key, nil);
    
    return NSLocalizedStringFromTableInBundle(key, nil, self.languageBundle, nil);
    
}

+ (NSArray*) calculateRoutesFrom:(CLLocationCoordinate2D) f to: (CLLocationCoordinate2D) t {
    
    NSArray* res = nil;
    @try {
        NSString* apiResponse = [Common callMapServiceFrom:f to:t];
        NSRange r1 = [apiResponse rangeOfString:@"points:" options:NSCaseInsensitiveSearch];
        NSRange r2 = [apiResponse rangeOfString:@"levels:" options:NSCaseInsensitiveSearch];
        NSString* encodedPoints = [apiResponse substringWithRange:NSMakeRange(r1.location + 8, r2.location - r1.location - 10)];
        
        res = [Common decodePolyLine:[encodedPoints mutableCopy]];
    }
    @catch (NSException *exception) {
//        NSLog(@"---+++ catched");
    }
    @finally {
    }
	return res;
}

- (void) regDeviceForPush:(NSString*)dev_id {
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:[NSString stringWithFormat:DEVICE_REG_URL, dev_id]]];
    
    NSHTTPURLResponse* urlResponse = nil;
    NSError *error = nil;
    NSData* responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&urlResponse error:&error];
    if (responseData == nil) {
        if ((error != nil) && self.internetActive) {
            
            UIAlertView* dialog = [[UIAlertView alloc] init];
            [dialog setTitle:NSLocalizedString1(@"title_network_error", nil)];
            [dialog setMessage:NSLocalizedString1(@"network_error", nil)];
            [dialog addButtonWithTitle:@"OK"];
            [dialog show];
        }
    }
    else {
        
        NSString* newStr = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
        NSLog(@"device registered OK: %@", newStr);
    }
    
    self.deviceId = dev_id;
}

- (NSString*) getCurrentCityName {
    
    NSString* s = NSLocalizedString(@"AllCities", nil);
    if(self.selectedCity >= 0) {
        
        NSDictionary* d = [[Common instance].cityjson objectAtIndex:self.selectedCity];
        s = [d valueForKey:CITY_NAME];
    }
    return s;
}

- (int) getCurrentCityId {
    
    int s = -1;
    if(self.selectedCity >= 0) {
        
        NSDictionary* d = [[Common instance].cityjson objectAtIndex:self.selectedCity];
        NSNumber* ns = [d valueForKey:CITY_ID];
        s = ns.intValue;
    }
    return s;
}

- (CLLocationCoordinate2D) getCurrentCityCoord {

    CLLocationCoordinate2D s = {43.240682, 76.892621};
    if(self.selectedCity >= 0) {
        
        NSDictionary* d = [[Common instance].cityjson objectAtIndex:self.selectedCity];
        
        NSNumber* n = [d valueForKey:CITY_LAT];
        CLLocationDegrees lat = n.doubleValue;
        n = [d valueForKey:CITY_LON];
        CLLocationDegrees lon = n.doubleValue;
        CLLocationCoordinate2D coord = { lat, lon };
        s = coord;
    }
    return s;
}

- (void) filterOnSelectedCity {
    
    NSArray *sortedArray;
    sortedArray = [self.azsjson sortedArrayUsingComparator:^NSComparisonResult(id a, id b) {
        NSDictionary *first = (NSDictionary*)a;
        NSDictionary *second = (NSDictionary*)b;
        
        float distance1 = -1;
        NSNumber* id1 = [first valueForKey:STATION_ID];
        NSDictionary* dic1 = [self.azsDistances objectForKey:id1];
        if(dic1) {
            
            NSNumber* nu1 = [dic1 valueForKey:AZS_NEEDUPDATE];
            if(!nu1.intValue) {
                
                NSNumber* dist1 = [dic1 valueForKey:AZS_DIST];
                distance1 = dist1.floatValue;
            }
        }
        float distance2 = -1;
        NSNumber* id2 = [second valueForKey:STATION_ID];
        NSDictionary* dic2 = [self.azsDistances objectForKey:id2];
        if(dic2) {
            
            NSNumber* nu2 = [dic2 valueForKey:AZS_NEEDUPDATE];
            if(!nu2.intValue) {
                
                NSNumber* dist2 = [dic2 valueForKey:AZS_DIST];
                distance2 = dist2.floatValue;
            }
        }

//        NSLog(@"%f, %f", distance1, distance2);
        if ((distance2 < 0.1f) && (distance1 > 0.1f)) {
            
            return NSOrderedAscending;
        }
        if ((distance1 < 0.1f) && (distance2 > 0.1f)) {
            
            return NSOrderedDescending;
        }
        if ((distance1 > 0.1f) && (distance2 > 0.1f)) {
            
            return [[NSNumber numberWithFloat:distance1] compare:[NSNumber numberWithFloat:distance2]];
        }
        
        NSString* s1 = [first valueForKey:STATION_TITLE];
        NSString* s2 = [second valueForKey:STATION_TITLE];
        return [s1 compare:s2];
    }];
    
    NSMutableArray* resarr = [NSMutableArray array];
    int cid = [self getCurrentCityId];
    for(NSDictionary* d in sortedArray) {
    
        NSNumber* n = [d valueForKey:STATION_CITY];
        if((cid < 0) || (n.intValue == cid)) {
            
            [resarr addObject:d];
        }
    }
    self.sortedazsjson = resarr;
}


- (void) sendMessage:(NSString*) msg {

    NSDate* now = [NSDate date];
    NSString* params = [NSString stringWithFormat:@"message=%@&time=%f", msg, 1000.0f * now.timeIntervalSince1970];
    NSURL* url = [NSURL URLWithString:[NSString stringWithFormat:SEND_MSG_URL, self.deviceId]];
    NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:url];
    request.HTTPMethod = @"POST";
    request.HTTPBody = [params dataUsingEncoding:NSUTF8StringEncoding];
    
    NSHTTPURLResponse* urlResponse = nil;
    NSError *error = nil;
    NSData* responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&urlResponse error:&error];
    if (responseData == nil) {
        if ((error != nil) && self.internetActive) {
            
            UIAlertView* dialog = [[UIAlertView alloc] init];
            [dialog setTitle:NSLocalizedString1(@"title_network_error", nil)];
            [dialog setMessage:NSLocalizedString1(@"network_error", nil)];
            [dialog addButtonWithTitle:@"OK"];
            [dialog show];
        }
    }
    else {
        
        NSString* newStr = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
        NSLog(@"sendMessage OK: %@", newStr);
    }

}

- (NSArray*) recvMessage {

    NSArray* result = [NSArray array];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:[NSString stringWithFormat:RECV_MSG_URL, self.deviceId, self.lastMsg]]];
    
    NSHTTPURLResponse* urlResponse = nil;
    NSError *error = nil;
    NSData* responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&urlResponse error:&error];
    if (responseData == nil) {
        if ((error != nil) && self.internetActive) {
            
            UIAlertView* dialog = [[UIAlertView alloc] init];
            [dialog setTitle:NSLocalizedString1(@"title_network_error", nil)];
            [dialog setMessage:NSLocalizedString1(@"network_error", nil)];
            [dialog addButtonWithTitle:@"OK"];
            [dialog show];
        }
    }
    else {
        
        @try {
            
            NSString* newStr = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
//            NSLog(@"recvMessage OK: %@", newStr);
            
            NSError* error;
//            NSData* tardata = [fnews dataUsingEncoding:NSUTF8StringEncoding];
            result = [NSJSONSerialization JSONObjectWithData:responseData options:NSDataReadingUncached error:&error];
            
            for(NSDictionary* d in result) {
                
                NSNumber* i = [d valueForKey:CHAT_ID];
                if(i.intValue > self.lastMsg) {
                    
                    self.lastMsg = i.intValue;
                }
            }
//            if (!result) {
//                
//                NSLog(@"Error parsing chat: %@", error);
//                
//            } else {
//                
//                NSLog(@"Parsing chat: OK!");
//            }
            
            
        } @catch (NSException * e) {
            NSLog(@"Exception2: %@", e);
        } @finally {
            //NSLog(@"finally");
        }
    }
    
    return result;
}

@end
