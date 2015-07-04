//
//  WRCAutoRefreshDataManager.m
//  WrightCycle
//
//  Created by Rob Timpone on 7/4/15.
//  Copyright (c) 2015 Rob Timpone. All rights reserved.
//

#import "WRCAutoRefreshDataManager.h"
#import "WRCiCloudRequestHandler.h"
#import "WRCStationsRequestHandler.h"

NSString * const kConfigurationUpdatedNotification = @"kConfigurationUpdatedNotification";
NSString * const kStationsUpdatedNotification = @"kStationsUpdatedNotification";

@interface WRCAutoRefreshDataManager ()

///A timer to get updated station data from the Divvy API
@property (strong, nonatomic) NSTimer *stationRefreshTimer;

///A timer to retrieve the configuration object from iCloud
@property (strong, nonatomic) NSTimer *configurationRefreshTimer;

@end

@implementation WRCAutoRefreshDataManager

- (void)beginAutoRefreshing
{
    NSInteger stationTimerInterval = [[WRCStationsRequestHandler sharedManager] secondsToWaitBeforeRefresh];
    self.stationRefreshTimer = [NSTimer scheduledTimerWithTimeInterval: stationTimerInterval
                                                                target: self
                                                              selector: @selector(stationsRefreshTimerDidFire:)
                                                              userInfo: nil
                                                               repeats: YES];
    
    NSInteger configurationTimerInterval = [[WRCiCloudRequestHandler sharedManager] secondsToWaitBeforeRefresh];
    self.configurationRefreshTimer = [NSTimer scheduledTimerWithTimeInterval: configurationTimerInterval
                                                                      target: self
                                                                    selector: @selector(configurationRefreshTimerDidFire:)
                                                                    userInfo: nil
                                                                     repeats: YES];
}

- (void)endAutoRefreshing
{
    [self.stationRefreshTimer invalidate];
    [self.configurationRefreshTimer invalidate];
}

#pragma mark - Timer Callbacks

- (void)stationsRefreshTimerDidFire: (NSTimer *)timer
{
    if ([WRCStationsRequestHandler internetConnectionIsAvailable])
    {
        [[WRCStationsRequestHandler sharedManager] getStationsListImmediately: YES withSuccess: ^(NSArray *stations) {
            
            NSLog(@"[%@ %@]: Stations refreshed successfully", [self class], NSStringFromSelector(_cmd));
            [[NSNotificationCenter defaultCenter] postNotificationName: kStationsUpdatedNotification object: stations];
            
        } failure: ^(NSError *error) {
            NSLog(@"[%@ %@]: Error retrieving stations: %@", [self class], NSStringFromSelector(_cmd), error);
        }];
    }
}

- (void)configurationRefreshTimerDidFire: (NSTimer *)timer
{
    if ([WRCiCloudRequestHandler internetConnectionIsAvailable])
    {
        [[WRCiCloudRequestHandler sharedManager] getAppConfigurationWithSuccess: ^(WRCConfiguration *configuration) {
            
            NSLog(@"[%@ %@]: Configuration object retrieved successfully", [self class], NSStringFromSelector(_cmd));
            [[NSNotificationCenter defaultCenter] postNotificationName: kConfigurationUpdatedNotification object: configuration];
            
        } failure:^(NSError *error) {
            NSLog(@"[%@ %@]: Error retrieving configuration: %@", [self class], NSStringFromSelector(_cmd), error);
        }];
    }
}

@end
