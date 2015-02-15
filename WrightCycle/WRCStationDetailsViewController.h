//
//  WRCStationDetailsViewController.h
//  WrightCycle
//
//  Created by Rob Timpone on 2/14/15.
//  Copyright (c) 2015 Rob Timpone. All rights reserved.
//

#import "WRCViewController.h"

@class WRCStation;

@interface WRCStationDetailsViewController : WRCViewController

/** The station to show details for */
@property (strong, nonatomic) WRCStation *station;

@end
