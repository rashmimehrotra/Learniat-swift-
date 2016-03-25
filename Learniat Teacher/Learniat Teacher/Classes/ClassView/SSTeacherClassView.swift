//
//  SSTeacherClassView.swift
//  Learniat Teacher
//
//  Created by Deepak MK on 23/03/16.
//  Copyright © 2016 Mindshift. All rights reserved.
//

import Foundation
class SSTeacherClassView: UIViewController,UIPopoverControllerDelegate,SSTeachermainTopicControllerDelegate,SSTeacherSubTopicControllerDelegate,SSTeacherDataSourceDelegate,SSTeacherQuestionControllerDelegate,SSTeacherMessagehandlerDelegate
{
    var mTeacherImageView: UIImageView!
    
    var mTopbarImageView: UIImageView!
    
    var mClassName: UILabel!
    
    let dateFormatter = NSDateFormatter()
    
    var currentSessionDetails           :AnyObject!
    
    var currentSessionId               = ""
    
    var mSubTopicsNamelabel                  = UILabel()
    
    var mQuestionNamelabel                   = UILabel()
    
    var currentQuestionDetails              :AnyObject!
    
    let mainTopicsController        =  SSTeachermainTopicController()
    
    let subTopicsController         =  SSTeacherSubTopicController()
    
    let questionController          =  SSTeacherQuestionController()
    
    var startedSubTopicID           = ""
    
    var startedMainTopicID          = ""
    
    var startedMainTopicName        = ""
    
    var currentQuestionLogId        = ""
    
    var isQuestionSent              :Bool = false
    
    
    var classViewPopOverController  :UIPopoverController!
    
    var  mTopicButton:UIButton!
    
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
        
        if let sessionId = (currentSessionDetails.objectForKey(kSessionId)) as? String
        {
            currentSessionId = sessionId
            SSTeacherDataSource.sharedDataSource.currentLiveSessionId = sessionId
        }
        
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
        
        
        
        
      let  mSchedulePopoverButton = UIButton(frame: CGRectMake(mTeacherImageView.frame.origin.x + mTeacherImageView.frame.size.width + 10,  mTeacherImageView.frame.origin.y, 250 , 50))
        mTopbarImageView.addSubview(mSchedulePopoverButton)
        mSchedulePopoverButton.addTarget(self, action: "onScheduleScreenPopupPressed:", forControlEvents: UIControlEvents.TouchUpInside)
        mSchedulePopoverButton.backgroundColor = standard_Button
        mSchedulePopoverButton.layer.cornerRadius = 2
        mSchedulePopoverButton.layer.masksToBounds = true
        
        mClassName = UILabel(frame: CGRectMake(mSchedulePopoverButton.frame.origin.x + 10, mSchedulePopoverButton.frame.origin.y + 5 , 230, 20))
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
        
        mClassName.font = UIFont(name:helveticaBold, size: 14)
        mTopbarImageView.addSubview(mClassName)
        mClassName.textColor = UIColor.whiteColor()
       
