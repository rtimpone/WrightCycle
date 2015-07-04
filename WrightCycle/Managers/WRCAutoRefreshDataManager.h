//
//  WRCAutoRefreshDataManager.h
//  WrightCycle
//
//  Created by Rob Timpone on 7/4/15.
//  Copyright (c) 2015 Rob Timpone. All rights reserved.
//

#import <Foundation/Foundation.h>

/** A notification that is posted when the configuration object is updated. The new configuration will be passed along with the notification. */
extern NSString * const kConfigurationUpdatedNotification;

/** A notification that is posted when the stations are updated. The updated stations array will be passed along with the notification. */
extern NSString * const kStationsUpdatedNotification;

@interface WRCAutoRefreshDataManager : NSObject

/** Starts timers that automatically refresh station and app configuration data at regular intervals */
- (void)beginAutoRefreshing;

/** Invalidates the timers that automatically refresh app data */
- (void)endAutoRefreshing;

@end
