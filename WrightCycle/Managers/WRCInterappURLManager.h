//
//  WRCInterappURLManager.h
//  WrightCycle
//
//  Created by Rob Timpone on 2/21/15.
//  Copyright (c) 2015 Rob Timpone. All rights reserved.
//

@import CoreLocation;

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, WRCGoogleMapsTransportationMode) {
    WRCGoogleMapsTransportationModeWalking,
    WRCGoogleMapsTransportationModeBicycling,
    WRCGoogleMapsTransportationModeTransit,
    WRCGoogleMapsTransportationModeDriving
};

@interface WRCInterappURLManager : NSObject

#pragma mark - Google Maps

/** Whether the user's device has the ability to open Google Maps */
+ (BOOL)canOpenGoogleMaps;

/** A url to open the Google Maps app with directions to a location.
 
 Opening this url will open Google Maps with directions from the user's current location to the destination 
 location using the specified transportation mode. Always make sure the user's device can open a Google 
 Maps url before attempting to open the url. A callback link to return to the app that called the URL will 
 be displayed at the top of the Google Maps app.
 
 @see + (BOOL)canOpenGoogleMaps
 
 @param destinationCoordinate the coordinate of the location to get directions to
 @param transportationMode the transportation mode to use when getting directions
 @return a url that will open Google Maps with the appropriate directions
 
 */
+ (NSURL *)googleMapsURLForDirectionsToLocation: (CLLocationCoordinate2D)desinationCoordinate transportationMode: (WRCGoogleMapsTransportationMode)transportationMode;

#pragma mark - Apple Maps

/** Whether the user's device has the ability to open Apple Maps */
+ (BOOL)canOpenAppleMaps;

/** A url to open the Apple Maps app with directions to a location.
 
 Opening this url will open Apple Maps with driving directions from the user's current location to the 
 destination. Always make sure the user's device can open an Apple Maps url before attempting to open it.
 
 @see + (BOOL)canOpenAppleMaps
 
 @param destinationCoordinate the coordinate of the location to get directions to
 @return a url that will open Apple Maps with directions
 
 */
+ (NSURL *)appleMapsURLForDirectionsToLocation: (CLLocationCoordinate2D)desinationCoordinate;

@end
