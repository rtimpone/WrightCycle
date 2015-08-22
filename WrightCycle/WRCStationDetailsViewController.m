//
//  WRCStationDetailsViewController.m
//  WrightCycle
//
//  Created by Rob Timpone on 2/14/15.
//  Copyright (c) 2015 Rob Timpone. All rights reserved.
//

#import "UIColor+WRCAdditions.h"
#import "UILabel+WRCAdditions.h"
#import "WRCAutoRefreshDataManager.h"
#import "WRCFavoriteStationsManager.h"
#import "WRCInterappURLManager.h"
#import "WRCStation.h"
#import "WRCStationDetailsMapViewHandler.h"
#import "WRCStationDetailsViewController.h"
#import "WRCStationsRequestHandler.h"

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
    [self.mapViewHandler zoomInOnStation: self.station];
    
    //refresh the stations list if needed and fail silently
    [[WRCStationsRequestHandler sharedManager] getStationsListWithSuccess: ^(NSArray *stations) {
        
        NSPredicate *predicate = [NSPredicate predicateWithFormat: @"stationId = %@", self.station.stationId];
        self.station = [[stations filteredArrayUsingPredicate: predicate] firstObject];
        [self updateStationLabelsText];
        
    } failure: nil];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear: animated];
    
    //listen for when the stations data is automatically updated
    [[NSNotificationCenter defaultCenter] addObserver: self selector: @selector(didReceiveStationsUpdateNotification:) name: kStationsUpdatedNotification object: nil];
}

- (void)viewWillDisappear: (BOOL)animated
{
    [super viewWillDisappear: animated];
    [[NSNotificationCenter defaultCenter] removeObserver: self];
}

#pragma mark - Actions

//Add or remove the station from the user's favorites list
- (IBAction)modifyFavoritesAction: (id)sender
{
    if ([WRCFavoriteStationsManager stationIsFavorite: self.station])
    {
        [WRCFavoriteStationsManager removeStationFromFavorites: self.station];
    }
    else
    {
        [WRCFavoriteStationsManager addStationAsFavorite: self.station];
    }
    
    [self updateFavoritesButtonText];
}

//Open the station in Google Maps if possible, otherwise open in Apple Maps
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

#pragma mark - Notification Center Callbacks

//Called when station data is automatically updated by the auto refresh data manager
//Updates the stations being shown in the mapview
- (void)didReceiveStationsUpdateNotification: (NSNotification *)notification
{
    dispatch_async(dispatch_get_main_queue(), ^{
        NSArray *stations = notification.object;
        NSPredicate *predicate = [NSPredicate predicateWithFormat: @"stationId = %@", self.station.stationId];
        WRCStation *updatedStation = [[stations filteredArrayUsingPredicate: predicate] firstObject];
        
        if (updatedStation)
        {
            WRCStation *originalStation = self.station;
            
            self.station = updatedStation;
            [self updateStationLabelsText];
            
            BOOL bikeCountChanged = updatedStation.availableBikes.integerValue != originalStation.availableBikes.integerValue;
            if (bikeCountChanged)
            {
                [self animateTextColorChangeForLabel: self.numBikesLabel];
            }
        
            BOOL dockCountChanged = updatedStation.availableDocks.integerValue != originalStation.availableDocks.integerValue;
            if (dockCountChanged)
            {
                [self animateTextColorChangeForLabel: self.numDocksLabel];
            }
            
            if (bikeCountChanged || dockCountChanged)
            {
                self.mapViewHandler.station = updatedStation;
            }
        }
    });
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
    NSString *buttonText = [WRCFavoriteStationsManager stationIsFavorite: self.station] ? removeFromFavoritesString : addToFavoritesString;
    
    [self.favoriteButton setTitle: buttonText forState: UIControlStateNormal];
}

#pragma mark - Helpers

//Use animation to change a label's color to blue for 3 seconds
- (void)animateTextColorChangeForLabel: (UILabel *)label
{
    [label temporarilySetTextColorToColor: [UIColor mediumBlueColor] duration: 3];
}

@end
