//
//  WRCStationDetailsMapViewHandler.m
//  WrightCycle
//
//  Created by Rob Timpone on 2/14/15.
//  Copyright (c) 2015 Rob Timpone. All rights reserved.
//

#import "MKMapView+WRCAdditions.h"
#import "WRCStation.h"
#import "WRCStationAnnotationView.h"
#import "WRCStationDetailsMapViewHandler.h"

@implementation WRCStationDetailsMapViewHandler

- (void)zoomInOnStation: (WRCStation *)station
{
    [self.mapView zoomInOnStation: station animated: NO];
}

- (void)setStation: (WRCStation *)station
{
    _station = station;
    
    WRCStation *existingAnnotation = [self.mapView.annotations firstObject];
    
    BOOL bikeCountChanged = station.availableBikes.integerValue != existingAnnotation.availableBikes.integerValue;
    BOOL dockCountChanged = station.availableDocks.integerValue != existingAnnotation.availableDocks.integerValue;
    
    if (existingAnnotation)
    {
        if (bikeCountChanged || dockCountChanged)
        {
            [self.mapView removeAnnotations: self.mapView.annotations];
            [self.mapView addAnnotation: station];
        }
    }
    else
    {
        [self.mapView addAnnotation: station];
    }
}

#pragma mark - Map View Delegate

- (MKAnnotationView *)mapView: (MKMapView *)mapView viewForAnnotation: (id<MKAnnotation>)annotation
{
    //ignore the annotation for the current user location, that view takes care of itself
    if ([annotation isKindOfClass: [MKUserLocation class]])
    {
        return nil;
    }
    
    return [WRCStationAnnotationView annotationViewForStation: (WRCStation *)annotation withCalloutEnabled: NO];
}

@end
