//
//  Common.m
//  iSinooil
//
//  Created by вадим on 1/2/14.
//  Copyright (c) 2014 Zul. All rights reserved.
//

#import "Common.h"

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
        
        [self parseData];
        
	}
	return self;
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
    self.azsjson = [NSJSONSerialization JSONObjectWithData:tardata options:NSDataReadingUncached error:&error];
    
    if (!self.azsjson) {
        
        NSLog(@"Error parsing azs: %@", error);
        
    } else {
        
        NSLog(@"Parsing azs: OK!");
//        NSLog(@"azsjson: %@", [self.azsjson objectAtIndex:2]);
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

@end
