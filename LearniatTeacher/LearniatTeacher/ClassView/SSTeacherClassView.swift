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



import Foundation
class SSTeacherClassView: UIViewController,UIPopoverControllerDelegate,SSTeachermainTopicControllerDelegate,SSTeacherSubTopicControllerDelegate,SSTeacherDataSourceDelegate,SSTeacherQuestionControllerDelegate,SSTeacherMessagehandlerDelegate,SSTeacherLiveQuestionControllerDelegate
{
   
    
    
    var mTeacherImageView: UIImageView!
    
    var mTopbarImageView: UIImageView!
    
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
    
    let mainTopicsController        =  SSTeachermainTopicController()
    
    let subTopicsController         =  SSTeacherSubTopicController()
    
    let questionController          =  SSTeacherQuestionController()
    
    let liveQuestionController      =  SSTeacherLiveQuestionController()
    
    var startedSubTopicID           = ""
    
    var startedMainTopicID          = ""
    
    var startedMainTopicName        = ""
    
    var currentQuestionLogId        = ""
    
    var isQuestionSent              :Bool = false
    
    var currentCumulativeTime       :String   = ""
    
    var classViewPopOverController  :UIPopoverController!
    
    var cumulativeTimer                    = NSTimer()
    
    var  mTopicButton:UIButton!
    
    var mGridContainerView           :UIView                = UIView()
    
    var StudentsDetailsArray                = NSMutableArray()
    
    
    var mActivityIndicatore          :UIActivityIndicatorView = UIActivityIndicatorView()
    
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
        
        
        
        mGridContainerView.frame = CGRectMake(0, mTopbarImageView.frame.origin.y + mTopbarImageView.frame.size.height , self.view.frame.size.width , self.view.frame.size.height - (mTopbarImageView.frame.origin.y + mTopbarImageView.frame.size.height + mBottombarImageView.frame.size.height ))
        self.view.addSubview(mGridContainerView)
        mGridContainerView.backgroundColor = whiteBackgroundColor
        mGridContainerView.hidden = true
        
        

        
        
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
        
        
        mClassName.font = UIFont(name:helveticaBold, size: 14)
        mTopbarImageView.addSubview(mClassName)
        mClassName.textColor = UIColor.whiteColor()
       
        mStartTimeLabel.frame = CGRectMake(mSchedulePopoverButton.frame.origin.x + 10, mClassName.frame.origin.y + mClassName.frame.size.height , 230, 20)
        mStartTimeLabel.font = UIFont(name:helveticaRegular, size: 12)
        mTopbarImageView.addSubview(mStartTimeLabel)
        mStartTimeLabel.textColor = UIColor.whiteColor()
        
        
        
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
        
        
      
        
        mStartLabelUpdater.invalidate()
        mStartLabelUpdater = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: "updateStartLabelTime", userInfo: nil, repeats: true)
        
        
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
        
        if var StartTime = currentSessionDetails.objectForKey("StartTime") as? String
        {
            
            var _string :String = ""
            let currentDate = NSDate()
            
            let isGreater = dateFormatter.dateFromString(StartTime)?.isGreaterThanDate(currentDate)
            
            if isGreater == true
            {
                StartTime = dateFormatter.stringFromDate(currentDate)
                currentSessionDetails.setObject(StartTime, forKey: "StartTime")
                
                
            }
            
            
            _string = _string.stringFromTimeInterval(currentDate.timeIntervalSinceDate(dateFormatter.dateFromString(StartTime)!)).fullString
            mStartTimeLabel.text = "Started: \(_string)"
        }
        
        
        mainTopicsController.setPreferredSize(CGSizeMake(600, 100),withSessionDetails: currentSessionDetails)
        subTopicsController.setPreferredSize(CGSizeMake(600, 100),withSessionDetails: currentSessionDetails)
        questionController.setPreferredSize(CGSizeMake(600, 100),withSessionDetails: currentSessionDetails)
        
        liveQuestionController.setPreferredSize(CGSizeMake(600, 100),withSessionDetails: currentSessionDetails)
        
        
        
        if let roomId = currentSessionDetails.objectForKey("RoomId") as? String
        {
            SSTeacherDataSource.sharedDataSource.getGridDesignDetails(roomId, WithDelegate: self)
            mActivityIndicatore.startAnimating()
            mActivityIndicatore.hidden = false
        }
        
        
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
        }
    }
    
    
    
    
