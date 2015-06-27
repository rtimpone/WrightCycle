//
//  WRCLandingViewController.m
//  WrightCycle
//
//  Created by Rob Timpone on 2/14/15.
//  Copyright (c) 2015 Rob Timpone. All rights reserved.
//

#import "WRCNetworkingManager.h"
#import "WRCLandingViewController.h"

@implementation WRCLandingViewController

- (void)viewDidAppear: (BOOL)animated
{
    [super viewDidAppear: animated];
    [self refreshStations];
}

//Requests a refreshed list of stations from the API using the data manager
//Shows a retry alert if there is an error or the user doesn't have an internet connection
- (void)refreshStations
{
    //show a retry alert if the user doesn't have an internet connection
    if (![WRCNetworkingManager internetConnectionIsAvailable])
    {
        NSString *title = NSLocalizedString(@"No Internet Connection", nil);
        NSString *message = NSLocalizedString(@"Unable to retrieve station data, please check your internet connection and try again.", nil);
        [self showRetryAlertWithTitle: title message: message retryAction: ^() {
            [self refreshStations];
        }];
        return;
    }
    
    [[WRCNetworkingManager sharedManager] getStationsListWithSuccess: ^(NSArray *stations) {
        
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName: @"Main" bundle: nil];
        UITabBarController *tabController = [storyboard instantiateViewControllerWithIdentifier: @"tabBarController"];
        [self presentViewController: tabController animated: YES completion: nil];
        
    } failure: ^(NSError *error) {

        NSString *title = NSLocalizedString(@"Error", nil);
        NSString *message = NSLocalizedString(@"Unable to retrieve station data, please try again.", nil);
        [self showRetryAlertWithTitle: title message: message retryAction: ^() {
            [self refreshStations];
        }];
    }];
}

@end
