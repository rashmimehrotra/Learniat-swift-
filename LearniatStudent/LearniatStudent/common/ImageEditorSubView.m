//
//  ImageEditorSubView.m
//  EditorView
//
//  Created by mindshift_Deepak on 07/11/15.
//  Copyright © 2015 mindShiftApps. All rights reserved.
//

#import "ImageEditorSubView.h"
#define kBorderSize 10
#define kBoxHeight   110
#define kBoxWidth    70


@implementation ImageEditorSubView
CGFloat kResizeThumbSize = 50;


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setUserInteractionEnabled:YES];
    }
    return self;
}

- (void) setdelegate:(id)delegate
{
    _delgate=delegate;
}
- (id)   delegate
{
    return _delgate;
}

#pragma mark - view setUp Functions
- (void)setContentImageView:(UIImageView*)_contentView withImage:(UIImage*)image
{
    
    [imageview removeFromSuperview];
    
    [mDeleteButton removeFromSuperview];
    [mEditButton removeFromSuperview];
    [mResizeButton removeFromSuperview];
    
    imageview = [[UIImageView alloc] init];
    CGRect rect= _contentView.bounds;
    
    
    if (rect.origin.x==INFINITY)
    {
         rect= CGRectMake(40, rect.origin.y, 50, rect.size.height);
    }
    
    
    if (rect.origin.y==INFINITY)
    {
        rect= CGRectMake(rect.origin.y, 40, 50, rect.size.height);
    }
    
    if (rect.size.width<=kBoxWidth)
    {
        rect= CGRectMake(rect.origin.x, rect.origin.y, kBoxWidth, rect.size.height);
    }
    if (rect.size.height<=kBoxHeight)
    {
        rect= CGRectMake(rect.origin.x, rect.origin.y, rect.size.width,kBoxHeight);
    }
    
    imageview.frame= CGRectMake(40, 0, rect.size.width,rect.size.height);
    
    [imageview setImage:image];
    imageview.contentMode= UIViewContentModeScaleAspectFit;
    [imageview.layer setBorderColor:[[UIColor colorWithRed:0/255.0 green:160.0/255.0 blue:219.0/255.0 alpha:1.0] CGColor]];
    imageview.layer.masksToBounds=YES;
    [imageview setUserInteractionEnabled:YES];
    [self addSubview:imageview];
    
    UITapGestureRecognizer *letterTapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(highlightLetter:)];
    [imageview addGestureRecognizer:letterTapRecognizer];
    
    
    
    
    
    
    preventsPositionOutsideSuperview=YES;
    isEditing=NO;
    
    
    CGRect upperLeft = CGRectMake(0.0, 0.0, kBorderSize, kBorderSize);
    CGRect upperRight = CGRectMake(imageview.frame.size.width - kBorderSize, 0.0, kBorderSize, kBorderSize);
    CGRect lowerRight = CGRectMake(imageview.bounds.size.width - kBorderSize, imageview.frame.size.height - kBorderSize, kBorderSize, kBorderSize);
    CGRect lowerLeft = CGRectMake(0.0, imageview.bounds.size.height - kBorderSize, kBorderSize, kBorderSize);
    CGRect allPoints[4] = { upperLeft, upperRight, lowerRight, lowerLeft};
    for (NSInteger i = 0; i < 4; i++)
    {
        
        CGRect borderRect = allPoints[i];
        UIImageView* borderImag= [[UIImageView alloc] initWithFrame:borderRect];
        [borderImag setBackgroundColor:[UIColor colorWithRed:0/255.0 green:160.0/255.0 blue:219.0/255.0 alpha:1.0]];
        [imageview addSubview:borderImag];
        [borderImag setHidden:YES];
    }
    
    
    mDeleteButton = [[UIButton alloc] initWithFrame:CGRectMake(0,0,30,30)];
    [mDeleteButton addTarget:self  action:@selector(onDeleteButton:) forControlEvents:UIControlEventTouchUpInside];
    [mDeleteButton setImage:[UIImage imageNamed:@"Delete.png"] forState:UIControlStateNormal];
    [self addSubview:mDeleteButton];
    [mDeleteButton setHidden:YES];
    mDeleteButton.imageView.contentMode= UIViewContentModeScaleAspectFit;
    
    
    mEditButton = [[UIButton alloc] initWithFrame: CGRectMake(0,40,30,30)];
    [mEditButton addTarget:self  action:@selector(onEditButton:) forControlEvents:UIControlEventTouchUpInside];
    [mEditButton setImage:[UIImage imageNamed:@"Edit.png"] forState:UIControlStateNormal];
    mEditButton.imageView.contentMode= UIViewContentModeScaleAspectFit;
    [self addSubview:mEditButton];
    [mEditButton setHidden:YES];
    
    mResizeButton = [[UIButton alloc] initWithFrame: CGRectMake(0,80,30,30)];
    [mResizeButton addTarget:self  action:@selector(onResizeButton:) forControlEvents:UIControlEventTouchUpInside];
    [mResizeButton setImage:[UIImage imageNamed:@"dragAndDrop.png"] forState:UIControlStateNormal];
    mResizeButton.imageView.contentMode= UIViewContentModeScaleAspectFit;
    [self addSubview:mResizeButton];
    [mResizeButton setHidden:YES];

    
}

