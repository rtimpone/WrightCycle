//
//  WRCNetworkingManager.h
//  WrightCycle
//
//  Created by Rob Timpone on 2/14/15.
//  Copyright (c) 2015 Rob Timpone. All rights reserved.
//

#import <Foundation/Foundation.h>

@class WRCConfiguration;

///A notification that is posted when the configuration object is updated. The new configuration will be passed along with the notification.
extern NSString * const kConfigurationUpdatedNotification;

@interface WRCNetworkingManager : NSObject

/** The most recently retrieved configuration object */
@property (strong, nonatomic, readonly) WRCConfiguration *cachedConfiguration;

#pragma mark - Singleton

/** A shared data manager to be used as a singleton */
+ (WRCNetworkingManager *)sharedManager;

#pragma mark - Reachability

/** Whether an internet connection is available */
+ (BOOL)internetConnectionIsAvailable;

#pragma mark - Divvy API

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

#pragma mark - Cloudkit

/** Request configuration information from the cloud
 
 Sends a request to CloudKit for the app configuration object. This object contains data about the account login page and
 how to locate the username and password fields. After the configuration object is successfully received, it will be stored
 in the networking manager shared instance.
 
 @param success The block to execute after a successful API response
 @param failure The block to execute after encountering an API error
 
 */
- (void)getAppConfigurationWithSuccess: (void (^)(WRCConfiguration *configuration))success failure: (void (^)(NSError *error))failure;

/** Whether enough time has passed to justify another configuration refresh */
- (BOOL)isReadyForConfigurationRefresh;

#pragma mark - Cached Stations

/** Fetch any cached stations that have an id in an array of ids
 
 @param stationIds The station ids of the stations being requested
 @return An array of stations with an id in the array of station ids
 
 */
- (NSArray *)fetchCachedStationsWithIds: (NSArray *)stationIds;

@end
