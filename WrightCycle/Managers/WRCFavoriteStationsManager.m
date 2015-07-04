//
//  WRCFavoriteStationsManager.m
//  WrightCycle
//
//  Created by Rob Timpone on 6/13/15.
//  Copyright (c) 2015 Rob Timpone. All rights reserved.
//

#import "WRCFavoriteStationsManager.h"
#import "WRCStation.h"
#import "WRCStationsRequestHandler.h"

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
    NSArray *cachedStations = [[WRCStationsRequestHandler sharedManager] cachedStations];
    
    NSMutableArray *favoriteStations = [[NSMutableArray alloc] init];
    for (NSNumber *stationId in favoriteStationIds)
    {
        NSPredicate *predicate = [NSPredicate predicateWithFormat: @"stationId = %@", stationId];
        NSArray *stationMatches = [cachedStations filteredArrayUsingPredicate: predicate];
        if ([stationMatches count])
        {
            WRCStation *station = [stationMatches firstObject];
            [favoriteStations addObject: station];
        }
    }
    
    return favoriteStations;
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

+ (void)moveFavoriteStationAtIndex: (NSInteger)sourceIndex toIndex: (NSInteger)destinationIndex
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSArray *favoriteStationIds = [WRCFavoriteStationsManager fetchFavoriteStationsIds];
    
    NSMutableArray *mutableFavoriteStationIds = [favoriteStationIds mutableCopy];
    WRCStation *stationToMove = mutableFavoriteStationIds[sourceIndex];
    [mutableFavoriteStationIds removeObjectAtIndex: sourceIndex];
    [mutableFavoriteStationIds insertObject: stationToMove atIndex: destinationIndex];
    
    [defaults setObject: mutableFavoriteStationIds forKey: kFavoriteStations];
    [defaults synchronize];
}

+ (BOOL)stationIsFavorite: (WRCStation *)station
{
    NSArray *favoriteStationIds = [WRCFavoriteStationsManager fetchFavoriteStationsIds];
    return [favoriteStationIds containsObject: station.stationId];
}

@end
