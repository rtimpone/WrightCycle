//
//  AppDelegate.m
//  WrightCycle
//
//  Created by Rob Timpone on 2/14/15.
//  Copyright (c) 2015 Rob Timpone. All rights reserved.
//

#import "AppDelegate.h"
#import "WRCiCloudRequestHandler.h"
#import "WRCStationsRequestHandler.h"

/** A notification that is posted when the configuration object is updated. The new configuration will be passed along with the notification. */
NSString * const kConfigurationUpdatedNotification = @"kConfigurationUpdatedNotification";

/** A notification that is posted when the stations are updated. The updated stations array will be passed along with the notification. */
NSString * const kStationsUpdatedNotification = @"kStationsUpdatedNotification";

@interface AppDelegate ()

///A timer that fires every 30 seconds to send a request to the Divvy API for updated station data
@property (strong, nonatomic) NSTimer *stationRefreshTimer;

@end

@implementation AppDelegate


- (BOOL)application: (UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    //custom navigation bar title font and text color
    UIColor *navBarTitleColor = [UIColor colorWithRed:62/255.0 green: 62/255.0 blue: 62/255.0 alpha: 1.0];
    UIFont *navBarTitleFont = [UIFont fontWithName: @"Oswald-Light" size: 20];
    [[UINavigationBar appearance] setTitleTextAttributes: @{ NSForegroundColorAttributeName : navBarTitleColor,
                                                             NSFontAttributeName : navBarTitleFont }];
    
    return YES;
}

- (void)applicationWillResignActive: (UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    
    [self.stationRefreshTimer invalidate];
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
    
    //Only request a configuration object refresh if enough time has passed
    if ([[WRCiCloudRequestHandler sharedManager] isReadyForRefresh] && [WRCiCloudRequestHandler internetConnectionIsAvailable])
    {
        //Refresh the configuration object that contains information about the Divvy account login page
        [[WRCiCloudRequestHandler sharedManager] getAppConfigurationWithSuccess: ^(WRCConfiguration *configuration) {
            NSLog(@"%@ %@: Configuration object retrieved", [self class], NSStringFromSelector(_cmd));
            [[NSNotificationCenter defaultCenter] postNotificationName: kConfigurationUpdatedNotification object: configuration];
        } failure:^(NSError *error) {
            NSLog(@"%@ %@: Error retrieving configuration: %@", [self class], NSStringFromSelector(_cmd), error);
        }];
    }
    
    //setup a timer to refresh station information every 30 seconds
    NSInteger timerInterval = [[WRCStationsRequestHandler sharedManager] secondsToWaitBeforeRefresh];
    self.stationRefreshTimer = [NSTimer scheduledTimerWithTimeInterval: timerInterval target: self selector: @selector(stationsRefreshTimerDidFire:) userInfo: nil repeats: YES];
}

- (void)applicationWillTerminate: (UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}
                                
#pragma mark - Timers

- (void)stationsRefreshTimerDidFire: (NSTimer *)timer
{
    if ([WRCStationsRequestHandler internetConnectionIsAvailable])
    {
        [[WRCStationsRequestHandler sharedManager] getStationsListImmediately: YES withSuccess: ^(NSArray *stations) {
            NSLog(@"%@ %@: Stations refreshed successfully", [self class], NSStringFromSelector(_cmd));
            [[NSNotificationCenter defaultCenter] postNotificationName: kStationsUpdatedNotification object: stations];
        } failure: ^(NSError *error) {
            NSLog(@"%@ %@: Error retrieving stations: %@", [self class], NSStringFromSelector(_cmd), error);
        }];
    }
}

@end
