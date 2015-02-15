//
//  WRCStationAnnotationView.m
//  WrightCycle
//
//  Created by Rob Timpone on 2/14/15.
//  Copyright (c) 2015 Rob Timpone. All rights reserved.
//

@import MapKit;

#import "WRCStation.h"
#import "WRCStationAnnotationView.h"

@implementation WRCStationAnnotationView

+ (instancetype)annotationViewForStation: (WRCStation *)station
{
    static NSString *pinViewReuseIdentifier = @"stationAnnotationView";
    WRCStationAnnotationView *pinView = [[WRCStationAnnotationView alloc] initWithAnnotation: station reuseIdentifier: pinViewReuseIdentifier];
    
    if (station.bikeAvailability == WRCStationBikeAvailabilityLow)
    {
        pinView.pinColor = MKPinAnnotationColorRed;
    }
    else if (station.bikeAvailability == WRCStationBikeAvailabilityNormal)
    {
        pinView.pinColor = MKPinAnnotationColorPurple;
    }
    else
    {
        pinView.pinColor = MKPinAnnotationColorGreen;
    }
    
    pinView.canShowCallout = YES;
    pinView.rightCalloutAccessoryView = [UIButton buttonWithType: UIButtonTypeInfoLight];
    
    return pinView;
}

@end
