//
//  StudentClassViewController.swift
//  LearniatStudent
//
//  Created by Deepak MK on 22/04/16.
//  Copyright © 2016 Mindshift. All rights reserved.
//

import Foundation
class StudentClassViewController: UIViewController,SSStudentDataSourceDelegate,SSStudentMessageHandlerDelegate,StudentQuestionViewDelegate,SSStudentFullscreenScribbleQuestionDelegate
{
    
    var sessionDetails               :AnyObject!
    
    var mTopbarImageView             :UIImageView           = UIImageView()
    
    
    var mTeacherImageView: UIImageView!
    
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
    var waitQuestionTimer                   = NSTimer()
    
    
    var mStudentQrvAnsweringView           :StudentVolunteeringView!
    
    var startedTimeUpdatingTimer = NSTimer()
    
    
    var mFullScreenView         :SSStudentFullscreenScribbleQuestion!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        
        self.view.backgroundColor = darkBackgroundColor
        
        SSStudentMessageHandler.sharedMessageHandler.setdelegate(self)
        
        mTopbarImageView = UIImageView(frame: CGRectMake(0, 0, self.view.frame.size.width, 60))
        mTopbarImageView.backgroundColor = topbarColor
        self.view.addSubview(mTopbarImageView)
        mTopbarImageView.userInteractionEnabled = true
        mTopbarImageView.userInteractionEnabled = true
        
        let studentImage = UIImageView(frame:CGRectMake(15, 15, mTopbarImageView.frame.size.height - 20 ,mTopbarImageView.frame.size.height - 20))
        mTopbarImageView.addSubview(studentImage)
        
        let urlString = NSUserDefaults.standardUserDefaults().objectForKey(k_INI_UserProfileImageURL) as! String
        
        if let checkedUrl = NSURL(string: "\(urlString)/\(SSStudentDataSource.sharedDataSource.currentUserId)_79px.jpg")
        {
            studentImage.contentMode = .ScaleAspectFit
            studentImage.downloadImage(checkedUrl, withFolderType: folderType.ProFilePics)
        }
        
        
        
        let studentName = UILabel(frame: CGRectMake(studentImage.frame.origin.x + studentImage.frame.size.width + 10, studentImage.frame.origin.y, 200, 20))
        mTopbarImageView.addSubview(studentName)
        studentName.textColor = UIColor.whiteColor()
        studentName.text = SSStudentDataSource.sharedDataSource.currentUserName.capitalizedString

        
        

        
        mClassName = UILabel(frame: CGRectMake(mTopbarImageView.frame.size.width/2 - 100 , 15, 500, 20))
        mClassName.font = UIFont(name:helveticaRegular, size: 20)
        
        mTopbarImageView.addSubview(mClassName)
        mClassName.textColor = UIColor.whiteColor()
        mClassName.textAlignment = .Left
        
        if let ClassName = sessionDetails.objectForKey("ClassName") as? String
        {
            mClassName.text = ClassName
        }
        
        
        
        mstatusImage .frame = CGRectMake(mClassName.frame.origin.x  - (mClassName.frame.size.height + 5),mClassName.frame.origin.y  ,mClassName.frame.size.height,mClassName.frame.size.height)
        mstatusImage.backgroundColor  = UIColor(red: 255/255.0, green: 59/255.0, blue: 48/255.0, alpha: 1)
        mTopbarImageView.addSubview(mstatusImage)
        mstatusImage.layer.cornerRadius = mstatusImage.frame.size.width/2
        
        
        
        mClassStatedLabel.frame =  CGRectMake(mClassName.frame.origin.x, mClassName.frame.origin.y + mClassName.frame.size.height + 3 , mClassName.frame.size.width, mClassName.frame.size.height)
        mClassStatedLabel.textColor = UIColor.whiteColor()
        mClassStatedLabel.numberOfLines = 2
        
        mClassStatedLabel.textAlignment = .Left
        mClassStatedLabel.font = UIFont(name: helveticaMedium, size: 14)
        mTopbarImageView.addSubview(mClassStatedLabel)
        


        
        
