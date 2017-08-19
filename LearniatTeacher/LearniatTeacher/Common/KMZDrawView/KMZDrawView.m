//
//  KMZCanvasView.m
//  KMZDraw
//
//  Created by Kentaro Matsumae on 12/06/09.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "KMZDrawView.h"

@interface KMZDrawView()

@end

@implementation KMZDrawView

- (id)initWithCoder:(NSCoder *)aDecoder {
    if ((self = [super initWithCoder:aDecoder])) {
        [self _setupWithFrame:self.frame];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self _setupWithFrame:frame];
    }
    return self;
}

#pragma mark private functions

- (void)_setupWithFrame:(CGRect)frame {
    self.backgroundColor = [UIColor clearColor];
    self.userInteractionEnabled = YES;

    self.currentFrame = [[KMZFrame alloc] init];
    self.penMode = KMZLinePenModePencil;
    self.penWidth = 10;
    self.penColor = [UIColor blackColor];
    
    self.eraser = [[UIView alloc] initWithFrame:CGRectZero];
    self.eraser.layer.borderWidth = 1.0;
    self.eraser.layer.borderColor = [[UIColor blackColor] CGColor];
    self.eraser.hidden = YES;
    [self addSubview:self.eraser];
}

- (void)layoutSubviews {
    self.currentFrame.frameSize = self.frame.size;
}

#pragma mark UIResponder

- (void)touchesBegan:(NSSet*)touches withEvent:(UIEvent*)event {
	CGPoint pt = [[touches anyObject] locationInView:self];
    
    if(self.penMode == KMZLinePenModeEraser) {
        self.eraser.frame = CGRectMake(pt.x, pt.y, self.penWidth, self.penWidth);
        self.eraser.layer.cornerRadius = self.eraser.frame.size.height / 2;
    }
    
    self.lastPoint = pt;
    
    CGMutablePathRef path = CGPathCreateMutable();
    
    self.currentLine = [[KMZLine alloc] initWithPenMode:self.penMode
                                                  width:self.penWidth
                                                  color:self.penColor path:path];
    
	[self.currentFrame addLine:self.currentLine];
    
	[self.currentLine moveToPoint:pt];
    
    UIGraphicsBeginImageContextWithOptions(self.bounds.size, NO, 0.0);
	[self.image drawInRect:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
}

- (void) touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
	if (!self.currentLine) {
		return;
	}
	
	CGPoint pt = [[touches anyObject] locationInView:self];
   
    if(self.penMode == KMZLinePenModeEraser) {
        self.eraser.frame = CGRectMake((pt.x - (self.penWidth/2)), (pt.y - (self.penWidth/2)), self.penWidth, self.penWidth);
        self.eraser.hidden = NO;
    }
    
	[self.currentLine addLineToPoint:pt];
	
	CGContextRef context = UIGraphicsGetCurrentContext();
	[self.currentFrame drawLine:context line:self.currentLine beginPoint:self.lastPoint endPoint:pt];
	self.image = UIGraphicsGetImageFromCurrentImageContext();
	
	self.lastPoint = pt;
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
    UIGraphicsEndImageContext();
    self.eraser.hidden = YES;
}

- (void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
	if (!self.currentLine) {
        UIGraphicsEndImageContext();
		return;
	}
	
	CGPoint pt = [[touches anyObject] locationInView:self];
    
    self.eraser.hidden = YES;
    
	[self.currentLine addLineToPoint:pt];
	
	CGContextRef context = UIGraphicsGetCurrentContext();
	[self.currentFrame drawLine:context line:self.currentLine beginPoint:self.lastPoint endPoint:pt];
	self.image = UIGraphicsGetImageFromCurrentImageContext();
    
	UIGraphicsEndImageContext();
	
	self.currentFrame.image = self.image;
    
    [self.delegate drawView:self finishDrawLine:self.currentLine];
	self.currentLine = nil;
}

#pragma mark public function

- (void)setPenMode:(KMZLinePenMode)penMode {
    _penMode = penMode;
}

- (void)undo {
    [self.currentFrame undo];
    self.image = self.currentFrame.image;
    self.currentLine = nil;
    [self.delegate drawView:self finishDrawLine:self.currentLine];
    [self setNeedsDisplay];
}

- (void)redo {
    [self.currentFrame redo];
    self.image = self.currentFrame.image;
    self.currentLine = nil;
    [self.delegate drawView:self finishDrawLine:self.currentLine];
    [self setNeedsDisplay];
}

- (BOOL)isUndoable {
    return [self.currentFrame isUndoable];
}

- (BOOL)isRedoable {
    return [self.currentFrame isRedoable];
}

- (void)clear {
    self.image = nil;
    self.currentFrame.lineCursor = 0;
    [self.currentFrame.lines removeAllObjects];
}

@end
