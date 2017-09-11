//
//  SSStudentMatchTheColoumnView.h
//  Learniat Teacher
//
//  Copyright (c) 2015 Mindshift Applications and Solutions Private Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "matchColoumnTableViewCell.h"
#import "NoShadowTableView.h"
@interface SSStudentMatchTheColoumnView : UIView<UITableViewDataSource,UITableViewDelegate>
{
    id                                      _delegate;

    
    
    
    NSMutableArray                      *firstColoumnArray;
    
    NSMutableArray                      *secondColoumnArray;
    
    NSMutableDictionary                 *selectedOptionDictonary;
    
    UIScrollView                        *optionDetailsScrollview;
    
    NSString                            *QuestionType;
    
    NSMutableArray                      *buttonsArray;
    
    NoShadowTableView                         *firstColoumnTableView;
    
    NoShadowTableView                         *secondColoumntableView;
    
    NSMutableArray                  *mLeftSequenceArray;
    
    NSMutableArray                  *mRightSequenceArray;
    
    NSMutableArray                  *mSelectedOptionsArray;
    
    NSMutableArray                  *mAnswerArray;
    
    NSMutableArray                  *tempAnsArray;
    
    NoShadowTableView               *StatusView;
    
    BOOL                            sendButtonPressed;
    
    BOOL                            isEditing;

    
    NSMutableArray                      *fullOptionsArray;
    
    BOOL                                mAnswerFreezed;

}
- (void) setDelegate:(id)delegate;

- (id)delegate;

- (NSString*)onSendButton;

- (void)onDontKnowButton;

- (void)updateMatchColoumnQuestionDict:(id)dict;

- (void)FreezMessageFromTeacher;

- (void)questionClearedByTeacher;

- (NSMutableArray*)getOptionsArray;


@end
