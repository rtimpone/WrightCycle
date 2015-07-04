//
//  WRCStationDetailsMapViewHandler.h
//  WrightCycle
//
//  Created by Rob Timpone on 2/14/15.
//  Copyright (c) 2015 Rob Timpone. All rights reserved.
//

@import MapKit;

#import <Foundation/Foundation.h>

@class WRCStation;

@interface WRCStationDetailsMapViewHandler : NSObject <MKMapViewDelegate>

/** The map view to display the station location in */
@property (weak, nonatomic) IBOutlet MKMapView *mapView;

/** The station to display in the map view */
@property (strong, nonatomic) WRCStation *station;

/** Zoom the mapview in on a station */
- (void)zoomInOnStation: (WRCStation *)station;

@end
