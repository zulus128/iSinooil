//
//  MapPoint.m
//  iSinooil
//
//  Created by вадим on 1/3/14.
//  Copyright (c) 2014 Zul. All rights reserved.
//

#import "MapPoint.h"

@implementation MapPoint

@synthesize title,coordinate,subtitle;

-(id) initWithCoordinate:(CLLocationCoordinate2D)c title:(NSString*)t subTitle:(NSString *) st {

    coordinate = c;
    [self setTitle:t];
    [self setSubtitle:st];
    return self;
    
}


@end