        classStartedView.frame = CGRectMake(0, mTopbarImageView.frame.size.height, self.view.frame.size.width, self.view.frame.size.height - mTopbarImageView.frame.size.height)
        classStartedView.backgroundColor = darkBackgroundColor
        self.view.addSubview(classStartedView)
        classStartedView.hidden = true
        
        
        
       
        
        
        mBottomBarImageView.frame = CGRectMake(0, classStartedView.frame.size.height - 60, classStartedView.frame.size.width, 60)
        classStartedView.addSubview(mBottomBarImageView)
        mBottomBarImageView.backgroundColor = topbarColor
        
        mTeacherImageView = UIImageView(frame: CGRectMake(10, 10, mBottomBarImageView.frame.size.height - 20 ,mBottomBarImageView.frame.size.height - 20))
        mTeacherImageView.backgroundColor = lightGrayColor
        mBottomBarImageView.addSubview(mTeacherImageView)
        mTeacherImageView.layer.masksToBounds = true
        mTeacherImageView.layer.cornerRadius = 2
        
        mTeacherName = UILabel(frame: CGRectMake(mTeacherImageView.frame.origin.x + mTeacherImageView.frame.size.width + 10, mTeacherImageView.frame.origin.y, 200, 20))
        mTeacherName.font = UIFont(name:helveticaMedium, size: 20)
        mBottomBarImageView.addSubview(mTeacherName)
        mTeacherName.textColor = UIColor.whiteColor()
        
        
        let teacher = UILabel(frame: CGRectMake(mTeacherImageView.frame.origin.x + mTeacherImageView.frame.size.width + 10, mTeacherName.frame.origin.y + mTeacherName.frame.size.height + 5, 200, 20))
        mBottomBarImageView.addSubview(teacher)
        teacher.text = "Teacher"
        teacher.font = UIFont(name:helveticaRegular, size: 16)
        teacher.textColor = UIColor.whiteColor()
        
      
        
        mNoStudentLabel.frame = CGRectMake(10, (self.view.frame.size.height - 40)/2, self.view.frame.size.width - 20,40)
        mNoStudentLabel.font = UIFont(name:helveticaMedium, size: 30)
        mNoStudentLabel.text = "Wait for the teacher to begin :)"
        self.view.addSubview(mNoStudentLabel)
        mNoStudentLabel.textColor = UIColor.whiteColor()
        mNoStudentLabel.textAlignment = .Center
        mNoStudentLabel.hidden = true
        
        
        if let sessionId = sessionDetails.objectForKey(kSessionId) as? String
        {
            SSStudentDataSource.sharedDataSource.currentLiveSessionId = sessionId
            SSStudentDataSource.sharedDataSource.getUserSessionWithDetails(sessionId, withDelegate: self)
            
        }
        
        
        switch (sessionDetails.objectForKey("SessionState") as! String)
        {
            case kopenedString:
                mstatusImage.backgroundColor = UIColor(red: 255/255.0, green: 59/255.0, blue: 48/255.0, alpha: 1)
                mClassStatedLabel.text = "Class not started yet"
                mNoStudentLabel.hidden = false
                classStartedView.hidden = true
                
                break
            
            case kLiveString:
                
                
                let dateFormatter = NSDateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                
                var _string :String = ""
                let currentDate = NSDate()
                
                
                
                _string = _string.stringFromTimeInterval(currentDate.timeIntervalSinceDate(dateFormatter.dateFromString((sessionDetails.objectForKey("StartTime") as! String))!)).fullString
                
                mstatusImage.backgroundColor = UIColor(red: 76.0/255.0, green: 217.0/255.0, blue: 100.0/255.0, alpha: 1)
                mClassStatedLabel.text = "Started: \(_string)"
                mNoStudentLabel.hidden = true
                classStartedView.hidden = false
                
                startedTimeUpdatingTimer.invalidate()
                startedTimeUpdatingTimer = NSTimer.scheduledTimerWithTimeInterval(0.1, target: self, selector: #selector(StudentClassViewController.startTimeUpdating), userInfo: nil, repeats: true)
                
                break
            
            default:
                mstatusImage.backgroundColor =  UIColor(red: 255/255.0, green: 59/255.0, blue: 48/255.0, alpha: 1)
                break
        }
         loadSubview()
        
        
    }
    
