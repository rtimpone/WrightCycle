//
//  WRCStationsMapViewHandler.h
//  WrightCycle
//
//  Created by Rob Timpone on 2/14/15.
//  Copyright (c) 2015 Rob Timpone. All rights reserved.
//

@import MapKit;

#import <Foundation/Foundation.h>

@class WRCStation, WRCStationsMapViewHandler;

@protocol WRCStationsMapViewHandlerDelegate <NSObject>

/** Called when the user taps a callout button on a station popover view to view station details */
- (void)stationsMapViewHandler: (WRCStationsMapViewHandler *)handler didSelectStation: (WRCStation *)station;

@end


@interface WRCStationsMapViewHandler : NSObject <MKMapViewDelegate>

/** The delegate to alert when the user selects a station to see details on */
@property (weak, nonatomic) IBOutlet id <WRCStationsMapViewHandlerDelegate> delegate;

/** The map view used to display stations in */
@property (weak, nonatomic) IBOutlet MKMapView *mapView;

/** The stations to display in the map view */
@property (strong, nonatomic) NSArray *stations;

/** Zooms the map view in on the city of chicago to handle situations where the user denies access to their location */
- (void)updateMapViewForUserDeniedLocationServices;

/** Zooms the map view to the initial region without animation */
- (void)zoomMapViewInOnInitialRegion;

@end
