//
//  NSURL+WRCAdditions.m
//  WrightCycle
//
//  Created by Rob Timpone on 2/21/15.
//  Copyright (c) 2015 Rob Timpone. All rights reserved.
//

#import "NSURL+WRCAdditions.h"

@implementation NSURL (WRCAdditions)

+ (instancetype)URLWithString: (NSString *)URLString queryStrings: (NSArray *)queryStrings
{
    NSString *newURLString = URLString;
    BOOL isFirstQueryString = YES;
    
    for (NSString *queryString in queryStrings)
    {
        NSString *separator = isFirstQueryString ? @"?" : @"&";
        NSString *stringToAppend = [separator stringByAppendingString: queryString];
        newURLString = [newURLString stringByAppendingString: stringToAppend];
        isFirstQueryString = NO;
    }
    
    return [NSURL URLWithString: newURLString];
}

@end