#pragma mark - touches Function
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (isEditing==NO)
    {
        return;
    }
    touchStart = [[touches anyObject] locationInView:self];
   
    isResizingLR = (self.bounds.size.width - touchStart.x < kResizeThumbSize && self.bounds.size.height - touchStart.y < kResizeThumbSize);
    
    isResizingUL = (touchStart.x <kResizeThumbSize && touchStart.y <kResizeThumbSize);
    
    isResizingUR = (self.bounds.size.width-touchStart.x < kResizeThumbSize && touchStart.y<kResizeThumbSize);
    
    isResizingLL = (touchStart.x <kResizeThumbSize*2 && self.bounds.size.height -touchStart.y <kResizeThumbSize);
    
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    
    if (isEditing==NO)
    {
        return;
    }
   CGPoint touchPoint = [[touches anyObject] locationInView:self];
    CGPoint previous = [[touches anyObject] previousLocationInView:self];
    
    CGFloat deltaWidth = touchPoint.x - previous.x;
    CGFloat deltaHeight = touchPoint.y - previous.y;
    
    // get the frame values so we can calculate changes below
    CGFloat x = self.frame.origin.x;
    CGFloat y = self.frame.origin.y;
    CGFloat width = self.frame.size.width;
    CGFloat height = self.frame.size.height;
    
    
    
    if (isResizingLR && isResizing)
    {
        self.frame = CGRectMake(x, y, touchPoint.x+deltaWidth, touchPoint.y+deltaWidth);
        
    }
    else if (isResizingUL&& isResizing)
    {
        self.frame = CGRectMake(x+deltaWidth, y+deltaHeight, width-deltaWidth, height-deltaHeight);
    }
    else if (isResizingUR&& isResizing)
    {
        self.frame = CGRectMake(x, y+deltaHeight, width+deltaWidth, height-deltaHeight);
    }
    else if (isResizingLL&& isResizing)
    {
        self.frame = CGRectMake(x+deltaWidth, y, width-deltaWidth, height+deltaHeight);
    }
    else
    {
        
        [self translateUsingTouchLocation:touchPoint];
    }
    
    
    
    if (self.frame.size.width<=kBoxWidth)
    {
        self.frame=CGRectMake(self.frame.origin.x,self.frame.origin.y,kBoxWidth,self.frame.size.height);
    }
    
    if (self.frame.size.height<=kBoxHeight)
    {
        self.frame=CGRectMake(self.frame.origin.x,self.frame.origin.y,self.frame.size.width,kBoxHeight);
    }
    
    [imageview setFrame:CGRectMake(40, 0,self.frame.size.width-40,self.frame.size.height)];
    
    
    CGRect upperLeft = CGRectMake(0.0, 0.0, kBorderSize, kBorderSize);
    
    CGRect upperRight = CGRectMake(imageview.frame.size.width - kBorderSize, 0.0, kBorderSize, kBorderSize);
    
    
    CGRect lowerRight = CGRectMake(imageview.bounds.size.width - kBorderSize, imageview.frame.size.height - kBorderSize, kBorderSize, kBorderSize);
    
    CGRect lowerLeft = CGRectMake(0.0, imageview.bounds.size.height - kBorderSize, kBorderSize, kBorderSize);
    
    
    CGRect allPoints[4] = { upperLeft, upperRight, lowerRight, lowerLeft};

    
    NSArray* array= [imageview subviews];
    
    for (int i=0; i<[array count]; i++)
    {
        CGRect borderRect = allPoints[i];
        UIImageView* borderImag= (UIImageView*)[array objectAtIndex:i];
        
        [borderImag setFrame:borderRect];
    }
}


