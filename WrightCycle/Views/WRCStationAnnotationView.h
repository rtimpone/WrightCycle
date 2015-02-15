//
//  WRCStationAnnotationView.h
//  WrightCycle
//
//  Created by Rob Timpone on 2/14/15.
//  Copyright (c) 2015 Rob Timpone. All rights reserved.
//

#import <MapKit/MapKit.h>

@class WRCStation;

@interface WRCStationAnnotationView : MKPinAnnotationView

/** Create an annotation view for a station. WRCStation conforms to the MKAnnotation protocol. 
 
 @param station The station to create the annotation view for.
 @param calloutEnabled Whether a callout bubble should be shown when the annotation is tapped on.
 @return An annotation view that can be shown in a map view.
 
 */
+ (instancetype)annotationViewForStation: (WRCStation *)station withCalloutEnabled: (BOOL)calloutEnabled;

@end
