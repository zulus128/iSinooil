//
//  Common.h
//  iSinooil
//
//  Created by вадим on 1/2/14.
//  Copyright (c) 2014 Zul. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Common : NSObject

+ (CGSize) currentScreenBoundsDependOnOrientation:(UIInterfaceOrientation) interfaceOrientation;
+ (CGSize) currentScreenBounds;

@end
