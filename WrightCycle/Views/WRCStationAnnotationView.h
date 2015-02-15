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

/** Create an annotation view for a station. WRCStation conforms to the MKAnnotation protocol. */
+ (instancetype)annotationViewForStation: (WRCStation *)station;

@end
