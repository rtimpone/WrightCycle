//
//  WRCLandingViewController.m
//  WrightCycle
//
//  Created by Rob Timpone on 2/14/15.
//  Copyright (c) 2015 Rob Timpone. All rights reserved.
//

#import "WRCDataManager.h"
#import "WRCLandingViewController.h"

@implementation WRCLandingViewController

- (void)viewDidAppear: (BOOL)animated
{
    [super viewDidAppear: animated];
    
    //show a retry alert if the user doesn't have an internet connection
    if (![WRCDataManager internetConnectionIsAvailable])
    {
        NSString *noInternetConnectionMessage = NSLocalizedString(@"Unable to retrieve station data, please check your internet connection and try again.", nil);
        [self showRetryAlertWithMessage: noInternetConnectionMessage];
        return;
    }
    
    [self refreshStations];
}

//Requests a refreshed list of stations from the API using the data manager
//Shows a retry alert if there is an error
- (void)refreshStations
{
    [[WRCDataManager sharedManager] getStationsListWithSuccess: ^(NSArray *stations) {
        
        [self performSegueWithIdentifier: @"stationMapSegue" sender: self];
        
    } failure: ^(NSError *error) {

        NSString *errorMessage = NSLocalizedString(@"Unable to retrieve station data, please try again.", nil);
        [self showRetryAlertWithMessage: errorMessage];
        
    }];
}

#pragma mark - Error Handling
//Shows an alert controller with a message and a retry button
//When the user taps the retry button, another attempt to refresh station data will be made
- (void)showRetryAlertWithMessage: (NSString *)message
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle: @"Error" message: message preferredStyle: UIAlertControllerStyleAlert];
    UIAlertAction *retryAction = [UIAlertAction actionWithTitle: @"Retry" style: UIAlertActionStyleDefault handler: ^(UIAlertAction *action) {
        [self refreshStations];
    }];
    [alertController addAction: retryAction];
    [self presentViewController: alertController animated: YES completion: nil];
}

@end
