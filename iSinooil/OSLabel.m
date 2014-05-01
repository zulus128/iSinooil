//
//  OSLabel.m
//  iSinooil
//
//  Created by вадим on 5/1/14.
//  Copyright (c) 2014 Zul. All rights reserved.
//

#import "OSLabel.h"

@implementation OSLabel

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.edgeInsets = UIEdgeInsetsMake(0, 0, 0, 20);
    }
    return self;
}

- (void)drawTextInRect:(CGRect)rect {
    [super drawTextInRect:UIEdgeInsetsInsetRect(rect, self.edgeInsets)];
}

@end
