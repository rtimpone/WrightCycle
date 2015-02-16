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


NSString * const kDivvyStationsJsonFeedUrlString = @"http://www.divvybikes.com/stations/json";

//The key used to store an array of station ids in user defaults representing the user's favorite stations
NSString * const kFavoriteStations = @"kFavoriteStations";

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

#pragma mark - Divvy API Methods

- (NSArray *)getStationsListWithSuccess: (void (^)(NSArray *))success failure: (void (^)(NSError *))failure
{
    if ([self shouldRefreshStations])
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

#pragma mark - Favorite Stations Methods

//The array of favorite station ids stored in user defaults
- (NSArray *)fetchFavoriteStationsIds
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSArray *favoriteStationIds = [defaults objectForKey: kFavoriteStations];
    
    if (!favoriteStationIds)
    {
        favoriteStationIds = @[];
    }
    
    return favoriteStationIds;
}

- (NSArray *)fetchFavoriteStations
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSArray *favoriteStationIds = [defaults objectForKey: kFavoriteStations];
    
    NSMutableArray *favoriteStations = [[NSMutableArray alloc] init];
    for (NSNumber *stationId in favoriteStationIds)
    {
        NSPredicate *predicate = [NSPredicate predicateWithFormat: @"stationId = %@", stationId];
        WRCStation *station = [[self.cachedStations filteredArrayUsingPredicate: predicate] firstObject];
        [favoriteStations addObject: station];
    }
    
    return favoriteStations;
}

- (void)addStationAsFavorite: (WRCStation *)station
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSArray *favoriteStationIds = [self fetchFavoriteStationsIds];

    NSMutableArray *mutableFavoriteStationIds = [favoriteStationIds mutableCopy];
    [mutableFavoriteStationIds addObject: station.stationId];
    
    [defaults setObject: mutableFavoriteStationIds forKey: kFavoriteStations];
    [defaults synchronize];
}

- (void)removeStationFromFavorites: (WRCStation *)station
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSArray *favoriteStationIds = [self fetchFavoriteStationsIds];
    
    NSMutableArray *mutableFavoriteStationIds = [favoriteStationIds mutableCopy];
    [mutableFavoriteStationIds removeObject: station.stationId];
    
    [defaults setObject: mutableFavoriteStationIds forKey: kFavoriteStations];
    [defaults synchronize];
}

- (BOOL)stationIsFavorite: (WRCStation *)station
{
    NSArray *favoriteStationIds = [self fetchFavoriteStationsIds];
    return [favoriteStationIds containsObject: station.stationId];
}

@end
