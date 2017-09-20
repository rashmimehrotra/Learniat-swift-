//
//  MRQCollaborationView.m
//  Learniat Teacher
//
//  Created by Deepak MK on 25/09/15.
//  Copyright © 2015 Amith Kumar. All rights reserved.
//

#import "MRQCollaborationView.h"

@implementation MRQCollaborationView
@synthesize mReplyTextView;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        
        
        
         [self setBackgroundColor:[UIColor colorWithRed:246.0/255.0 green:246.0/255.0 blue:246.0/255.0 alpha:1.0]];
        
        
        
    }
    return self;
}





- (void) resetCollaborationView
{
    NSArray *viewsToRemove = [self subviews];
    for (UIView *v in viewsToRemove)
    {
        [v removeFromSuperview];
    }
    
    presentYposition=10;
    rightSideYPosition=10;
    UIImageView* topImageView= [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 1024, 50)];
    [topImageView setBackgroundColor:[UIColor whiteColor]];
    [self addSubview:topImageView];
    [topImageView setUserInteractionEnabled:YES];
    
    mDismissButton = [[UIButton alloc] initWithFrame:CGRectMake(20, 5, 200, 40)];
    [mDismissButton setTitle:@"Dismiss" forState:UIControlStateNormal];
    [mDismissButton setTitleColor:[UIColor colorWithRed:0 green:174.0/255.0 blue:239.0/255.0 alpha:1.0] forState:UIControlStateNormal];
    mDismissButton.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue Bold" size:25];
    [topImageView addSubview:mDismissButton];
    [mDismissButton addTarget:self action:@selector(ondeleteQuestion:) forControlEvents:UIControlEventTouchUpInside];
    mDismissButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [mDismissButton setTitleColor:[UIColor colorWithRed:0 green:174.0/255.0 blue:239.0/255.0 alpha:1.0] forState:UIControlStateNormal];
    
    
    
    
    
    
    mPreviewButton = [[UIButton alloc] initWithFrame:CGRectMake(824, 5, 200, 40)];
    [mPreviewButton setTitle:@"Preview" forState:UIControlStateNormal];
    [mPreviewButton setTitleColor:[UIColor colorWithRed:0 green:174.0/255.0 blue:239.0/255.0 alpha:1.0] forState:UIControlStateNormal];
    mPreviewButton.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue Bold" size:25];
    [topImageView addSubview:mPreviewButton];
    [mPreviewButton addTarget:self action:@selector(onPreviewQuestion:) forControlEvents:UIControlEventTouchUpInside];
    mPreviewButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    [mPreviewButton setTitleColor:[UIColor colorWithRed:0 green:174.0/255.0 blue:239.0/255.0 alpha:1.0] forState:UIControlStateNormal];
    
    
    
    containerview= [[UIImageView alloc] initWithFrame:CGRectMake(20, 60, 984, 50)];
    [containerview setBackgroundColor:[UIColor whiteColor]];
    [containerview setUserInteractionEnabled:YES];
    [self addSubview:containerview];
    containerview.layer.borderColor= [[UIColor lightGrayColor] CGColor];
    containerview.layer.borderWidth=1.0f;
    containerview.layer.cornerRadius=5.0f;
    containerview.layer.shadowOpacity=2;
    containerview.layer.shadowColor=[[UIColor colorWithRed:238.0/255.0 green:238.0/255.0 blue:238.0/255.0 alpha:1.0] CGColor];
    
    UILabel* questionTextLabel= [[UILabel alloc] initWithFrame:CGRectMake(10, 3, 80, 40)];
    questionTextLabel.text=@"Question :";
    questionTextLabel.font=[UIFont fontWithName:@"HelveticaNeue" size:15];
    [containerview addSubview:questionTextLabel];
    questionTextLabel.textColor=[UIColor lightGrayColor];
    
    mReplyTextView = [[SZTextView alloc]initWithFrame:CGRectMake(85, 5, 859, 40)];
    mReplyTextView.textColor = [UIColor blackColor];
    [mReplyTextView setBackgroundColor:[UIColor whiteColor]];
    mReplyTextView.autocorrectionType=UITextAutocorrectionTypeYes;
    [containerview addSubview:mReplyTextView];
    mReplyTextView.font=[UIFont fontWithName:@"HelveticaNeue" size:15];
    mReplyTextView.delegate=self;
    mReplyTextView.placeholder= @"Enter question text";
    mReplyTextView.placeholderTextColor= [UIColor lightGrayColor];
    mReplyTextView.autocorrectionType = UITextAutocorrectionTypeYes;
    mReplyTextView.textAlignment=NSTextAlignmentLeft;
    //        NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
    //        [notificationCenter addObserver:self
    //                               selector:@selector (textViewText:)
    //                                   name:UITextViewTextDidChangeNotification
    //                                 object:mReplyTextView];
    
    mReplyTextView.scrollEnabled=NO;
    [mReplyTextView setUserInteractionEnabled:YES];
    
    collaborationStartingView= [[UIImageView alloc] initWithFrame:CGRectMake(0, 140, 1024, 250)];
    [self addSubview:collaborationStartingView];
    [collaborationStartingView setUserInteractionEnabled:YES];
    
    
    UILabel* tipsLabel= [[UILabel alloc] initWithFrame:CGRectMake(312, 10, 400, 30)];
    [tipsLabel setText:@"ENTER KEY AND ASK FOR SUGGESTIONS"];
    [collaborationStartingView addSubview:tipsLabel];
    [tipsLabel setTextAlignment:NSTextAlignmentCenter];
    
    UIImageView* replyBackgroudnView= [[UIImageView alloc] initWithFrame:CGRectMake(262, 60, 500, 200)];
    [replyBackgroudnView setBackgroundColor:[UIColor colorWithRed:224.0/255.0 green:224.0/255.0 blue:224.0/255.0 alpha:1.0f]];
    [collaborationStartingView addSubview:replyBackgroudnView];
    [replyBackgroudnView setUserInteractionEnabled:YES];
    
    
    
    
    UILabel* replyTips= [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 480,30)];
    [replyTips setText:@"This will be sent to all students now to get valid alternatives"];
    [replyBackgroudnView addSubview:replyTips];
    [replyTips setTextAlignment:NSTextAlignmentCenter];
    
    
    UIImageView* replyTipsTextContainerview= [[UIImageView alloc] initWithFrame:CGRectMake(10, 50, 350, 40)];
    [replyTipsTextContainerview setBackgroundColor:[UIColor whiteColor]];
    [replyTipsTextContainerview setUserInteractionEnabled:YES];
    [replyBackgroudnView addSubview:replyTipsTextContainerview];
    replyTipsTextContainerview.layer.borderColor= [[UIColor lightGrayColor] CGColor];
    replyTipsTextContainerview.layer.borderWidth=1.0f;
    replyTipsTextContainerview.layer.cornerRadius=5.0f;
    replyTipsTextContainerview.layer.shadowOpacity=2;
    replyTipsTextContainerview.layer.shadowColor=[[UIColor colorWithRed:238.0/255.0 green:238.0/255.0 blue:238.0/255.0 alpha:1.0] CGColor];

    
    replyTipsTextView = [[SZTextView alloc]initWithFrame:CGRectMake(10, 3, 330, 30)];
    replyTipsTextView.textColor = [UIColor blackColor];
    [replyTipsTextView setBackgroundColor:[UIColor whiteColor]];
    replyTipsTextView.autocorrectionType=UITextAutocorrectionTypeYes;
    [replyTipsTextContainerview addSubview:replyTipsTextView];
    replyTipsTextView.font=[UIFont fontWithName:@"HelveticaNeue" size:15];
    replyTipsTextView.delegate=self;
    replyTipsTextView.placeholder= @"Enter category text";
    replyTipsTextView.placeholderTextColor= [UIColor lightGrayColor];
    replyTipsTextView.autocorrectionType = UITextAutocorrectionTypeYes;
    replyTipsTextView.textAlignment=NSTextAlignmentLeft;
    replyTipsTextView.scrollEnabled=NO;
    [replyTipsTextView setUserInteractionEnabled:YES];
    
    
    UIButton* sendCategoryButton= [[UIButton alloc] initWithFrame:CGRectMake(380, 50, 100, 40)];
    [sendCategoryButton setTitle:@"Send" forState:UIControlStateNormal];
    [sendCategoryButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [replyBackgroudnView addSubview:sendCategoryButton];
    [sendCategoryButton setBackgroundColor:[UIColor colorWithRed:0.0/255.0 green:174.0/255.0 blue:239.0/255.0 alpha:1.0]];
    [sendCategoryButton addTarget:self action:@selector(onStartCollaboration:) forControlEvents:UIControlEventTouchUpInside];
    
    
    UIFont* font =[UIFont fontWithName:@"HelveticaNeue" size:12];
    UILabel* belowReplyView= [[UILabel alloc] initWithFrame:CGRectMake(10, 50, 480,200)];
    [belowReplyView setText:@"This is a prompt to the students to generate alternatives for a question that you are about to construct. Please do not give away the final question at this stage. The idea of sending a prompt KEY is so that students may generate alternatives satisfying a larger constraint (the key is just the hint or a category title). You may have to explain the key verbally to the class, with a few examples."];
    [replyBackgroudnView addSubview:belowReplyView];
    [belowReplyView setTextAlignment:NSTextAlignmentCenter];
    [belowReplyView setFont:font];
    belowReplyView.numberOfLines=10;
    belowReplyView.lineBreakMode=NSLineBreakByWordWrapping;
}
- (void) onStartCollaboration:(id)sender
{
    if (replyTipsTextView.text.length>0)
    {
        [self onColabborationStartWithCoulmn:replyTipsTextView.text];
        
        [self beginCollaboration];
        [replyTipsTextView resignFirstResponder];
        
        
    }
}


