//
//  WRCGoogleMapsManager.m
//  WrightCycle
//
//  Created by Rob Timpone on 2/21/15.
//  Copyright (c) 2015 Rob Timpone. All rights reserved.
//

@import UIKit;

#import "NSURL+WRCAdditions.h"
#import "WRCGoogleMapsManager.h"

NSString * const kTransportationModeWalking = @"walking";
NSString * const kTransportationModeBicycling = @"bicycling";
NSString * const kTransportationModeTransit = @"transit";
NSString * const kTransportationModeDriving = @"driving";
NSString * const kGoogleMapsBaseURLString = @"comgooglemaps-x-callback://";
NSString * const kBundleInfoDictionaryAppNameKey = @"CFBundleName";

@implementation WRCGoogleMapsManager

+ (BOOL)canOpenGoogleMaps
{
    NSURL *baseURL = [NSURL URLWithString: kGoogleMapsBaseURLString];
    return [[UIApplication sharedApplication] canOpenURL: baseURL];
}

+ (NSURL *)URLForDirectionsToLocation: (CLLocationCoordinate2D)desinationCoordinate transportationMode: (WRCGoogleMapsTransportationMode)transportationMode
{
    //create querty parameters that tell Google Maps where the user wants to go and how they want to get there
    NSString *destinationCoordParamString = [NSString stringWithFormat: @"daddr=%f,%f", desinationCoordinate.latitude, desinationCoordinate.longitude];
    NSString *transportationModeString = [WRCGoogleMapsManager transportationModeStringForTransportationMode: transportationMode];
    NSString *transporationModeParamString = [NSString stringWithFormat: @"directionsmode=%@", transportationModeString];
    
    //create query parameters that will add a button at the top of google maps to get back to this app
    NSString *appName = [[[NSBundle mainBundle] infoDictionary] objectForKey: kBundleInfoDictionaryAppNameKey];
    NSString *callbackParamString = [NSString stringWithFormat: @"x-success=%@://resume=true", appName];
    NSString *sourceParamString = [NSString stringWithFormat: @"x-source=%@", appName];
    
    NSArray *paramStrings = @[destinationCoordParamString, transporationModeParamString, callbackParamString, sourceParamString];
    return [NSURL URLWithString: kGoogleMapsBaseURLString queryStrings: paramStrings];
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
