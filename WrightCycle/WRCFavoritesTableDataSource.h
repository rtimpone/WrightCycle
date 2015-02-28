//
//  WRCFavoritesTableDataSource.h
//  WrightCycle
//
//  Created by Rob Timpone on 2/28/15.
//  Copyright (c) 2015 Rob Timpone. All rights reserved.
//

@import UIKit;

#import <Foundation/Foundation.h>

@interface WRCFavoritesTableDataSource : NSObject <UITableViewDataSource, UITableViewDelegate>

- (void)updateTableWithFavoriteStations: (NSArray *)favoriteStations;

@end
