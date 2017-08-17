//
//  RatingsPopOverViewController.m
//  selectAll
//
//  Created by Deepak MK on 10/02/15.
//  Copyright (c) 2015 Mindshift Apps. All rights reserved.
//

#import "RatingsPopOverViewController.h"

@interface RatingsPopOverViewController ()

@end

@implementation RatingsPopOverViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    
    
   
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) addStartRatingwithStarValue:(int)startValue withtext:(NSString*)text
{
    
    NSArray *viewsToRemove = [self.view subviews];
    for (UIView *v in viewsToRemove)
    {
        [v removeFromSuperview];
    }
    
    topView = [[UIView alloc]initWithFrame:CGRectMake(0,0,200, 40)];
    [topView setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:topView];
    topView.layer.shadowColor = [UIColor colorWithRed:213.0/255.0 green:213.0/255.0 blue:213.0/255.0 alpha:0.5].CGColor;
    topView.layer.shadowOffset = CGSizeMake(1, 1);
    topView.layer.shadowOpacity = 0.5;
    topView.layer.shadowRadius = 0.5;
    topView.clipsToBounds = NO;
    
    topviewLabel= [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 40)];
    [topviewLabel setText:text];
    [self.view addSubview:topviewLabel];
    [topviewLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:16]];
    topviewLabel.textAlignment= NSTextAlignmentCenter;
    
    
    
    mStarRatingView = [[SSStarRatingView alloc] init];
    mStarRatingView.backgroundColor = [UIColor clearColor];
    mStarRatingView.frame = CGRectMake(26, 55, 180, 30);
    [mStarRatingView setDelegate:self];
    [self.view addSubview:mStarRatingView];
    [mStarRatingView setsizeOfStar:25];
    [mStarRatingView setStarRating:startValue];
}


- (void) starRatingDidChange
{
    
}



- (void) addBadgesWithValueValue:(int)badgevalue withtext:(NSString*)text
{
    NSArray *viewsToRemove = [self.view subviews];
    for (UIView *v in viewsToRemove)
    {
        [v removeFromSuperview];
    }
    
    topView = [[UIView alloc]initWithFrame:CGRectMake(0,0,200, 40)];
    [topView setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:topView];
    topView.layer.shadowColor = [UIColor colorWithRed:213.0/255.0 green:213.0/255.0 blue:213.0/255.0 alpha:0.5].CGColor;
    topView.layer.shadowOffset = CGSizeMake(1, 1);
    topView.layer.shadowOpacity = 0.5;
    topView.layer.shadowRadius = 0.5;
    topView.clipsToBounds = NO;
    
    topviewLabel= [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 40)];
    [topviewLabel setText:text];
    [self.view addSubview:topviewLabel];
    [topviewLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:16]];
    topviewLabel.textAlignment= NSTextAlignmentCenter;

    badgeId=badgevalue;
    [self showBadges];
    
    
}

- (void)showBadges
{
    
    
    
    {
        badgesScrollView= [[UIScrollView alloc] initWithFrame:CGRectMake(0, 55, 200, 100)];
        [self.view addSubview:badgesScrollView];
        
        int width=5;
        int height=5;
        for(int i=1;i<=8;i++)
        {
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            [button setFrame:CGRectMake(width,height, 30,30)];
            [badgesScrollView addSubview:button];
            [button setBackgroundColor:[UIColor clearColor]];
            
            NSString *imagePathString = [NSString stringWithFormat:@"/badges/%d.png",i];
            NSString  *jpgPath = [NSTemporaryDirectory()stringByAppendingPathComponent:imagePathString];
            
            UIImage *img = [UIImage imageWithContentsOfFile:jpgPath];
            
            
            [button setTag:i+500];
            if (badgeId==i)
            {
                [button setAlpha:1.0];
                [button setImage:img forState:UIControlStateNormal];
            }
            else
            {
                [button setAlpha:0.3];
                [button setImage:img forState:UIControlStateNormal];
            }
            
            
            [button addTarget:self action:@selector(onBadgeIcon:) forControlEvents:UIControlEventTouchUpInside];
            
            width=width+50;
            if (i==4)
            {
                height=45;
                 width=5;
            }
        }
        [badgesScrollView setContentSize:CGSizeMake(width, 40)];
    }
    
}


