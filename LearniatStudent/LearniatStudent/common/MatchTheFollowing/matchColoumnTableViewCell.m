//
//  matchColoumnTableViewCell.m
//  Learniat Teacher
//
//  Copyright (c) 2015 Mindshift Applications and Solutions Private Ltd. All rights reserved.
//

#import "matchColoumnTableViewCell.h"

@implementation matchColoumnTableViewCell
@synthesize optionButton,optionLabel,statusImageView;
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        [self setBackgroundColor:[UIColor clearColor]];
        optionButton = [[UIButton alloc] init];
        [optionButton setTitleColor:[UIColor colorWithRed:0 green:174.0/255.0 blue:239.0/255.0 alpha:1.0] forState:UIControlStateNormal];
        optionButton.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:0];
        optionButton.layer.cornerRadius=50.0;
        optionButton.layer.borderColor=[ [UIColor colorWithRed:46/255.0 green:88.0/255.0 blue:128.0/255.0 alpha:1.0] CGColor];
        optionButton.layer.borderWidth=1;
        [self.contentView addSubview:optionButton];
                
        optionLabel = [[UILabel alloc] init];
        [optionLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:18]];
        [optionLabel setTextAlignment:NSTextAlignmentCenter];
        [optionLabel setTextColor:[UIColor colorWithRed:46/255.0 green:88.0/255.0 blue:128.0/255.0 alpha:1.0]];
        [optionLabel setHidden:NO];
        [optionButton addSubview:optionLabel];
       
        optionLabel.numberOfLines=4;
        [optionLabel bringSubviewToFront:optionButton];
        [optionLabel setText:optionButton.titleLabel.text];
        optionLabel.adjustsFontSizeToFitWidth = YES;
        optionLabel.minimumScaleFactor = 0.3;
        optionLabel.adjustsFontSizeToFitWidth = YES;
        
        
        statusImageView= [[UIImageView alloc] init];
        [self.contentView addSubview:statusImageView];
        [statusImageView setHidden:YES];
        

    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    
     optionButton.frame = CGRectMake(20,20,self.frame.size.width - 40 ,self.frame.size.height - 40 );
     optionLabel.frame = CGRectMake(10 ,0, optionButton.frame.size.width - 20,optionButton.frame.size.height);
    statusImageView.frame= CGRectMake((self.frame.size.width - 30)/2, (self.frame.size.height - 30)/2, 30,30);
}



@end
