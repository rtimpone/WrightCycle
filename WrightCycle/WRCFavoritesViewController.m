//
//  WRCFavoritesViewController.m
//  WrightCycle
//
//  Created by Rob Timpone on 2/28/15.
//  Copyright (c) 2015 Rob Timpone. All rights reserved.
//

#import "WRCDataManager.h"
#import "WRCFavoritesTableDataSource.h"
#import "WRCFavoritesViewController.h"

@interface WRCFavoritesViewController ()

@property (strong, nonatomic) IBOutlet WRCFavoritesTableDataSource *tableDataSource;

@end


@implementation WRCFavoritesViewController

- (void)viewWillAppear: (BOOL)animated
{
    [super viewWillAppear: animated];
    
    NSArray *favoriteStations = [[WRCDataManager sharedManager] fetchFavoriteStations];
    [self.tableDataSource updateTableWithFavoriteStations: favoriteStations];
}

@end
