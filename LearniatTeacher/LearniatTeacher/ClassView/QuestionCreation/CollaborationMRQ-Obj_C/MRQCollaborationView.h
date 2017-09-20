//
//  MRQCollaborationView.h
//  Learniat Teacher
//
//  Created by Deepak MK on 25/09/15.
//  Copyright © 2015 Amith Kumar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SZTextView.h"
#import "CollaborationOptionCell.h"
//#import "SSTeacherDataSource.h"
#import "MazeScrollView.h"
#import "MRQCollaborationCell.h"
#import "MRQPreviewView.h"
@interface MRQCollaborationView : UIView<UITextViewDelegate>
{
    UIImageView                 *containerview;
    MazeScrollView              *mLeftSideScrollView;
    UILabel                     *mLeftSideLabel;
    MazeScrollView              *mRightSideScrollView;
    UILabel                     *mRightSideLabel;
    UIButton                    *mDismissButton;
    UIButton                    *mPreviewButton;
    id                          _delegate;
    float                       presentYposition;
    float                       rightSideYPosition;
    MRQPreviewView              *mrqPreviewView;
    BOOL                        savAndExitClicked;
    UIImageView                 *collaborationStartingView;
    SZTextView                  *replyTipsTextView;
    
    
}
@property (nonatomic,retain) SZTextView            *mReplyTextView;

- (void) onStartCollaboration:(id)sender;

- (void) setDelegate:(id)delegate;

- (id)   delegate;

-(void) beginCollaboration;

- (void) resetCollaborationView;

- (void) addOptionWithText:(NSString*)optionText withStudentName:(NSString*)studentName withStudentId:(NSString*)studentId withOptionId:(NSString*)optionId withState:(NSString*)state;

- (void) repositionLeftSideCells;

- (void) onColabborationStartWithCoulmn:(NSString*)sender;

- (void) ondeleteQuestion:(id)sender;

- (void) onPreviewQuestion:(id)sender;

- (void) addSelectedTextOption:(NSString*)optionText withStudentName:(NSString*)studentName withStudentId:(NSString*)studentId withOptionId:(NSString*)optionId withState:(NSString*)state;

- (void) repositionRightSideCells;

@end

@protocol MRQCollaborationViewDelegate <NSObject>
- (void) collaborationMRQstartedWithCategoryName:(NSString*)categoryName;
- (void) optionSelectedWithState:(NSString*)state withStudentId:(NSString*)studentId;
- (void) collaborationClosed;
- (void) questionSentwithDetails:(id)details withDemoMode:(BOOL)demoMode;
@end
