//
//  WRCFavoritesViewController.m
//  WrightCycle
//
//  Created by Rob Timpone on 2/28/15.
//  Copyright (c) 2015 Rob Timpone. All rights reserved.
//

#import "WRCFavoriteStationsManager.h"
#import "WRCFavoritesViewController.h"
#import "WRCStationDetailsViewController.h"
#import "WRCStationsRequestHandler.h"

@interface WRCFavoritesViewController ()

/** A custom object that handles the table view's data source and table view user interaction */
@property (strong, nonatomic) IBOutlet WRCFavoritesTableViewHandler *tableViewHandler;

/** The station that the user selected from the table view */
@property (strong, nonatomic) WRCStation *selectedStation;

@end


@implementation WRCFavoritesViewController

- (void)viewWillAppear: (BOOL)animated
{
    [super viewWillAppear: animated];
    [self refreshFavoriteStations];
}

- (void)prepareForSegue: (UIStoryboardSegue *)segue sender: (id)sender
{
    if ([segue.identifier isEqualToString: @"stationDetailsSegue"])
    {
        WRCStationDetailsViewController *vc = segue.destinationViewController;
        vc.station = self.selectedStation;
    }
}

#pragma mark - Favorites Table View Handler Delegate

//Called when the user taps on a table view cell
//Segues to the station details screen for the selected station
- (void)favoritesTableViewHandler: (WRCFavoritesTableViewHandler *)handler userSelectedStation: (WRCStation *)station
{
    self.selectedStation = station;
    [self performSegueWithIdentifier: @"stationDetailsSegue" sender: self];
}

//Called when the user activates the table view's refresh control
//Tells the request handler to get fresh data from the API
- (void)favoritesTableViewHandlerUserActivatedRefreshControl: (WRCFavoritesTableViewHandler *)handler
{
    [[WRCStationsRequestHandler sharedManager] getStationsListImmediately: YES
                                                              withSuccess: ^(NSArray *stations) {
        
                                                                  [self refreshFavoriteStations];
        
                                                              } failure: ^(NSError *error) {
        
                                                                  NSString *title = NSLocalizedString(@"Error", nil);
                                                                  NSString *message = NSLocalizedString(@"Unable to refresh station data.", nil);
                                                                  [self showOkAlertWithTitle: title message: message];
                                                                  
                                                              }];
}

#pragma mark - Helpers

//Fetches the favorite stations from the data manager and passes them to the table view handler to update the table
- (void)refreshFavoriteStations
{
    NSArray *favoriteStations = [WRCFavoriteStationsManager fetchFavoriteStations];
    [self.tableViewHandler updateTableWithFavoriteStations: favoriteStations];
}

@end
