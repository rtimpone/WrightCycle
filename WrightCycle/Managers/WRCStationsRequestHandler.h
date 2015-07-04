//
//  WRCStationsRequestHandler.h
//  WrightCycle
//
//  Created by Rob Timpone on 7/3/15.
//  Copyright (c) 2015 Rob Timpone. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WRCRequestHandler.h"

@interface WRCStationsRequestHandler : WRCRequestHandler

/** The most recent list of stations from the API */
@property (strong, nonatomic, readonly) NSArray *cachedStations;

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

/** Fetch any cached stations that have an id in an array of ids
 
 @param stationIds The station ids of the stations being requested
 @return An array of stations with an id in the array of station ids
 
 */
- (NSArray *)fetchCachedStationsWithIds: (NSArray *)stationIds;

@end
