//
//  WRCiCloudRequestHandler.m
//  WrightCycle
//
//  Created by Rob Timpone on 7/3/15.
//  Copyright (c) 2015 Rob Timpone. All rights reserved.
//

@import CloudKit;
@import UIKit;

#import "WRCConfiguration.h"
#import "WRCiCloudRequestHandler.h"

@interface WRCiCloudRequestHandler ()

/** The most recently retrieved configuration object */
@property (strong, nonatomic, readwrite) WRCConfiguration *cachedConfiguration;

/** The last time a successful configuration refresh was made */
@property (strong, nonatomic) NSDate *lastConfigurationRefreshDate;

@end


NSString * const kConfigurationUpdatedNotification = @"kConfigurationUpdatedNotification";

//The Divvy API only updates its JSON feed once a minute
#define SECONDS_TO_WAIT_BEFORE_REFRESHING_CONFIGURATION 15 * 60

@implementation WRCiCloudRequestHandler

- (void)getAppConfigurationWithSuccess: (void (^)(WRCConfiguration *configuration))success failure: (void (^)(NSError *error))failure
{
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible: YES];
    
    CKDatabase *publicCloudDatabase = [[CKContainer defaultContainer] publicCloudDatabase];
    NSPredicate *truePredicate = [NSPredicate predicateWithFormat: @"TRUEPREDICATE"];
    CKQuery *query = [[CKQuery alloc] initWithRecordType: @"configuration" predicate: truePredicate];
    [publicCloudDatabase performQuery: query inZoneWithID: nil completionHandler: ^(NSArray *results, NSError *error) {
        
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible: NO];
        
        if (error)
        {
            failure(error);
        }
        else
        {
            CKRecord *record = [results firstObject];
            WRCConfiguration *configuration = [WRCConfiguration configurationFromRecord: record];
            
            if (![self.cachedConfiguration isEqualToConfiguration: configuration])
            {
                self.cachedConfiguration = configuration;
            }
            
            self.lastConfigurationRefreshDate = [NSDate date];
            success(configuration);
        }
    }];
}

#pragma mark - Cooldown Period

//A configuration refresh should only be made if at least 15 minutes have passed since the last refresh attempt
- (BOOL)isReadyForConfigurationRefresh
{
    BOOL thisIsTheFirstRefresh = !self.lastConfigurationRefreshDate;
    BOOL enoughTimeHasElapsedToRefresh = -[self.lastConfigurationRefreshDate timeIntervalSinceNow] >= SECONDS_TO_WAIT_BEFORE_REFRESHING_CONFIGURATION;
    
    return thisIsTheFirstRefresh || enoughTimeHasElapsedToRefresh;
}

#pragma mark - Setters

//Post a notification when the configuration is updated
- (void)setCachedConfiguration:(WRCConfiguration *)cachedConfiguration
{
    _cachedConfiguration = cachedConfiguration;
    [[NSNotificationCenter defaultCenter] postNotificationName: kConfigurationUpdatedNotification object: cachedConfiguration];
}

@end
