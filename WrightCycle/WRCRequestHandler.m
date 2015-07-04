//
//  WRCRequestHandler.m
//  WrightCycle
//
//  Created by Rob Timpone on 7/3/15.
//  Copyright (c) 2015 Rob Timpone. All rights reserved.
//

#import "WRCRequestHandler.h"
#import <Reachability/Reachability.h>

@implementation WRCRequestHandler

#pragma mark - Singleton

+ (instancetype)sharedManager
{
    static NSMutableDictionary *singletons = nil;
    if (!singletons)
    {
        singletons = [[NSMutableDictionary alloc] init];
    }
    
    NSString *className = NSStringFromClass([self class]);
    WRCRequestHandler *sharedInstance = singletons[className];
    if (!sharedInstance)
    {
        sharedInstance = [[self alloc] init];
        singletons[className] = sharedInstance;
    }
    
    return sharedInstance;
}

#pragma mark - Reachability

+ (BOOL)internetConnectionIsAvailable
{
    Reachability *reachabilty = [Reachability reachabilityForInternetConnection];
    return reachabilty.isReachable;
}

@end
