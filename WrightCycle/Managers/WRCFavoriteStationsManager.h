//
//  WRCFavoriteStationsManager.h
//  WrightCycle
//
//  Created by Rob Timpone on 6/13/15.
//  Copyright (c) 2015 Rob Timpone. All rights reserved.
//

#import <Foundation/Foundation.h>

@class WRCStation;

@interface WRCFavoriteStationsManager : NSObject

/** Add a station to the favorites list
 
 This will add the station's id to the favorites list stored in user defaults
 
 @param station The station to add as a favorite
 
 */
+ (void)addStationAsFavorite: (WRCStation *)station;

/** Remove a station from the favorites list
 
 This will remove the station's id from the favorites list stored in user defaults
 
 @param station The station to remove from the favorites list
 
 */
+ (void)removeStationFromFavorites: (WRCStation *)station;

/** Change where a station appears on the favorites list
 
 This will update the order that the favorite stations list appears in
 
 @param sourceIndex The index of the station to move
 @param destinationIndex The index to move the station to
 
 */
+ (void)moveFavoriteStationAtIndex: (NSInteger)sourceIndex toIndex: (NSInteger)destinationIndex;

/** Whether a station is in the favories list
 
 Checks the list of favorite station ids stored in user defaults to see if the station is a favorite.
 
 @return Whether the station is a favorite
 
 */
+ (BOOL)stationIsFavorite: (WRCStation *)station;

/** The current list of the user's favorite stations
 
 Stored as an array in user defaults to preserve the way the user may have ordered the list.
 
 @return An array containing the user's favorite stations
 
 */
+ (NSArray *)fetchFavoriteStations;

@end
