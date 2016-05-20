//
//  SmoothLineView.m
//  Smooth Line View
//
//  Created by Levi Nunnink on 8/15/11.
//  Copyright 2011 culturezoo. All rights reserved.
//
//  modify by Amith Kumar @mindshiftapps

#import "SmoothLineView.h"
#import <QuartzCore/QuartzCore.h>
#import "UIImage-Extensions.h"

#define DEFAULT_COLOR [UIColor blackColor]
#define DEFAULT_WIDTH 5.0f
#define DEFAULT_ALPHA 1.0f

@interface SmoothLineView (){
    //Sherin Added
    BOOL firstLoad;
}

#pragma mark Private Helper function

CGPoint midPoint(CGPoint p1, CGPoint p2);

@end

@implementation SmoothLineView

@synthesize lineAlpha;
@synthesize lineColor;
@synthesize lineWidth;
@synthesize delegate;
@synthesize curImage;

#pragma mark -

- (id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    
    if (self)
    {
        self.backgroundColor = [UIColor clearColor];
        self.lineWidth = DEFAULT_WIDTH;
        self.lineColor = DEFAULT_COLOR;
        self.lineAlpha = DEFAULT_ALPHA;
        
        bufferArray = [[NSMutableArray alloc]init];
        lineArray = [[NSMutableArray alloc]init];
        
        [self clearAndCreateNewCacheDirectory];
        
        [self checkDrawStatus];
        
        //         UIPanGestureRecognizer *panrecognizer;
        //
        //         panrecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanDrawing:)];
        //         panrecognizer.minimumNumberOfTouches = 1;
        //         panrecognizer.maximumNumberOfTouches = 1;
        //
        //         [self addGestureRecognizer:panrecognizer];
        //         [panrecognizer release];
        
        UITapGestureRecognizer *taprecognizer;
        
        taprecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapDrawing:)];
        taprecognizer.numberOfTapsRequired = 1;
        taprecognizer.numberOfTouchesRequired = 1;
        
        [self addGestureRecognizer:taprecognizer];
        //Sherin Added
        
        firstLoad = YES;
        
        
        [self setMaskTo:self byRoundingCorners:UIRectCornerTopLeft];
    }
    
    return self;
}

-(void) setMaskTo:(UIView*)view byRoundingCorners:(UIRectCorner)corners
{
    UIBezierPath* rounded = [UIBezierPath bezierPathWithRoundedRect:view.bounds byRoundingCorners:corners cornerRadii:CGSizeMake(10.0, 10.0)];
    
    CAShapeLayer* shape = [[CAShapeLayer alloc] init];
    [shape setPath:rounded.CGPath];
    
    view.layer.mask = shape;
}




- (void) clearAndCreateNewCacheDirectory {
    
#if PUSHTOFILE
    lineIndex = 0;
    redoIndex = 0;
    
    NSString  *pngPath = [NSTemporaryDirectory() stringByAppendingPathComponent:@"/Scribble"];
    
    // Check if the directory already exists
    BOOL isDir;
    BOOL exists = [[NSFileManager defaultManager] fileExistsAtPath:pngPath isDirectory:&isDir];
    
    if (exists)
    {
        if (isDir)
        {
            NSError *error = nil;
            [[NSFileManager defaultManager]  removeItemAtPath:pngPath error:&error];
            // Directory does not exist so create it
            [[NSFileManager defaultManager] createDirectoryAtPath:pngPath withIntermediateDirectories:YES attributes:nil error:nil];
        }
    }
    else
    {
        // Directory does not exist so create it
        [[NSFileManager defaultManager] createDirectoryAtPath:pngPath withIntermediateDirectories:YES attributes:nil error:nil];
    }
#endif
    
}

