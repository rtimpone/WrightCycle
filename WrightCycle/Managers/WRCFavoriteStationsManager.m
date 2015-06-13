//
//  WRCFavoriteStationsManager.m
//  WrightCycle
//
//  Created by Rob Timpone on 6/13/15.
//  Copyright (c) 2015 Rob Timpone. All rights reserved.
//

#import "WRCNetworkingManager.h"
#import "WRCFavoriteStationsManager.h"
#import "WRCStation.h"

//The key used to store an array of station ids in user defaults representing the user's favorite stations
NSString * const kFavoriteStations = @"kFavoriteStations";

@implementation WRCFavoriteStationsManager

//The array of favorite station ids stored in user defaults
+ (NSArray *)fetchFavoriteStationsIds
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSArray *favoriteStationIds = [defaults objectForKey: kFavoriteStations];
    
    if (!favoriteStationIds)
    {
        favoriteStationIds = @[];
    }
    
    return favoriteStationIds;
}

+ (NSArray *)fetchFavoriteStations
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSArray *favoriteStationIds = [defaults objectForKey: kFavoriteStations];
    return [[WRCNetworkingManager sharedManager] fetchCachedStationsWithIds: favoriteStationIds];
}

+ (void)addStationAsFavorite: (WRCStation *)station
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSArray *favoriteStationIds = [WRCFavoriteStationsManager fetchFavoriteStationsIds];
    
    NSMutableArray *mutableFavoriteStationIds = [favoriteStationIds mutableCopy];
    [mutableFavoriteStationIds addObject: station.stationId];
    
    [defaults setObject: mutableFavoriteStationIds forKey: kFavoriteStations];
    [defaults synchronize];
}

+ (void)removeStationFromFavorites: (WRCStation *)station
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSArray *favoriteStationIds = [WRCFavoriteStationsManager fetchFavoriteStationsIds];
    
    NSMutableArray *mutableFavoriteStationIds = [favoriteStationIds mutableCopy];
    [mutableFavoriteStationIds removeObject: station.stationId];
    
    [defaults setObject: mutableFavoriteStationIds forKey: kFavoriteStations];
    [defaults synchronize];
}

+ (BOOL)stationIsFavorite: (WRCStation *)station
{
    NSArray *favoriteStationIds = [WRCFavoriteStationsManager fetchFavoriteStationsIds];
    return [favoriteStationIds containsObject: station.stationId];
}

@end
