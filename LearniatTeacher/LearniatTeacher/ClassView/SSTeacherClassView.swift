

//
//  SSTeacherClassView.swift
//  Learniat Teacher
//
//  Created by Deepak MK on 23/03/16.
//  Copyright © 2016 Mindshift. All rights reserved.
//


/*
    When teacher begin calss we will navigate to SSTeacherClassView controller.
 
 
 This is the main view controller for learniat teacher app
 
	1. It contain queryView, submissionView and class view tabs
	2. ClassView  : It contains all students desk where each student response is 	captured. Response like query or any answers form student or student current 	state Etc
    3. Create Room in Xmpp for each class and in student side join room automatically with sessionId.
    4.
 
*/

enum SessionState:Int
{
    case Live           = 1
    case Scheduled      = 4
    case Ended          = 5
    case Cancelled      = 6
    case Opened         = 2
}


enum UserStateInt:Int
{
    case Live           =  1
    case BackGround     =  11
    case Free           =  7
    case SignedOut      =  8
    case Occupied       =  10
    case Preallocated   =  9
    
}


let kStudentLive             = 1
let kStudentSignedOut        = 8
let kStudentLivebackground   = 11
let kStudentLeaveSession     = 7
let kStudentBatteryState5    = 205
let kStudentBatteryState10   = 210
let kStudentPreAllocated     = 9
let kStudentOccupied         = 10


let kClassView              = "classView"
let kSubmissionView         = "Submission"
let kQueryView              = "Query"
let kPollView               = "Polling"

let EndClassTimmerMinutes   = 6

import Foundation
class SSTeacherClassView: UIViewController,UIPopoverControllerDelegate,MainTopicsViewDelegate,SubTopicsViewDelegate,SSTeacherDataSourceDelegate,QuestionsViewDelegate,SSTeacherMessagehandlerDelegate,LiveQuestionViewDelegate,StundentDeskViewDelegate,SSTeacherSubmissionViewDelegate,SSTeacherQueryViewDelegate,StudentSubjectivePopoverDelegate,SSSettingsViewControllerDelegate,SSTeacherSchedulePopoverControllerDelegate,SSTeacherPollViewDelegate,StudentModelAnswerViewDelegate {
   
    var mTeacherImageView: CustomProgressImageView!
    
    var mTopbarImageView: UIImageView!
    
    
    var mTeacherImageButton = UIButton()
    
     var mBottombarImageView: UIImageView!
    
    var mClassName: UILabel!
    
    var mStartTimeLabel = UILabel()
    
    var mEndCounterlabel = UILabel()
    
    let dateFormatter = DateFormatter()
    
    var mStartLabelUpdater                    = Timer()
    
    var currentSessionDetails           :AnyObject!
    
    var currentSessionId               = ""
    
    var mSubTopicsNamelabel                  = UILabel()
    
    var mQuestionNamelabel                   = UILabel()
    
    var currentQuestionDetails              :AnyObject!
    
    var mainTopicsView              :  MainTopicsView!
    
    var subTopicsView               :  SubTopicsView!
    
    var questionTopicsView          :  QuestionsView!
    
    var liveQuestionView            :   LiveQuestionView!
    
    var startedSubTopicDetails:AnyObject!
    
    
    var startedMainTopicID          = ""
    
    var startedMainTopicName        = ""
        
    
    var currentCumulativeTime       :String   = ""
    
    var  mTopicButton:UIButton!
    
    var mClassView                      = UIView()
    
    var mModelAnswerButton                  : ModelAnswerButtonView!
    
    var mSubmissionView                 = SSTeacherSubmissionView()
    
    var mQueryView                      : SSTeacherQueryView!
    
     var mPollingView                   : SSTeacherPollView!
    
    
    var mModelAnswerView                    : StudentModelAnswerView!
    
    var StudentsDetailsArray                = NSMutableArray()
    
    var mClassViewButton                    = UIButton()
    
    var mQuestionViewButton                 = UIButton()
    
    var mQueryViewButton                    = UIButton()
    
     var mPollViewButton                    = UIButton()
    
    var tabPlaceHolderImage                 = UIImageView()
    
    var currentStudentsDict                 = NSMutableDictionary()
    
    var currentScreen                       = kClassView
    
    var mActivityIndicatore :UIActivityIndicatorView = UIActivityIndicatorView()
    
    var submissionNotificationLabel             = UILabel()
    
    
    var queryNotificationLabel                  = UILabel()
    
    var PollNotificationLabel                  = UILabel()
    
    var newSubmissionRecieved               = NSMutableArray()
    
    var newQueryRecieved                    = NSMutableArray()
    
    var newPollRecieved                     = NSMutableArray()
    
     var seatsIdArray                       = [String]()
    
    var mRemainingTimeProgressBar           = UIProgressView()
    
    
    var mShowTopicsView                         = UIView()
    
    var demoQuestionAnswerView              = StudentAnswerDemo()
    
    
    var demoQueryView                       = StudentQueryDemo()
    
    var pollingDemoView                     = StudentPollingView()
    
    
    var mScheduleDetailView          : ScheduleDetailView!
    var mTeacherLessonPlanView      : SSTeacherLessonPlanView!
    
    var plistLoader = PlistDownloder()
    
    var schedulePopOverController : SSTeacherSchedulePopoverController!
    
   var checkingClassEndTime                 = false
    
    var sessionEndingAlertView:UIAlertController!
    
