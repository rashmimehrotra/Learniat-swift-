//
//  DottedLine.h
//  Learniat_Student_Iphone
//
//  Created by Deepak MK on 09/02/16.
//  Copyright © 2016 mindShiftApps. All rights reserved.
//

#import <UIKit/UIKit.h>


/**
 *  Simple UIView for a dotted line
 */
@interface DottedLine : UIView

/**
 *  Set the line's thickness
 */
@property (nonatomic, assign) CGFloat thickness;

/**
 *  Set the line's color
 */
@property (nonatomic, copy) UIColor *color;

/**
 *  Set the length of the dash
 */
@property (nonatomic, assign) CGFloat dashedLength;

/**
 *  Set the gap between dashes
 */
@property (nonatomic, assign) CGFloat dashedGap;


- (void)drawDashedBorderAroundViewWithColor:(UIColor*)color;

- (void)drawDashedBorderVertically:(UIColor*)color;

@end