- (UIImage*) getbadgeImageWithId:(int)Id
{
    NSString *imagePathString = [NSString stringWithFormat:@"/badges/%d.png",Id];
    NSString  *jpgPath = [NSTemporaryDirectory()stringByAppendingPathComponent:imagePathString];
    
    UIImage *img = [UIImage imageWithContentsOfFile:jpgPath];
    
    return img;
}

-(void)onBadgeIcon:(id)sender
{
    UIButton *tempButton = (UIButton*)sender;
    for(int i=1;i<11;i++)
    {
        UIButton *button = (UIButton*)[badgesScrollView viewWithTag:i+500];
        
        NSString *imagePathString = [NSString stringWithFormat:@"/badges/%d.png",i];
        NSString  *jpgPath = [NSTemporaryDirectory()stringByAppendingPathComponent:imagePathString];
        
        UIImage *img = [UIImage imageWithContentsOfFile:jpgPath];
        

        
        if(button.tag != tempButton.tag)
        {
            
            [button setAlpha:0.5];
            [button setImage:img forState:UIControlStateNormal];
        }
        else
        {
            if (button.alpha==1.0)
            {
                [button setAlpha:0.5];
                 badgeId=0;
                [button setImage:img forState:UIControlStateNormal];
            }
            else
            {
                [button setAlpha:1.0];
                 badgeId=i;
                [button setImage:img forState:UIControlStateNormal];
            }
            
           
        }
    }
}

- (void) addTextviewwithtext:(NSString*)textViewtext withtopviewText:(NSString*)text
{
    NSArray *viewsToRemove = [self.view subviews];
    for (UIView *v in viewsToRemove)
    {
        [v removeFromSuperview];
    }
    
    topView = [[UIView alloc]initWithFrame:CGRectMake(0,0,200, 40)];
    [topView setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:topView];
    topView.layer.shadowColor = [UIColor colorWithRed:213.0/255.0 green:213.0/255.0 blue:213.0/255.0 alpha:0.5].CGColor;
    topView.layer.shadowOffset = CGSizeMake(1, 1);
    topView.layer.shadowOpacity = 0.5;
    topView.layer.shadowRadius = 0.5;
    topView.clipsToBounds = NO;
    
    topviewLabel= [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 40)];
    [topviewLabel setText:text];
    [self.view addSubview:topviewLabel];
    [topviewLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:16]];
    topviewLabel.textAlignment= NSTextAlignmentCenter;
    
    
    mTextView = [[SZTextView alloc] initWithFrame:CGRectMake(0,40,200,60)];
    [mTextView setEditable:YES];
    [mTextView setUserInteractionEnabled:YES];
    [mTextView setFont:[UIFont fontWithName:@"HelveticaNeue" size:18.5]];
    [self.view addSubview:mTextView];
    mTextView.autocorrectionType = UITextAutocorrectionTypeYes;
    mTextView.text = textViewtext;
    mTextView.textColor = [UIColor blackColor];
    [mTextView setBackgroundColor:[UIColor colorWithRed:238.0/255.0 green:238.0/255.0 blue:238.0/255.0 alpha:1.0]];
    
    
}



