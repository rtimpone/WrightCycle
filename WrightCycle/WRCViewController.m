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

- (void)showRetryAlertWithTitle: (NSString *)title message: (NSString *)message retryAction: (void (^)())retryBlock
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle: title message: message preferredStyle: UIAlertControllerStyleAlert];
    
    NSString *retryString = NSLocalizedString(@"Retry", nil);
    UIAlertAction *retryAction = [UIAlertAction actionWithTitle: retryString style: UIAlertActionStyleDefault handler: retryBlock];
    [alertController addAction: retryAction];
    
    [self presentViewController: alertController animated: YES completion: nil];
}

- (void)showYesNoAlertWithTitle: (NSString *)title message: (NSString *)message yesAction: (void (^)())yesBlock noAction: (void (^)())noBlock
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle: title message: message preferredStyle: UIAlertControllerStyleAlert];
    
    NSString *yesString = NSLocalizedString(@"Yes", nil);
    UIAlertAction *yesAction = [UIAlertAction actionWithTitle: yesString style: UIAlertActionStyleDefault handler: yesBlock];
    [alertController addAction: yesAction];
    
    NSString *noString = NSLocalizedString(@"No", nil);
    UIAlertAction *noAction = [UIAlertAction actionWithTitle: noString style: UIAlertActionStyleDefault handler: noBlock];
    [alertController addAction: noAction];
    
    [self presentViewController: alertController animated: YES completion: nil];
}

@end
