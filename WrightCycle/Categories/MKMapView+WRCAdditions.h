//
//  MKMapView+WRCAdditions.h
//  WrightCycle
//
//  Created by Rob Timpone on 2/14/15.
//  Copyright (c) 2015 Rob Timpone. All rights reserved.
//

#import <MapKit/MapKit.h>

@class WRCStation;

@interface MKMapView (WRCAdditions)

/** Zoom the map in on the current user location with an area about 3/4 of a mile wide */
- (void)zoomInOnCurrentUserLocationAnimated: (BOOL)animated;

/** Zoom the map in on the city of Chicago with an area about 4 miles wide */
- (void)zoomInOnChicagoAnimated: (BOOL)animated;

/** Zoom the map in on a station's coordinate */
- (void)zoomInOnStation: (WRCStation *)station animated: (BOOL)animated;

@end
