//
//  WRCSetupLoginTextHandler.m
//  WrightCycle
//
//  Created by Rob Timpone on 6/27/15.
//  Copyright (c) 2015 Rob Timpone. All rights reserved.
//

#import "WRCSetupLoginTextHandler.h"

@interface WRCSetupLoginTextHandler ()

///The text field the user puts their username in
@property (weak, nonatomic) IBOutlet UITextField *usernameTextField;

///The text field the user puts their password in
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;

@end

@implementation WRCSetupLoginTextHandler

- (BOOL)validateUserInputPresentingAlertsFromController: (WRCViewController *)controller
{
    if ([self.usernameTextField.text length] == 0)
    {
        NSString *title = NSLocalizedString(@"Invalid Username", nil);
        NSString *message = NSLocalizedString(@"Username cannot be blank", nil);
        [controller showOkAlertWithTitle: title message: message];
        return NO;
    }
    
    if ([self.passwordTextField.text length] == 0)
    {
        NSString *title = NSLocalizedString(@"Invalid Password", nil);
        NSString *message = NSLocalizedString(@"Password cannot be blank", nil);
        [controller showOkAlertWithTitle: title message: message];
        return NO;
    }
    return YES;
}

- (void)setInitialUsernameText: (NSString *)usernameText passwordText: (NSString *)passwordText
{
    self.usernameTextField.text = usernameText;
    self.passwordTextField.text = passwordText;
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
        [self.delegate setupLoginTextHandlerUserDidTapDoneKeyboardKey: self];
    }
    
    return NO;
}

#pragma mark - Getters

- (NSString *)username
{
    return self.usernameTextField.text;
}

- (NSString *)password
{
    return self.passwordTextField.text;
}

#pragma mark - Setters

- (void)setUsernameTextField: (UITextField *)usernameTextField
{
    _usernameTextField = usernameTextField;
    [usernameTextField becomeFirstResponder];
}

@end
