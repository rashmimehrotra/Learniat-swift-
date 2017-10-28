//
//  DottedLine.m
//  Learniat_Student_Iphone
//
//  Created by Deepak MK on 09/02/16.
//  Copyright © 2016 mindShiftApps. All rights reserved.
//

#import "DottedLine.h"

@implementation DottedLine

#pragma mark - Object Lifecycle

- (instancetype)init {
    self = [super init];
    
    if (self) {
        // Set Default Values
        _thickness = 1.0f;
        _color = [UIColor whiteColor];
        _dashedGap = 1.0f;
        _dashedLength = 2.0f;
    }
    
    return self;
}

#pragma mark - View Lifecycle

- (void)layoutSubviews {
    // Note, this object draws a straight line. If you wanted the line at an angle you simply need to adjust the start and/or end point here.
    [self updateLineStartingAt:self.frame.origin andEndPoint:CGPointMake(self.frame.origin.x+self.frame.size.width, self.frame.origin.y)];
}

#pragma mark - Setters

- (void)setThickness:(CGFloat)thickness {
    _thickness = thickness;
    [self setNeedsLayout];
}

- (void)setColor:(UIColor *)color {
    _color = [color copy];
    [self setNeedsLayout];
}

- (void)setDashedGap:(CGFloat)dashedGap {
    _dashedGap = dashedGap;
    [self setNeedsLayout];
}

- (void)setDashedLength:(CGFloat)dashedLength {
    _dashedLength = dashedLength;
    [self setNeedsLayout];
}

#pragma mark - Draw Methods

-(void)updateLineStartingAt:(CGPoint)beginPoint andEndPoint:(CGPoint)endPoint {
    
//    // Important, otherwise we will be adding multiple sub layers
//    if ([[[self layer] sublayers] objectAtIndex:0])
//    {
//        self.layer.sublayers = nil;
//    }
//    
//    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
//    [shapeLayer setBounds:self.bounds];
//    [shapeLayer setPosition:self.center];
//    [shapeLayer setFillColor:[UIColor clearColor].CGColor];
//    [shapeLayer setStrokeColor:self.color.CGColor];
//    [shapeLayer setLineWidth:self.thickness];
//    [shapeLayer setLineJoin:kCALineJoinRound];
//    [shapeLayer setLineDashPattern:@[@(self.dashedLength), @(self.dashedGap)]];
//    
//    // Setup the path
//    CGMutablePathRef path = CGPathCreateMutable();
//    CGPathMoveToPoint(path, NULL, beginPoint.x, beginPoint.y);
//    CGPathAddLineToPoint(path, NULL, endPoint.x, endPoint.y);
//    
//    [shapeLayer setPath:path];
//    CGPathRelease(path);
//    
//    [[self layer] addSublayer:shapeLayer];
    
    
    
    [self.layer setBorderColor:[[UIColor colorWithPatternImage:[UIImage imageNamed:@"DotedImage.png"]] CGColor]];
    
}
- (void)drawDashedBorderAroundViewWithColor:(UIColor*)color
{
    CAShapeLayer *shapelayer = [CAShapeLayer layer];
    UIBezierPath *path = [UIBezierPath bezierPath];
    //draw a line
    [path moveToPoint:CGPointMake(0.0, self.frame.size.height)]; //add yourStartPoint here
    [path addLineToPoint:CGPointMake(self.frame.size.width, self.frame.size.height)];// add yourEndPoint here
    UIColor *fill = color;
    shapelayer.strokeStart = 0.0;
    shapelayer.strokeColor = fill.CGColor;
    shapelayer.lineWidth = 0.50;
    shapelayer.lineJoin = kCALineJoinRound;
    shapelayer.lineDashPattern = [NSArray arrayWithObjects:[NSNumber numberWithInt:3],[NSNumber numberWithInt:3 ], nil];
    shapelayer.lineDashPhase = 3.0f;
    shapelayer.path = path.CGPath;
    
    [self.layer addSublayer:shapelayer];
}

- (void)drawDashedBorderVertically:(UIColor*)color
{
    CAShapeLayer *shapelayer = [CAShapeLayer layer];
    UIBezierPath *path = [UIBezierPath bezierPath];
    //draw a line
    [path moveToPoint:CGPointMake(0.0, 0.0)]; //add yourStartPoint here
    [path addLineToPoint:CGPointMake(self.frame.size.width, self.frame.size.height)];// add yourEndPoint here
    UIColor *fill = color;
    shapelayer.strokeStart = 0.0;
    shapelayer.strokeColor = fill.CGColor;
    shapelayer.lineWidth = 1.0;
    shapelayer.lineJoin = kCALineJoinRound;
    shapelayer.lineDashPattern = [NSArray arrayWithObjects:[NSNumber numberWithInt:3],[NSNumber numberWithInt:3 ], nil];
    shapelayer.lineDashPhase = 3.0f;
    shapelayer.path = path.CGPath;
    
    [self.layer addSublayer:shapelayer];
}


@end
