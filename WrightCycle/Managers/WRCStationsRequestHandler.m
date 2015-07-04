//
//  WRCStationsRequestHandler.m
//  WrightCycle
//
//  Created by Rob Timpone on 7/3/15.
//  Copyright (c) 2015 Rob Timpone. All rights reserved.
//

#import "WRCStation.h"
#import "WRCStationsRequestHandler.h"

@interface WRCStationsRequestHandler ()

/** The most recent list of stations from the API */
@property (strong, nonatomic, readwrite) NSArray *cachedStations;

/** The last time a successful data refresh was made */
@property (strong, nonatomic) NSDate *lastStationsRefreshDate;

@end


#define SECONDS_TO_WAIT_BEFORE_REFRESHING_STATION_DATA 60

NSString * const kDivvyStationsJsonFeedUrlString = @"http://www.divvybikes.com/stations/json";

@implementation WRCStationsRequestHandler

- (NSArray *)getStationsListWithSuccess: (void (^)(NSArray *stations))success failure: (void (^)(NSError *error))failure
{
    return [self getStationsListImmediately: NO withSuccess: success failure: failure];
}

- (NSArray *)getStationsListImmediately: (BOOL)shouldMakeRequestImmediately withSuccess: (void (^)(NSArray *stations))success failure: (void (^)(NSError *error))failure
{
    if ([self shouldRefreshStations] || shouldMakeRequestImmediately)
    {
        NSURL *url = [NSURL URLWithString: kDivvyStationsJsonFeedUrlString];
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
                
                self.lastStationsRefreshDate = [NSDate date];
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
    BOOL thisIsTheFirstRefresh = !self.lastStationsRefreshDate;
    BOOL enoughTimeHasElapsedToRefresh = -[self.lastStationsRefreshDate timeIntervalSinceNow] >= SECONDS_TO_WAIT_BEFORE_REFRESHING_STATION_DATA;
    
    return thisIsTheFirstRefresh || enoughTimeHasElapsedToRefresh;
}

- (NSArray *)fetchCachedStationsWithIds: (NSArray *)stationIds
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat: @"stationId IN %@", stationIds];
    return [self.cachedStations filteredArrayUsingPredicate: predicate];
}

@end
