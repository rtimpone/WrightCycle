//
//  UILabel+WRCAdditions.m
//  WrightCycle
//
//  Created by Rob Timpone on 8/22/15.
//  Copyright (c) 2015 Rob Timpone. All rights reserved.
//

#import "UILabel+WRCAdditions.h"

@implementation UILabel (WRCAdditions)

- (void)temporarilySetTextColorToColor: (UIColor *)temporaryTextColor duration: (CGFloat)duration
{
    UIColor *originalLabelColor = self.textColor;
    
    //quickly animate the change to the new temporary color
    [UIView transitionWithView: self
                      duration: 0.25
                       options: UIViewAnimationOptionTransitionCrossDissolve
                    animations: ^{
                        self.textColor = temporaryTextColor;
                    }
                    completion: ^(BOOL finished) {
                        
                        //animate the change back to the original color using the duration param
                        [UIView transitionWithView: self
                                          duration: duration
                                           options: UIViewAnimationOptionTransitionCrossDissolve
                                        animations: ^{
                                            self.textColor = originalLabelColor;
                                        }
                                        completion: nil];
                    }];
}

@end
