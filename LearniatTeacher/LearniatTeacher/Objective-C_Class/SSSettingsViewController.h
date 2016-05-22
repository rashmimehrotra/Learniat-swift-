//
//  SSSettingsViewController.h
//  Learniat Teacher
//
//  Copyright (c) 2015 Mindshift Applications and Solutions Private Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface SSSettingsViewController : UIViewController
{
    
	id					 _delegate;
	
	id			_popOverController;
}
@property(nonatomic, strong)UIButton *setupTopicsButton;
@property(nonatomic, strong)UIButton *logoutButton;
@property(nonatomic, strong)UIButton *testPingButton;
@property(nonatomic, strong)UIButton *XmppReconnect;
@property(nonatomic, strong)UIButton *takePhoto;
@property(nonatomic, strong)UIButton* manualResignButton;
@property(nonatomic, strong)UIButton* alphabeticalReassignButton;
@property(nonatomic, strong)UIButton* randomReassignButton;
@property(nonatomic, strong)UIButton* pullNewProfilePics;



@property(nonatomic, strong)UIButton *setupSitingButton;

- (void) setDelegate:(id) del;
- (id) delegate;

- (void) setPopOverController:(id) pop;
- (id) popOverController;
- (void) didGetAllNodes:(id)details orError:(NSError*)error;
- (float) scheduleScrrenTeacherImagePressed;
- (void) ClassViewTopicsButtonSettingsButtonPressed;
- (void) onTestPingButton:(id)sender;
- (void) onXmppButtonClicked:(id)Sender;
- (void) onManualResignClicked:(id)sender;
- (void) onRandomReasignClicked:(id)sender;
- (void) onAlphabeticalReassignClicked:(id)sender;
- (void) onTakePhoto:(id)sender;
- (void) onSimulateSwitch:(id)sender;
- (void) onrefreshPics:(id) sender;
- (void) onCreateScribbleQuestion:(id) sender;
- (void) onCreateMRQQuestion:(id)sender;



@end

@protocol SSSettingsViewControllerDelegate <NSObject>

@optional - (void) Settings_setupLessonPlanClicked;
@optional- (void) Settings_setupClassRoomClicked;
@optional- (void) Settings_testPingButtonClicked;
@optional- (void) Settings_XmppReconnectButtonClicked;
@optional- (void) Settings_onQueryEnbled;
@optional- (void) Settings_onQuestionEnabled;
@optional- (void) Settings_ManualResignSeats;
@optional- (void) Settings_RandomReasignSeats;
@optional- (void) Settings_AlphabeticalReassignseats;
@optional- (void) Settings_takePhotoDelegate;
@optional- (void) Settings_refreshPicsClicked;
@optional- (void) Settings_createScribbleQuestion;
@optional- (void) Settings_createMRQQuestion;
@optional- (void) Settings_performLogout;


@end