-(void) beginCollaboration
{
    [collaborationStartingView setHidden:YES];
    
    mLeftSideLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 130, 400,30)];
    mLeftSideLabel.textAlignment = NSTextAlignmentCenter;
    UIFont* font =[UIFont fontWithName:@"HelveticaNeue" size:18];
    mLeftSideLabel.font = font;
    [self addSubview:mLeftSideLabel];
    [mLeftSideLabel setBackgroundColor:[UIColor clearColor]];
    [mLeftSideLabel setTextColor:[UIColor blackColor]];
    [mLeftSideLabel setText:@"Please select atleast 2 options"];
    
    
    
    mLeftSideScrollView = [[MazeScrollView alloc] initWithFrame:CGRectMake(0, 170, 511,self.frame.size.height-170)];
    mLeftSideScrollView.backgroundColor = [UIColor clearColor];
    [self addSubview:mLeftSideScrollView];
    [mLeftSideScrollView setUserInteractionEnabled:YES];
    mLeftSideScrollView.showsVerticalScrollIndicatorAlways=YES;
    mLeftSideScrollView.indicatorStyle=UIScrollViewIndicatorStyleBlack;
    
    
    UIImageView* LineImageView= [[UIImageView alloc] initWithFrame:CGRectMake(512, 180, 1, self.frame.size.height-180)];
    [self addSubview:LineImageView];
    [LineImageView setBackgroundColor:[UIColor lightGrayColor]];
    
    
    
    mRightSideLabel = [[UILabel alloc]initWithFrame:CGRectMake(624, 130, 400,30)];
    mRightSideLabel.textAlignment = NSTextAlignmentCenter;
    mRightSideLabel.font = font;
    [self addSubview:mRightSideLabel];
    [mRightSideLabel setBackgroundColor:[UIColor clearColor]];
    [mLeftSideLabel setTextColor:[UIColor blackColor]];
    [mRightSideLabel setText:@"Please select correct answers"];
    
    
    
    mRightSideScrollView = [[MazeScrollView alloc] initWithFrame:CGRectMake(513, 170, 511,self.frame.size.height-170)];
    mRightSideScrollView.backgroundColor = [UIColor clearColor];
    [self addSubview:mRightSideScrollView];
    [mRightSideScrollView setUserInteractionEnabled:YES];
    mRightSideScrollView.showsVerticalScrollIndicatorAlways=YES;
    mRightSideScrollView.indicatorStyle=UIScrollViewIndicatorStyleBlack;
}

