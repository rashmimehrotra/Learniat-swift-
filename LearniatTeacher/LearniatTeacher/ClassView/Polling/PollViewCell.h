//
//  PollViewCell.h
//  Learniat Teacher
//
//  Created by mindshift_Deepak on 15/10/15.
//  Copyright © 2015 Amith Kumar. All rights reserved.
//

#import <UIKit/UIKit.h>


#define kSelected       @"Selected"
#define kNotSelected    @"NotSelected"



@interface PollViewCell : UIView
{
    NSString                            * subCellState;
    
    id                                  _delgate;
    
    NSString                            *pollOptions;
    
    UIImageView                         *selectButtonImageview;
    
    UIImageView                         *ignoreButtonImageview;

}

@property(nonatomic, assign)  NSInteger             m_optionId;

@property(nonatomic,retain)   UIButton              *mSelectButton;

@property(nonatomic,retain)   UIButton              *mIgnoreButon;

@property(nonatomic,retain)   UILabel               *mMainOptionlabel;

- (void) setPollOptions:(NSString*)_pollOptions;

- (NSString*)getPollOptions;

- (void) selectButtonClicked:(id)sender;

- (void) ignoreButtonClicked:(id)sender;

- (void) setSelectedState:(NSString*)state;

- (NSString*)getPollSubcellState;

- (void) setdelegate:(id)delegate;

- (id)   delegate;


@end

@protocol PollViewCellDelegate <NSObject>

- (void) delegateSelectButtonPressedWithOptionCell:(PollViewCell*)selectedCell;

-(void) delegateIgnoreButtonPressedWithOptionCell:(PollViewCell*)selectedCell;

@end