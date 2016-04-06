//
//  SSStarRatingView.m
//  Learniat Teacher
//
//  Created by Amith Kumar on 03/01/14.
//  Copyright (c) 2015 Mindshift Applications and Solutions Private Ltd. All rights reserved.
//
//

#import "SSStarRatingView.h"


@implementation SSStarRatingView


- (id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code.
        _canEdit = YES;
        _rating = 0;
	
    }
    return self;
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code.
    
//    if (_canEdit) 
    {
        for (int i = 0; i < 5; i++) {
            
            UIImage *activeStarImage = [UIImage imageNamed:@"Star_Unselected.png"];
            
            CGRect starRect = CGRectMake((i * (_starSize+5)), 0.0, _starSize, _starSize);
            [activeStarImage drawInRect:starRect];
        }
        
        
    }
     
    for (int i = 0; i < _rating; i++)
    {
        
        UIImage *activeStarImage = [UIImage imageNamed:@"Star_Selected.png"];
        
        CGRect starRect = CGRectMake((i * (_starSize+5)), 0.0, _starSize, _starSize);
        [activeStarImage drawInRect:starRect];
    }
}

- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
}

- (void) touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    
	if (_canEdit) 
    {
        UITouch *touch = [touches anyObject];
        
        CGPoint touchPosition = [touch locationInView:self];
        
        float xOrigin = touchPosition.x;
        
        int starRating = (floorf(xOrigin)/35.0) + 1;
        
        if(starRating > 5)
            starRating = 5;
		
        _rating = starRating;
        
        if ([self delegate]) {
            [[self delegate] starRatingDidChange];
        }
		
        [self setStarRating:starRating];
    }	
}

- (void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    
    if (_canEdit) 
    {
        UITouch *touch = [touches anyObject];
        
        CGPoint touchPosition = [touch locationInView:self];
        
        float xOrigin = touchPosition.x;
        
       int starRating = (floorf(xOrigin)/35.0) + 1;
        
        if(starRating > 5)
            starRating = 5;
		
        _rating = starRating;
        
        if ([self delegate])
        {
            [[self delegate] starRatingDidChange];
        }
		
        [self setStarRating:starRating];
    }
}

- (void) setStarRating:(NSInteger) rating {
   
//	if (rating < 1) 
//        _rating = 1;
//    else 
        _rating = rating;
    
    [self setNeedsDisplay];
}

- (NSInteger) rating {
    
    return _rating;
}

- (void) setEditable:(BOOL) editable {
   
	_canEdit = editable;
}

- (void) setDelegate:(id) del {
    
	
	_delegate = del;
}


- (id) delegate {
    
	return _delegate;
}


- (void) setsizeOfStar:(NSInteger) starSize
{
    _starSize=starSize;
}
- (NSInteger) starSize
{
    return _starSize;
}


@end
