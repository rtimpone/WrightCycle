//
//  WRCInterappURLManager.m
//  WrightCycle
//
//  Created by Rob Timpone on 2/21/15.
//  Copyright (c) 2015 Rob Timpone. All rights reserved.
//

@import UIKit;

#import "NSURL+WRCAdditions.h"
#import "WRCInterappURLManager.h"

NSString * const kTransportationModeWalking = @"walking";
NSString * const kTransportationModeBicycling = @"bicycling";
NSString * const kTransportationModeTransit = @"transit";
NSString * const kTransportationModeDriving = @"driving";

NSString * const kAppleMapsBaseURLString = @"http://maps.apple.com";
NSString * const kGoogleMapsBaseURLString = @"comgooglemaps-x-callback://";

NSString * const kBundleInfoDictionaryAppNameKey = @"CFBundleName";


@implementation WRCInterappURLManager

#pragma mark - Google Maps

+ (BOOL)canOpenGoogleMaps
{
    NSURL *baseURL = [NSURL URLWithString: kGoogleMapsBaseURLString];
    return [[UIApplication sharedApplication] canOpenURL: baseURL];
}

+ (NSURL *)googleMapsURLForDirectionsToLocation: (CLLocationCoordinate2D)desinationCoordinate transportationMode: (WRCGoogleMapsTransportationMode)transportationMode
{
    //create querty parameters that tell Google Maps where the user wants to go and how they want to get there
    NSString *destinationCoordParamString = [NSString stringWithFormat: @"daddr=%f,%f", desinationCoordinate.latitude, desinationCoordinate.longitude];
    NSString *transportationModeString = [WRCInterappURLManager transportationModeStringForTransportationMode: transportationMode];
    NSString *transporationModeParamString = [NSString stringWithFormat: @"directionsmode=%@", transportationModeString];
    
    //create query parameters that will add a button at the top of google maps to get back to this app
    NSString *appName = [[[NSBundle mainBundle] infoDictionary] objectForKey: kBundleInfoDictionaryAppNameKey];
    NSString *callbackParamString = [NSString stringWithFormat: @"x-success=%@://resume=true", appName];
    NSString *sourceParamString = [NSString stringWithFormat: @"x-source=%@", appName];
    
    NSArray *paramStrings = @[destinationCoordParamString, transporationModeParamString, callbackParamString, sourceParamString];
    return [NSURL URLWithString: kGoogleMapsBaseURLString queryStrings: paramStrings];
}

#pragma mark - Apple Maps

+ (BOOL)canOpenAppleMaps
{
    NSURL *baseURL = [NSURL URLWithString: kAppleMapsBaseURLString];
    return [[UIApplication sharedApplication] canOpenURL: baseURL];
}

+ (NSURL *)appleMapsURLForDirectionsToLocation: (CLLocationCoordinate2D)desinationCoordinate
{
    NSString *destinationCoordParamString = [NSString stringWithFormat: @"daddr=%f,%f", desinationCoordinate.latitude, desinationCoordinate.longitude];
    return [NSURL URLWithString: kAppleMapsBaseURLString queryStrings: @[destinationCoordParamString]];
}

#pragma mark - Helpers

+ (NSString *)transportationModeStringForTransportationMode: (WRCGoogleMapsTransportationMode)transportationMode
{
    if (transportationMode == WRCGoogleMapsTransportationModeWalking)
    {
        return kTransportationModeWalking;
    }
    else if (transportationMode == WRCGoogleMapsTransportationModeBicycling)
    {
        return kTransportationModeBicycling;
    }
    else if (transportationMode == WRCGoogleMapsTransportationModeTransit)
    {
        return kTransportationModeTransit;
    }
    else if (transportationMode == WRCGoogleMapsTransportationModeDriving)
    {
        return kTransportationModeDriving;
    }
    else
    {
        return @"";
    }
}

@end
