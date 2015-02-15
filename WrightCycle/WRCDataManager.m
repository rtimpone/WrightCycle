//
//  WRCDataManager.m
//  WrightCycle
//
//  Created by Rob Timpone on 2/14/15.
//  Copyright (c) 2015 Rob Timpone. All rights reserved.
//

#import <Reachability/Reachability.h>
#import "WRCDataManager.h"
#import "WRCStation.h"

@interface WRCDataManager ()

/** The most recent list of stations from the API */
@property (strong, nonatomic) NSArray *cachedStations;

/** The last time a successful data refresh was made */
@property (strong, nonatomic) NSDate *lastRefreshDate;

@end


#define STATIONS_JSON_URL_STRING @"http://www.divvybikes.com/stations/json"

//The Divvy API only updates its JSON feed once a minute
#define SECONDS_TO_WAIT_BEFORE_REFRESHING_DATA 60

@implementation WRCDataManager

+ (instancetype)sharedManager
{
    static WRCDataManager *sharedManager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager = [[WRCDataManager alloc] init];
    });
    return sharedManager;
}

+ (BOOL)internetConnectionIsAvailable
{
    Reachability *reachabilty = [Reachability reachabilityForInternetConnection];
    return reachabilty.isReachable;
}

- (NSArray *)getStationsListWithSuccess: (void (^)(NSArray *))success failure: (void (^)(NSError *))failure
{
    if ([self shouldRefreshStations])
    {
        NSURL *url = [NSURL URLWithString: STATIONS_JSON_URL_STRING];
        NSURLSessionDataTask *task = [[NSURLSession sharedSession] dataTaskWithURL: url completionHandler: ^(NSData *data, NSURLResponse *response, NSError *error) {
            
            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible: NO];
            
            if (error && failure)
            {
                failure(error);
            }
            else
            {
                //extract the array of station dictionaries from the API response
                NSDictionary *json = [NSJSONSerialization JSONObjectWithData: data options: 0 error: nil];
                NSArray *stationDictionaries = json[@"stationBeanList"];
                
                //convert the dictionaries into station objects
                NSMutableArray *stations = [[NSMutableArray alloc] init];
                for (NSDictionary *stationDictionary in stationDictionaries)
                {
                    WRCStation *station = [WRCStation stationFromDictionary: stationDictionary];
                    [stations addObject: station];
                }
                
                self.lastRefreshDate = [NSDate date];
                self.cachedStations = stations;
                
                success(stations);
            }
        }];
        
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible: YES];
        [task resume];
    }
    
    //return the currently cached list of stations immediately
    return self.cachedStations;
}

//An API request should only be made if we don't have any data yet or if 60 seconds has elapsed since the last data refresh
- (BOOL)shouldRefreshStations
{
    BOOL thisIsTheFirstRefresh = !self.lastRefreshDate;
    BOOL enoughTimeHasElapsedToRefresh = -[self.lastRefreshDate timeIntervalSinceNow] >= SECONDS_TO_WAIT_BEFORE_REFRESHING_DATA;
    
    return thisIsTheFirstRefresh || enoughTimeHasElapsedToRefresh;
}

@end
