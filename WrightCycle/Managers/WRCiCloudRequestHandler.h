//
//  WRCiCloudRequestHandler.h
//  WrightCycle
//
//  Created by Rob Timpone on 7/3/15.
//  Copyright (c) 2015 Rob Timpone. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WRCRequestHandler.h"

@class WRCConfiguration;

/** A notification that is posted when the configuration object is updated. The new configuration will be passed along with the notification. */
extern NSString * const kConfigurationUpdatedNotification;

@interface WRCiCloudRequestHandler : WRCRequestHandler

/** The most recently retrieved configuration object */
@property (strong, nonatomic, readonly) WRCConfiguration *cachedConfiguration;

/** Request configuration information from the cloud
 
 Sends a request to CloudKit for the app configuration object. This object contains data about the account login page and
 how to locate the username and password fields. After the configuration object is successfully received, it will be stored
 in the networking manager shared instance.
 
 @param success The block to execute after a successful API response
 @param failure The block to execute after encountering an API error
 
 */
- (void)getAppConfigurationWithSuccess: (void (^)(WRCConfiguration *configuration))success failure: (void (^)(NSError *error))failure;

@end