// MARK: - datasource delegate functions
    
    
    
    func didGetGridDesignWithDetails(details: AnyObject) {
        
        
        
        arrangegridWithDetails(details)
    }
    
    func didGetSeatAssignmentWithDetails(details: AnyObject)
    {
        
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
            
            SSTeacherMessageHandler.sharedMessageHandler.createRoomWithRoomName("question_\(SSTeacherDataSource.sharedDataSource.currentUserId)_\(QuestionLogId)", withHistory: "0")
        }
    }
    
    
    
    
    
    func onScheduleScreenPopupPressed(sender:UIButton)
    {
        
    }
    

    
    
// MARK: - seatAssignment functions
    
    
    func arrangegridWithDetails(details:AnyObject)
    {
        var columnValue         = 1
        var rowValue            = 1
        var seatsIdArray        = [String]()
        var seatsLableArray     = [String]()
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
        
        if let SeatLabelList = details.objectForKey("SeatLabelList") as? String
        {
            seatsLableArray =  SeatLabelList.componentsSeparatedByString(",")
        }
        
        if let SeatsRemoved = details.objectForKey("SeatsRemoved") as? String
        {
            seatsRemovedArray =  SeatsRemoved.componentsSeparatedByString(",")
        }
        
        
        var  barWidthvalue  :CGFloat = mGridContainerView.frame.size.width / CGFloat(columnValue)
        
        let barWidthSpace :CGFloat = barWidthvalue * 0.03
        
        barWidthvalue = barWidthvalue * 0.97
        
        var barHeight   :CGFloat = mGridContainerView.frame.size.height / CGFloat(rowValue)
        
        let barHeightSpace:CGFloat = barHeight * 0.03
        
        barHeight = barHeight * 0.97
        
        
        var postionY :CGFloat = barHeightSpace / 2
        
        var totalSeatvalue  = rowValue * columnValue
        
        for var columnIndex = 0; columnIndex < rowValue ; columnIndex++
        {
            
            let backGroundImageView = UIImageView(frame:  CGRectMake(0, postionY - barHeightSpace, mGridContainerView.frame.size.width, barHeight + barHeightSpace) )
            if (columnIndex%2==0)
            {
                backGroundImageView.backgroundColor = UIColor.whiteColor()
                
            }
            else
            {
                backGroundImageView.backgroundColor = UIColor(red: 249/255.0, green:249/255.0, blue:249/255.0, alpha: 1)
            }
            mGridContainerView.addSubview(backGroundImageView)
            
            var positionX :CGFloat = barWidthSpace / 2
            for var rowIndex = 0; rowIndex < columnValue ; rowIndex++
            {
                if seatsRemovedArray.contains("A\(totalSeatvalue)")
                {
                    
                }
                else
                {
                    let seatView = StundentDeskView(frame: CGRectMake(positionX, postionY, barWidthvalue, barHeight))
                    mGridContainerView.addSubview(seatView)
                    seatView.tag  = totalSeatvalue
                    seatView.backgroundColor = UIColor.clearColor()
                }
                
                positionX = positionX + barWidthvalue + barWidthSpace
                totalSeatvalue = totalSeatvalue - 1
                
            }
            postionY = postionY + barHeight + barHeightSpace
            
        }
        
        
        SSTeacherDataSource.sharedDataSource.getSeatAssignmentofSession(currentSessionId, withDelegate: self)

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
        
        
        for var indexValue = 0 ; indexValue < StudentsDetailsArray.count ; indexValue++
        {
            let studentsDict = StudentsDetailsArray.objectAtIndex(indexValue)
            
            if var seatlabel = studentsDict.objectForKey("SeatLabel") as? String
            {
                seatlabel = seatlabel.stringByReplacingOccurrencesOfString("A", withString: "")
                
               if let studentDeskView  = mGridContainerView.viewWithTag(Int(seatlabel)!) as? StundentDeskView
               {
                    studentDeskView.setStudentsDetails(studentsDict)
                    if let StudentId = studentsDict.objectForKey("StudentId") as? String
                    {
                            studentDeskView.tag = Int(StudentId)!
                    }
                }
                
                
            }
        }
        
        
        mGridContainerView.hidden = false
        mActivityIndicatore.stopAnimating()
        mActivityIndicatore.hidden = true

    }
    
    
