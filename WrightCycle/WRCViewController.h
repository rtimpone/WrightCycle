//
//  WRCViewController.h
//  WrightCycle
//
//  Created by Rob Timpone on 2/14/15.
//  Copyright (c) 2015 Rob Timpone. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WRCViewController : UIViewController

/** Show an alert controller with a title, message, and a single OK button 
 
 @param title The title to show at the top of the alert.
 @param message The message to display in the alert.
 
 */
- (void)showOkAlertWithTitle: (NSString *)title message: (NSString *)message;

/** Show an alert controller with a title, message, and a single Retry button. 
 
 When the user taps the retry button, the action block will be called 
 
 @param title The title to show at the top of the alert.
 @param message The message to display in the alert.
 @param action The block to execute when the user taps on the Retry button. Usually to re-attempt some action that failed.
 
 */
- (void)showRetryAlertWithTitle: (NSString *)title message: (NSString *)message retryAction: (void (^)(UIAlertAction *action))action;

@end
