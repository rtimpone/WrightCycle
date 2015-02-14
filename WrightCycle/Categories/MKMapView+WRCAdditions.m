//
//  MKMapView+WRCAdditions.m
//  WrightCycle
//
//  Created by Rob Timpone on 2/14/15.
//  Copyright (c) 2015 Rob Timpone. All rights reserved.
//

@import CoreLocation;

#import "MKMapView+WRCAdditions.h"

#define USER_LOCATION_REGION_SPAN_IN_METERS 1200
#define CHICAGO_REGION_SPAN_IN_METERS 6400
#define CHICAGO_LATITUDE 41.8833
#define CHICAGO_LONGITUDE -87.6333

@implementation MKMapView (WRCAdditions)

- (void)zoomInOnCurrentUserLocationAnimated: (BOOL)animated
{
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(self.userLocation.coordinate, USER_LOCATION_REGION_SPAN_IN_METERS, USER_LOCATION_REGION_SPAN_IN_METERS);
    [self setRegion: region animated: animated];
}

- (void)zoomInOnChicagoAnimated: (BOOL)animated
{
    CLLocationCoordinate2D chicagoCoordinate = CLLocationCoordinate2DMake(CHICAGO_LATITUDE, CHICAGO_LONGITUDE);
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(chicagoCoordinate, CHICAGO_REGION_SPAN_IN_METERS, CHICAGO_REGION_SPAN_IN_METERS);
    [self setRegion: region animated: animated];
}

@end
