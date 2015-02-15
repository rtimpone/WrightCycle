//
//  WRCStation.m
//  WrightCycle
//
//  Created by Rob Timpone on 2/14/15.
//  Copyright (c) 2015 Rob Timpone. All rights reserved.
//

#import "WRCStation.h"

@interface WRCStation ()

;

@end


@implementation WRCStation

+ (instancetype)stationFromDictionary: (NSDictionary *)dictionary
{
    WRCStation *station = [[WRCStation alloc] init];
    station.stationId = dictionary[@"id"];
    station.title = dictionary[@"stationName"];
    station.availableBikes = dictionary[@"availableBikes"];
    station.availableDocks = dictionary[@"availableDocks"];
    
    NSNumber *latitude = dictionary[@"latitude"];
    NSNumber *longitude = dictionary[@"longitude"];
    if (latitude && longitude)
    {
        station.coordinate = CLLocationCoordinate2DMake([latitude doubleValue], [longitude doubleValue]);
    }
    
    return station;
}

- (NSNumber *)totalDocks
{
    NSInteger totalDocks = [self.availableBikes integerValue] + [self.availableDocks integerValue];
    return @(totalDocks);
}

- (WRCStationBikeAvailability)bikeAvailability
{
    if ([self.availableBikes integerValue] < 4)
    {
        return WRCStationBikeAvailabilityLow;
    }
    else if ([self.availableDocks integerValue] < 4)
    {
        return WRCStationBikeAvailabilityHigh;
    }
    else
    {
        return WRCStationBikeAvailabilityNormal;
    }
}

@end
