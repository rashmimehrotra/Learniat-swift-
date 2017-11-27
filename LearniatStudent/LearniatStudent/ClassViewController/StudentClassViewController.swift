//
//  StudentClassViewController.swift
//  LearniatStudent
//
//  Created by Deepak MK on 22/04/16.
//  Copyright © 2016 Mindshift. All rights reserved.
//

import Foundation
class StudentClassViewController: UIViewController,SSStudentDataSourceDelegate,SSStudentMessageHandlerDelegate,StudentQuestionViewDelegate,SSStudentFullscreenScribbleQuestionDelegate,UIPopoverControllerDelegate,SSStudentSchedulePopoverControllerDelegate
{
    
    var sessionDetails               = NSMutableDictionary()
    
    var mTopbarImageView             :UIImageView           = UIImageView()
    
    var  studentImage :CustomProgressImageView!
    
    var mTeacherImageView: CustomProgressImageView!
    
    var mTeacherName: UILabel!
    
    var mNoStudentLabel = UILabel()
    
    var mBottomBarImageView      = UIImageView()
    
    var classStartedView            = UIView()
    
    var mQuestionButton = CustomButtonSubView()
    
    var mQueryButton = CustomButtonSubView()
    
    var mSubmissionButton   = CustomButtonSubView()
    
    var mQuestionView       : StudentQuestionView!
    
    var mQueryView          : StudentsQueryView!
    
    var mOTFView             :StudentOTFView!
    
    var mSubTopicNamelabel       = UILabel()
    var mQuestionNameLabel       = UILabel()
    
    
    var mstatusImage        = UIImageView()
    var mClassName          = UILabel()
    var mClassStatedLabel   = UILabel()
    
    
    var currentQuestionDetails : AnyObject!
    var questionAcceptAlert                 = UIAlertView()
    var currentQuestionLogId                = String()
    var currentQuestionType                 = String()
    
    var currentSubTopicId :String           = String()
    var currentAssessmentAnswerId :String   = String()
    var waitQuestionTimer                   = Timer()
    
     let mClassNameButton  = UIButton()
    let mTeacherImageButton = UIButton()
    
    var mStudentQrvAnsweringView           :StudentVolunteeringView!
    
    var startedTimeUpdatingTimer = Timer()
    
    
    var mFullScreenView         :SSStudentFullscreenScribbleQuestion!
    
    var   classViewPopOverController : UIPopoverController!
    
    var questionPanelMessage = "There are no questions yet"
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        
        self.view.backgroundColor = darkBackgroundColor
        
        SSStudentMessageHandler.sharedMessageHandler.setdelegate(self)
        
        mTopbarImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 60))
        mTopbarImageView.backgroundColor = topbarColor
        self.view.addSubview(mTopbarImageView)
        mTopbarImageView.isUserInteractionEnabled = true
        
         studentImage = CustomProgressImageView(frame:CGRect(x: 15, y: 15, width: mTopbarImageView.frame.size.height - 20 ,height: mTopbarImageView.frame.size.height - 20))
        mTopbarImageView.addSubview(studentImage)
        
        let urlString = UserDefaults.standard.object(forKey: k_INI_UserProfileImageURL) as! String
        
        let userID = urlString.appending("/").appending(SSStudentDataSource.sharedDataSource.currentUserId)
        
        
        if let checkedUrl = URL(string: "\(userID)_79px.jpg")
        {
            studentImage.contentMode = .scaleAspectFit
            studentImage.downloadImage(checkedUrl, withFolderType: folderType.proFilePics)
        }
        
        
        
        let studentName = UILabel(frame: CGRect(x: studentImage.frame.origin.x + studentImage.frame.size.width + 10, y: studentImage.frame.origin.y, width: 200, height: 20))
        mTopbarImageView.addSubview(studentName)
        studentName.textColor = UIColor.white
        studentName.text = SSStudentDataSource.sharedDataSource.currentUserName.capitalized

        
        
        
        mTeacherImageButton.frame = CGRect(x: 0, y: 0, width: mTopbarImageView.frame.size.height , height: mTopbarImageView.frame.size.height)
        mTopbarImageView.addSubview(mTeacherImageButton)
        mTeacherImageButton.addTarget(self, action: #selector(StudentClassViewController.onTeacherImage), for: UIControlEvents.touchUpInside)
        

        
        
        mClassName = UILabel(frame: CGRect(x: mTopbarImageView.frame.size.width/2 - 100 , y: 15, width: 500, height: 20))
        mClassName.font = UIFont(name:helveticaRegular, size: 17)
        
        mTopbarImageView.addSubview(mClassName)
        mClassName.textColor = UIColor.white
        mClassName.textAlignment = .left
        
        if let ClassName = sessionDetails.object(forKey: "ClassName") as? String
        {
            mClassName.text = ClassName
        }
        
        
       
        
        
        mClassNameButton.frame = CGRect(x: (mTopbarImageView.frame.size.width - mClassName.frame.size.width)/2 , y: 0, width: mClassName.frame.size.width, height: mTopbarImageView.frame.size.height )
        mTopbarImageView.addSubview(mClassNameButton)
        mClassNameButton.addTarget(self, action: #selector(StudentClassViewController.onClassButton), for: UIControlEvents.touchUpInside)
        mClassNameButton.backgroundColor = UIColor.clear
        
        
        
        mstatusImage .frame = CGRect(x: mClassName.frame.origin.x  - (mClassName.frame.size.height + 5),y: mClassName.frame.origin.y  ,width: mClassName.frame.size.height,height: mClassName.frame.size.height)
        mstatusImage.backgroundColor = standard_Green
        mTopbarImageView.addSubview(mstatusImage)
        mstatusImage.layer.cornerRadius = mstatusImage.frame.size.width/2
        
        
        
        mClassStatedLabel.frame =  CGRect(x: mClassName.frame.origin.x, y: mClassName.frame.origin.y + mClassName.frame.size.height + 3 , width: mClassName.frame.size.width, height: mClassName.frame.size.height)
        mClassStatedLabel.textColor = UIColor.white
        mClassStatedLabel.numberOfLines = 2
        
        mClassStatedLabel.textAlignment = .left
        mClassStatedLabel.font = UIFont(name: helveticaMedium, size: 14)
        mTopbarImageView.addSubview(mClassStatedLabel)
        


        
        
        classStartedView.frame = CGRect(x: 0, y: mTopbarImageView.frame.size.height, width: self.view.frame.size.width, height: self.view.frame.size.height - mTopbarImageView.frame.size.height)
        classStartedView.backgroundColor = darkBackgroundColor
        self.view.addSubview(classStartedView)
        classStartedView.isHidden = true
        
        
        
       
        
        
        mBottomBarImageView.frame = CGRect(x: 0, y: classStartedView.frame.size.height - 60, width: classStartedView.frame.size.width, height: 60)
        classStartedView.addSubview(mBottomBarImageView)
        mBottomBarImageView.backgroundColor = topbarColor
        
        mTeacherImageView = CustomProgressImageView(frame: CGRect(x: 10, y: 10, width: mBottomBarImageView.frame.size.height - 20 ,height: mBottomBarImageView.frame.size.height - 20))
        mTeacherImageView.backgroundColor = lightGrayColor
        mBottomBarImageView.addSubview(mTeacherImageView)
        mTeacherImageView.layer.masksToBounds = true
        mTeacherImageView.layer.cornerRadius = 2
        
        mTeacherName = UILabel(frame: CGRect(x: mTeacherImageView.frame.origin.x + mTeacherImageView.frame.size.width + 10, y: mTeacherImageView.frame.origin.y, width: 200, height: 20))
        mTeacherName.font = UIFont(name:helveticaMedium, size: 20)
        mBottomBarImageView.addSubview(mTeacherName)
        mTeacherName.textColor = UIColor.white
        
        
        let teacher = UILabel(frame: CGRect(x: mTeacherImageView.frame.origin.x + mTeacherImageView.frame.size.width + 10, y: mTeacherName.frame.origin.y + mTeacherName.frame.size.height + 5, width: 200, height: 20))
        mBottomBarImageView.addSubview(teacher)
        teacher.text = "Teacher"
        teacher.font = UIFont(name:helveticaRegular, size: 16)
        teacher.textColor = UIColor.white
        
      
        
        mNoStudentLabel.frame = CGRect(x: 10, y: (self.view.frame.size.height - 40)/2, width: self.view.frame.size.width - 20,height: 40)
        mNoStudentLabel.font = UIFont(name:helveticaMedium, size: 30)
        mNoStudentLabel.text = "Wait for the teacher to begin :)"
        self.view.addSubview(mNoStudentLabel)
        mNoStudentLabel.textColor = UIColor.white
        mNoStudentLabel.textAlignment = .center
        mNoStudentLabel.isHidden = true
        
        
        if let sessionId = sessionDetails.object(forKey: kSessionId) as? String
        {
            SSStudentDataSource.sharedDataSource.currentLiveSessionId = sessionId
            
            getUserSessionWithSessionID(sessionID: sessionId)
            
        }
        
        
        switch (sessionDetails.object(forKey: kSessionState) as! String)
        {
            case kopenedString:
                mClassStatedLabel.text = "Class not started yet"
                mNoStudentLabel.isHidden = false
                classStartedView.isHidden = true
                RealmDatasourceManager.saveScreenStateOfUser(screenState: .waitingForTeacherScreen, withUserId: SSStudentDataSource.sharedDataSource.currentUserId)

                break
            
            case kLiveString:
                
                
                mNoStudentLabel.isHidden = true
                classStartedView.isHidden = false
                
                startedTimeUpdatingTimer.invalidate()
                startedTimeUpdatingTimer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(StudentClassViewController.startTimeUpdating), userInfo: nil, repeats: true)
                RealmDatasourceManager.saveScreenStateOfUser(screenState: .LiveScreen, withUserId: SSStudentDataSource.sharedDataSource.currentUserId)
                break
            
            default:
                break
        }
         loadSubview()
        
        subscribeForSignal()
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if let sessionId = sessionDetails.object(forKey: kSessionId) as? String{
            if SSStudentMessageHandler.sharedMessageHandler.questionSubjects[sessionId] != nil{
                let questionRoomSubject:QuestionRoomSubject = SSStudentMessageHandler.sharedMessageHandler.questionSubjects[sessionId]!
                if questionRoomSubject.question.questionId != "" && questionRoomSubject.question.questionState == QuestionState.Started{
                    smhDidReceiveQuesitonIdChange(question: questionRoomSubject.question)
                }
                else if questionRoomSubject.question.questionState == QuestionState.Frozen{
                    mQuestionView.noQuestionslabel.text = "Last question is Frozen"
                    mQuestionView.addSubview(mQuestionView.noQuestionslabel)


                }
                
            }
            
            if SSStudentMessageHandler.sharedMessageHandler.sessionSubjects[sessionId] != nil{
                let sessionRoomSubject:SessionRoomSubject = SSStudentMessageHandler.sharedMessageHandler.sessionSubjects[sessionId]!
                if sessionRoomSubject.topic.topicId != "" && sessionRoomSubject.topic.topicState == QuestionState.Started{
                        mSubTopicNamelabel.text = sessionRoomSubject.topic.topicName
                        mQueryView.queryPresentState(.TopicStarted)
                        LearniatToast.showToast(view: self.view, duration:5.0, text: "Topic Started")
                } else {
                    mQueryView.queryPresentState(.TopicStopped)
                }
            }
        }

    }
    
    
    
    
    @objc func onTeacherImage() {
        let questionInfoController = SSSettingsViewController()
        questionInfoController.setDelegate(self)
        questionInfoController.classViewTopicsButtonSettingsButtonPressed();
        classViewPopOverController = UIPopoverController(contentViewController: questionInfoController)
        classViewPopOverController.contentSize = CGSize(width: 310, height: 145);
        questionInfoController.setPopOver(classViewPopOverController)
        classViewPopOverController.present(from: CGRect(
            x:mTeacherImageButton.frame.origin.x ,
            y:mTeacherImageButton.frame.origin.y + mTeacherImageButton.frame.size.height,
            width: 1,
            height: 1), in: self.view, permittedArrowDirections: .up, animated: true)
    }
    
    
    func subscribeForSignal() {
        SSStudentDataSource.sharedDataSource.isBackgroundSignal.subscribe(on: self) { [unowned self] (isBackgroud) in
            if isBackgroud == true {
               self.appMovedToBackground()
            } else {
               self.appMovedToForeground()
            }
        }
    }
  
    func appMovedToBackground() {
       if getCurrentSessionState() == "\(SessionState.Live.rawValue)" || getCurrentSessionState() == kLiveString  {
            updateStudentState(state: .BackGround)
            RealmDatasourceManager.checkForLiveAndupdateStateToLive(screenState: .LiveBackground, withUserId: SSStudentDataSource.sharedDataSource.currentUserId)
           RealmDatasourceManager.saveScreenStateOfUser(screenState: .LiveBackground, withUserId: SSStudentDataSource.sharedDataSource.currentUserId)
        }
    }
    
    func appMovedToForeground() {
        if SSStudentMessageHandler.sharedMessageHandler.getConnectedState() == false {
             SSStudentMessageHandler.sharedMessageHandler.performReconnet(connectType: "Other")
        } else {
            if getCurrentSessionState() == "\(SessionState.Live.rawValue)" || getCurrentSessionState() == kLiveString  {
                updateStudentState(state: .Live)
                RealmDatasourceManager.saveScreenStateOfUser(screenState: .LiveScreen, withUserId: SSStudentDataSource.sharedDataSource.currentUserId)

            }
        }
    }

    
    func updateStudentState(state:UserState) {
        SSStudentDataSource.sharedDataSource.updatUserState(state: Int(state.rawValue)!, success: { (result) in
            let userStateParser = self.parseUpdateUserStateAPI(details: result)
            if userStateParser.warning != "No Update happened" {
               SSStudentMessageHandler.sharedMessageHandler.sendStudentBenchStatus(UserState(rawValue:"\(userStateParser.userState)")!)
            }
            
            if Int(state.rawValue) == UserStateInt.Free.rawValue {
                self.moveToScheduleScreen()
            }
            // This is commented to avoid the issues of student app moving out of the live session
//            self.verifyUserState(userState: userStateParser.userState)
        }) { (error) in
            self.view.makeToast("\(error.code)-\(error.description)", duration: 0.5, position: .bottom)
        }
    }
    
    
    
    
    func classsBegin() {
        if let sessionId = sessionDetails.object(forKey: kSessionId) as? String {
            SSStudentDataSource.sharedDataSource.currentLiveSessionId = sessionId
            getUserSessionWithSessionID(sessionID: sessionId)
            RealmDatasourceManager.saveScreenStateOfUser(screenState: .LiveScreen, withUserId: SSStudentDataSource.sharedDataSource.currentUserId)

        }
    }
    
    @objc func onClassButton() {
        let buttonPosition :CGPoint = mClassNameButton.convert(CGPoint.zero, to: self.view)
        let remainingHeight = self.view.frame.size.height - (buttonPosition.y  + mClassNameButton.frame.size.height + mClassNameButton.frame.size.height)
        let questionInfoController = SSStudentSchedulePopoverController()
        questionInfoController.setCurrentScreenSize(CGSize(width: 400, height: remainingHeight))
        questionInfoController.setdelegate(self)
          classViewPopOverController = UIPopoverController(contentViewController: questionInfoController)
        classViewPopOverController.contentSize = CGSize(width: 400,height: remainingHeight);
        classViewPopOverController.delegate = self;
        questionInfoController.setPopover(classViewPopOverController)
        classViewPopOverController.present(from: CGRect(
            x:buttonPosition.x + mClassNameButton.frame.size.width / 2,
            y:buttonPosition.y  + mClassNameButton.frame.size.height,
            width: 1,
            height: 1), in: self.view, permittedArrowDirections: .up, animated: true)
    }
    
    
    
    
    
    @objc func startTimeUpdating() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        var _string :String = ""
        let currentDate = Date()
        _string = _string.stringFromTimeInterval(currentDate.timeIntervalSince(dateFormatter.date(from: (sessionDetails.object(forKey: kStartTime) as! String))!)).fullString
        mClassStatedLabel.text = "Started: \(_string)"
        let isgreatervalue :Bool ;
        isgreatervalue = currentDate.isGreaterThanDate(dateFormatter.date(from: sessionDetails.object(forKey: "EndTime") as! String)!)
        if isgreatervalue {
            if let sessionId = sessionDetails.object(forKey: kSessionId) as? String {
                startedTimeUpdatingTimer.invalidate()
                SSStudentDataSource.sharedDataSource.currentLiveSessionId = sessionId
//                getUserSessionWithSessionID(sessionID: sessionId)
            }
        }
    }
    
    
    private func getUserSessionWithSessionID(sessionID:String) {
        SSStudentDataSource.sharedDataSource.getSessionInfoWithSessionID(SessionId: sessionID,
        withSuccessHandle: { (reseponse) in
            self.gotSessionDetails(details: reseponse)
        },
        withfailurehandler: { (error) in
        })
    }
    
    
    
    
    private func gotSessionDetails(details:AnyObject) {
        sessionDetails.setObject((details.object(forKey: kStartTime)) ?? String(), forKey: kStartTime as NSCopying)
        sessionDetails.setObject((details.object(forKey: kEndTime)) ?? String(), forKey: kEndTime as NSCopying)
        if let sessionState = details.object(forKey: kSessionState) as? Int {
            if sessionState == SessionState.Live.rawValue {
                displaySessionLiveStatus()
            } else if sessionState == SessionState.Opened.rawValue {
                displaySessionOpendState()
            } else if (sessionState == SessionState.Scheduled.rawValue || sessionState == SessionState.Ended.rawValue || sessionState == SessionState.Cancelled.rawValue) {
                displayOtherStates()
            }
            sessionDetails.setObject("\(sessionState)", forKey: kSessionState as NSCopying )
        } else {
            mNoStudentLabel.isHidden = false
            classStartedView.isHidden = true
        }
        
        
        if let  TeacherId = details.object(forKey: "TeacherId") as? Int {
            SSStudentDataSource.sharedDataSource.currentTeacherId = "\(TeacherId)"
            let urlString = UserDefaults.standard.object(forKey: k_INI_UserProfileImageURL) as! String
            let userID = urlString.appending("/").appending("\(TeacherId)")
            if let checkedUrl = URL(string: "\(userID)_79px.jpg")  {
                mTeacherImageView.contentMode = .scaleAspectFit
                mTeacherImageView.downloadImage(checkedUrl, withFolderType: folderType.proFilePics)
            }
        }
        
        if let  TeacherName = details.object(forKey: "TeacherName") as? String {
            mTeacherName.text = TeacherName
            SSStudentDataSource.sharedDataSource.currentTeacherName = TeacherName
            
        }
    }
    
    
    
    private func displaySessionLiveStatus() {
        mNoStudentLabel.isHidden = true
        classStartedView.isHidden = false
        updateStudentState(state: UserState.Live)
        
        mNoStudentLabel.isHidden = true
        classStartedView.isHidden = false
        startedTimeUpdatingTimer.invalidate()
        startedTimeUpdatingTimer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(StudentClassViewController.startTimeUpdating), userInfo: nil, repeats: true)
        
    }
    
    
    
    func displaySessionOpendState() {
        
        mNoStudentLabel.isHidden = false
        classStartedView.isHidden = true
        updateStudentState(state: UserState.Occupied)
        
    }
    
    
    func displayOtherStates() {
        
        delegateSessionEnded()
    }
    
    
    
    
    func setCurrentSessionDetails(_ details: AnyObject)
    {
        sessionDetails = details as! NSMutableDictionary
    
    }
    
    
    
    // MARK: - datasource delegate Functions
    
    func didGetSessionInfoWithDetials(_ details: AnyObject)
    {
        
        sessionDetails.setObject((details.object(forKey: kStartTime)) ?? String(), forKey: kStartTime as NSCopying)
        sessionDetails.setObject((details.object(forKey: kEndTime)) ?? String(), forKey: kEndTime as NSCopying)
        
        if let sessionState = details.object(forKey: kSessionState) as? String
        {
            if sessionState == "1"
            {
               mNoStudentLabel.isHidden = true
                classStartedView.isHidden = false
                updateStudentState(state: UserState.Live)
                
                
                
                mNoStudentLabel.isHidden = true
                classStartedView.isHidden = false

                startedTimeUpdatingTimer.invalidate()
                startedTimeUpdatingTimer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(StudentClassViewController.startTimeUpdating), userInfo: nil, repeats: true)
                
                
                
            }
            else if sessionState == "2"
            {
                mNoStudentLabel.isHidden = false
                 classStartedView.isHidden = true
                updateStudentState(state: UserState.Occupied)

            }
            else if (sessionState == "4" || sessionState == "5" || sessionState == "6")
            {
                delegateSessionEnded()
            }
        }
        else
        {
            mNoStudentLabel.isHidden = false
            classStartedView.isHidden = true
        }
        
        
        if let  TeacherId = details.object(forKey: "TeacherId") as? String
        {
            SSStudentDataSource.sharedDataSource.currentTeacherId = TeacherId
            
            let urlString = UserDefaults.standard.object(forKey: k_INI_UserProfileImageURL) as! String
            
            let userID = urlString.appending("/").appending(TeacherId)
            
            
            if let checkedUrl = URL(string: "\(userID)_79px.jpg")
            {
                mTeacherImageView.contentMode = .scaleAspectFit
                mTeacherImageView.downloadImage(checkedUrl, withFolderType: folderType.proFilePics)
            }
            
            

        }
        
        if let  TeacherName = details.object(forKey: "TeacherName") as? String
        {
            mTeacherName.text = TeacherName
            
            SSStudentDataSource.sharedDataSource.currentTeacherName = TeacherName

        }
    }
    
    func didGetQuestionWithDetails(_ details: AnyObject)
    {
        currentQuestionDetails = details
        SSStudentMessageHandler.sharedMessageHandler.sendAcceptQuestionMessageToTeacherforType()
        
        
        if ((details.object(forKey: kQuestionTag) as AnyObject).object(forKey: kQuestionName) as? String) != ""
        {
            mQuestionNameLabel.text = ((details.object(forKey: kQuestionTag) as AnyObject).object(forKey: kQuestionName) as? String)
        }
        
        
        if ((details.object(forKey: kQuestionTag) as AnyObject).object(forKey: kQuestionType) as? String) != ""
        {
            currentQuestionType = ((details.object(forKey: kQuestionTag) as AnyObject).object(forKey: kQuestionType) as? String)!
        }
        
        
        let questionDetails = currentQuestionDetails.object(forKey: kQuestionTag)
        
        
        
        mQuestionView.setQuestionDetails(questionDetails! as AnyObject, withType: currentQuestionType, withSessionDetails: sessionDetails, withQuestion: currentQuestionLogId)
        
        mQuestionButton.newEventRaised()
        
    }
    
    
    // MARK: - Questions delegate 
    func delegateFullScreenButtonPressedWithOverlayImage(_ overlay:UIImage, withQuestionName name:String)
    {
        if mFullScreenView == nil{
            mFullScreenView = SSStudentFullscreenScribbleQuestion(frame:CGRect(x: 0,y: 0,width: self.view.frame.size.width,height: self.view.frame.size.height))
            mFullScreenView.setdelegate(self)
            self.view.addSubview(mFullScreenView)
            self.view.bringSubview(toFront: mFullScreenView)
        }
        
        mFullScreenView.isHidden = false
        
        mFullScreenView.setOverlayImage(overlay)
        mFullScreenView.questionText.text = name
    }
    
    
    func delegateFullScreenSendButtonPressedWithImage(_ writtenImage: UIImage)
    {
        mQuestionView.setFullScreenDrawnImage(writtenImage)
        mFullScreenView.isHidden = true
        
    }
    // MARK: - schedule popover delegate
    
    
    func delegateSessionEnded() {
        updateStudentState(state: UserState.Free)
        startedTimeUpdatingTimer.invalidate()
    }
    
    // MARK: - Loading subViews
    
    func loadSubview()
    {
        
        mQuestionButton.frame = CGRect(x: 10, y: 10, width: 100, height: 100)
        mQuestionButton.setImage("Questions_Selected.png", _unselectedImageName: "Questions.png", withText: "Question")
        classStartedView.addSubview(mQuestionButton)
        mQuestionButton.buttonselected()
         mQuestionButton.addTarget(self, action: #selector(StudentClassViewController.onQuestionButton), for: UIControlEvents.touchUpInside)
        
        mQuestionView = StudentQuestionView(frame:CGRect(x: mQuestionButton.frame.origin.x + mQuestionButton.frame.size.width ,y: mQuestionButton.frame.origin.y, width: classStartedView.frame.size.width - (mQuestionButton.frame.origin.x + mQuestionButton.frame.size.width + 10 ) , height: classStartedView.frame.size.height -  (mQuestionButton.frame.origin.y + mBottomBarImageView.frame.size.height )))
        mQuestionView.setdelegate(self)
        classStartedView.addSubview(mQuestionView)
        
        
        
        mQueryButton.frame = CGRect(x: 10 , y: mQuestionButton.frame.origin.y + mQuestionButton.frame.size.height + 20 , width: 100, height: 100)
        mQueryButton.setImage("Query_Selected.png",  _unselectedImageName:"Query.png" ,withText: "Query")
        classStartedView.addSubview(mQueryButton)
        mQueryButton.buttonUnSelected()
         mQueryButton.addTarget(self, action: #selector(StudentClassViewController.onQueryButton), for: UIControlEvents.touchUpInside)
       
        mQueryView = StudentsQueryView(frame:mQuestionView.frame)
         classStartedView.addSubview(mQueryView)
        mQueryView.isHidden = true
        mQueryView.queryPresentState(.TopicStopped)
        
        mSubmissionButton.frame = CGRect(x: 10 , y: mQueryButton.frame.origin.y + mQueryButton.frame.size.height + 20 , width: 100, height: 100)
         mSubmissionButton.setImage("poll_icon_selected.png",  _unselectedImageName: "poll_icon_unselected.png", withText: "POLL")
        classStartedView.addSubview(mSubmissionButton)
        mSubmissionButton.buttonUnSelected()
         mSubmissionButton.addTarget(self, action: #selector(StudentClassViewController.onOTFButton), for: UIControlEvents.touchUpInside)
        
        
        mOTFView = StudentOTFView(frame:mQuestionView.frame)
        classStartedView.addSubview(mOTFView)
        mOTFView.isHidden = true
        
        
        mSubTopicNamelabel.frame =  CGRect(x: mTeacherName.frame.origin.x + mTeacherName.frame.size.width + 10 , y: mTeacherName.frame.origin.y, width: mBottomBarImageView.frame.size.width - (mTeacherName.frame.origin.x + mTeacherName.frame.size.width + 20),height: mTeacherName.frame.size.height )
        mBottomBarImageView.addSubview(mSubTopicNamelabel)
        mSubTopicNamelabel.text = "No subtopic"
        mSubTopicNamelabel.font = UIFont(name:helveticaMedium, size: 16)
        mSubTopicNamelabel.textColor = UIColor.white
        mSubTopicNamelabel.textAlignment = .right
        
        
        
        mQuestionNameLabel.frame =  CGRect(x: mSubTopicNamelabel.frame.origin.x,y: mSubTopicNamelabel.frame.origin.y + mSubTopicNamelabel.frame.size.height + 5,width: mSubTopicNamelabel.frame.size.width,height: mSubTopicNamelabel.frame.size.height)
        mBottomBarImageView.addSubview(mQuestionNameLabel)
        mQuestionNameLabel.text = "No Question"
        mQuestionNameLabel.font = UIFont(name:helveticaMedium, size: 14)
        mQuestionNameLabel.textColor = UIColor.white
        mQuestionNameLabel.textAlignment = .right
        
        
        SSStudentMessageHandler.sharedMessageHandler.createRoomWithRoomName("question_\((sessionDetails.object(forKey: "SessionId") as! String))", withHistory: "1")
        
        
        
    }
    
  
    
    // MARK: - student Message handler
    
    
    @objc func onQuestionButton()
    {
        mQuestionView.isHidden = false
        mQueryView.isHidden = true
        mOTFView.isHidden = true
        mSubmissionButton.buttonUnSelected()
         mQueryButton.buttonUnSelected()
        mQuestionButton.buttonselected()
        
    }
    
    @objc func onQueryButton()
    {
        mQuestionView.isHidden = true
        mQueryView.isHidden = false
         mOTFView.isHidden = true
        mSubmissionButton.buttonUnSelected()
        mQueryButton.buttonselected()
        mQuestionButton.buttonUnSelected()
    }
    
    @objc func onOTFButton()
    {
        mQuestionView.isHidden = true
        mQueryView.isHidden = true
        mOTFView.isHidden = false
        mSubmissionButton.buttonselected()
        mQueryButton.buttonUnSelected()
        mQuestionButton.buttonUnSelected()
        
    }
    
    
    
    func onBack()
    {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    // MARK: - message handler functions
    
    func smhDidRecieveStreamConnectionsState(_ state: Bool) {
       
         mstatusImage.backgroundColor = standard_Red
    }
    

    
    
    func smhStreamReconnectingWithDelay(_ delay: Int32) {
        self.view.makeToast("Reconnecting in \(delay) seconds", duration: 0.5, position: .bottom)
        AppDelegate.sharedDataSource.showReconnecting()

    }
    
    func smhDidReciveAuthenticationState(_ state: Bool, WithName userName: String) {
        if state == false {
            mstatusImage.backgroundColor = standard_Red
            self.view.makeToast("Not Able to Authenticate current user. Plese try again", duration: 0.5, position: .bottom)
        } else {
            mstatusImage.backgroundColor = standard_Green
            updateStudentState(state: UserState.Live)
        }
        AppDelegate.sharedDataSource.hideReconnecting()
    }
    
    
    func smhDidGetSessionStateChange(){
        if classStartedView.isHidden == true{
            classStartedView.isHidden = false
            classsBegin()
        }
        
        mQueryView.VolunteerPresentState(false)
        if mStudentQrvAnsweringView != nil{
            mStudentQrvAnsweringView.removeFromSuperview()
        }
        
        mNoStudentLabel.isHidden = true
    }
    
    
    func smhDidgetTimeExtendedWithDetails(_ Details: AnyObject)
    {
        
        
        if classStartedView.isHidden == true
        {
            classStartedView.isHidden = false
             classsBegin()
        }
        
        mQueryView.VolunteerPresentState(false)
        if mStudentQrvAnsweringView != nil
        {
            mStudentQrvAnsweringView.removeFromSuperview()
        }
        
        

            mNoStudentLabel.isHidden = true 
    }
    
    func smhDidGetSessionEndMessageWithDetails(_ details: AnyObject) {
       updateStudentState(state: UserState.Free)
    }
    
    func smhEndSession()
    {
        if classViewPopOverController != nil{
            classViewPopOverController.dismiss(animated: true)
        }
        let storyboard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let preallotController : SSStudentScheduleViewController = storyboard.instantiateViewController(withIdentifier: "TeacherScheduleViewController") as! SSStudentScheduleViewController
        self.present(preallotController, animated: true, completion: nil)
    }
    
    func smhDidGetTopicStateChanged(topic:Topic){
        if topic.topicState == TopicState.Ended{
            mQueryView.queryPresentState(.TopicStopped)
            mSubTopicNamelabel.text = "No subtopic"
            LearniatToast.showToast(view: self.view, duration:5.0, image:"wrongMatch.png", text: "Topic Stopped")
        }
        else{
            mSubTopicNamelabel.text = topic.topicName
            mQueryView.queryPresentState(.TopicStarted)
            LearniatToast.showToast(view: self.view, duration:5.0, text: "Topic Started")
        }
        
    }
    
    func smhDidGetTopicChanged(topic: Topic){
        if topic.topicState == TopicState.Started{
            mSubTopicNamelabel.text = topic.topicName
            mQueryView.queryPresentState(.TopicStarted)
            LearniatToast.showToast(view: self.view, duration:5.0, text: "Topic Started")
        }
        else{
            mSubTopicNamelabel.text = "No subtopic"
            mQueryView.queryPresentState(.TopicStopped)
        }
        SSStudentDataSource.sharedDataSource.currentSubtopicID = topic.topicId
        currentSubTopicId = topic.topicId

    }
    
    
    
    
//    func smhDidGetVotingMessageWithDetails(_ details: AnyObject)
//    {
//        
//        
//        
//        if let VotingValue = details.object(forKey: "VotingValue") as? String
//        {
//            if VotingValue == "TRUE"
//            {
//                
//                mQueryView.queryPresentState(.TopicStarted)
//                
//                if (details.object(forKey: "SubTopicName") != nil)
//                {
//                    if let SubTopicName = details.object(forKey: "SubTopicName") as? String
//                    {
//                        mSubTopicNamelabel.text = SubTopicName
//                    }
//                    else
//                    {
//                        mSubTopicNamelabel.text = "No subtopic"
//                    }
//                }
//                else
//                {
//                    mSubTopicNamelabel.text = "No subtopic"
//                }
//                
//                
//                LearniatToast.showToast(view: self.view, duration:5.0, text: "Topic Started")
//                
//                
//                
//            }
//            else
//            {
//                 mQueryView.queryPresentState(.TopicStopped)
//                mSubTopicNamelabel.text = "No subtopic"
//
//                LearniatToast.showToast(view: self.view, duration:5.0, image:"wrongMatch.png", text: "Topic Stopped")
//                
//            }
//            
//            
//            if let subtopicId = details.object(forKey: "SubTopicId") as? String
//            {
//                SSStudentDataSource.sharedDataSource.currentSubtopicID = subtopicId
//                
//                currentSubTopicId = subtopicId
//            }
//            
//        }
//    }
    
    func smhDidReceiveQuesitonIdChange(question:Question){
        mQuestionButton.isHidden = false
        if mFullScreenView != nil{
            
            // By Ujjval
            // ==========================================
            
//            mFullScreenView.mScribbleView.clearButtonClicked()
            mFullScreenView.mScribbleView.clear()
            
            // ==========================================
            
        }
        if let QuestionLogId:String = question.questionId{
            currentQuestionLogId = QuestionLogId
            var messageString:String!
            if question.questionType  == text{
                messageString = "Please type out your response";
                showAlertWithMessage(messageString)
            }
            else if question.questionType  == MatchColumns{
                messageString = "Please rearrange the list to match other list";
                showAlertWithMessage(messageString)
            }
            else if  question.questionType  == MultipleChoice{
                messageString = "Please Select correct Response (Just one)";
                showAlertWithMessage(messageString)
            }
            else if question.questionType  == MultipleResponse{
                messageString = "Please Select correct Responses (More than one or just one)";
                showAlertWithMessage(messageString)
            }
            else if question.questionType  == OverlayScribble{
                messageString = "Please hand draw over the picture sent";
                showAlertWithMessage(messageString)
            }
            else if question.questionType  == FreshScribble{
                messageString = "Please sketch your response";
                showAlertWithMessage(messageString)
            }
            else if question.questionType  == OneString{
                messageString = "Please type one word answer";
                showAlertWithMessage(messageString)
            }
            else if question.questionType  == TextAuto{
                messageString = "Please type one word answer";
                showAlertWithMessage(messageString)
            }
        }
        
        if classStartedView.isHidden == true{
            classStartedView.isHidden = false
        }
    }
    
    func smhDidReceiveQuestionStateChange(question:Question){
        if question.questionState == QuestionState.Ended{
            processQuestionEnded(question:question)
        }
        else if question.questionState == QuestionState.Frozen{
            processFreezeQuestion(question:question)
        }
        else if question.questionState == QuestionState.Started{
            smhDidReceiveQuesitonIdChange(question:question)
        }
    }
    
    func processQuestionEnded(question:Question){
        mQuestionView.questionCleared()
        mQuestionNameLabel.text = "No active question"
        if mFullScreenView != nil{
            mFullScreenView.removeFromSuperview()
            mFullScreenView = nil
        }
        if questionAcceptAlert.isVisible == true{
            questionAcceptAlert.dismiss(withClickedButtonIndex: -1, animated: true)
        }
        if classStartedView.isHidden == true{
            classsBegin()
        }
        mQuestionView.questionCleared()
        waitQuestionTimer.invalidate()
        if SSStudentDataSource.sharedDataSource.answerSent == true{
            SSStudentDataSource.sharedDataSource.answerSent = false
        }
        mQuestionButton.newEventRaised()
    }
    
    func processFreezeQuestion(question:Question){
        if SSStudentDataSource.sharedDataSource.answerSent == false{
            if currentQuestionType == kOverlayScribble || currentQuestionType == kFreshScribble{
                if mFullScreenView != nil{
                    mFullScreenView.onSendButton()
                }
            }
        }
        mQuestionView.didgetFreezMessageFromTeacher()
        mQuestionButton.newEventRaised()
    }
    
    
    
    func smhdidReceiveQuestionSentMessage(_ dict: AnyObject)
    {
        
        mQuestionButton.isHidden = false
        if mFullScreenView != nil
        {
            // By Ujjval
            // Clear image
            // ==========================================
            
//            mFullScreenView.mScribbleView.clearButtonClicked()
            mFullScreenView.mScribbleView.clear()
            
            // ==========================================
        }
        
        if let QuestionLogId = dict.object(forKey: "QuestionLogId") as? String
        {
            currentQuestionLogId = QuestionLogId
            var messageString:String!
            
            if dict.object(forKey: kQuestionType) as! String  == text
            {
                messageString = "Please type out your response";
                showAlertWithMessage(messageString)
                
            }
            else if dict.object(forKey: kQuestionType) as! String  == MatchColumns
            {
                messageString = "Please rearrange the list to match other list";
                showAlertWithMessage(messageString)
                
                
            }
            else if  dict.object(forKey: kQuestionType) as! String  == MultipleChoice
            {
                messageString = "Please Select correct Response (Just one)";
                showAlertWithMessage(messageString)
                
            }
            else if dict.object(forKey: kQuestionType) as! String  == MultipleResponse
            {
                
                messageString = "Please Select correct Responses (More than one or just one)";
                showAlertWithMessage(messageString)
            }
            else if dict.object(forKey: kQuestionType) as! String  == OverlayScribble
            {
                
                messageString = "Please hand draw over the picture sent";
                showAlertWithMessage(messageString)
                
            }
            else if dict.object(forKey: kQuestionType) as! String  == FreshScribble
            {
                
                messageString = "Please sketch your response";
               showAlertWithMessage(messageString)
               
            }
            else if dict.object(forKey: kQuestionType) as! String  == OneString
            {
                
                messageString = "Please type one word answer";
                showAlertWithMessage(messageString)
               
            }
            else if dict.object(forKey: kQuestionType) as! String  == TextAuto
            {
                
                messageString = "Please type one word answer";
                showAlertWithMessage(messageString)
                
            }
        }
        
        
        
        if classStartedView.isHidden == true
        {
            classStartedView.isHidden = false
        }
        
    }
    
    
    
    func smhdidReceiveQuestionClearMessage()
    {
        mQuestionView.questionCleared()
        mQuestionNameLabel.text = "No active question"
       
        if mFullScreenView != nil
        {
            mFullScreenView.removeFromSuperview()
            mFullScreenView = nil
        }


//        SSStudentDataSource.sharedDataSource.getGraspIndexwithTopicId(currentSubTopicId, withSessionId: (sessionDetails.objectForKey("SessionId") as! String), withDelegate: self)
       
        
        if questionAcceptAlert.isVisible == true{
            questionAcceptAlert.dismiss(withClickedButtonIndex: -1, animated: true)
        }
        
        
        if classStartedView.isHidden == true
        {
            classsBegin()
        }
        
        mQuestionView.questionCleared()
        
        waitQuestionTimer.invalidate()
        
        if SSStudentDataSource.sharedDataSource.answerSent == true
        {
            SSStudentDataSource.sharedDataSource.answerSent = false
        }
         mQuestionButton.newEventRaised()
        
        
        
    }
    
    func smhdidReceiveQuestionFreezMessage()
    {
        if SSStudentDataSource.sharedDataSource.answerSent == false
        {
            if currentQuestionType == kOverlayScribble || currentQuestionType == kFreshScribble
            {
                if mFullScreenView != nil
                {
                    mFullScreenView.onSendButton()
                    
                }
            }
           
        }
        
         mQuestionView.didgetFreezMessageFromTeacher()
        
         mQuestionButton.newEventRaised()
       
    }
    
    
    func smhdidRecieveQueryReviewmessage()
    {
        mQueryView.teacherReviewQuery()
        mQueryButton.newEventRaised()
    }
    func smhDidRecieveMutemessageWithDetails(_ details: AnyObject)
    {
        if details.object(forKey: "MUTESTATUS") != nil
        {
            if let muteState = details.object(forKey: "MUTESTATUS") as? String
            {
                if muteState == "1"
                {
                    studentImage.image = UIImage(named: "StudentMuted.png")
                    mQueryView.queryPresentState(.StudentMuted)
                }
                else
                {
                    mQueryView.queryPresentState(.TopicStarted)
                    let urlString = UserDefaults.standard.object(forKey: k_INI_UserProfileImageURL) as! String
                    
                    let userID = urlString.appending("/").appending(SSStudentDataSource.sharedDataSource.currentUserId)
                    
                    
                    if let checkedUrl = URL(string: "\(userID)_79px.jpg")

                    {
                        studentImage.contentMode = .scaleAspectFit
                        studentImage.downloadImage(checkedUrl, withFolderType: folderType.proFilePics)
                    }
                }
            }
        }
        
    }
    
    func smhdidGetQueryFeedBackFromTeacherWithDetials(_ details: AnyObject)
    {
        mQueryView.feedBackSentFromTeacherWithDetiails(details)
        mQueryButton.newEventRaised()
    }
    
     func smhdidRecieveQueryOpenedForVotingWithDetails()
     {
        mQueryView.VolunteerPresentState(true)
        mQueryButton.newEventRaised()
    }
    func smhdidRecieveQueryVolunteeringEnded()
    {
         mQueryView.VolunteerPresentState(false)
        mQueryButton.newEventRaised()
        if mStudentQrvAnsweringView != nil
        {
            mStudentQrvAnsweringView.removeFromSuperview()
        }
        if questionAcceptAlert.isVisible == true
        {
            questionAcceptAlert.dismiss(withClickedButtonIndex: -1, animated: true)
        }

    }
    
    
    func smhDidRecieveQueryAnsweringMessageWithDetails(_ details: AnyObject)
    {
        if details.object(forKey: "AnsweringStudentId") != nil
        {
            if let AnsweringStudentId = details.object(forKey: "AnsweringStudentId") as? String
            {
                if AnsweringStudentId == SSStudentDataSource.sharedDataSource.currentUserId
                {
                    if questionAcceptAlert.isVisible == true{
                        questionAcceptAlert.dismiss(withClickedButtonIndex: -1, animated: true)
                    }

                    questionAcceptAlert = UIAlertView()
                    questionAcceptAlert.title = "Teacher selected you"
                    questionAcceptAlert.message = "Please stand up and answer"
                    questionAcceptAlert.addButton(withTitle: "OK")
                    questionAcceptAlert.show()
                    questionAcceptAlert.delegate = self
                    
                   
                }
                
                
                mStudentQrvAnsweringView = StudentVolunteeringView(frame:CGRect(x: 0,y: 0,width: self.view.frame.size.width, height: self.view.frame.size.height))
                mStudentQrvAnsweringView.setVolunteeringDetails(details)
                self.view.addSubview(mStudentQrvAnsweringView)
                
                

            }
        }
        
    }
    
    
    func smhdidRecieveQueryVolunteeringClosedMessageWithDetails(_ details: AnyObject)
    {
        if mStudentQrvAnsweringView != nil
        {
            mStudentQrvAnsweringView.removeFromSuperview()
        }
        
        
        if questionAcceptAlert.isVisible == true{
            questionAcceptAlert.dismiss(withClickedButtonIndex: -1, animated: true)
        }
        
        var totalVotes :CGFloat = 0 ;
        
        
        if details.object(forKey: "QueryId") != nil
        {
             if let QueryId = details.object(forKey: "QueryId") as? String
             {
                
                if details.object(forKey: "totalPercentage") != nil
                {
                    if let _totalVotes = details.object(forKey: "totalPercentage") as? String
                    {
                        
                        if let n = NumberFormatter().number(from: _totalVotes)
                        {
                             totalVotes = CGFloat(n)
                        }
                        
                       
                    }
                }
                
               
                if totalVotes < 0
                {
                    totalVotes = 0
                }
                
                if details.object(forKey: "StudentId") != nil
                {
                    if let StudentId = details.object(forKey: "StudentId") as? String
                    {
                        
                        mQueryView.volunteerClosedWithQueryId(QueryId, withStudentdID: StudentId, withTotalVotes:totalVotes)
                        mQueryButton.newEventRaised()
                    }
                }
                
            }
        }
    }
    
    func smhDidRecievePollingStartedMessageWithDetails(_ detials: AnyObject)
    {
       mOTFView.didGetPollingStartedWithDetills(detials)
        mSubmissionButton.newEventRaised()
    }
    
    func smhDidGetPollEndedMessageFromteacher()
    {
        mOTFView.didGetPollingStopped()
        mSubmissionButton.newEventRaised()
    }
    
    
    func smhDidGetGraphSharedWithDetails(_ details: AnyObject)
    {
        mQuestionView.didGetGraphSharedWithDetails(details)
        
         mQuestionButton.newEventRaised()
    }
    
    func smhDidGetTeacherReviewMessage()
    {
        mQuestionView.didgetTeacherEvaluatingMessage()
         mQuestionButton.newEventRaised()
    }
    
    func smhDidGetFeedbackForAnswerWithDetils(_ details: AnyObject)
    {
        if (details.object(forKey: "AssesmentAnswerId") != nil)
        {
          
            if let AssesmentAnswerId = details.object(forKey: "AssesmentAnswerId") as? String
            {
                 mQuestionView.getFeedbackDetailsWithId(AssesmentAnswerId)
                 mQuestionButton.newEventRaised()
            }
        }
    }
    
    func smhDidGetPeakViewMessage()
    {
        if mFullScreenView != nil
        {
          let peakImage =   mFullScreenView.getCurrentImage()
            
            let imageData:Data = UIImagePNGRepresentation(peakImage)!
            let strBase64:String = imageData.base64EncodedString(options: .lineLength64Characters)
            SSStudentMessageHandler.sharedMessageHandler.sendPeakViewMessageToTeacherWithImageData(strBase64)
            
            
        }
        else
        {
            mQuestionView.getPeakViewMessage()
        }
        
        
    }
    
    func smhdidRecieveModelAnswerMessageWithDetials(_ details: AnyObject)
    {
        
        if currentQuestionType == text  || currentQuestionType == OverlayScribble || currentQuestionType == FreshScribble
        {
          mQuestionView.modelAnswrMessageRecieved()
             mQuestionButton.newEventRaised()
            
        }
        
    }
    
     // MARK:  Collaboration Messages
    
    func smhDidRecieveCollaborationPingFromTeacher(_ details: AnyObject) {
        
        if let category = details.object(forKey: "category") as? String
        {
            if let categoryID = details.object(forKey: "categoryID") as? String
            {
                 mOTFView.didGetCollaborationStartedMessageWithCategoryName(category, withCategoryID: categoryID)
            }
            
           
        }
        
        onOTFButton()
        
        
    }
    
    
    func smhDidRecieveSuggestionStatusFromTeacher(_ details: AnyObject) {
        
        
        if let status = details.object(forKey: "status") as? String
        {
            mOTFView.didGetsuggestionStatusWithState(state: status)
            
        }
        
    }
    
    func smhDidRecieveCollaborationEndedFromTeacher()
    {
        mOTFView.didGetCollaborationStopped()
        
    }
    
    
   
    // MARK: - message handler functions
    func showAlertWithMessage(_ message:String)
    {
        
        if SSStudentDataSource.sharedDataSource.currentUSerState == UserState.Live || SSStudentDataSource.sharedDataSource.currentUSerState == UserState.BackGround
        {
            
            if questionAcceptAlert.isVisible == true{
                questionAcceptAlert.dismiss(withClickedButtonIndex: -1, animated: true)
            }
            
            questionAcceptAlert = UIAlertView()
            questionAcceptAlert.title = "Received a question"
            questionAcceptAlert.message = message
//            questionAcceptAlert.addButtonWithTitle("Wait")
            questionAcceptAlert.addButton(withTitle: "Accept")
            questionAcceptAlert.show()
            questionAcceptAlert.delegate = self
            questionAcceptAlert.tag = 1011
        }
        else
        {
            if questionAcceptAlert.isVisible == true
            {
                questionAcceptAlert.dismiss(withClickedButtonIndex: -1, animated: true)
            }
        }
    }
   
    func alertView(_ alertView: UIAlertView!, clickedButtonAtIndex buttonIndex: Int)
    {
        if alertView.tag == 1011
        {
//            if (buttonIndex == 0)
//            {
//                waitQuestionTimer = NSTimer.scheduledTimerWithTimeInterval(0.4, target: self, selector: #selector(StudentClassViewController.waitForQuestion), userInfo: nil, repeats: true)
//            }
//            else
//            {
//              
//            }
            
            
            SSStudentDataSource.sharedDataSource.fetchQuestionWithQuestionLogId(currentQuestionLogId, WithDelegate: self)
            waitQuestionTimer.invalidate()
            
        }
    }
    
    func waitForQuestion()
    {
        
    }

    func Settings_RefreshApp()
    {
        refreshApp()
        if classViewPopOverController != nil{
            classViewPopOverController.dismiss(animated: true)
        }
        
    }
    
    
    func Settings_XmppReconnectButtonClicked()
    {
        SSStudentMessageHandler.sharedMessageHandler.performReconnet(connectType: "Other")
        
        
      
    }
    
    
    
    func refreshApp()
    {
        SSStudentDataSource.sharedDataSource.refreshApp(success: { (response) in
            
            if let summary = response.object(forKey: "Summary") as? NSArray
            {
                if summary.count > 0
                {
                    let summaryValue = summary.firstObject
                    self.evaluateStateWithSummary(details: summaryValue as AnyObject)
                }
            }
            
            
        }) { (error) in
            
        }
    }

    deinit {
        SSStudentDataSource.sharedDataSource.isBackgroundSignal.cancelAllSubscriptions()
    }
}




extension StudentClassViewController {
    
    fileprivate func getCurrentSessionState()->String {
        
        if let sessionState = sessionDetails.object(forKey: kSessionState) as?  String {
            return sessionState
        }
        return kopenedString
    }
    
    fileprivate func getCurrentStudentState() -> Int {
        var userState = UserStateInt.Occupied.rawValue
        
        switch getCurrentSessionState() {
        case kopenedString:
            userState = UserStateInt.Occupied.rawValue
            break
        case kLiveString:
            userState = UserStateInt.Live.rawValue
            break
        default:
            userState = UserStateInt.Occupied.rawValue
            break
        }
        
        return userState
    }
    
    
    fileprivate func parseUpdateUserStateAPI(details:AnyObject)->(userState:Int, warning:String) {
        
        if let user_state = details.object(forKey: "user_state") as? Int {
            if let warningMessage = details.object(forKey: "warning") as? String {
                return (user_state, warningMessage)
            }
            return (user_state, "")
        }
        
         return (0, "")
    }
    
    
    
    fileprivate func evaluateStateWithSummary(details:AnyObject)
    {
        if let myState =  details.object(forKey: "MyState") as? Int {
            if let CurrentSessionState = details.object(forKey: "CurrentSessionState") as? Int {
                if CurrentSessionState == SessionState.Live.rawValue {
                    classsBegin()
                    if myState != UserStateInt.Live.rawValue {
                        updateStudentState(state: UserState.Live)
                    }
                } else if CurrentSessionState == SessionState.Opened.rawValue {
                    displaySessionOpendState()
                    if myState != UserStateInt.Occupied.rawValue {
                        updateStudentState(state: UserState.Occupied)
                    }
                } else {
                    delegateSessionEnded()
                    
                }
            } else {
                delegateSessionEnded()
            }
        }
    }
    
    fileprivate func verifyUserState(userState:Int) {
        switch userState {
        case UserStateInt.Free.rawValue:
            self.moveToScheduleScreen()
        case UserStateInt.SignedOut.rawValue:
            self.moveToScheduleScreen()
        default: break
            
        }
    }
    
    fileprivate func moveToScheduleScreen() {
        RealmDatasourceManager.saveScreenStateOfUser(screenState: .ScheduleScreen, withUserId: SSStudentDataSource.sharedDataSource.currentUserId)
        if classViewPopOverController != nil{
            classViewPopOverController.dismiss(animated: true)
        }
        let storyboard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let preallotController : SSStudentScheduleViewController = storyboard.instantiateViewController(withIdentifier: "TeacherScheduleViewController") as! SSStudentScheduleViewController
        self.present(preallotController, animated: true, completion: nil)
    }

   
    
}

