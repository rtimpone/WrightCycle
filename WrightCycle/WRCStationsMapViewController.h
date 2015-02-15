//
//  WRCStationsMapViewController.h
//  WrightCycle
//
//  Created by Rob Timpone on 2/14/15.
//  Copyright (c) 2015 Rob Timpone. All rights reserved.
//

@import CoreLocation;

#import <UIKit/UIKit.h>
#import "WRCStationsMapViewHandler.h"
#import "WRCViewController.h"

@interface WRCStationsMapViewController : WRCViewController <CLLocationManagerDelegate, WRCStationsMapViewHandlerDelegate>

@end
