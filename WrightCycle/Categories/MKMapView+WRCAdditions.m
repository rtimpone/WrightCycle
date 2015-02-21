//
//  MKMapView+WRCAdditions.m
//  WrightCycle
//
//  Created by Rob Timpone on 2/14/15.
//  Copyright (c) 2015 Rob Timpone. All rights reserved.
//

@import CoreLocation;

#import "MKMapView+WRCAdditions.h"
#import "WRCStation.h"

//These constants determine how wide of an area, in meters, the map view shows when zooming in on various locations
#define REGION_SPAN_FOR_STATION_DETAILS 600
#define REGION_SPAN_FOR_USER_LOCATION 1200
#define REGION_SPAN_FOR_CHICAGO 6400

//The fixed lat/long of the city of Chicago
#define CHICAGO_LATITUDE 41.8833
#define CHICAGO_LONGITUDE -87.6333

@implementation MKMapView (WRCAdditions)

- (void)zoomInOnCurrentUserLocationAnimated: (BOOL)animated
{
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(self.userLocation.coordinate, REGION_SPAN_FOR_USER_LOCATION, REGION_SPAN_FOR_USER_LOCATION);
    [self setRegion: region animated: animated];
}

- (void)zoomInOnChicagoAnimated: (BOOL)animated
{
    CLLocationCoordinate2D chicagoCoordinate = CLLocationCoordinate2DMake(CHICAGO_LATITUDE, CHICAGO_LONGITUDE);
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(chicagoCoordinate, REGION_SPAN_FOR_CHICAGO, REGION_SPAN_FOR_CHICAGO);
    [self setRegion: region animated: animated];
}

- (void)zoomInOnStation: (WRCStation *)station animated: (BOOL)animated
{
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(station.coordinate, REGION_SPAN_FOR_STATION_DETAILS, REGION_SPAN_FOR_STATION_DETAILS);
    [self setRegion: region animated: animated];
}

@end
