//
//  WRCStationsMapViewController.m
//  WrightCycle
//
//  Created by Rob Timpone on 2/14/15.
//  Copyright (c) 2015 Rob Timpone. All rights reserved.
//

#import "WRCStationsMapViewController.h"

@interface WRCStationsMapViewController ()

/** A location manager to get permission from the user to use their location */
@property (strong, nonatomic) CLLocationManager *locationManager;

@end


@implementation WRCStationsMapViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    [self.locationManager requestWhenInUseAuthorization];
}

#pragma mark - Location Manager Delegate

- (void)locationManager: (CLLocationManager *)manager didChangeAuthorizationStatus: (CLAuthorizationStatus)status
{
    if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied)
    {
        NSString *title = NSLocalizedString(@"Location Services are Disabled", nil);
        NSString *message = NSLocalizedString(@"To zoom in on stations near you, this app needs access to your current location. You can enable location services by going to the iPhone settings and navigating to WrightCycle -> Location Services", nil);
        [self showOkAlertWithTitle: title message: message];
    }
    else if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorizedWhenInUse)
    {
        NSLog(@"Zooming in on current user location");
    }
}

@end
