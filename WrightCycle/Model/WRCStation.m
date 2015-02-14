//
//  WRCStation.m
//  WrightCycle
//
//  Created by Rob Timpone on 2/14/15.
//  Copyright (c) 2015 Rob Timpone. All rights reserved.
//

#import "WRCStation.h"

@implementation WRCStation

+ (instancetype)stationFromDictionary: (NSDictionary *)dictionary
{
    WRCStation *station = [[WRCStation alloc] init];
    station.stationId = dictionary[@"id"];
    station.title = dictionary[@"stationName"];
    
    station.availableBikes = dictionary[@"availableBikes"];
    NSNumber *availableDocks = dictionary[@"availableDocks"];
    
    //a station may have bikes or docks that are broken, so the 'true' total docks count is available bikes plus available docks
    if (station.availableBikes && availableDocks)
    {
        NSInteger totalDocksInteger = [station.availableBikes integerValue] + [availableDocks integerValue];
        station.totalDocks = @(totalDocksInteger);
    }
    
    NSNumber *latitude = dictionary[@"latitude"];
    NSNumber *longitude = dictionary[@"longitude"];
    if (latitude && longitude)
    {
        station.coordinate = CLLocationCoordinate2DMake([latitude doubleValue], [longitude doubleValue]);
    }
    
    return station;
}

@end
