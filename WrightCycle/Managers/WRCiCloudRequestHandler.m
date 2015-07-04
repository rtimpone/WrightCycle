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

@end


@implementation WRCiCloudRequestHandler

#pragma mark - Request Handler Superclass

- (NSInteger)secondsToWaitBeforeRefresh
{
    return 15 * 60;
}

#pragma mark - iCloud Requests

- (void)getAppConfigurationWithSuccess: (void (^)(WRCConfiguration *configuration))success failure: (void (^)(NSError *error))failure
{
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible: YES];
    
    CKDatabase *publicCloudDatabase = [[CKContainer defaultContainer] publicCloudDatabase];
    NSPredicate *truePredicate = [NSPredicate predicateWithFormat: @"TRUEPREDICATE"];
    CKQuery *query = [[CKQuery alloc] initWithRecordType: @"configuration" predicate: truePredicate];
    [publicCloudDatabase performQuery: query inZoneWithID: nil completionHandler: ^(NSArray *results, NSError *error) {
        
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible: NO];
        
        //we don't care whether the request succeeded, we only want to make it once every 15 minutes
        self.lastRefreshDate = [NSDate date];
        
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
            
            success(configuration);
        }
    }];
}

@end
