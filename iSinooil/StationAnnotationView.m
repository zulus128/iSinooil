//
//  StationAnnotationView.m
//  iSinooil
//
//  Created by вадим on 1/3/14.
//  Copyright (c) 2014 Zul. All rights reserved.
//

#import "StationAnnotationView.h"

@implementation StationAnnotationView

- (id)initWithAnnotation:(id <MKAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier];
    if (self != nil) {
        
        CGRect frame = self.frame;
        frame.size = CGSizeMake(60.0, 60.0);
        self.frame = frame;
        self.backgroundColor = [UIColor clearColor];
//        self.centerOffset = CGPointMake(-5, -5);
        self.enabled = NO;
        
        self.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];

    }
    return self;
}

-(void) drawRect:(CGRect)rect {
    
    [[UIImage imageNamed:@"icon_fuel.png"] drawInRect:CGRectMake(15.0, 0.0, 30.0, 30.0)];
}

@end