// MARK: - buttons functions
    func onTopicsButton(sender:UIButton)
    {
        
        if startedSubTopicID == ""
        {
            mainTopicsController.setdelegate(self)
            mainTopicsController.preferredContentSize = CGSizeMake(600, 44)
            mainTopicsController.getTopicsDetailswithStartedMaintopicId("")
            
            classViewPopOverController = UIPopoverController(contentViewController: mainTopicsController)
            
            classViewPopOverController.popoverContentSize = CGSizeMake(540, 680);
            classViewPopOverController.delegate = self;
            
            classViewPopOverController.presentPopoverFromRect(CGRect(
                x: mTopicButton.frame.origin.x + mTopicButton.frame.size.width / 2 ,
                y: mTopicButton.frame.origin.y + mTopicButton.frame.size.height,
                width: 1,
                height: 1), inView: self.view, permittedArrowDirections: .Up, animated: true)
        }
        else  if isQuestionSent == true
        {
            liveQuestionController.setdelegate(self)
            liveQuestionController.preferredContentSize = CGSizeMake(600, 44)
            
            classViewPopOverController = UIPopoverController(contentViewController: liveQuestionController)
            liveQuestionController.setQuestionDetails(currentQuestionDetails, withMainTopciName: subTopicsController.mTopicName.text!, withMainTopicId: subTopicsController.currentMainTopicId)
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
              subTopicsController.getSubtopicsDetailsWithMainTopicId(startedMainTopicID, withMainTopicName: startedMainTopicName, withStartedSubtopicID: startedSubTopicID, withCumulativeTime: currentCumulativeTime)
            classViewPopOverController = UIPopoverController(contentViewController: subTopicsController)
            
            classViewPopOverController.popoverContentSize = CGSizeMake(540, 680);
            classViewPopOverController.delegate = self;
            
            classViewPopOverController.presentPopoverFromRect(CGRect(
                x: mTopicButton.frame.origin.x + mTopicButton.frame.size.width / 2 ,
                y: mTopicButton.frame.origin.y + mTopicButton.frame.size.height,
                width: 1,
                height: 1), inView: self.view, permittedArrowDirections: .Up, animated: true)
            cumulativeTimer.invalidate()
        }
        
        
        if classViewPopOverController.popoverVisible == false
        {
            
            mainTopicsController.setdelegate(self)
            mainTopicsController.preferredContentSize = CGSizeMake(600, 44)
            mainTopicsController.getTopicsDetailswithStartedMaintopicId(startedMainTopicID)
            
            classViewPopOverController = UIPopoverController(contentViewController: mainTopicsController)
            
            classViewPopOverController.popoverContentSize = CGSizeMake(540, 680);
            classViewPopOverController.delegate = self;
            
            classViewPopOverController.presentPopoverFromRect(CGRect(
                x: mTopicButton.frame.origin.x + mTopicButton.frame.size.width / 2 ,
                y: mTopicButton.frame.origin.y + mTopicButton.frame.size.height,
                width: 1,
                height: 1), inView: self.view, permittedArrowDirections: .Up, animated: true)
        }
        
        
        
        
    }

    
    
