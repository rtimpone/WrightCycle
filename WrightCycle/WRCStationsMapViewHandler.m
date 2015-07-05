//
//  WRCStationsMapViewHandler.m
//  WrightCycle
//
//  Created by Rob Timpone on 2/14/15.
//  Copyright (c) 2015 Rob Timpone. All rights reserved.
//

#import "MKMapView+WRCAdditions.h"
#import "WRCStation.h"
#import "WRCStationAnnotationView.h"
#import "WRCStationsMapViewHandler.h"

@implementation WRCStationsMapViewHandler

- (void)updateMapViewForUserDeniedLocationServices
{
    [self.mapView zoomInOnChicagoAnimated: YES];
}

- (void)zoomMapViewInOnInitialRegion
{
    [self.mapView zoomInOnChicagoAnimated: NO];
}

- (void)zoomMapViewInOnUsersLocation
{
    [self.mapView zoomInOnCurrentUserLocationAnimated: YES];
}

- (void)setStations: (NSArray *)stations
{
    _stations = stations;

    for (WRCStation *station in stations)
    {
        NSPredicate *predicate = [NSPredicate predicateWithFormat: @"class != %@ && stationId = %@", [MKUserLocation class], station.stationId];
        WRCStation *existingAnnotation = [[self.mapView.annotations filteredArrayUsingPredicate: predicate] firstObject];
        
        if (existingAnnotation)
        {
            BOOL bikeCountChanged = station.availableBikes.integerValue != existingAnnotation.availableBikes.integerValue;
            BOOL dockCountChanged = station.availableDocks.integerValue != existingAnnotation.availableDocks.integerValue;
            
            if (bikeCountChanged || dockCountChanged)
            {
                [self.mapView removeAnnotation: existingAnnotation];
                [self.mapView addAnnotation: station];
            }
        }
        else
        {
            [self.mapView addAnnotation: station];
        }
    }
}

#pragma mark - Map View Delegate

- (void)mapView: (MKMapView *)mapView didUpdateUserLocation: (MKUserLocation *)userLocation
{
    //this delegate method fires every time the map view gets a user location, but we only want to zoom in on the user's location once
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [mapView zoomInOnCurrentUserLocationAnimated: YES];
    });
}

- (MKAnnotationView *)mapView: (MKMapView *)mapView viewForAnnotation: (id<MKAnnotation>)annotation
{
    //ignore the annotation for the current user location, that view takes care of itself
    if ([annotation isKindOfClass: [MKUserLocation class]])
    {
        return nil;
    }
    
    return [WRCStationAnnotationView annotationViewForStation: (WRCStation *)annotation withCalloutEnabled: YES];
}

- (void)mapView: (MKMapView *)mapView annotationView: (MKAnnotationView *)view calloutAccessoryControlTapped: (UIControl *)control
{
    [self.delegate stationsMapViewHandler: self didSelectStation: (WRCStation *)view.annotation];
}

@end