- (void)translateUsingTouchLocation:(CGPoint)touchPoint
{
    if (isEditing==NO)
    {
        return;
    }
    CGPoint newCenter = CGPointMake(self.center.x + touchPoint.x - touchStart.x, self.center.y + touchPoint.y - touchStart.y);
    if (preventsPositionOutsideSuperview)
    {
        // Ensure the translation won't cause the view to move offscreen.
        CGFloat midPointX = CGRectGetMidX(self.bounds);
        if (newCenter.x > (self.superview.bounds.size.width+self.frame.size.width/2) - midPointX) {
            newCenter.x = (self.superview.bounds.size.width+self.frame.size.width/2) - midPointX;
        }
        if (newCenter.x < midPointX-self.frame.size.width/2) {
            newCenter.x = midPointX-self.frame.size.width/2;
        }
        CGFloat midPointY = CGRectGetMidY(self.bounds);
        if (newCenter.y > (self.superview.bounds.size.height+self.frame.size.height/2) - midPointY) {
            newCenter.y = (self.superview.bounds.size.height+self.frame.size.height/2) - midPointY;
        }
        if (newCenter.y < midPointY-self.frame.size.height/2)
        {
            newCenter.y = midPointY-self.frame.size.height/2;
        }
    }
    self.center = newCenter;
}

#pragma mark - Button Functions


- (void)highlightLetter:(UITapGestureRecognizer*)sender
{
 
    
    if (isEditing==NO)
    {
        
       
        
       
        [[self delegate] delegateSelectPressedWithView:self withSelectedState:YES];
         [self showHandles];
    }
    else
    {
        
        
        [[self delegate] delegateSelectPressedWithView:self withSelectedState:NO];
       [self hideHandles];
        
    }
}







- (void) showHandles
{
    imageview.layer.borderWidth=3;
    [mEditButton setHidden:NO];
    [mResizeButton setHidden:NO];
    [mDeleteButton setHidden:NO];
    isResizing=NO;
    [mResizeButton setImage:[UIImage imageNamed:@"dragAndDrop.png"] forState:UIControlStateNormal];
    NSArray* array= [imageview subviews];
    for (int i=0; i<[array count]; i++)
    {
        UIImageView* borderImag= (UIImageView*)[array objectAtIndex:i];
        
        [borderImag setHidden:NO];
    }
    isEditing=YES;

}

- (void) hideHandles
{
    NSArray* array= [imageview subviews];
    
    for (int i=0; i<[array count]; i++)
    {
        UIImageView* borderImag= (UIImageView*)[array objectAtIndex:i];
        
        [borderImag setHidden:YES];
    }
    
    imageview.layer.borderWidth=0;
    [mEditButton setHidden:YES];
    [mResizeButton setHidden:YES];
    [mDeleteButton setHidden:YES];
    isEditing=NO;
    isResizing=NO;
    [mResizeButton setImage:[UIImage imageNamed:@"dragAndDrop.png"] forState:UIControlStateNormal];

}

- (void) onEditButton:(id)sedner
{
    [[self delegate] delegateEditButtonPressedWithView:self];
}

- (void) onResizeButton:(id)sender
{
    if (isResizing==YES)
    {
        isResizing=NO;
        [mResizeButton setImage:[UIImage imageNamed:@"dragAndDrop.png"] forState:UIControlStateNormal];

    }
    else
    {
        isResizing=YES;
        [mResizeButton setImage:[UIImage imageNamed:@"Resize.png"] forState:UIControlStateNormal];
    }
}

- (void) onDeleteButton:(id)sender
{
     [[self delegate] delegateDeleteDeleteButtonPressedWithView:self];
}
#pragma mark - custom Functions
- (void)setTypeOfImage:(TypeOfImage)type
{
    currentImageType=type;
}
- (TypeOfImage)getCurrentTypeOfImage
{
    return currentImageType;
}

- (void) setBinaryValue:(NSData*)binaryValue
{
    m_binaryValue=binaryValue;
}
- (NSData*)getBinarayData
{
    return m_binaryValue;
}


@end

