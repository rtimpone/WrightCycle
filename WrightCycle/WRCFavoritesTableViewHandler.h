//
//  WRCFavoritesTableViewHandler.h
//  WrightCycle
//
//  Created by Rob Timpone on 2/28/15.
//  Copyright (c) 2015 Rob Timpone. All rights reserved.
//

@import UIKit;

#import <Foundation/Foundation.h>

@class WRCFavoritesTableViewHandler, WRCStation;

@protocol WRCFavoritesTableViewHandlerDelegate <NSObject>

/** Called when the user taps on a favorite station table view cell */
- (void)favoritesTableViewHandler: (WRCFavoritesTableViewHandler *)handler userSelectedStation: (WRCStation *)station;

/** Called when the user activates the table refresh control */
- (void)favoritesTableViewHandlerUserActivatedRefreshControl: (WRCFavoritesTableViewHandler *)handler;

@end


@interface WRCFavoritesTableViewHandler : NSObject <UITableViewDataSource, UITableViewDelegate>

/** The delegate to alert when the user taps a station cell */
@property (weak, nonatomic) IBOutlet id <WRCFavoritesTableViewHandlerDelegate> delegate;

/** Updates the data source with a list of favorite stations and reload the table view */
- (void)updateTableWithFavoriteStations: (NSArray *)favoriteStations;

/** Brings the tableview into or out of editing mode */
- (void)toggleTableViewEditing;

@end
