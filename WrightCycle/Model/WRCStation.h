//
//  WRCStation.h
//  WrightCycle
//
//  Created by Rob Timpone on 2/14/15.
//  Copyright (c) 2015 Rob Timpone. All rights reserved.
//

@import CoreLocation;
@import MapKit;

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, WRCStationBikeAvailability) {
    WRCStationBikeAvailabilityLow,
    WRCStationBikeAvailabilityNormal,
    WRCStationBikeAvailabilityHigh
};


@interface WRCStation : NSObject <MKAnnotation>

#pragma mark - MKAnnotation Protocol

/** The title of the station, usually the name of a nearby street intersection or landmark */
@property (copy, nonatomic) NSString *title;

/** The lat/long coordinate of the station */
@property (nonatomic) CLLocationCoordinate2D coordinate;

#pragma mark - Other Station Properties

/** The station's id from the API */
@property (strong, nonatomic) NSNumber *stationId;

/** The number of usable bikes currently available */
@property (strong, nonatomic) NSNumber *availableBikes;

/** The number of usable docks currently available */
@property (strong, nonatomic) NSNumber *availableDocks;

/** The total number of functioning docks at this station, including docks with and without bikes in them */
@property (strong, nonatomic) NSNumber *totalDocks;

/** An enum describing bike availability at this station */
@property (nonatomic) WRCStationBikeAvailability bikeAvailability;

/** Create a station object from a JSON dictionary
 
 @param dictionary A dictionary representation of the station
 @return A WRCStation object with its property values populated from the dictionary

 */
+ (instancetype)stationFromDictionary: (NSDictionary *)dictionary;

@end
