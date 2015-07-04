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

@end


NSString * const kDivvyStationsJsonFeedUrlString = @"http://www.divvybikes.com/stations/json";

@implementation WRCStationsRequestHandler

#pragma mark - Request Handler Superclass

- (NSInteger)secondsToWaitBeforeRefresh
{
    return 60;
}

#pragma mark - Divvy API Requests

- (void)getStationsListWithSuccess: (void (^)(NSArray *stations))success failure: (void (^)(NSError *error))failure
{
    [self getStationsListImmediately: NO withSuccess: success failure: failure];
}

- (void)getStationsListImmediately: (BOOL)shouldMakeRequestImmediately withSuccess: (void (^)(NSArray *stations))success failure: (void (^)(NSError *error))failure
{
    if ([self isReadyForRefresh] || shouldMakeRequestImmediately)
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
                
                self.lastRefreshDate = [NSDate date];
                self.cachedStations = stations;
                
                success(stations);
            }
        }];
        
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible: YES];
        [task resume];
    }
}

@end
