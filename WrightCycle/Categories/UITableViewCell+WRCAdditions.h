//
//  UITableViewCell+WRCAdditions.h
//  WrightCycle
//
//  Created by Rob Timpone on 8/22/15.
//  Copyright (c) 2015 Rob Timpone. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITableViewCell (WRCAdditions)

/** Set the color of a cell's label and background, then animate them back to their original color.
 
 Uses UIView's animateWithDuration: methods to animate the background color change. Uses a UILabel
 category to handle the text color animations for the cell's textLabel and detailTextLabel. The 
 colors are quickly changed to the temporary color using animation, then they are animated back 
 to the original colors using the duration param.
 
 @param temporaryTextColor The color to temporarily change the cell's textLabel and detailTextLabel textColors to.
 @param temporaryBackgroundColor The color to temporarily change the cell's backgroundColor to.
 @param duration The amount of time in seconds the animation back to the original colors should take.
 
 */
- (void)temporarilySetTextColorToColor: (UIColor *)temporaryTextColor andBackgroundColorToColor: (UIColor *)temporaryBackgroundColor duration: (CGFloat)duration;

@end
