//
//  TeacherScheduleViewController.swift
//  Learniat Teacher
//
//  Created by Deepak MK on 19/03/16.
//  Copyright © 2016 Mindshift. All rights reserved.
//



/*
 
 TeacherScheduleViewController details
 
 After login success with Learniat and xmpp server we are navigating to this class.
	
	Class Logic
	
	1. Fire “GetMyTodaysSessions” Api.
	
	2. If “GetMyTodaysSessions” Api returned no schedules then display label returned text in Api.
 
	3.  If “GetMyTodaysSessions” Api returned session details then add each session with details.
	
	4. For displaying session details use “ScheduleScreenTile” class where you can pass all the vales of sessions.
	
	5. Show sessions in the form of calendar and update session current time.
	
	6. When user press on any session then show session details with half screen using  “ScheduleDetailView” using "ClassSessionSummary" API return value.
 
	7. Check for start time ad end time of each session and show warnings of session.
 
 */

import Foundation
import UIKit
// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
    switch (lhs, rhs) {
    case let (l?, r?):
        return l < r
    case (nil, _?):
        return true
    default:
        return false
    }
}

// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func > <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
    switch (lhs, rhs) {
    case let (l?, r?):
        return l > r
    default:
        return rhs < lhs
    }
}


let oneHourDiff :CGFloat = 90.0

let halfHourMultipleRatio : CGFloat = (oneHourDiff / 2)/(30)


class TeacherScheduleViewController: UIViewController,SSTeacherDataSourceDelegate,ScheduleScreenTileDelegate,SSTeacherMessagehandlerDelegate,CustomAlertViewDelegate,ScheduleDetailViewDelegate,SSSettingsViewControllerDelegate
{
    var mTeacherImageView: CustomProgressImageView!
    
    var mTopbarImageView: UIImageView!
    
    var mTeacherName: UILabel!
    
    var mRefreshButton: UIButton!
    
    var mTeacherImageButton = UIButton()
    
    var mNoSessionLabel: UILabel!
    
    var mNoSessionSubLabel:UILabel!
    
    var mScrollView:UIScrollView!
    
    var sessionDetailsArray:NSMutableArray = NSMutableArray()
    
    var positionsArray:Dictionary<String,CGFloat> = Dictionary()
    
    var mCurrentTimeLine :CurrentTimeLineView!
    
    var timer = Timer()
    
    var sessionIdDictonary:Dictionary<String,AnyObject> = Dictionary()
    
    let dateFormatter = DateFormatter()
    
    var mAppVersionNumber               = UILabel();
    
    var mExtTimelabel: UILabel = UILabel();
    
    
    var extendTimeSessiondetails : AnyObject!
    
    var activityIndicator  = UIActivityIndicatorView(activityIndicatorStyle:.whiteLarge)
    
    var delayTime:Float = 0
    
    var liveSessionDetails         = NSMutableDictionary()
    
    var sessionUpdatedLive          :Bool = false
    
    
    var mScheduleDetailView  : ScheduleDetailView!
    
    var mStudentsStateView      : StudentsStateView!
    
    var mStudentsLessonPlanView      : SSTeacherLessonPlanView!
    
    static var currentSessionId : Int = 0
    
    static var nextSessionId : Int = 0
    
    
    