- (void)drawRect:(CGRect)rect {
    
    switch (drawStep)
    {
        case DRAW:
        {
            
            CGPoint mid1 = midPoint(previousPoint1, previousPoint2);
            CGPoint mid2 = midPoint(currentPoint, previousPoint1);
#if USEUIBezierPath
            [myPath moveToPoint:mid1];
            [myPath addQuadCurveToPoint:mid2 controlPoint:previousPoint1];
            [self.lineColor setStroke];
            [myPath strokeWithBlendMode:kCGBlendModeNormal alpha:self.lineAlpha];
#else
            [self.curImage drawAtPoint:CGPointMake(0, 0)];
            CGContextRef context = UIGraphicsGetCurrentContext();
            
            [self.layer renderInContext:context];
            CGContextMoveToPoint(context, mid1.x, mid1.y);
            CGContextAddQuadCurveToPoint(context, previousPoint1.x, previousPoint1.y, mid2.x, mid2.y);
            if(previousPoint1.x == previousPoint2.x && previousPoint1.y == previousPoint2.y && previousPoint1.x == currentPoint.x && previousPoint1.y == currentPoint.y)
            {
                
                //Sherin Added
                if (firstLoad) {
                    CGContextSetLineCap(context, kCGLineCapButt);
                    firstLoad = NO;
                    
                }else{
                    
                    CGContextSetLineCap(context, kCGLineCapRound);
                }
                
            }
            else
            {
                CGContextSetLineCap(context, kCGLineCapButt);
            }
            
            CGContextSetBlendMode(context, kCGBlendModeNormal);
            CGContextSetLineJoin(context, kCGLineJoinRound);
            CGContextSetLineWidth(context, self.lineWidth);
            CGContextSetStrokeColorWithColor(context, self.lineColor.CGColor);
            CGContextSetShouldAntialias(context, YES);
            CGContextSetAllowsAntialiasing(context, YES);
            CGContextSetFlatness(context, 0.1f);
            
            CGContextSetAlpha(context, self.lineAlpha);
            CGContextStrokePath(context);
#endif
        }
            break;
        case CLEAR:
        {
            CGContextRef context = UIGraphicsGetCurrentContext();
            CGContextClearRect(context, rect);
            break;
        }
        case ERASE:
        {
            CGPoint mid1 = midPoint(previousPoint1, previousPoint2);
            CGPoint mid2 = midPoint(currentPoint, previousPoint1);
#if USEUIBezierPath
            [myPath moveToPoint:mid1];
            [myPath addQuadCurveToPoint:mid2 controlPoint:previousPoint1];
            [self.lineColor setStroke];
            [myPath strokeWithBlendMode:kCGBlendModeClear alpha:self.lineAlpha];
#else
            [self.curImage drawAtPoint:CGPointMake(0, 0)];
            CGContextRef context = UIGraphicsGetCurrentContext();
            
            [self.layer renderInContext:context];
            CGContextMoveToPoint(context, mid1.x, mid1.y);
            CGContextAddQuadCurveToPoint(context, previousPoint1.x, previousPoint1.y, mid2.x, mid2.y);
            CGContextSetLineCap(context, kCGLineCapRound);
            
            //eraser work around http://stackoverflow.com/a/9043950/489594
            CGContextSetBlendMode(context, kCGBlendModeClear);
            CGContextSetLineJoin(context, kCGLineJoinRound);
            CGContextSetLineWidth(context, self.lineWidth);
            CGContextSetStrokeColorWithColor(context, self.lineColor.CGColor);
            CGContextSetShouldAntialias(context, YES);
            CGContextSetAllowsAntialiasing(context, YES);
            CGContextSetFlatness(context, 0.1f);
            
            CGContextSetAlpha(context, self.lineAlpha);
            CGContextStrokePath(context);
#endif
        }
            break;
        case UNDO:
        {
            [self.curImage drawInRect:self.bounds];
            break;
        }
        case REDO:
        {
            [self.curImage drawInRect:self.bounds];
            break;
        }
        case RELOAD:
        {
            //http://stackoverflow.com/a/6176608/489594
            if(self.curImage.size.width>self.curImage.size.height)
            {
                UIImage *_tmp = self.curImage;
                self.curImage = [_tmp imageRotatedByDegrees:90];
            }
            [self.curImage drawInRect:self.bounds];
            
            break;
        }
        default:
            break;
    }
    
    [super drawRect:rect];
}

#pragma mark Private Helper function

CGPoint midPoint(CGPoint p1, CGPoint p2) {
    
    return CGPointMake((p1.x + p2.x) * 0.5, (p1.y + p2.y) * 0.5);
}

- (void)handlePanDrawing:(UIPanGestureRecognizer *)recognizer {
    
    CGPoint point  = [recognizer locationInView:self];
    
    switch (recognizer.state)
    {
        case UIGestureRecognizerStateBegan:
        {
            previousPoint1 = point;
            previousPoint2 = point;
            currentPoint = point;
            
            break;
        }
        case UIGestureRecognizerStateChanged:
        {
            previousPoint2  = previousPoint1;
            previousPoint1  = currentPoint;
            currentPoint    = point;
            
            if(drawStep != ERASE)
                drawStep = DRAW;
            
            [self calculateMinImageArea:previousPoint1 :previousPoint2 :currentPoint];
            
            break;
        }
        case UIGestureRecognizerStateEnded:
        {
            UIGraphicsBeginImageContext(self.bounds.size);
            [self.layer renderInContext:UIGraphicsGetCurrentContext()];
            self.curImage = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
            
            lineIndex++;
            redoIndex = 0;
            
            [self performSelectorInBackground:@selector(writeFilesBG) withObject:nil];
            
            [self checkDrawStatus];
            
            break;
        }
            
        case UIGestureRecognizerStateCancelled:
            break;
        default:
            break;
    }
}