// MARK: - MainTopic delegate functions
    
    func delegateShowSubTopicWithMainTopicId(mainTopicID: String, WithMainTopicName mainTopicName: String)
    {
        subTopicsController.setdelegate(self)
        subTopicsController.preferredContentSize = CGSizeMake(600, 44)
       
        if (classViewPopOverController.popoverVisible == true)
        {
             subTopicsController.getSubtopicsDetailsWithMainTopicId(mainTopicID, withMainTopicName: mainTopicName,withStartedSubtopicID: startedSubTopicID, withCumulativeTime: currentCumulativeTime)
            
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
      
        if (classViewPopOverController.popoverVisible == true)
        {
              mainTopicsController.getTopicsDetailswithStartedMaintopicId(startedMainTopicID)
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

             mSubTopicsNamelabel.text = "\(mainTopicName) / \(subTopicName)"
            
            SSTeacherMessageHandler.sharedMessageHandler.sendAllowVotingToRoom(currentSessionId, withValue: "TRUE", withSubTopicName: mSubTopicsNamelabel.text!, withSubtopicID: subTopicId)
            
            
            
            
        }
        else
        {
            
            
            if let sessionId = (currentSessionDetails.objectForKey(kSessionId)) as? String
            {
                SSTeacherDataSource.sharedDataSource.stopSubTopicWithTopicID(subTopicId, withSessionID: sessionId, withDelegate: self)
            }

            
            startedSubTopicID = ""
            SSTeacherMessageHandler.sharedMessageHandler.sendAllowVotingToRoom(currentSessionId, withValue: "FALSE", withSubTopicName: subTopicName, withSubtopicID: subTopicId)
            
             mSubTopicsNamelabel.text = "\(mainTopicName)"
        }
    }
    
    func delegateSubtopicHiddenWithCumulativeTime(cumulativeTime: String)
    {
        currentCumulativeTime = cumulativeTime
        cumulativeTimer.invalidate()
         cumulativeTimer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: "udpateCumulativeTime", userInfo: nil, repeats: true)
    
    }
    
    func delegateStopCumulativeTimmer() {
         cumulativeTimer.invalidate()
    }
    
    func udpateCumulativeTime()
    {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "HH:mm:ss"
        
        var currentDate = NSDate()
        currentDate = currentDate.addSeconds(1, withDate: dateFormatter.dateFromString(currentCumulativeTime)!)
        currentCumulativeTime = dateFormatter.stringFromDate(currentDate)
        
        print(currentCumulativeTime)
        
    }
    
    
