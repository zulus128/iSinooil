//
//  AppDelegate.m
//  iSinooil
//
//  Created by Zul on 11/24/13.
//  Copyright (c) 2013 Zul. All rights reserved.
//

#import "AppDelegate.h"
#import "TestFlight.h"
#import "Common.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    [TestFlight takeOff:@"9be99990-d71e-41b7-bc03-27c53dee6d2e"];
    
    
//    [application setStatusBarHidden:NO];
//    [application setStatusBarStyle:UIStatusBarStyleDefault];
//    [[UINavigationBar appearance] setBarStyle:UIBarStyleBlack];
//    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];

    // Регистируем девайс на приём push-уведомлений
    [[UIApplication sharedApplication] registerForRemoteNotificationTypes: (UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert)];
    
    return YES;
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken  {

//    NSString* newStr = [[NSString alloc] initWithData:deviceToken encoding:NSUTF8StringEncoding];
    NSLog(@"My PUSH token is: %@", deviceToken);
    NSString * tokenAsString = [[[deviceToken description]
                                 stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]]
                                stringByReplacingOccurrencesOfString:@" " withString:@""];
    [[Common instance] regDeviceForPush:tokenAsString];
    [[NSUserDefaults standardUserDefaults] setObject:tokenAsString forKey:DEVICE_TOKEN];
    NSLog(@"My PUSH token is: %@", tokenAsString);

}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    
    NSLog(@"Failed to get PUSH token, error: %@", error);
    [[Common instance] regDeviceForPush:PUSH_ID_FOR_SIMULATOR];
   [[NSUserDefaults standardUserDefaults] setObject:PUSH_ID_FOR_SIMULATOR forKey:DEVICE_TOKEN];

}

- (void) application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {

//    NSLog(@"Received PUSH notification: %@", userInfo);
    
    NSDictionary* apsInfo = [userInfo objectForKey:@"aps"];
    NSString* alert = [apsInfo objectForKey:@"alert"];
    UIAlertView* dialog = [[UIAlertView alloc] init];
    [dialog setTitle:@"Push Message"];
    [dialog setMessage:alert];
    [dialog addButtonWithTitle:@"OK"];
    [dialog show];
    
//    NSString *badge = [apsInfo objectForKey:@"badge"];
//    NSLog(@"Received Push Badge: %@", badge);
//    int currentBadgeNumber = application.applicationIconBadgeNumber;
//    currentBadgeNumber += [[apsInfo objectForKey:@"badge"] integerValue];
//    application.applicationIconBadgeNumber = currentBadgeNumber;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
