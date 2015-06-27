//
//  WRCSetupLoginViewController.h
//  WrightCycle
//
//  Created by Rob Timpone on 6/27/15.
//  Copyright (c) 2015 Rob Timpone. All rights reserved.
//

#import "WRCSetupLoginTextHandler.h"
#import "WRCViewController.h"

@class WRCSetupLoginViewController;

@protocol WRCSetupLoginViewControllerDelegate <NSObject>

///Called when the user saves their changes to their credentials
- (void)setupLoginViewControllerUserDidUpdateCredentials: (WRCSetupLoginViewController *)controller;

@end

@interface WRCSetupLoginViewController : WRCViewController <WRCSetupLoginTextHandlerDelegate>

///The delegate to alert when the user updates their credentials
@property (weak, nonatomic) id <WRCSetupLoginViewControllerDelegate> delegate;

@end
