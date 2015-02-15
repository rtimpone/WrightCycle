//
//  WRCStationsMapViewController.m
//  WrightCycle
//
//  Created by Rob Timpone on 2/14/15.
//  Copyright (c) 2015 Rob Timpone. All rights reserved.
//

#import "WRCDataManager.h"
#import "WRCStationsMapViewController.h"

@interface WRCStationsMapViewController ()

/** A location manager to get permission from the user to use their location */
@property (strong, nonatomic) CLLocationManager *locationManager;

/** Handles displaying stations on the mapview, zooming in, and responding to the user's station selection */
@property (strong, nonatomic) IBOutlet WRCStationsMapViewHandler *mapViewHandler;

@end


@implementation WRCStationsMapViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.mapViewHandler zoomMapViewInOnInitialRegion];
    
    //need to check for user location services authorization
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    [self.locationManager requestWhenInUseAuthorization];
    
    //load cached station data into the mapview and request refreshed data from the API if necessary
    self.mapViewHandler.stations = [[WRCDataManager sharedManager] getStationsListWithSuccess: ^(NSArray *stations) {
        
        self.mapViewHandler.stations = stations;
        
    } failure: ^(NSError *error) {
        
        NSString *title = NSLocalizedString(@"Error", nil);
        NSString *message = NSLocalizedString(@"There was an error trying to retrieve station data, station information may not be up to date.", nil);
        [self showOkAlertWithTitle: title message: message];

    }];
}

#pragma mark - Location Manager Delegate

- (void)locationManager: (CLLocationManager *)manager didChangeAuthorizationStatus: (CLAuthorizationStatus)status
{
    if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied)
    {
        NSString *title = NSLocalizedString(@"Location Services are Disabled", nil);
        NSString *message = NSLocalizedString(@"To zoom in on stations near you, this app needs access to your current location. You can enable location services by going to the iPhone settings and navigating to WrightCycle -> Location Services", nil);
        [self showOkAlertWithTitle: title message: message];
        
        //the user isn't letting us use their location, so just zoom in on chicago so they can see most of the stations
        [self.mapViewHandler updateMapViewForUserDeniedLocationServices];
    }
}

#pragma mark - Map View Handler Delegate

- (void)stationsMapViewHandler: (WRCStationsMapViewHandler *)handler didSelectStation: (WRCStation *)station
{
    //segue to station details screen for the selected station
}

@end
