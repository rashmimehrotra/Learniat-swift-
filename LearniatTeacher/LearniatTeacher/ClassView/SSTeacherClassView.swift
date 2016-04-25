

//
//  SSTeacherClassView.swift
//  Learniat Teacher
//
//  Created by Deepak MK on 23/03/16.
//  Copyright © 2016 Mindshift. All rights reserved.
//


/* NOTE
1.Chnaged live session startTime when teacher begin class

*/


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



import Foundation
class SSTeacherClassView: UIViewController,UIPopoverControllerDelegate,MainTopicsViewDelegate,SubTopicsViewDelegate,SSTeacherDataSourceDelegate,QuestionsViewDelegate,SSTeacherMessagehandlerDelegate,SSTeacherLiveQuestionControllerDelegate,StundentDeskViewDelegate,SSTeacherSubmissionViewDelegate,SSTeacherQueryViewDelegate,StudentSubjectivePopoverDelegate,SSSettingsViewControllerDelegate,SSTeacherSchedulePopoverControllerDelegate
{
   
    
    
    var mTeacherImageView: UIImageView!
    
    var mTopbarImageView: UIImageView!
    
    
    var mTeacherImageButton = UIButton()
    
     var mBottombarImageView: UIImageView!
    
    var mClassName: UILabel!
    
    var mStartTimeLabel = UILabel()
    
    let dateFormatter = NSDateFormatter()
    
    var mStartLabelUpdater                    = NSTimer()
    
    var currentSessionDetails           :AnyObject!
    
    var currentSessionId               = ""
    
    var mSubTopicsNamelabel                  = UILabel()
    
    var mQuestionNamelabel                   = UILabel()
    
    var currentQuestionDetails              :AnyObject!
    
    var mainTopicsView              :  MainTopicsView!
    
    var subTopicsView               :  SubTopicsView!
    
    var questionTopicsView          :  QuestionsView!
    
    let liveQuestionController      =  SSTeacherLiveQuestionController()
    
    var startedSubTopicDetails:AnyObject!
    
    
    var startedMainTopicID          = ""
    
    var startedMainTopicName        = ""
    
    var currentQuestionLogId        = ""
    
    var isQuestionSent              :Bool = false
    
    var currentCumulativeTime       :String   = ""
    
    var classViewPopOverController  :UIPopoverController!
    
    var cumulativeTimer                    = NSTimer()
    
    var  mTopicButton:UIButton!
    
    var mClassView                      = UIView()
    
    var mSubmissionView                 = SSTeacherSubmissionView()
    
    var mQueryView                      = SSTeacherQueryView()
    
    var StudentsDetailsArray                = NSMutableArray()
    
    var mClassViewButton                    = UIButton()
    
    var mQuestionViewButton                 = UIButton()
    
    var mQueryViewButton                    = UIButton()
    
    var tabPlaceHolderImage                 = UIImageView()
    
    var currentStudentsDict                 = NSMutableDictionary()
    
    var currentScreen                       = kClassView
    
    var mActivityIndicatore :UIActivityIndicatorView = UIActivityIndicatorView()
    
    var submissionNotificationLabel             = UILabel()
    
    
    var queryNotificationLabel                  = UILabel()
    
    var newSubmissionRecieved               = NSMutableArray()
    
    var newQueryRecieved                    = NSMutableArray()
    
     var seatsIdArray                       = [String]()
    
