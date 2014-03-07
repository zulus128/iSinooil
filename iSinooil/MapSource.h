//
//  MapSource.h
//  iSinooil
//
//  Created by вадим on 1/3/14.
//  Copyright (c) 2014 Zul. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

enum { MAPTYPE_MAINMENU, MAPTYPE_FULLWINDOW };

@class MapViewController;

@interface MapSource : NSObject <MKMapViewDelegate> {
    
    int type;
    BOOL fsttime;
}

-(id) initWithType:(int)typ;
- (void)refreshPins;

@property (weak, nonatomic) MapViewController* mapcontr;

@end