- (void) addTextViewWithDoneButtonWithQueryId:(NSString*)queryId
{
    NSArray *viewsToRemove = [self.view subviews];
    for (UIView *v in viewsToRemove)
    {
        [v removeFromSuperview];
    }
    
    currentQueryId = queryId;
    topView = [[UIView alloc]initWithFrame:CGRectMake(0,0,300, 40)];
    [topView setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:topView];
//    topView.layer.shadowColor = [UIColor colorWithRed:213.0/255.0 green:213.0/255.0 blue:213.0/255.0 alpha:0.5].CGColor;
//    topView.layer.shadowOffset = CGSizeMake(1, 1);
//    topView.layer.shadowOpacity = 0.5;
//    topView.layer.shadowRadius = 0.5;
//    topView.clipsToBounds = NO;
    
    
    
    UIButton* DoneButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [DoneButton setTitle:@"Send" forState:UIControlStateNormal];
    [DoneButton setTitleColor:[UIColor colorWithRed:0 green:174.0/255.0 blue:239.0/255.0 alpha:1.0] forState:UIControlStateNormal];;
    [DoneButton setShowsTouchWhenHighlighted:YES];
    [DoneButton setAdjustsImageWhenHighlighted:NO];
    [DoneButton addTarget:self action:@selector(onDoneButton) forControlEvents:UIControlEventTouchUpInside];
    DoneButton.frame = CGRectMake(200, 0, 100, 40);
    [topView addSubview:DoneButton];
    [[DoneButton titleLabel] setFont:[UIFont fontWithName:@"Roboto-Medium" size:18]];
    
    
    UIButton* CnacelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [CnacelButton setTitle:@"Cancel" forState:UIControlStateNormal];
    [CnacelButton setTitleColor:[UIColor colorWithRed:0 green:174.0/255.0 blue:239.0/255.0 alpha:1.0] forState:UIControlStateNormal];;
    [CnacelButton setShowsTouchWhenHighlighted:YES];
    [CnacelButton setAdjustsImageWhenHighlighted:NO];
    [CnacelButton addTarget:self action:@selector(onCancelButton) forControlEvents:UIControlEventTouchUpInside];
    CnacelButton.frame = CGRectMake(00, 0, 100, 40);
    [topView addSubview:CnacelButton];
    [[CnacelButton titleLabel] setFont:[UIFont fontWithName:@"Roboto-Regular" size:18]];
    
    topviewLabel= [[UILabel alloc] initWithFrame:CGRectMake(110, 0, 100, 40)];
    [topviewLabel setText:@"Text Reply"];
    [self.view addSubview:topviewLabel];
    [topviewLabel setFont:[UIFont fontWithName:@"Roboto-Regular" size:18]];
    topviewLabel.textAlignment= NSTextAlignmentCenter;
    
    
    mTextView = [[SZTextView alloc] initWithFrame:CGRectMake(0,40,300,120)];
    [mTextView setPlaceholder:@""];
    [mTextView setEditable:YES];
    [mTextView setUserInteractionEnabled:YES];
    mTextView.delegate = self;
    [mTextView setFont:[UIFont fontWithName:@"Roboto-Regular" size:18.5]];
    [self.view addSubview:mTextView];
    mTextView.autocorrectionType = UITextAutocorrectionTypeYes;
    mTextView.text = @"";
    mTextView.textColor = [UIColor blackColor];
    [mTextView setBackgroundColor:[UIColor colorWithRed:247.0/255.0 green:247.0/255.0 blue:247.0/255.0 alpha:1.0]];
    
    
}

- (void)onCancelButton
{
    [[self delegate] dismissPopoverForQuery];
    [[self popOverController]dismissPopoverAnimated:true];
}

- (void) onDoneButton
{
    [[self delegate] dismissPopoverForQuery];
    
    if ([mTextView.text  isEqual: @""])
    {
         [[self popOverController]dismissPopoverAnimated:true];
    }
    else
    {
        [[self delegate]delegatePopoverDoneButtonPressedWithText:mTextView.text withQueryID:currentQueryId];
         [[self popOverController]dismissPopoverAnimated:true];
    }
    
    
    
   
}

