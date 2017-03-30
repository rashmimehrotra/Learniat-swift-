//
//  DynamicFontSize.m
//  Learniat Teacher
//
//  Copyright (c) 2015 Mindshift Applications and Solutions Private Ltd. All rights reserved.
//

#import "DynamicFontSize.h"

@implementation DynamicFontSize
@synthesize verticalAlignment;
#define CATEGORY_DYNAMIC_FONT_SIZE_MAXIMUM_VALUE 35
#define CATEGORY_DYNAMIC_FONT_SIZE_MINIMUM_VALUE 3

-(void) adjustFontSizeToFillItsContents
{
    NSString* text = self.text;
    if (text)
    {
        
        for (int i = CATEGORY_DYNAMIC_FONT_SIZE_MAXIMUM_VALUE; i>CATEGORY_DYNAMIC_FONT_SIZE_MINIMUM_VALUE; i--) {
            
            UIFont *font = [UIFont fontWithName:self.font.fontName size:(CGFloat)i];
            NSAttributedString *attributedText = [[NSAttributedString alloc] initWithString:text attributes:@{NSFontAttributeName: font}];
            
            CGRect rectSize = [attributedText boundingRectWithSize:CGSizeMake(self.frame.size.width, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin context:nil];
            
            if (rectSize.size.height <= self.frame.size.height) {
                self.font = [UIFont fontWithName:self.font.fontName size:(CGFloat)i];
                break;
            }
        }
    }
    
    
}


-(void)resizeToStretch
{
    float width = [self expectedWidth].width;
    float height = [self expectedWidth].height;
    CGRect newFrame = [self frame];
    newFrame.size.width = width;
    newFrame.size.height = height;
    [self setFrame:newFrame];
}

-(CGSize)expectedWidth{
    [self setNumberOfLines:10];
    
    CGSize maximumLabelSize = CGSizeMake(400,self.frame.size.height);
    
    CGSize expectedLabelSize = [[self text] sizeWithFont:[self font]
                                       constrainedToSize:maximumLabelSize
                                           lineBreakMode:[self lineBreakMode]];
    return expectedLabelSize;
}

- (void) setLabelText:(NSString *)text
{
    self.text=text;
    [self adjustHeight];
}
- (void) setlabelWithWidthChange:(NSString*)text
{
    self.text=text;
    [self adjustWidth];
}

- (void) setDoubtTextWithNoChangeinSize:(NSString *)text
{
    
    if (self.text == nil)
    {
        self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.bounds.size.width, 30);
        return;
    }
    
    
    
    NSString* string= self.text;
    
    if (!subLabel)
    {
        subLabel= [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        [self addSubview:subLabel];
        subLabel.lineBreakMode= NSLineBreakByTruncatingTail;
        [subLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:17.0]];
        [subLabel setNumberOfLines:7];
        [subLabel sizeToFit];
        [subLabel setTextColor:_subLableColor];
    }
    
    switch (verticalAlignment)
    {
        case VerticalAlignmentTop:
            
            subLabel.frame=CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
            [subLabel setText:string];
            
            self.text=@"";
            
            
            break;
            
        default:
            
            break;
    }
    
}
- (void) adjustWidth
{
    
    if (self.text == nil)
    {
        self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.bounds.size.width, 30);
        return;
    }
    
    CGSize aSize = self.bounds.size;
    CGSize tmpSize = CGRectInfinite.size;
    tmpSize.width = aSize.width;
    
    
    
    
    
    
    tmpSize = [self.text sizeWithFont:self.font constrainedToSize:tmpSize];
    
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, tmpSize.width, aSize.height);
    NSString* string= self.text;
    
    if (!subLabel)
    {
        subLabel= [[UILabel alloc] initWithFrame:CGRectMake(0, 0, tmpSize.width,aSize.height)];
        [self addSubview:subLabel];
        subLabel.lineBreakMode= NSLineBreakByTruncatingTail;
        [subLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:17.0]];
        [subLabel setNumberOfLines:7];
        [subLabel sizeToFit];
        [subLabel setTextColor:_subLableColor];
    }
    
    switch (verticalAlignment)
    {
        case VerticalAlignmentTop:
            
            subLabel.frame=CGRectMake(0, 0, tmpSize.width, aSize.height);
            [subLabel setText:string];
            
            self.text=@"";
            
            
            break;
            
        default:
            
            break;
    }
    
    
    
    
    
    labelSize=CGSizeMake(tmpSize.width, aSize.height);
}

- (void)adjustHeight {
    
    if (self.text == nil)
    {
        self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.bounds.size.width, 30);
        return;
    }
    
    CGSize aSize = self.bounds.size;
    CGSize tmpSize = CGRectInfinite.size;
    tmpSize.width = aSize.width;
    
   
    

    
    
    tmpSize = [self.text sizeWithFont:self.font constrainedToSize:tmpSize];
    
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, aSize.width, tmpSize.height);
    NSString* string= self.text;
    
    if (!subLabel)
    {
        subLabel= [[UILabel alloc] initWithFrame:CGRectMake(0, 0, aSize.width, tmpSize.height)];
        [self addSubview:subLabel];
        subLabel.lineBreakMode= NSLineBreakByTruncatingTail;
        [subLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:17.0]];
        [subLabel setNumberOfLines:7];
        [subLabel sizeToFit];
        [subLabel setTextColor:_subLableColor];
    }
    
    switch (verticalAlignment)
    {
        case VerticalAlignmentTop:
            
            subLabel.frame=CGRectMake(0, 0, aSize.width, tmpSize.height);
            [subLabel setText:string];
            
            self.text=@"";
            
            
            break;
            
        default:
            
            break;
    }
    
    
    
    
    
    labelSize=CGSizeMake(aSize.width, tmpSize.height);
}
-(CGSize)returnLabelSize
{
    return labelSize;
}

@end