- (void)handleTapDrawing:(UIPanGestureRecognizer *)recognizer {
    
    CGPoint point  = [recognizer locationInView:self];
    
    previousPoint1 = point;
    previousPoint2 = point;
    currentPoint = point;
    
    previousPoint2  = previousPoint1;
    previousPoint1  = currentPoint;
    currentPoint    = point;
    
    if(drawStep != ERASE)
        drawStep = DRAW;
    
    [self calculateMinImageArea:point :point :point];
    
    UIGraphicsBeginImageContext(self.bounds.size);
    [self.layer renderInContext:UIGraphicsGetCurrentContext()];
    self.curImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    lineIndex++;
    redoIndex = 0;
    [self performSelectorInBackground:@selector(writeFilesBG) withObject:nil];
    
    [self checkDrawStatus];
}


#pragma mark Private Helper function

- (void) calculateMinImageArea:(CGPoint)pp1 :(CGPoint)pp2 :(CGPoint)cp {
    
    // calculate mid point
    CGPoint mid1    = midPoint(pp1, pp2);
    CGPoint mid2    = midPoint(cp, pp1);
    
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, NULL, mid1.x, mid1.y);
    CGPathAddQuadCurveToPoint(path, NULL, pp1.x, pp1.y, mid2.x, mid2.y);
    CGRect bounds = CGPathGetBoundingBox(path);
    CGPathRelease(path);
    
    CGRect drawBox = bounds;
    
    //Pad our values so the bounding box respects our line width
    drawBox.origin.x        -= self.lineWidth * 1;
    drawBox.origin.y        -= self.lineWidth * 1;
    drawBox.size.width      += self.lineWidth * 2;
    drawBox.size.height     += self.lineWidth * 2;
    
    UIGraphicsBeginImageContext(drawBox.size);
    [self.layer renderInContext:UIGraphicsGetCurrentContext()];
    self.curImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    [self setNeedsDisplayInRect:drawBox];
    
    //http://stackoverflow.com/a/4766028/489594
    //[[NSRunLoop currentRunLoop] runMode: NSDefaultRunLoopMode beforeDate: [NSDate date]];
    [CATransaction flush];
    
}



#if PUSHTOFILE

- (void)writeFilesBG {
    
    
    NSString  *pngPath = [NSTemporaryDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"/Scribble/%d.jpg",lineIndex]];
    UIGraphicsBeginImageContext(self.bounds.size);
    [self.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *saveImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    [UIImagePNGRepresentation(saveImage) writeToFile:pngPath atomically:YES];
    
}

#endif


-(void)setLineIndex:(int)index
{
    
    lineIndex = index;
    
}

- (void) redrawLine {
    
    UIGraphicsBeginImageContext(self.bounds.size);
    [self.layer renderInContext:UIGraphicsGetCurrentContext()];
#if PUSHTOFILE
    self.curImage = [UIImage imageWithContentsOfFile:[NSTemporaryDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"/Scribble/%d.jpg",lineIndex]]];
#else
    NSDictionary *lineInfo = [lineArray lastObject];
    self.curImage = (UIImage*)[lineInfo valueForKey:@"IMAGE"];
#endif
    UIGraphicsEndImageContext();
    [self setNeedsDisplayInRect:self.bounds];
}


-(void) setInitialSribbleByTeacher:(UIImage *)image
{
    
    UIGraphicsBeginImageContext(self.bounds.size);
    [self.layer renderInContext:UIGraphicsGetCurrentContext()];
#if PUSHTOFILE
    
    UIImageView *imageview = [[UIImageView alloc]initWithFrame:CGRectMake(100, 75, 600, 450)];
    [imageview setBackgroundColor:[UIColor clearColor]];
    imageview.image = image;
    
    self.curImage = imageview.image;
    
    
#endif
    UIGraphicsEndImageContext();
    [self setNeedsDisplayInRect:self.bounds];
    
    
}



- (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize {
    //UIGraphicsBeginImageContext(newSize);
    // In next line, pass 0.0 to use the current device's pixel scaling factor (and thus account for Retina resolution).
    // Pass 1.0 to force exact pixel size.
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 0.0);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}
- (void)setInitialScribble:(UIImage *)image withSize:(CGSize)size
{
    image= [self imageWithImage:image scaledToSize:size];
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height)];
    [imageView setImage:image];
    
    //nslog(@"%f",self.bounds.size.width);
    //nslog(@"%f",self.bounds.size.height);
    
    [self.curImage drawInRect:CGRectMake(0, 0, size.width, size.height)];
    self.curImage = imageView.image;
     drawStep = DRAW;
    [self setNeedsDisplay];
    
}



#pragma mark Button Handle

