//
//  SSStudentScheduleViewController.swift
//  Learniat Teacher
//
//  Created by Deepak MK on 19/03/16.
//  Copyright © 2016 Mindshift. All rights reserved.
//





import Foundation
import UIKit

let oneHourDiff :CGFloat = 90.0

let halfHourMultipleRatio : CGFloat = (oneHourDiff / 2)/(30)


class SSStudentScheduleViewController: UIViewController,SSStudentDataSourceDelegate,ScheduleScreenTileDelegate,SSStudentMessageHandlerDelegate
{
    var mTeacherImageView: UIImageView!
   
    var mTopbarImageView: UIImageView!
    
    var mTeacherName: UILabel!
    
    var mRefreshButton: UIButton!
    
    
    var mNoSessionLabel: UILabel!
    
    var mNoSessionSubLabel:UILabel!
    
    var mScrollView:UIScrollView!
    
    var sessionDetailsArray:NSMutableArray = NSMutableArray()
    
    var positionsArray:Dictionary<String,CGFloat> = Dictionary()
    
    var mCurrentTimeLine :CurrentTimeLineView!
    
    var timer = NSTimer()
    
    var sessionIdDictonary:Dictionary<String,AnyObject> = Dictionary()
    
    let dateFormatter = NSDateFormatter()
    
    
    var mExtTimelabel: UILabel = UILabel();

    
    var sessionAlertView    :UIAlertController!
    
    var extendTimeSessiondetails : AnyObject!
    
    var activityIndicator  = UIActivityIndicatorView(activityIndicatorStyle:.WhiteLarge)
    
    var delayTime:Float = 0
    
    var liveSessionDetails          : AnyObject!
    
    var sessionUpdatedLive          :Bool = false
    
    
    
     private var foregroundNotification: NSObjectProtocol!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.view.backgroundColor = darkBackgroundColor
        
        
        self.view.setNeedsLayout()
        self.view.layoutIfNeeded()

        
        
        foregroundNotification = NSNotificationCenter.defaultCenter().addObserverForName(UIApplicationWillEnterForegroundNotification, object: nil, queue: NSOperationQueue.mainQueue()) {
            [unowned self] notification in
            
            if self.sessionAlertView != nil
            {
                if self.sessionAlertView.isBeingPresented()
                {
                    self.sessionAlertView.dismissViewControllerAnimated(true, completion: nil)
                }
            }
            
             SSStudentDataSource.sharedDataSource.getScheduleOfTheDay(self)
        }
        
        
        SSStudentMessageHandler.sharedMessageHandler.setdelegate(self)
        
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        mTopbarImageView = UIImageView(frame: CGRectMake(0, 0, self.view.frame.size.width, (self.view.frame.size.height)/12))
        mTopbarImageView.backgroundColor = topbarColor
        self.view.addSubview(mTopbarImageView)
        mTopbarImageView.userInteractionEnabled = true
        
        
        
        
        
        mTeacherImageView = UIImageView(frame: CGRectMake(15, 15, mTopbarImageView.frame.size.height - 20 ,mTopbarImageView.frame.size.height - 20))
        mTeacherImageView.backgroundColor = lightGrayColor
        mTopbarImageView.addSubview(mTeacherImageView)
        mTeacherImageView.layer.masksToBounds = true
        mTeacherImageView.layer.cornerRadius = 2
        
        
        let urlString = NSUserDefaults.standardUserDefaults().objectForKey(k_INI_UserProfileImageURL) as! String
        
        if let checkedUrl = NSURL(string: "\(urlString)/\(SSStudentDataSource.sharedDataSource.currentUserId)_79px.jpg")
        {
            mTeacherImageView.contentMode = .ScaleAspectFit
            mTeacherImageView.downloadImage(checkedUrl, withFolderType: folderType.ProFilePics)
        }
        
        
        
        
        
        mTeacherName = UILabel(frame: CGRectMake(mTeacherImageView.frame.origin.x + mTeacherImageView.frame.size.width + 10, mTeacherImageView.frame.origin.y, 200, 20))
        mTeacherName.font = UIFont(name:helveticaMedium, size: 20)
        mTeacherName.text = SSStudentDataSource.sharedDataSource.currentUserName.capitalizedString
        mTopbarImageView.addSubview(mTeacherName)
        mTeacherName.textColor = UIColor.whiteColor()
        
        
        
        let mTeacher = UILabel(frame: CGRectMake(mTeacherImageView.frame.origin.x + mTeacherImageView.frame.size.width + 10, 40, 200, 20))
        mTeacher.font = UIFont(name:helveticaRegular, size: 16)
        mTeacher.text = "Student"
        mTopbarImageView.addSubview(mTeacher)
        mTeacher.textColor = UIColor.whiteColor()
        
        
        
        
        