#pragma mark - buttons functions

- (void) ondeleteQuestion:(id)sender
{
    [[self delegate] collaborationClosed];
   
}

- (void) onPreviewQuestion:(id)sender
{
    
    {
        
        
        mrqPreviewView=[[MRQPreviewView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        [self addSubview:mrqPreviewView];
        
        [mrqPreviewView setDelegate:self];
        [mrqPreviewView setBackgroundColor:[UIColor colorWithRed:246.0/255.0 green:246.0/255.0 blue:246.0/255.0 alpha:1.0]];
    }
    [self bringSubviewToFront:mrqPreviewView];
    [mrqPreviewView setHidden:NO];
    
    NSMutableArray* array=[[NSMutableArray alloc] init];
    NSArray *viewsToRemove = [mRightSideScrollView subviews];
    for (MRQCollaborationCell *optionCell in viewsToRemove)
    {
        if ([optionCell isKindOfClass:[MRQCollaborationCell class]])
        {
            [array addObject:optionCell];
            
        }
    }
    [mrqPreviewView.mQuestionLabel setText:mReplyTextView.text];
    [mrqPreviewView addOptionsWithArray:array];
    
    [mReplyTextView resignFirstResponder];
    
}


#pragma mark - Add category

- (void) addOptionWithText:(NSString*)optionText withStudentName:(NSString*)studentName withStudentId:(NSString*)studentId withOptionId:(NSString*)optionId withState:(NSString*)state
{
    
    
    
    CollaborationOptionCell *optionCell= [[CollaborationOptionCell alloc] init];

    [optionCell setTag:[studentId integerValue]];
    optionCell.m_StudentIdValue=[studentId integerValue];
    optionCell.m_optionId=[optionId integerValue];
    
    [optionCell.mRejectButton setHidden:NO];
    [optionCell.mSelectCorrectWrongButton setHidden:YES];
    if ([state isEqualToString:@"Selected"])
    {
        
        optionCell.backgroundColor= [UIColor colorWithRed:229.0/255.0 green:243.0/255.0 blue:231.0/255.0 alpha:1.0];
    }
    else if ([state isEqualToString:@"Rejected"])
    {
        optionCell.backgroundColor= [UIColor colorWithRed:229.0/255.0 green:243.0/255.0 blue:231.0/255.0 alpha:1.0];
    }
    else if ([state isEqualToString:@"Selected Correct"])
    {
        [optionCell.mSelectCorrectWrongButton setImage:[UIImage imageNamed:@"SelectCollaboration.png"] forState:UIControlStateNormal];
        optionCell.backgroundColor= [UIColor colorWithRed:229.0/255.0 green:243.0/255.0 blue:231.0/255.0 alpha:1.0];
        [optionCell.mRejectButton setHidden:YES];
        [optionCell.mSelectButton setHidden:YES];
        [optionCell.mSelectCorrectWrongButton setHidden:NO];
        
    }
    else
    {
        optionCell.backgroundColor= [UIColor whiteColor];
        
    }
    
    NSMutableDictionary* studentDictonary= [[[SSTeacherDataSource sharedDataSource] getStudentCollaborationDetails]objectForKey:studentId];
    [studentDictonary setObject:state forKey:@"SelectionState"];
    [[SSTeacherDataSource sharedDataSource] setStudentCollaborationDetails:studentDictonary forKey:studentId];
    
    
    [optionCell setDelegate:self];
    
    [optionCell setSelectedState:state];
    [optionCell setOptionLabelWithText:optionText];
    
    CGSize questionLabelSize= [optionCell returnSize];
    
    if (questionLabelSize.height<60)
    {
        questionLabelSize= CGSizeMake(questionLabelSize.width, 60);
    }
    
    
    optionCell.frame= CGRectMake(10,presentYposition,490,questionLabelSize.height);
    [optionCell.mContainerView setFrame:CGRectMake(5,5,480,questionLabelSize.height-10)];
    
    [optionCell.mRejectButton setFrame:CGRectMake(5,(optionCell.mContainerView.frame.size.height-30)/2, 31,30)];
    
    
    [optionCell.mAddButton setFrame:CGRectMake(5,(optionCell.mContainerView.frame.size.height-30)/2, 31,30)];
    
    
    
    [optionCell.mSelectButton setFrame:CGRectMake(optionCell.mContainerView.frame.size.width-30,(optionCell.mContainerView.frame.size.height-30)/2, 31,30)];
    
    [optionCell.mIgnoreButon setFrame:CGRectMake(optionCell.mContainerView.frame.size.width-30,(optionCell.mContainerView.frame.size.height-30)/2, 31,30)];
    
    [optionCell.mMainOptionlabel setFrame:CGRectMake(58, (optionCell.mContainerView.frame.size.height- optionCell.mMainOptionlabel.frame.size.height)/2, optionCell.mMainOptionlabel.frame.size.width, optionCell.mMainOptionlabel.frame.size.height)];
    
    [mLeftSideScrollView addSubview:optionCell];
    
    presentYposition=presentYposition+optionCell.frame.size.height+10.0;
    
    [mLeftSideScrollView setContentSize:CGSizeMake(0, presentYposition)];
    
    
    [optionCell.mMainOptionlabel setText:optionText];
    
    //    [optionCell.mOptionlabel setText:@""];
    
    
    NSMutableDictionary *students = [[SSTeacherDataSource sharedDataSource] getStudentCollaborationDetails];
    
    NSArray *keyArray =  [students allKeys];
    
    NSInteger count = [keyArray count];
    
    if (count>2)
    {
        //        [topBarLabel setText:@"Please select at least two options"];
    }
    [self repositionLeftSideCells];
    
}

- (void) onColabborationStartWithCoulmn:(NSString*)sender
{
    [[SSTeacherDataSource sharedDataSource] recordQuestionWithScribbleId:@"" withQuestionName:@"" withType:@"2" withDelegate:self];
    
//    mReplyTextView.text=sender;
    
}

- (void) didgetRecordedwithDetails:(id)details orError:(NSError *) error
{
    NSMutableArray *students = [[[SSTeacherDataSource sharedDataSource] studentDict] objectForKey:@"Students"];
    
    for (int i= 0; i < [students count]; i++)
    {
        id  student = [students objectAtIndex:i];
        //nslog(@"%@",student);
        [[SSTeacherMessageHandler sharedMessageHandler]sendCollaborationQuestionEnabledWithStudentId:[student objectForKey:@"StudentId"] WithType:@"MRQ" withCollaborationCategoray:replyTipsTextView.text withQuestionId:selectedQuestionId];
    }
    
    
    
    [[self delegate] collaborationMRQstartedWithCategoryName:replyTipsTextView.text];
}



#pragma -mark subCell Delegate

//- (void) selectedClickedWithStudentId:(NSInteger)studentId withState:(NSString*)state withSubCell:(CollaborationOptionCell*)subcell
//{
//    NSMutableDictionary* studentDictonary= [[[SSTeacherDataSource sharedDataSource] getStudentCollaborationDetails] objectForKey:[NSString stringWithFormat:@"%ld",(long)studentId]];
//    
//    [studentDictonary setObject:state forKey:@"SelectionState"];
//    
//    
//    [[SSTeacherDataSource sharedDataSource] setStudentCollaborationDetails:studentDictonary forKey:[NSString stringWithFormat:@"%ld",(long)studentId]];
//    
//    [[self delegate] optionSelectedWithState:state withStudentId:[NSString stringWithFormat:@"%ld",(long)studentId]];
//    
//    
//    [self addSelectedTextOption:subcell.mMainOptionlabel.text withStudentName:@"" withStudentId:[NSString stringWithFormat:@"%ld",(long)subcell.m_StudentIdValue] withOptionId:[NSString stringWithFormat:@"%ld",(long)subcell.m_optionId] withState:@"Selected Wrong"];
//    
//    [subcell removeFromSuperview];
//    presentYposition=presentYposition-subcell.frame.size.height;
//    [self repositionLeftSideCells];
//    
//}

- (void) repositionLeftSideCells
{
    
    NSMutableArray* selectedSubCellsArra=[[NSMutableArray alloc] init];
    NSMutableArray* rejectedSubcellsArray= [[NSMutableArray alloc] init];
    
    NSArray *viewsToRemove = [mLeftSideScrollView subviews];
    for (CollaborationOptionCell *optionCell in viewsToRemove)
    {
        if ([optionCell isKindOfClass:[CollaborationOptionCell class]])
        {
            if ([[optionCell getSelectedState] isEqualToString:@"Rejected"])
            {
                [rejectedSubcellsArray addObject:optionCell];
            }
            else
            {
                [selectedSubCellsArra addObject:optionCell];
            }
        }
    }
    
    presentYposition=10;
    for (int i=0; i<[selectedSubCellsArra count]; i++)
    {
        CollaborationOptionCell *optionCell= [selectedSubCellsArra objectAtIndex:i];
        
        if ([optionCell isKindOfClass:[CollaborationOptionCell class]])
        {
            [UIView animateWithDuration:0.3 animations:^{
               optionCell.frame= CGRectMake(10,presentYposition,optionCell.frame.size.width,optionCell.frame.size.height);
            }];
            
            presentYposition=presentYposition+optionCell.frame.size.height+10;
        }
    }
    
    for (int i=0; i<[rejectedSubcellsArray count]; i++)
    {
        CollaborationOptionCell *optionCell= [rejectedSubcellsArray objectAtIndex:i];
        
        if ([optionCell isKindOfClass:[CollaborationOptionCell class]])
        {
            [UIView animateWithDuration:0.3 animations:^{
                optionCell.frame= CGRectMake(10,presentYposition,optionCell.frame.size.width,optionCell.frame.size.height);
            }];
            
            presentYposition=presentYposition+optionCell.frame.size.height+10;
        }
    }
}

//- (void) unSelectWithStudentId:(NSInteger)studentId withState:(NSString*)state
//{
//    NSMutableDictionary* studentDictonary= [[[SSTeacherDataSource sharedDataSource] getStudentCollaborationDetails] objectForKey:[NSString stringWithFormat:@"%ld",(long)studentId]];
//    
//    [studentDictonary setObject:state forKey:@"SelectionState"];
//    
//    [[self delegate] optionSelectedWithState:state withStudentId:[NSString stringWithFormat:@"%ld",(long)studentId]];
//    [[SSTeacherDataSource sharedDataSource] setStudentCollaborationDetails:studentDictonary forKey:[NSString stringWithFormat:@"%ld",(long)studentId]];
//    
////    [self checkSelectedCount];
//}
//
//- (void) addButtonWithStudentId:(NSInteger)studentId withState:(NSString*)state
//{
//    NSMutableDictionary* studentDictonary= [[[SSTeacherDataSource sharedDataSource] getStudentCollaborationDetails] objectForKey:[NSString stringWithFormat:@"%ld",(long)studentId]];
//    
//    [studentDictonary setObject:state forKey:@"SelectionState"];
//    
//    [[self delegate] optionSelectedWithState:state withStudentId:[NSString stringWithFormat:@"%ld",(long)studentId]];
//    [[SSTeacherDataSource sharedDataSource] setStudentCollaborationDetails:studentDictonary forKey:[NSString stringWithFormat:@"%ld",(long)studentId]];
//    [self repositionLeftSideCells];
//}


- (void) rejectClickedWithStudentId:(NSInteger)studentId withState:(NSString*)state
{
    NSMutableDictionary* studentDictonary= [[[SSTeacherDataSource sharedDataSource] getStudentCollaborationDetails] objectForKey:[NSString stringWithFormat:@"%ld",(long)studentId]];
    
    [[self delegate] optionSelectedWithState:state withStudentId:[NSString stringWithFormat:@"%ld",(long)studentId]];
    
    [studentDictonary setObject:state forKey:@"SelectionState"];
    [[SSTeacherDataSource sharedDataSource] setStudentCollaborationDetails:studentDictonary forKey:[NSString stringWithFormat:@"%ld",(long)studentId]];
     [self repositionLeftSideCells];
    
}



- (void) selectionChangedWithState:(NSString*)state withStudentId:(NSString*)studentId
{
    UIView *myTable = mLeftSideScrollView;
    UIView* tempview = [myTable viewWithTag:[studentId integerValue]];
    CollaborationOptionCell *optionCell=(CollaborationOptionCell*)tempview;
    if ([state isEqualToString:@"Selected"])
    {
        
        [optionCell.mSelectButton setHidden:YES];
        [optionCell.mRejectButton setHidden:YES];
        [optionCell.mIgnoreButon setHidden:NO];
        
        optionCell.backgroundColor= [UIColor colorWithRed:229.0/255.0 green:243.0/255.0 blue:231.0/255.0 alpha:1.0];
        [optionCell.mRejectButton setAlpha:1];
    }
    else if ([state isEqualToString:@"Rejected"])
    {
        [optionCell.mSelectButton setHidden:YES];
        [optionCell.mRejectButton setHidden:YES];
        [optionCell.mIgnoreButon setHidden:NO];
        
        optionCell.backgroundColor= [UIColor colorWithRed:229.0/255.0 green:243.0/255.0 blue:231.0/255.0 alpha:1.0];
        [optionCell.mRejectButton setAlpha:0.2];
    }
    else if ([state isEqualToString:@"Selected Correct"])
    {
        [optionCell.mSelectButton setHidden:YES];
        [optionCell.mRejectButton setHidden:YES];
        [optionCell.mIgnoreButon setHidden:NO];
        
        optionCell.backgroundColor= [UIColor colorWithRed:229.0/255.0 green:243.0/255.0 blue:231.0/255.0 alpha:1.0];
        [optionCell.mRejectButton setAlpha:1];
    }
    else if ([state isEqualToString:@"Selected Wrong"])
    {
        [optionCell.mSelectButton setHidden:YES];
        [optionCell.mRejectButton setHidden:YES];
        [optionCell.mIgnoreButon setHidden:NO];
        
        optionCell.backgroundColor= [UIColor colorWithRed:229.0/255.0 green:243.0/255.0 blue:231.0/255.0 alpha:1.0];
    }
    else
    {
        optionCell.backgroundColor= [UIColor whiteColor];
        [optionCell.mRejectButton setAlpha:1];
        
        
        [optionCell.mSelectButton setHidden:NO];
        [optionCell.mRejectButton setHidden:NO];
        [optionCell.mIgnoreButon setHidden:YES];
        
        
    }
    [optionCell setSelectedState:state];
}
- (void) textViewText:(id)notification
{
//    if([mReplyTextView.text length]>0)
//    {
//        if(totalSelectedCount>=1)
//        {
//            [m_sendBtton setEnabled:YES];
//            [m_sendBtton setUserInteractionEnabled:YES];
//            [m_sendBtton setTitleColor:[UIColor colorWithRed:0 green:174.0/255.0 blue:239.0/255.0 alpha:1.0] forState:UIControlStateNormal];
//            
//            [m_saveAndExit setEnabled:YES];
//            [m_saveAndExit setUserInteractionEnabled:YES];
//            [m_saveAndExit setTitleColor:[UIColor colorWithRed:0 green:174.0/255.0 blue:239.0/255.0 alpha:1.0] forState:UIControlStateNormal];
//            
//        }
//        
//    }
//    else
//    {
//        [m_sendBtton setEnabled:NO];
//        [m_sendBtton setUserInteractionEnabled:NO];
//        [m_sendBtton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
//        
//        [m_saveAndExit setEnabled:NO];
//        [m_saveAndExit setUserInteractionEnabled:NO];
//        [m_saveAndExit setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
//    }
//    
}

- (void) setDelegate:(id)delegate
{
    _delegate= delegate;
}
- (id)   delegate
{
    return _delegate;
}



#pragma mark - Add Selected cell

- (void) addSelectedTextOption:(NSString*)optionText withStudentName:(NSString*)studentName withStudentId:(NSString*)studentId withOptionId:(NSString*)optionId withState:(NSString*)state
{
    
    
    
    MRQCollaborationCell *optionCell= [[MRQCollaborationCell alloc] init];
    
    [optionCell setTag:[studentId integerValue]];
    optionCell.m_StudentIdValue=[studentId integerValue];
    optionCell.m_optionId=[optionId integerValue];
    
    [optionCell.mRejectButton setHidden:NO];
   
        optionCell.backgroundColor= [UIColor whiteColor];
  
//    NSMutableDictionary* studentDictonary= [[[SSTeacherDataSource sharedDataSource] getStudentCollaborationDetails]objectForKey:studentId];
//    [studentDictonary setObject:state forKey:@"SelectionState"];
//    [[SSTeacherDataSource sharedDataSource] setStudentCollaborationDetails:studentDictonary forKey:studentId];
    
    
    [optionCell setDelegate:self];
    
    [optionCell setSelectedState:state];
    [optionCell setOptionLabelWithText:optionText];
    
    CGSize questionLabelSize= [optionCell returnHeight];
    
    if (questionLabelSize.height<60)
    {
        questionLabelSize= CGSizeMake(questionLabelSize.width, 60);
    }
    
    
    optionCell.frame= CGRectMake(10,rightSideYPosition,490,questionLabelSize.height);
    
    [optionCell.mRejectButton setFrame:CGRectMake(optionCell.frame.size.width-35,(optionCell.frame.size.height-30)/2, 31,30)];
    
    
    
    [optionCell.mSelectButton setFrame:CGRectMake(5,(optionCell.frame.size.height-30)/2, 31,30)];
    
    [optionCell.mIgnoreButon setFrame:CGRectMake(5,(optionCell.frame.size.height-30)/2, 31,30)];
    
    [optionCell.mMainOptionlabel setFrame:CGRectMake(58, (optionCell.frame.size.height- optionCell.mMainOptionlabel.frame.size.height)/2, optionCell.mMainOptionlabel.frame.size.width, optionCell.mMainOptionlabel.frame.size.height)];
    
    [mRightSideScrollView addSubview:optionCell];
    
    rightSideYPosition=rightSideYPosition+optionCell.frame.size.height+10.0;
    
    [mRightSideScrollView setContentSize:CGSizeMake(0, rightSideYPosition)];
    
    
    [optionCell.mMainOptionlabel setText:optionText];
    
    
    
}

- (void) SelectCorrectOptionWithStudentId:(NSInteger)studentId withState:(NSString*)state withSubcell:(MRQCollaborationCell*)subcell
{
//    NSMutableDictionary* studentDictonary= [[[SSTeacherDataSource sharedDataSource] getStudentCollaborationDetails] objectForKey:[NSString stringWithFormat:@"%ld",(long)studentId]];
//    
//    [studentDictonary setObject:state forKey:@"SelectionState"];
//    
//    
//    [[SSTeacherDataSource sharedDataSource] setStudentCollaborationDetails:studentDictonary forKey:[NSString stringWithFormat:@"%ld",(long)studentId]];
    
    [[self delegate] optionSelectedWithState:state withStudentId:[NSString stringWithFormat:@"%ld",(long)studentId]];
    
    
    
    
    if (!([state isEqualToString:@"Selected Correct"] || [state isEqualToString:@"Selected Wrong"]))
    {
//        [self addSelectedTextOption:subcell.mMainOptionlabel.text withStudentName:@"" withStudentId:[NSString stringWithFormat:@"%ld",(long)subcell.m_StudentIdValue] withOptionId:[NSString stringWithFormat:@"%ld",(long)subcell.m_optionId] withState:@"Selected Wrong"];
//        
//        
//        
        [self addOptionWithText:subcell.mMainOptionlabel.text withStudentName:@"" withStudentId:[NSString stringWithFormat:@"%ld",(long)subcell.m_StudentIdValue] withOptionId:[NSString stringWithFormat:@"%ld",(long)subcell.m_optionId] withState:@"not_Selected"];
        [subcell removeFromSuperview];
        rightSideYPosition=rightSideYPosition-subcell.frame.size.height;
        
        [self repositionRightSideCells];
    }
    
    
    
}

- (void) repositionRightSideCells
{
    rightSideYPosition=10;
    NSArray *viewsToRemove = [mRightSideScrollView subviews];
    for (MRQCollaborationCell *optionCell in viewsToRemove)
    {
        if ([optionCell isKindOfClass:[MRQCollaborationCell class]])
        {
            optionCell.frame= CGRectMake(10,rightSideYPosition,optionCell.frame.size.width,optionCell.frame.size.height);
            rightSideYPosition=rightSideYPosition+optionCell.frame.size.height+10;
 
        }
    }
}



#pragma mark - preview view Functions
- (void)onSaveButton
{
    savAndExitClicked=YES;
//    [[SSTeacherDataSource sharedDataSource] updateRecordQuestion:mReplyTextView.text withDelegate:self];
}
- (void)onSendButton
{
//    [[SSTeacherDataSource sharedDataSource] updateRecordQuestion:mReplyTextView.text withDelegate:self];
}


- (void) didgetRecordQuestionUpdatedWithDetilas:(id)details orError:(NSError *)error
{
    
    
    [[self delegate] collaborationClosed];
    
    
    if (!savAndExitClicked)
    {
//        [[SSTeacherDataSource sharedDataSource] getAllNodes:[[[SSTeacherDataSource sharedDataSource] m_getsubJectId] objectForKey:current_Session_Id] WithTopicid:StartedSubTopicId withTopicType:@"Only Questions"  withDelegate:self];
    }
}

- (void) didGetAllNodes:(id)details orError:(NSError*)error
{
    
    //nslog(@"%@",details);
//    
//    NSMutableDictionary* sampledetails = [[details objectForKey:kSunstone] objectForKey:kSSAction];
//    
//    NSMutableArray* questionsArray= [sampledetails objectForKey:@"Questions"];
//    
//    for (int i=0; i< [questionsArray count]; i++)
//    {
//        id dict= [questionsArray objectAtIndex:i];
//        if ([[dict objectForKey:@"Id"] isEqualToString:selectedQuestionId])
//        {
//            
//            [[SSTeacherDataSource sharedDataSource]broadcastQuestion:[dict objectForKey:@"Id"] withDelegate:self];
//            
//            [[NSUserDefaults standardUserDefaults] setObject:dict forKey:@"popoverDetails"];
//            [[NSUserDefaults standardUserDefaults] synchronize];
//            NSUserDefaults* defaults= [NSUserDefaults standardUserDefaults];
//            [defaults setBool:YES forKey:@"QuestionSent"];
//            
//            [defaults setObject:dict forKey:@"QuestionDetails"];
//            
//            [defaults setBool:YES forKey:@"QuestionSent"];
//            [defaults synchronize];
//            [[SSTeacherDataSource sharedDataSource]setCurrentQuestionDict:dict];
//            
//            
//            
//        }
//    }
    
    
}

- (void) didgetQuestionSentmessage:(id)details orError:(NSError *)error
{
//     NSUserDefaults* defaults= [NSUserDefaults standardUserDefaults];
//    if([defaults boolForKey:@"isSimulateMode"])
//    {
//        [[self delegate] questionSentwithDetails:[[SSTeacherDataSource sharedDataSource] currentQuestionDict] withDemoMode:YES];
//    }
//    else
//    {
//        [[self delegate] questionSentwithDetails:[[SSTeacherDataSource sharedDataSource] currentQuestionDict] withDemoMode:NO];
//    }

}

@end
