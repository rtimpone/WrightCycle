//
//  WRCStationsMapViewController.m
//  WrightCycle
//
//  Created by Rob Timpone on 2/14/15.
//  Copyright (c) 2015 Rob Timpone. All rights reserved.
//

#import "WRCNetworkingManager.h"
#import "WRCStationDetailsViewController.h"
#import "WRCStationsMapViewController.h"

@interface WRCStationsMapViewController ()

/** A location manager to get permission from the user to use their location */
@property (strong, nonatomic) CLLocationManager *locationManager;

/** Handles displaying stations on the mapview, zooming in, and responding to the user's station selection */
@property (strong, nonatomic) IBOutlet WRCStationsMapViewHandler *mapViewHandler;

/** The station that the user selected and is about to be shown in the station details screen */
@property (strong, nonatomic) WRCStation *selectedStation;

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
    self.mapViewHandler.stations = [[WRCNetworkingManager sharedManager] getStationsListWithSuccess: ^(NSArray *stations) {
        
        self.mapViewHandler.stations = stations;
        
    } failure: ^(NSError *error) {
        
        NSString *title = NSLocalizedString(@"Error", nil);
        NSString *message = NSLocalizedString(@"There was an error trying to retrieve station data, station information may not be up to date.", nil);
        [self showOkAlertWithTitle: title message: message];

    }];
}

- (void)prepareForSegue: (UIStoryboardSegue *)segue sender: (id)sender
{
    if ([segue.identifier isEqualToString: @"stationDetailsSegue"])
    {
        WRCStationDetailsViewController *vc = segue.destinationViewController;
        vc.station = self.selectedStation;
    }
}

#pragma mark - Location Manager Delegate

- (void)locationManager: (CLLocationManager *)manager didChangeAuthorizationStatus: (CLAuthorizationStatus)status
{
    if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied)
    {
        [self showLocationServicesDisabledAlert];
        
        //the user isn't letting us use their location, so just zoom in on chicago so they can see most of the stations
        [self.mapViewHandler updateMapViewForUserDeniedLocationServices];
    }
}

#pragma mark - Map View Handler Delegate

- (void)stationsMapViewHandler: (WRCStationsMapViewHandler *)handler didSelectStation: (WRCStation *)station
{
    self.selectedStation = station;
    [self performSegueWithIdentifier: @"stationDetailsSegue" sender: self];
}

#pragma mark - Actions

//Called when the user taps the near me button
//Zooms the map view in on the user's current location
- (IBAction)nearMeAction: (id)sender
{
    if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied)
    {
        [self showLocationServicesDisabledAlert];
    }
    else
    {
        [self.mapViewHandler zoomMapViewInOnUsersLocation];
    }
}

#pragma mark - Helpers

//Shows an alert to the user letting them know location services are disabled
- (void)showLocationServicesDisabledAlert
{
    NSString *title = NSLocalizedString(@"Location Services are Disabled", nil);
    NSString *message = NSLocalizedString(@"To zoom in on stations near you, this app needs access to your current location. You can enable location services by going to the iPhone settings and navigating to WrightCycle -> Location Services", nil);
    [self showOkAlertWithTitle: title message: message];
}

@end
