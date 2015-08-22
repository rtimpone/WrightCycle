//
//  AppDelegate.m
//  WrightCycle
//
//  Created by Rob Timpone on 2/14/15.
//  Copyright (c) 2015 Rob Timpone. All rights reserved.
//

#import "AppDelegate.h"
#import "WRCAutoRefreshDataManager.h"
#import "UIColor+WRCAdditions.h"

@interface AppDelegate ()

@property (strong, nonatomic) WRCAutoRefreshDataManager *autoRefreshManager;

@end

@implementation AppDelegate

- (BOOL)application: (UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    //custom navigation bar title font and text color
    UIColor *navBarTitleColor = [UIColor mediumGreyColor];
    UIFont *navBarTitleFont = [UIFont fontWithName: @"Oswald-Light" size: 20];
    [[UINavigationBar appearance] setTitleTextAttributes: @{ NSForegroundColorAttributeName : navBarTitleColor,
                                                             NSFontAttributeName : navBarTitleFont }];
    
    //setup the manager that handles automatically refreshing station and app configuration data
    self.autoRefreshManager = [[WRCAutoRefreshDataManager alloc] init];
    
    return YES;
}

- (void)applicationWillResignActive: (UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    
    [self.autoRefreshManager endAutoRefreshing];
}

- (void)applicationDidEnterBackground: (UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground: (UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive: (UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    
    [self.autoRefreshManager beginAutoRefreshing];
}

- (void)applicationWillTerminate: (UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