    var mRemainingTimeProgressBar           = UIProgressView()
    
    
    var mShowTopicsView                         = UIView()
    
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.view.backgroundColor = whiteBackgroundColor
        
        
        self.view.setNeedsLayout()
        self.view.layoutIfNeeded()
        
        
        SSTeacherMessageHandler.sharedMessageHandler.setdelegate(self)
        
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        mTopbarImageView = UIImageView(frame: CGRectMake(0, 0, self.view.frame.size.width, 70))
        mTopbarImageView.backgroundColor = topbarColor
        self.view.addSubview(mTopbarImageView)
        mTopbarImageView.userInteractionEnabled = true
        
        
        mBottombarImageView = UIImageView(frame: CGRectMake(0, self.view.frame.size.height - 60, self.view.frame.size.width, 60))
        mBottombarImageView.backgroundColor = topbarColor
        self.view.addSubview(mBottombarImageView)
        mBottombarImageView.userInteractionEnabled = true
        
        
       
        
        
        
        mRemainingTimeProgressBar.userInteractionEnabled = false;
        mBottombarImageView.addSubview(mRemainingTimeProgressBar)
        mRemainingTimeProgressBar.frame  = CGRectMake(0, mBottombarImageView.frame.size.height - 4 , mBottombarImageView.frame.size.width, 1)
        mRemainingTimeProgressBar.progressTintColor = standard_Button;
        let transform: CGAffineTransform = CGAffineTransformMakeScale(1.0, 2);
        mRemainingTimeProgressBar.transform = transform;
        
        
        
        
        mBottombarImageView.addSubview(tabPlaceHolderImage)
        tabPlaceHolderImage.backgroundColor = UIColor(red: 39/255.0, green:68/255.0, blue:98/255.0, alpha: 1)
        tabPlaceHolderImage.layer.cornerRadius = 5
        tabPlaceHolderImage.layer.masksToBounds = true
        
        
        mQuestionViewButton.frame  = CGRectMake((mBottombarImageView.frame.size.width - 150)/2  , 0, 150, mBottombarImageView.frame.size.height)
        mBottombarImageView.addSubview(mQuestionViewButton)
        mQuestionViewButton.addTarget(self, action: #selector(SSTeacherClassView.onQuestionsView), forControlEvents: UIControlEvents.TouchUpInside)
        mQuestionViewButton.backgroundColor = UIColor.clearColor()
        mQuestionViewButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        mQuestionViewButton.setTitle("Submission", forState: .Normal)
        mQuestionViewButton.titleLabel?.font = UIFont(name: helveticaMedium, size: 18)
        
        submissionNotificationLabel.frame = CGRectMake(mQuestionViewButton.frame.origin.x + mQuestionViewButton.frame.size.width - 25 , mQuestionViewButton.frame.origin.y + 5 , 40, 30)
        submissionNotificationLabel.backgroundColor = standard_Red
        submissionNotificationLabel.textColor = UIColor.whiteColor()
        mBottombarImageView.addSubview(submissionNotificationLabel)
        submissionNotificationLabel.layer.cornerRadius = 11.0;
        submissionNotificationLabel.layer.masksToBounds = true;
        submissionNotificationLabel.text = "0"
        submissionNotificationLabel.font = UIFont(name: helveticaBold, size: 20)
        submissionNotificationLabel.textAlignment = .Center
        submissionNotificationLabel.hidden = true
        
        
        
        
        mClassViewButton.frame  = CGRectMake(mQuestionViewButton.frame.origin.x - (mQuestionViewButton.frame.size.width + 10)  , 0, mQuestionViewButton.frame.size.width, mQuestionViewButton.frame.size.height)
        mBottombarImageView.addSubview(mClassViewButton)
        mClassViewButton.addTarget(self, action: #selector(SSTeacherClassView.onClassView), forControlEvents: UIControlEvents.TouchUpInside)
        mClassViewButton.backgroundColor = UIColor.clearColor()
        mClassViewButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        mClassViewButton.setTitle("Class view", forState: .Normal)
        mClassViewButton.titleLabel?.font = UIFont(name: helveticaMedium, size: 18)
        
        tabPlaceHolderImage.frame = CGRectMake(mClassViewButton.frame.origin.x  , 10, mQuestionViewButton.frame.size.width, mQuestionViewButton.frame.size.height - 20 )
       
        mQueryViewButton.frame  = CGRectMake(mQuestionViewButton.frame.origin.x + (mQuestionViewButton.frame.size.width + 10)  , 0, mQuestionViewButton.frame.size.width, mQuestionViewButton.frame.size.height)
        mBottombarImageView.addSubview(mQueryViewButton)
        mQueryViewButton.addTarget(self, action: #selector(SSTeacherClassView.onQueryView), forControlEvents: UIControlEvents.TouchUpInside)
        mQueryViewButton.backgroundColor = UIColor.clearColor()
        mQueryViewButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        mQueryViewButton.setTitle("Query", forState: .Normal)
        mQueryViewButton.titleLabel?.font = UIFont(name: helveticaMedium, size: 18)
        
        
        
        
        
        
        queryNotificationLabel.frame = CGRectMake(mQueryViewButton.frame.origin.x + mQueryViewButton.frame.size.width - 25 , mQueryViewButton.frame.origin.y + 5 , 40, 30)
        queryNotificationLabel.backgroundColor = standard_Red
        queryNotificationLabel.textColor = UIColor.whiteColor()
        mBottombarImageView.addSubview(queryNotificationLabel)
        queryNotificationLabel.layer.cornerRadius = 11.0;
        queryNotificationLabel.layer.masksToBounds = true;
        queryNotificationLabel.text = "0"
        queryNotificationLabel.font = UIFont(name: helveticaBold, size: 20)
        queryNotificationLabel.textAlignment = .Center
        queryNotificationLabel.hidden = true
        
        
        
        
        
        mClassView.frame = CGRectMake(0, mTopbarImageView.frame.origin.y + mTopbarImageView.frame.size.height , self.view.frame.size.width , self.view.frame.size.height - (mTopbarImageView.frame.origin.y + mTopbarImageView.frame.size.height + mBottombarImageView.frame.size.height ))
        self.view.addSubview(mClassView)
        mClassView.backgroundColor = whiteBackgroundColor
        mClassView.hidden = true
        mClassView.userInteractionEnabled = true
        
        
        
        
        mSubmissionView.frame = CGRectMake(0, mTopbarImageView.frame.origin.y + mTopbarImageView.frame.size.height , self.view.frame.size.width , self.view.frame.size.height - (mTopbarImageView.frame.origin.y + mTopbarImageView.frame.size.height + mBottombarImageView.frame.size.height ))
        self.view.addSubview(mSubmissionView)
        mSubmissionView.backgroundColor = whiteBackgroundColor
        mSubmissionView.hidden = true
        mSubmissionView.userInteractionEnabled = true
        mSubmissionView.setdelegate(self)
        mSubmissionView.loadViewWithDetails()
        
        
        
        
        
        
        
        
        
        mQueryView.frame = CGRectMake(0, mTopbarImageView.frame.origin.y + mTopbarImageView.frame.size.height , self.view.frame.size.width , self.view.frame.size.height - (mTopbarImageView.frame.origin.y + mTopbarImageView.frame.size.height + mBottombarImageView.frame.size.height ))
        self.view.addSubview(mQueryView)
        mQueryView.backgroundColor = whiteBackgroundColor
        mQueryView.hidden = true
        mQueryView.userInteractionEnabled = true
        mQueryView.setdelegate(self)
        

        
        
        
        mTeacherImageView = UIImageView(frame: CGRectMake(15, 20, 40 ,40))
        mTeacherImageView.backgroundColor = lightGrayColor
        mTopbarImageView.addSubview(mTeacherImageView)
        mTeacherImageView.layer.masksToBounds = true
        mTeacherImageView.layer.cornerRadius = 2
        
        
        let urlString = NSUserDefaults.standardUserDefaults().objectForKey(k_INI_UserProfileImageURL) as! String
        
        if let checkedUrl = NSURL(string: "\(urlString)/\(SSTeacherDataSource.sharedDataSource.currentUserId)_79px.jpg")
        {
            mTeacherImageView.contentMode = .ScaleAspectFit
            mTeacherImageView.downloadImage(checkedUrl, withFolderType: folderType.ProFilePics)
        }
        
        
        mTeacherImageButton.frame = CGRectMake(0, 0, 40 , mTopbarImageView.frame.size.height)
        mTopbarImageView.addSubview(mTeacherImageButton)
        mTeacherImageButton.addTarget(self, action: #selector(SSTeacherClassView.onTeacherImage), forControlEvents: UIControlEvents.TouchUpInside)

        
        
      let  mSchedulePopoverButton = UIButton(frame: CGRectMake(mTeacherImageView.frame.origin.x + mTeacherImageView.frame.size.width + 10,  mTeacherImageView.frame.origin.y, 250 , 50))
        mTopbarImageView.addSubview(mSchedulePopoverButton)
        mSchedulePopoverButton.addTarget(self, action: #selector(SSTeacherClassView.onScheduleScreenPopupPressed(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        mSchedulePopoverButton.backgroundColor = standard_Button
        mSchedulePopoverButton.layer.cornerRadius = 2
        mSchedulePopoverButton.layer.masksToBounds = true
        
        mClassName = UILabel(frame: CGRectMake(mSchedulePopoverButton.frame.origin.x + 10, mSchedulePopoverButton.frame.origin.y + 5 , 230, 20))
        
        
        mClassName.font = UIFont(name:helveticaBold, size: 14)
        mTopbarImageView.addSubview(mClassName)
        mClassName.textColor = UIColor.whiteColor()
       
        mStartTimeLabel.frame = CGRectMake(mSchedulePopoverButton.frame.origin.x + 10, mClassName.frame.origin.y + mClassName.frame.size.height , 230, 20)
        mStartTimeLabel.font = UIFont(name:helveticaRegular, size: 12)
        mTopbarImageView.addSubview(mStartTimeLabel)
        mStartTimeLabel.textColor = UIColor.whiteColor()
        
        
        
         mTopicButton = UIButton(frame: CGRectMake(mTopbarImageView.frame.size.width - (mSchedulePopoverButton.frame.size.width + 10 ),  mSchedulePopoverButton.frame.origin.y, mSchedulePopoverButton.frame.size.width , mSchedulePopoverButton.frame.size.height))
        mTopbarImageView.addSubview(mTopicButton)
        mTopicButton.addTarget(self, action: #selector(SSTeacherClassView.onTopicsButton(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        mTopicButton.backgroundColor = standard_Button
        mTopicButton.layer.cornerRadius = 2
        mTopicButton.layer.masksToBounds = true
        
        
        mShowTopicsView.frame = CGRectMake(self.view.frame.size.width - 600, mTopbarImageView.frame.origin.y + mTopbarImageView.frame.size.height , 600, 680)
        
        mShowTopicsView.backgroundColor = UIColor.whiteColor()
        mShowTopicsView.layer.shadowColor = UIColor.blackColor().CGColor
        mShowTopicsView.layer.shadowOpacity = 0.3
        mShowTopicsView.layer.shadowOffset = CGSizeZero
        mShowTopicsView.layer.shadowRadius = 10
        mShowTopicsView.hidden = true
        self.view.addSubview(mShowTopicsView)
        
        
        
        
        mSubTopicsNamelabel = UILabel(frame: CGRectMake(10, 5 , mTopicButton.frame.size.width - 20, 20))
        mSubTopicsNamelabel.font = UIFont(name:helveticaBold, size: 14)
        mTopicButton.addSubview(mSubTopicsNamelabel)
        mSubTopicsNamelabel.textColor = UIColor.whiteColor()
        mSubTopicsNamelabel.text = "No topic selected"
        mSubTopicsNamelabel.textAlignment = .Right
        
        
        
        mQuestionNamelabel = UILabel(frame: CGRectMake(mSubTopicsNamelabel.frame.origin.x , mSubTopicsNamelabel.frame.origin.y + mSubTopicsNamelabel.frame.size.height , mSubTopicsNamelabel.frame.size.width, 20))
        mQuestionNamelabel.font = UIFont(name:helveticaRegular, size: 12)
        mTopicButton.addSubview(mQuestionNamelabel)
        mQuestionNamelabel.textColor = UIColor.whiteColor()
        mQuestionNamelabel.text = "No active question"
        mQuestionNamelabel.textAlignment = .Right
        
        
      
        
        mStartLabelUpdater.invalidate()
        mStartLabelUpdater = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: #selector(SSTeacherClassView.updateStartLabelTime), userInfo: nil, repeats: true)
        
        
        mActivityIndicatore = UIActivityIndicatorView(activityIndicatorStyle: .Gray)
        mActivityIndicatore.frame = CGRectMake((self.view.frame.size.width - 60)/2, (self.view.frame.size.height - 60)/2, 60, 60)
        self.view.addSubview(mActivityIndicatore)
        
        
       
        addAllDetailsOfSession()
        
        
        
    }

    func setSessionDetails(details:AnyObject)
    {
        currentSessionDetails = details
        
    }
    
    
    func addAllDetailsOfSession()
    {
        if let sessionId = (currentSessionDetails.objectForKey(kSessionId)) as? String
        {
            currentSessionId = sessionId
            SSTeacherDataSource.sharedDataSource.currentLiveSessionId = sessionId
        }

        
        if let className = currentSessionDetails.objectForKey("ClassName") as? String
        {
            
            if var roomName = currentSessionDetails.objectForKey("RoomName") as? String
            {
                
                roomName = roomName.stringByReplacingOccurrencesOfString("Room ", withString: "")
                
                mClassName.text = "\(className)(R:\(roomName))"
            }
            else
            {
                mClassName.text = className
            }
            
        }
        
        if let  StartTime = currentSessionDetails.objectForKey("StartTime") as? String
        {
            
            var _string :String = ""
            let currentDate = NSDate()
           
            
//            if isGreater == true
//            {
//                StartTime = dateFormatter.stringFromDate(currentDate)
//                currentSessionDetails.setObject(StartTime, forKey: "StartTime")
//                
//                
//            }
            
            
            _string = _string.stringFromTimeInterval(currentDate.timeIntervalSinceDate(dateFormatter.dateFromString(StartTime)!)).fullString
            mStartTimeLabel.text = "Started: \(_string)"
        }
        
        
        
        if let  StartTime = currentSessionDetails.objectForKey("StartTime") as? String
        {
         
            if let  EndTime = currentSessionDetails.objectForKey("EndTime") as? String
            {
                 let currentDate = NSDate()
                
                   var totalminutesRemaining = currentDate.minutesDiffernceBetweenDates(dateFormatter.dateFromString(StartTime)!, endDate: dateFormatter.dateFromString(EndTime )!)
                
                totalminutesRemaining = totalminutesRemaining * 60
                
                
                
                 var minutesRemaining = currentDate.minutesDiffernceBetweenDates(dateFormatter.dateFromString(StartTime )!, endDate:currentDate )
                
                
                minutesRemaining = minutesRemaining * 60
                
                
                let progressValue :CGFloat = CGFloat(minutesRemaining) / CGFloat(totalminutesRemaining)
                mRemainingTimeProgressBar.progress = Float(progressValue)
                
                
                
                
                
            }
        }
        
        
        mainTopicsView  = MainTopicsView(frame: CGRectMake(0,0, 600   ,44))
        mainTopicsView.setSessionDetails(currentSessionDetails)
        mainTopicsView.setdelegate(self)
        mShowTopicsView.addSubview(mainTopicsView)
        mainTopicsView.hidden = true
        
        subTopicsView = SubTopicsView(frame:CGRectMake(0,0, 600   ,44))
        subTopicsView.setSessionDetails(currentSessionDetails)
        subTopicsView.setdelegate(self)
        mShowTopicsView.addSubview(subTopicsView)
        mShowTopicsView.hidden = true
        
        
        
        
        questionTopicsView = QuestionsView(frame:CGRectMake(0,0, 600   ,44))
        questionTopicsView.setSessionDetails(currentSessionDetails)
        questionTopicsView.setdelegate(self)
        mShowTopicsView.addSubview(questionTopicsView)
        questionTopicsView.hidden = true
        
        
        
        liveQuestionController.setPreferredSize(CGSizeMake(450, 350),withSessionDetails: currentSessionDetails)
        
        
        
        if let roomId = currentSessionDetails.objectForKey("RoomId") as? String
        {
            SSTeacherDataSource.sharedDataSource.getGridDesignDetails(roomId, WithDelegate: self)
            mActivityIndicatore.startAnimating()
            mActivityIndicatore.hidden = false
        }
        
        
        SSTeacherMessageHandler.sharedMessageHandler.createRoomWithRoomName("question_\(currentSessionId)", withHistory: "0")
        
        
    }
    
    
    func onScheduleScreenPopupPressed(sender:UIButton)
    {
        let questionInfoController = SSTeacherSchedulePopoverController()
        questionInfoController.setdelegate(self)
        
        let height = self.view.frame.size.height - (mTopbarImageView.frame.size.height + 20 )
        questionInfoController.setdelegate(self)
        questionInfoController.setCurrentScreenSize(CGSizeMake(600,height))
        questionInfoController.preferredContentSize = CGSizeMake(600,height)
        
        let   classViewPopOverController = UIPopoverController(contentViewController: questionInfoController)
        questionInfoController.setPopover(classViewPopOverController)
        classViewPopOverController.popoverContentSize = CGSizeMake(600,height);
        classViewPopOverController.delegate = self;
        
        classViewPopOverController.presentPopoverFromRect(CGRect(
            x:sender.frame.origin.x + sender.frame.size.width / 2,
            y:sender.frame.origin.y + sender.frame.size.height,
            width: 1,
            height: 1), inView: self.view, permittedArrowDirections: .Up, animated: true)

    }
    
    
// MARK: - StartTime updating
    
    func updateStartLabelTime()
    {
        if let StartTime = currentSessionDetails.objectForKey("StartTime") as? String
        {
            
            var _string :String = ""
            let currentDate = NSDate()
            
            _string = _string.stringFromTimeInterval(currentDate.timeIntervalSinceDate(dateFormatter.dateFromString(StartTime)!)).fullString
            mStartTimeLabel.text = "Started: \(_string)"
            
            
            
            if let  EndTime = currentSessionDetails.objectForKey("EndTime") as? String
            {

                var totalminutesRemaining = currentDate.minutesDiffernceBetweenDates(dateFormatter.dateFromString(StartTime)!, endDate: dateFormatter.dateFromString(EndTime )!)
                
                totalminutesRemaining = totalminutesRemaining * 60
                
                
                
                var minutesRemaining = currentDate.minutesDiffernceBetweenDates(dateFormatter.dateFromString(StartTime )!, endDate:currentDate )
                
                
                minutesRemaining = minutesRemaining * 60
                
                
                let progressValue :CGFloat = CGFloat(minutesRemaining) / CGFloat(totalminutesRemaining)
                mRemainingTimeProgressBar.progress = Float(progressValue)
                
            }
            
        }
    }
    

    // MARK: - Buttons Functions
    
    func onTeacherImage()
    {
        let questionInfoController = SSSettingsViewController()
        questionInfoController.setDelegate(self)
        
        questionInfoController.ClassViewTopicsButtonSettingsButtonPressed();

        let   classViewPopOverController = UIPopoverController(contentViewController: questionInfoController)
        
        classViewPopOverController.popoverContentSize = CGSizeMake(310, 444);
        classViewPopOverController.delegate = self;
        questionInfoController.setPopOverController(classViewPopOverController)
        
        
        if (newSubmissionRecieved.count <= 0 && newQueryRecieved.count <= 0 && SSTeacherDataSource.sharedDataSource.isSubtopicStarted == false)
        {
            questionInfoController.setupTopicsButton.enabled = true;
            questionInfoController.setupTopicsButton.setTitleColor(standard_Button,forState:.Normal);
            
            questionInfoController.manualResignButton.enabled = true
            questionInfoController.manualResignButton.setTitleColor(standard_Button, forState:.Normal);
            
            
            
            questionInfoController.randomReassignButton.enabled = true
            questionInfoController.randomReassignButton.setTitleColor(standard_Button, forState:.Normal);
            
           
            questionInfoController.alphabeticalReassignButton.enabled = true
            questionInfoController.alphabeticalReassignButton.setTitleColor(standard_Button, forState:.Normal);

            questionInfoController.pullNewProfilePics.enabled = true
            questionInfoController.pullNewProfilePics.setTitleColor(standard_Button, forState:.Normal);
            
            
        }
        else
        {
            
            
            questionInfoController.setupTopicsButton.enabled = false;
            questionInfoController.setupTopicsButton.setTitleColor(lightGrayColor,forState:.Normal);
            
            
            questionInfoController.manualResignButton.enabled = false;
            questionInfoController.manualResignButton.setTitleColor(lightGrayColor,forState:.Normal);


            questionInfoController.randomReassignButton.enabled = false;
            questionInfoController.randomReassignButton.setTitleColor(lightGrayColor,forState:.Normal);
            
            questionInfoController.alphabeticalReassignButton.enabled = false;
            questionInfoController.alphabeticalReassignButton.setTitleColor(lightGrayColor,forState:.Normal);
            
            questionInfoController.pullNewProfilePics.enabled = false;
            questionInfoController.pullNewProfilePics.setTitleColor(lightGrayColor,forState:.Normal);
            
        }
        
        
        
        
        classViewPopOverController.presentPopoverFromRect(CGRect(
            x:mTeacherImageButton.frame.origin.x ,
            y:mTeacherImageButton.frame.origin.y + mTeacherImageButton.frame.size.height,
            width: 1,
            height: 1), inView: self.view, permittedArrowDirections: .Up, animated: true)
        
        
        
        
        
        
        
        
        
        
        

    }
    
    func onClassView()
    {
         tabPlaceHolderImage.frame = CGRectMake(mClassViewButton.frame.origin.x  , 10, mQuestionViewButton.frame.size.width, mQuestionViewButton.frame.size.height - 20 )
        currentScreen  = kClassView
        
        mClassView.hidden      = false
        mSubmissionView.hidden = true
        mQueryView.hidden      = true
    }
    
    func onQuestionsView()
    {
         tabPlaceHolderImage.frame = CGRectMake(mQuestionViewButton.frame.origin.x  , 10, mQuestionViewButton.frame.size.width, mQuestionViewButton.frame.size.height - 20 )
        
        mClassView.hidden      = true
        mSubmissionView.hidden = false
        mQueryView.hidden      = true
        currentScreen  = kSubmissionView
        
        submissionNotificationLabel.hidden = true
        
        if newSubmissionRecieved.count > 0
        {

            for index in 0 ..< newSubmissionRecieved.count
            {
                
                if let studentId = newSubmissionRecieved.objectAtIndex(index) as? String
                {
                    SSTeacherMessageHandler.sharedMessageHandler.sendHandRaiseReceivedMessageToStudentWithId(studentId)
                }
                
               
            }
            
            
            
            newSubmissionRecieved.removeAllObjects()
        }
        

    }
    
    func onQueryView()
    {
         tabPlaceHolderImage.frame = CGRectMake(mQueryViewButton.frame.origin.x  , 10, mQuestionViewButton.frame.size.width, mQuestionViewButton.frame.size.height - 20 )
      
        mClassView.hidden      = true
        mSubmissionView.hidden = true
        mQueryView.hidden      = false
        currentScreen  = kQueryView
        
        queryNotificationLabel.hidden = true
        if newQueryRecieved.count > 0
        {
            SSTeacherMessageHandler.sharedMessageHandler.sendQueryRecievedMessageToRoom(currentSessionId)
            
            newQueryRecieved.removeAllObjects()
        }
        
        
    }
    
    
    
    
// MARK: - datasource delegate functions
    
    
    
    func didGetGridDesignWithDetails(details: AnyObject) {
        
        let subViews = mClassView.subviews.flatMap{ $0 as? StundentDeskView }
        
        for subview in subViews
        {
            if subview.isKindOfClass(StundentDeskView)
            {
               subview.removeFromSuperview()
            }
        }
        
        arrangegridWithDetails(details)
    }
    
    
    func didGetSeatAssignmentSavedWithDetails(details: AnyObject)
    {
        
        
        if let sessionid = currentSessionDetails.objectForKey(kSessionId) as? String
        {
            
            if let RoomName = currentSessionDetails.objectForKey("RoomName") as? String
            {
                SSTeacherMessageHandler.sharedMessageHandler.sendSeatingChangedtoRoom(sessionid, withSeatName: "A2", withRoomName: RoomName)
            }
            else
            {
                SSTeacherMessageHandler.sharedMessageHandler.sendSeatingChangedtoRoom(sessionid, withSeatName: "A2", withRoomName: "")
            }
            
            SSTeacherDataSource.sharedDataSource.getStudentsInfoWithSessionId(currentSessionId, withDelegate: self)
            
            if let roomId = currentSessionDetails.objectForKey("RoomId") as? String
            {
                SSTeacherDataSource.sharedDataSource.getGridDesignDetails(roomId, WithDelegate: self)
                mActivityIndicatore.startAnimating()
                mActivityIndicatore.hidden = false
            }

        }
    }

    
    
    func didGetSeatAssignmentWithDetails(details: AnyObject)
    {
        
        
    }
    func didGetStudentsInfoWithDetails(details: AnyObject) {
        
        arranageSeatsWithDetails(details)
    }
    
    
    func didGetSubtopicStartedWithDetails(details: AnyObject)
    {
        
    }
    
    func didGetQuestionSentWithDetails(details: AnyObject) {
        
        
        if let QuestionLogId = details.objectForKey("QuestionLogId") as? String
        {
            
            isQuestionSent = true
            
            currentQuestionLogId = QuestionLogId
            
            
            if let Type = currentQuestionDetails.objectForKey("Type") as? String
            {
                SSTeacherMessageHandler.sharedMessageHandler.sendQuestionWithRoomName("question_\(currentSessionId)", withQuestionLogId: currentQuestionLogId, withQuestionType: Type)
                
                if let questionType = currentQuestionDetails.objectForKey("Type") as? String
                {
                    
                    if (questionType  == kOverlayScribble  || questionType == kFreshScribble)
                    {
                       mSubmissionView.addScribbleQuestionWithDetails(currentQuestionDetails)
                    }
                    else if (questionType == kText)
                    {
                         mSubmissionView.addScribbleQuestionWithDetails(currentQuestionDetails)
                    }
                    else if (questionType == kMatchColumn)
                    {
                         mSubmissionView.addMTCQuestionWithDetails(currentQuestionDetails)
                    }
                    else
                    {
                        mSubmissionView.addMRQQuestionWithDetails(currentQuestionDetails)
                        
                    }
                }
            }
        }
    }
    
    
    func didGetSessionUpdatedWithDetials(details: AnyObject)
    {
        let scheduleScreenView  = TeacherScheduleViewController()
        presentViewController(scheduleScreenView, animated: true, completion: nil)
    }
    
    
// MARK: - seatAssignment functions
    
    
    func arrangegridWithDetails(details:AnyObject)
    {
        var columnValue         = 1
        var rowValue            = 1
       
//        var seatsLableArray     = [String]()
        var seatsRemovedArray   = [String]()
        
        
        if let Columns = details.objectForKey("Columns") as? String
        {
            columnValue = Int(Columns)!
        }
        
        if let Rows = details.objectForKey("Rows") as? String
        {
            rowValue = Int(Rows)!
        }
        
        if let SeatIdList = details.objectForKey("SeatIdList") as? String
        {
            seatsIdArray =  SeatIdList.componentsSeparatedByString(",")
        }
        
//        if let SeatLabelList = details.objectForKey("SeatLabelList") as? String
//        {
//            seatsLableArray =  SeatLabelList.componentsSeparatedByString(",")
//        }
        
        if let SeatsRemoved = details.objectForKey("SeatsRemoved") as? String
        {
            seatsRemovedArray =  SeatsRemoved.componentsSeparatedByString(",")
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
            
            let backGroundImageView = UIImageView(frame:  CGRectMake(0, postionY - barHeightSpace, mClassView.frame.size.width, barHeight + barHeightSpace) )
            if (columnIndex%2==0)
            {
                backGroundImageView.backgroundColor = UIColor.whiteColor()
                
            }
            else
            {
                backGroundImageView.backgroundColor = UIColor(red: 249/255.0, green:249/255.0, blue:249/255.0, alpha: 1)
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
                    let seatView = StundentDeskView(frame: CGRectMake(positionX, postionY, barWidthvalue, barHeight))
                    seatView.setdelegate(self)
                    mClassView.addSubview(seatView)
                    seatView.tag  = totalSeatvalue
                    seatView.backgroundColor = UIColor.clearColor()
                }
                
                positionX = positionX + barWidthvalue + barWidthSpace
                totalSeatvalue = totalSeatvalue - 1
                
            }
            postionY = postionY + barHeight + barHeightSpace
            
        }
        
        
        SSTeacherDataSource.sharedDataSource.getStudentsInfoWithSessionId(currentSessionId, withDelegate: self)
       

    }
    
    func arranageSeatsWithDetails(details:AnyObject)
    {
        
        
        if let statusString = details.objectForKey("Status") as? String
        {
            if statusString == kSuccessString
            {
                
                let classCheckingVariable = details.objectForKey("Students")!.objectForKey("Student")!
                
                if classCheckingVariable.isKindOfClass(NSMutableArray)
                {
                    StudentsDetailsArray = classCheckingVariable as! NSMutableArray
                }
                else
                {
                    StudentsDetailsArray.addObject(details.objectForKey("Students")!.objectForKey("Student")!)
                    
                }
            }
        }
        
        
        for indexValue in 0  ..< StudentsDetailsArray.count
        {
            let studentsDict = StudentsDetailsArray.objectAtIndex(indexValue)
            
            if var seatlabel = studentsDict.objectForKey("SeatLabel") as? String
            {
                seatlabel = seatlabel.stringByReplacingOccurrencesOfString("A", withString: "")
                
               if let studentDeskView  = mClassView.viewWithTag(Int(seatlabel)!) as? StundentDeskView
               {
                    studentDeskView.setStudentsDetails(studentsDict)
                    if let StudentId = studentsDict.objectForKey("StudentId") as? String
                    {
                            studentDeskView.tag = Int(StudentId)!
                    }
                }
                
                
            }
        }
        
        
        mClassView.hidden = false
        mActivityIndicatore.stopAnimating()
        mActivityIndicatore.hidden = true

    }
    
    
// MARK: - buttons functions
    func onTopicsButton(sender:UIButton)
    {
        
        
        mShowTopicsView.hidden = false
        self.view.bringSubviewToFront(mShowTopicsView)
        
        
        if SSTeacherDataSource.sharedDataSource.isSubtopicStarted == false
        {
          
            
            mainTopicsView.getTopicsDetailswithStartedMaintopicId("")
             mShowTopicsView.frame = CGRectMake(mShowTopicsView.frame.origin.x, mShowTopicsView.frame.origin.y , mShowTopicsView.frame.size.width  , mainTopicsView.currentMainTopicsViewHeight)
            mainTopicsView.hidden = false
            subTopicsView.hidden = true
            questionTopicsView.hidden = true
            mShowTopicsView.bringSubviewToFront(mainTopicsView)
           
            
            
            
        }
        else if SSTeacherDataSource.sharedDataSource.isSubtopicStarted == true
        {
            
            
            subTopicsView.frame = CGRectMake(0,0, 600   ,44)
            subTopicsView.getSubtopicsDetailsWithMainTopicId(SSTeacherDataSource.sharedDataSource.startedMainTopicId, withMainTopicName: SSTeacherDataSource.sharedDataSource.startedMainTopicName,withStartedSubtopicID:SSTeacherDataSource.sharedDataSource.startedSubTopicId
            )
            subTopicsView.hidden = false
            mainTopicsView.hidden = true
             questionTopicsView.hidden = true
            mShowTopicsView.bringSubviewToFront(subTopicsView)
            
            
            mShowTopicsView.frame = CGRectMake(mShowTopicsView.frame.origin.x, mShowTopicsView.frame.origin.y , mShowTopicsView.frame.size.width  , subTopicsView.currentMainTopicsViewHeight)
        }
//        else  if isQuestionSent == true
//        {
//            liveQuestionController.setdelegate(self)
//            liveQuestionController.preferredContentSize = CGSizeMake(450, 350)
//            
//            classViewPopOverController = UIPopoverController(contentViewController: liveQuestionController)
//            
//            liveQuestionController.setPopover(classViewPopOverController)
//            
//            liveQuestionController.setQuestionDetails(currentQuestionDetails, withMainTopciName: subTopicsController.mTopicName.text!, withMainTopicId: subTopicsController.currentMainTopicId)
//            classViewPopOverController.popoverContentSize = CGSizeMake(450, 350);
//            classViewPopOverController.delegate = self;
//            
//            classViewPopOverController.presentPopoverFromRect(CGRect(
//                x: mTopicButton.frame.origin.x + mTopicButton.frame.size.width / 2 ,
//                y: mTopicButton.frame.origin.y + mTopicButton.frame.size.height,
//                width: 1,
//                height: 1), inView: self.view, permittedArrowDirections: .Up, animated: true)
//
//        }
//        else
//        {
//           
//            
//           
//            
//            
//            subTopicsController.setdelegate(self)
//            subTopicsController.preferredContentSize = CGSizeMake(600, 44)
//              subTopicsController.getSubtopicsDetailsWithMainTopicId(startedMainTopicID, withMainTopicName: startedMainTopicName, withStartedSubtopicID: startedSubTopicID, withCumulativeTime: currentCumulativeTime)
//            classViewPopOverController = UIPopoverController(contentViewController: subTopicsController)
//            subTopicsController.setPopover(classViewPopOverController)
//            classViewPopOverController.popoverContentSize = CGSizeMake(540, 680);
//            classViewPopOverController.delegate = self;
//            
//            classViewPopOverController.presentPopoverFromRect(CGRect(
//                x: mTopicButton.frame.origin.x + mTopicButton.frame.size.width / 2 ,
//                y: mTopicButton.frame.origin.y + mTopicButton.frame.size.height,
//                width: 1,
//                height: 1), inView: self.view, permittedArrowDirections: .Up, animated: true)
//            cumulativeTimer.invalidate()
//        }
//        
//        
//        if classViewPopOverController.popoverVisible == false
//        {
//            
//            mainTopicsController.setdelegate(self)
//            mainTopicsController.preferredContentSize = CGSizeMake(600, 44)
//            mainTopicsController.getTopicsDetailswithStartedMaintopicId(startedMainTopicID)
//            
//            classViewPopOverController = UIPopoverController(contentViewController: mainTopicsController)
//            mainTopicsController.setPopover(classViewPopOverController)
//            classViewPopOverController.popoverContentSize = CGSizeMake(540, 680);
//            classViewPopOverController.delegate = self;
//            
//            classViewPopOverController.presentPopoverFromRect(CGRect(
//                x: mTopicButton.frame.origin.x + mTopicButton.frame.size.width / 2 ,
//                y: mTopicButton.frame.origin.y + mTopicButton.frame.size.height,
//                width: 1,
//                height: 1), inView: self.view, permittedArrowDirections: .Up, animated: true)
//        }
//        
//        
        
        
    }

    
    
// MARK: - MainTopic delegate functions
    
    
    func delegateTopicsSizeChangedWithHeight(height: CGFloat)
    {
        UIView.animateWithDuration(0.5, animations:
            {
                self.mShowTopicsView.frame = CGRectMake(self.mShowTopicsView.frame.origin.x, self.mShowTopicsView.frame.origin.y , self.mShowTopicsView.frame.size.width  , height)
        })
        
        
        
        
    }
    
    func delegateShowSubTopicWithMainTopicId(mainTopicID: String, WithMainTopicName mainTopicName: String)
    {
        
        
        subTopicsView.frame = CGRectMake(0,0, 600   ,44)
        subTopicsView.getSubtopicsDetailsWithMainTopicId(mainTopicID, withMainTopicName: mainTopicName,withStartedSubtopicID: SSTeacherDataSource.sharedDataSource.startedSubTopicId)
        subTopicsView.hidden = false
        mainTopicsView.hidden = true
        mShowTopicsView.bringSubviewToFront(subTopicsView)
          mShowTopicsView.frame = CGRectMake(mShowTopicsView.frame.origin.x, mShowTopicsView.frame.origin.y , mShowTopicsView.frame.size.width  , subTopicsView.currentMainTopicsViewHeight)
        
        
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
        mainTopicsView.getTopicsDetailswithStartedMaintopicId("")
        mainTopicsView.hidden = false
        mShowTopicsView.bringSubviewToFront(mainTopicsView)
        subTopicsView.hidden = true
         mShowTopicsView.frame = CGRectMake(mShowTopicsView.frame.origin.x, mShowTopicsView.frame.origin.y , mShowTopicsView.frame.size.width  , mainTopicsView.currentMainTopicsViewHeight)
       
    }
    
    func delegateSubtopicStateChanedWithSubTopicDetails(subTopicDetails: AnyObject, withState state: Bool, withmainTopicName mainTopicName: String)
    {
        
        
        if state == true
        {
            startedSubTopicDetails = subTopicDetails
            if let topicId = subTopicDetails.objectForKey("Id")as? String
            {

                if let sessionId = (currentSessionDetails.objectForKey(kSessionId)) as? String
                {
                    SSTeacherDataSource.sharedDataSource.startSubTopicWithTopicID(topicId, withStudentId: "", withSessionID: sessionId, withDelegate: self)
                   
                    if let topicName = subTopicDetails.objectForKey("Name")as? String
                    {
                        mSubTopicsNamelabel.text = "\(mainTopicName) / \(topicName)"
                    }
                    
                    
                    
                    SSTeacherMessageHandler.sharedMessageHandler.sendAllowVotingToRoom(currentSessionId, withValue: "TRUE", withSubTopicName: mSubTopicsNamelabel.text!, withSubtopicID: topicId)
                }

            }
        }
        else
        {
            
            if let subTopicId = subTopicDetails.objectForKey("Id")as? String
            {
                let subTopicName = subTopicDetails.objectForKey("Name")as! String
                
                if let sessionId = (currentSessionDetails.objectForKey(kSessionId)) as? String
                {
                    SSTeacherDataSource.sharedDataSource.stopSubTopicWithTopicID(subTopicId, withSessionID: sessionId, withDelegate: self)
                }
                cumulativeTimer.invalidate()
                
                SSTeacherMessageHandler.sharedMessageHandler.sendAllowVotingToRoom(currentSessionId, withValue: "FALSE", withSubTopicName: subTopicName, withSubtopicID: subTopicId)
                
                mSubTopicsNamelabel.text = "\(mainTopicName)"
            }
            
            
        }
        
        
        
    }
    
    
    func delegateSubtopicStateChanedWithID(subTopicId: String, withState state: Bool, withSubtopicName subTopicName: String, withmainTopicName mainTopicName: String) {
        
        if state == true
        {
            
            if let sessionId = (currentSessionDetails.objectForKey(kSessionId)) as? String
            {
                SSTeacherDataSource.sharedDataSource.startSubTopicWithTopicID(subTopicId, withStudentId: "", withSessionID: sessionId, withDelegate: self)
            }

             mSubTopicsNamelabel.text = "\(mainTopicName) / \(subTopicName)"
            
            SSTeacherMessageHandler.sharedMessageHandler.sendAllowVotingToRoom(currentSessionId, withValue: "TRUE", withSubTopicName: mSubTopicsNamelabel.text!, withSubtopicID: subTopicId)
        }
        else
        {
            
            
            if let sessionId = (currentSessionDetails.objectForKey(kSessionId)) as? String
            {
                SSTeacherDataSource.sharedDataSource.stopSubTopicWithTopicID(subTopicId, withSessionID: sessionId, withDelegate: self)
            }

            
            SSTeacherDataSource.sharedDataSource.isSubtopicStarted = false
            SSTeacherMessageHandler.sharedMessageHandler.sendAllowVotingToRoom(currentSessionId, withValue: "FALSE", withSubTopicName: subTopicName, withSubtopicID: subTopicId)
            
             mSubTopicsNamelabel.text = "\(mainTopicName)"
        }
    }
    
    
// MARK: - subTopic delegate functions
    func delegateQuestionButtonPressedWithSubtopicId(subtopicId: String, withSubTopicName subTopicName: String, withMainTopicId mainTopicId: String, withMainTopicName mainTopicName: String) {
        
       
        
        
        
        questionTopicsView.frame = CGRectMake(0,0, 600   ,44)
        
        if SSTeacherDataSource.sharedDataSource.startedSubTopicId == subtopicId
        {
            questionTopicsView.getQuestionsDetailsWithsubTopicId(subtopicId, withSubTopicName: subTopicName, withMainTopicId: mainTopicId, withMainTopicName: mainTopicName, withSubtopicStarted: true)
        }
        else
        {
            questionTopicsView.getQuestionsDetailsWithsubTopicId(subtopicId, withSubTopicName: subTopicName, withMainTopicId: mainTopicId, withMainTopicName: mainTopicName, withSubtopicStarted: false)
        }

        
        questionTopicsView.hidden = false
        mShowTopicsView.bringSubviewToFront(questionTopicsView)
        subTopicsView.hidden = true
        mainTopicsView.hidden = true
        
        mShowTopicsView.frame = CGRectMake(mShowTopicsView.frame.origin.x, mShowTopicsView.frame.origin.y , mShowTopicsView.frame.size.width  , questionTopicsView.currentMainTopicsViewHeight)
        
        
        
        
//        if (classViewPopOverController.popoverVisible == true)
//        {
//           
//            
//            classViewPopOverController.contentViewController = questionController
//            
//            if startedSubTopicID == ""
//            {
//                mSubTopicsNamelabel.text = "\(mainTopicName) / \(subTopicName)"
//            }
//        }
    }
    
    
// MARK: - Question delegate functions
    
    func delegateQuestionSentWithQuestionDetails(questionDetails: AnyObject) {
        
        currentQuestionDetails = questionDetails
        
        if let QuestionID = (currentQuestionDetails.objectForKey("Id")) as? String
        {
            SSTeacherDataSource.sharedDataSource.broadcastQuestionWithQuestionId(QuestionID, withSessionID: currentSessionId, withDelegate: self)
            isQuestionSent = true
            classViewPopOverController.dismissPopoverAnimated(true)
            
            if let questionName = (currentQuestionDetails.objectForKey("Name")) as? String
            {
                mQuestionNamelabel.text = questionName
            }
        }
    }
    
    
    func delegateQuestionBackButtonPressed(mainTopicId: String, withMainTopicName mainTopicName: String) {
       
//        subTopicsController.setdelegate(self)
//        subTopicsController.preferredContentSize = CGSizeMake(600, 44)
//        subTopicsController.setPopover(classViewPopOverController)
//        if (classViewPopOverController.popoverVisible == true)
//        {
//            subTopicsController.getSubtopicsDetailsWithMainTopicId(mainTopicId, withMainTopicName: mainTopicName,withStartedSubtopicID: startedSubTopicID, withCumulativeTime: currentCumulativeTime)
//            
//            classViewPopOverController.contentViewController = subTopicsController
//            if startedSubTopicID == ""
//            {
//                mSubTopicsNamelabel.text = mainTopicName
//                startedMainTopicID = mainTopicId
//                startedMainTopicName = mainTopicName
//                
//            }
//            cumulativeTimer.invalidate()
//            
//        }
        
        
        
        subTopicsView.frame = CGRectMake(0,0, 600   ,44)
        subTopicsView.getSubtopicsDetailsWithMainTopicId(mainTopicId, withMainTopicName: mainTopicName,withStartedSubtopicID:SSTeacherDataSource.sharedDataSource.startedSubTopicId
        )
        subTopicsView.hidden = false
        mainTopicsView.hidden = true
        questionTopicsView.hidden = true
        mShowTopicsView.bringSubviewToFront(subTopicsView)
        
    }
    
    func delegateScribbleQuestionWithSubtopicId(subTopicID: String)
    {
        let mScribbleview =  SSTeacherScribbleQuestion(frame:CGRectMake(0  ,0,self.view.frame.size.width,self.view.frame.size.height))
        self.view.addSubview(mScribbleview)
        mScribbleview.setdelegate(self)
        mScribbleview.setCurrentTopicId(SSTeacherDataSource.sharedDataSource.startedSubTopicId)
        
    }
    
    
    // MARK: - live Question delegate functions
    
    func delegateQuestionCleared(questionDetails: AnyObject, withCurrentmainTopicId mainTopicId: String, withCurrentMainTopicName mainTopicName: String) {
        
        SSTeacherDataSource.sharedDataSource.clearQuestionWithQuestionogId(currentQuestionLogId, withDelegate: self)
        
        
        
        isQuestionSent = false
        
         questionTopicsView.clearQuestionTopicId(SSTeacherDataSource.sharedDataSource.startedSubTopicId)
//        subTopicsController.preferredContentSize = CGSizeMake(600, 44)
//      subTopicsController.clearSubTopicDetailsWithMainTopicId(mainTopicId)
        
        if (SSTeacherDataSource.sharedDataSource.subTopicDetailsDictonary.objectForKey(mainTopicId) != nil)
        {
            SSTeacherDataSource.sharedDataSource.subTopicDetailsDictonary.removeObjectForKey(mainTopicId)
        }
        
        
        newSubmissionRecieved.removeAllObjects()
        
        submissionNotificationLabel.hidden = true
        

        
        
        
        if (classViewPopOverController.popoverVisible == true)
        {
//            subTopicsController.setPopover(classViewPopOverController)
            subTopicsView.getSubtopicsDetailsWithMainTopicId(mainTopicId, withMainTopicName: mainTopicName,withStartedSubtopicID: SSTeacherDataSource.sharedDataSource.startedSubTopicId)
            
//            classViewPopOverController.contentViewController = subTopicsController
            if SSTeacherDataSource.sharedDataSource.isSubtopicStarted == false
            {
                mSubTopicsNamelabel.text = mainTopicName
                startedMainTopicID = mainTopicId
                startedMainTopicName = mainTopicName
                
            }
            cumulativeTimer.invalidate()
            
            
            
            
            
            
        }
        
        
        for indexValue in 0  ..< StudentsDetailsArray.count
        {
            let studentsDict = StudentsDetailsArray.objectAtIndex(indexValue)
           
            if let StudentId = studentsDict.objectForKey("StudentId") as? String{
                
                if let studentDeskView  = mClassView.viewWithTag(Int(StudentId)!) as? StundentDeskView
                {
                    studentDeskView.teacherClearedQuestion()
                }
            }
            
           
        }
        

        
        
        mQuestionNamelabel.text = "No active question"
        SSTeacherMessageHandler.sharedMessageHandler.sendClearQuestionMessageWithRoomId("question_\(currentSessionId)")
        mSubmissionView.questionClearedByTeacher()
    }
    
    func delegateDoneButtonPressed()
    {
        mShowTopicsView.hidden = true
    }
    
    
// MARK: - message handler delegate
    
    func smhDidcreateRoomWithRoomName(roomName: String)
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
    
    
    func smhDidgetStudentBentchStateWithStudentId(studentId: String, withState state: String) {
        
        if let studentDeskView  = mClassView.viewWithTag(Int(studentId)!) as? StundentDeskView
        {
            if Int(state) == kStudentLive
            {
                
               
                if SSTeacherDataSource.sharedDataSource.startedSubTopicId != "" && studentDeskView.StudentState != StudentLiveBackground
                {
                    SSTeacherMessageHandler.sharedMessageHandler.sendAllowVotingToStudents(studentId, withValue: "TRUE", withSubTopicName: mSubTopicsNamelabel.text!, withSubtopicID: SSTeacherDataSource.sharedDataSource.startedSubTopicId)
                }
                
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
    
    
    func smhDidgetStudentQuestionAccepetedMessageWithStudentId(StudentId: String) {
        
        
        if let studentDeskView  = mClassView.viewWithTag(Int(StudentId)!) as? StundentDeskView
        {
           
            if let questionType = currentQuestionDetails.objectForKey("Type") as? String
            {
                
                if (questionType  == "Overlay Scribble"  || questionType == "Fresh Scribble" || questionType  == "Text")
                {
                    studentDeskView.mQuestionStateImage.image = UIImage(named:"StudentWriting.png");
                }
                else
                {
                     studentDeskView.mQuestionStateImage.image = UIImage(named:"StudentThinking.png");
                    
                }
                
                studentDeskView.mQuestionStateImage.hidden = false
            }
        }
        
    }
    
    
    func smhDidGetstudentSubmissionWithDrawn(StudentId: String)
    {
        if let studentDeskView  = mClassView.viewWithTag(Int(StudentId)!) as? StundentDeskView
        {
            if currentQuestionDetails != nil
            {
                studentDeskView.studentAnswerWithdrawn()
                
                mSubmissionView.studentAnswerWithdrawnWithStudentId(StudentId)
                
                if newSubmissionRecieved.containsObject(StudentId)
                {
                    newSubmissionRecieved.removeObject(StudentId)
                    
                    if newSubmissionRecieved.count > 0
                    {
                        submissionNotificationLabel.hidden = false
                        
                        submissionNotificationLabel.text = "\(newSubmissionRecieved.count)"
                    }
                    else
                    {
                        submissionNotificationLabel.hidden = true
                    }
                }
                
                
            }
            
            
        }
    }
    
    func smhDidgetStudentAnswerMessageWithStudentId(StudentId: String, withAnswerString answerStrin: String)
    {
        if let studentDeskView  = mClassView.viewWithTag(Int(StudentId)!) as? StundentDeskView
        {
            if currentQuestionDetails != nil
             {
                studentDeskView.studentSentAnswerWithAnswerString(answerStrin,withQuestionDetails: currentQuestionDetails)
                
            }
            
            
        }
        
    }
    
    
    func smhDidgetStudentDontKnowMessageRecieved(StudentId: String)
    {
        if let studentDeskView  = mClassView.viewWithTag(Int(StudentId)!) as? StundentDeskView
        {
            if currentQuestionDetails != nil
            {
                studentDeskView.setDontKnowMessageFromStudent()
                
            }
            
            
        }
        
    }
    
    
    func smhDidgetStudentQueryWithDetails(queryId: String) {
        
        mQueryView.addQueryWithDetails(queryId)
    }
    
    // MARK: - DeskView delegate functions
    
    func delegateStudentAnswerDownloadedWithDetails(details: AnyObject, withStudentDict studentDict: AnyObject)
    {
        
        
        
        
        if let _ = currentQuestionDetails.objectForKey("Type") as? String
        {
            
            if currentScreen != kSubmissionView
            {
                newSubmissionRecieved.addObject(studentDict.objectForKey("StudentId") as! String)
                
                submissionNotificationLabel.hidden = false
                
                submissionNotificationLabel.text = "\(newSubmissionRecieved.count)"
            }
            
            
            mSubmissionView.studentAnswerRecievedWIthDetails(details, withStudentDict: studentDict)
            
            
            
            if mSubmissionView.hidden == false
            {
                if let studentId = studentDict.objectForKey("StudentId") as? String
                {
                    SSTeacherMessageHandler.sharedMessageHandler.sendHandRaiseReceivedMessageToStudentWithId(studentId)
                }

            }
            
            
            
        }
        
        
        
    }
    
    
    func delegateStudentCellPressedWithViewAnswerOptions(answerOptions: NSMutableArray, withStudentId studentId: String) {
        
        
        if let studentDeskView  = mClassView.viewWithTag(Int(studentId)!) as? StundentDeskView
        {
            let buttonPosition :CGPoint = studentDeskView.convertPoint(CGPointZero, toView: self.view)
           
            if let questionType = currentQuestionDetails.objectForKey("Type") as? String
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
                    
                    
                    questionInfoController.preferredContentSize = CGSizeMake(400,317)
                    
                    let   classViewPopOverController = UIPopoverController(contentViewController: questionInfoController)
                    questionInfoController.setPopover(classViewPopOverController)
                    classViewPopOverController.popoverContentSize = CGSizeMake(400,317);
                    classViewPopOverController.delegate = self;
                    
                    classViewPopOverController.presentPopoverFromRect(CGRect(
                        x:buttonPosition.x ,
                        y:buttonPosition.y + studentDeskView.frame.size.height / 2,
                        width: 1,
                        height: 1), inView: self.view, permittedArrowDirections: .Right, animated: true)
                }
                else
                {
                    let questionInfoController = SingleResponceOption()
//                    questionInfoController.setdelegate(self)
                    
                    
                    
                    
                    questionInfoController.setQuestionDetails(currentQuestionDetails,withAnswerOptions: answerOptions)
                    
                    
                    questionInfoController.preferredContentSize = CGSizeMake(400,317)
                    
                    let   classViewPopOverController = UIPopoverController(contentViewController: questionInfoController)
                    questionInfoController.setPopover(classViewPopOverController)
                    classViewPopOverController.popoverContentSize = CGSizeMake(400,317);
                    classViewPopOverController.delegate = self;
                    
                    classViewPopOverController.presentPopoverFromRect(CGRect(
                        x:buttonPosition.x ,
                        y:buttonPosition.y + studentDeskView.frame.size.height / 2,
                        width: 1,
                        height: 1), inView: self.view, permittedArrowDirections: .Right, animated: true)
                    
                    
                }
            }
            
        }
        
        
        
    }
    
    
    func delegateStudentCellPressedWithViewSubjectiveAnswerDetails(details: AnyObject, withStudentId studentId: String)
    {
        if let studentDeskView  = mClassView.viewWithTag(Int(studentId)!) as? StundentDeskView
        {
            let buttonPosition :CGPoint = studentDeskView.convertPoint(CGPointZero, toView: self.view)
            
            if let questionType = currentQuestionDetails.objectForKey("Type") as? String
            {
                
                if (questionType  == kOverlayScribble  || questionType == kFreshScribble || questionType == kText)
                {
                    let questionInfoController = StudentSubjectivePopover()
                    questionInfoController.setdelegate(self)
                    
                   questionInfoController.setStudentAnswerDetails(details, withStudentDetials: studentDeskView.currentStudentsDict, withCurrentQuestionDict: currentQuestionDetails)
                    
                    let   classViewPopOverController = UIPopoverController(contentViewController: questionInfoController)
                    
                    classViewPopOverController.popoverContentSize = CGSizeMake(320,320);
                    classViewPopOverController.delegate = self;
                    questionInfoController.setPopover(classViewPopOverController)
                    classViewPopOverController.presentPopoverFromRect(CGRect(
                        x:buttonPosition.x ,
                        y:buttonPosition.y + studentDeskView.frame.size.height / 2,
                        width: 1,
                        height: 1), inView: self.view, permittedArrowDirections: .Right, animated: true)
                    
                    
                    
                    if newSubmissionRecieved.containsObject(studentId)
                    {
                        newSubmissionRecieved.removeObject(studentId)
                        
                         SSTeacherMessageHandler.sharedMessageHandler.sendHandRaiseReceivedMessageToStudentWithId(studentId)
                        
                        if newSubmissionRecieved.count > 0
                        {
                            submissionNotificationLabel.hidden = false
                            
                            submissionNotificationLabel.text = "\(newSubmissionRecieved.count)"
                        }
                        else
                        {
                            submissionNotificationLabel.hidden = true
                        }
                    }
                }
            }
            
        }
    }
    
    
    
    
    
    func delegateStudentCellPressedWithEvaluationDetails(details: AnyObject, withStudentId studentId: String)
    {
        if let studentDeskView  = mClassView.viewWithTag(Int(studentId)!) as? StundentDeskView
        {
            let buttonPosition :CGPoint = studentDeskView.convertPoint(CGPointZero, toView: self.view)
            
            let questionInfoController = StudentEvaluationDetails()
            questionInfoController.setdelegate(self)
            
            questionInfoController.setStudentAnswerDetails(studentDeskView._currentAnswerDetails, withStudentDetials: studentDeskView.currentStudentsDict, withCurrentQuestionDict: currentQuestionDetails, withEvaluationDetails: details)
            
            let   classViewPopOverController = UIPopoverController(contentViewController: questionInfoController)
            
            classViewPopOverController.popoverContentSize = CGSizeMake(320,320);
            classViewPopOverController.delegate = self;
            questionInfoController.setPopover(classViewPopOverController)
            
            classViewPopOverController.presentPopoverFromRect(CGRect(
                x:buttonPosition.x ,
                y:buttonPosition.y + studentDeskView.frame.size.height / 2,
                width: 1,
                height: 1), inView: self.view, permittedArrowDirections: .Right, animated: true)
            
        }
        
    }
    
    
    func delegateStudentQueryWithDetails(details: AnyObject, withStudentDict studentDict: AnyObject)
    {
        
        
        if let studentId = studentDict.objectForKey("StudentId") as? String
        {
            if let studentDeskView  = mClassView.viewWithTag(Int(studentId)!) as? StundentDeskView
            {
                let buttonPosition :CGPoint = studentDeskView.convertPoint(CGPointZero, toView: self.view)
                
                let questionInfoController = StudentQueryPopover()
                //                    questionInfoController.setdelegate(self)
                
                
                
                
                questionInfoController.setQueryWithDetails(details, withStudentDetials: studentDict)
                
                
                questionInfoController.preferredContentSize = CGSizeMake(320,317)
                
                let   classViewPopOverController = UIPopoverController(contentViewController: questionInfoController)
                questionInfoController.setPopover(classViewPopOverController)
                classViewPopOverController.popoverContentSize = CGSizeMake(320,317);
                classViewPopOverController.delegate = self;
                
                classViewPopOverController.presentPopoverFromRect(CGRect(
                    x:buttonPosition.x ,
                    y:buttonPosition.y + studentDeskView.frame.size.height / 2,
                    width: 1,
                    height: 1), inView: self.view, permittedArrowDirections: .Right, animated: true)
                
            }
        }

        
        
        
        
        
        
         }
    
    
    // MARK: - Submission view delegate  functions
    func delegateGetaggregateWithOptionId(optionId: String, withView barButton: BarView) {
        
        let buttonPosition :CGPoint = barButton.convertPoint(CGPointZero, toView: self.view)
        
        
        
        let questionInfoController = SSTeacherAggregatePopOverController()
        questionInfoController.setdelegate(self)
        
        
        if let questionType = currentQuestionDetails.objectForKey("Type") as? String
        {
            
            questionInfoController.AggregateDrillDownWithOptionId(optionId, withQuestionDetails: currentQuestionDetails, withQuestionLogId: currentQuestionLogId,withQuestionTye:questionType )
           
        }
        
        

        questionInfoController.preferredContentSize = CGSizeMake(400,100)
        
        let   classViewPopOverController = UIPopoverController(contentViewController: questionInfoController)
        
        classViewPopOverController.popoverContentSize = CGSizeMake(400,100);
        classViewPopOverController.delegate = self;
        
        classViewPopOverController.presentPopoverFromRect(CGRect(
            x:buttonPosition.x + barButton.frame.size.width / 2,
            y:buttonPosition.y + barButton.frame.size.height / 2,
            width: 1,
            height: 1), inView: self.view, permittedArrowDirections:.Any, animated: true)

        
        
    }
    
    
    func delegateTeacherEvaluatedReplyWithDetails(details: AnyObject, withStudentId studentId: String) {
        
        
        
        if let studentDeskView  = mClassView.viewWithTag(Int(studentId)!) as? StundentDeskView
        {
                studentDeskView.setReplayEvaluatedWithDetails(details)
        }
        
    }
    
    
    
    // MARK: - Query view delegate  functions
    
    func delegateQueryDownloadedWithDetails(queryDetails: AnyObject)
    {
        if let StudentId = queryDetails.objectForKey("StudentId") as? String
        {
            if let studentDeskView  = mClassView.viewWithTag(Int(StudentId)!) as? StundentDeskView
            {
               studentDeskView.setQueryDetails(queryDetails)
                 newQueryRecieved.addObject(StudentId)
                
                
                if currentScreen != kQueryView
                {
                    
                    queryNotificationLabel.hidden = false
                    
                    queryNotificationLabel.text = "\(newQueryRecieved.count)"
                }
                
            }
        }
        
    }
    
    
    func delegateQueryDeletedWithDetails(queryDetails: AnyObject) {
        
        if let StudentId = queryDetails.objectForKey("StudentId") as? String
        {
            if let studentDeskView  = mClassView.viewWithTag(Int(StudentId)!) as? StundentDeskView
            {
                newQueryRecieved.removeObject(StudentId)
                studentDeskView.queryDismissed()
                
            }
        }
    }
    
    // MARK: - SubmissionPopover functions
    
    
    func delegateAnnotateButtonPressedWithAnswerDetails(answerDetails: AnyObject, withStudentDetails studentDict: AnyObject, withQuestionDetails questionDetails: AnyObject) {
        
        let annotateView = StudentAnnotateView(frame: CGRectMake(0, 0 ,self.view.frame.size.width,self.view.frame.size.height))
        self.view.addSubview(annotateView)
        annotateView.setdelegate(self)
        annotateView.setStudentDetails(studentDict, withAnswerDetails: answerDetails, withQuestionDetails: questionDetails)
        
    }
    
    func delegateSubmissionEvalauatedWithAnswerDetails(answerDetails: AnyObject, withEvaluationDetail evaluation: AnyObject, withStudentId studentId: String)
    {
       
        mSubmissionView.studentSubmissionEvaluatedWithDetails(evaluation, withStdentId: studentId)
    }
    
    
    
    // MARK: - Extra functions
    func popoverControllerDidDismissPopover(popoverController: UIPopoverController)
    {
        if SSTeacherDataSource.sharedDataSource.isSubtopicStarted == false
         {
            mSubTopicsNamelabel.text = "No topic selected"
        }
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if let _ = touches.first
        {
            
        }
        super.touchesBegan(touches, withEvent:event)
    }
    
    
    func popoverControllerShouldDismissPopover(popoverController: UIPopoverController) -> Bool {
       
        return true
    }
    
    // MARK: - Setting controller functions
    
    func Settings_setupLessonPlanClicked()
    {
        let mSetupLessonPlan  = SSTeacherLessonPlanView(frame: CGRectMake(0, 0 ,self.view.frame.size.width, self.view.frame.size.height))
        mSetupLessonPlan.setCurrentSessionDetails(currentSessionDetails)
        self.view.addSubview(mSetupLessonPlan)
        SSTeacherDataSource.sharedDataSource.subTopicDetailsDictonary.removeAllObjects()
        mainTopicsView.mMaintopicsDetails.removeAllObjects()
    }
    
    func Settings_AlphabeticalReassignseats()
    {
        
        let studentIdArray = NSMutableArray()
        
        let _seatsIdArray   = NSMutableArray()
        
        
        
        
        for indexValue in 0  ..< StudentsDetailsArray.count
        {
            let studentsDict = StudentsDetailsArray.objectAtIndex(indexValue)
            
            let seatId = seatsIdArray[indexValue]
            if let StudentId = studentsDict.objectForKey("StudentId") as? String
            {
                
                _seatsIdArray.addObject(seatId)
                studentIdArray.addObject(StudentId)
            }

        }
        
        if let sessionid = currentSessionDetails.objectForKey(kSessionId) as? String
        {

            SSTeacherDataSource.sharedDataSource.SaveSeatAssignmentWithStudentsList(studentIdArray.componentsJoinedByString(","), withSeatsIdList: _seatsIdArray.componentsJoinedByString(","), withSessionId: sessionid, withDelegate: self)
        }

        
    }
    
    func Settings_RandomReasignSeats()
    {
       
        let studentIdArray = NSMutableArray()
        
        let seatsIdArray   = NSMutableArray()
        
        let subViews = mClassView.subviews.flatMap{ $0 as? StundentDeskView }
        
        for subview in subViews
        {
            if subview.isKindOfClass(StundentDeskView)
            {
                if subview.getSeatIdAndStudentId().StudentId != "0"
                {
                    seatsIdArray.addObject(subview.getSeatIdAndStudentId().seatId)
                    studentIdArray.addObject(subview.getSeatIdAndStudentId().StudentId)
                }
            }
        }
        
        
        seatsIdArray.shuffle()
       
        
        if let sessionid = currentSessionDetails.objectForKey(kSessionId) as? String
        {
            //            mDonebutton.hidden = true
            SSTeacherDataSource.sharedDataSource.SaveSeatAssignmentWithStudentsList(studentIdArray.componentsJoinedByString(","), withSeatsIdList: seatsIdArray.componentsJoinedByString(","), withSessionId: sessionid, withDelegate: self)
        }
    }
   
    
    
    func Settings_ManualResignSeats() {
        
    }
    
    func Settings_onQueryEnbled() {
        
    }
    
    func Settings_onQuestionEnabled() {
        
    }
    
    func Settings_refreshPicsClicked() {
        
    }
    
    func Settings_testPingButtonClicked() {
        
    }
    
    func Settings_XmppReconnectButtonClicked() {
        
    }
    
     // MARK: - SSTeacherSchedulePopoverController Delegate  functions
    
    func delegateSessionEnded()
    {
        
        if let sessionId = (currentSessionDetails.objectForKey(kSessionId)) as? String
        {
            SSTeacherDataSource.sharedDataSource.updateSessionStateWithSessionId(sessionId, WithStatusvalue: "5", WithDelegate: self)
        
        }
       
    }
    
}