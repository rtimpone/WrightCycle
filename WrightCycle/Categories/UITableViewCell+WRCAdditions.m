//
//  UITableViewCell+WRCAdditions.m
//  WrightCycle
//
//  Created by Rob Timpone on 8/22/15.
//  Copyright (c) 2015 Rob Timpone. All rights reserved.
//

#import "UILabel+WRCAdditions.h"
#import "UITableViewCell+WRCAdditions.h"

@implementation UITableViewCell (WRCAdditions)

- (void)temporarilySetTextColorToColor: (UIColor *)temporaryTextColor andBackgroundColorToColor: (UIColor *)temporaryBackgroundColor duration: (CGFloat)duration
{
    [self.textLabel temporarilySetTextColorToColor: temporaryTextColor duration: duration];
    [self.detailTextLabel temporarilySetTextColorToColor: temporaryTextColor duration: duration];
    
    //quickly animate the change to the new temporary color
    UIColor *originalBackgroundColor = self.backgroundColor;
    [UIView animateWithDuration: 0.25
                     animations: ^{
                         self.backgroundColor = temporaryBackgroundColor;
                     }
                     completion: ^(BOOL finished) {
                         
                         //animate the change back to the original color using the duration param
                         [UIView animateWithDuration: duration
                                          animations: ^{
                                              self.backgroundColor = originalBackgroundColor;
                                          }];
                     }];
}

@end
