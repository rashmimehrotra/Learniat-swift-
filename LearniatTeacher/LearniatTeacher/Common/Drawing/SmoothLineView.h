//
//  SmoothLineView.h
//  Smooth Line View
//
//  Created by Levi Nunnink on 8/15/11.
//  Copyright 2011 culturezoo. All rights reserved.
//
//  modify by Amith Kumar @mindshiftapps

#import <UIKit/UIKit.h>

#define PUSHTOFILE      1
typedef enum {
	
	kRedColor = 0,
	kGreenColor,
	kBlueColor,
    kPurpleColor,
    kOrangeColor,
    kCyanColor,
    kYellowColor,
    kBrownColor,
	
} Drawing_Color;

typedef enum {
	kBrushTool = 0,
	kEraserTool
} Drawing_Tool;

enum
{
	DRAW					= 0x0000,
	CLEAR					= 0x0001,
	ERASE					= 0x0002,
	UNDO					= 0x0003,
	REDO					= 0x0004,
    RELOAD                  = 0x0005,
};

@interface SmoothLineView : UIView {
    
  __unsafe_unretained  id delegate;
    
    NSMutableArray *lineArray;
    NSMutableArray *bufferArray;
    
    CGPoint currentPoint;
    CGPoint previousPoint1;
    CGPoint previousPoint2;
    CGFloat lineWidth;
    UIColor *lineColor;
    CGFloat lineAlpha;
    CGPoint _previousPoint1;
    CGPoint _previousPoint2;
    CGPoint _currentPoint;
    
    CGFloat red;
    CGFloat green;
    CGFloat blue;
    CGFloat brush;
    CGFloat eraserWidth;
    CGFloat opacity;
    BOOL touchesCancleed;
    UIImage *curImage;
    int drawStep;
    
#if USEUIBezierPath
    UIBezierPath *myPath;
#endif
#if PUSHTOFILE
    int lineIndex;
    int redoIndex;
#endif
    
    id  _delegate;
    
}
@property (nonatomic, retain) UIColor *lineColor;
@property (readwrite) CGFloat lineWidth;
@property (readwrite) CGFloat lineAlpha;
@property(assign) id delegate;
@property (retain) UIImage *curImage;
@property (retain) UIImage *TempImage;




- (void)calculateMinImageArea:(CGPoint)pp1 :(CGPoint)pp2 :(CGPoint)cp;
- (void)redoButtonClicked;
- (void)undoButtonClicked;
- (void)clearButtonClicked;
- (void)eraserButtonClicked;

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event;
- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event;
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event;
- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event;
- (void)setInitialScribble:(UIImage *)image withSize:(CGSize)size;
-(void) setInitialSribbleByTeacher:(UIImage *)image;
- (void)setColor:(float)r g:(float)g b:(float)b a:(float)a;
-(void)setLineIndex:(int)index;
- (void)checkDrawStatus;
-(void) setMaskTo:(UIView*)view byRoundingCorners:(UIRectCorner)corners;
- (void)canceltouches;
#if PUSHTOFILE
- (void)writeFilesBG;
#endif
//- (void) writeTempImageFile;
- (void) clearAndCreateNewCacheDirectory;
- (void) setDrawingColor:(UIColor*) color;
- (void) setBrushWidth:(int) width;

- (void) setDrawingTool:(Drawing_Tool) tool;

- (int) pathCount;


@end

@protocol SmoothLineViewdelegate <NSObject>

@optional
- (void) setUndoButtonEnable:(NSNumber *) enable;
- (void) setRedoButtonEnable:(NSNumber *) enable;
- (void) lineDrawnChanged;

@end