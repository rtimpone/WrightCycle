//
//  WRCRequestHandler.h
//  WrightCycle
//
//  Created by Rob Timpone on 7/3/15.
//  Copyright (c) 2015 Rob Timpone. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WRCRequestHandler : NSObject

/** The last time a data refresh was completed */
@property (strong, nonatomic) NSDate *lastRefreshDate;

#pragma mark - Singleton

/** A shared networking manager to be used as a singleton */
+ (instancetype)sharedManager;

#pragma mark - Reachability

/** Whether an internet connection is available */
+ (BOOL)internetConnectionIsAvailable;

#pragma mark - Cooldown Period

/** Whether enough time has passed to justify another request */
- (BOOL)isReadyForRefresh;

/** How long to wait before making another data request */
- (NSInteger)secondsToWaitBeforeRefresh;

@end
