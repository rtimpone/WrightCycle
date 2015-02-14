//
//  WRCViewController.m
//  WrightCycle
//
//  Created by Rob Timpone on 2/14/15.
//  Copyright (c) 2015 Rob Timpone. All rights reserved.
//

#import "WRCViewController.h"

@implementation WRCViewController

- (void)showOkAlertWithTitle: (NSString *)title message: (NSString *)message
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle: title message: message preferredStyle: UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle: @"OK" style: UIAlertActionStyleDefault handler: nil];
    [alertController addAction: okAction];
    [self presentViewController: alertController animated: YES completion: nil];
}

- (void)showRetryAlertWithTitle: (NSString *)title message: (NSString *)message retryAction: (void (^)(UIAlertAction *action))action
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle: title message: message preferredStyle: UIAlertControllerStyleAlert];
    
    NSString *retryString = NSLocalizedString(@"Retry", nil);
    UIAlertAction *retryAction = [UIAlertAction actionWithTitle: retryString style: UIAlertActionStyleDefault handler: action];
    [alertController addAction: retryAction];
    
    [self presentViewController: alertController animated: YES completion: nil];
}

@end