- (void) addTextViewWithStudentId:(int)studentId withIndexPath:(int)indexPath
{
    m_indexPath=indexPath;
    m_studentId=studentId;
    
    
    NSArray *viewsToRemove = [self.view subviews];
    for (UIView *v in viewsToRemove)
    {
        [v removeFromSuperview];
    }
    
    topView = [[UIView alloc]initWithFrame:CGRectMake(0,0,400, 40)];
    [topView setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:topView];
    topView.layer.shadowColor = [UIColor colorWithRed:213.0/255.0 green:213.0/255.0 blue:213.0/255.0 alpha:0.5].CGColor;
    topView.layer.shadowOffset = CGSizeMake(1, 1);
    topView.layer.shadowOpacity = 0.5;
    topView.layer.shadowRadius = 0.5;
    topView.clipsToBounds = NO;
    
    topviewLabel= [[UILabel alloc] initWithFrame:CGRectMake(100, 0, 200, 40)];
    [self.view addSubview:topviewLabel];
    [topviewLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:16]];
    topviewLabel.textAlignment= NSTextAlignmentCenter;
    [topviewLabel setText:@"Rate with text"];
    
    mTextView = [[SZTextView alloc] initWithFrame:CGRectMake(0,40,400,200)];
    [mTextView setEditable:YES];
    [mTextView setUserInteractionEnabled:YES];
    [mTextView setFont:[UIFont fontWithName:@"HelveticaNeue" size:18.5]];
    [self.view addSubview:mTextView];
    mTextView.textColor = [UIColor blackColor];
    [mTextView setBackgroundColor:[UIColor colorWithRed:238.0/255.0 green:238.0/255.0 blue:238.0/255.0 alpha:1.0]];
    [mTextView setDelegate:self];
    mTextView.text= @"Type your reply here";
    mTextView.textColor= [UIColor lightGrayColor];
    [mTextView setFont:[UIFont systemFontOfSize:18.0f]];
    
    NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
    [notificationCenter addObserver:self
                           selector:@selector (textViewText:)
                               name:UITextViewTextDidChangeNotification
                             object:mTextView];

    
    
    
    UIButton* CnacelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [CnacelButton setTitle:@"Cancel" forState:UIControlStateNormal];
    [CnacelButton setTitleColor:[UIColor colorWithRed:0 green:174.0/255.0 blue:239.0/255.0 alpha:1.0] forState:UIControlStateNormal];;
    [CnacelButton setShowsTouchWhenHighlighted:YES];
    [CnacelButton setAdjustsImageWhenHighlighted:NO];
    [CnacelButton addTarget:self action:@selector(onCancelButton:) forControlEvents:UIControlEventTouchUpInside];
    CnacelButton.frame = CGRectMake(00, 0, 100, 40);
    [topView addSubview:CnacelButton];
    
    
    
    
    sendButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [sendButton setTitle:@"Send" forState:UIControlStateNormal];
    [sendButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [sendButton setShowsTouchWhenHighlighted:YES];
    [sendButton setAdjustsImageWhenHighlighted:NO];
    [sendButton addTarget:self action:@selector(onSendButton:) forControlEvents:UIControlEventTouchUpInside];
    sendButton.frame = CGRectMake(300, 0, 100, 40);
    [topView addSubview:sendButton];
    [sendButton setEnabled:NO];

    
    
    
    
    
}




- (void)onCancelButton:(id)sender
{
    [[self delegate]dismissPopoverAnimated];
}
- (void)onSendButton:(id)sender
{
    [[self delegate] sendDoubtReplaywithStudentId:[NSString stringWithFormat:@"%ld",(long)m_studentId] withIndexPathValue:[NSString stringWithFormat:@"%ld",(long)m_indexPath] witText:mTextView.text];
    [[self delegate]dismissPopoverAnimated];
    
//    [self dismissViewControllerAnimated:YES completion:nil];
}



- (void) setPopOverController:(id) pop {
    
    
    popoverController = pop ;
}

- (id) popOverController {
    
    return popoverController;
}

- (void) setDelegate:(id)delegate
{
    _delgate= delegate;
}
- (id)   delegate
{
    return _delgate;
}
- (void)textViewDidBeginEditing:(UITextView *)textView
{
    if ([textView.text isEqualToString:@"Type your reply here"])
    {
        textView.text = @"";
        textView.textColor = [UIColor blackColor]; //optional
    }
    [textView becomeFirstResponder];
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    if ([textView.text isEqualToString:@""])
    {
        textView.text = @"Type your reply here";
        textView.textColor = [UIColor lightGrayColor]; //optional
    }
    [textView resignFirstResponder];
}


- (void) textViewText:(id)notification
{
    if([mTextView.text isEqualToString:@" "])
    {
        //textView is Empty
        mTextView.text=@"";
    }
    else
    {
        //textView has text
    }
    if([mTextView.text length]>0)
    {
        
        [sendButton setEnabled:YES];
        [sendButton setUserInteractionEnabled:YES];
        [sendButton setTitleColor:[UIColor colorWithRed:0 green:174.0/255.0 blue:239.0/255.0 alpha:1.0] forState:UIControlStateNormal];;
        
    }
    else
    {
        [sendButton setEnabled:NO];
        [sendButton setUserInteractionEnabled:NO];
        [sendButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    }
    
}





- (int)StarRatings
{
    return (int)[mStarRatingView rating];
}
- (int)badgeId
{
    return badgeId;
}
- (NSString*)textViewtext
{
    return mTextView.text;
}


@end