// MARK: - subTopic delegate functions
    func delegateQuestionButtonPressedWithSubtopicId(subtopicId: String, withSubTopicName subTopicName: String, withMainTopicId mainTopicId: String, withMainTopicName mainTopicName: String) {
        
        questionController.setdelegate(self)
        questionController.preferredContentSize = CGSizeMake(600, 44)
        
       
      
        if (classViewPopOverController.popoverVisible == true)
        {
            if startedSubTopicID == subtopicId
            {
                questionController.getQuestionsDetailsWithsubTopicId(subtopicId, withSubTopicName: subTopicName, withMainTopicId: mainTopicId, withMainTopicName: mainTopicName, withSubtopicStarted: true)
            }
            else
            {
                questionController.getQuestionsDetailsWithsubTopicId(subtopicId, withSubTopicName: subTopicName, withMainTopicId: mainTopicId, withMainTopicName: mainTopicName, withSubtopicStarted: false)
            }
            
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
            isQuestionSent = true
            classViewPopOverController.dismissPopoverAnimated(true)
            
            if let questionName = (currentQuestionDetails.objectForKey("Name")) as? String
            {
                mQuestionNamelabel.text = questionName
            }
            
        }
    }
    
    
    func delegateQuestionBackButtonPressed(mainTopicId: String, withMainTopicName mainTopicName: String) {
       
        subTopicsController.setdelegate(self)
        subTopicsController.preferredContentSize = CGSizeMake(600, 44)
        
        if (classViewPopOverController.popoverVisible == true)
        {
            subTopicsController.getSubtopicsDetailsWithMainTopicId(mainTopicId, withMainTopicName: mainTopicName,withStartedSubtopicID: startedSubTopicID, withCumulativeTime: currentCumulativeTime)
            
            classViewPopOverController.contentViewController = subTopicsController
            if startedSubTopicID == ""
            {
                mSubTopicsNamelabel.text = mainTopicName
                startedMainTopicID = mainTopicId
                startedMainTopicName = mainTopicName
                
            }
            cumulativeTimer.invalidate()
            
        }
        

    }
    
    // MARK: - live Question delegate functions
    
    func delegateQuestionCleared(questionDetails: AnyObject, withCurrentmainTopicId mainTopicId: String, withCurrentMainTopicName mainTopicName: String) {
        
        SSTeacherDataSource.sharedDataSource.clearQuestionWithQuestionogId(currentQuestionLogId, withDelegate: self)
        
        
        
        isQuestionSent = false
        
         questionController.clearQuestionTopicId(startedSubTopicID)
        subTopicsController.setdelegate(self)
        subTopicsController.preferredContentSize = CGSizeMake(600, 44)
//      subTopicsController.clearSubTopicDetailsWithMainTopicId(mainTopicId)
        
        if (SSTeacherDataSource.sharedDataSource.subTopicDetailsDictonary.objectForKey(mainTopicId) != nil)
        {
            SSTeacherDataSource.sharedDataSource.subTopicDetailsDictonary.removeObjectForKey(mainTopicId)
        }
        
        
        
        if (classViewPopOverController.popoverVisible == true)
        {
            subTopicsController.getSubtopicsDetailsWithMainTopicId(mainTopicId, withMainTopicName: mainTopicName,withStartedSubtopicID: startedSubTopicID, withCumulativeTime: currentCumulativeTime)
            
            classViewPopOverController.contentViewController = subTopicsController
            if startedSubTopicID == ""
            {
                mSubTopicsNamelabel.text = mainTopicName
                startedMainTopicID = mainTopicId
                startedMainTopicName = mainTopicName
                
            }
            cumulativeTimer.invalidate()
            
        }
        
        
        mQuestionNamelabel.text = "No active question"
        SSTeacherMessageHandler.sharedMessageHandler.sendClearQuestionMessageWithRoomId("question_\(SSTeacherDataSource.sharedDataSource.currentUserId)_\(currentQuestionLogId)")
    }
    
    func delegateDoneButtonPressed()
    {
        classViewPopOverController.dismissPopoverAnimated(true)
    }
    
    
// MARK: - message handler delegate
    
    func smhDidcreateRoomWithRoomName(roomName: String)
    {
       
        if currentQuestionDetails == nil
        {
            return
        }
        if let Type = currentQuestionDetails.objectForKey("Type") as? String
        {
            
            
            for var indexValue = 0 ; indexValue < StudentsDetailsArray.count ; indexValue++
            {
                let studentsDict = StudentsDetailsArray.objectAtIndex(indexValue)
                
                if let StudentId = studentsDict.objectForKey("StudentId") as? String
                {
                    SSTeacherMessageHandler.sharedMessageHandler.sendLiveClassRoomName(roomName, withQuestionLogId: StudentId, withQuestionType: Type)
                }
            }
           
            SSTeacherMessageHandler.sharedMessageHandler.sendQuestionWithRoomName(roomName, withQuestionLogId: currentQuestionLogId, withQuestionType: Type)
        }
       
    }
    
    
    func smhDidgetStudentBentchStateWithStudentId(studentId: String, withState state: String) {
        
        if let studentDeskView  = mGridContainerView.viewWithTag(Int(studentId)!) as? StundentDeskView
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
    
    
    // MARK: - Extra functions
    func popoverControllerDidDismissPopover(popoverController: UIPopoverController)
    {
        if startedSubTopicID == ""
         {
            mSubTopicsNamelabel.text = "No topic selected"
        }
    }
    
    
    
    
    func popoverControllerShouldDismissPopover(popoverController: UIPopoverController) -> Bool {
       
        return true
    }
}