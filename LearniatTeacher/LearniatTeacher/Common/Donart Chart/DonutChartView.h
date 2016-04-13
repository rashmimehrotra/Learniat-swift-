//
//  DonutChartView.h
//  Learniat Teacher
//
//  Copyright (c) 2015 Mindshift Applications and Solutions Private Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DonutChartView : UIView
/**
 * The progress of the view.
 **/
@property (nonatomic, assign) CGFloat progress;

/**
 * The width of the line used to draw the progress view.
 **/
@property (nonatomic, assign) CGFloat lineWidth;

/**
 * The color of the progress view
 */
@property (nonatomic, strong) UIColor *tintColor;

/**
 * The color of the tick view
 */
@property (nonatomic, strong) UIColor *tickColor;

/**
 * Icon view to be rendered instead of default arrow
 */
@property (nonatomic, strong) UIView* iconView;

/**
 * Bezier path to be rendered instead of icon view or default arrow
 */
@property (nonatomic, strong) UIBezierPath* iconPath;

/**
 * You can hide the icons which are shown during progress
 */
@property (readwrite) BOOL hideProgressIcons;

/**
 * Make the background layer to spin around its center. This should be called in the main thread.
 */
- (void) startSpinProgressBackgroundLayer;

/**
 * Stop the spinning of the background layer. This should be called in the main thread.
 * WARN: This implementation remove all animations from background layer.
 **/
- (void) stopSpinProgressBackgroundLayer;



- (void) setTinitColor:(UIColor*)color;
@end
