//
//  DynamicFontSize.h
//  Learniat Teacher
//
//  Copyright (c) 2015 Mindshift Applications and Solutions Private Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum
{
    VerticalAlignmentTop = 0, // default
    VerticalAlignmentMiddle,
    VerticalAlignmentBottom,
} VerticalAlignment;

@interface DynamicFontSize : UILabel
{
    CGSize  labelSize;
    UILabel * subLabel;
}
@property (nonatomic, readwrite) VerticalAlignment verticalAlignment;
@property (nonatomic, readwrite) UIColor            *subLableColor;
-(void) adjustFontSizeToFillItsContents;
-(void)resizeToStretch;
- (void) adjustHeight;
- (void) adjustWidth;
-(CGSize)returnLabelSize;
- (void) setLabelText:(NSString *)text;
- (void) setlabelWithWidthChange:(NSString*)text;
- (void) setDoubtTextWithNoChangeinSize:(NSString *)text;
@end
