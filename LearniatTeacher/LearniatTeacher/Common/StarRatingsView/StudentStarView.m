//
//  StudentStarView.m
//  Learniat Teacher
//
//  Created by Deepak MK on 30/03/15.
//  Copyright (c) 2015 Mindshift Applications and Solutions Private Ltd. All rights reserved.
//

#import "StudentStarView.h"

@implementation StudentStarView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/



- (void) addStarsWithRatings:(int)rating withSize:(float)size
{
    
    
    NSArray *viewsToRemove = [self subviews];
    for (UIView *v in viewsToRemove)
    {
        [v removeFromSuperview];
    }
    
    float starSize= self.frame.size.width/rating;
    if (starSize>self.frame.size.height)
    {
        starSize=self.frame.size.height;
    }
    
    float totalSize= starSize* rating;
    UIImageView* imageView= [[UIImageView alloc] initWithFrame:CGRectMake((self.frame.size.width-totalSize)/2, 0, totalSize, self.frame.size.height)];
    [self addSubview:imageView];
    
    
    
    
    float starSpaceSize= starSize*0.2;
    starSize= starSize*0.8;
    
    float startPoint=starSpaceSize/2;
    for (int i=0; i<rating; i++)
    {
        UIImageView *activeStarImage = [[UIImageView alloc] initWithFrame:CGRectMake(startPoint, (imageView.frame.size.height-starSize)/2, starSize, starSize)];
        startPoint=startPoint+starSize+starSpaceSize;
        [imageView addSubview:activeStarImage];
        [activeStarImage setImage:[UIImage imageNamed:@"Star_Selected.png"]];
        
        
    }
    
    
    
}




@end
