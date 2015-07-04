//
//  WRCFavoritesTableViewHandler.m
//  WrightCycle
//
//  Created by Rob Timpone on 2/28/15.
//  Copyright (c) 2015 Rob Timpone. All rights reserved.
//

#import "WRCFavoritesTableViewHandler.h"
#import "WRCStation.h"
#import "WRCFavoriteStationsManager.h"

@interface WRCFavoritesTableViewHandler ()

/** The table view to display the favorite stations in */
@property (weak, nonatomic) IBOutlet UITableView *tableView;

/** The edit button used to toggle table view editing */
@property (weak, nonatomic) IBOutlet UIBarButtonItem *editButton;

/** The favorite stations to display in the table view */
@property (strong, nonatomic) NSArray *favoriteStations;

/** The refresh control to handle pull to refresh functionality */
@property (strong, nonatomic) UIRefreshControl *refreshControl;

@end


@implementation WRCFavoritesTableViewHandler

#pragma mark - Table View Data Source

- (NSInteger)tableView: (UITableView *)tableView numberOfRowsInSection: (NSInteger)section
{
    return [self.favoriteStations count];
}

- (UITableViewCell *)tableView: (UITableView *)tableView cellForRowAtIndexPath: (NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"favoritesCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: CellIdentifier];
    
    WRCStation *station = self.favoriteStations[indexPath.row];
    cell.textLabel.text = station.title;
    
    NSString *bikesString = NSLocalizedString(@"Bikes", nil);
    NSString *docksString = NSLocalizedString(@"Docks", nil);
    cell.detailTextLabel.text = [NSString stringWithFormat: @"%@: %@, %@: %@", bikesString, station.availableBikes, docksString, station.availableDocks];
    
    return cell;
}

#pragma mark - Table View Delegate

- (void)tableView: (UITableView *)tableView didSelectRowAtIndexPath: (NSIndexPath *)indexPath
{
    WRCStation *selectedStation = self.favoriteStations[indexPath.row];
    [self.delegate favoritesTableViewHandler: self userSelectedStation: selectedStation];
    [tableView deselectRowAtIndexPath: indexPath animated: YES];
}

- (void)tableView: (UITableView *)tableView commitEditingStyle: (UITableViewCellEditingStyle)editingStyle forRowAtIndexPath: (NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        //update the favorite stations list stored in user defaults
        WRCStation *station = self.favoriteStations[indexPath.row];
        [WRCFavoriteStationsManager removeStationFromFavorites: station];
        
        //update the tableview and data source
        self.favoriteStations = [WRCFavoriteStationsManager fetchFavoriteStations];
        [self.tableView deleteRowsAtIndexPaths: @[indexPath] withRowAnimation: UITableViewRowAnimationAutomatic];
    }
}

- (BOOL)tableView: (UITableView *)tableView canMoveRowAtIndexPath: (NSIndexPath *)indexPath
{
    return YES;
}

- (void)tableView: (UITableView *)tableView moveRowAtIndexPath: (NSIndexPath *)sourceIndexPath toIndexPath: (NSIndexPath *)destinationIndexPath
{
    [WRCFavoriteStationsManager moveFavoriteStationAtIndex: sourceIndexPath.row toIndex: destinationIndexPath.row];
    self.favoriteStations = [WRCFavoriteStationsManager fetchFavoriteStations];
}

#pragma mark - Actions

//Called when the user activates the refresh control
//Alerts the delegate that the refresh control was activated
- (void)refreshControlAction
{
    [self.delegate favoritesTableViewHandlerUserActivatedRefreshControl: self];
}

#pragma mark - Setters

//Sets up a refresh control when the table view is set
- (void)setTableView: (UITableView *)tableView
{
    _tableView = tableView;
    
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget: self action: @selector(refreshControlAction) forControlEvents: UIControlEventValueChanged];
    [tableView addSubview: refreshControl];
    [tableView sendSubviewToBack: refreshControl];

    self.refreshControl = refreshControl;
}

#pragma mark - Helpers

//Stops the refresh control, updates the favorites stations array, and reloads the table view
- (void)updateTableWithFavoriteStations: (NSArray *)favoriteStations
{
    if (self.refreshControl.isRefreshing)
    {
        [self.refreshControl endRefreshing];
    }
    
    self.favoriteStations = favoriteStations;
    [self.tableView reloadData];
}

//Brings the tableview into or out of editing mode
- (void)toggleTableViewEditing
{
    if (self.tableView.isEditing)
    {
        [self.tableView setEditing: NO animated: YES];
        self.editButton.title = NSLocalizedString(@"Edit", nil);
    }
    else
    {
        [self.tableView setEditing: YES animated: YES];
        self.editButton.title = NSLocalizedString(@"Done", nil);
    }
}

@end
