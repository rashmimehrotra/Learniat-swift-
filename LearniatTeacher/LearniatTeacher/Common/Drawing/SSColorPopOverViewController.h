//
//  SSColorPopOverViewController.h
//  Learniat Teacher
//
//  Copyright (c) 2015 Mindshift Applications and Solutions Private Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SSColorPopOverViewController : UIViewController
{
    
    id					  _delegate;
	id			 _popOverController;
    UIButton                   *mRedColorButton;
    UIButton                  *mBlueColorButton;
    UIButton                 *mGreenColorButton;
    NSInteger               _lastSelectedColour;
    int Counter;
    UILabel *fontLabel;
    CGRect _rect;
    NSMutableArray *colorArray;

}
- (void) setDelegate:(id) del;
- (id) delegate;
- (void) setPopOverController:(id) pop;
- (id) popOverController;
-(void) setRect:(CGRect)rect;
-(CGRect)rect;
- (void)setSelectedColor:(NSInteger)selectedColor;
@end