        let mTeacher = UILabel(frame: CGRectMake(mSchedulePopoverButton.frame.origin.x + 10, mClassName.frame.origin.y + mClassName.frame.size.height , 230, 20))
        mTeacher.font = UIFont(name:helveticaRegular, size: 12)
        mTopbarImageView.addSubview(mTeacher)
        mTeacher.textColor = UIColor.whiteColor()
         if let StartTime = currentSessionDetails.objectForKey("StartTime") as? String
         {
            
            var _string :String = ""
            let currentDate = NSDate()
            _string = _string.stringFromTimeInterval(currentDate.timeIntervalSinceDate(dateFormatter.dateFromString(StartTime)!)).fullString
            mTeacher.text = "Started: \(_string)"
        }
        
       
        
        
         mTopicButton = UIButton(frame: CGRectMake(mTopbarImageView.frame.size.width - (mSchedulePopoverButton.frame.size.width + 10 ),  mSchedulePopoverButton.frame.origin.y, mSchedulePopoverButton.frame.size.width , mSchedulePopoverButton.frame.size.height))
        mTopbarImageView.addSubview(mTopicButton)
        mTopicButton.addTarget(self, action: "onTopicsButton:", forControlEvents: UIControlEvents.TouchUpInside)
        mTopicButton.backgroundColor = standard_Button
        mTopicButton.layer.cornerRadius = 2
        mTopicButton.layer.masksToBounds = true
        
        
        
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
        
        
        mainTopicsController.setPreferredSize(CGSizeMake(600, 100),withSessionDetails: currentSessionDetails)
        subTopicsController.setPreferredSize(CGSizeMake(600, 100),withSessionDetails: currentSessionDetails)
        questionController.setPreferredSize(CGSizeMake(600, 100),withSessionDetails: currentSessionDetails)
        
        
        
    }

    func setSessionDetails(details:AnyObject)
    {
        currentSessionDetails = details
        print(details)
    }
    
    
    
    
    
     // MARK: - buttons functions
    
    func onScheduleScreenPopupPressed(sender:UIButton)
    {
        
    }
    
    
    func onTopicsButton(sender:UIButton)
    {
        
     if startedSubTopicID == ""
     {
        mainTopicsController.setdelegate(self)
        mainTopicsController.preferredContentSize = CGSizeMake(600, 44)
        mainTopicsController.getTopicsDetails()
        
        classViewPopOverController = UIPopoverController(contentViewController: mainTopicsController)
        
        classViewPopOverController.popoverContentSize = CGSizeMake(540, 680);
        classViewPopOverController.delegate = self;
        
        classViewPopOverController.presentPopoverFromRect(CGRect(
            x: mTopicButton.frame.origin.x + mTopicButton.frame.size.width / 2 ,
            y: mTopicButton.frame.origin.y + mTopicButton.frame.size.height,
            width: 1,
            height: 1), inView: self.view, permittedArrowDirections: .Up, animated: true)
        }
        else
     {
        subTopicsController.setdelegate(self)
        subTopicsController.preferredContentSize = CGSizeMake(600, 44)
        subTopicsController.getSubtopicsDetailsWithMainTopicId(startedMainTopicID, withMainTopicName: startedMainTopicName, withStartedSubtopicID: startedSubTopicID)
        classViewPopOverController = UIPopoverController(contentViewController: subTopicsController)
        
        classViewPopOverController.popoverContentSize = CGSizeMake(540, 680);
        classViewPopOverController.delegate = self;
        
        classViewPopOverController.presentPopoverFromRect(CGRect(
            x: mTopicButton.frame.origin.x + mTopicButton.frame.size.width / 2 ,
            y: mTopicButton.frame.origin.y + mTopicButton.frame.size.height,
            width: 1,
            height: 1), inView: self.view, permittedArrowDirections: .Up, animated: true)
        }
        
        
        
    }
    
    
     // MARK: - datasource delegate functions
    
    
    func didGetSubtopicStartedWithDetails(details: AnyObject)
    {
        print(details)
    }
    
    func didGetQuestionSentWithDetails(details: AnyObject) {
        print(details)
        
        
        if let QuestionLogId = details.objectForKey("QuestionLogId") as? String
        {
            
            isQuestionSent = false
            
            currentQuestionLogId = QuestionLogId
            
            SSTeacherMessageHandler.sharedMessageHandler.createRoomWithRoomName("question_\(SSTeacherDataSource.sharedDataSource.currentUserId)_\(currentQuestionLogId)", withHistory: "0")
        }
    }
    
    // MARK: - MainTopic delegate functions
    
    func delegateShowSubTopicWithMainTopicId(mainTopicID: String, WithMainTopicName mainTopicName: String)
    {
        subTopicsController.setdelegate(self)
        subTopicsController.preferredContentSize = CGSizeMake(600, 44)
        subTopicsController.getSubtopicsDetailsWithMainTopicId(mainTopicID, withMainTopicName: mainTopicName,withStartedSubtopicID: startedSubTopicID)
        if (classViewPopOverController.popoverVisible == true)
        {
            classViewPopOverController.contentViewController = subTopicsController
            if startedSubTopicID == ""
            {
                mSubTopicsNamelabel.text = mainTopicName
                startedMainTopicID = mainTopicID
                startedMainTopicName = mainTopicName
                
            }
            
        }
    }
    
     // MARK: - subTopic delegate functions
    
    
    func delegateSubTopicBackButtonPressed()
    {
        mainTopicsController.setdelegate(self)
        mainTopicsController.preferredContentSize = CGSizeMake(600, 44)
        mainTopicsController.getTopicsDetails()
        if (classViewPopOverController.popoverVisible == true)
        {
            classViewPopOverController.contentViewController = mainTopicsController
        }
    }
    
    func delegateSubtopicStateChanedWithID(subTopicId: String, withState state: Bool, withSubtopicName subTopicName: String, withmainTopicName mainTopicName: String) {
        
        if state == true
        {
            startedSubTopicID = subTopicId
            
            
            if let sessionId = (currentSessionDetails.objectForKey(kSessionId)) as? String
            {
                SSTeacherDataSource.sharedDataSource.startSubTopicWithTopicID(subTopicId, withStudentId: "", withSessionID: sessionId, withDelegate: self)
            }

            
            SSTeacherMessageHandler.sharedMessageHandler.sendAllowVotingToRoom(currentSessionId, withValue: "TRUE", withSubTopicName: subTopicName, withSubtopicID: subTopicId)
            
             mSubTopicsNamelabel.text = "\(mainTopicName) / \(subTopicName)"
            
            
        }
        else
        {
            startedSubTopicID = ""
            SSTeacherMessageHandler.sharedMessageHandler.sendAllowVotingToRoom(currentSessionId, withValue: "FALSE", withSubTopicName: subTopicName, withSubtopicID: subTopicId)
            
             mSubTopicsNamelabel.text = "\(mainTopicName)"
        }
    }
    
    
    func delegateQuestionButtonPressedWithSubtopicId(subtopicId: String, withSubTopicName subTopicName: String, withMainTopicId mainTopicId: String, withMainTopicName mainTopicName: String) {
        
        questionController.setdelegate(self)
        questionController.preferredContentSize = CGSizeMake(600, 44)
        
        if startedSubTopicID == subtopicId
        {
              questionController.getQuestionsDetailsWithsubTopicId(subtopicId, withSubTopicName: subTopicName, withMainTopicId: mainTopicId, withMainTopicName: mainTopicName, withSubtopicStarted: true)
        }
        else
        {
            questionController.getQuestionsDetailsWithsubTopicId(subtopicId, withSubTopicName: subTopicName, withMainTopicId: mainTopicId, withMainTopicName: mainTopicName, withSubtopicStarted: false)
        }
      
        if (classViewPopOverController.popoverVisible == true)
        {
            classViewPopOverController.contentViewController = questionController
            
            if startedSubTopicID == ""
            {
                mSubTopicsNamelabel.text = "\(mainTopicName) / \(subTopicName)"
            }
        }
    }
    
     // MARK: - Question delegate functions
    
    func delegateQuestionSentWithQuestionDetails(questionDetails: AnyObject) {
        
        currentQuestionDetails = questionDetails
        
        if let QuestionID = (currentQuestionDetails.objectForKey("Id")) as? String
        {
            SSTeacherDataSource.sharedDataSource.broadcastQuestionWithQuestionId(QuestionID, withSessionID: currentSessionId, withDelegate: self)
            
            classViewPopOverController.dismissPopoverAnimated(true)
            
        }
    }
    
    
    
    
     // MARK: - message handler delegate
    
    func smhDidcreateRoomWithRoomName(roomName: String)
    {
        
        if let Type = currentQuestionDetails.objectForKey("Type") as? String
        {
           SSTeacherMessageHandler.sharedMessageHandler.sendQuestionWithName(currentSessionId, withQuestionLogId: currentQuestionLogId, withQuestionType: Type)
        }
       
    }
    
    
    
    func popoverControllerDidDismissPopover(popoverController: UIPopoverController)
    {
        if startedSubTopicID == ""
         {
            mSubTopicsNamelabel.text = "No topic selected"
        }
    }
}