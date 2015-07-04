//
//  WRCRequestHandler.h
//  WrightCycle
//
//  Created by Rob Timpone on 7/3/15.
//  Copyright (c) 2015 Rob Timpone. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WRCRequestHandler : NSObject

#pragma mark - Singleton

/** A shared networking manager to be used as a singleton */
+ (instancetype)sharedManager;

#pragma mark - Reachability

/** Whether an internet connection is available */
+ (BOOL)internetConnectionIsAvailable;

@end
