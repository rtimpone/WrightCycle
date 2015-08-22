//
//  UILabel+WRCAdditions.h
//  WrightCycle
//
//  Created by Rob Timpone on 8/22/15.
//  Copyright (c) 2015 Rob Timpone. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UILabel (WRCAdditions)

/** Set the text color of a label, then animate it back to its original color with animation.
 
 Uses UIView's transitionWithView:duration:options:animations:completion: method to cross dissolve
 animate the text change. The text color is quickly changed to the temporary color using animation,
 then is animated back to the original text color using the duration param. 
 
 @param temporaryTextColor The color to temporarily change the label's textColor to
 @param duration The amount of time the animation back to the original text color should take.
 
 */
- (void)temporarilySetTextColorToColor: (UIColor *)temporaryTextColor duration: (CGFloat)duration;

@end
