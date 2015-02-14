//
//  WRCStationsMapViewController.m
//  WrightCycle
//
//  Created by Rob Timpone on 2/14/15.
//  Copyright (c) 2015 Rob Timpone. All rights reserved.
//

#import "MKMapView+WRCAdditions.h"
#import "WRCStationsMapViewController.h"

@interface WRCStationsMapViewController ()

/** A location manager to get permission from the user to use their location */
@property (strong, nonatomic) CLLocationManager *locationManager;

/** The map view used to display stations in */
@property (weak, nonatomic) IBOutlet MKMapView *mapView;

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
        
        //the user isn't letting us use their location, so just zoom in on chicago so they can see most of the stations
        [self.mapView zoomInOnChicagoAnimated: YES];
    }
}

#pragma mark - Map View Delegate

- (void)mapView: (MKMapView *)mapView didUpdateUserLocation: (MKUserLocation *)userLocation
{
    //this delegate method fires every time the map view gets a user location, but we only want to zoom in on the user's location once
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [mapView zoomInOnCurrentUserLocationAnimated: YES];
    });
}

@end