    var mCurrentSessionModel :CurrentSessionViewModel!
      var mExtTimelabel: UILabel = UILabel();
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.view.backgroundColor = whiteBackgroundColor
        
        
        self.view.setNeedsLayout()
        self.view.layoutIfNeeded()
        
  
        NotificationCenter.default.addObserver(self, selector: #selector(willResignActive), name: .UIApplicationWillResignActive, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(appBecameActive), name: .UIApplicationDidBecomeActive, object: nil)
        
        
        
        demoQuestionAnswerView.setdelegate(self)
        
        demoQueryView.setdelegate(self)
        
        
        pollingDemoView.setdelegate(self)
        
        SSTeacherMessageHandler.sharedMessageHandler.setdelegate(self)
        
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        mTopbarImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 70))
        mTopbarImageView.backgroundColor = topbarColor
        self.view.addSubview(mTopbarImageView)
        mTopbarImageView.isUserInteractionEnabled = true
        
        
        mBottombarImageView = UIImageView(frame: CGRect(x: 0, y: self.view.frame.size.height - 60, width: self.view.frame.size.width, height: 60))
        mBottombarImageView.backgroundColor = topbarColor
        self.view.addSubview(mBottombarImageView)
        mBottombarImageView.isUserInteractionEnabled = true
        
        mRemainingTimeProgressBar.isUserInteractionEnabled = false;
        mBottombarImageView.addSubview(mRemainingTimeProgressBar)
        mRemainingTimeProgressBar.frame  = CGRect(x: 0, y: mBottombarImageView.frame.size.height - 4 , width: mBottombarImageView.frame.size.width, height: 1)
        mRemainingTimeProgressBar.progressTintColor = standard_Button;
        let transform: CGAffineTransform = CGAffineTransform(scaleX: 1.0, y: 2);
        mRemainingTimeProgressBar.transform = transform;
        
        
        
        
        mBottombarImageView.addSubview(tabPlaceHolderImage)
        tabPlaceHolderImage.backgroundColor = UIColor(red: 39/255.0, green:68/255.0, blue:98/255.0, alpha: 1)
        tabPlaceHolderImage.layer.cornerRadius = 5
        tabPlaceHolderImage.layer.masksToBounds = true
        
        
        mQuestionViewButton.frame  = CGRect(x: mBottombarImageView.frame.size.width/2 - 150  , y: 0, width: 150, height: mBottombarImageView.frame.size.height)
        mBottombarImageView.addSubview(mQuestionViewButton)
        mQuestionViewButton.addTarget(self, action: #selector(SSTeacherClassView.onQuestionsView), for: UIControlEvents.touchUpInside)
        mQuestionViewButton.backgroundColor = UIColor.clear
        mQuestionViewButton.setTitleColor(UIColor.white, for: UIControlState())
        mQuestionViewButton.setTitle("Submission", for: UIControlState())
        mQuestionViewButton.titleLabel?.font = UIFont(name: helveticaMedium, size: 18)
        
        submissionNotificationLabel.frame = CGRect(x: mQuestionViewButton.frame.origin.x + mQuestionViewButton.frame.size.width - 25 , y: mQuestionViewButton.frame.origin.y + 5 , width: 40, height: 30)
        submissionNotificationLabel.backgroundColor = standard_Red
        submissionNotificationLabel.textColor = UIColor.white
        mBottombarImageView.addSubview(submissionNotificationLabel)
        submissionNotificationLabel.layer.cornerRadius = 11.0;
        submissionNotificationLabel.layer.masksToBounds = true;
        submissionNotificationLabel.text = "0"
        submissionNotificationLabel.font = UIFont(name: helveticaBold, size: 20)
        submissionNotificationLabel.textAlignment = .center
        submissionNotificationLabel.isHidden = true
        
        
        
        
        mClassViewButton.frame  = CGRect(x: mQuestionViewButton.frame.origin.x - (mQuestionViewButton.frame.size.width + 10)  , y: 0, width: mQuestionViewButton.frame.size.width, height: mQuestionViewButton.frame.size.height)
        mBottombarImageView.addSubview(mClassViewButton)
        mClassViewButton.addTarget(self, action: #selector(SSTeacherClassView.onClassView), for: UIControlEvents.touchUpInside)
        mClassViewButton.backgroundColor = UIColor.clear
        mClassViewButton.setTitleColor(UIColor.white, for: UIControlState())
        mClassViewButton.setTitle("Class view", for: UIControlState())
        mClassViewButton.titleLabel?.font = UIFont(name: helveticaMedium, size: 18)
        tabPlaceHolderImage.frame = CGRect(x: mClassViewButton.frame.origin.x  , y: 10, width: mQuestionViewButton.frame.size.width, height: mQuestionViewButton.frame.size.height - 20 )
       
        mQueryViewButton.frame  = CGRect(x: mQuestionViewButton.frame.origin.x + (mQuestionViewButton.frame.size.width + 10)  , y: 0, width: mQuestionViewButton.frame.size.width, height: mQuestionViewButton.frame.size.height)
        mBottombarImageView.addSubview(mQueryViewButton)
        mQueryViewButton.addTarget(self, action: #selector(SSTeacherClassView.onQueryView), for: UIControlEvents.touchUpInside)
        mQueryViewButton.backgroundColor = UIColor.clear
        mQueryViewButton.setTitleColor(UIColor.white, for: UIControlState())
        mQueryViewButton.setTitle("Query", for: UIControlState())
        mQueryViewButton.titleLabel?.font = UIFont(name: helveticaMedium, size: 18)
        
        
        
        
        
        mEndCounterlabel.frame = CGRect(x: mBottombarImageView.frame.width - 100, y: 0 , width: 100, height: mQuestionViewButton.frame.size.height)
        mEndCounterlabel.font = UIFont(name:helveticaRegular, size: 22)
        mBottombarImageView.addSubview(mEndCounterlabel)
        mEndCounterlabel.textColor = standard_Red
        mEndCounterlabel.isHidden = true
        mEndCounterlabel.font = UIFont(name: helveticaBold, size: 18)
        
        
        
        
        
        
        
        mPollViewButton.frame  = CGRect(x: mQueryViewButton.frame.origin.x + (mQueryViewButton.frame.size.width + 10)  , y: 0, width: mQuestionViewButton.frame.size.width, height: mQuestionViewButton.frame.size.height)
        mBottombarImageView.addSubview(mPollViewButton)
        mPollViewButton.addTarget(self, action: #selector(SSTeacherClassView.onPollView), for: UIControlEvents.touchUpInside)
        mPollViewButton.backgroundColor = UIColor.clear
        mPollViewButton.setTitleColor(UIColor.white, for: UIControlState())
        mPollViewButton.setTitle("Poll", for: UIControlState())
        mPollViewButton.titleLabel?.font = UIFont(name: helveticaMedium, size: 18)
        

        
        PollNotificationLabel.frame = CGRect(x: mPollViewButton.frame.origin.x + mPollViewButton.frame.size.width - 25 , y: mQuestionViewButton.frame.origin.y + 5 , width: 40, height: 30)
        PollNotificationLabel.backgroundColor = standard_Red
        PollNotificationLabel.textColor = UIColor.white
        mBottombarImageView.addSubview(PollNotificationLabel)
        PollNotificationLabel.layer.cornerRadius = 11.0;
        PollNotificationLabel.layer.masksToBounds = true;
        PollNotificationLabel.text = "0"
        PollNotificationLabel.font = UIFont(name: helveticaBold, size: 20)
        PollNotificationLabel.textAlignment = .center
        PollNotificationLabel.isHidden = true
        

        
        
        
        queryNotificationLabel.frame = CGRect(x: mQueryViewButton.frame.origin.x + mQueryViewButton.frame.size.width - 25 , y: mQueryViewButton.frame.origin.y + 5 , width: 40, height: 30)
        queryNotificationLabel.backgroundColor = standard_Red
        queryNotificationLabel.textColor = UIColor.white
        mBottombarImageView.addSubview(queryNotificationLabel)
        queryNotificationLabel.layer.cornerRadius = 11.0;
        queryNotificationLabel.layer.masksToBounds = true;
        queryNotificationLabel.text = "0"
        queryNotificationLabel.font = UIFont(name: helveticaBold, size: 20)
        queryNotificationLabel.textAlignment = .center
        queryNotificationLabel.isHidden = true
        
        
        
        
        
        mClassView.frame = CGRect(x: 0, y: mTopbarImageView.frame.origin.y + mTopbarImageView.frame.size.height , width: self.view.frame.size.width , height: self.view.frame.size.height - (mTopbarImageView.frame.origin.y + mTopbarImageView.frame.size.height + mBottombarImageView.frame.size.height ))
        self.view.addSubview(mClassView)
        mClassView.backgroundColor = whiteBackgroundColor
        mClassView.isHidden = true
        mClassView.isUserInteractionEnabled = true
        
        
        
        
        mSubmissionView.frame = CGRect(x: 0, y: mTopbarImageView.frame.origin.y + mTopbarImageView.frame.size.height , width: self.view.frame.size.width , height: self.view.frame.size.height - (mTopbarImageView.frame.origin.y + mTopbarImageView.frame.size.height + mBottombarImageView.frame.size.height ))
        self.view.addSubview(mSubmissionView)
        mSubmissionView.backgroundColor = whiteBackgroundColor
        mSubmissionView.isHidden = true
        mSubmissionView.isUserInteractionEnabled = true
        mSubmissionView.setdelegate(self)
        mSubmissionView.loadViewWithDetails()
        
        
        
        
        
        
        
        
        mQueryView = SSTeacherQueryView(frame:CGRect(x: 0, y: mTopbarImageView.frame.origin.y + mTopbarImageView.frame.size.height , width: self.view.frame.size.width , height: self.view.frame.size.height - (mTopbarImageView.frame.origin.y + mTopbarImageView.frame.size.height + mBottombarImageView.frame.size.height )))
        self.view.addSubview(mQueryView)
        mQueryView.backgroundColor = whiteBackgroundColor
        mQueryView.isHidden = true
        mQueryView.isUserInteractionEnabled = true
        mQueryView.setdelegate(self)
        
        
        mPollingView = SSTeacherPollView(frame:CGRect(x: 0, y: mTopbarImageView.frame.origin.y + mTopbarImageView.frame.size.height , width: self.view.frame.size.width , height: self.view.frame.size.height - (mTopbarImageView.frame.origin.y + mTopbarImageView.frame.size.height + mBottombarImageView.frame.size.height )))
        self.view.addSubview(mPollingView)
        mPollingView.backgroundColor = whiteBackgroundColor
        mPollingView.isHidden = true
        mPollingView.isUserInteractionEnabled = true
        mPollingView.setdelegate(self)

        

        
        
        
        mTeacherImageView = CustomProgressImageView(frame: CGRect(x: 15, y: 20, width: 40 ,height: 40))
        mTeacherImageView.backgroundColor = lightGrayColor
        mTopbarImageView.addSubview(mTeacherImageView)
        mTeacherImageView.layer.masksToBounds = true
        mTeacherImageView.layer.cornerRadius = 2
        
        
        
        let urlString = UserDefaults.standard.object(forKey: k_INI_UserProfileImageURL) as! String
        let userID = urlString.appending("/").appending(SSTeacherDataSource.sharedDataSource.currentUserId)
        
        print("\(urlString)/\(userID)_79px.jpg")
        
        if let checkedUrl = URL(string:"\(userID)_79px.jpg")
        {
            mTeacherImageView.contentMode = .scaleAspectFit
            mTeacherImageView.downloadImage(checkedUrl, withFolderType: folderType.proFilePics)
        }
        
        
        mTeacherImageButton.frame = CGRect(x: 0, y: 0, width: 40 , height: mTopbarImageView.frame.size.height)
        mTopbarImageView.addSubview(mTeacherImageButton)
        mTeacherImageButton.addTarget(self, action: #selector(SSTeacherClassView.onTeacherImage), for: UIControlEvents.touchUpInside)

        
        
      let  mSchedulePopoverButton = UIButton(frame: CGRect(x: mTeacherImageView.frame.origin.x + mTeacherImageView.frame.size.width + 10,  y: mTeacherImageView.frame.origin.y, width: 250 , height: 50))
        mTopbarImageView.addSubview(mSchedulePopoverButton)
        mSchedulePopoverButton.addTarget(self, action: #selector(SSTeacherClassView.onScheduleScreenPopupPressed(_:)), for: UIControlEvents.touchUpInside)
        mSchedulePopoverButton.backgroundColor = standard_Button
        mSchedulePopoverButton.layer.cornerRadius = 2
        mSchedulePopoverButton.layer.masksToBounds = true
        
        mClassName = UILabel(frame: CGRect(x: mSchedulePopoverButton.frame.origin.x + 10, y: mSchedulePopoverButton.frame.origin.y + 5 , width: 230, height: 20))
        
        
        mClassName.font = UIFont(name:helveticaBold, size: 14)
        mTopbarImageView.addSubview(mClassName)
        mClassName.textColor = UIColor.white
       
        mStartTimeLabel.frame = CGRect(x: mSchedulePopoverButton.frame.origin.x + 10, y: mClassName.frame.origin.y + mClassName.frame.size.height , width: 230, height: 20)
        mStartTimeLabel.font = UIFont(name:helveticaRegular, size: 12)
        mTopbarImageView.addSubview(mStartTimeLabel)
        mStartTimeLabel.textColor = UIColor.white
        
        
        
         mTopicButton = UIButton(frame: CGRect(x: mTopbarImageView.frame.size.width - (mSchedulePopoverButton.frame.size.width + 10 ),  y: mSchedulePopoverButton.frame.origin.y, width: mSchedulePopoverButton.frame.size.width , height: mSchedulePopoverButton.frame.size.height))
        mTopbarImageView.addSubview(mTopicButton)
        mTopicButton.addTarget(self, action: #selector(SSTeacherClassView.onTopicsButton(_:)), for: UIControlEvents.touchUpInside)
        mTopicButton.backgroundColor = standard_Button
        mTopicButton.layer.cornerRadius = 2
        mTopicButton.layer.masksToBounds = true
        
        
        mModelAnswerButton = ModelAnswerButtonView(frame:CGRect(x: mTopicButton.frame.origin.x - (mTopicButton.frame.size.width + 10 ) , y: mTopicButton.frame.origin.y, width: mTopicButton.frame.size.width, height: mTopicButton.frame.size.height))
        mTopbarImageView.addSubview(mModelAnswerButton)
        mModelAnswerButton.backgroundColor = standard_Green
         mModelAnswerButton.addTarget(self, action: #selector(SSTeacherClassView.onModelAnswerButton), for: UIControlEvents.touchUpInside)
        mModelAnswerButton.isHidden = true
        
        
        
        
        mShowTopicsView.frame = CGRect(x: self.view.frame.size.width - 610, y: mTopbarImageView.frame.origin.y + mTopbarImageView.frame.size.height , width: 600, height: 680)
        
        mShowTopicsView.backgroundColor = UIColor.white
        mShowTopicsView.layer.shadowColor = UIColor.black.cgColor
        mShowTopicsView.layer.shadowOpacity = 0.3
        mShowTopicsView.layer.shadowOffset = CGSize.zero
        mShowTopicsView.layer.shadowRadius = 10
        mShowTopicsView.isHidden = true
        self.view.addSubview(mShowTopicsView)
        
        
        
        mModelAnswerView = StudentModelAnswerView(frame:CGRect(x: mModelAnswerButton.frame.origin.x - 30 , y: mTopbarImageView.frame.origin.y + mTopbarImageView.frame.size.height , width: mModelAnswerButton.frame.size.width + 60, height: 60))
        self.view.addSubview(mModelAnswerView)
        mModelAnswerView.backgroundColor = UIColor.white
        mModelAnswerView.layer.shadowColor = UIColor.black.cgColor
        mModelAnswerView.layer.shadowOpacity = 0.3
        mModelAnswerView.layer.shadowOffset = CGSize.zero
        mModelAnswerView.layer.shadowRadius = 10
        mModelAnswerView.setdelegate(self)
        mModelAnswerView.isHidden = true
        
        
        mSubTopicsNamelabel = UILabel(frame: CGRect(x: 10, y: 5 , width: mTopicButton.frame.size.width - 20, height: 20))
        mSubTopicsNamelabel.font = UIFont(name:helveticaBold, size: 14)
        mTopicButton.addSubview(mSubTopicsNamelabel)
        mSubTopicsNamelabel.textColor = UIColor.white
        mSubTopicsNamelabel.text = "No topic selected"
        mSubTopicsNamelabel.textAlignment = .right
        
        
        
        mQuestionNamelabel = UILabel(frame: CGRect(x: mSubTopicsNamelabel.frame.origin.x , y: mSubTopicsNamelabel.frame.origin.y + mSubTopicsNamelabel.frame.size.height , width: mSubTopicsNamelabel.frame.size.width, height: 20))
        mQuestionNamelabel.font = UIFont(name:helveticaRegular, size: 12)
        mTopicButton.addSubview(mQuestionNamelabel)
        mQuestionNamelabel.textColor = UIColor.white
        mQuestionNamelabel.text = "No active question"
        mQuestionNamelabel.textAlignment = .right
        
        
      
        
        mStartLabelUpdater.invalidate()
        mStartLabelUpdater = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(SSTeacherClassView.updateStartLabelTime), userInfo: nil, repeats: true)
        
        
        mActivityIndicatore = UIActivityIndicatorView(activityIndicatorStyle: .gray)
        mActivityIndicatore.frame = CGRect(x: (self.view.frame.size.width - 60)/2, y: (self.view.frame.size.height - 60)/2, width: 60, height: 60)
        self.view.addSubview(mActivityIndicatore)
        
        addAllDetailsOfSession()
        
        downloladDemoMasterFileDetails()
    }

    
    deinit {
        print("deinit called")
        NotificationCenter.default.removeObserver(self)
    }
    
 
  
    
    func setSessionDetails(_ details:AnyObject) {
        currentSessionDetails = details
        mCurrentSessionModel =  CurrentSessionViewModel(sessionDetails: currentSessionDetails)
    }
    
    
    func addAllDetailsOfSession() {
        
        currentSessionId = mCurrentSessionModel._sessionModel.SessionID
        SSTeacherDataSource.sharedDataSource.currentLiveSessionId = currentSessionId
       
        mClassName.text = mCurrentSessionModel.getClassName()
        mStartTimeLabel.text = mCurrentSessionModel.getStartTimeLabelText()
        mRemainingTimeProgressBar.progress = Float(mCurrentSessionModel.getClassProgressTime())
            
        
        
        mainTopicsView  = MainTopicsView(frame: CGRect(x: 0,y: 0, width: 600   ,height: 44))
        mainTopicsView.setSessionDetails(currentSessionDetails)
        mainTopicsView.setdelegate(self)
        mShowTopicsView.addSubview(mainTopicsView)
        mainTopicsView.isHidden = true
        
        subTopicsView = SubTopicsView(frame:CGRect(x: 0,y: 0, width: 600   ,height: 44))
        subTopicsView.setSessionDetails(currentSessionDetails)
        subTopicsView.setdelegate(self)
        mShowTopicsView.addSubview(subTopicsView)
        mShowTopicsView.isHidden = true
        
        questionTopicsView = QuestionsView(frame:CGRect(x: 0,y: 0, width: 600   ,height: 44))
        questionTopicsView.setSessionDetails(currentSessionDetails)
        questionTopicsView.setdelegate(self)
        mShowTopicsView.addSubview(questionTopicsView)
        questionTopicsView.isHidden = true
        
        liveQuestionView = LiveQuestionView(frame:CGRect(x: 0,y: 0, width: 450   ,height: 350))
        liveQuestionView.setSessionDetails(currentSessionDetails)
        liveQuestionView.setdelegate(self)
        mShowTopicsView.addSubview(liveQuestionView)
        liveQuestionView.isHidden = true
        
        if mCurrentSessionModel._sessionModel.RoomID.isEmpty == false {
            SSTeacherDataSource.sharedDataSource.getGridDesignDetails(mCurrentSessionModel._sessionModel.RoomID, WithDelegate: self)
            mActivityIndicatore.startAnimating()
            mActivityIndicatore.isHidden = false
        }
        SSTeacherMessageHandler.sharedMessageHandler.createRoomWithRoomName("question_\(currentSessionId)", withHistory: "0")
    }
    
    func willResignActive(_ notification: Notification) {
        mStartLabelUpdater.invalidate()
    }
    
    func appBecameActive(_ notification: Notification) {
       updateStartLabelTime()
    }
    
    
    func onScheduleScreenPopupPressed(_ sender:UIButton) {
        schedulePopOverController = SSTeacherSchedulePopoverController()
        schedulePopOverController.setdelegate(self)
        
        let height = self.view.frame.size.height - (mTopbarImageView.frame.size.height + 20 )
        schedulePopOverController.setdelegate(self)
        schedulePopOverController.setCurrentScreenSize(CGSize(width: 600,height: height))
        schedulePopOverController.preferredContentSize = CGSize(width: 600,height: height)
        
         SSTeacherDataSource.sharedDataSource.mPopOverController = UIPopoverController(contentViewController: schedulePopOverController)
        schedulePopOverController.setPopover(SSTeacherDataSource.sharedDataSource.mPopOverController)
        SSTeacherDataSource.sharedDataSource.mPopOverController.contentSize = CGSize(width: 600,height: height);
        SSTeacherDataSource.sharedDataSource.mPopOverController.delegate = self;
        
        SSTeacherDataSource.sharedDataSource.mPopOverController.present(from: CGRect(
            x:sender.frame.origin.x + sender.frame.size.width / 2,
            y:sender.frame.origin.y + sender.frame.size.height,
            width: 1,
            height: 1), in: self.view, permittedArrowDirections: .up, animated: true)

    }
    
    
// MARK: - StartTime updating
    func updateStartLabelTime() {
        mStartTimeLabel.text =  mCurrentSessionModel.getStartTimeLabelText()
        mRemainingTimeProgressBar.progress = Float(mCurrentSessionModel.getClassProgressTime())
       
        let remainingMinutes = mCurrentSessionModel.getRemainClassTime()
        if remainingMinutes <= 0 {
            //TODO:- Need to validate end session functionality
            mStartLabelUpdater.invalidate()
            updateSessionStateToEnded()
        } else if remainingMinutes < (EndClassTimmerMinutes*60) {
            self.mEndCounterlabel.text = mCurrentSessionModel.getEndTimeLabelText()
            mEndCounterlabel.isHidden = false
        } else {
            checkingClassEndTime = false
            mEndCounterlabel.isHidden = true
        }
    }
    
    // MARK: - Buttons Functions
    
    func onTeacherImage()
    {
        //Topic 2
        //Pradip
        
        mTeacherLessonPlanView =  SSTeacherLessonPlanView(frame: CGRect(x: 0, y: mTopbarImageView.frame.size.height - mTopbarImageView.frame.size.height, width: self.view.frame.size.width, height: self.view.frame.size.height))
        mTeacherLessonPlanView.layer.shadowColor = UIColor.black.cgColor
        mTeacherLessonPlanView.layer.shadowOpacity = 0.3
        mTeacherLessonPlanView.layer.shadowOffset = CGSize.zero
        mTeacherLessonPlanView.layer.shadowRadius = 10
        self.view.addSubview(mTeacherLessonPlanView)
        mTeacherLessonPlanView.setdelegate(self)
        
        
        mTeacherLessonPlanView.isHidden = false
        self.view.bringSubview(toFront: mTeacherLessonPlanView)
        
        
        if (currentSessionDetails.object(forKey: "RoomId") as? String) != nil
        {
            mTeacherLessonPlanView.setCurrentSessionDetails(currentSessionDetails)
        }
        
        
        
        // Existing Code.
        
        /*
         mShowTopicsView.isHidden = true
         if SSTeacherDataSource.sharedDataSource.isSubtopicStarted == false
         {
         mSubTopicsNamelabel.text = "No topic selected"
         }
         
         let questionInfoController = SSSettingsViewController()
         questionInfoController.setDelegate(self)
         
         questionInfoController.classViewTopicsButtonSettingsButtonPressed();
         
         SSTeacherDataSource.sharedDataSource.mPopOverController = UIPopoverController(contentViewController: questionInfoController)
         
         SSTeacherDataSource.sharedDataSource.mPopOverController.contentSize = CGSize(width: 310, height: 444);
         SSTeacherDataSource.sharedDataSource.mPopOverController.delegate = self;
         questionInfoController.setPopOver(SSTeacherDataSource.sharedDataSource.mPopOverController)
         
         
         if (newSubmissionRecieved.count <= 0 && newQueryRecieved.count <= 0 && SSTeacherDataSource.sharedDataSource.isSubtopicStarted == false)
         {
         questionInfoController.setupTopicsButton.isEnabled = true;
         questionInfoController.setupTopicsButton.setTitleColor(standard_Button,for:UIControlState());
         
         questionInfoController.manualResignButton.isEnabled = true
         questionInfoController.manualResignButton.setTitleColor(standard_Button, for:UIControlState());
         
         
         
         questionInfoController.randomReassignButton.isEnabled = true
         questionInfoController.randomReassignButton.setTitleColor(standard_Button, for:UIControlState());
         
         
         questionInfoController.alphabeticalReassignButton.isEnabled = true
         questionInfoController.alphabeticalReassignButton.setTitleColor(standard_Button, for:UIControlState());
         
         questionInfoController.pullNewProfilePics.isEnabled = true
         questionInfoController.pullNewProfilePics.setTitleColor(standard_Button, for:UIControlState());
         
         
         }
         else
         {
         
         
         questionInfoController.setupTopicsButton.isEnabled = false;
         questionInfoController.setupTopicsButton.setTitleColor(lightGrayColor,for:UIControlState());
         
         
         questionInfoController.manualResignButton.isEnabled = false;
         questionInfoController.manualResignButton.setTitleColor(lightGrayColor,for:UIControlState());
         
         
         questionInfoController.randomReassignButton.isEnabled = false;
         questionInfoController.randomReassignButton.setTitleColor(lightGrayColor,for:UIControlState());
         
         questionInfoController.alphabeticalReassignButton.isEnabled = false;
         questionInfoController.alphabeticalReassignButton.setTitleColor(lightGrayColor,for:UIControlState());
         
         questionInfoController.pullNewProfilePics.isEnabled = false;
         questionInfoController.pullNewProfilePics.setTitleColor(lightGrayColor,for:UIControlState());
         
         }
         
         
         
         
         SSTeacherDataSource.sharedDataSource.mPopOverController.present(from: CGRect(
         x:mTeacherImageButton.frame.origin.x ,
         y:mTeacherImageButton.frame.origin.y + mTeacherImageButton.frame.size.height,
         width: 1,
         height: 1), in: self.view, permittedArrowDirections: .up, animated: true)
         */
    }
    
    func onClassView()
    {
         tabPlaceHolderImage.frame = CGRect(x: mClassViewButton.frame.origin.x  , y: 10, width: mQuestionViewButton.frame.size.width, height: mQuestionViewButton.frame.size.height - 20 )
        currentScreen  = kClassView
        
        mClassView.isHidden      = false
        mSubmissionView.isHidden = true
        mQueryView.isHidden      = true
         mPollingView.isHidden    = true
    }
    
    func onQuestionsView()
    {
         tabPlaceHolderImage.frame = CGRect(x: mQuestionViewButton.frame.origin.x  , y: 10, width: mQuestionViewButton.frame.size.width, height: mQuestionViewButton.frame.size.height - 20 )
        
        mClassView.isHidden      = true
        mSubmissionView.isHidden = false
        mQueryView.isHidden      = true
         mPollingView.isHidden    = true
        currentScreen  = kSubmissionView
//        mShowTopicsView.hidden = true
//        if SSTeacherDataSource.sharedDataSource.isSubtopicStarted == false
//        {
//            mSubTopicsNamelabel.text = "No topic selected"
//        }
        
        // By Ujjval
        // ==========================================
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "ChangeBrushValues"), object: nil)
        
        // ==========================================
        
        submissionNotificationLabel.isHidden = true
        
        if newSubmissionRecieved.count > 0
        {

            for index in 0 ..< newSubmissionRecieved.count
            {
                
                if let studentId = newSubmissionRecieved.object(at: index) as? String
                {
                    SSTeacherMessageHandler.sharedMessageHandler.sendHandRaiseReceivedMessageToStudentWithId(studentId)
                }
                
               
            }
            
            
            
            newSubmissionRecieved.removeAllObjects()
        }
        

    }
    
    func onQueryView()
    {
         tabPlaceHolderImage.frame = CGRect(x: mQueryViewButton.frame.origin.x  , y: 10, width: mQuestionViewButton.frame.size.width, height: mQuestionViewButton.frame.size.height - 20 )
      
//        mShowTopicsView.hidden = true
//        if SSTeacherDataSource.sharedDataSource.isSubtopicStarted == false
//        {
//            mSubTopicsNamelabel.text = "No topic selected"
//        }
        
        mClassView.isHidden      = true
        mSubmissionView.isHidden = true
        mPollingView.isHidden    = true
        mQueryView.isHidden      = false
        currentScreen  = kQueryView
        
        queryNotificationLabel.isHidden = true
        if newQueryRecieved.count > 0
        {
            SSTeacherMessageHandler.sharedMessageHandler.sendQueryRecievedMessageToRoom(currentSessionId)
            
            newQueryRecieved.removeAllObjects()
        }
        
        
    }
    
    func onPollView()
    {
        tabPlaceHolderImage.frame = CGRect(x: mPollViewButton.frame.origin.x  , y: 10, width: mQuestionViewButton.frame.size.width, height: mQuestionViewButton.frame.size.height - 20 )
        
        mClassView.isHidden      = true
        mSubmissionView.isHidden = true
        mQueryView.isHidden      = true
        mPollingView.isHidden      = false
        currentScreen  = kQueryView
        
        PollNotificationLabel.isHidden = true
        if newPollRecieved.count > 0
        {
            
            newPollRecieved.removeAllObjects()
        }
        
        
    }
    
    
    func updateSessionStateToEnded() {
        SSTeacherDataSource.sharedDataSource.changeStateOfSessionWithSessionID(sessionID: SSTeacherDataSource.sharedDataSource.currentLiveSessionId, withSessionState: "5", withSuccessHandle: { (response) in
            
            if let sessionId = response.object(forKey: kSessionId) as? String {
                SSTeacherMessageHandler.sharedMessageHandler.sendEndSessionMessageToRoom(sessionId)
                SSTeacherMessageHandler.sharedMessageHandler.destroyRoom("room_"+sessionId)
                SSTeacherMessageHandler.sharedMessageHandler.destroyRoom("question_"+sessionId)
                SSTeacherDataSource.sharedDataSource.updateSessionStateWithSessionId(sessionId, WithStatusvalue: "5", WithDelegate: self)
                self.MoveToscheduleScreen()
                SSTeacherDataSource.sharedDataSource.isQuestionSent = false
                
                SSTeacherDataSource.sharedDataSource.isSubtopicStarted = false
                SSTeacherDataSource.sharedDataSource.startedSubTopicId = ""
                SSTeacherDataSource.sharedDataSource.startedMainTopicId = ""
                SSTeacherDataSource.sharedDataSource.subTopicDetailsDictonary.removeAllObjects()
                SSTeacherDataSource.sharedDataSource.questionsDictonary.removeAllObjects()
                self.mStartLabelUpdater.invalidate()
                
            }
            
            
        }) { (error) in
            
            
            
        }
    }
    
    
    
    private func MoveToscheduleScreen() {
        UIView.animate(withDuration: 0.25, delay: 0.0, options: [], animations: {
            if SSTeacherDataSource.sharedDataSource.mPopOverController != nil {
                SSTeacherDataSource.sharedDataSource.mPopOverController.dismiss(animated: true)
            }
            if self.schedulePopOverController != nil {
                self.schedulePopOverController.onDoneButton()
            }
            if self.sessionEndingAlertView != nil {
                self.sessionEndingAlertView.dismiss(animated: true, completion: nil)
            }
        }, completion: { (finished: Bool) in
            NotificationCenter.default.removeObserver(self)
            let storyboard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let preallotController : TeacherScheduleViewController = storyboard.instantiateViewController(withIdentifier: "TeacherScheduleViewController") as! TeacherScheduleViewController
            self.present(preallotController, animated: true, completion: nil)
        })
    }
    
    
// MARK: - datasource delegate functions
    
    
    
    
    func didGetGridDesignWithDetails(_ details: AnyObject) {
        
        let subViews = mClassView.subviews.flatMap{ $0 as? StundentDeskView }
        
        for subview in subViews
        {
            if subview.isKind(of: StundentDeskView.self)
            {
               subview.removeFromSuperview()
            }
        }
        
        arrangegridWithDetails(details)
    }
    
    
    func didGetSeatAssignmentSavedWithDetails(_ details: AnyObject)
    {
        
        
        if let sessionid = currentSessionDetails.object(forKey: kSessionId) as? String
        {
            
            if let RoomName = currentSessionDetails.object(forKey: "RoomName") as? String
            {
                SSTeacherMessageHandler.sharedMessageHandler.sendSeatingChangedtoRoom(sessionid, withSeatName: "A2", withRoomName: RoomName)
            }
            else
            {
                SSTeacherMessageHandler.sharedMessageHandler.sendSeatingChangedtoRoom(sessionid, withSeatName: "A2", withRoomName: "")
            }
            
            SSTeacherDataSource.sharedDataSource.getStudentsInfoWithSessionId(currentSessionId, withDelegate: self)
            
            if let roomId = currentSessionDetails.object(forKey: "RoomId") as? String
            {
                SSTeacherDataSource.sharedDataSource.getGridDesignDetails(roomId, WithDelegate: self)
                mActivityIndicatore.startAnimating()
                mActivityIndicatore.isHidden = false
            }

        }
    }

    
    
    func didGetSeatAssignmentWithDetails(_ details: AnyObject)
    {
        
        
    }
    func didGetStudentsInfoWithDetails(_ details: AnyObject) {
        
        arranageSeatsWithDetails(details)
    }
    
    func didGetAllGraspIndexWithDetails(_ details: AnyObject)
    {
        
        print(details)
        
        
        if let studentsdetails = (details.object(forKey: "Students") as AnyObject).object(forKey: "Student") as? NSMutableArray
        {
            for index in studentsdetails
            {
                
                if let graspIndex =  (index as AnyObject).object(forKey: "GraspIndex") as? String
                {
                    if let StudentId = (index as AnyObject).object(forKey: "StudentId") as? String
                    {
                        if let studentDeskView  = mClassView.viewWithTag(Int(StudentId)!) as? StundentDeskView
                        {
                            studentDeskView.setProgressValue(Float(graspIndex)!)
                        }
                        
                    }
                }
                
            }
        }
        
        
        
        
        

    }
    
    func didGetSubtopicStartedWithDetails(_ details: AnyObject)
    {
        
        
        
        

        if SSTeacherDataSource.sharedDataSource.isSubtopicStarted == true
        {
            if UserDefaults.standard.bool(forKey: "isSimulateMode") == true
            {
                demoQueryView.sendDummyQueriesWithStudentDetails(StudentsDetailsArray)
            }
            
            SSTeacherDataSource.sharedDataSource.getGraspIndexOfAllStudentsWithTopic(SSTeacherDataSource.sharedDataSource.startedSubTopicId, withSessionID: currentSessionId, withDelegate: self)
            
            
                    let subViews = mClassView.subviews.flatMap{ $0 as? StundentDeskView }
            
                    for subview in subViews
                    {
                        if subview.isKind(of: StundentDeskView.self)
                        {
                            subview.setNewSubTopicStarted(true)
                        }
                    }
            
        }
        else
        {
            let subViews = mClassView.subviews.flatMap{ $0 as? StundentDeskView }
            
            for subview in subViews
            {
                if subview.isKind(of: StundentDeskView.self)
                {
                    subview.setNewSubTopicStarted(false)
                }
            }
        }
        
        
       
        
    }
    
    func didGetQuestionSentWithDetails(_ details: AnyObject) {
        
       
        print(currentQuestionDetails)
        
        if let QuestionLogId = details.object(forKey: "QuestionLogId") as? String
        {
            
            SSTeacherDataSource.sharedDataSource.isQuestionSent = true
            
            
            SSTeacherDataSource.sharedDataSource.currentQuestionLogId = QuestionLogId
            
            if let Type = currentQuestionDetails.object(forKey: kQuestionType) as? String
            {
                SSTeacherMessageHandler.sharedMessageHandler.sendQuestionWithRoomName(currentSessionId, withQuestionLogId: SSTeacherDataSource.sharedDataSource.currentQuestionLogId, withQuestionType: Type)
                
                
                
                
                if let questionType = currentQuestionDetails.object(forKey: kQuestionType) as? String
                {
                    
//                    print(currentQuestionDetails)
                    
                    if (questionType  == kOverlayScribble  || questionType == kFreshScribble)
                    {
                        mSubmissionView.addScribbleQuestionWithDetails(currentQuestionDetails)
                       
                        
                         if let Scribble = currentQuestionDetails.object(forKey: "Scribble") as? String
                         {
                            SSTeacherDataSource.sharedDataSource.mOverlayImageName = Scribble
                        }
                        else
                         {
                            SSTeacherDataSource.sharedDataSource.mOverlayImageName = ""
                        }
                        
                        
                        
                        
                        if UserDefaults.standard.bool(forKey: "isSimulateMode") == true
                        {
                            demoQuestionAnswerView.sendDummyAnswerWithQuestionDetails(currentQuestionDetails, withStudentDetails: StudentsDetailsArray)
                        }
                    }
                    else if (questionType == kText)
                    {
                        mSubmissionView.addScribbleQuestionWithDetails(currentQuestionDetails)
                        if UserDefaults.standard.bool(forKey: "isSimulateMode") == true
                        {
                            demoQuestionAnswerView.sendDummyAnswerWithQuestionDetails(currentQuestionDetails, withStudentDetails: StudentsDetailsArray)
                        }
                        SSTeacherDataSource.sharedDataSource.mOverlayImageName = ""
                    }
                    else if (questionType == kMatchColumn)
                    {
                        mSubmissionView.addMTCQuestionWithDetails(currentQuestionDetails)
                        
                        if UserDefaults.standard.bool(forKey: "isSimulateMode") == true
                        {
                            demoQuestionAnswerView.sendDummyAnswerWithQuestionDetails(currentQuestionDetails, withStudentDetails: StudentsDetailsArray)
                        }
                        SSTeacherDataSource.sharedDataSource.mOverlayImageName = ""
                        
                    }
                    else if (questionType  == kMCQ  || questionType == kMRQ)
                    {
                        mSubmissionView.addMRQQuestionWithDetails(currentQuestionDetails)
                        if UserDefaults.standard.bool(forKey: "isSimulateMode") == true
                        {
                          demoQuestionAnswerView.sendDummyAnswerWithQuestionDetails(currentQuestionDetails, withStudentDetails: StudentsDetailsArray)
                        }
                        SSTeacherDataSource.sharedDataSource.mOverlayImageName = ""
                        
                        
                    }
                    else if (questionType  == OneString) || questionType  == TextAuto
                    {
                        mSubmissionView.addOneStringQuestionWithDetails(currentQuestionDetails)
                        SSTeacherDataSource.sharedDataSource.mOverlayImageName = ""
                    }
//                    else if
//                    {
//                        mSubmissionView.addOneWordQuestionViewWithDetails(currentQuestionDetails)
//                        SSTeacherDataSource.sharedDataSource.mOverlayImageName = ""
//                    }
                }
            }
            else if let questionDetails = currentQuestionDetails.object(forKey: "Question") as? AnyObject
            {
                
                if let questionType = questionDetails.object(forKey: kQuestionType) as? String
                {
                    SSTeacherMessageHandler.sharedMessageHandler.sendQuestionWithRoomName(currentSessionId, withQuestionLogId: SSTeacherDataSource.sharedDataSource.currentQuestionLogId, withQuestionType: questionType)
                    
                  
                        //                    print(currentQuestionDetails)
                        
                        if (questionType  == kOverlayScribble  || questionType == kFreshScribble)
                        {
                            mSubmissionView.addScribbleQuestionWithDetails(currentQuestionDetails)
                            
                            
                            if let Scribble = currentQuestionDetails.object(forKey: "Scribble") as? String
                            {
                                SSTeacherDataSource.sharedDataSource.mOverlayImageName = Scribble
                            }
                            else
                            {
                                SSTeacherDataSource.sharedDataSource.mOverlayImageName = ""
                            }
                            
                            
                            
                            
                            if UserDefaults.standard.bool(forKey: "isSimulateMode") == true
                            {
                                demoQuestionAnswerView.sendDummyAnswerWithQuestionDetails(currentQuestionDetails, withStudentDetails: StudentsDetailsArray)
                            }
                        }
                        else if (questionType == kText)
                        {
                            mSubmissionView.addScribbleQuestionWithDetails(currentQuestionDetails)
                            if UserDefaults.standard.bool(forKey: "isSimulateMode") == true
                            {
                                demoQuestionAnswerView.sendDummyAnswerWithQuestionDetails(currentQuestionDetails, withStudentDetails: StudentsDetailsArray)
                            }
                            SSTeacherDataSource.sharedDataSource.mOverlayImageName = ""
                        }
                        else if (questionType == kMatchColumn)
                        {
                            mSubmissionView.addMTCQuestionWithDetails(currentQuestionDetails)
                            
                            if UserDefaults.standard.bool(forKey: "isSimulateMode") == true
                            {
                                demoQuestionAnswerView.sendDummyAnswerWithQuestionDetails(currentQuestionDetails, withStudentDetails: StudentsDetailsArray)
                            }
                            SSTeacherDataSource.sharedDataSource.mOverlayImageName = ""
                            
                        }
                        else if (questionType  == kMCQ  || questionType == kMRQ)
                        {
                            mSubmissionView.addMRQQuestionWithDetails(currentQuestionDetails)
                            if UserDefaults.standard.bool(forKey: "isSimulateMode") == true
                            {
                                demoQuestionAnswerView.sendDummyAnswerWithQuestionDetails(currentQuestionDetails, withStudentDetails: StudentsDetailsArray)
                            }
                            SSTeacherDataSource.sharedDataSource.mOverlayImageName = ""
                            
                            
                        }
                        else if (questionType  == OneString) || questionType  == TextAuto
                        {
                            mSubmissionView.addOneStringQuestionWithDetails(currentQuestionDetails)
                            SSTeacherDataSource.sharedDataSource.mOverlayImageName = ""
                        }
                        
                    
                }
                
                
            }
        }
        
    }
    
    func didGetQuestionClearedWithDetails(_ details:AnyObject)
    {
        print(details)
        
        SSTeacherDataSource.sharedDataSource.getGraspIndexOfAllStudentsWithTopic(SSTeacherDataSource.sharedDataSource.startedSubTopicId, withSessionID: currentSessionId, withDelegate: self)
        
    }
    
    func didGetSessionUpdatedWithDetials(_ details: AnyObject)
    {
       
        
     
        
    }
    
    func didGetMycurrentSessionWithDetials(_ details: AnyObject) {
        if details.object(forKey: "Status") != nil {
            if let Status = details.object(forKey: "Status") as? String {
                if Status == "There are no active sessions." {
                    delegateSessionEnded()
                } else  {
                    if let SessionId = details.object(forKey: "SessionId") as? String  {
                        if SessionId != SSTeacherDataSource.sharedDataSource.currentLiveSessionId {
                            delegateSessionEnded()
                        } else {
                            if let StartTime = currentSessionDetails.object(forKey: "StartTime") as? String {
                                var _string :String = ""
                                let currentDate = Date()
                                _string = _string.stringFromTimeInterval(currentDate.timeIntervalSince(dateFormatter.date(from: StartTime)!)).fullString
                                mStartTimeLabel.text = "Started: \(_string)"
                                if let  EndTime = currentSessionDetails.object(forKey: "EndTime") as? String {
                                    var totalminutesRemaining = currentDate.minutesDiffernceBetweenDates(dateFormatter.date(from: StartTime)!, endDate: dateFormatter.date(from: EndTime )!)
                                    totalminutesRemaining = totalminutesRemaining * 60
                                    var minutesRemaining = currentDate.minutesDiffernceBetweenDates(dateFormatter.date(from: StartTime )!, endDate:currentDate )
                                    minutesRemaining = minutesRemaining * 60
                                    let progressValue :CGFloat = CGFloat(minutesRemaining) / CGFloat(totalminutesRemaining)
                                    mRemainingTimeProgressBar.progress = Float(progressValue)
                                    let classEndingRemainingTime = currentDate.minutesDiffernceBetweenDates(currentDate, endDate:dateFormatter.date(from: EndTime )! )
                                    if classEndingRemainingTime <= 0 {
                                        mStartLabelUpdater.invalidate()
                                        delegateSessionEnded()
                                    } else if classEndingRemainingTime < 6 {
                                         sessionEndingAlertView = UIAlertController(title: "Session ending", message: "Your class is about to end in 6 mins. Do you want to continue?", preferredStyle: UIAlertControllerStyle.alert)
                                        sessionEndingAlertView.addAction(UIAlertAction(title: "End now", style: .default, handler: { action in
                                            self.sessionEndingAlertView.dismiss(animated: true, completion: nil)
                                                self.updateSessionStateToEnded()
                                        }))
                                        sessionEndingAlertView.addAction(UIAlertAction(title: "Continue", style: .default, handler: { action in
                                        }))
                                        self.present(sessionEndingAlertView, animated: true, completion: nil)
                                    } else {
                                        checkingClassEndTime = false
                                    }
                                }
                            }
                        }
                    }
                }
            } else {
                if details.object(forKey: "SessionId") != nil {
                    if let SessionId = details.object(forKey: "SessionId") as? String {
                        if SessionId != SSTeacherDataSource.sharedDataSource.currentLiveSessionId {
                            delegateSessionEnded()
                        } else {
                            sessionEndingAlertView = UIAlertController(title: "Session ending", message: "", preferredStyle: UIAlertControllerStyle.alert)
                            sessionEndingAlertView.addAction(UIAlertAction(title: "End session", style: .default, handler: { action in
                                self.updateSessionStateToEnded()
                            }))
                            sessionEndingAlertView.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: { action in
                            }))
                        }
                    }
                }
            }
        }
    }
    
    
    
    func didGetStudentsStateWithDetails(_ details: AnyObject) {
        
        print(details)
        
        var mStudentsDetails = NSMutableArray()
        
        if let StudentIdList = details.object(forKey: "StudentIdList") as? NSMutableDictionary
        {
            if let Students = StudentIdList.object(forKey: "Students") as? NSMutableArray
            {
                mStudentsDetails = Students
            }
            else if let Students = StudentIdList.object(forKey: "Students") as? NSMutableDictionary
            {
                mStudentsDetails.add(Students)
            }
            
        }
        
        
        
        for indexValue in 0  ..< mStudentsDetails.count
        {
           if let studentsDict = mStudentsDetails.object(at: indexValue) as? NSMutableDictionary
           {
                if let StudentId = studentsDict.object(forKey: "StudentId") as? String
                {
                    
                    if let studentDeskView  = mClassView.viewWithTag(Int(StudentId)!) as? StundentDeskView
                    {
                        if let state = studentsDict.object(forKey: "StudentState") as? String
                        {
                            if Int(state) == kStudentLive
                            {
                                studentDeskView.setStudentCurrentState(StudentLive)
                            }
                            else if Int(state) == kStudentSignedOut
                            {
                                studentDeskView.setStudentCurrentState(StudentSignedout)
                                
                            }
                            else if Int(state) == kStudentLeaveSession
                            {
                                studentDeskView.setStudentCurrentState(StudentFree)
                            }
                            else if Int(state) == kStudentLivebackground
                            {
                                studentDeskView.setStudentCurrentState(StudentLiveBackground)
                            }
                            else
                            {
                                studentDeskView.setStudentCurrentState(StudentFree)
                            }
                        }
                        
                    }
                }

            }
            
            
            
        }
        
        
    }
    
   
    
// MARK: - seatAssignment functions
    
    /// This function is used to arrange Grid using the details returned by API "RetrieveGridDesign"
    func arrangegridWithDetails(_ details:AnyObject)
    {
        var columnValue         = 1
        var rowValue            = 1
       
//        var seatsLableArray     = [String]()
        var seatsRemovedArray   = [String]()
        
        
        if let Columns = details.object(forKey: "Columns") as? String
        {
            columnValue = Int(Columns)!
        }
        
        if let Rows = details.object(forKey: "Rows") as? String
        {
            rowValue = Int(Rows)!
        }
        
        if let SeatIdList = details.object(forKey: "SeatIdList") as? String
        {
            seatsIdArray =  SeatIdList.components(separatedBy: ",")
        }
        
//        if let SeatLabelList = details.objectForKey("SeatLabelList") as? String
//        {
//            seatsLableArray =  SeatLabelList.componentsSeparatedByString(",")
//        }
        
        if let SeatsRemoved = details.object(forKey: "SeatsRemoved") as? String
        {
            seatsRemovedArray =  SeatsRemoved.components(separatedBy: ",")
        }
        
        
        var  barWidthvalue  :CGFloat = mClassView.frame.size.width / CGFloat(columnValue)
        
        let barWidthSpace :CGFloat = barWidthvalue * 0.03
        
        barWidthvalue = barWidthvalue * 0.97
        
        var barHeight   :CGFloat = mClassView.frame.size.height / CGFloat(rowValue)
        
        let barHeightSpace:CGFloat = barHeight * 0.03
        
        barHeight = barHeight * 0.97
        
        
        var postionY :CGFloat = barHeightSpace / 2
        
        var totalSeatvalue  = rowValue * columnValue
        
        for columnIndex in 0 ..< rowValue
        {
            
            let backGroundImageView = UIImageView(frame:  CGRect(x: 0, y: postionY - barHeightSpace, width: mClassView.frame.size.width, height: barHeight + barHeightSpace) )
            if (columnIndex%2==0)
            {
                backGroundImageView.backgroundColor = UIColor.white
                
            }
            else
            {
                backGroundImageView.backgroundColor = whiteBackgroundColor
            }
            
            mClassView.addSubview(backGroundImageView)
            
            var positionX :CGFloat = barWidthSpace / 2
            for _ in 0 ..< columnValue
            {
                if seatsRemovedArray.contains("A\(totalSeatvalue)")
                {
                    
                }
                else
                {
                    let seatView = StundentDeskView(frame: CGRect(x: positionX, y: postionY, width: barWidthvalue, height: barHeight))
                    seatView.setdelegate(self)
                    mClassView.addSubview(seatView)
                    seatView.tag  = totalSeatvalue
                    seatView.backgroundColor = UIColor.clear
                }
                
                positionX = positionX + barWidthvalue + barWidthSpace
                totalSeatvalue = totalSeatvalue - 1
                
            }
            postionY = postionY + barHeight + barHeightSpace
            
        }
        
        
        SSTeacherDataSource.sharedDataSource.getStudentsInfoWithSessionId(currentSessionId, withDelegate: self)
       

    }
    
    
    // This function is used to arrange seates according to details returned by API
    func arranageSeatsWithDetails(_ details:AnyObject)
    {
        
        
        if let statusString = details.object(forKey: "Status") as? String
        {
            if statusString == kSuccessString
            {
                if let classCheckingVariable = details.object(forKey: "Students") as? NSMutableDictionary
                {
                    if let StudentValue = classCheckingVariable.object(forKey: "Student") as? NSMutableArray
                    {
                        StudentsDetailsArray = StudentValue
                    }
                    else
                    {
                        StudentsDetailsArray.add(classCheckingVariable.object(forKey: "Student"))
                    }
                }
                
                
//                let classCheckingVariable = (details.object(forKey: "Students")! as AnyObject).object(forKey: "Student")!
//                
//                if (classCheckingVariable as AnyObject).isKind(of: NSMutableArray)
//                {
//                    StudentsDetailsArray = classCheckingVariable as! NSMutableArray
//                }
//                else
//                {
//                    StudentsDetailsArray.add((details.object(forKey: "Students")! as AnyObject).object(forKey: "Student")!)
//                    
//                }
            }
        }
        
        
        for indexValue in 0  ..< StudentsDetailsArray.count
        {
            let studentsDict = StudentsDetailsArray.object(at: indexValue)
            
            if var seatlabel = (studentsDict as AnyObject).object(forKey: "SeatLabel") as? String
            {
                seatlabel = seatlabel.replacingOccurrences(of: "A", with: "")
                
               if let studentDeskView  = mClassView.viewWithTag(Int(seatlabel)!) as? StundentDeskView
               {
                    studentDeskView.setStudentsDetails(studentsDict as AnyObject)
                    if let StudentId = (studentsDict as AnyObject).object(forKey: "StudentId") as? String
                    {
                            studentDeskView.tag = Int(StudentId)!
                    }
                }
                
                
            }
        }
        
        
        mClassView.isHidden = false
        mActivityIndicatore.stopAnimating()
        mActivityIndicatore.isHidden = true

    }
    
    
// MARK: - buttons functions
    
    func onModelAnswerButton()
    {
        mShowTopicsView.isHidden = true
        if mModelAnswerView.isHidden == false
        {
           mModelAnswerView.isHidden = true
        }
        else
        {
            mModelAnswerView.isHidden = false
        }
    }
    
    func onTopicsButton(_ sender:UIButton)
    {
        
        mModelAnswerView.isHidden =  true
        
        if mShowTopicsView.isHidden == true
        {
            mShowTopicsView.isHidden = false
            self.view.bringSubview(toFront: mShowTopicsView)
            
            
            if SSTeacherDataSource.sharedDataSource.isSubtopicStarted == false
            {
                
    
                
                mainTopicsView.getTopicsDetailswithStartedMaintopicId("")
                mShowTopicsView.frame = CGRect(x: self.view.frame.size.width - 610, y: mShowTopicsView.frame.origin.y , width: 600  , height: mainTopicsView.currentMainTopicsViewHeight)
                
                hideAllViewInTopicsView()
                mainTopicsView.isHidden = false
                mShowTopicsView.bringSubview(toFront: mainTopicsView)
                
                
                
            }
            else  if SSTeacherDataSource.sharedDataSource.isQuestionSent == true
            {
                liveQuestionView.setQuestionDetails(currentQuestionDetails, withMainTopciName: subTopicsView.mTopicName.text!, withMainTopicId: SSTeacherDataSource.sharedDataSource.startedMainTopicId)
                hideAllViewInTopicsView()
                liveQuestionView.isHidden = false
                mShowTopicsView.bringSubview(toFront: liveQuestionView)
                
                
                
                mShowTopicsView.frame = CGRect(x: self.view.frame.size.width - 460, y: mShowTopicsView.frame.origin.y ,width: 450  ,height: 350)
                
            }
            else if SSTeacherDataSource.sharedDataSource.isSubtopicStarted == true
            {
                
                
                subTopicsView.frame = CGRect(x: 0,y: 0, width: 600   ,height: 44)
                subTopicsView.getSubtopicsDetailsWithMainTopicId(SSTeacherDataSource.sharedDataSource.startedMainTopicId, withMainTopicName: SSTeacherDataSource.sharedDataSource.startedMainTopicName,withStartedSubtopicID:SSTeacherDataSource.sharedDataSource.startedSubTopicId
                )
                hideAllViewInTopicsView()
                subTopicsView.isHidden = false
                mShowTopicsView.bringSubview(toFront: subTopicsView)
                
                mShowTopicsView.frame = CGRect(x: self.view.frame.size.width - 610, y: mShowTopicsView.frame.origin.y , width: 600 , height: subTopicsView.currentMainTopicsViewHeight)
            }
            
            

        }
        else
        {
            mShowTopicsView.isHidden = true
            if SSTeacherDataSource.sharedDataSource.isSubtopicStarted == false
            {
                mSubTopicsNamelabel.text = "No topic selected"
            }
            
            
        }
        
        
        

    }

    
    
// MARK: - MainTopic delegate functions
    
    
    func delegateTopicsSizeChangedWithHeight(_ height: CGFloat)
    {
        UIView.animate(withDuration: 0.5, animations:
            {
                self.mShowTopicsView.frame = CGRect(x: self.view.frame.size.width - 610, y: self.mShowTopicsView.frame.origin.y , width: 600 , height: height)
        })
        
    }
    
    func delegateShowSubTopicWithMainTopicId(_ mainTopicID: String, WithMainTopicName mainTopicName: String)
    {
        
        
        subTopicsView.frame = CGRect(x: 0,y: 0, width: 600   ,height: 44)
        subTopicsView.getSubtopicsDetailsWithMainTopicId(mainTopicID, withMainTopicName: mainTopicName,withStartedSubtopicID: SSTeacherDataSource.sharedDataSource.startedSubTopicId)

        hideAllViewInTopicsView()
        subTopicsView.isHidden = false
        mShowTopicsView.bringSubview(toFront: subTopicsView)
          mShowTopicsView.frame = CGRect(x: self.view.frame.size.width - 610, y: mShowTopicsView.frame.origin.y ,width: 600, height: subTopicsView.currentMainTopicsViewHeight)
        
        
        if SSTeacherDataSource.sharedDataSource.isSubtopicStarted == false
        {
            mSubTopicsNamelabel.text = mainTopicName
            startedMainTopicID = mainTopicID
            startedMainTopicName = mainTopicName
            
        }
       
    }

    
// MARK: - subTopic delegate functions
    
    func delegateSubTopicBackButtonPressed()
    {
        mainTopicsView.getTopicsDetailswithStartedMaintopicId(SSTeacherDataSource.sharedDataSource.startedMainTopicId)
        
        hideAllViewInTopicsView()
        mainTopicsView.isHidden = false
        mShowTopicsView.bringSubview(toFront: mainTopicsView)
         mShowTopicsView.frame = CGRect(x: self.view.frame.size.width - 610, y: mShowTopicsView.frame.origin.y , width: 600 , height: mainTopicsView.currentMainTopicsViewHeight)
       
    }
    
    func delegateSubtopicStateChanedWithSubTopicDetails(_ subTopicDetails: AnyObject, withState state: Bool, withmainTopicName mainTopicName: String)
    {
        
        mainTopicsView.mMaintopicsDetails.removeAllObjects()

        if state == true
        {
            startedSubTopicDetails = subTopicDetails
            if let topicId = subTopicDetails.object(forKey: "Id")as? String
            {

                if let sessionId = (currentSessionDetails.object(forKey: kSessionId)) as? String
                {
                    SSTeacherDataSource.sharedDataSource.startSubTopicWithTopicID(topicId, withStudentId: "", withSessionID: sessionId, withDelegate: self)
                   
                    if let topicName = subTopicDetails.object(forKey: "Name")as? String
                    {
                        mSubTopicsNamelabel.text = "\(mainTopicName) / \(topicName)"
                    }
                    
                    
                    
                    SSTeacherMessageHandler.sharedMessageHandler.sendAllowVotingToRoom(currentSessionId, withValue: "TRUE", withSubTopicName: mSubTopicsNamelabel.text!, withSubtopicID: topicId)
                    
                }

            }
        }
        else
        {
            
            if let subTopicId = subTopicDetails.object(forKey: "Id")as? String
            {
                let subTopicName = subTopicDetails.object(forKey: "Name")as! String
                
                if let sessionId = (currentSessionDetails.object(forKey: kSessionId)) as? String
                {
                    SSTeacherDataSource.sharedDataSource.stopSubTopicWithTopicID(subTopicId, withSessionID: sessionId, withDelegate: self)
                }
                
                SSTeacherMessageHandler.sharedMessageHandler.sendAllowVotingToRoom(currentSessionId, withValue: "FALSE", withSubTopicName: subTopicName, withSubtopicID: subTopicId)
                
                
               
                
                mSubTopicsNamelabel.text = "\(mainTopicName)"
            }
            
            
        }
        
        
        
    }
    
    
    func delegateSubtopicStateChanedWithID(_ subTopicId: String, withState state: Bool, withSubtopicName subTopicName: String, withmainTopicName mainTopicName: String) {
        
        if state == true
        {
            
            if let sessionId = (currentSessionDetails.object(forKey: kSessionId)) as? String
            {
                SSTeacherDataSource.sharedDataSource.startSubTopicWithTopicID(subTopicId, withStudentId: "", withSessionID: sessionId, withDelegate: self)
            }

             mSubTopicsNamelabel.text = "\(mainTopicName) / \(subTopicName)"
            
            SSTeacherMessageHandler.sharedMessageHandler.sendAllowVotingToRoom(currentSessionId, withValue: "TRUE", withSubTopicName: mSubTopicsNamelabel.text!, withSubtopicID: subTopicId)
        }
        else
        {
            
            
            if let sessionId = (currentSessionDetails.object(forKey: kSessionId)) as? String
            {
                SSTeacherDataSource.sharedDataSource.stopSubTopicWithTopicID(subTopicId, withSessionID: sessionId, withDelegate: self)
            }

            
            SSTeacherDataSource.sharedDataSource.isSubtopicStarted = false
            SSTeacherMessageHandler.sharedMessageHandler.sendAllowVotingToRoom(currentSessionId, withValue: "FALSE", withSubTopicName: subTopicName, withSubtopicID: subTopicId)
            
             mSubTopicsNamelabel.text = "\(mainTopicName)"
        }
    }
    
    
// MARK: - subTopic delegate functions
    func delegateQuestionButtonPressedWithSubtopicId(_ subtopicId: String, withSubTopicName subTopicName: String, withMainTopicId mainTopicId: String, withMainTopicName mainTopicName: String) {
        
       
        
        
        
        questionTopicsView.frame = CGRect(x: 0,y: 0, width: 600   ,height: 88)
        
        if SSTeacherDataSource.sharedDataSource.startedSubTopicId == subtopicId
        {
            questionTopicsView.getQuestionsDetailsWithsubTopicId(subtopicId, withSubTopicName: subTopicName, withMainTopicId: mainTopicId, withMainTopicName: mainTopicName, withSubtopicStarted: true)
        }
        else
        {
            questionTopicsView.getQuestionsDetailsWithsubTopicId(subtopicId, withSubTopicName: subTopicName, withMainTopicId: mainTopicId, withMainTopicName: mainTopicName, withSubtopicStarted: false)
        }

         hideAllViewInTopicsView()
        
        questionTopicsView.isHidden = false
        mShowTopicsView.bringSubview(toFront: questionTopicsView)
        
        mShowTopicsView.frame = CGRect(x: self.view.frame.size.width - 610, y: mShowTopicsView.frame.origin.y , width: 600 , height: questionTopicsView.currentMainTopicsViewHeight)

        
    }
    
    
// MARK: - Question delegate functions
    
    
    func delegateQuizmodePressedwithQuestions(_ questionArray: NSMutableArray)
    {
        
        
        
        let mQuizMode = QuizModeView(frame:CGRect(x: 0,y: 0,width: mShowTopicsView.frame.size.width,height: mShowTopicsView.frame.size.height))
        mShowTopicsView.addSubview(mQuizMode)
        mQuizMode.setQuestionWithDetails(questionArray)
    
        
        
        
        
    }
    
    
    func delegateQuestionSentWithQuestionDetails(_ questionDetails: AnyObject) {
        
        
        
        if SSTeacherDataSource.sharedDataSource.isQuestionSent == false
        {
            mShowTopicsView.isHidden = true
            
            currentQuestionDetails = questionDetails
            
            if let QuestionID = (currentQuestionDetails.object(forKey: "Id")) as? String
            {
                SSTeacherDataSource.sharedDataSource.broadcastQuestionWithQuestionId(QuestionID, withSessionID: currentSessionId, withDelegate: self)
                SSTeacherDataSource.sharedDataSource.isQuestionSent = true
                
                if let questionName = (currentQuestionDetails.object(forKey: "Name")) as? String
                {
                    mQuestionNamelabel.text = questionName
                }
                
                
                
                
                
            }
            
            let subViews = mClassView.subviews.flatMap{ $0 as? StundentDeskView }
            
            for subview in subViews
            {
                if subview.isKind(of: StundentDeskView.self)
                {
                    subview.setCurrentQuestionDetails(questionDetails)
                }
            }
            

        }
        else
        {
            self.view.makeToast("Please clear current question to send new question", duration: 5.0, position: .bottom)
        }
    }
    
    
    func delegateQuestionBackButtonPressed(_ mainTopicId: String, withMainTopicName mainTopicName: String) {
       
        subTopicsView.frame = CGRect(x: 0,y: 0, width: 600   ,height: 44)
        subTopicsView.getSubtopicsDetailsWithMainTopicId(mainTopicId, withMainTopicName: mainTopicName,withStartedSubtopicID:SSTeacherDataSource.sharedDataSource.startedSubTopicId
        )
        
        
        hideAllViewInTopicsView()
        
        subTopicsView.isHidden = false
        mShowTopicsView.bringSubview(toFront: subTopicsView)
        
    }
    
    func delegateScribbleQuestionWithSubtopicId(_ subTopicID: String)
    {
        let mScribbleview =  SSTeacherScribbleQuestion(frame:CGRect(x: 0  ,y: 0,width: self.view.frame.size.width,height: self.view.frame.size.height))
        self.view.addSubview(mScribbleview)
        mScribbleview.setdelegate(self)
        mScribbleview.setCurrentTopicId(SSTeacherDataSource.sharedDataSource.startedSubTopicId)
        
    }
    
    func delegateMtcQuestionWithSubtopicId(_ subTopicId:String)
    {
        
    }
   
    func delegateMRQQuestionWithSubtopicId(_ subTopicId:String)
    {
        
        
        
        
        questionTopicsView.isHidden = true
        
       mShowTopicsView.frame = CGRect(x: mShowTopicsView.frame.origin.x, y: mShowTopicsView.frame.origin.y , width: mShowTopicsView.frame.size.width     , height: 200)
        
       /*
        let  mCollaborationMRQView  = CollaborationMRQCategoryView(frame:CGRect(x: 0,y: 0, width: self.questionTopicsView.frame.size.width   ,height: 100))
        mCollaborationMRQView.setdelegate(self)
        mCollaborationMRQView.backgroundColor = UIColor.white
        self.mShowTopicsView.addSubview(mCollaborationMRQView)
        
        DispatchQueue.main.async
        {
            mCollaborationMRQView.loadAllSubView()
           
        }
 */
        
        
        mSubmissionView.addCollaborationMRQView()
        
        mShowTopicsView.isHidden = true
        
        if SSTeacherDataSource.sharedDataSource.isSubtopicStarted == false
        {
            mSubTopicsNamelabel.text = "No topic selected"
        }
        
        onQuestionsView()
        
        
        
    }
    
    
    // MARK: - Collaboration Questiondelegate functions
    
    func delegateDoneButtonPressedWithCategoryName(_ category:String)
    {
       
     /*
        SSTeacherMessageHandler.sharedMessageHandler.sendCollaborationQuestionEnabledWithRoomId(SSTeacherDataSource.sharedDataSource.currentLiveSessionId, withType: "MRQ", withCategory: category)
 
 */
        
        
        
    }
    
    func delegateBackButtonPressed()
    {
        
        mShowTopicsView.frame = CGRect(x: self.view.frame.size.width - 610, y: mShowTopicsView.frame.origin.y , width: 600  , height: questionTopicsView.currentMainTopicsViewHeight)
        
        questionTopicsView.isHidden = false
    }

    
    
    // MARK: - live Question delegate functions
    
    func delegateQuestionCleared(_ questionDetails: AnyObject, withCurrentmainTopicId mainTopicId: String, withCurrentMainTopicName mainTopicName: String) {
        
        
        SSTeacherDataSource.sharedDataSource.clearQuestionWithQuestionogId(SSTeacherDataSource.sharedDataSource.currentQuestionLogId,withTopicId: SSTeacherDataSource.sharedDataSource.startedSubTopicId,withSessionId: currentSessionId,withDelegate: self)
        
        
        
        SSTeacherDataSource.sharedDataSource.isQuestionSent = false
        
        questionTopicsView.clearQuestionTopicId(SSTeacherDataSource.sharedDataSource.startedSubTopicId)
        
        subTopicsView.clearSubTopicDetailsWithMainTopicId(mainTopicId)
        
        
        if (SSTeacherDataSource.sharedDataSource.subTopicDetailsDictonary.object(forKey: mainTopicId) != nil)
        {
            SSTeacherDataSource.sharedDataSource.subTopicDetailsDictonary.removeObject(forKey: mainTopicId)
        }
        
        
        
        
        
        
        
        newSubmissionRecieved.removeAllObjects()
        
        submissionNotificationLabel.isHidden = true
        

        
        
        
        subTopicsView.frame = CGRect(x: 0,y: 0, width: 600   ,height: 44)
        subTopicsView.getSubtopicsDetailsWithMainTopicId(mainTopicId, withMainTopicName: mainTopicName,withStartedSubtopicID:SSTeacherDataSource.sharedDataSource.startedSubTopicId
        )
        
        
        hideAllViewInTopicsView()
        subTopicsView.isHidden = false
        mShowTopicsView.bringSubview(toFront: subTopicsView)
         mShowTopicsView.frame = CGRect(x: self.view.frame.size.width - 610, y: mShowTopicsView.frame.origin.y , width: 600 , height: 44)

        
        
        for indexValue in 0  ..< StudentsDetailsArray.count
        {
            let studentsDict = StudentsDetailsArray.object(at: indexValue)
           
            if let StudentId = (studentsDict as AnyObject).object(forKey: "StudentId") as? String{
                
                if let studentDeskView  = mClassView.viewWithTag(Int(StudentId)!) as? StundentDeskView
                {
                    studentDeskView.teacherClearedQuestion()
                }
            }
            
           
        }
        
        mQuestionNamelabel.text = "No active question"
        SSTeacherMessageHandler.sharedMessageHandler.sendClearQuestionMessageWithRoomId(currentSessionId)
        mSubmissionView.questionClearedByTeacher()
        mModelAnswerView.questionClearedByTeacher()
        mModelAnswerButton.isHidden = true
        mModelAnswerView.isHidden = true
        SSTeacherDataSource.sharedDataSource.mOverlayImageName = ""
        
        SSTeacherDataSource.sharedDataSource.mModelAnswersArray.removeAllObjects()
        SSTeacherDataSource.sharedDataSource.mRecordedModelAnswersArray.removeAllObjects()
    }
    
    func delegateFreezQuestion() {
          SSTeacherDataSource.sharedDataSource.freezQuestionWithQuestionogId(SSTeacherDataSource.sharedDataSource.currentQuestionLogId,withTopicId: SSTeacherDataSource.sharedDataSource.startedSubTopicId,withSessionId: currentSessionId,withDelegate: self)
    }
    
    func delegateDoneButtonPressed()
    {
        mShowTopicsView.isHidden = true
       
        if SSTeacherDataSource.sharedDataSource.isSubtopicStarted == false
        {
            mSubTopicsNamelabel.text = "No topic selected"
        }
    }
    
    func delegateTopicsButtonPressed()
    {
        
        subTopicsView.frame = CGRect(x: 0,y: 0, width: 600   ,height: 44)
        subTopicsView.getSubtopicsDetailsWithMainTopicId(SSTeacherDataSource.sharedDataSource.startedMainTopicId, withMainTopicName: SSTeacherDataSource.sharedDataSource.startedMainTopicName,withStartedSubtopicID:SSTeacherDataSource.sharedDataSource.startedSubTopicId
        )
       hideAllViewInTopicsView()
        subTopicsView.isHidden = false
       
        mShowTopicsView.bringSubview(toFront: subTopicsView)
        
        
        
        
        
        mShowTopicsView.frame = CGRect(x: self.view.frame.size.width - 610, y: mShowTopicsView.frame.origin.y , width: 600 , height: subTopicsView.currentMainTopicsViewHeight)
        
    }
    
    
// MARK: - message handler delegate
    
    
    func smhDidReciveAuthenticationState(_ state: Bool, WithName userName: String)
    {
        if state == true
        {
            AppDelegate.sharedDataSource.hideReconnecting()
        }
    }
    
    func smhStreamReconnectingWithDelay(_ delay: Int32) {
        
        self.view.makeToast("Reconnecting in \(delay) seconds", duration: 2, position: .bottom)
        
        AppDelegate.sharedDataSource.showReconnecting()
      
    }
    
    func smhDidcreateRoomWithRoomName(_ roomName: String)
    {
       
//        if currentQuestionDetails == nil
//        {
//            return
//        }
//        if let Type = currentQuestionDetails.objectForKey("Type") as? String
//        {
//            
//            
//            for var indexValue = 0 ; indexValue < StudentsDetailsArray.count ; indexValue++
//            {
//                let studentsDict = StudentsDetailsArray.objectAtIndex(indexValue)
//                
//                if let StudentId = studentsDict.objectForKey("StudentId") as? String
//                {
//                    SSTeacherMessageHandler.sharedMessageHandler.sendLiveClassRoomName(roomName, withQuestionLogId: StudentId, withQuestionType: Type)
//                }
//            }
//           
//           
//        }
       
    }
    
    
    func smhDidgetStudentBentchStateWithStudentId(_ studentId: String, withState state: String) {
        
        if let studentDeskView  = mClassView.viewWithTag(Int(studentId)!) as? StundentDeskView
        {
            
             studentDeskView.setNewSubTopicStarted(false)
            
            if Int(state) == kStudentLive
            {
                
               
                if studentDeskView.StudentState != StudentLiveBackground
                {
                    if SSTeacherDataSource.sharedDataSource.isSubtopicStarted == true
                    {
                        SSTeacherMessageHandler.sharedMessageHandler.sendAllowVotingToStudents(studentId, withValue: "TRUE", withSubTopicName: mSubTopicsNamelabel.text!, withSubtopicID: SSTeacherDataSource.sharedDataSource.startedSubTopicId)
                    }
//                    else
//                    {
//                        SSTeacherMessageHandler.sharedMessageHandler.sendAllowVotingToStudents(studentId, withValue: "FALSE", withSubTopicName: mSubTopicsNamelabel.text!, withSubtopicID: SSTeacherDataSource.sharedDataSource.startedSubTopicId)
//                    }
                    
                    
                }
                
                studentDeskView.setStudentCurrentState(StudentLive)
                
                if SSTeacherDataSource.sharedDataSource.isSubtopicStarted == true
                {
                    studentDeskView.setNewSubTopicStarted(true)
                }
                
                
                
            }
            else if Int(state) == kStudentSignedOut
            {
                studentDeskView.setStudentCurrentState(StudentSignedout)
                
            }
            else if Int(state) == kStudentLeaveSession
            {
                studentDeskView.setStudentCurrentState(StudentFree)
            }
            else if Int(state) == kStudentLivebackground
            {
                studentDeskView.setStudentCurrentState(StudentLiveBackground)
                
                if SSTeacherDataSource.sharedDataSource.isSubtopicStarted == true
                {
                    studentDeskView.setNewSubTopicStarted(true)
                }
            }
            else
            {
                studentDeskView.setStudentCurrentState(StudentFree)
            }
        }
    }
    
    
    func smhDidgetStudentQuestionAccepetedMessageWithStudentId(_ StudentId: String) {
        
        
        if currentQuestionDetails ==  nil
        {
            return
        }
        
        
        if let studentDeskView  = mClassView.viewWithTag(Int(StudentId)!) as? StundentDeskView
        {
           
            if currentQuestionDetails.object(forKey: kQuestionType) != nil
            {
                if let questionType = currentQuestionDetails.object(forKey: kQuestionType) as? String
                {
                    
                    if (questionType  == kOverlayScribble  || questionType == kFreshScribble || questionType  == kText)
                    {
                        studentDeskView.mQuestionStateImage.image = UIImage(named:"StudentWriting.png");
                    }
                    else
                    {
                        studentDeskView.mQuestionStateImage.image = UIImage(named:"StudentThinking.png");
                        
                    }
                    
                    studentDeskView.mQuestionStateImage.isHidden = false
                }
            }
            
        }
        
    }
    
    
    func smhDidGetstudentSubmissionWithDrawn(_ StudentId: String)
    {
        if let studentDeskView  = mClassView.viewWithTag(Int(StudentId)!) as? StundentDeskView
        {
            if currentQuestionDetails != nil
            {
                studentDeskView.studentAnswerWithdrawn()
                
                mSubmissionView.studentAnswerWithdrawnWithStudentId(StudentId)
                
                if newSubmissionRecieved.contains(StudentId)
                {
                    newSubmissionRecieved.remove(StudentId)
                    
                    if newSubmissionRecieved.count > 0
                    {
                        submissionNotificationLabel.isHidden = false
                        
                        submissionNotificationLabel.text = "\(newSubmissionRecieved.count)"
                    }
                    else
                    {
                        submissionNotificationLabel.isHidden = true
                    }
                }
                
                
            }
            
            
        }
    }
    
    func smhDidgetStudentAnswerMessageWithStudentId(_ StudentId: String, withAnswerString answerStrin: String)
    {
        if let studentDeskView  = mClassView.viewWithTag(Int(StudentId)!) as? StundentDeskView {
            if currentQuestionDetails != nil && studentDeskView.currentAnswerRecievedState == .Cleared {
                studentDeskView.studentSentAnswerWithAnswerString(answerStrin,withQuestionDetails: currentQuestionDetails)
            }
        }
    }
    
    
    func smhDidgetStudentDontKnowMessageRecieved(_ StudentId: String) {
        if let studentDeskView  = mClassView.viewWithTag(Int(StudentId)!) as? StundentDeskView {
            if currentQuestionDetails != nil {
                studentDeskView.setDontKnowMessageFromStudent()
            }
        }
    }
    
    
    func smhDidgetStudentQueryWithDetails(_ queryId: String) {
        
        mQueryView.addQueryWithDetails(queryId)
        if mQueryView.isHidden == false
        {
            SSTeacherMessageHandler.sharedMessageHandler.sendQueryRecievedMessageToRoom(currentSessionId)
        }
        
    }
    
    func smhDidgetQueryWithdrawnWithDetails(_ queryId: String, withStudentId studentId: String) {
        
        if let studentDeskView  = mClassView.viewWithTag(Int(studentId)!) as? StundentDeskView
        {
            newQueryRecieved.remove(studentId)
            studentDeskView.queryDismissed()
            mQueryView.queryWithDrawnWithQueryId(queryId)
            
        }
    }
    
    func smhDidgetStudentPollWithDetails(optionValue:NSMutableDictionary)
    {
        if let studentID =  optionValue.object(forKey: "studentID") as? String
        {
            if newQueryRecieved.contains(studentID) == false
            {
                newPollRecieved.add(studentID)
            }
            
        }
        
        
        if currentScreen != kPollView
        {
            
            PollNotificationLabel.isHidden = false
            
            PollNotificationLabel.text = "\(newPollRecieved.count)"
        }
        else
        {
            PollNotificationLabel.isHidden = true
        }
        
        
        
        if mPollingView != nil
        {
            
            
            if let options =  optionValue.object(forKey: "option") as? String
            {
                mPollingView.didGetStudentPollValue(options)
            }
            
            
            
        }
        
    }
    
    
    func smhDidgetMeTooValueWithDetails(_ details: AnyObject)
    {
        mQueryView.studentRaisedMeeToWithDetial(details)
    }
    
    func smhDidgetVolunteerValueWithDetails(_ details: AnyObject)
    {
        mQueryView.studentVolunteerRaisedWithDetails(details)
    }
    
    
    func smhDidgetVoteFromStudentWithStudentId(_ StudentId: String, withVote newVote: String)
    {
        
        
        var totalStudents = 0
        
        
        let subViews = mClassView.subviews.flatMap{ $0 as? StundentDeskView }
        
        for subview in subViews
        {
            if subview.isKind(of: StundentDeskView.self)
            {
                
                
                
                if subview.StudentState == StudentLive || subview.StudentState == StudentLiveBackground
                {
                    totalStudents = totalStudents + 1
                }
            }
        }
        
        if totalStudents <= 0
        {
            totalStudents = 1
        }
        else if totalStudents >= 2
        {
            totalStudents = totalStudents - 1
        }
        
        
        mQueryView.studentNewVoteRaised(StudentId, withVote: newVote, withTotalStudents:totalStudents)
    }
    
    
    
    func smhDidgetUnderstoodMessageWithDetails(_ details: AnyObject, withStudentId StudentId: String){
        if details.object(forKey: "QueryId") != nil {
            if let QueryId =  details.object(forKey: "QueryId") as? String {
                mQueryView.studentUnderstoodQueryWithId(QueryId, withStudentId: StudentId)
            }
        }
    }
    
    func smhDidgetPeakViewWithDetails(_ details: AnyObject, withStudentId studentId: String) {
       
        if details.object(forKey: "imageData") != nil
        {
           if  let imageData = details.object(forKey: "imageData")  as? String
           {
            
            let dataDecoded:Data = Data(base64Encoded: imageData, options: NSData.Base64DecodingOptions.ignoreUnknownCharacters)!
            
            var decodedimage:UIImage = UIImage()
            if dataDecoded.count > 0
            {
                decodedimage = UIImage(data: dataDecoded)!
            }
            
            
            if let studentDeskView  = mClassView.viewWithTag(Int(studentId)!) as? StundentDeskView
            {
                
                studentDeskView.didGetPeakView()
                
                let buttonPosition :CGPoint = studentDeskView.convert(CGPoint.zero, to: self.view)

                let questionInfoController = SSTeacherPeakViewController()
                questionInfoController.setStudentDetails(studentDeskView.currentStudentsDict, withPeakImage: decodedimage)
               
                 SSTeacherDataSource.sharedDataSource.mPopOverController = UIPopoverController(contentViewController: questionInfoController)
                
                questionInfoController.preferredContentSize = CGSize(width: 270,height: 220)
                
                SSTeacherDataSource.sharedDataSource.mPopOverController.contentSize = CGSize(width: 270,height: 220);
                SSTeacherDataSource.sharedDataSource.mPopOverController.delegate = self;
                questionInfoController.setPopover(SSTeacherDataSource.sharedDataSource.mPopOverController)
                SSTeacherDataSource.sharedDataSource.mPopOverController.present(from: CGRect(
                    x:buttonPosition.x + studentDeskView.frame.size.height / 2,
                    y:buttonPosition.y + studentDeskView.frame.size.height / 2,
                    width: 1,
                    height: 1), in: self.view, permittedArrowDirections: [.right, .left], animated: true)

            }
            }
            
        }
        
      
           }
    
    
    func smhDidgetOneStringAnswerWithDetails(_ details: AnyObject, withStudentId studentId: String) {
        
        if details.object(forKey: "OneStringAnswer") != nil
        {
            if let OneStringAnswer = details.object(forKey: "OneStringAnswer")  as? String
            {
                if let studentDeskView  = mClassView.viewWithTag(Int(studentId)!) as? StundentDeskView
                {
                    studentDeskView.setOneStringAnswerWithText(OneStringAnswer)
                    
                    
                    if currentQuestionDetails.object(forKey: kQuestionType) != nil
                    {
                        if let questionType = currentQuestionDetails.object(forKey: kQuestionType) as? String
                        {
                            if questionType == OneString || questionType  == TextAuto
                            {
                                mSubmissionView.SetStudentOneStringAnswer(OneStringAnswer, withStudentDict: studentDeskView.currentStudentsDict)
                            }
                            
                        }
                    }
                }
            }
        }
        
    }
    
    
    
    func smhDidgetCollaborationSuggestion(_ details: AnyObject)
    {
        
      mSubmissionView.addCollaborationSuggestionWithDetails(details)
        
        
    }
    
    
    // MARK: - DeskView delegate functions
    
    func delegateStudentAnswerDownloadedWithDetails(_ details: AnyObject, withStudentDict studentDict: AnyObject)
    {
        
        
        if currentQuestionDetails ==  nil
        {
            return
        }
        
        
        if let _ = currentQuestionDetails.object(forKey: kQuestionType) as? String
        {
            
            if currentScreen != kSubmissionView
            {
                newSubmissionRecieved.add(studentDict.object(forKey: "StudentId") as! String)
                
                submissionNotificationLabel.isHidden = false
                
                submissionNotificationLabel.text = "\(newSubmissionRecieved.count)"
            }
            
            
            mSubmissionView.studentAnswerRecievedWIthDetails(details, withStudentDict: studentDict)
            
            
            
            if mSubmissionView.isHidden == false
            {
                if let studentId = studentDict.object(forKey: "StudentId") as? String
                {
                    SSTeacherMessageHandler.sharedMessageHandler.sendHandRaiseReceivedMessageToStudentWithId(studentId)
                }

            }
            
            
            
        }
        
        
        
    }
    
    
    func delegateStudentCellPressedWithViewAnswerOptions(_ answerOptions: NSMutableArray, withStudentId studentId: String) {
        
        
        if let studentDeskView  = mClassView.viewWithTag(Int(studentId)!) as? StundentDeskView
        {
            let buttonPosition :CGPoint = studentDeskView.convert(CGPoint.zero, to: self.view)
           
            if let questionType = currentQuestionDetails.object(forKey: kQuestionType) as? String
            {
                
                if (questionType  == kOverlayScribble  || questionType == kFreshScribble)
                {
                    
                }
                else if (questionType == kText)
                {
                    
                }
                else if (questionType == kMatchColumn)
                {
                    
                    let questionInfoController = MatchColumnOption()
                    questionInfoController.setdelegate(self)
                    
                    
                    
                    
                    questionInfoController.setQuestionDetails(currentQuestionDetails, withStudentsAnswer:answerOptions)
                    
                    
                    questionInfoController.preferredContentSize = CGSize(width: 400,height: 317)
                    
                     SSTeacherDataSource.sharedDataSource.mPopOverController = UIPopoverController(contentViewController: questionInfoController)
                    questionInfoController.setPopover(SSTeacherDataSource.sharedDataSource.mPopOverController)
                    SSTeacherDataSource.sharedDataSource.mPopOverController.contentSize = CGSize(width: 400,height: 317);
                    SSTeacherDataSource.sharedDataSource.mPopOverController.delegate = self;
                    
                    SSTeacherDataSource.sharedDataSource.mPopOverController.present(from: CGRect(
                        x:buttonPosition.x + studentDeskView.frame.size.height / 2,
                        y:buttonPosition.y + studentDeskView.frame.size.height / 2,
                        width: 1,
                        height: 1), in: self.view, permittedArrowDirections:[.right, .left], animated: true)
                }
                else
                {
                    let questionInfoController = SingleResponceOption()
//                    questionInfoController.setdelegate(self)
                    
                    
                    
                    
                    questionInfoController.setQuestionDetails(currentQuestionDetails,withAnswerOptions: answerOptions)
                    
                    
                    questionInfoController.preferredContentSize = CGSize(width: 400,height: 317)
                    
                      SSTeacherDataSource.sharedDataSource.mPopOverController = UIPopoverController(contentViewController: questionInfoController)
                    questionInfoController.setPopover(SSTeacherDataSource.sharedDataSource.mPopOverController)
                    SSTeacherDataSource.sharedDataSource.mPopOverController.contentSize = CGSize(width: 400,height: 317);
                    SSTeacherDataSource.sharedDataSource.mPopOverController.delegate = self;
                    
                    SSTeacherDataSource.sharedDataSource.mPopOverController.present(from: CGRect(
                        x:buttonPosition.x + studentDeskView.frame.size.height / 2,
                        y:buttonPosition.y + studentDeskView.frame.size.height / 2,
                        width: 1,
                        height: 1), in: self.view, permittedArrowDirections: [.right, .left], animated: true)
                    
                    
                }
            }
            
        }
        
        
        
    }
    
    
    func delegateStudentCellPressedWithViewSubjectiveAnswerDetails(_ details: AnyObject, withStudentId studentId: String)
    {
        if let studentDeskView  = mClassView.viewWithTag(Int(studentId)!) as? StundentDeskView
        {
            let buttonPosition :CGPoint = studentDeskView.convert(CGPoint.zero, to: self.view)
            
            if let questionType = currentQuestionDetails.object(forKey: kQuestionType) as? String
            {
                
                if (questionType  == kOverlayScribble  || questionType == kFreshScribble || questionType == kText)
                {
                    let questionInfoController = StudentSubjectivePopover()
                    questionInfoController.setdelegate(self)
                    
                   questionInfoController.setStudentAnswerDetails(details, withStudentDetials: studentDeskView.currentStudentsDict, withCurrentQuestionDict: currentQuestionDetails)
                    
                     SSTeacherDataSource.sharedDataSource.mPopOverController = UIPopoverController(contentViewController: questionInfoController)
                    
                    SSTeacherDataSource.sharedDataSource.mPopOverController.contentSize = CGSize(width: 320,height: 320);
                    SSTeacherDataSource.sharedDataSource.mPopOverController.delegate = self;
                    questionInfoController.setPopover(SSTeacherDataSource.sharedDataSource.mPopOverController)
                    SSTeacherDataSource.sharedDataSource.mPopOverController.present(from: CGRect(
                        x:buttonPosition.x + studentDeskView.frame.size.height / 2,
                        y:buttonPosition.y + studentDeskView.frame.size.height / 2,
                        width: 1,
                        height: 1), in: self.view, permittedArrowDirections: [.right, .left], animated: true)
                    
                    
                    
                    if newSubmissionRecieved.contains(studentId)
                    {
                        newSubmissionRecieved.remove(studentId)
                        
                         SSTeacherMessageHandler.sharedMessageHandler.sendHandRaiseReceivedMessageToStudentWithId(studentId)
                        
                        if newSubmissionRecieved.count > 0
                        {
                            submissionNotificationLabel.isHidden = false
                            
                            submissionNotificationLabel.text = "\(newSubmissionRecieved.count)"
                        }
                        else
                        {
                            submissionNotificationLabel.isHidden = true
                        }
                    }
                }
            }
            
        }
    }
    
    
    
    
    
    func delegateStudentCellPressedWithEvaluationDetails(_ details: AnyObject, withStudentId studentId: String)
    {
        if let studentDeskView  = mClassView.viewWithTag(Int(studentId)!) as? StundentDeskView
        {
            let buttonPosition :CGPoint = studentDeskView.convert(CGPoint.zero, to: self.view)
            
            // By Ujjval
            // ==========================================
            
//            let questionInfoController = StudentEvaluationDetails()
            let questionInfoController = StudentSubjectivePopover()
            questionInfoController.isAfterEvaluated = true
            
            // ==========================================
            
            questionInfoController.setdelegate(self)
            
            questionInfoController.setStudentAnswerDetails(studentDeskView._currentAnswerDetails, withStudentDetials: studentDeskView.currentStudentsDict, withCurrentQuestionDict: currentQuestionDetails, withEvaluationDetails: details)
            
             SSTeacherDataSource.sharedDataSource.mPopOverController = UIPopoverController(contentViewController: questionInfoController)
            
            SSTeacherDataSource.sharedDataSource.mPopOverController.contentSize = CGSize(width: 320,height: 320);
            SSTeacherDataSource.sharedDataSource.mPopOverController.delegate = self;
            questionInfoController.setPopover(SSTeacherDataSource.sharedDataSource.mPopOverController)
            
            SSTeacherDataSource.sharedDataSource.mPopOverController.present(from: CGRect(
                x:buttonPosition.x + studentDeskView.frame.size.height / 2,
                y:buttonPosition.y + studentDeskView.frame.size.height / 2,
                width: 1,
                height: 1), in: self.view, permittedArrowDirections: [.right, .left], animated: true)
            
        }
        
    }
    
    
    func delegateStudentQueryWithDetails(_ details: AnyObject, withStudentDict studentDict: AnyObject)
    {
        
        
        if let studentId = studentDict.object(forKey: "StudentId") as? String
        {
            if let studentDeskView  = mClassView.viewWithTag(Int(studentId)!) as? StundentDeskView
            {
                let buttonPosition :CGPoint = studentDeskView.convert(CGPoint.zero, to: self.view)
                
                let questionInfoController = StudentQueryPopover()
                //                    questionInfoController.setdelegate(self)
                
                
                
                
                questionInfoController.setQueryWithDetails(details, withStudentDetials: studentDict)
                
                
                questionInfoController.preferredContentSize = CGSize(width: 320,height: 317)
                
                 SSTeacherDataSource.sharedDataSource.mPopOverController = UIPopoverController(contentViewController: questionInfoController)
                questionInfoController.setPopover(SSTeacherDataSource.sharedDataSource.mPopOverController)
                SSTeacherDataSource.sharedDataSource.mPopOverController.contentSize = CGSize(width: 320,height: 317);
                SSTeacherDataSource.sharedDataSource.mPopOverController.delegate = self;
                
                SSTeacherDataSource.sharedDataSource.mPopOverController.present(from: CGRect(
                    x:buttonPosition.x + studentDeskView.frame.size.height / 2,
                    y:buttonPosition.y + studentDeskView.frame.size.height / 2,
                    width: 1,
                    height: 1), in: self.view, permittedArrowDirections:[.right, .left], animated: true)
                
            }
        }

        
        
        
        
        
        
         }
    
    
    // MARK: - Submission view delegate  functions
    func delegateGetaggregateWithOptionId(_ optionId: String, withView barButton: BarView) {
        
        let buttonPosition :CGPoint = barButton.convert(CGPoint.zero, to: self.view)
        
        
        
        let questionInfoController = SSTeacherAggregatePopOverController()
        questionInfoController.setdelegate(self)
        
        
        if let questionType = currentQuestionDetails.object(forKey: kQuestionType) as? String
        {
            
            questionInfoController.AggregateDrillDownWithOptionId(optionId, withQuestionDetails: currentQuestionDetails, withQuestionLogId: SSTeacherDataSource.sharedDataSource.currentQuestionLogId,withQuestionTye:questionType )
           
        }
        
        

        questionInfoController.preferredContentSize = CGSize(width: 400,height: 100)
        
         SSTeacherDataSource.sharedDataSource.mPopOverController = UIPopoverController(contentViewController: questionInfoController)
        
        SSTeacherDataSource.sharedDataSource.mPopOverController.contentSize = CGSize(width: 400,height: 100);
        SSTeacherDataSource.sharedDataSource.mPopOverController.delegate = self;
        
        SSTeacherDataSource.sharedDataSource.mPopOverController.present(from: CGRect(
            x:buttonPosition.x + barButton.frame.size.width / 2,
            y:buttonPosition.y + barButton.frame.size.height / 2,
            width: 1,
            height: 1), in: self.view, permittedArrowDirections:[.right, .left], animated: true)

        
        
    }
    
    
    func delegateTeacherEvaluatedReplyWithDetails(_ details: AnyObject, withStudentId studentId: String) {
        
        print(details)
        
        if let studentDeskView  = mClassView.viewWithTag(Int(studentId)!) as? StundentDeskView
        {
            
            if let ModelAnswerFlag = details.object(forKey: "ModelAnswerFlag") as? String
            {
                if ModelAnswerFlag == "true"
                {
                    mModelAnswerView.newModelAnswerAddedWithQuestionLogId(SSTeacherDataSource.sharedDataSource.currentQuestionLogId)
                }
            }
            
                studentDeskView.setReplayEvaluatedWithDetails(details)
        }
        
    }
    
    
    
    // MARK: - Query view delegate  functions
    
    func delegateQueryDownloadedWithDetails(_ queryDetails: AnyObject)
    {
        if let StudentId = queryDetails.object(forKey: "StudentId") as? String
        {
            if let studentDeskView  = mClassView.viewWithTag(Int(StudentId)!) as? StundentDeskView
            {
               studentDeskView.setQueryDetails(queryDetails)
                 newQueryRecieved.add(StudentId)
                
                
                if currentScreen != kQueryView
                {
                    
                    queryNotificationLabel.isHidden = false
                    
                    queryNotificationLabel.text = "\(newQueryRecieved.count)"
                }
                
            }
        }
        
    }
    
    
    func delegateQueryDeletedWithDetails(_ queryDetails: AnyObject) {
        
        if let StudentId = queryDetails.object(forKey: "StudentId") as? String
        {
            if let studentDeskView  = mClassView.viewWithTag(Int(StudentId)!) as? StundentDeskView
            {
                newQueryRecieved.remove(StudentId)
                studentDeskView.queryDismissed()
                
            }
        }
    }
    
    // MARK: - SubmissionPopover functions
    
    
func delegateAnnotateButtonPressedWithAnswerDetails(_ answerDetails:AnyObject, withStudentDetails studentDict:AnyObject, withQuestionDetails questionDetails:AnyObject, withStarRatings ratings:Int, withModelAnswer modelAnswer:Bool)
{
        let annotateView = StudentAnnotateView(frame: CGRect(x: 0, y: 0 ,width: self.view.frame.size.width,height: self.view.frame.size.height))
        self.view.addSubview(annotateView)
        annotateView.setdelegate(self)
        annotateView.setStudentDetails(studentDict, withAnswerDetails: answerDetails, withQuestionDetails: questionDetails,withStarRatings: ratings, withModelAnswer: modelAnswer)
        
    }
    
    func delegateSubmissionEvalauatedWithAnswerDetails(_ answerDetails: AnyObject, withEvaluationDetail evaluation: AnyObject, withStudentId studentId: String)
    {
       
        mSubmissionView.studentSubmissionEvaluatedWithDetails(evaluation, withStdentId: studentId)
    }
    
    // MARK: - Polling delegate functions
    func delegatePollingStartedWithOptions(_ optionsArray: NSMutableArray)
    {
        if UserDefaults.standard.bool(forKey: "isSimulateMode") == true
        {
            pollingDemoView.sendDummyPollingWithStudents(StudentsDetailsArray, withOPtionsArray: optionsArray)
        }
        
    }
    
    // MARK: - Setting controller functions
    
    func settings_setupLessonPlanClicked()
    {
        mShowTopicsView.isHidden = true
        if SSTeacherDataSource.sharedDataSource.isSubtopicStarted == false
        {
            mSubTopicsNamelabel.text = "No topic selected"
        }
        
        let mSetupLessonPlan  = SSTeacherLessonPlanView(frame: CGRect(x: 0, y: 0 ,width: self.view.frame.size.width, height: self.view.frame.size.height))
        mSetupLessonPlan.setCurrentSessionDetails(currentSessionDetails)
        self.view.addSubview(mSetupLessonPlan)
        SSTeacherDataSource.sharedDataSource.subTopicDetailsDictonary.removeAllObjects()
        mainTopicsView.mMaintopicsDetails.removeAllObjects()
    }
    
    func settings_AlphabeticalReassignseats()
    {
        
        let studentIdArray = NSMutableArray()
        
        let _seatsIdArray   = NSMutableArray()
        
        
        
        
        for indexValue in 0  ..< StudentsDetailsArray.count
        {
            let studentsDict = StudentsDetailsArray.object(at: indexValue)
            
            let seatId = seatsIdArray[indexValue]
            if let StudentId = (studentsDict as AnyObject).object(forKey: "StudentId") as? String
            {
                
                _seatsIdArray.add(seatId)
                studentIdArray.add(StudentId)
            }

        }
        
        if let sessionid = currentSessionDetails.object(forKey: kSessionId) as? String
        {

            SSTeacherDataSource.sharedDataSource.SaveSeatAssignmentWithStudentsList(studentIdArray.componentsJoined(by: ","), withSeatsIdList: _seatsIdArray.componentsJoined(by: ","), withSessionId: sessionid, withDelegate: self)
        }

        
    }
    
    func settings_RandomReasignSeats()
    {
       
        let studentIdArray = NSMutableArray()
        
        let seatsIdArray   = NSMutableArray()
        
        let subViews = mClassView.subviews.flatMap{ $0 as? StundentDeskView }
        
        for subview in subViews
        {
            if subview.isKind(of: StundentDeskView.self)
            {
                if subview.getSeatIdAndStudentId().StudentId != "0"
                {
                    seatsIdArray.add(subview.getSeatIdAndStudentId().seatId)
                    studentIdArray.add(subview.getSeatIdAndStudentId().StudentId)
                }
            }
        }
        
        
        seatsIdArray.shuffle()
       
        
        if let sessionid = currentSessionDetails.object(forKey: kSessionId) as? String
        {
            //            mDonebutton.hidden = true
            SSTeacherDataSource.sharedDataSource.SaveSeatAssignmentWithStudentsList(studentIdArray.componentsJoined(by: ","), withSeatsIdList: seatsIdArray.componentsJoined(by: ","), withSessionId: sessionid, withDelegate: self)
        }
    }
   
    
    
    func settings_ManualResignSeats() {
        
    }
    
    func settings_onQueryEnbled() {
        
    }
    
    func settings_onQuestionEnabled() {
        
    }
    
    func settings_refreshPicsClicked() {
       SSTeacherDataSource.sharedDataSource.refreshApp(success: { (response) in
            if let summary = response.object(forKey: "Summary") as? NSArray {
                if summary.count > 0 {
                    let summaryValue = summary.firstObject
                    self.evaluateStateWithSummary(details: summaryValue as AnyObject)
                }
            }
            SSTeacherDataSource.sharedDataSource.getStudentsState(SSTeacherDataSource.sharedDataSource.currentLiveSessionId, withDelegate: self)
        }) { (error) in
        }
        
    }
    
    private func evaluateStateWithSummary(details:AnyObject)
    {
        if let CurrentSessionState = details.object(forKey: "CurrentSessionState") as? Int {
            if let currentSessionID = details.object(forKey: "CurrentSessionId") as? Int {
                if currentSessionID == Int(SSTeacherDataSource.sharedDataSource.currentLiveSessionId) {
                    if CurrentSessionState != SessionState.Live.rawValue {
                        MoveToscheduleScreen()
                    }
                } else {
                   MoveToscheduleScreen()
                }
            }
            
        } else {
            MoveToscheduleScreen()
        }
    }
    
    func settings_testPingButtonClicked() {
        
    }
    
    func settings_XmppReconnectButtonClicked() {
        SSTeacherMessageHandler.sharedMessageHandler.performReconnet(connectType: "Others")
    }
    
    
    
   
    
     // MARK: - SSTeacherSchedulePopoverController Delegate  functions
    
    func delegateSessionEnded() {
        updateSessionStateToEnded()
    }
    
    func delegateMoveToScheduleScreen() {
        MoveToscheduleScreen()
    }
    func hideAllViewInTopicsView()
    {
        mainTopicsView.isHidden = true
        subTopicsView.isHidden = true
        questionTopicsView.isHidden = true
        liveQuestionView.isHidden = true
    }
    
    
    
    func downloladDemoMasterFileDetails()
    {
        
        let  url = URL(string: "\(kDemoPlistUrl)/DemoMasterDetails.plist")
        let mDemoMaseterFileDetails = plistLoader.returnDictonarywithPlistName("DemoMasterDetails.plist", with: url)
        
        if (mDemoMaseterFileDetails?.object(forKey: "DemoCollaborationSubtopicId") != nil)
        {
           if  let classCheckingVariable = mDemoMaseterFileDetails?.object(forKey: "DemoCollaborationSubtopicId") as? NSMutableArray
            {
                SSTeacherDataSource.sharedDataSource.mDemoCollaborationSubTopicArray = classCheckingVariable as! NSMutableArray
            }
            else
            {
                SSTeacherDataSource.sharedDataSource.mDemoCollaborationSubTopicArray.add(mDemoMaseterFileDetails?.object(forKey: "DemoCollaborationSubtopicId")!)
                
            }
        }
        
        
        if (mDemoMaseterFileDetails?.object(forKey: "DemoQuestionsId") != nil)
        {
            if let classCheckingVariable = mDemoMaseterFileDetails?.object(forKey: "DemoQuestionsId") as? NSMutableArray
            {
                SSTeacherDataSource.sharedDataSource.mDemoQuestionsIdArray = classCheckingVariable
            }
            else if let classCheckingVariable = mDemoMaseterFileDetails?.object(forKey: "DemoQuestionsId") as? NSMutableDictionary
            {
                SSTeacherDataSource.sharedDataSource.mDemoQuestionsIdArray.add(classCheckingVariable)
                
            }
        }
        
        if (mDemoMaseterFileDetails?.object(forKey: "DemoSubTopicsId") != nil)
        {
            if let classCheckingVariable = mDemoMaseterFileDetails?.object(forKey: "DemoSubTopicsId") as? NSMutableArray
            {
            
              SSTeacherDataSource.sharedDataSource.mDemoQuerySubTopicsArray = classCheckingVariable 
            }
            else if let classCheckingVariable = mDemoMaseterFileDetails?.object(forKey: "DemoSubTopicsId") as? NSMutableDictionary
            {
                SSTeacherDataSource.sharedDataSource.mDemoQuerySubTopicsArray.add(classCheckingVariable)
            }
        }
    }
    
    // MARK: - ModelAnswer Delegate  functions
    func delegateModelAnswerViewLoadedWithHeight(_ height: CGFloat, withCount modelCount: Int) {
        
        mModelAnswerButton.isHidden = false
        mModelAnswerButton.modelAnswerCountLabel.text = "\(modelCount)"
        
        UIView.animate(withDuration: 0.6, animations:
            {
               self.mModelAnswerView.frame = CGRect(x: self.mModelAnswerView.frame.origin.x, y: self.mModelAnswerView.frame.origin.y,width: self.mModelAnswerView.frame.size.width, height: height)
                self.mModelAnswerView.layer.cornerRadius = 5
        })
        
        if modelCount <= 0
        {
            mModelAnswerButton.isHidden = true
            mModelAnswerView.isHidden = true 
        }
        
        
        
        
    }
    
    func delegateModelAnswerViewLoadedWithHeight(_ height: CGFloat, withCount modelCount: Int, studentID : String) {
        
        mModelAnswerButton.isHidden = false
        mModelAnswerButton.modelAnswerCountLabel.text = "\(modelCount)"
        
        UIView.animate(withDuration: 0.6, animations:
            {
                self.mModelAnswerView.frame = CGRect(x: self.mModelAnswerView.frame.origin.x, y: self.mModelAnswerView.frame.origin.y,width: self.mModelAnswerView.frame.size.width, height: height)
                self.mModelAnswerView.layer.cornerRadius = 5
        })
        
        if modelCount <= 0
        {
            mModelAnswerButton.isHidden = true
            mModelAnswerView.isHidden = true
        }
        
        if let studentDeskView  = mClassView.viewWithTag(Int(studentID)!) as? StundentDeskView
        {
            for view in studentDeskView.subviews {
                if let imgView  = view as? UIImageView {
                    for view1 in imgView.subviews {
                        if let studentAnswerOptionView  = view1 as? StudentAnswerOptionsView {
                            for view2 in studentAnswerOptionView.subviews {
                                if let label  = view2 as? UILabel {
                                    if label.text?.lowercased() == "model answer" {
                                        label.removeFromSuperview()
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
        
        
    }
    
}