    fileprivate var foregroundNotification: NSObjectProtocol!
    
    
    override func viewDidAppear(_ animated: Bool)
    {
        super.viewDidAppear(animated)
        
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
        
        
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.view.backgroundColor = whiteBackgroundColor
        
        
        self.view.setNeedsLayout()
        self.view.layoutIfNeeded()
        
        

        SSTeacherMessageHandler.sharedMessageHandler.setdelegate(self)
        
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        mTopbarImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: (self.view.frame.size.height)/12))
        mTopbarImageView.backgroundColor = topbarColor
        self.view.addSubview(mTopbarImageView)
        mTopbarImageView.isUserInteractionEnabled = true
        
        
        mTeacherImageButton.frame = CGRect(x: 0, y: 0, width: mTopbarImageView.frame.size.height , height: mTopbarImageView.frame.size.height)
        mTopbarImageView.addSubview(mTeacherImageButton)
        mTeacherImageButton.addTarget(self, action: #selector(TeacherScheduleViewController.onTeacherImage), for: UIControlEvents.touchUpInside)
        
        
        mTeacherImageView = CustomProgressImageView(frame: CGRect(x: 15, y: 15, width: mTopbarImageView.frame.size.height - 20 ,height: mTopbarImageView.frame.size.height - 20))
        mTeacherImageView.backgroundColor = lightGrayColor
        mTopbarImageView.addSubview(mTeacherImageView)
        mTeacherImageView.layer.masksToBounds = true
        mTeacherImageView.layer.cornerRadius = 5
        
        
        let urlString = UserDefaults.standard.object(forKey: k_INI_UserProfileImageURL) as! String
        let userID = urlString.appending("/").appending(SSTeacherDataSource.sharedDataSource.currentUserId)
        
        print("\(urlString)/\(userID)_79px.jpg")
        
        if let checkedUrl = URL(string:"\(userID)_79px.jpg")
        {
            mTeacherImageView.contentMode = .scaleAspectFit
            mTeacherImageView.downloadImage(checkedUrl, withFolderType: folderType.proFilePics)
        }
        
        
        
        
        
        mTeacherName = UILabel(frame: CGRect(x: mTeacherImageView.frame.origin.x + mTeacherImageView.frame.size.width + 10, y: mTeacherImageView.frame.origin.y, width: 200, height: 20))
        mTeacherName.font = UIFont(name:helveticaMedium, size: 20)
        mTeacherName.text = SSTeacherDataSource.sharedDataSource.currentUserName.capitalized
        mTopbarImageView.addSubview(mTeacherName)
        mTeacherName.textColor = UIColor.white
        
        
        
        let mTeacher = UILabel(frame: CGRect(x: mTeacherImageView.frame.origin.x + mTeacherImageView.frame.size.width + 10, y: 40, width: 200, height: 20))
        mTeacher.font = UIFont(name:helveticaRegular, size: 16)
        mTeacher.text = "Teacher"
        mTopbarImageView.addSubview(mTeacher)
        mTeacher.textColor = UIColor.white
        
        
        
        
        
        let mTodaysSchedule = UILabel(frame: CGRect(x: (mTopbarImageView.frame.size.width - 200)/2, y: 15, width: 200, height: 20))
        mTodaysSchedule.font = UIFont(name:helveticaMedium, size: 20)
        mTodaysSchedule.text = "Today's schedule"
        mTopbarImageView.addSubview(mTodaysSchedule)
        mTodaysSchedule.textColor = UIColor.white
        
        
        
        mRefreshButton = UIButton(frame: CGRect(x: mTopbarImageView.frame.size.width - mTopbarImageView.frame.size.height, y: 0,width: mTopbarImageView.frame.size.height,height: mTopbarImageView.frame.size.height ))
        mRefreshButton.setImage(UIImage(named: "refresh.png"), for: UIControlState())
        mTopbarImageView.addSubview(mRefreshButton)
        mRefreshButton.contentEdgeInsets = UIEdgeInsetsMake(10, 10, 10, 10);
        mRefreshButton.addTarget(self, action: #selector(TeacherScheduleViewController.onRefreshButton(_:)), for: UIControlEvents.touchUpInside)
        mRefreshButton.isHidden = false
        
        
        mAppVersionNumber = UILabel(frame: CGRect(x: mRefreshButton.frame.origin.x - (mRefreshButton.frame.size.width + mRefreshButton.frame.size.width + 10), y: 0,width: (mRefreshButton.frame.size.width*2),height: mTopbarImageView.frame.size.height ))
        
        mTopbarImageView.addSubview(mAppVersionNumber)
        mAppVersionNumber.textAlignment = .right
        mAppVersionNumber.textColor = UIColor.white
        if let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
        {
            let buildNumber: String = Bundle.main.object(forInfoDictionaryKey: "CFBundleVersion") as! String
            
            
            mAppVersionNumber.text = "V = \(version).".appending(buildNumber)
        }
        
        
        activityIndicator.frame = CGRect(x: mRefreshButton.frame.origin.x - 60,  y: 0,width: mTopbarImageView.frame.size.height,height: mTopbarImageView.frame.size.height)
        mTopbarImageView.addSubview(activityIndicator)
        activityIndicator.isHidden = true
        
        
        mNoSessionLabel = UILabel(frame: CGRect(x: 10, y: (self.view.frame.size.height - 40)/2, width: self.view.frame.size.width - 20,height: 40))
        mNoSessionLabel.font = UIFont(name:helveticaMedium, size: 30)
        mNoSessionLabel.text = "Please wait we are loading your sessions "
        self.view.addSubview(mNoSessionLabel)
        mNoSessionLabel.textColor = UIColor.black
        mNoSessionLabel.textAlignment = .center
        
        
        mNoSessionSubLabel = UILabel(frame: CGRect(x: 10, y: mNoSessionLabel.frame.origin.y + mNoSessionLabel.frame.size.height + 0, width: self.view.frame.size.width - 20,height: 40))
        mNoSessionSubLabel.font = UIFont(name:helveticaRegular, size: 20)
        mNoSessionSubLabel.text = "Enjoy your day :)"
        self.view.addSubview(mNoSessionSubLabel)
        mNoSessionSubLabel.textColor = UIColor.black
        mNoSessionSubLabel.alpha = 0.5
        mNoSessionSubLabel.textAlignment = .center
        
        
        
        
        mScrollView = UIScrollView(frame: CGRect(x: 0,y: mTopbarImageView.frame.size.height,width: self.view.frame.size.width,height: self.view.frame.size.height - mTopbarImageView.frame.size.height))
        mScrollView.backgroundColor = whiteBackgroundColor
        self.view.addSubview(mScrollView)
        mScrollView.isHidden = true
        
        SSTeacherDataSource.sharedDataSource.getScheduleOfTeacher(self)
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
        
        
        
        addNumberOfLinesToScrollView()
        
        
        let currentDate = Date()
        mCurrentTimeLine = CurrentTimeLineView(frame: CGRect(x: 0, y: 0 , width: self.view.frame.size.width, height: 10))
        mScrollView.addSubview(mCurrentTimeLine)
        mCurrentTimeLine.addToCurrentTimewithHours(getPositionWithHour(currentDate.hour(), withMinute: currentDate.minute()))
        mScrollView.contentOffset = CGPoint(x: 0,y: mCurrentTimeLine.frame.origin.y-self.view.frame.size.height/3);
        mCurrentTimeLine.setCurrentTimeLabel(currentDate.toShortTimeString())
        checkToHideLabelwithDate(currentDate)
        
        mScrollView.bringSubview(toFront: mCurrentTimeLine)
        
//        timer = Timer.scheduledTimer(timeInterval: 60, target: self, selector: #selector(TeacherScheduleViewController.timerAction), userInfo: nil, repeats: true)
        
        
        // By Ujjval
        // ==========================================
        
        let calendar1 = Calendar.current
        let components: DateComponents? = calendar1.dateComponents([.second], from: Date())
        let currentSecond: Int = (components?.second)!
        //+1 to ensure we fire right after the minute change
        let fireDate = Date().addingTimeInterval(TimeInterval(Int(60 - currentSecond)))
        
        timer = Timer(fireAt: fireDate, interval: 60, target: self, selector: #selector(TeacherScheduleViewController.timerAction), userInfo: nil, repeats: true)
        RunLoop.main.add(timer, forMode: RunLoopMode.commonModes)
        
        // ==========================================
        
        
    }
    
    deinit {
        // make sure to remove the observer when this view controller is dismissed/deallocated
        
        NotificationCenter.default.removeObserver(foregroundNotification)
    }
    
    
    func addNumberOfLinesToScrollView()
    {
        var positionY: CGFloat = 30
        var hourValue = 1
        
        
        
        
        for index in 0 ..< 25
        {
            let hourlabel = UILabel(frame: CGRect(x: 10, y: positionY-15,width: 50,height: 30))
            mScrollView.addSubview(hourlabel)
            hourlabel.textColor = standard_TextGrey
            if index == 0
            {
                hourlabel.text = "\(12) am"
            }
            else if index == 12
            {
                hourlabel.text = "Noon"
            }
            else if index < 12
            {
                hourlabel.text = "\(index) am"
            }
            else if index > 12
            {
                hourlabel.text = "\(hourValue) pm"
                hourValue = hourValue+1
            }
            hourlabel.font = UIFont (name: helveticaRegular, size: 16)
            hourlabel.textAlignment = NSTextAlignment.right
            hourlabel.tag = index
            
            
            let hourLineView = ScheduleScreenLineView()
            hourLineView.frame = CGRect(x: 70, y: positionY, width: self.view.frame.size.width-70, height: 1)
            positionsArray[String("\(index)")] = positionY
            mScrollView.addSubview(hourLineView)
            
            
            
            
            if index != 24
            {
                let halfHourLineView =  DottedLine()
                halfHourLineView.frame = CGRect(x: 75, y: positionY + (oneHourDiff/2), width: self.view.frame.size.width-80, height: 2)
                
                mScrollView.addSubview(halfHourLineView)
                halfHourLineView.drawDashedBorderAroundView(with: UIColor(red: 153/255.0, green: 153/255.0, blue: 153/255.0, alpha: 1))
                positionY = positionY + oneHourDiff
            }
            
            
        }
        
        mScrollView.contentSize = CGSize(width: 0, height: positionY + oneHourDiff / 2 )
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func onRefreshButton(_ sender: AnyObject)
    {
        SSTeacherDataSource.sharedDataSource.getScheduleOfTeacher(self)
        mNoSessionLabel.text = "Please wait we are loading your sessions "
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
    }
    
    func timerAction() {
        let currentDate = Date()
        let currentHour = (currentDate.hour())
        mCurrentTimeLine.addToCurrentTimewithHours(getPositionWithHour(currentHour, withMinute: currentDate.minute()))
        mCurrentTimeLine.setCurrentTimeLabel(currentDate.toShortTimeString())
        checkToHideLabelwithDate(currentDate)
        mScrollView.bringSubview(toFront: mCurrentTimeLine)
    }
    
    
    
    
    func onTeacherImage()
    {
        
        
        let questionInfoController = SSSettingsViewController()
        questionInfoController.setDelegate(self)
        
        questionInfoController.scheduleScrrenTeacherImagePressed();
        
        let   classViewPopOverController = UIPopoverController(contentViewController: questionInfoController)
        
        classViewPopOverController.contentSize = CGSize(width: 310, height: 145);
        
        questionInfoController.setPopOver(classViewPopOverController)
        
        
        classViewPopOverController.present(from: CGRect(
            x:mTeacherImageButton.frame.origin.x ,
            y:mTeacherImageButton.frame.origin.y + mTeacherImageButton.frame.size.height,
            width: 1,
            height: 1), in: self.view, permittedArrowDirections: .up, animated: true)
        
        
        
        
        
        
        
        
        
        
        
        
    }
    
    // MARK: - Returning Functions
    
    func getPositionWithHour(_ _hour : Int, withMinute minute:Int) -> CGFloat
    {
        var  hour = _hour
        var returningValue = CGFloat()
        
        if hour < 0
        {
            hour = 0
        }
        
        
        returningValue = positionsArray[(String("\(hour)"))]! + CGFloat(minute) * halfHourMultipleRatio
        
        return returningValue
    }
    
    
    
    func getSizeOfCalendarEvernWithStarthour(_ startHour: Int, withstartMinute startMinute:Int, withEndHour endHour:Int, withEndMinute endMinute:Int) -> CGFloat
    {
        
        let startPosition = getPositionWithHour(startHour, withMinute: startMinute)
        
        let endposition = getPositionWithHour(endHour, withMinute: endMinute)
        
        
        let sizeOfEvent = endposition - startPosition
        
        
        return sizeOfEvent
    }
    
    
    
    // MARK: - Teacher datasource Error
    
    func didgetErrorMessage(_ message: String, WithServiceName serviceName: String)
    {
        self.view.makeToast(message, duration: 5.0, position: .bottom)
        
        activityIndicator.isHidden = true
        activityIndicator.stopAnimating()
        
    }
    
    // MARK: - Teacher datasource Delegate
    
    func didGetSchedulesWithDetials(_ details: AnyObject)
    {
        
        sessionUpdatedLive = false
        
        if mScheduleDetailView != nil
        {
            mScheduleDetailView.onDoneButton()
        }
        
        
        
        mNoSessionLabel.text = "Please wait we are loading your sessions "
       
        
        for index in 0 ..< sessionDetailsArray.count
        {
            let dict = sessionDetailsArray.object(at: index)
            let sessionid = (dict as AnyObject).object(forKey: kSessionId) as! String
            
            if let scheduleTileView  = mScrollView.viewWithTag(Int(sessionid)!) as? ScheduleScreenTile
            {
                scheduleTileView.stopAllTimmers()
                scheduleTileView.removeFromSuperview()
            }
        }
        
        
        sessionDetailsArray.removeAllObjects()
        if let statusString = details.object(forKey: "Status") as? String
        {
            if statusString == kSuccessString
            {
                mNoSessionLabel.isHidden = true
                mNoSessionSubLabel.isHidden = true
                mScrollView.isHidden = false
                
                if  let classCheckingVariable = (details.object(forKey: kSessions)! as AnyObject).object(forKey: kSubSession) as? NSMutableArray
                {
                    sessionDetailsArray = classCheckingVariable
                }
                else
                {
                    sessionDetailsArray.add((details.object(forKey: kSessions)! as AnyObject).object(forKey: kSubSession)!)
                    
                }
                
                
            }
            else
            {
                mNoSessionLabel.text = "You do not have any sessions today!"
                mNoSessionLabel.isHidden = false
                mNoSessionSubLabel.isHidden = false
                mScrollView.isHidden = true
            }
        }
        
        
        
        
        
        
        for index in 0 ..< sessionDetailsArray.count
        {
            let dict = sessionDetailsArray.object(at: index)
            
            let startDate :String = ((dict as AnyObject).object(forKey: kStartTime) as! String)
            let endDate = ((dict as AnyObject).object(forKey: kEndTime) as! String!)
            let totalSize = getSizeOfCalendarEvernWithStarthour(startDate.hourValue(), withstartMinute: startDate.minuteValue(), withEndHour: (endDate?.hourValue())!, withEndMinute: (endDate?.minuteValue())!)
            let StartPositionOfTile = getPositionWithHour(startDate.hourValue(), withMinute: startDate.minuteValue())
            
            
            let scheduleTileView = ScheduleScreenTile(frame: CGRect(x: 80, y: StartPositionOfTile, width: self.view.frame.size.width-90, height: totalSize))
            mScrollView.addSubview(scheduleTileView)
            scheduleTileView.setdelegate(self)
            
            
            let sessionid = (dict as AnyObject).object(forKey: kSessionId) as! String
            
            let sessionState = (dict as AnyObject).object(forKey: kSessionState) as! String
            
            
            sessionIdDictonary[sessionid] = dict as AnyObject?
            scheduleTileView.tag = Int(sessionid)!
            scheduleTileView.setCurrentSessionDetails(dict as AnyObject)
            
        }
        
        
        
        let currentDate = Date()
        let currentHour = (currentDate.hour())
        mCurrentTimeLine.addToCurrentTimewithHours(getPositionWithHour(currentHour, withMinute: currentDate.minute()))
        
        mCurrentTimeLine.setCurrentTimeLabel(currentDate.toShortTimeString())
        mScrollView.bringSubview(toFront: mCurrentTimeLine)
        checkToHideLabelwithDate(currentDate)
        
        UIView.animate(withDuration: 0.5, animations: {
            self.mScrollView.contentOffset = CGPoint(x: 0,y: self.mCurrentTimeLine.frame.origin.y - self.view.frame.size.height/3);
        })
        
        
        if sessionDetailsArray.count > 0
        {
            SSTeacherDataSource.sharedDataSource.getMyCurrentSessionOfTeacher(self)
        }
        else
        {
            activityIndicator.isHidden = true
            activityIndicator.stopAnimating()
        }
        
        SSTeacherMessageHandler.sharedMessageHandler.refreshApp()
        TeacherScheduleViewController.destroyUnusedRooms();
    }
    
    static func destroyUnusedRooms(){
        SSTeacherDataSource.sharedDataSource.refreshApp(success: { (response) in
            if let unusedRooms = response.object(forKey: "DestroyRooms") as? NSArray{
                for unusedRoom in unusedRooms{
                    if let sessionId:Int = (unusedRoom as AnyObject).object(forKey: "class_session_id") as? Int{
                    SSTeacherMessageHandler.sharedMessageHandler.destroyRoom("room_"+"\(sessionId)")
                    SSTeacherMessageHandler.sharedMessageHandler.destroyRoom("question_"+"\(sessionId)")
                    }
                }
            }
            
        })
        { (error) in
            NSLog("Refresh API failed, unable to join xmpp rooms")
        }
    }
    
    
    
    static func joinXMPPRooms(){
        SSTeacherDataSource.sharedDataSource.refreshApp(success: { (response) in
            
            if let summary = response.object(forKey: "Summary") as? NSArray
            {
                if summary.count > 0
                {
                    let details = summary.firstObject as AnyObject
                    if let currentState = details.object(forKey: "CurrentSessionState") as? Int{
                        
                        let currentSessionId:Int = (summary.value(forKey: "CurrentSessionId") as! NSArray)[0] as! Int
                        self.currentSessionId = currentSessionId
                        let currentSessionState:Int = (summary.value(forKey: "CurrentSessionState") as! NSArray)[0] as! Int
                        self.joinOrLeaveXMPPSessionRoom(sessionState:String(describing:currentSessionState), roomName:String(describing:currentSessionId))
                        
                        
                    }
                    if let nextState = details.object(forKey: "NextClassSessionState") as? Int{
                        let nextSessionState:Int = (summary.value(forKey: "NextClassSessionState") as! NSArray)[0] as! Int
                        let nextSessionId:Int = (summary.value(forKey: "NextClassSessionId") as! NSArray)[0] as! Int
                        self.nextSessionId = nextSessionId
                        self.joinOrLeaveXMPPSessionRoom(sessionState:String(describing:nextSessionState), roomName:String(describing:nextSessionId))
                    }
                    
                }
            }
            
            
        }) { (error) in
            NSLog("Refresh API failed, unable to join xmpp rooms")
        }
    }
    
    
    static func joinOrLeaveXMPPSessionRoom(sessionState: String, roomName: String){
        if sessionState == kLive || sessionState == kopened || sessionState == kScheduled
        {
            SSTeacherMessageHandler.sharedMessageHandler.createRoomWithRoomName(String(format:"room_%@",roomName), withHistory: "0")
        }
        else
        {
            SSTeacherMessageHandler.sharedMessageHandler.checkAndRemoveJoinedRoomsArrayWithRoomid(String(format:"room_%@",roomName))
        }        
    }
    
    static func destroyUnusedRooms(){
        SSTeacherDataSource.sharedDataSource.refreshApp(success: { (response) in
            if let unusedRooms = response.object(forKey: "DestroyRooms") as? NSArray{
                for unusedRoom in unusedRooms{
                    if let sessionId:Int = (unusedRoom as AnyObject).object(forKey: "class_session_id") as? Int{
                    SSTeacherMessageHandler.sharedMessageHandler.destroyRoom("room_"+"\(sessionId)")
                    SSTeacherMessageHandler.sharedMessageHandler.destroyRoom("question_"+"\(sessionId)")
                    }
                }
            }
            
        })
        { (error) in
            NSLog("Refresh API failed, unable to join xmpp rooms")
        }
    }
    
    
    
    
    
    
    
    
    func didGetMycurrentSessionWithDetials(_ details: AnyObject)
    {
        
        if let currentSessionId = details.object(forKey: "SessionId") as? String
        {
            
            if let SessionState = details.object(forKey: "SessionState") as? String
            {
                if SessionState == kScheduled || SessionState == kopened
                {
                    
                    
                    let currentDate = Date()
                    let isgreatervalue :Bool ;
                    
                    isgreatervalue = currentDate.isGreaterThanDate(dateFormatter.date(from: details.object(forKey: "StartTime") as! String)!)
                    
                    let  isEqualValue = currentDate == dateFormatter.date(from: details.object(forKey: "StartTime") as! String)!
                    
                    if isgreatervalue == true || isEqualValue == true
                    {
                        updateOverDueSessionWithSessionId(currentSessionId)
                    }
                    else
                    {
                        updateNextSessionWithSessionId(currentSessionId)
                    }
                }
                else if let nextSessionId = details.object(forKey: "NextSessionId") as? String
                {
                    updateNextSessionWithSessionId(nextSessionId)
                }
            }
            
        }
        else if let nextSessionId = details.object(forKey: "NextSessionId") as? String
        {
            updateNextSessionWithSessionId(nextSessionId)
        }
        
        
        
        activityIndicator.isHidden = true
        activityIndicator.stopAnimating()
        
        
    }
    
    func didGetSessionUpdatedWithDetials(_ details: AnyObject)
    {
        
        if sessionUpdatedLive == false
        {
            SSTeacherDataSource.sharedDataSource.getScheduleOfTeacher(self)
        }
        else
        {
            let currentDate = Date()
            
            
            let startTime = dateFormatter.string(from: currentDate)
            liveSessionDetails.setValue(startTime, forKey: "StartTime" )
            
            //                liveSessionDetails.set(startTime, forKey: "StartTime")
            //                liveSessionDetails.set(dateFormatter.string(from: currentDate), forKey: "StartTime")
            
            beginClassWithDetails(liveSessionDetails)
            
            
        }
        
        activityIndicator.isHidden = true
        activityIndicator.stopAnimating()
        
        
        
        
        
        
    }
    
    func didGetSessionExtendedDetials(_ details: AnyObject) {
        
        
        SSTeacherDataSource.sharedDataSource.getScheduleOfTeacher(self)
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
        
        if let currentSessionDetails = extendTimeSessiondetails
        {
            
            let timeDelayString = "\(currentSessionDetails.object(forKey: "ClassName") as! String) class time Extended for \(Int(delayTime)) Minutes"
            
            self.sendTimeExtendMessageWithDetails(currentSessionDetails, withMessage: timeDelayString, withSessionState: SubjectSessionState.Begin)
        }
        
        
        
    }
    
    func didGetLogOutWithDetails(_ details: AnyObject)
    {
        print(details)
        
        if details.object(forKey: "Status") != nil
        {
            if let status = details.object(forKey: "Status") as? String
            {
                if status == kSuccessString
                {
                    if UserDefaults.standard.object(forKey: kPassword) != nil
                    {
                        UserDefaults.standard.removeObject(forKey: kPassword)
                    }
                    
                    
                    SSTeacherMessageHandler.sharedMessageHandler.goOffline()
                    performSegue(withIdentifier: "ScheduleToLogin", sender: nil)
                    
                    activityIndicator.isHidden = true
                    activityIndicator.stopAnimating()
                    
                }
            }
        }
        
        
    }
    
    // MARK: - session checking Functions
    
    
    func updateNextSessionWithSessionId(_ sessionId:String)
    {
        if let currentSessionDetails = sessionIdDictonary[sessionId]
        {
            
            
            
            if let SessionState = currentSessionDetails.object(forKey: "SessionState") as? String
            {
                
                if SessionState == kScheduled || SessionState == kopened
                {
                    if let scheduleTileView  = mScrollView.viewWithTag(Int(sessionId)!) as? ScheduleScreenTile
                    {
                        scheduleTileView.nextSessionUpdatingWithdetails(currentSessionDetails)
                    }
                    
                    
                    
                    
                    let currentDate = Date()
                    
                    let differenceMinutes  = currentDate.minutesAndSecondsDiffernceBetweenDates(currentDate, endDate: dateFormatter.date(from: currentSessionDetails.object(forKey: "StartTime") as! String)!)
                    
                    if differenceMinutes.second < 120
                    {
                        
                        
                        showScheduleScreenAlertWithDetails(currentSessionDetails, withMessage:"Your class is about to start in \n \(differenceMinutes.minutes) minutes \(Int(secondsToMinutesSeconds(Double(differenceMinutes.second)).1)) seconds")
                    }
                    
                    
                }
            }
            
        }
        
    }
    
    func updateOverDueSessionWithSessionId(_ sessionId:String)
    {
        if let currentSessionDetails = sessionIdDictonary[sessionId]
        {
            
            if let SessionState = currentSessionDetails.object(forKey: "SessionState") as? String
            {
                
                if SessionState == kScheduled || SessionState == kopened
                {
                    if let scheduleTileView  = mScrollView.viewWithTag(Int(sessionId)!) as? ScheduleScreenTile
                    {
                        scheduleTileView.OverDueSessionIsWithDetails(currentSessionDetails)
                    }
                    
                    
                    showScheduleScreenAlertWithDetails(currentSessionDetails, withMessage: "Your class is OVERDUE")
                }
                
                
            }
            
            
            
        }
    }
    
    // MARK: - ScheduleScreen tile delegate functions
    
    
    func delegateScheduleTileTouchedWithState(_ state: String, withCurrentTileDetails Details: AnyObject)
    {
        
        if let SessionState = Details.object(forKey: "SessionState") as? String
        {
            if SessionState == kScheduled || SessionState == kopened
            {
                if let _ = Details.object(forKey: "SessionId") as? String
                {
                    if mScheduleDetailView == nil
                    {
                        mScheduleDetailView = ScheduleDetailView(frame: CGRect(x: self.view.frame.size.width, y: mScrollView.frame.origin.y ,width: self.view.frame.size.width / 2 , height: mScrollView.frame.size.height))
                        self.view.addSubview(mScheduleDetailView)
                        mScheduleDetailView.addAllSubView()
                        mScheduleDetailView.setdelegate(self)
                        self.view.bringSubview(toFront: mScheduleDetailView)
                        mScheduleDetailView.backgroundColor = UIColor.white
                        mScheduleDetailView.layer.shadowRadius = 1.0;
                        
                        mScheduleDetailView.layer.shadowColor = UIColor.black.cgColor
                        mScheduleDetailView.layer.shadowOpacity = 0.3
                        mScheduleDetailView.layer.shadowOffset = CGSize.zero
                        mScheduleDetailView.layer.shadowRadius = 10
                        
                    }
                    
                    mScheduleDetailView.teacherScheduleViewController = self
                    
                    mScheduleDetailView.isHidden = false
                    
                    UIView.animate(withDuration: 0.5, animations: {
                        self.mScheduleDetailView.frame = CGRect(x: self.view.frame.size.width - (self.view.frame.size.width / 2), y: self.mScrollView.frame.origin.y ,width: self.view.frame.size.width / 2 , height: self.mScrollView.frame.size.height)
                    }, completion: { finished in
                        
                    })
                    
                    mScheduleDetailView.setClassname((Details.object(forKey: "ClassName") as! String),withSessionDetails: Details)
                    
                    
                }
            }
            else  if SessionState == kCanClled
            {
                self.view.makeToast("This class was cancelled.", duration: 0.5, position: .bottom)
                
            }
            else  if SessionState == kEnded
            {
                self.view.makeToast("This class has already ended.", duration: 0.5, position: .bottom)
            }
            else if SessionState == kLive
            {
                if mScheduleDetailView != nil
                {
                    mScheduleDetailView.onDoneButton()
                }
                
                liveSessionDetails = Details as! NSMutableDictionary
                
                beginClassWithDetails(liveSessionDetails)
                
            }
        }
        
    }
    
    func delegateRefreshSchedule()
    {
        SSTeacherDataSource.sharedDataSource.getScheduleOfTeacher(self)
         mNoSessionLabel.text = "Please wait we are loading your sessions "
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
        
    }
    
    
    
    
    // MARK: - Alert functions
    
    func showScheduleScreenAlertWithDetails(_ currentSessionDetails:AnyObject, withMessage message:String)
    {
        
        
        if let StudentsRegistered = currentSessionDetails.object(forKey: "StudentsRegistered") as? String
        {
            if let PreAllocatedSeats = currentSessionDetails.object(forKey: "PreAllocatedSeats") as? String
            {
                if let OccupiedSeats = currentSessionDetails.object(forKey: "OccupiedSeats") as? String
                {
                    
                    if Int(StudentsRegistered) > Int(PreAllocatedSeats)! + Int(OccupiedSeats)!
                    {
                        
                        showAllocateSeatAlertWithSessionId(currentSessionDetails.object(forKey: "SessionId") as! String , withMessage:message )
                    }
                    else if let SessionState = currentSessionDetails.object(forKey: "SessionState") as? String
                    {
                        if SessionState == kScheduled
                        {
                            showOpenClassAlertWithSessionId(currentSessionDetails.object(forKey: "SessionId") as! String , withMessage: message)
                        }
                        if SessionState == kopened
                        {
                            showBeginClassAlertWithSessionId(currentSessionDetails.object(forKey: "SessionId") as! String , withMessage: message)
                        }
                    }
                }
            }
        }
    }
    
    
    func showAllocateSeatAlertWithSessionId(_ SessionId:String, withMessage message:String)
    {
        
        
        
        
        //        if sessionAlertView != nil
        //        {
        //            if sessionAlertView.isBeingPresented()
        //            {
        //                sessionAlertView.dismissViewControllerAnimated(true, completion: nil)
        //            }
        //        }
        
        
        //        sessionAlertView = UIAlertController(title: "AllocateSeat", message: message, preferredStyle: UIAlertControllerStyle.Alert)
        //        sessionAlertView.addAction(UIAlertAction(title: "Allocate seats", style: .Default, handler: { action in
        //
        //            if let currentSessionDetails = self.sessionIdDictonary[SessionId]
        //            {
        //                self.allocateSeatsWithDetails(currentSessionDetails)
        //            }
        //
        //
        //
        //        }))
        
        //        sessionAlertView.addAction(UIAlertAction(title: "Cancel Class", style: .Default, handler: { action in
        //
        //            SSTeacherDataSource.sharedDataSource.updateSessionStateWithSessionId(SessionId, WithStatusvalue: kCanClled, WithDelegate: self)
        //
        //            if let currentSessionDetails = self.sessionIdDictonary[SessionId]
        //            {
        //                self.sendTimeExtendMessageWithDetails(currentSessionDetails, withMessage: "Class has been cancelled")
        //            }
        //
        //
        //
        //
        //
        //        }))
        
        //        sessionAlertView.addAction(UIAlertAction(title: "Extendtime", style: .Default, handler: { action in
        //
        //            if let currentSessionDetails = self.sessionIdDictonary[SessionId]
        //            {
        //                self.showExtendTimeAlertForSessionDetaisl(currentSessionDetails)
        //            }
        //
        //        }))
        
        //        sessionAlertView.addAction(UIAlertAction(title: "Dismiss", style: .Cancel, handler: { action in
        //
        //
        //                if let scheduleTileView  = self.mScrollView.viewWithTag(Int(SessionId)!) as? ScheduleScreenTile
        //                {
        //                    scheduleTileView.alertDismissed()
        //                }
        //
        //        }))
        //
        //        self.presentViewController(sessionAlertView, animated: true, completion: nil)
    }
    
    
    
    
    func showOpenClassAlertWithSessionId(_ SessionId:String, withMessage message:String)
    {
        //        if sessionAlertView != nil
        //        {
        //            if sessionAlertView.isBeingPresented()
        //            {
        //                sessionAlertView.dismissViewControllerAnimated(true, completion: nil)
        //            }
        //        }
        
        
        //        sessionAlertView = UIAlertController(title: "OpenClass", message: message, preferredStyle: UIAlertControllerStyle.Alert)
        //        sessionAlertView.addAction(UIAlertAction(title: "Open Class", style: .Default, handler: { action in
        //             SSTeacherDataSource.sharedDataSource.updateSessionStateWithSessionId(SessionId, WithStatusvalue: kopened, WithDelegate: self)
        //
        //            if let currentSessionDetails = self.sessionIdDictonary[SessionId]
        //            {
        //                self.sendTimeExtendMessageWithDetails(currentSessionDetails, withMessage: "Class has been opened")
        //            }
        //
        //
        //        }))
        
        //        sessionAlertView.addAction(UIAlertAction(title: "Cancel Class", style: .Default, handler: { action in
        //
        //             SSTeacherDataSource.sharedDataSource.updateSessionStateWithSessionId(SessionId, WithStatusvalue: kCanClled, WithDelegate: self)
        //
        //        }))
        
        //        sessionAlertView.addAction(UIAlertAction(title: "Extendtime", style: .Default, handler: { action in
        //
        //            if let currentSessionDetails = self.sessionIdDictonary[SessionId]
        //            {
        //                self.showExtendTimeAlertForSessionDetaisl(currentSessionDetails)
        //            }
        //
        //
        //
        //        }))
        //
        //        sessionAlertView.addAction(UIAlertAction(title: "Dismiss", style: .Cancel, handler: { action in
        //
        //
        //            if let scheduleTileView  = self.mScrollView.viewWithTag(Int(SessionId)!) as? ScheduleScreenTile
        //            {
        //                scheduleTileView.alertDismissed()
        //            }
        //
        //
        //        }))
        //
        //        self.presentViewController(sessionAlertView, animated: true, completion: nil)
    }
    
    func showBeginClassAlertWithSessionId(_ SessionId:String, withMessage message:String)
    {
        //        if sessionAlertView != nil
        //        {
        //            if sessionAlertView.isBeingPresented()
        //            {
        //                sessionAlertView.dismissViewControllerAnimated(true, completion: nil)
        //            }
        //        }
        
        
        //        sessionAlertView = UIAlertController(title: "BeginClass", message: message, preferredStyle: UIAlertControllerStyle.Alert)
        //        sessionAlertView.addAction(UIAlertAction(title: "Begin Class", style: .Default, handler: { action in
        //
        //
        //            self.sessionUpdatedLive = true
        //             SSTeacherDataSource.sharedDataSource.updateSessionStateWithSessionId(SessionId, WithStatusvalue: kLive, WithDelegate: self)
        //
        //            if let currentSessionDetails = self.sessionIdDictonary[SessionId]
        //            {
        //
        //
        //                self.liveSessionDetails = currentSessionDetails
        //            }
        //
        //        }))
        
        //        sessionAlertView.addAction(UIAlertAction(title: "Cancel Class", style: .Default, handler: { action in
        //
        //             SSTeacherDataSource.sharedDataSource.updateSessionStateWithSessionId(SessionId, WithStatusvalue: kCanClled, WithDelegate: self)
        //
        //        }))
        
        //        sessionAlertView.addAction(UIAlertAction(title: "Extendtime", style: .Default, handler: { action in
        //
        //            if let currentSessionDetails = self.sessionIdDictonary[SessionId]
        //            {
        //                self.showExtendTimeAlertForSessionDetaisl(currentSessionDetails)
        //            }
        //
        //        }))
        
        //        sessionAlertView.addAction(UIAlertAction(title: "Dismiss", style: .Cancel, handler: { action in
        //
        //            if let scheduleTileView  = self.mScrollView.viewWithTag(Int(SessionId)!) as? ScheduleScreenTile
        //            {
        //                scheduleTileView.alertDismissed()
        //            }
        //
        //        }))
        //
        //        self.presentViewController(sessionAlertView, animated: true, completion: nil)
    }
    
    
    
    
    
    
    
    // MARK: - message handler functions
    
    func smhDidRecieveStreamConnectionsState(_ state: Bool) {
        
        //        self.view.makeToast("Xmpp Stream disconnected.", duration: 0.2, position: .Bottom)
        
        activityIndicator.stopAnimating()
        activityIndicator.isHidden = true
        
        
    }
    
    func smhDidReciveAuthenticationState(_ state: Bool, WithName userName: String) {
        
        activityIndicator.stopAnimating()
        activityIndicator.isHidden = true
        
        AppDelegate.sharedDataSource.hideReconnecting()
    }
    
    func smhStreamReconnectingWithDelay(_ delay: Int32)
    {
        self.view.makeToast("Reconnecting in \(delay) seconds", duration: 3, position: .bottom)
        
        activityIndicator.startAnimating()
        activityIndicator.isHidden = false
        
        AppDelegate.sharedDataSource.showReconnecting()
        
    }
    
    
    func smhDidgetStudentBentchStateWithStudentId(_ studentId: String, withState state: String)
    {
        if mScheduleDetailView != nil
        {
            if mScheduleDetailView.isHidden == false
            {
                mScheduleDetailView.refreshJoinedStateBar()
            }
        }
        
        
        if mStudentsStateView != nil
        {
            if mStudentsStateView.isHidden == false
            {
                mStudentsStateView.StudentsStateRefreshedWithStudentId(studentId: studentId, WithState: state)
            }
        }
        
    }
    
    
    // MARK: - Extra functions
    
    func secondsToMinutesSeconds (_ seconds : Double) -> (Double, Double)
    {
        let (_,  minf) = modf (seconds / 3600)
        let (min, secf) = modf (60 * minf)
        return ( min, 60 * secf)
    }
    
    
    func sendTimeExtendMessageWithDetails(_ currentSessionDetails:AnyObject, withMessage message:String, withSessionState: String)
    {
        
        SSTeacherMessageHandler.sharedMessageHandler.sendExtendedTimetoRoom((currentSessionDetails.object(forKey: "SessionId") as? String)!, withClassName: (currentSessionDetails.object(forKey: "ClassName") as? String)! , withStartTime: (currentSessionDetails.object(forKey: "StartTime") as? String)!, withDelayTime:message, withSessionState: withSessionState)
    }
    
    
    
    // MARK: - Extend Time Alert view functions
    
    func showExtendTimeAlertForSessionDetaisl(_ details:AnyObject)
    {
        
        extendTimeSessiondetails = details
        
        let alertView = CustomAlertView(frame: CGRect(x: 0, y: 0, width: 1024, height: 768))
        
        
        alertView.containerView = createDemoView()
        
        alertView.buttonTitles = NSMutableArray(objects: "Cancel", "Done") as [AnyObject]
        
        alertView.delegate = self
        
        delayTime = 1;
        
        
        alertView.useMotionEffects = true;
        
        let mySlider = UISlider(frame:CGRect(x: 15, y: 90, width: 320, height: 20))
        
        let currentDate = Date()
        let differenceMinutes  = currentDate.minutesDiffernceBetweenDates(dateFormatter.date(from: extendTimeSessiondetails.object(forKey: "StartTime") as! String)!, endDate: dateFormatter.date(from: extendTimeSessiondetails.object(forKey: "EndTime") as! String)!)
        
        if differenceMinutes > 20
        {
            mySlider.maximumValue = 20;
        }
        else
        {
            
            mySlider.maximumValue = Float(differenceMinutes)
        }
        
        mySlider.minimumValue=1.00;
        
        mySlider.addTarget(self, action: #selector(TeacherScheduleViewController.sliderHandler(_:)), for: UIControlEvents.valueChanged)
        mySlider.tintColor = UIColor.green;
        
        mExtTimelabel=UILabel(frame: CGRect(x: 50, y: 20, width: 250, height: 40));
        mExtTimelabel.text = "Extend time with \(Int(delayTime)) min";
        mExtTimelabel.textColor = UIColor.black;
        mExtTimelabel.textAlignment = .center;
        alertView.containerView.addSubview(mExtTimelabel);
        alertView.containerView.addSubview(mySlider);
        alertView.show();
        
        
        
        
    }
    
    func createDemoView()   -> UIView
    {
        let customView = UIView(frame: CGRect(x: 0, y: 0, width: 350, height: 150))
        customView.isUserInteractionEnabled = true
        return customView
    }
    
    func sliderHandler(_ sender:UISlider)
    {
        delayTime = sender.value;
        mExtTimelabel.text = "Extend time with \(Int(delayTime)) min"
    }
    
    public func customdialogButtonTouchUp(inside alertView: Any!, clickedButtonAt buttonIndex: Int)
    {
        
        
        
        (alertView as! CustomAlertView).close()
        
        if buttonIndex == 1
        {
            let currentDate = Date()
            
            let differenceMinutes  = currentDate.minutesDiffernceBetweenDates(dateFormatter.date(from: extendTimeSessiondetails.object(forKey: "StartTime") as! String)!, endDate: currentDate)
            
            delayTime = delayTime + Float(differenceMinutes)
            
            if let currentSessionDetails = extendTimeSessiondetails
            {
                SSTeacherDataSource.sharedDataSource.extendSessionWithSessionId(currentSessionDetails.object(forKey: "SessionId") as! String, withTime: "\(Int(delayTime))", WithDelegate: self)
            }
            
            
        }
        else
        {
            
            if let currentSessionDetails = extendTimeSessiondetails
            {
                if let scheduleTileView  = self.mScrollView.viewWithTag(Int(currentSessionDetails.object(forKey: "SessionId") as! String)!) as? ScheduleScreenTile
                {
                    scheduleTileView.alertDismissed()
                }
            }
            
        }
        
    }
    
    // MARK: - schedule details view  delegate Functions
    func delegateAllocateSeatPressedWithDetails(_ details: AnyObject)
    {
        self.allocateSeatsWithDetails(details)
        
    }
    func delegateEditSeatPressedWithDetails(_ details: AnyObject)
    {
        self.allocateSeatsWithDetails(details)
    }
    func delegateConfigureGridPressedWithDetails(_ details: AnyObject)
    {
        let gridView = SetupGridview()
        gridView.setCurrentSessionDetails(details)
        present(gridView, animated: true, completion: nil)
        
    }
    func delegateCancelClassPressedWithDetails(_ details: AnyObject)
    {
        
        
        let  sessionAlertView = UIAlertController(title: "Cancel class", message: "Do you really want to Cancel this class? \n You cannot reverse this action!", preferredStyle: UIAlertControllerStyle.alert)
        sessionAlertView.addAction(UIAlertAction(title: "Cancel class", style: .default, handler: { action in
            
            
            if let sessionid = details.object(forKey: kSessionId) as? String
            {
                SSTeacherDataSource.sharedDataSource.updateSessionStateWithSessionId(sessionid, WithStatusvalue: kCanClled, WithDelegate: self)
                

                SSTeacherMessageHandler.sharedMessageHandler.destroyRoom("room_"+sessionid)
                SSTeacherMessageHandler.sharedMessageHandler.destroyRoom("question_"+sessionid)
                
                self.activityIndicator.isHidden = false
                self.activityIndicator.startAnimating()
                
                self.sendTimeExtendMessageWithDetails(details, withMessage: "Class has been cancelled", withSessionState: SubjectSessionState.Cancelled)
                
                self.mScheduleDetailView.onDoneButton()
            }
            
            
        }))
        
        sessionAlertView.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: { action in
            
            if let sessionid = details.object(forKey: kSessionId) as? String
            {
                if let scheduleTileView  = self.mScrollView.viewWithTag(Int(sessionid)!) as? ScheduleScreenTile
                {
                    scheduleTileView.alertDismissed()
                }
            }
            
            
            
        }))
        
        
        self.present(sessionAlertView, animated: true, completion: nil)
        
        
        
    }
    func delegateOpenClassPressedWithDetails(_ details: AnyObject)
    {
        if let sessionid = details.object(forKey: kSessionId) as? String
        {
            SSTeacherDataSource.sharedDataSource.updateSessionStateWithSessionId(sessionid, WithStatusvalue: kopened, WithDelegate: self)
            self.activityIndicator.isHidden = false
            self.activityIndicator.startAnimating()
            
            self.sendTimeExtendMessageWithDetails(details, withMessage: "Class has been opened", withSessionState: SubjectSessionState.Open)
            
            self.mScheduleDetailView.onDoneButton()
        }
    }
    func delegateBeginClassPressedWithDetails(_ details: AnyObject)
    {
        if let sessionid = details.object(forKey: kSessionId) as? String
        {
            self.sessionUpdatedLive = true
            self.liveSessionDetails = details as! NSMutableDictionary
            
            SSTeacherDataSource.sharedDataSource.updateSessionStateWithSessionId(sessionid, WithStatusvalue: kLive, WithDelegate: self)
            self.activityIndicator.isHidden = false
            self.activityIndicator.startAnimating()
            self.mScheduleDetailView.onDoneButton()
        }
    }
    
    func delegateResetButtonPressedWithDetails(_ details: AnyObject) {
        onRefreshButton(details)
        self.mScheduleDetailView.onDoneButton()
    }
    
    
    func delegateViewStudentsPressed(_ details: AnyObject)
    {
        if mStudentsStateView == nil
        {
            mStudentsStateView =  StudentsStateView(frame: CGRect(x: 10, y: mTopbarImageView.frame.size.height + 10, width: self.view.frame.size.width - 20, height: self.view.frame.size.height - (mTopbarImageView.frame.size.height + 20)))
            mStudentsStateView.setdelegate(self)
            mStudentsStateView.layer.shadowColor = UIColor.black.cgColor
            mStudentsStateView.layer.shadowOpacity = 0.3
            mStudentsStateView.layer.shadowOffset = CGSize.zero
            mStudentsStateView.layer.shadowRadius = 10
            self.view.addSubview(mStudentsStateView)
            
            
        }
        else
        {
            mStudentsStateView.isHidden = false
            self.view.bringSubview(toFront: mStudentsStateView)
            
        }
        
        
        if let sessionId = details.object(forKey: "RoomId") as? String
        {
            self.mScheduleDetailView.onDoneButton()
            
            mStudentsStateView.addStudentsWithRoomId(RoomId: sessionId, withDetails: details)
        }
        
    }
    
    
    func delegateViewLessonPlanPressed(_ details: AnyObject)
    {
        if mStudentsLessonPlanView == nil
        {
            mStudentsLessonPlanView =  SSTeacherLessonPlanView(frame: CGRect(x: 0, y: mTopbarImageView.frame.size.height + 10, width: self.view.frame.size.width, height: self.view.frame.size.height - (mTopbarImageView.frame.size.height + 20)))
            mStudentsLessonPlanView.layer.shadowColor = UIColor.black.cgColor
            mStudentsLessonPlanView.layer.shadowOpacity = 0.3
            mStudentsLessonPlanView.layer.shadowOffset = CGSize.zero
            mStudentsLessonPlanView.layer.shadowRadius = 10
            self.view.addSubview(mStudentsLessonPlanView)
            mStudentsLessonPlanView.setdelegate(self)
            
        }
        else
        {
            
            if mStudentsLessonPlanView != nil
            { // Make sure the view exists
                
                if self.view.subviews.contains(mStudentsLessonPlanView) == false
                {
                    mStudentsLessonPlanView =  SSTeacherLessonPlanView(frame: CGRect(x: 0, y: mTopbarImageView.frame.size.height + 10, width: self.view.frame.size.width, height: self.view.frame.size.height - (mTopbarImageView.frame.size.height + 20)))
                    mStudentsLessonPlanView.layer.shadowColor = UIColor.black.cgColor
                    mStudentsLessonPlanView.layer.shadowOpacity = 0.3
                    mStudentsLessonPlanView.layer.shadowOffset = CGSize.zero
                    mStudentsLessonPlanView.layer.shadowRadius = 10
                    self.view.addSubview(mStudentsLessonPlanView)
                    mStudentsLessonPlanView.setdelegate(self)
                    
                }
                
            }
            
            
            
            mStudentsLessonPlanView.isHidden = false
            self.view.bringSubview(toFront: mStudentsLessonPlanView)
            
        }
        
        
        if (details.object(forKey: "RoomId") as? String) != nil
        {
            self.mScheduleDetailView.onDoneButton()
            
            mStudentsLessonPlanView.setCurrentSessionDetails(details)
        }
    }
    
    func delegateDoneButtonPressed()
    {
        mStudentsLessonPlanView = nil
    }
    
    // MARK: - Change screen Functions
    
    func allocateSeatsWithDetails(_ details:AnyObject)
    {
        
        
        
        let storyboard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let preallotController : PreallocateSeatViewController = storyboard.instantiateViewController(withIdentifier: "PreallocateSeatViewController") as! PreallocateSeatViewController
        
        preallotController.setCurrentSessionDetails(details)
        self.present(preallotController, animated: true, completion: nil)
        
    }
    
    func beginClassWithDetails(_ details:AnyObject)
    {
        
        for index in 0 ..< sessionDetailsArray.count
        {
            let dict = sessionDetailsArray.object(at: index)
            let sessionid = (dict as AnyObject).object(forKey: kSessionId) as! String
            
            if let scheduleTileView  = mScrollView.viewWithTag(Int(sessionid)!) as? ScheduleScreenTile
            {
                scheduleTileView.stopAllTimmers()
            }
        }
        
        
        if (details.object(forKey: kSessionId) != nil)
        {
            let storyboard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let preallotController : SSTeacherClassView = storyboard.instantiateViewController(withIdentifier: "SSTeacherClassView") as! SSTeacherClassView
            
            preallotController.setSessionDetails(details)
            
            
            self.sendTimeExtendMessageWithDetails(details, withMessage: "Class has begun", withSessionState: SubjectSessionState.Begin)
            
            self.present(preallotController, animated: true, completion: nil)
        }
        else
        {
            //            delegateRefreshSchedule()
            self.view.makeToast("Error in schedule. Please refresh...", duration:3.0, position: .bottom)
        }
        
        
    }
    
    func checkToHideLabelwithDate(_ currentDate:Date)
    {
        
        
        for index in 0 ..< 25
        {
            if let hourLabel  = mScrollView.viewWithTag(index) as? UILabel
            {
                hourLabel.isHidden = false
            }
        }
        
        
        if currentDate.minute() > 55
        {
            if let hourLabel  = mScrollView.viewWithTag(currentDate.hour() + 1) as? UILabel
            {
                hourLabel.isHidden = true
            }
        }
        else if currentDate.minute() < 5
        {
            if let hourLabel  = mScrollView.viewWithTag(currentDate.hour()) as? UILabel
            {
                hourLabel.isHidden = true
            }
        }
        
        
    }
    
    func settings_performLogout()
    {
        SSTeacherDataSource.sharedDataSource.logOutTeacherWithDelegate(self)
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
        
    }
    
    func settings_XmppReconnectButtonClicked() {
        SSTeacherMessageHandler.sharedMessageHandler.performReconnet(connectType: "Others")
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
    }
    
}
