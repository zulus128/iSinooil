//
//  WildcardGestureRecognizer.h
//  iSinooil
//
//  Created by вадим on 12/8/13.
//  Copyright (c) 2013 Zul. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^TouchesEventBlock)(NSSet * touches, UIEvent * event);

@interface WildcardGestureRecognizer : UIGestureRecognizer;

@property(copy) TouchesEventBlock touchesBeganCallback;


@end
