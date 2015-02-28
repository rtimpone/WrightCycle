//
//  WRCFavoritesTableDataSource.m
//  WrightCycle
//
//  Created by Rob Timpone on 2/28/15.
//  Copyright (c) 2015 Rob Timpone. All rights reserved.
//

#import "WRCFavoritesTableDataSource.h"
#import "WRCStation.h"

@interface WRCFavoritesTableDataSource ()

/** The table view to display the favorite stations in */
@property (weak, nonatomic) IBOutlet UITableView *tableView;

/** The favorite stations to display in the table view */
@property (strong, nonatomic) NSArray *favoriteStations;

@end


@implementation WRCFavoritesTableDataSource

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

#pragma mark - Helpers

- (void)updateTableWithFavoriteStations: (NSArray *)favoriteStations
{
    self.favoriteStations = favoriteStations;
    [self.tableView reloadData];
}

@end
