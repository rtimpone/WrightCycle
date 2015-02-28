//
//  WRCFavoritesTableViewHandler.h
//  WrightCycle
//
//  Created by Rob Timpone on 2/28/15.
//  Copyright (c) 2015 Rob Timpone. All rights reserved.
//

@import UIKit;

#import <Foundation/Foundation.h>

@interface WRCFavoritesTableViewHandler : NSObject <UITableViewDataSource, UITableViewDelegate>

/** Updates the data source with a list of favorite stations and reload the table view */
- (void)updateTableWithFavoriteStations: (NSArray *)favoriteStations;

@end
