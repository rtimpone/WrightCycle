//
//  WRCFavoritesTableDataSource.m
//  WrightCycle
//
//  Created by Rob Timpone on 2/28/15.
//  Copyright (c) 2015 Rob Timpone. All rights reserved.
//

#import "WRCFavoritesTableDataSource.h"

@interface WRCFavoritesTableDataSource ()

@property (strong, nonatomic) NSArray *favoriteStations;

@property (weak, nonatomic) IBOutlet UITableView *tableView;
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
    
    //configure cell
    
    return cell;
}

#pragma mark - Helpers

- (void)updateTableWithFavoriteStations: (NSArray *)favoriteStations
{
    self.favoriteStations = favoriteStations;
    
    //reload table view
}

@end
