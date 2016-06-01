//
//  RatingsPopOverViewController.h
//  selectAll
//
//  Created by Deepak MK on 10/02/15.
//  Copyright (c) 2015 Mindshift Apps. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SSStarRatingView.h"
@interface RatingsPopOverViewController : UIViewController<UITextViewDelegate>
{
    
    SSStarRatingView                    *mStarRatingView;
    UIView                              *topView;
    UILabel                             *topviewLabel;
    UIScrollView                        *badgesScrollView;
    int                                 badgeId;
    UITextView                          *mTextView;
    int                                 m_studentId;
    int                                 m_indexPath;
    UIButton                            *sendButton;
    
    id                              _delgate;
    id                              popoverController;
    NSString                        *currentQueryId;

}
- (void) addStartRatingwithStarValue:(int)startValue withtext:(NSString*)text;
- (void) addBadgesWithValueValue:(int)badgevalue withtext:(NSString*)text;
- (void) addTextviewwithtext:(NSString*)textViewtext withtopviewText:(NSString*)text;
- (void) addTextViewWithStudentId:(int)studentId withIndexPath:(int)indexPath;
- (int)StarRatings;
- (int)badgeId;
- (NSString*)textViewtext;

- (UIImage*) getbadgeImageWithId:(int)Id;

- (void) setDelegate:(id)delegate;
- (id)   delegate;

- (void) setPopOverController:(id) pop;
- (id) popOverController;
- (void) addTextViewWithDoneButtonWithQueryId:(NSString*)queryId;

@end

@protocol RatingsPopOverViewControllerDelegate <NSObject>

@optional - (void) sendDoubtReplaywithStudentId:(NSString*)studentId withIndexPathValue:(NSString*)indexPathValue witText:(NSString*)text;
@optional - (void) dismissPopoverAnimated;
@optional - (void) delegatePopoverDoneButtonPressedWithText:(NSString*)text withQueryID:(NSString*)queryId;


@end