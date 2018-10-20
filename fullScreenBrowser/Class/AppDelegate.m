//
//  AppDelegate.m
//  fullScreenBrowser
//
//  Created by HTC on 14/12/7.
//  Copyright (c) 2014年 HTC. All rights reserved.
//

#import "AppDelegate.h"

#import "BaiduMobStat.h"
#import "Utility.h"


@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    [self startBaiduMobStat];
    
    return YES;
}


/**
 *  初始化百度统计SDK
 */
- (void)startBaiduMobStat {
    BaiduMobStat* statTracker = [BaiduMobStat defaultStat];
    // 此处(startWithAppId之前)可以设置初始化的可选参数，具体有哪些参数，可详见BaiduMobStat.h文件，例如：
    statTracker.shortAppVersion  = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    //    statTracker.enableDebugOn = YES;
    [statTracker startWithAppId:@"71ccc049f5"]; // 设置您在mtj网站上添加的app的appkey,此处AppId即为应用的appKey
    
#if DEBUG
    NSLog(@"Debug Model");
#else
    NSDateFormatter * df = [[NSDateFormatter alloc] init];
    df.locale = [NSLocale currentLocale];
    df.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    NSString *currentDate = [df stringFromDate:[NSDate new]];
    
    // 自定义事件
    [statTracker logEvent:@"usermodelName" eventLabel:[Utility getCurrentDeviceModel]];
    [statTracker logEvent:@"systemVersion" eventLabel:[[UIDevice currentDevice] systemVersion]];
    [statTracker logEvent:@"Devices" eventLabel:[[UIDevice currentDevice] name]];
    [statTracker logEvent:@"DateAndDeviceName" eventLabel:[NSString stringWithFormat:@"%@ %@", currentDate, [[UIDevice currentDevice] name]]];
    [statTracker logEvent:@"DateSystemVersion" eventLabel:[NSString stringWithFormat:@"%@ %@", currentDate, [[UIDevice currentDevice] systemVersion]]];
#endif
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
