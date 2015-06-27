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

///The text field the user puts their username in
@property (weak, nonatomic) IBOutlet UITextField *usernameTextField;

///The text field the user puts their password in
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;

@end

@implementation WRCSetupLoginViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.usernameTextField becomeFirstResponder];
}

#pragma mark - Text Field Delegate

- (BOOL)textFieldShouldReturn: (UITextField *)textField
{
    if (textField == self.usernameTextField)
    {
        [self.passwordTextField becomeFirstResponder];
    }
    else
    {
        [textField resignFirstResponder];
        if ([self validateAndSaveUserInput])
        {
            [self dismissViewControllerAnimated: YES completion: nil];
        }
    }
    
    return NO;
}

#pragma mark - Actions

- (IBAction)cancelAction: (id)sender
{
    [self.view endEditing: YES];
    [self dismissViewControllerAnimated: YES completion: nil];
}

- (IBAction)doneAction: (id)sender
{
    if ([self validateAndSaveUserInput])
    {
        [self dismissViewControllerAnimated: YES completion: nil];
    }
}

- (IBAction)resetAction: (id)sender
{
    [self.view endEditing: YES];
    
    NSString *title = NSLocalizedString(@"Confirm Reset", nil);
    NSString *message = NSLocalizedString(@"Are you sure you want to reset any saved credentials?", nil);
    [self showYesNoAlertWithTitle: title message: message yesAction: ^{
        
        [[WRCKeychainManager sharedInstance] resetItemsSavedInKeychain];
        
        NSString *title = NSLocalizedString(@"Credentials Reset", nil);
        NSString *message = NSLocalizedString(@"Your credentials have been reset", nil);
        [self showOkAlertWithTitle: title message: message];
        
    } noAction: nil];
}

#pragma mark - Helpers

- (BOOL)validateAndSaveUserInput
{
    if ([self.usernameTextField.text length] == 0)
    {
        NSString *title = NSLocalizedString(@"Invalid Username", nil);
        NSString *message = NSLocalizedString(@"Username cannot be blank", nil);
        [self showOkAlertWithTitle: title message: message];
        return NO;
    }
    
    if ([self.passwordTextField.text length] == 0)
    {
        NSString *title = NSLocalizedString(@"Invalid Password", nil);
        NSString *message = NSLocalizedString(@"Password cannot be blank", nil);
        [self showOkAlertWithTitle: title message: message];
        return NO;
    }
    
    [[WRCKeychainManager sharedInstance] saveStringToKeychain: self.usernameTextField.text ofItemType: WRCKeychainItemTypeUsername];
    [[WRCKeychainManager sharedInstance] saveStringToKeychain: self.passwordTextField.text ofItemType: WRCKeychainItemTypePassword];
    
    return YES;
}

@end
