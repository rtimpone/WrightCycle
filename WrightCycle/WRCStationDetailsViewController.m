//
//  WRCStationDetailsViewController.m
//  WrightCycle
//
//  Created by Rob Timpone on 2/14/15.
//  Copyright (c) 2015 Rob Timpone. All rights reserved.
//

#import "WRCDataManager.h"
#import "WRCInterappURLManager.h"
#import "WRCStation.h"
#import "WRCStationDetailsMapViewHandler.h"
#import "WRCStationDetailsViewController.h"

@interface WRCStationDetailsViewController ()

/** A label that displays the number of bikes available */
@property (weak, nonatomic) IBOutlet UILabel *numBikesLabel;

/** A label that displays the number of docks available */
@property (weak, nonatomic) IBOutlet UILabel *numDocksLabel;

/** The button used to add or remove the station from the favorites list */
@property (weak, nonatomic) IBOutlet UIButton *favoriteButton;

/** Handles displaying the station's location in the map view */
@property (strong, nonatomic) IBOutlet WRCStationDetailsMapViewHandler *mapViewHandler;

@end


@implementation WRCStationDetailsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self updateFavoritesButtonText];
    [self updateStationLabelsText];
    
    self.mapViewHandler.station = self.station;
    
    //refresh the stations list if needed
    [[WRCDataManager sharedManager] getStationsListWithSuccess: ^(NSArray *stations) {
        
        NSPredicate *predicate = [NSPredicate predicateWithFormat: @"stationId = %@", self.station.stationId];
        self.station = [[stations filteredArrayUsingPredicate: predicate] firstObject];
        [self updateStationLabelsText];
        
    } failure: nil];
}

#pragma mark - Actions

- (IBAction)modifyFavoritesAction: (id)sender
{
    if ([[WRCDataManager sharedManager] stationIsFavorite: self.station])
    {
        [[WRCDataManager sharedManager] removeStationFromFavorites: self.station];
    }
    else
    {
        [[WRCDataManager sharedManager] addStationAsFavorite: self.station];
    }
    
    [self updateFavoritesButtonText];
}

- (IBAction)getDirectionsAction: (id)sender
{
    if ([WRCInterappURLManager canOpenGoogleMaps])
    {
        NSURL *googleMapsURL = [WRCInterappURLManager googleMapsURLForDirectionsToLocation: self.station.coordinate transportationMode: WRCGoogleMapsTransportationModeWalking];
        [[UIApplication sharedApplication] openURL: googleMapsURL];
    }
    else if ([WRCInterappURLManager canOpenAppleMaps])
    {
        NSURL *appleMapsURL = [WRCInterappURLManager appleMapsURLForDirectionsToLocation: self.station.coordinate];
        [[UIApplication sharedApplication] openURL: appleMapsURL];
    }
    else
    {
        NSString *title = NSLocalizedString(@"Could Not Find Maps App", nil);
        NSString *message = NSLocalizedString(@"To get directions to this stations, you must have Google Maps or Apple Maps installed.", nil);
        [self showOkAlertWithTitle: title message: message];
    }
}

#pragma mark - UI Updates

- (void)updateStationLabelsText
{
    self.navigationItem.title = self.station.title;
    
    NSString *bikesString = NSLocalizedString(@"Bikes", nil);
    NSString *docksString = NSLocalizedString(@"Docks", nil);
    
    self.numBikesLabel.text = [NSString stringWithFormat: @"%@: %@", bikesString, self.station.availableBikes];
    self.numDocksLabel.text = [NSString stringWithFormat: @"%@: %@", docksString, self.station.availableDocks];
}

- (void)updateFavoritesButtonText
{
    NSString *addToFavoritesString = NSLocalizedString(@"Add to Favorites", nil);
    NSString *removeFromFavoritesString = NSLocalizedString(@"Remove from Favorites", nil);
    NSString *buttonText = [[WRCDataManager sharedManager] stationIsFavorite: self.station] ? removeFromFavoritesString : addToFavoritesString;
    
    [self.favoriteButton setTitle: buttonText forState: UIControlStateNormal];
}

@end
