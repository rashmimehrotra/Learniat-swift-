//
//  PollViewCell.m
//  Learniat Teacher
//
//  Created by mindshift_Deepak on 15/10/15.
//  Copyright © 2015 Amith Kumar. All rights reserved.
//

#import "PollViewCell.h"

@implementation PollViewCell
@synthesize mSelectButton,
mIgnoreButon,
m_optionId,
mMainOptionlabel;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        
        
        mSelectButton = [[UIButton alloc] initWithFrame:CGRectMake(0,0,self.frame.size.width, self.frame.size.height)];
        [mSelectButton setBackgroundColor:[UIColor clearColor]];
        [self addSubview:mSelectButton];
        [mSelectButton addTarget:self action:@selector(selectButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [mSelectButton setHidden:YES];
        
        
        selectButtonImageview= [[UIImageView alloc] initWithFrame:CGRectMake(15, 15, 25,25)];
        [selectButtonImageview setImage:[UIImage imageNamed:@"Mark_Model_Selected.png"]];
        [mSelectButton addSubview:selectButtonImageview];
        
        
        
        
        
        
        
        
        mIgnoreButon = [[UIButton alloc] initWithFrame:CGRectMake(0,0,self.frame.size.width, self.frame.size.height)];
        [mIgnoreButon setBackgroundColor:[UIColor clearColor]];
        [self addSubview:mIgnoreButon];
        [mIgnoreButon addTarget:self action:@selector(ignoreButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [mIgnoreButon setHidden:NO];
        
        
        ignoreButtonImageview= [[UIImageView alloc] initWithFrame:CGRectMake(15,15,25,25)];
        [ignoreButtonImageview setImage:[UIImage imageNamed:@"Mark_Model_Not_Selected.png"]];
        [mIgnoreButon addSubview:ignoreButtonImageview];
        

        mMainOptionlabel = [[UILabel alloc]initWithFrame:CGRectMake(50,10,self.frame.size.width-60,30)];
        mMainOptionlabel.textAlignment = NSTextAlignmentLeft;
        mMainOptionlabel.font = [UIFont fontWithName:@"HelveticaNeue" size:14];
        [self addSubview:mMainOptionlabel];
        [mMainOptionlabel setBackgroundColor:[UIColor clearColor]];
        mMainOptionlabel.lineBreakMode= NSLineBreakByTruncatingTail;
        [mMainOptionlabel setTextColor:[UIColor blackColor]];
        mMainOptionlabel.numberOfLines=20;
        
        
        
       UILabel* OptionAvailableLabel = [[UILabel alloc]initWithFrame:CGRectMake(10,50,self.frame.size.width-20,40)];
        OptionAvailableLabel.textAlignment = NSTextAlignmentLeft;
        OptionAvailableLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:14];
        [self addSubview:OptionAvailableLabel];
        [OptionAvailableLabel setBackgroundColor:[UIColor clearColor]];
        OptionAvailableLabel.lineBreakMode= NSLineBreakByTruncatingTail;
        [OptionAvailableLabel setTextColor:[UIColor lightGrayColor]];
        [OptionAvailableLabel setText:@"Options available"];
    }
    return self;
}


- (void) selectButtonClicked:(id)sender
{
   
    [self setSelectedState:kNotSelected];
    [[self delegate] delegateIgnoreButtonPressedWithOptionCell:self];
    
    
    [mSelectButton setHidden:YES];
    [mIgnoreButon setHidden:NO];
    [self setBackgroundColor:[UIColor colorWithRed:235.0/255.0 green:235.0/255.0 blue:235.0/255.0 alpha:1.0]];
}

- (void) ignoreButtonClicked:(id)sender
{
    
    [self setSelectedState:kSelected];
    [[self delegate] delegateSelectButtonPressedWithOptionCell:self];
    
    
    [mSelectButton setHidden:NO];
    [mIgnoreButon setHidden:YES];
    [self setBackgroundColor:[UIColor whiteColor]];

}

- (void) setSelectedState:(NSString*)state
{
    subCellState=state;
}

- (NSString*)getPollSubcellState
{
    return subCellState;
}


- (void) setPollOptions:(NSString*)_pollOptions
{
    pollOptions= _pollOptions;
    
    
    NSArray* optionsArray= [_pollOptions componentsSeparatedByString:@";;;"];
    
    UIScrollView*  mLikerScaleScrollView= [[UIScrollView alloc] initWithFrame:CGRectMake(5,90,self.frame.size.width,175)];
    [self addSubview:mLikerScaleScrollView];
    
    
    float positionYValue = 5;
    
    for (int i=0; i< [optionsArray count]; i++)
    {
        UILabel* OptionAvailableLabel = [[UILabel alloc]initWithFrame:CGRectMake(5,positionYValue,mLikerScaleScrollView.frame.size.width-10,25)];
        OptionAvailableLabel.textAlignment = NSTextAlignmentLeft;
        OptionAvailableLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:16];
        [mLikerScaleScrollView addSubview:OptionAvailableLabel];
        [OptionAvailableLabel setBackgroundColor:[UIColor clearColor]];
        OptionAvailableLabel.lineBreakMode= NSLineBreakByTruncatingTail;
        [OptionAvailableLabel setTextColor:[UIColor colorWithRed:51.0/255.0 green:51.0/255.0 blue:51.0/255.0 alpha:1.0]];
        [OptionAvailableLabel setText:[optionsArray objectAtIndex:i]];
        positionYValue=positionYValue+OptionAvailableLabel.frame.size.height+2;
        
    }
    [self bringSubviewToFront:mSelectButton];
    [self bringSubviewToFront:mIgnoreButon];
}

- (NSString*)getPollOptions
{
    
    return pollOptions;
}


- (void) setdelegate:(id)delegate
{
    _delgate= delegate;
}
- (id)   delegate
{
    return _delgate;
}



@end
