//
//  WRCDataManager.h
//  WrightCycle
//
//  Created by Rob Timpone on 2/14/15.
//  Copyright (c) 2015 Rob Timpone. All rights reserved.
//

#import <Foundation/Foundation.h>

@class WRCStation;

@interface WRCDataManager : NSObject

/** A shared data manager to be used as a singleton */
+ (WRCDataManager *)sharedManager;

/** Whether an internet connection is available */
+ (BOOL)internetConnectionIsAvailable;

/** Request the current list of stations and refresh stations if necessary
 
 Returns the currently cached list of stations immediately. Also makes a request to the Divvy API to refresh stations if it has been at least 
 1 minute since the last refresh. The completion blocks will only be triggered if an API request is actually made.
 
 @param success The block to execute after a successful API response. The array passed to the blockis the newly refreshed list of stations.
 @param failure The block to execute after encountering an API error. This parameter is optional in casethe caller wants the request to fail silently.
 
 @return The currently cached list of stations.
 
 */
- (NSArray *)getStationsListWithSuccess: (void (^)(NSArray *stations))success failure: (void (^)(NSError *error))failure;

/** Request the current list of stations and refresh stations immediately or if necessary
 
 Returns the currently cached list of stations immediately. Also makes a request to the Divvy API to refresh stations if it has been at least 
 1 minute since the last refresh or if the shouldMakeRequestImmediately is YES. The completion blocks will only be triggered if an API request 
 is actually made.
 
 @param shouldMakeRequestImmediately Whether the API request should be made regardless of the last time the request was made.
 @param success The block to execute after a successful API response. The array passed to the blockis the newly refreshed list of stations.
 @param failure The block to execute after encountering an API error. This parameter is optional in case the caller wants the request to fail silently.
 
 @return The currently cached list of stations.
 
 */
- (NSArray *)getStationsListImmediately: (BOOL)shouldMakeRequestImmediately withSuccess: (void (^)(NSArray *stations))success failure: (void (^)(NSError *error))failure;

/** Add a station to the favorites list
 
 This will add the station's id to the favorites list stored in user defaults
 
 @param station The station to add as a favorite
 
 */
- (void)addStationAsFavorite: (WRCStation *)station;

/** Remove a station from the favorites list
 
 This will remove the station's id from the favorites list stored in user defaults
 
 @param station The station to remove from the favorites list
 
 */
- (void)removeStationFromFavorites: (WRCStation *)station;

/** Whether a station is in the favories list
 
 Checks the list of favorite station ids stored in user defaults to see if the station is a favorite.
 
 @return Whether the station is a favorite
 
 */
- (BOOL)stationIsFavorite: (WRCStation *)station;

/** The current list of the user's favorite stations
 
 Stored as an array in user defaults to preserve the way the user may have ordered the list.
 
 @return An array containing the user's favorite stations
 
 */
- (NSArray *)fetchFavoriteStations;

@end
