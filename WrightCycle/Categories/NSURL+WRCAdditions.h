//
//  NSURL+WRCAdditions.h
//  WrightCycle
//
//  Created by Rob Timpone on 2/21/15.
//  Copyright (c) 2015 Rob Timpone. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSURL (WRCAdditions)

/** Create a URL with a url string and some query strings
 
 The array of query strings should already be in the format 'key=value' and should not have a ? or & separator 
 prefix. Each query string is appended to the url string with the appropriate separator and the combined result 
 is returned as an NSURL.
 
 @param URLString the url string to initialize the NSURL with
 @param queryStrings the query strings that should be appended to the url
 @return An NSURL object with the url string and query strings appended with the appropriate ? or & separators
 
 */
+ (instancetype)URLWithString: (NSString *)URLString queryStrings: (NSArray *)queryStrings;

@end