- (void)undoButtonClicked {
    
#if PUSHTOFILE
    lineIndex--;
    redoIndex++;
    drawStep = UNDO;
    [self redrawLine];
#else
    if([lineArray count]>0){
        NSMutableArray *_line=[lineArray lastObject];
        [bufferArray addObject:[_line copy]];
        [lineArray removeLastObject];
        drawStep = UNDO;
        [self redrawLine];
    }
#endif
    
    [self checkDrawStatus];
}

- (void)redoButtonClicked {
    
#if PUSHTOFILE
    lineIndex++;
    redoIndex--;
    drawStep = REDO;
    [self redrawLine];
#else
    if([bufferArray count]>0){
        NSMutableArray *_line=[bufferArray lastObject];
        [lineArray addObject:_line];
        [bufferArray removeLastObject];
        drawStep = REDO;
        [self redrawLine];
    }
#endif
    [self checkDrawStatus];
}

- (void)clearButtonClicked {
    
    UIGraphicsBeginImageContext(self.bounds.size);
    [self.layer renderInContext:UIGraphicsGetCurrentContext()];
    self.curImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    drawStep = CLEAR;
    [self setNeedsDisplayInRect:self.bounds];
#if PUSHTOFILE
    lineIndex = 0;
    redoIndex = 0;
    //REMOVE ALL FILES
#else
    [lineArray removeAllObjects];
    [bufferArray removeAllObjects];
#endif
    [self checkDrawStatus];
}

- (void) eraserButtonClicked {
    
    if(drawStep!=ERASE)
    {
        drawStep = ERASE;
    }
    else
    {
        drawStep = DRAW;
    }
}

- (void)setColor:(float)r g:(float)g b:(float)b a:(float)a {
    
    self.lineColor = [UIColor colorWithRed:r green:g blue:b alpha:a];
    self.lineAlpha = a;
}

#pragma mark toolbarDelegate Handle
- (void) checkDrawStatus {
    
#if PUSHTOFILE
    if(lineIndex > 0)
        
#else
        if([lineArray count]>0)
#endif
        {
            [delegate performSelectorOnMainThread:@selector(setUndoButtonEnable:)
                                       withObject:[NSNumber numberWithBool:YES]
                                    waitUntilDone:NO];
        }
        else
        {
            [delegate performSelectorOnMainThread:@selector(setUndoButtonEnable:)
                                       withObject:[NSNumber numberWithBool:NO]
                                    waitUntilDone:NO];
        }
#if PUSHTOFILE
    if(redoIndex > 0)
#else
        if([bufferArray count]>0)
#endif
        {
            [delegate performSelectorOnMainThread:@selector(setRedoButtonEnable:)
                                       withObject:[NSNumber numberWithBool:YES]
                                    waitUntilDone:NO];
        }
        else
        {
            [delegate performSelectorOnMainThread:@selector(setRedoButtonEnable:)
                                       withObject:[NSNumber numberWithBool:NO]
                                    waitUntilDone:NO];
        }
}


//////////////////////////////

- (void) setDrawingColor:(UIColor*) color
{
    self.lineColor = color;
    
    
}

- (void) setBrushWidth:(int) width
{
    
    self.lineWidth = width;
    
}


- (void) setDrawingTool:(Drawing_Tool) tool {
    
    if(tool == kBrushTool)
        drawStep = DRAW;
    else if(tool == kEraserTool)
        drawStep = ERASE;
}

- (int) pathCount {
    
#if PUSHTOFILE
    return lineIndex;
    
#else
    return [lineArray count];
#endif
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    
    UITouch *touch = [touches anyObject];
    previousPoint1 = [touch previousLocationInView:self];
    previousPoint2 = [touch previousLocationInView:self];
    currentPoint =   [touch previousLocationInView:self];
    
    touchesCancleed=NO;
    
}
- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesMoved:touches withEvent:event];
    UITouch *touch = [touches anyObject];
    
    previousPoint2  = previousPoint1;
    previousPoint1  = currentPoint;
    currentPoint    = [touch previousLocationInView:self];
    
    if(drawStep != ERASE)
        drawStep = DRAW;
    
    [self calculateMinImageArea:previousPoint1 :previousPoint2 :currentPoint];
    [[self delegate] lineDrawnChanged];
    if (touchesCancleed)
    {
        [self touchesEnded:touches withEvent:event];
    }
    
    
}
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    
    [super touchesEnded:touches withEvent:event];
    
    UIGraphicsBeginImageContext(self.bounds.size);
    [self.layer renderInContext:UIGraphicsGetCurrentContext()];
    self.curImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    lineIndex++;
    redoIndex = 0;
    
    [self performSelectorInBackground:@selector(writeFilesBG) withObject:nil];
    
    [self checkDrawStatus];
    
    
}

- (void)canceltouches
{
    touchesCancleed=YES;
    
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesCancelled:touches withEvent:event];
    
    
    
    
}







@end


