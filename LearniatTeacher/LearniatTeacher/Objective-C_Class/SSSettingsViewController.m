//
//  SSSettingsViewController.m
//  Learniat Teacher
//
//  Copyright (c) 2015 Mindshift Applications and Solutions Private Ltd. All rights reserved.
//

#import "SSSettingsViewController.h"
#import "PlistDownloder.h"
@interface SSSettingsViewController ()

@end



@implementation SSSettingsViewController
@synthesize setupTopicsButton,
logoutButton,
setupSitingButton,
testPingButton,
XmppReconnect,
manualResignButton,
alphabeticalReassignButton,
randomReassignButton,
takePhoto,
pullNewProfilePics;
// Implement loadView to create a view hierarchy programmatically, without using a nib.

- (float) scheduleScrrenTeacherImagePressed
{
    
    UIView *baseView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, 280, 43.0)];
    baseView.backgroundColor = [UIColor colorWithRed:248.0/255.0 green:248.0/255.0 blue:248.0/255.0 alpha:1.0];
    self.view = baseView;
    [self.navigationController.navigationBar setHidden:YES];
   
   
    
    
//    setupSitingButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    [setupSitingButton addTarget:self action:@selector(onSetUpSeatingButtonAction:) forControlEvents:UIControlEventTouchUpInside];
//    setupSitingButton.frame = CGRectMake(10.0,20, 290, 40); //(10.0, 116.0, 258.0, 43.0);
//    [self.view addSubview:setupSitingButton];
//    [setupSitingButton setTitle:@"SetUpSeating" forState:UIControlStateNormal];
//    [setupSitingButton setTitleColor:[UIColor colorWithRed:0.0 green:174.0/255.0 blue:239.0/255.0 alpha:1.0] forState:UIControlStateNormal];
//    [setupSitingButton setBackgroundColor:[UIColor whiteColor]];
//    
    
    
    XmppReconnect = [UIButton buttonWithType:UIButtonTypeCustom];
    [XmppReconnect addTarget:self action:@selector(onXmppButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    XmppReconnect.frame = CGRectMake(100.0,20, 200, 40); //(10.0, 116.0, 258.0, 43.0);
    [self.view addSubview:XmppReconnect];
    [XmppReconnect setTitle:@"Xmpp Reconnect" forState:UIControlStateNormal];
    [XmppReconnect setTitleColor:[UIColor colorWithRed:0.0 green:174.0/255.0 blue:239.0/255.0 alpha:1.0] forState:UIControlStateNormal];
    [XmppReconnect setBackgroundColor:[UIColor whiteColor]];
    

    
    UILabel *mDiagnosisLabel= [[UILabel alloc] initWithFrame:CGRectMake(10.0, 20, 90, 40)];
    [self.view addSubview:mDiagnosisLabel];
    [mDiagnosisLabel setBackgroundColor:[UIColor whiteColor]];
    mDiagnosisLabel.textAlignment = NSTextAlignmentCenter;
    mDiagnosisLabel.numberOfLines=10;
    mDiagnosisLabel.lineBreakMode= NSLineBreakByTruncatingTail;
    [mDiagnosisLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:16]];
    [mDiagnosisLabel setText:@" Diagnostics"];
    [mDiagnosisLabel setTextColor:[UIColor colorWithRed:96.0/255.0 green:96.0/255.0 blue:96.0/255.0 alpha:1.0]];
    
    
//    UIView *lineView5 = [[UIView alloc]initWithFrame:CGRectMake(110, 85, 1, 30) ];
//    [lineView5 setBackgroundColor:[UIColor colorWithRed:213.0/255.0 green:213.0/255.0 blue:213.0/255.0 alpha:0.7]];
//    [self.view addSubview:lineView5];
//
    
    
    
//    UILabel *addQuestionLable= [[UILabel alloc] initWithFrame:CGRectMake(10.0,140, 90, 120)];
//    [self.view addSubview:addQuestionLable];
//    [addQuestionLable setBackgroundColor:[UIColor whiteColor]];
//    addQuestionLable.textAlignment = NSTextAlignmentCenter;
//    addQuestionLable.numberOfLines=10;
//    addQuestionLable.lineBreakMode= NSLineBreakByTruncatingTail;
//    [addQuestionLable setFont:[UIFont fontWithName:@"HelveticaNeue" size:16]];
//    [addQuestionLable setText:@"Add Question"];
//    [addQuestionLable setTextColor:[UIColor colorWithRed:96.0/255.0 green:96.0/255.0 blue:96.0/255.0 alpha:1.0]];
//
//    
//    
//    
//    UIButton* multipleChoice = [UIButton buttonWithType:UIButtonTypeCustom];
//    [multipleChoice addTarget:self action:@selector(onCreateMRQQuestion:) forControlEvents:UIControlEventTouchUpInside];
//    multipleChoice.frame = CGRectMake(100.0,140, 200, 40); //(10.0, 116.0, 258.0, 43.0);
//    [self.view addSubview:multipleChoice];
//    [multipleChoice setTitle:@"Multiple Choice" forState:UIControlStateNormal];
//    [multipleChoice setTitleColor:[UIColor colorWithRed:0.0 green:174.0/255.0 blue:239.0/255.0 alpha:1.0] forState:UIControlStateNormal];
//    [multipleChoice setBackgroundColor:[UIColor whiteColor]];
//    
//    
//    UIButton* matchColumn = [UIButton buttonWithType:UIButtonTypeCustom];
////    [matchColumn addTarget:self action:@selector(onLogoutButtonAction:) forControlEvents:UIControlEventTouchUpInside];
//    matchColumn.frame = CGRectMake(100.0,180, 200, 40); //(10.0, 116.0, 258.0, 43.0);
//    [self.view addSubview:matchColumn];
//    [matchColumn setTitle:@"Match column" forState:UIControlStateNormal];
//    [matchColumn setTitleColor:[UIColor colorWithRed:0.0 green:174.0/255.0 blue:239.0/255.0 alpha:1.0] forState:UIControlStateNormal];
//    [matchColumn setBackgroundColor:[UIColor whiteColor]];
//    
//    UIButton* scribble = [UIButton buttonWithType:UIButtonTypeCustom];
//    [scribble addTarget:self action:@selector(onCreateScribbleQuestion:) forControlEvents:UIControlEventTouchUpInside];
//    scribble.frame = CGRectMake(100.0,220, 200, 40); //(10.0, 116.0, 258.0, 43.0);
//    [self.view addSubview:scribble];
//    [scribble setTitle:@"Scribble" forState:UIControlStateNormal];
//    [scribble setTitleColor:[UIColor colorWithRed:0.0 green:174.0/255.0 blue:239.0/255.0 alpha:1.0] forState:UIControlStateNormal];
//    [scribble setBackgroundColor:[UIColor whiteColor]];
//    
//    
//    
//    UIView *lineView6 = [[UIView alloc]initWithFrame:CGRectMake(110, 145, 1, 110) ];
//    [lineView6 setBackgroundColor:[UIColor colorWithRed:213.0/255.0 green:213.0/255.0 blue:213.0/255.0 alpha:0.7]];
//    [self.view addSubview:lineView6];
    

    
    
    
    
    logoutButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [logoutButton addTarget:self action:@selector(onLogoutButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    logoutButton.frame = CGRectMake(10.0,85, 290, 40); //(10.0, 116.0, 258.0, 43.0);
    [self.view addSubview:logoutButton];
    [logoutButton setTitle:@"Sign Out" forState:UIControlStateNormal];
    [logoutButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [logoutButton setBackgroundColor:[UIColor whiteColor]];
    
    
    
    return logoutButton.frame.origin.y + logoutButton.frame.size.height + 20;
    
    
}




- (void) ClassViewTopicsButtonSettingsButtonPressed
{
    UIView *baseView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, 280, 43.0)];
    baseView.backgroundColor = [UIColor colorWithRed:248.0/255.0 green:248.0/255.0 blue:248.0/255.0 alpha:1.0];
    self.view = baseView;
    [self.navigationController.navigationBar setHidden:YES];
    
    

    setupTopicsButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [setupTopicsButton addTarget:self action:@selector(onSetupTopicsButton:) forControlEvents:UIControlEventTouchUpInside];
    setupTopicsButton.frame = CGRectMake(10.0,20, 290, 40); //(10.0, 116.0, 258.0, 43.0);
    [self.view addSubview:setupTopicsButton];
    [setupTopicsButton setTitle:@"Setup Topics" forState:UIControlStateNormal];
    [setupTopicsButton setTitleColor:[UIColor colorWithRed:0.0 green:174.0/255.0 blue:239.0/255.0 alpha:1.0] forState:UIControlStateNormal];
    [setupTopicsButton setBackgroundColor:[UIColor whiteColor]];
    
    
    
    
    manualResignButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [manualResignButton addTarget:self action:@selector(onManualResignClicked:) forControlEvents:UIControlEventTouchUpInside];
    manualResignButton.frame = CGRectMake(100.0,81, 200, 40); //(10.0, 116.0, 258.0, 43.0);
    [self.view addSubview:manualResignButton];
    [manualResignButton setTitle:@"Manual" forState:UIControlStateNormal];
    [manualResignButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [manualResignButton setBackgroundColor:[UIColor whiteColor]];
    
    
    UIView *lineView1 = [[UIView alloc]initWithFrame:CGRectMake(110, 121, 180, 1) ];
    [lineView1 setBackgroundColor:[UIColor colorWithRed:213.0/255.0 green:213.0/255.0 blue:213.0/255.0 alpha:0.7]];
    [self.view addSubview:lineView1];
    
    
    
    
    randomReassignButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [randomReassignButton addTarget:self action:@selector(onRandomReasignClicked:) forControlEvents:UIControlEventTouchUpInside];
    randomReassignButton.frame = CGRectMake(100.0,122, 200, 40); //(10.0, 116.0, 258.0, 43.0);
    [self.view addSubview:randomReassignButton];
    [randomReassignButton setTitle:@"Random" forState:UIControlStateNormal];
    [randomReassignButton setTitleColor:[UIColor colorWithRed:0.0 green:174.0/255.0 blue:239.0/255.0 alpha:1.0] forState:UIControlStateNormal];
    [randomReassignButton setBackgroundColor:[UIColor whiteColor]];
    
    
    UIView *lineView2 = [[UIView alloc]initWithFrame:CGRectMake(110, 162, 180, 1) ];
    [lineView2 setBackgroundColor:[UIColor colorWithRed:213.0/255.0 green:213.0/255.0 blue:213.0/255.0 alpha:0.7]];
    [self.view addSubview:lineView2];

    
    
    
    
    alphabeticalReassignButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [alphabeticalReassignButton addTarget:self action:@selector(onAlphabeticalReassignClicked:) forControlEvents:UIControlEventTouchUpInside];
    alphabeticalReassignButton.frame = CGRectMake(100.0,163, 200, 40); //(10.0, 116.0, 258.0, 43.0);
    [self.view addSubview:alphabeticalReassignButton];
    [alphabeticalReassignButton setTitle:@"Alphabetical" forState:UIControlStateNormal];
    [alphabeticalReassignButton setTitleColor:[UIColor colorWithRed:0.0 green:174.0/255.0 blue:239.0/255.0 alpha:1.0] forState:UIControlStateNormal];
    [alphabeticalReassignButton setBackgroundColor:[UIColor whiteColor]];
    
    
      
    
    
    UILabel *mResignLabel= [[UILabel alloc] initWithFrame:CGRectMake(10.0, 81, 89, 122)];
    [self.view addSubview:mResignLabel];
    [mResignLabel setBackgroundColor:[UIColor whiteColor]];
    mResignLabel.textAlignment = NSTextAlignmentCenter;
    mResignLabel.numberOfLines=10;
    mResignLabel.lineBreakMode= NSLineBreakByTruncatingTail;
    [mResignLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:16]];
    [mResignLabel setText:@"Reassign \n seats"];
    [mResignLabel setTextColor:[UIColor colorWithRed:96.0/255.0 green:96.0/255.0 blue:96.0/255.0 alpha:1.0]];
    
    
    UIView *lineView3 = [[UIView alloc]initWithFrame:CGRectMake(100, 91, 1, 102) ];
    [lineView3 setBackgroundColor:[UIColor colorWithRed:213.0/255.0 green:213.0/255.0 blue:213.0/255.0 alpha:0.7]];
    [self.view addSubview:lineView3];
    

    
    
    
//    
//    testPingButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    [testPingButton addTarget:self action:@selector(onTestPingButton:) forControlEvents:UIControlEventTouchUpInside];
//    testPingButton.frame = CGRectMake(100.0,223, 200, 40); //(10.0, 116.0, 258.0, 43.0);
//    [self.view addSubview:testPingButton];
//    [testPingButton setTitle:@"Test Ping" forState:UIControlStateNormal];
//    [testPingButton setTitleColor:[UIColor colorWithRed:0.0 green:174.0/255.0 blue:239.0/255.0 alpha:1.0] forState:UIControlStateNormal];
//    [testPingButton setBackgroundColor:[UIColor whiteColor]];
//
//    
//    
//    UIView *lineView4 = [[UIView alloc]initWithFrame:CGRectMake(110, 263, 180, 1) ];
//    [lineView4 setBackgroundColor:[UIColor colorWithRed:213.0/255.0 green:213.0/255.0 blue:213.0/255.0 alpha:0.7]];
//    [self.view addSubview:lineView4];
//    
    
    XmppReconnect = [UIButton buttonWithType:UIButtonTypeCustom];
    [XmppReconnect addTarget:self action:@selector(onXmppButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    XmppReconnect.frame = CGRectMake(100.0,223, 200, 80); //(10.0, 116.0, 258.0, 43.0);
    [self.view addSubview:XmppReconnect];
    [XmppReconnect setTitle:@"Xmpp Reconnect" forState:UIControlStateNormal];
    [XmppReconnect setTitleColor:[UIColor colorWithRed:0.0 green:174.0/255.0 blue:239.0/255.0 alpha:1.0] forState:UIControlStateNormal];
    [XmppReconnect setBackgroundColor:[UIColor whiteColor]];
    
    
    
    
    
    
    
    UILabel *mDiagnosisLabel= [[UILabel alloc] initWithFrame:CGRectMake(10.0, 223, 89, 81)];
    [self.view addSubview:mDiagnosisLabel];
    [mDiagnosisLabel setBackgroundColor:[UIColor whiteColor]];
    mDiagnosisLabel.textAlignment = NSTextAlignmentCenter;
    mDiagnosisLabel.numberOfLines=10;
    mDiagnosisLabel.lineBreakMode= NSLineBreakByTruncatingTail;
    [mDiagnosisLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:15]];
    [mDiagnosisLabel setText:@" Diagnostics"];
    [mDiagnosisLabel setTextColor:[UIColor colorWithRed:96.0/255.0 green:96.0/255.0 blue:96.0/255.0 alpha:1.0]];
    
    
    UIView *lineView5 = [[UIView alloc]initWithFrame:CGRectMake(100, 233, 1, 61) ];
    [lineView5 setBackgroundColor:[UIColor colorWithRed:213.0/255.0 green:213.0/255.0 blue:213.0/255.0 alpha:0.7]];
    [self.view addSubview:lineView5];

    
    
    
    UILabel *mTextAnswerLabel= [[UILabel alloc] initWithFrame:CGRectMake(10.0,324, 290, 40)];
    [self.view addSubview:mTextAnswerLabel];
    [mTextAnswerLabel setBackgroundColor:[UIColor whiteColor]];
    mTextAnswerLabel.textAlignment = NSTextAlignmentLeft;
    mTextAnswerLabel.numberOfLines=10;
    mTextAnswerLabel.lineBreakMode= NSLineBreakByTruncatingTail;
    [mTextAnswerLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:16]];
    [mTextAnswerLabel setText:@"  Simulate mode"];
    [mTextAnswerLabel setTextColor:[UIColor colorWithRed:96.0/255.0 green:96.0/255.0 blue:96.0/255.0 alpha:1.0]];
    
    
    UISwitch *mySwitch = [[UISwitch alloc] initWithFrame:CGRectMake(240, 328, 0, 0)];
    [mySwitch addTarget:self action:@selector(onSimulateSwitch:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:mySwitch];
    
//    PlistDownloder * downloder = [[PlistDownloder alloc] init];
//    
//    
//    
//   id  dict =  [downloder returnDictonarywithUrl:[NSURL URLWithString:@"http://54.251.104.13/Demo/SimulationPlist.plist"]];
//    
//    if (dict != nil)
//    {   NSString* string = [dict objectForKey:@"IsSimulation"];
//        
//        if ([string  isEqualToString:@"1"])
//        {
//            mySwitch.enabled = true;
//            [mTextAnswerLabel setTextColor:[UIColor colorWithRed:96.0/255.0 green:96.0/255.0 blue:96.0/255.0 alpha:1.0]];
//            
//        }
//        else{
//            mySwitch.enabled = false;
//            [mySwitch setOn:NO];
//            [mTextAnswerLabel setTextColor:[UIColor lightGrayColor]];
//        }
//    }
//    else
//    {
//        mySwitch.enabled = false;
//        [mySwitch setOn:NO];
//        [mTextAnswerLabel setTextColor:[UIColor lightGrayColor]];
//    }
    
    
    NSUserDefaults* defaults=[NSUserDefaults standardUserDefaults];
    
    
    if([defaults boolForKey:@"isSimulateMode"])
    {
        [mySwitch setOn:YES animated:YES];
    }
    
    
    
    
    pullNewProfilePics = [UIButton buttonWithType:UIButtonTypeCustom];
    [pullNewProfilePics addTarget:self action:@selector(onrefreshPics:) forControlEvents:UIControlEventTouchUpInside];
    pullNewProfilePics.frame = CGRectMake(10.0,384, 290, 40); //(10.0, 116.0, 258.0, 43.0);
    [self.view addSubview:pullNewProfilePics];
    [pullNewProfilePics setTitle:@"Refresh" forState:UIControlStateNormal];
    [pullNewProfilePics setTitleColor:[UIColor colorWithRed:0.0 green:174.0/255.0 blue:239.0/255.0 alpha:1.0] forState:UIControlStateNormal];
    [pullNewProfilePics setBackgroundColor:[UIColor whiteColor]];
}



- (void)CollaborationSwitch:(id)sender
{
    if([sender isOn])
    {
     }
    else
    {
    }
}

- (void)querySwitch:(id)sender
{
    
    
    
    if([sender isOn])
    {
//        // Execute any code when the switch is ON
////        //nslog(@"Switch is ON");
//        
//        if ([topicsStarted isEqualToString:@"No"])
//        {
//            [sender setOn:NO animated:YES];
//            UIAlertView *_alert = [[UIAlertView alloc] initWithTitle:@"Alert" message:@"please start a topic to turn on Demo mode" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
//            [_alert show];
//            
//        }
//        else
//        {
//            demoQueryStatus=YES;
//            [[self delegate] onQueryEnbled];
//        }
//        
        
        
    }
    else
    {
//        // Execute any code when the switch is OFF
////        //nslog(@"Switch is OFF");
//        
//        if (![topicsStarted isEqualToString:@"No"])
//        {
//            [sender setOn:YES animated:YES];
//        }
//        else
//        {
//             demoQueryStatus=NO;
//        }
        
       
    }
}

- (void)questionSwitch:(id)sender
{
//    if([sender isOn])
//    {
//        // Execute any code when the switch is ON
//        //        //nslog(@"Switch is ON");
//        
//        NSUserDefaults* defaults= [NSUserDefaults standardUserDefaults];
//        if ([defaults boolForKey:@"QuestionSent"]==NO)
//        {
//            [sender setOn:NO animated:YES];
//            UIAlertView *_alert = [[UIAlertView alloc] initWithTitle:@"Alert" message:@"please send a question before you turn on demo mode" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
//            [_alert show];
//            
//        }
//        else
//        {
//            demoQuestion=YES;
//            [[self delegate] onQuestionEnabled];
//        }
//        
//        
//        
//    }
//    else
//    {
//        // Execute any code when the switch is OFF
//        //        //nslog(@"Switch is OFF");
//        demoQuestion=NO;
//    }
}



- (void) onSimulateSwitch:(id)sender
{
    NSUserDefaults* defaults=[NSUserDefaults standardUserDefaults];
    
    
    if([sender isOn])
    {
      [defaults setBool:YES forKey:@"isSimulateMode"];
    }
    else
    {
        [defaults setBool:NO forKey:@"isSimulateMode"];
    }

}

/*- this function is called to setup topics -*/
-(void) onSetupTopicsButton :(id)sender
{

//    if ([topicsStarted isEqualToString:@"No"])
//    {
//        [[self popOverController] dismissPopoverAnimated:YES];
//        [self setPopOverController:nil];
//        
//        //
//        
//    }
//    else
//    {
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Alert" message:@"Please stop the current subtopic" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
//        [alert show];
//    }
//    
    
    UIButton* button = (UIButton*)sender;
    CABasicAnimation *anim = [CABasicAnimation animationWithKeyPath:@"transform"];
    anim.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    anim.duration = 0.125;
    anim.repeatCount = 1;
    anim.autoreverses = YES;
    anim.removedOnCompletion = YES;
    anim.toValue = [NSValue valueWithCATransform3D:CATransform3DMakeScale(1.2, 1.2, 1.0)];
    [button.layer addAnimation:anim forKey:nil];
    
    [[self delegate] Settings_setupLessonPlanClicked];

     [[self popOverController] dismissPopoverAnimated:YES];
  
    
}


- (void) onManualResignClicked:(id)sender
{
    [[self popOverController] dismissPopoverAnimated:YES];
//    [[self delegate] ManualResignSeats];
}
- (void) onRandomReasignClicked:(id)sender
{
    [[self popOverController] dismissPopoverAnimated:YES];
    [[self delegate] Settings_RandomReasignSeats];
}
- (void) onAlphabeticalReassignClicked:(id)sender
{
    [[self popOverController] dismissPopoverAnimated:YES];
    [[self delegate] Settings_AlphabeticalReassignseats];
}
- (void) onTakePhoto:(id)sender
{
//    [[self delegate] takePhotoDelegate];
}


/*- this function is called to get all the topics -*/
- (void) didGetAllNodes:(id)details orError:(NSError*)error
{
    
    //nslog(@"%@",details);
//    
//    id dict = [[details objectForKey:kSunstone] objectForKey:kSSAction];
//    //nslog(@"%@",dict);
//    [[SSTeacherDataSource sharedDataSource]addToTopicsDict:[[details objectForKey:kSunstone]objectForKey:kSSAction] forKey:@"Topics"];
//    
//    
//    SSTagTopicsViewController *tagTopicsView = [[SSTagTopicsViewController alloc]init];
//    [tagTopicsView.view setFrame:CGRectMake(0, 0, 1024, 768)];
//    [[self delegate] addChildViewController:tagTopicsView];
//    [[[self delegate]view] addSubview:tagTopicsView.view];
//    [tagTopicsView didMoveToParentViewController:[self delegate ]];
    
   

    
}


- (void) setDelegate:(id) del {
	_delegate = del;
}

- (id) delegate
{
	
	return _delegate;
}

- (void) setPopOverController:(id) pop
{
	_popOverController = pop;
}

- (id) popOverController {
	
	return _popOverController;
}

- (IBAction) onAddStudentButtonAction:(id) sender {
	
}

- (IBAction) onGlobalSettingsButtonAction:(id) sender {
	
}


/*- this function is called when SignOutButton is pressed -*/
- (IBAction) onLogoutButtonAction :(id) sender {
	
	[[self popOverController] dismissPopoverAnimated:YES];
	
	
	
	[[self delegate] Settings_performLogout];
}

/*- Deepak this function is called when SetUpSeatingButton is pressed -*/
- (IBAction) onSetUpSeatingButtonAction :(id) sender {
	
    UIButton* button = (UIButton*)sender;
    CABasicAnimation *anim = [CABasicAnimation animationWithKeyPath:@"transform"];
    anim.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    anim.duration = 0.125;
    anim.repeatCount = 1;
    anim.autoreverses = YES;
    anim.removedOnCompletion = YES;
    anim.toValue = [NSValue valueWithCATransform3D:CATransform3DMakeScale(1.2, 1.2, 1.0)];
    [button.layer addAnimation:anim forKey:nil];
    
    [[self delegate] Settings_setupClassRoomClicked];
    
    
    
    
//    NSArray* roomDetails = [[[[[[SSTeacherDataSource sharedDataSource]getAllRoomDetails] objectForKey:@"AllRoomDetails"] objectForKey:kSunstone]  objectForKey:kSSAction] objectForKey:@"Rooms"] ;
//    
//    if (roomDetails!=nil)
//    {
//        //nslog(@"%@",[[[[[[SSTeacherDataSource sharedDataSource]getAllRoomDetails] objectForKey:@"AllRoomDetails"] objectForKey:kSunstone]  objectForKey:kSSAction] objectForKey:@"Rooms"]);
//        SSTeacherSetUpSeatingViewcontroller* viewController = [[SSTeacherSetUpSeatingViewcontroller alloc] init];
//        [viewController updatePopOverWithDetails:roomDetails];
//        [self.navigationController pushViewController:viewController animated:YES];
//        
//    }
}
- (void) onTestPingButton:(id)sender
{
    [[self popOverController] dismissPopoverAnimated:YES];
    [[self delegate] Settings_testPingButtonClicked];
}

- (void) onXmppButtonClicked:(id)Sender
{
    [[self popOverController] dismissPopoverAnimated:YES];
    [[self delegate] Settings_XmppReconnectButtonClicked];
}

- (void) onrefreshPics:(id) sender
{
    
    
    CABasicAnimation *anim = [CABasicAnimation animationWithKeyPath:@"transform"];
    anim.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    anim.duration = 0.125;
    anim.repeatCount = 1;
    anim.autoreverses = YES;
    anim.removedOnCompletion = YES;
    anim.toValue = [NSValue valueWithCATransform3D:CATransform3DMakeScale(1.2, 1.2, 1.0)];
    [pullNewProfilePics.layer addAnimation:anim forKey:nil];
    
    
//    NSString* globallyUniqueString = kProFIlePics;
//    NSString* tempDirectoryPath = [NSTemporaryDirectory() stringByAppendingPathComponent:globallyUniqueString];
//    [[NSFileManager defaultManager] removeItemAtPath:tempDirectoryPath error:nil];
//    
//    
//    
//   NSString* pngPath = [NSTemporaryDirectory() stringByAppendingPathComponent:kProFIlePics];
//    BOOL isDir;
//    
//    // Check if the directory already exists
//   BOOL exists = [[NSFileManager defaultManager] fileExistsAtPath:pngPath isDirectory:&isDir];
//    
//    if (!exists)
//    {
//        // Directory does not exist so create it
//        [[NSFileManager defaultManager] createDirectoryAtPath:pngPath withIntermediateDirectories:YES attributes:nil error:nil];
//    }
    

    
    
   [[self popOverController] dismissPopoverAnimated:YES];
    
    
   [[self delegate] Settings_refreshPicsClicked];
}

- (void) onCreateScribbleQuestion:(id) sender
{
//    [[self delegate]createScribbleQuestion];
}

- (void) onCreateMRQQuestion:(id)sender
{
//     [[self delegate]createMRQQuestion];
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    
    [super viewDidLoad];
	
}

// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations.
    return ((interfaceOrientation == UIInterfaceOrientationLandscapeRight) || (interfaceOrientation == UIInterfaceOrientationLandscapeLeft));
}


- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}



@end
