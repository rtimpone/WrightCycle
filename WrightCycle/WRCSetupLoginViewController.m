//
//  WRCSetupLoginViewController.m
//  WrightCycle
//
//  Created by Rob Timpone on 6/27/15.
//  Copyright (c) 2015 Rob Timpone. All rights reserved.
//

#import "WRCSetupLoginViewController.h"
#import "WrightCycle-Swift.h"

@interface WRCSetupLoginViewController ()

///Created in the storyboard, handles text field delegate methods and text validation
@property (strong, nonatomic) IBOutlet WRCSetupLoginTextHandler *textHandler;

@end

@implementation WRCSetupLoginViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSString *savedUsernameText = [[WRCKeychainManager sharedInstance] retrieveStringFromKeychainOfType: WRCKeychainItemTypeUsername];
    NSString *savedPasswordText = [[WRCKeychainManager sharedInstance] retrieveStringFromKeychainOfType: WRCKeychainItemTypePassword];
    [self.textHandler setInitialUsernameText: savedUsernameText passwordText: savedPasswordText];
}

#pragma mark - Setup Login Text Handler Delegate

- (void)setupLoginTextHandlerUserDidTapDoneKeyboardKey: (WRCSetupLoginTextHandler *)textHandler
{
    [self processUserInputAndDismissIfValid];
}

#pragma mark - Actions

///Dismiss the keyboard and dismiss self
- (IBAction)cancelAction: (id)sender
{
    [self.view endEditing: YES];
    [self dismissViewControllerAnimated: YES completion: nil];
}

///Attempt to validate and save the user's input
- (IBAction)doneAction: (id)sender
{
    [self processUserInputAndDismissIfValid];
}

///Present a yes/no alert to the user and, if they tap yes, reset anything saved in the keychain for this app
- (IBAction)resetAction: (id)sender
{
    [self.view endEditing: YES];
    
    NSString *title = NSLocalizedString(@"Confirm Reset", nil);
    NSString *message = NSLocalizedString(@"Are you sure you want to reset your saved credentials?", nil);
    [self showYesNoAlertWithTitle: title message: message yesAction: ^{
        
        [[WRCKeychainManager sharedInstance] resetItemsSavedInKeychain];
        
        NSString *title = NSLocalizedString(@"Credentials Reset", nil);
        NSString *message = NSLocalizedString(@"Your saved credentials have been reset", nil);
        [self showOkAlertWithTitle: title message: message okAction: ^{
            [self dismissViewControllerAnimated: YES completion: nil];
        }];
        
    } noAction: nil];
}

#pragma mark - Helpers

///Validate the user's input and, if valid, save to the keychain and dismiss self
- (void)processUserInputAndDismissIfValid
{
    [self.view endEditing: YES];
    
    if ([self.textHandler validateUserInputPresentingAlertsFromController: self])
    {
        [[WRCKeychainManager sharedInstance] saveStringToKeychain: self.textHandler.username ofItemType: WRCKeychainItemTypeUsername];
        [[WRCKeychainManager sharedInstance] saveStringToKeychain: self.textHandler.password ofItemType: WRCKeychainItemTypePassword];
        
        [self dismissViewControllerAnimated: YES completion: nil];
        [self.delegate setupLoginViewControllerUserDidUpdateCredentials: self];
    }
}

@end
