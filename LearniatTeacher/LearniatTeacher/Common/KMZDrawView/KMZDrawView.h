//
//  KMZCanvasView.h
//  KMZDraw
//
//  Created by Kentaro Matsumae on 12/06/09.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KMZFrame.h"

@class KMZDrawView;

@protocol KMZDrawViewDelegate
- (void)drawView:(KMZDrawView*)drawView finishDrawLine:(KMZLine*)line;
@end

@interface KMZDrawView : UIImageView
{
    __unsafe_unretained  id delegate;
}
@property (nonatomic, weak) id<KMZDrawViewDelegate> delegate;

@property (nonatomic) CGPoint lastPoint;
@property (nonatomic) KMZFrame* currentFrame;
@property (nonatomic) KMZLine* currentLine;
@property (nonatomic) KMZLinePenMode penMode;
@property (nonatomic) NSUInteger penWidth;
@property (nonatomic) UIColor* penColor;

@property (nonatomic) UIView *eraser;

- (void)setPenMode:(KMZLinePenMode)penMode;
- (void)undo;
- (void)redo;
- (BOOL)isUndoable;
- (BOOL)isRedoable;
- (void)clear;

@end