    func classsBegin()
    {
        
        
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        var _string :String = ""
        let currentDate = NSDate()
        _string = _string.stringFromTimeInterval(currentDate.timeIntervalSinceDate(dateFormatter.dateFromString((sessionDetails.objectForKey("StartTime") as! String))!)).fullString
        
        
        mstatusImage.backgroundColor = UIColor(red: 76.0/255.0, green: 217.0/255.0, blue: 100.0/255.0, alpha: 1)
        mNoStudentLabel.hidden = true
        classStartedView.hidden = false
        mClassStatedLabel.text = "Started: \(_string)"
        
        SSStudentDataSource.sharedDataSource.updateStudentStatus(kUserStateLive, ofSession:(sessionDetails.objectForKey("SessionId") as! String), withDelegate: self)
        
        startedTimeUpdatingTimer.invalidate()
        startedTimeUpdatingTimer = NSTimer.scheduledTimerWithTimeInterval(0.1, target: self, selector: #selector(StudentClassViewController.startTimeUpdating), userInfo: nil, repeats: true)
        
    }
    
    
    func startTimeUpdating()
    {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        var _string :String = ""
        let currentDate = NSDate()
        _string = _string.stringFromTimeInterval(currentDate.timeIntervalSinceDate(dateFormatter.dateFromString((sessionDetails.objectForKey("StartTime") as! String))!)).fullString
        mClassStatedLabel.text = "Started: \(_string)"
    }
    
    
    
    func setCurrentSessionDetails(details: AnyObject)
    {
        sessionDetails = details
        
        
    }
    
    
    
    // MARK: - datasource delegate Functions
    
    func didGetSessionInfoWithDetials(details: AnyObject)
    {
        print(details)
        
        
        if let sessionState = details.objectForKey("SessionState") as? String
        {
            if sessionState == "1"
            {
               mNoStudentLabel.hidden = true
                classStartedView.hidden = false
                if let sessionId = sessionDetails.objectForKey(kSessionId) as? String
                {
                     SSStudentDataSource.sharedDataSource.updateStudentStatus(kUserStateLive, ofSession: sessionId, withDelegate: self)
                }
            }
            else
            {
                mNoStudentLabel.hidden = false
                 classStartedView.hidden = true
                if let sessionId = sessionDetails.objectForKey(kSessionId) as? String
                {
                    SSStudentDataSource.sharedDataSource.updateStudentStatus(kUserOccupied, ofSession: sessionId, withDelegate: self)
                }

            }
        }
        else
        {
            mNoStudentLabel.hidden = false
            classStartedView.hidden = true
        }
        
        
        if let  TeacherId = details.objectForKey("TeacherId") as? String
        {
            SSStudentDataSource.sharedDataSource.currentTeacherId = TeacherId
            
            let urlString = NSUserDefaults.standardUserDefaults().objectForKey(k_INI_UserProfileImageURL) as! String
            
            if let checkedUrl = NSURL(string: "\(urlString)/\(TeacherId)_79px.jpg")
            {
                mTeacherImageView.contentMode = .ScaleAspectFit
                mTeacherImageView.downloadImage(checkedUrl, withFolderType: folderType.ProFilePics)
            }
            
            

        }
        
        if let  TeacherName = details.objectForKey("TeacherName") as? String
        {
            mTeacherName.text = TeacherName
            
            SSStudentDataSource.sharedDataSource.currentTeacherName = TeacherName

        }
    }
    
    
    func didGetUpdatedUserStateWithDetails(details: AnyObject)
    {
         SSStudentMessageHandler.sharedMessageHandler.sendStudentBenchStatus(SSStudentDataSource.sharedDataSource.currentUSerState)
    }
    
    
    func didGetQuestionWithDetails(details: AnyObject)
    {
        currentQuestionDetails = details
        SSStudentMessageHandler.sharedMessageHandler.sendAcceptQuestionMessageToTeacherforType()
        
        if (details.objectForKey(kQuestionTag)?.objectForKey(kQuestionName) as? String) != ""
        {
            mQuestionNameLabel.text = (details.objectForKey(kQuestionTag)?.objectForKey(kQuestionName) as? String)
        }
        
        
        if (details.objectForKey(kQuestionTag)?.objectForKey(kQuestionType) as? String) != ""
        {
            currentQuestionType = (details.objectForKey(kQuestionTag)?.objectForKey(kQuestionType) as? String)!
        }
        
        mQuestionView.setQuestionDetails(currentQuestionDetails.objectForKey(kQuestionTag)!, withType: currentQuestionType, withSessionDetails: sessionDetails, withQuestion: currentQuestionLogId)
        
    }
    
    
    // MARK: - Questions delegate 
    func delegateFullScreenButtonPressedWithOverlayImage(overlay: UIImage)
    {
        if mFullScreenView == nil{
            mFullScreenView = SSStudentFullscreenScribbleQuestion(frame:CGRectMake(0,0,self.view.frame.size.width,self.view.frame.size.height))
            mFullScreenView.setdelegate(self)
            self.view.addSubview(mFullScreenView)
            self.view.bringSubviewToFront(mFullScreenView)
        }
        
        mFullScreenView.hidden = false
        
        mFullScreenView.setOverlayImage(overlay)
    }
    
    
    func delegateFullScreenSendButtonPressedWithImage(writtenImage: UIImage)
    {
        mQuestionView.setFullScreenDrawnImage(writtenImage)
        mFullScreenView.hidden = true
        
    }
    
    
    
    
    // MARK: - Loading subViews
    
    func loadSubview()
    {
        
        mQuestionButton.frame = CGRectMake(10, 10, 100, 100)
        mQuestionButton.setImage("Questions_Selected.png", _unselectedImageName: "Questions.png", withText: "Question")
        classStartedView.addSubview(mQuestionButton)
        mQuestionButton.buttonselected()
         mQuestionButton.addTarget(self, action: #selector(StudentClassViewController.onQuestionButton), forControlEvents: UIControlEvents.TouchUpInside)
        
        mQuestionView = StudentQuestionView(frame:CGRectMake(mQuestionButton.frame.origin.x + mQuestionButton.frame.size.width ,mQuestionButton.frame.origin.y, classStartedView.frame.size.width - (mQuestionButton.frame.origin.x + mQuestionButton.frame.size.width + 10 ) , classStartedView.frame.size.height -  (mQuestionButton.frame.origin.y + mBottomBarImageView.frame.size.height )))
        mQuestionView.setdelegate(self)
        classStartedView.addSubview(mQuestionView)
        
        
        
        mQueryButton.frame = CGRectMake(10 , mQuestionButton.frame.origin.y + mQuestionButton.frame.size.height + 20 , 100, 100)
        mQueryButton.setImage("Query_Selected.png",  _unselectedImageName:"Query.png" ,withText: "Query")
        classStartedView.addSubview(mQueryButton)
        mQueryButton.buttonUnSelected()
         mQueryButton.addTarget(self, action: #selector(StudentClassViewController.onQueryButton), forControlEvents: UIControlEvents.TouchUpInside)
       
        mQueryView = StudentsQueryView(frame:mQuestionView.frame)
         classStartedView.addSubview(mQueryView)
        mQueryView.hidden = true
        
        mSubmissionButton.frame = CGRectMake(10 , mQueryButton.frame.origin.y + mQueryButton.frame.size.height + 20 , 100, 100)
         mSubmissionButton.setImage("poll_icon_selected.png",  _unselectedImageName: "poll_icon_unselected.png", withText: "OTF")
        classStartedView.addSubview(mSubmissionButton)
        mSubmissionButton.buttonUnSelected()
         mSubmissionButton.addTarget(self, action: #selector(StudentClassViewController.onOTFButton), forControlEvents: UIControlEvents.TouchUpInside)
        
        
        mOTFView = StudentOTFView(frame:mQuestionView.frame)
        classStartedView.addSubview(mOTFView)
        mOTFView.hidden = true
        
        
        mSubTopicNamelabel.frame =  CGRectMake(mTeacherName.frame.origin.x + mTeacherName.frame.size.width + 10 , mTeacherName.frame.origin.y, mBottomBarImageView.frame.size.width - (mTeacherName.frame.origin.x + mTeacherName.frame.size.width + 20),mTeacherName.frame.size.height )
        mBottomBarImageView.addSubview(mSubTopicNamelabel)
        mSubTopicNamelabel.text = "No subtopic"
        mSubTopicNamelabel.font = UIFont(name:helveticaMedium, size: 20)
        mSubTopicNamelabel.textColor = UIColor.whiteColor()
        mSubTopicNamelabel.textAlignment = .Right
        
        
        
        mQuestionNameLabel.frame =  CGRectMake(mSubTopicNamelabel.frame.origin.x,mSubTopicNamelabel.frame.origin.y + mSubTopicNamelabel.frame.size.height + 5,mSubTopicNamelabel.frame.size.width,mSubTopicNamelabel.frame.size.height)
        mBottomBarImageView.addSubview(mQuestionNameLabel)
        mQuestionNameLabel.text = "No Question"
        mQuestionNameLabel.font = UIFont(name:helveticaMedium, size: 14)
        mQuestionNameLabel.textColor = UIColor.whiteColor()
        mQuestionNameLabel.textAlignment = .Right
        
        
        SSStudentMessageHandler.sharedMessageHandler.createRoomWithRoomName("question_\((sessionDetails.objectForKey("SessionId") as! String))", withHistory: "1")
        
    }
    
  
    
    // MARK: - student Message handler
    
    
    func onQuestionButton()
    {
        mQuestionView.hidden = false
        mQueryView.hidden = true
        mOTFView.hidden = true
        mSubmissionButton.buttonUnSelected()
         mQueryButton.buttonUnSelected()
        mQuestionButton.buttonselected()
        
    }
    
    func onQueryButton()
    {
        mQuestionView.hidden = true
        mQueryView.hidden = false
         mOTFView.hidden = true
        mSubmissionButton.buttonUnSelected()
        mQueryButton.buttonselected()
        mQuestionButton.buttonUnSelected()
    }
    
    func onOTFButton()
    {
        mQuestionView.hidden = true
        mQueryView.hidden = true
        mOTFView.hidden = false
        mSubmissionButton.buttonselected()
        mQueryButton.buttonUnSelected()
        mQuestionButton.buttonUnSelected()
        
    }
    
    
    
    func onBack()
    {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    // MARK: - message handler functions
    
    func smhDidgetTimeExtendedWithDetails(Details: AnyObject)
    {
        
        
        if classStartedView.hidden == true
        {
            classStartedView.hidden = false
             classsBegin()
        }
        
        mQueryView.VolunteerPresentState(false)
        if mStudentQrvAnsweringView != nil
        {
            mStudentQrvAnsweringView.removeFromSuperview()
        }
        
        

            mNoStudentLabel.hidden = true 
    }
    func smhDidGetVotingMessageWithDetails(details: AnyObject)
    {
        
        print(details)
        
        
        if let VotingValue = details.objectForKey("VotingValue") as? String
        {
            if VotingValue == "TRUE"
            {
                
                mQueryView.queryPresentState(true)
                
                if (details.objectForKey("SubTopicName") != nil)
                {
                    if let SubTopicName = details.objectForKey("SubTopicName") as? String
                    {
                        mSubTopicNamelabel.text = SubTopicName
                    }
                    else
                    {
                        mSubTopicNamelabel.text = "No subtopic"
                    }
                }
                else
                {
                    mSubTopicNamelabel.text = "No subtopic"
                }
                
            }
            else
            {
                 mQueryView.queryPresentState(false)
                mSubTopicNamelabel.text = "No subtopic"
            }
        }
    }
    
    
    func smhdidReceiveQuestionSentMessage(dict: AnyObject)
    {
        
        mQuestionButton.hidden = false
        
        if let QuestionLogId = dict.objectForKey("QuestionLogId") as? String
        {
            currentQuestionLogId = QuestionLogId
            var messageString:String!
            
            if dict.objectForKey(kQuestionType) as! String  == text
            {
                messageString = "Please type out your response";
                showAlertWithMessage(messageString)
                
            }
            else if dict.objectForKey(kQuestionType) as! String  == MatchColumns
            {
                messageString = "Please rearrange the list to match other list";
                showAlertWithMessage(messageString)
                
                
            }
            else if  dict.objectForKey(kQuestionType) as! String  == MultipleChoice
            {
                messageString = "Please Select correct Response (Just one)";
                showAlertWithMessage(messageString)
                
            }
            else if dict.objectForKey(kQuestionType) as! String  == MultipleResponse
            {
                
                messageString = "Please Select correct Responses (More than one or just one)";
                showAlertWithMessage(messageString)
            }
            else if dict.objectForKey(kQuestionType) as! String  == OverlayScribble
            {
                
                messageString = "Please hand draw over the picture sent";
                showAlertWithMessage(messageString)
                
                
                
            }
            else if dict.objectForKey(kQuestionType) as! String  == FreshScribble
            {
                
                messageString = "Please sketch your response";
               showAlertWithMessage(messageString)
            }
        }
        
        
        
        if classStartedView.hidden == true
        {
            classStartedView.hidden = false
        }
        
    }
    
    
    func smhdidReceiveQuestionClearMessage()
    {
        mQuestionView.questionCleared()
        mQuestionNameLabel.text = "No active question"
        

//        SSStudentDataSource.sharedDataSource.getGraspIndexwithTopicId(currentSubTopicId, withSessionId: (sessionDetails.objectForKey("SessionId") as! String), withDelegate: self)
       
        
        if questionAcceptAlert.visible == true{
            questionAcceptAlert.dismissWithClickedButtonIndex(-1, animated: true)
        }
        
        
        if classStartedView.hidden == true
        {
            classsBegin()
        }
        
        mQuestionView.questionCleared()
        
        waitQuestionTimer.invalidate()
        
        if SSStudentDataSource.sharedDataSource.answerSent == true
        {
            SSStudentDataSource.sharedDataSource.answerSent = false
        }
        
        
        
    }
    
    func smhdidReceiveQuestionFreezMessage() {
        mQuestionView.didgetFreezMessageFromTeacher()
    }
    
    
    func smhdidRecieveQueryReviewmessage()
    {
        mQueryView.teacherReviewQuery()
    }
    
    func smhdidGetQueryFeedBackFromTeacherWithDetials(details: AnyObject)
    {
        mQueryView.feedBackSentFromTeacherWithDetiails(details)
    }
    
     func smhdidRecieveQueryOpenedForVotingWithDetails()
     {
        mQueryView.VolunteerPresentState(true)
    }
    func smhdidRecieveQueryVolunteeringEnded()
    {
         mQueryView.VolunteerPresentState(false)
        if mStudentQrvAnsweringView != nil
        {
            mStudentQrvAnsweringView.removeFromSuperview()
        }
        if questionAcceptAlert.visible == true
        {
            questionAcceptAlert.dismissWithClickedButtonIndex(-1, animated: true)
        }

    }
    
    
    func smhDidRecieveQueryAnsweringMessageWithDetails(details: AnyObject)
    {
        if details.objectForKey("AnsweringStudentId") != nil
        {
            if let AnsweringStudentId = details.objectForKey("AnsweringStudentId") as? String
            {
                if AnsweringStudentId == SSStudentDataSource.sharedDataSource.currentUserId
                {
                    if questionAcceptAlert.visible == true{
                        questionAcceptAlert.dismissWithClickedButtonIndex(-1, animated: true)
                    }

                    questionAcceptAlert = UIAlertView()
                    questionAcceptAlert.title = "Teacher selected you"
                    questionAcceptAlert.message = "Please stand up and answer"
                    questionAcceptAlert.addButtonWithTitle("OK")
                    questionAcceptAlert.show()
                    questionAcceptAlert.delegate = self
                    
                   
                }
                
                
                mStudentQrvAnsweringView = StudentVolunteeringView(frame:CGRectMake(0,0,self.view.frame.size.width, self.view.frame.size.height))
                mStudentQrvAnsweringView.setVolunteeringDetails(details)
                self.view.addSubview(mStudentQrvAnsweringView)
                
                

            }
        }
        
    }
    
    
    func smhdidRecieveQueryVolunteeringClosedMessageWithDetails(details: AnyObject)
    {
        if mStudentQrvAnsweringView != nil
        {
            mStudentQrvAnsweringView.removeFromSuperview()
        }
        
        
        if questionAcceptAlert.visible == true{
            questionAcceptAlert.dismissWithClickedButtonIndex(-1, animated: true)
        }
        
        var totalVotes :CGFloat = 0 ;
        
        
        if details.objectForKey("QueryId") != nil
        {
             if let QueryId = details.objectForKey("QueryId") as? String
             {
                
                if details.objectForKey("totalPercentage") != nil
                {
                    if let _totalVotes = details.objectForKey("totalPercentage") as? String
                    {
                        
                        if let n = NSNumberFormatter().numberFromString(_totalVotes)
                        {
                             totalVotes = CGFloat(n)
                        }
                        
                       
                    }
                }
                
               
                if totalVotes < 0
                {
                    totalVotes = 0
                }
                
                if details.objectForKey("StudentId") != nil
                {
                    if let StudentId = details.objectForKey("StudentId") as? String
                    {
                        
                        mQueryView.volunteerClosedWithQueryId(QueryId, withStudentdID: StudentId, withTotalVotes:totalVotes)
                    }
                }
                
            }
        }
    }
    
    func smhDidRecievePollingStartedMessageWithDetails(detials: AnyObject)
    {
       mOTFView.didGetPollingStartedWithDetills(detials)
    }
    
    func smhDidGetPollEndedMessageFromteacher()
    {
        mOTFView.didGetPollingStopped()
    }
    
    
    func smhDidGetGraphSharedWithDetails(details: AnyObject)
    {
        mQuestionView.didGetGraphSharedWithDetails(details)
        
    }
    
   
    // MARK: - message handler functions
    func showAlertWithMessage(message:String)
    {
        
        if SSStudentDataSource.sharedDataSource.currentUSerState == kUserStateLive
        {
            
            if questionAcceptAlert.visible == true{
                questionAcceptAlert.dismissWithClickedButtonIndex(-1, animated: true)
            }
            
            questionAcceptAlert = UIAlertView()
            questionAcceptAlert.title = "Received a question"
            questionAcceptAlert.message = message
            questionAcceptAlert.addButtonWithTitle("Wait")
            questionAcceptAlert.addButtonWithTitle("Accept")
            questionAcceptAlert.show()
            questionAcceptAlert.delegate = self
            questionAcceptAlert.tag = 1011
        }
        else
        {
            if questionAcceptAlert.visible == true
            {
                questionAcceptAlert.dismissWithClickedButtonIndex(-1, animated: true)
            }
        }
    }
   
    func alertView(alertView: UIAlertView!, clickedButtonAtIndex buttonIndex: Int)
    {
        if alertView.tag == 1011
        {
            if (buttonIndex == 0)
            {
                waitQuestionTimer = NSTimer.scheduledTimerWithTimeInterval(0.4, target: self, selector: #selector(StudentClassViewController.waitForQuestion), userInfo: nil, repeats: true)
            }
            else
            {
                SSStudentDataSource.sharedDataSource.fetchQuestionWithQuestionLogId(currentQuestionLogId, WithDelegate: self)
                waitQuestionTimer.invalidate()
            }
        }
    }
    
    func waitForQuestion()
    {
        
    }

    
    
    
}