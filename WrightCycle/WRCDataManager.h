//
//  WRCDataManager.h
//  WrightCycle
//
//  Created by Rob Timpone on 2/14/15.
//  Copyright (c) 2015 Rob Timpone. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WRCDataManager : NSObject

/** A shared data manager to be used as a singleton */
+ (WRCDataManager *)sharedManager;

/** Whether an internet connection is available */
+ (BOOL)internetConnectionIsAvailable;

/** Request the current list of stations and refresh stations if necessary
 
 Returns the currently cached list of stations if available immediately. Also makes a request to the
 Divvy API to refresh stations if it has been at least 1 minute since the last refresh. The completion
 blocks will only be triggered if an API request is made.
 
 @param success The block to execute after a successful API response. The array passed to the block
                is the newly refreshed list of stations.
 
 @param failure The block to execute after encountering an API error.
 
 @return The currently cached list of stations.
 
*/
- (NSArray *)getStationsListWithSuccess: (void (^)(NSArray *stations))success failure: (void (^)(NSError *error))failure;

@end