        let mTodaysSchedule = UILabel(frame: CGRectMake((mTopbarImageView.frame.size.width - 200)/2, 15, 200, 20))
        mTodaysSchedule.font = UIFont(name:helveticaMedium, size: 20)
        mTodaysSchedule.text = "Today's schedule"
        mTopbarImageView.addSubview(mTodaysSchedule)
        mTodaysSchedule.textColor = UIColor.whiteColor()
        
        
        
        mRefreshButton = UIButton(frame: CGRectMake(mTopbarImageView.frame.size.width - mTopbarImageView.frame.size.height, 0,mTopbarImageView.frame.size.height,mTopbarImageView.frame.size.height ))
        mRefreshButton.setImage(UIImage(named: "refresh.png"), forState: .Normal)
        mTopbarImageView.addSubview(mRefreshButton)
        mRefreshButton.contentEdgeInsets = UIEdgeInsetsMake(10, 10, 10, 10);
        mRefreshButton.addTarget(self, action: #selector(SSStudentScheduleViewController.onRefreshButton(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        mRefreshButton.hidden = false
        
        
        activityIndicator.frame = CGRectMake(mRefreshButton.frame.origin.x - 60,  0,mTopbarImageView.frame.size.height,mTopbarImageView.frame.size.height)
        mTopbarImageView.addSubview(activityIndicator)
        activityIndicator.hidden = true
       
        
        mNoSessionLabel = UILabel(frame: CGRectMake(10, (self.view.frame.size.height - 40)/2, self.view.frame.size.width - 20,40))
        mNoSessionLabel.font = UIFont(name:helveticaMedium, size: 30)
        mNoSessionLabel.text = "You do not have any sessions today!"
        self.view.addSubview(mNoSessionLabel)
        mNoSessionLabel.textColor = UIColor.whiteColor()
        mNoSessionLabel.textAlignment = .Center
        
        
        mNoSessionSubLabel = UILabel(frame: CGRectMake(10, mNoSessionLabel.frame.origin.y + mNoSessionLabel.frame.size.height + 0, self.view.frame.size.width - 20,40))
        mNoSessionSubLabel.font = UIFont(name:helveticaRegular, size: 20)
        mNoSessionSubLabel.text = "Enjoy your day :)"
        self.view.addSubview(mNoSessionSubLabel)
        mNoSessionSubLabel.textColor = UIColor.whiteColor()
        mNoSessionSubLabel.alpha = 0.5
        mNoSessionSubLabel.textAlignment = .Center
        
        
        
        
        mScrollView = UIScrollView(frame: CGRectMake(0,mTopbarImageView.frame.size.height,self.view.frame.size.width,self.view.frame.size.height - mTopbarImageView.frame.size.height))
        mScrollView.backgroundColor = darkBackgroundColor
        self.view.addSubview(mScrollView)
        mScrollView.hidden = true
        
        SSStudentDataSource.sharedDataSource.getScheduleOfTheDay(self)
        activityIndicator.hidden = false
        activityIndicator.startAnimating()
        
        
        
        addNumberOfLinesToScrollView()
        
        
        let currentDate = NSDate()
        mCurrentTimeLine = CurrentTimeLineView(frame: CGRectMake(30, 0 , self.view.frame.size.width-30, 10))
        mScrollView.addSubview(mCurrentTimeLine)
        mCurrentTimeLine.addToCurrentTimewithHours(getPositionWithHour(currentDate.hour(), withMinute: currentDate.minute()))
        mScrollView.contentOffset = CGPointMake(0,mCurrentTimeLine.frame.origin.y-self.view.frame.size.height/3);
        
        
        
         timer = NSTimer.scheduledTimerWithTimeInterval(60, target: self, selector: #selector(SSStudentScheduleViewController.timerAction), userInfo: nil, repeats: true)
        
    }
   
    deinit {
        // make sure to remove the observer when this view controller is dismissed/deallocated
        
        NSNotificationCenter.defaultCenter().removeObserver(foregroundNotification)
    }
    
    func addNumberOfLinesToScrollView()
    {
        var positionY: CGFloat = 30
        var hourValue = 1
        
        
        
        
        for index in 0 ..< 25
        {
            let hourlabel = UILabel(frame: CGRectMake(10, positionY-15,50,30))
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
            hourlabel.textAlignment = NSTextAlignment.Right
            
            
            
            let hourLineView = ScheduleScreenLineView()
            hourLineView.frame = CGRectMake(70, positionY, self.view.frame.size.width-70, 1)
            positionsArray[String("\(index)")] = positionY
            mScrollView.addSubview(hourLineView)
            
            
            
            
            if index != 24
            {
                let halfHourLineView =  DottedLine()
                halfHourLineView.frame = CGRectMake(75, positionY + (oneHourDiff/2), self.view.frame.size.width-80, 2)
                
                mScrollView.addSubview(halfHourLineView)
                halfHourLineView.drawDashedBorderAroundViewWithColor(UIColor(red: 153/255.0, green: 153/255.0, blue: 153/255.0, alpha: 1))
                 positionY = positionY + oneHourDiff
            }
            
           
        }
        
        mScrollView.contentSize = CGSizeMake(0, positionY + oneHourDiff / 2 )
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func onRefreshButton(sender: AnyObject)
    {
        SSStudentDataSource.sharedDataSource.getScheduleOfTheDay(self)
        activityIndicator.hidden = false
        activityIndicator.startAnimating()
    }
    
    func timerAction()
    {
        let currentDate = NSDate()
        
        let currentHour = (currentDate.hour())
        
        
        
        
        mCurrentTimeLine.addToCurrentTimewithHours(getPositionWithHour(currentHour, withMinute: currentDate.minute()))
    }
    
    
    
    // MARK: - Returning Functions
    
    func getPositionWithHour(_hour : Int, withMinute minute:Int) -> CGFloat
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
    
    
    
    func getSizeOfCalendarEvernWithStarthour(startHour: Int, withstartMinute startMinute:Int, withEndHour endHour:Int, withEndMinute endMinute:Int) -> CGFloat
    {
        
        let startPosition = getPositionWithHour(startHour, withMinute: startMinute)
        
        let endposition = getPositionWithHour(endHour, withMinute: endMinute)
        
        
        let sizeOfEvent = endposition - startPosition
        
        
        return sizeOfEvent
    }

    
    
    // MARK: - Teacher datasource Error

    func didgetErrorMessage(message: String, WithServiceName serviceName: String)
    {
         self.view.makeToast(message, duration: 2.0, position: .Bottom)
        
        activityIndicator.hidden = true
        activityIndicator.stopAnimating()
        
    }
    
    // MARK: - Teacher datasource Delegate
    
    func didGetSchedulesWithDetials(details: AnyObject)
    {

        sessionUpdatedLive = false
        
        
        if self.sessionAlertView != nil
        {
            if self.sessionAlertView.isBeingPresented()
            {
                self.sessionAlertView.dismissViewControllerAnimated(true, completion: nil)
            }
        }
        
        
        for index in 0 ..< sessionDetailsArray.count
        {
            let dict = sessionDetailsArray.objectAtIndex(index)
             let sessionid = dict.objectForKey(kSessionId) as! String
            
             if let scheduleTileView  = mScrollView.viewWithTag(Int(sessionid)!) as? ScheduleScreenTile
             {
                scheduleTileView.stopAllTimmers()
                scheduleTileView.removeFromSuperview()
            }
        }
        
        
        sessionDetailsArray.removeAllObjects()
        if let statusString = details.objectForKey("Status") as? String
        {
            if statusString == kSuccessString
            {
                mNoSessionLabel.hidden = true
                mNoSessionSubLabel.hidden = true
                mScrollView.hidden = false
                
                let classCheckingVariable = details.objectForKey(kSessions)!.objectForKey(kSubSession)!
                
                if classCheckingVariable.isKindOfClass(NSMutableArray)
                {
                    sessionDetailsArray = classCheckingVariable as! NSMutableArray
                }
                else
                {
                    sessionDetailsArray.addObject(details.objectForKey(kSessions)!.objectForKey(kSubSession)!)
                    
                }
            }
            else
            {
                mNoSessionLabel.hidden = false
                mNoSessionSubLabel.hidden = false
                mScrollView.hidden = true
            }
        }
        
        
       
        
        
        
        for index in 0 ..< sessionDetailsArray.count
        {
            let dict = sessionDetailsArray.objectAtIndex(index)
            
            let startDate :String = (dict.objectForKey(kStartTime) as! String)
            let endDate = (dict.objectForKey(kEndTime) as! String!)
            let totalSize = getSizeOfCalendarEvernWithStarthour(startDate.hourValue(), withstartMinute: startDate.minuteValue(), withEndHour: endDate.hourValue(), withEndMinute: endDate.minuteValue())
            let StartPositionOfTile = getPositionWithHour(startDate.hourValue(), withMinute: startDate.minuteValue())
            
            
            let scheduleTileView = ScheduleScreenTile(frame: CGRectMake(75, StartPositionOfTile, self.view.frame.size.width-85, totalSize))
            mScrollView.addSubview(scheduleTileView)
            scheduleTileView.setdelegate(self)
            
            
            let sessionid = dict.objectForKey(kSessionId) as! String
           
            sessionIdDictonary[sessionid] = dict
            scheduleTileView.tag = Int(sessionid)!
            scheduleTileView.setCurrentSessionDetails(dict)
            
            let sessionState = dict.objectForKey(kSessionState) as! String
            if sessionState == kLiveString || sessionState == kopenedString || sessionState == kScheduledString
            {
                SSStudentMessageHandler.sharedMessageHandler.createRoomWithRoomName(String(format:"room_%@",(dict.objectForKey(kSessionId) as! String)), withHistory: "0")
            }
            else
            {
                SSStudentMessageHandler.sharedMessageHandler.checkAndRemoveJoinedRoomsArrayWithRoomid(String(format:"room_%@",(dict.objectForKey(kSessionId) as! String)))
            }
            
            
            
            
        }
        
        
        
        let currentDate = NSDate()
        let currentHour = (currentDate.hour())
        mCurrentTimeLine.addToCurrentTimewithHours(getPositionWithHour(currentHour, withMinute: currentDate.minute()))
        UIView.animateWithDuration(0.5, animations: {
            self.mScrollView.contentOffset = CGPointMake(0,self.mCurrentTimeLine.frame.origin.y - self.view.frame.size.height/3);
            self.mScrollView.bringSubviewToFront(self.mCurrentTimeLine)
        })
       
        
        activityIndicator.hidden = true
        activityIndicator.stopAnimating()

        
        
    }
    
    
    
    
    
    
    // MARK: - session checking Functions
    
    
    
    
    
    
    // MARK: - ScheduleScreen tile delegate functions
    
    func delegateRefreshSchedule()
    {
        SSStudentDataSource.sharedDataSource.getScheduleOfTheDay(self)
        activityIndicator.hidden = false
        activityIndicator.startAnimating()
        
    }
    
    
    
    
    // MARK: - Alert functions
    
    
    func delegateScheduleTileTouchedWithState(state: String, withCurrentTileDetails Details: AnyObject) {
        
        
        if let SessionState = Details.objectForKey("SessionState") as? String
        {
            if SessionState == kScheduledString
            {
                 self.view.makeToast("You can not enter to scheduled session" , duration: 0.5, position: .Bottom)
            }
            else  if SessionState == kCanClledString
            {
                self.view.makeToast("This class was cancelled.", duration: 0.5, position: .Bottom)
                
            }
            else  if SessionState == kEndedString
            {
                self.view.makeToast("This class has already ended.", duration: 0.5, position: .Bottom)
            }
            else if SessionState == kLiveString
            {
                let seatController = StudentSeatViewController()
                seatController.setCurrentSessionDetails(Details)
                self.presentViewController(seatController, animated: true, completion: nil)
            }
            else if SessionState == kopenedString
            {
                let seatController = StudentSeatViewController()
                seatController.setCurrentSessionDetails(Details)
                self.presentViewController(seatController, animated: true, completion: nil)
            }
        }

    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
     // MARK: - message handler functions
    
    func smhDidRecieveStreamConnectionsState(state: Bool) {
        
//        self.view.makeToast("Xmpp Stream disconnected.", duration: 0.2, position: .Bottom)
        
        activityIndicator.stopAnimating()
        activityIndicator.hidden = true
    }
    
    func smhDidReciveAuthenticationState(state: Bool, WithName userName: String) {
        
        activityIndicator.stopAnimating()
        activityIndicator.hidden = true
    }
    
    func smhStreamReconnectingWithDelay(delay: Int32)
    {
       self.view.makeToast("Reconnecting in \(delay) seconds", duration: 0.5, position: .Bottom)
        
        activityIndicator.startAnimating()
        activityIndicator.hidden = false
    }
    
    
    func smhDidgetTimeExtendedWithDetails(Details: AnyObject)
    {
        
        delegateRefreshSchedule()
    }
    
    
     // MARK: - Extra functions
    
    func secondsToMinutesSeconds (seconds : Double) -> (Double, Double)
    {
        let (_,  minf) = modf (seconds / 3600)
        let (min, secf) = modf (60 * minf)
        return ( min, 60 * secf)
    }
    
    
    
   
    // MARK: - Change screen Functions
   
    
    func beginClassWithDetails(details:AnyObject)
    {
       
//        let storyboard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
//        let preallotController : SSTeacherClassView = storyboard.instantiateViewControllerWithIdentifier("SSTeacherClassView") as! SSTeacherClassView
//        
//         preallotController.setSessionDetails(details)
//        
//        
//         self.sendTimeExtendMessageWithDetails(details, withMessage: "Class has begun")
//       
//        self.presentViewController(preallotController, animated: true, completion: nil)
    }
    
}