//
//  WildcardGestureRecognizer.m
//  iSinooil
//
//  Created by вадим on 12/8/13.
//  Copyright (c) 2013 Zul. All rights reserved.
//

#import "WildcardGestureRecognizer.h"

@implementation WildcardGestureRecognizer

-(id) init{
    if (self = [super init])
    {
        self.cancelsTouchesInView = NO;
    }
    return self;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (self.touchesBeganCallback)
        self.touchesBeganCallback(touches, event);
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
}

- (void)reset
{
}

- (void)ignoreTouch:(UITouch *)touch forEvent:(UIEvent *)event
{
}

@end
