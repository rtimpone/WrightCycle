//
//  WRCSetupLoginTextHandler.h
//  WrightCycle
//
//  Created by Rob Timpone on 6/27/15.
//  Copyright (c) 2015 Rob Timpone. All rights reserved.
//

@import Foundation;
@import UIKit;

#import "WRCViewController.h"

@class WRCSetupLoginTextHandler;

@protocol WRCSetupLoginTextHandlerDelegate <NSObject>

///Called when the user taps the 'done' button on the keyboard
- (void)setupLoginTextHandlerUserDidTapDoneKeyboardKey: (WRCSetupLoginTextHandler *)textHandler;

@end

@interface WRCSetupLoginTextHandler : NSObject <UITextFieldDelegate>

///The delegate to alert when the user taps the 'done' key on the keyboard
@property (weak, nonatomic) IBOutlet id <WRCSetupLoginTextHandlerDelegate> delegate;

///The user's input for 'username'
@property (strong, nonatomic, readonly) NSString *username;

///The user's input for 'password'
@property (strong, nonatomic, readonly) NSString *password;

/** Validates that the user's input is not blank
 
 Shows an alert view to the user if either field is blank
 
 @param controller The controller to present alerts from if the validation fails.
 @return YES if the user has non-blank values for username and password.
 
 */
- (BOOL)validateUserInputPresentingAlertsFromController: (WRCViewController *)controller;

///Set the initial text for the username and password text fields
- (void)setInitialUsernameText: (NSString *)usernameText passwordText: (NSString *)passwordText;

@end
