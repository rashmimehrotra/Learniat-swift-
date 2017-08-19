//
//  colorpopOverViewController.h
//  Learniat Teacher
//
//  Copyright (c) 2015 Mindshift Applications and Solutions Private Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface colorpopOverViewController : UIViewController
{
    UILabel                                         *fontLabel;
    id                                              _popOverController;
    CGRect                                          _rect;
//    NSMutableArray                                  *colorArray;
     NSMutableArray                                  *colorButtonArray;
    id                                              _delegate;
    int                                         selectedtab;
}

// By Ujjval
// ==========================================

@property (nonatomic) NSMutableArray *colorArray;

// ==========================================


- (void) setPopOverController:(id) pop;
- (id) popOverController;

-(void) setRect:(CGRect)rect;
-(CGRect)rect;

- (void)onColorSelectbutton:(id)sender;
- (void)onprogressBarValueChanged:(id)sender;
- (void) setDelegate:(id) del;
- (id) delegate;

-(void) setSelectTab:(int)tabTag;

@end
@protocol colorpopOverViewControllerDelegate <NSObject>

- (void)selectedColor:(id)sender withSelectedTab:(int)tabTag;
- (void)selectedbrushSize:(id)sender withSelectedTab:(int)tabTag;

@end
