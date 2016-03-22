//
//  TeacherScheduleViewController.swift
//  Learniat Teacher
//
//  Created by Deepak MK on 19/03/16.
//  Copyright © 2016 Mindshift. All rights reserved.
//

import Foundation
import UIKit

let oneHourDiff :CGFloat = 90.0

let halfHourMultipleRatio : CGFloat = (oneHourDiff / 2)/(30)


class TeacherScheduleViewController: UIViewController,SSTeacherDataSourceDelegate,ScheduleScreenTileDelegate,SSTeacherMessagehandlerDelegate,CustomAlertViewDelegate
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
    
    
    var mScheduleDetailView  : ScheduleDetailView!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.view.backgroundColor = whiteBackgroundColor
        
        
        self.view.setNeedsLayout()
        self.view.layoutIfNeeded()

        
        SSTeacherMessageHandler.sharedMessageHandler.setdelegate(self)
        
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        mTopbarImageView = UIImageView(frame: CGRectMake(0, 0, self.view.frame.size.width, (self.view.frame.size.height)/12))
        mTopbarImageView.backgroundColor = topbarColor
        self.view.addSubview(mTopbarImageView)
        mTopbarImageView.userInteractionEnabled = true
        
        
        
        
        
        mTeacherImageView = UIImageView(frame: CGRectMake(10, 15, mTopbarImageView.frame.size.height - 20 ,mTopbarImageView.frame.size.height - 20))
        mTeacherImageView.backgroundColor = lightGrayColor
        mTopbarImageView.addSubview(mTeacherImageView)
        mTeacherImageView.layer.masksToBounds = true
        mTeacherImageView.layer.cornerRadius = 3
        
        
        let urlString = NSUserDefaults.standardUserDefaults().objectForKey(k_INI_UserProfileImageURL) as! String
        
        if let checkedUrl = NSURL(string: "\(urlString)/\(SSTeacherDataSource.sharedDataSource.currentUserId)_79px.jpg")
        {
            mTeacherImageView.contentMode = .ScaleAspectFit
            mTeacherImageView.downloadImage(checkedUrl, withFolderType: folderType.ProFilePics)
        }

        
        
        
        
        mTeacherName = UILabel(frame: CGRectMake(mTeacherImageView.frame.origin.x + mTeacherImageView.frame.size.width + 10, 10, 200, 30))
        mTeacherName.font = UIFont(name:helveticaMedium, size: 20)
        mTeacherName.text = SSTeacherDataSource.sharedDataSource.currentUserName.capitalizedString
        mTopbarImageView.addSubview(mTeacherName)
        mTeacherName.textColor = UIColor.whiteColor()
        
        
        
        let mTeacher = UILabel(frame: CGRectMake(mTeacherImageView.frame.origin.x + mTeacherImageView.frame.size.width + 10, 40, 200, 20))
        mTeacher.font = UIFont(name:helveticaRegular, size: 16)
        mTeacher.text = "Teacher"
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
        mRefreshButton.addTarget(self, action: "onRefreshButton:", forControlEvents: UIControlEvents.TouchUpInside)
        
        
        
        activityIndicator.frame = CGRectMake(mRefreshButton.frame.origin.x - 60,  0,mTopbarImageView.frame.size.height,mTopbarImageView.frame.size.height)
        mTopbarImageView.addSubview(activityIndicator)
        activityIndicator.hidden = true
       
        
        mNoSessionLabel = UILabel(frame: CGRectMake(10, (self.view.frame.size.height - 40)/2, self.view.frame.size.width - 20,40))
        mNoSessionLabel.font = UIFont(name:helveticaMedium, size: 30)
        mNoSessionLabel.text = "You do not have any sessions today!"
        self.view.addSubview(mNoSessionLabel)
        mNoSessionLabel.textColor = UIColor.blackColor()
        mNoSessionLabel.textAlignment = .Center
        
        
        mNoSessionSubLabel = UILabel(frame: CGRectMake(10, mNoSessionLabel.frame.origin.y + mNoSessionLabel.frame.size.height + 0, self.view.frame.size.width - 20,40))
        mNoSessionSubLabel.font = UIFont(name:helveticaRegular, size: 20)
        mNoSessionSubLabel.text = "Enjoy your day :)"
        self.view.addSubview(mNoSessionSubLabel)
        mNoSessionSubLabel.textColor = UIColor.blackColor()
        mNoSessionSubLabel.alpha = 0.5
        mNoSessionSubLabel.textAlignment = .Center
        
        
        
        
        mScrollView = UIScrollView(frame: CGRectMake(0,mTopbarImageView.frame.size.height,self.view.frame.size.width,self.view.frame.size.height - mTopbarImageView.frame.size.height))
        mScrollView.backgroundColor = whiteBackgroundColor
        self.view.addSubview(mScrollView)
        mScrollView.hidden = true
        
        SSTeacherDataSource.sharedDataSource.getScheduleOfTeacher(self)
        activityIndicator.hidden = false
        activityIndicator.startAnimating()
        
        
        
        addNumberOfLinesToScrollView()
        
        
        let currentDate = NSDate()
        mCurrentTimeLine = CurrentTimeLineView(frame: CGRectMake(30, 0 , self.view.frame.size.width-30, 10))
        mScrollView.addSubview(mCurrentTimeLine)
        mCurrentTimeLine.addToCurrentTimewithHours(getPositionWithHour(currentDate.hour(), withMinute: currentDate.minute()))
        mScrollView.contentOffset = CGPointMake(0,mCurrentTimeLine.frame.origin.y-self.view.frame.size.height/3);
        
        
        
         timer = NSTimer.scheduledTimerWithTimeInterval(60, target: self, selector: "timerAction", userInfo: nil, repeats: true)
    }
    
    
    
    func addNumberOfLinesToScrollView()
    {
        var index: Int
        var positionY: CGFloat = 30
        var hourValue = 1
        for index = 0; index <= 24; ++index
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
        SSTeacherDataSource.sharedDataSource.getScheduleOfTeacher(self)
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
    
    func getPositionWithHour(var hour : Int, withMinute minute:Int) -> CGFloat
    {
        //        hour = hour
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

        
        if mScheduleDetailView != nil
        {
            mScheduleDetailView.onDoneButton()
        }
        
        for var index = 0; index < sessionDetailsArray.count; index++
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
        
        
       
        
        
        
        for var index = 0; index < sessionDetailsArray.count; index++
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
            if sessionState == kLive || sessionState == kopened || sessionState == kScheduled
            {
                SSTeacherMessageHandler.sharedMessageHandler.createRoomWithRoomName(String(format:"room_%@",(dict.objectForKey(kSessionId) as! String)), withHistory: "0")
            }
            else
            {
                SSTeacherMessageHandler.sharedMessageHandler.checkAndRemoveJoinedRoomsArrayWithRoomid(String(format:"room_%@",(dict.objectForKey(kSessionId) as! String)))
            }
            
            
            
            
        }
        
        
        
        let currentDate = NSDate()
        let currentHour = (currentDate.hour())
        mCurrentTimeLine.addToCurrentTimewithHours(getPositionWithHour(currentHour, withMinute: currentDate.minute()))
        UIView.animateWithDuration(0.5, animations: {
            self.mScrollView.contentOffset = CGPointMake(0,self.mCurrentTimeLine.frame.origin.y - self.view.frame.size.height/3);
        })
       
        
        if sessionDetailsArray.count > 0
        {
            SSTeacherDataSource.sharedDataSource.getMyCurrentSessionOfTeacher(self)
        }
        else
        {
            activityIndicator.hidden = true
            activityIndicator.stopAnimating()
        }
        
        
    }
    
    
    func didGetMycurrentSessionWithDetials(details: AnyObject)
    {
        
        if let currentSessionId = details.objectForKey("SessionId") as? String
        {
            
            let currentDate = NSDate()
            let isgreatervalue :Bool ;
            
            isgreatervalue = currentDate.isGreaterThanDate(dateFormatter.dateFromString(details.objectForKey("StartTime") as! String)!)
            
            let  isEqualValue = currentDate.isEqualToDate(dateFormatter.dateFromString(details.objectForKey("StartTime") as! String)!)
            
            if isgreatervalue == true || isEqualValue == true
            {
                updateOverDueSessionWithSessionId(currentSessionId)
            }
            else
            {
                updateNextSessionWithSessionId(currentSessionId)
            }
            
        }
        else if let nextSessionId = details.objectForKey("NextSessionId") as? String
        {
            updateNextSessionWithSessionId(nextSessionId)
        }
        
        activityIndicator.hidden = true
        activityIndicator.stopAnimating()
        
    }
    
    func didGetSessionSummaryDetials(details: AnyObject)
    {
        
        mScheduleDetailView.setcurrentViewDetails(details)
    }
    
    func didGetSessionUpdatedWithDetials(details: AnyObject)
    {
        
        print(details)
        
        SSTeacherDataSource.sharedDataSource.getScheduleOfTeacher(self)
        activityIndicator.hidden = false
        activityIndicator.startAnimating()
    }
    
    func didGetSessionExtendedDetials(details: AnyObject) {
        print(details)
        
        
        SSTeacherDataSource.sharedDataSource.getScheduleOfTeacher(self)
        activityIndicator.hidden = false
        activityIndicator.startAnimating()
        
        if let currentSessionDetails = extendTimeSessiondetails
        {
            
            let timeDelayString = "\(currentSessionDetails.objectForKey("ClassName") as! String) class time Extended for \(Int(delayTime)) Minutes"
            
            self.sendTimeExtendMessageWithDetails(currentSessionDetails, withMessage: timeDelayString)
        }

        
        
    }
    
    // MARK: - session checking Functions
    
    
    func updateNextSessionWithSessionId(sessionId:String)
    {
        if let currentSessionDetails = sessionIdDictonary[sessionId]
        {
            
            
            
            if let SessionState = currentSessionDetails.objectForKey("SessionState") as? String
            {
                
                if SessionState == kScheduled || SessionState == kopened
                {
                    if let scheduleTileView  = mScrollView.viewWithTag(Int(sessionId)!) as? ScheduleScreenTile
                    {
                        scheduleTileView.nextSessionUpdatingWithdetails(currentSessionDetails)
                    }
                    
                    
                    
                    
                    let currentDate = NSDate()
                    
                    let differenceMinutes  = currentDate.minutesAndSecondsDiffernceBetweenDates(currentDate, endDate: dateFormatter.dateFromString(currentSessionDetails.objectForKey("StartTime") as! String)!)
                    
                    if differenceMinutes.second < 120
                    {
                        
                        
                        showScheduleScreenAlertWithDetails(currentSessionDetails, withMessage:"Your class is about to start in \n \(differenceMinutes.minutes) minutes \(Int(secondsToMinutesSeconds(Double(differenceMinutes.second)).1)) seconds")
                    }
                    
                    
                }
            }
            
        }
        
    }
    
    func updateOverDueSessionWithSessionId(sessionId:String)
    {
        if let currentSessionDetails = sessionIdDictonary[sessionId]
        {
            
            if let SessionState = currentSessionDetails.objectForKey("SessionState") as? String
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
    
    
    func delegateScheduleTileTouchedWithState(state: String, withCurrentTileDetails Details: AnyObject)
    {
        
        
        
        
        if let sessionId = Details.objectForKey("SessionId") as? String
        {
            SSTeacherDataSource.sharedDataSource.getScheduleSummaryWithSessionId(sessionId, WithDelegate: self)
            
            
            if mScheduleDetailView == nil
            {
                mScheduleDetailView = ScheduleDetailView(frame: CGRectMake(self.view.frame.size.width - (self.view.frame.size.width / 2.2), mScrollView.frame.origin.y ,self.view.frame.size.width / 2.2 , mScrollView.frame.size.height))
                self.view.addSubview(mScheduleDetailView)
                mScheduleDetailView.addAllSubView()
                self.view.bringSubviewToFront(mScheduleDetailView)
                mScheduleDetailView.backgroundColor = UIColor.whiteColor()
            }
            
            mScheduleDetailView.hidden = false
             mScheduleDetailView.setClassname((Details.objectForKey("ClassName") as! String))
            
            
        }
        
    }
    
    func delegateRefreshSchedule()
    {
        SSTeacherDataSource.sharedDataSource.getScheduleOfTeacher(self)
        activityIndicator.hidden = false
        activityIndicator.startAnimating()
        
    }
    
    
    
    
    // MARK: - Alert functions
    
    func showScheduleScreenAlertWithDetails(currentSessionDetails:AnyObject, withMessage message:String)
    {
        
        
        if let StudentsRegistered = currentSessionDetails.objectForKey("StudentsRegistered") as? String
        {
            if let PreAllocatedSeats = currentSessionDetails.objectForKey("PreAllocatedSeats") as? String
            {
                if let OccupiedSeats = currentSessionDetails.objectForKey("OccupiedSeats") as? String
                {
                    
                    if Int(StudentsRegistered) > Int(PreAllocatedSeats)! + Int(OccupiedSeats)!
                    {
                        
                       showAllocateSeatAlertWithSessionId(currentSessionDetails.objectForKey("SessionId") as! String , withMessage:message )
                    }
                    else if let SessionState = currentSessionDetails.objectForKey("SessionState") as? String
                    {
                        if SessionState == kScheduled
                        {
                            showOpenClassAlertWithSessionId(currentSessionDetails.objectForKey("SessionId") as! String , withMessage: message)
                        }
                        if SessionState == kopened
                        {
                            showBeginClassAlertWithSessionId(currentSessionDetails.objectForKey("SessionId") as! String , withMessage: message)
                        }
                    }
                }
            }
        }
    }
    
    
    func showAllocateSeatAlertWithSessionId(SessionId:String, withMessage message:String)
    {
       
        
        
        
        if sessionAlertView != nil
        {
            if sessionAlertView.isBeingPresented()
            {
                sessionAlertView.dismissViewControllerAnimated(true, completion: nil)
            }
        }
        
        
        sessionAlertView = UIAlertController(title: "AllocateSeat", message: message, preferredStyle: UIAlertControllerStyle.Alert)
        sessionAlertView.addAction(UIAlertAction(title: "Allocate seats", style: .Default, handler: { action in
            
        }))
        
        sessionAlertView.addAction(UIAlertAction(title: "Cancel Class", style: .Default, handler: { action in
            
            SSTeacherDataSource.sharedDataSource.updateSessionStateWithSessionId(SessionId, WithStatusvalue: kCanClled, WithDelegate: self)
            
           
            
            
        }))
        
        sessionAlertView.addAction(UIAlertAction(title: "Extendtime", style: .Default, handler: { action in
            
            if let currentSessionDetails = self.sessionIdDictonary[SessionId]
            {
                self.showExtendTimeAlertForSessionDetaisl(currentSessionDetails)
            }
            
        }))
        
        sessionAlertView.addAction(UIAlertAction(title: "Dismiss", style: .Cancel, handler: { action in
            
            
                if let scheduleTileView  = self.mScrollView.viewWithTag(Int(SessionId)!) as? ScheduleScreenTile
                {
                    scheduleTileView.alertDismissed()
                }
            
        }))
        
        self.presentViewController(sessionAlertView, animated: true, completion: nil)
    }
    
    
    
    
    func showOpenClassAlertWithSessionId(SessionId:String, withMessage message:String)
    {
        if sessionAlertView != nil
        {
            if sessionAlertView.isBeingPresented()
            {
                sessionAlertView.dismissViewControllerAnimated(true, completion: nil)
            }
        }

        
        sessionAlertView = UIAlertController(title: "OpenClass", message: message, preferredStyle: UIAlertControllerStyle.Alert)
        sessionAlertView.addAction(UIAlertAction(title: "Open Class", style: .Default, handler: { action in
             SSTeacherDataSource.sharedDataSource.updateSessionStateWithSessionId(SessionId, WithStatusvalue: kopened, WithDelegate: self)
            
            if let currentSessionDetails = self.sessionIdDictonary[SessionId]
            {
                self.sendTimeExtendMessageWithDetails(currentSessionDetails, withMessage: "Class has been opened")
            }

            
        }))
        
        sessionAlertView.addAction(UIAlertAction(title: "Cancel Class", style: .Default, handler: { action in
            
             SSTeacherDataSource.sharedDataSource.updateSessionStateWithSessionId(SessionId, WithStatusvalue: kCanClled, WithDelegate: self)
            
        }))
        
        sessionAlertView.addAction(UIAlertAction(title: "Extendtime", style: .Default, handler: { action in
            
            if let currentSessionDetails = self.sessionIdDictonary[SessionId]
            {
                self.showExtendTimeAlertForSessionDetaisl(currentSessionDetails)
            }
            
            
            
        }))
        
        sessionAlertView.addAction(UIAlertAction(title: "Dismiss", style: .Cancel, handler: { action in
            
            
            if let scheduleTileView  = self.mScrollView.viewWithTag(Int(SessionId)!) as? ScheduleScreenTile
            {
                scheduleTileView.alertDismissed()
            }

            
        }))
        
        self.presentViewController(sessionAlertView, animated: true, completion: nil)
    }
    
    func showBeginClassAlertWithSessionId(SessionId:String, withMessage message:String)
    {
        if sessionAlertView != nil
        {
            if sessionAlertView.isBeingPresented()
            {
                sessionAlertView.dismissViewControllerAnimated(true, completion: nil)
            }
        }

        
        sessionAlertView = UIAlertController(title: "BeginClass", message: message, preferredStyle: UIAlertControllerStyle.Alert)
        sessionAlertView.addAction(UIAlertAction(title: "Begin Class", style: .Default, handler: { action in
            
             SSTeacherDataSource.sharedDataSource.updateSessionStateWithSessionId(SessionId, WithStatusvalue: kLive, WithDelegate: self)
            
            if let currentSessionDetails = self.sessionIdDictonary[SessionId]
            {
                self.sendTimeExtendMessageWithDetails(currentSessionDetails, withMessage: "Class has begun")
            }
            
        }))
        
        sessionAlertView.addAction(UIAlertAction(title: "Cancel Class", style: .Default, handler: { action in
            
             SSTeacherDataSource.sharedDataSource.updateSessionStateWithSessionId(SessionId, WithStatusvalue: kCanClled, WithDelegate: self)
            
        }))
        
        sessionAlertView.addAction(UIAlertAction(title: "Extendtime", style: .Default, handler: { action in
            
            if let currentSessionDetails = self.sessionIdDictonary[SessionId]
            {
                self.showExtendTimeAlertForSessionDetaisl(currentSessionDetails)
            }
            
        }))
        
        sessionAlertView.addAction(UIAlertAction(title: "Dismiss", style: .Cancel, handler: { action in
            
            if let scheduleTileView  = self.mScrollView.viewWithTag(Int(SessionId)!) as? ScheduleScreenTile
            {
                scheduleTileView.alertDismissed()
            }

        }))
        
        self.presentViewController(sessionAlertView, animated: true, completion: nil)
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
    
    
    
     // MARK: - Extra functions
    
    func secondsToMinutesSeconds (seconds : Double) -> (Double, Double)
    {
        let (_,  minf) = modf (seconds / 3600)
        let (min, secf) = modf (60 * minf)
        return ( min, 60 * secf)
    }
    
    
    func sendTimeExtendMessageWithDetails(currentSessionDetails:AnyObject, withMessage message:String)
    {
        
        SSTeacherMessageHandler.sharedMessageHandler.sendExtendedTimetoRoom((currentSessionDetails.objectForKey("SessionId") as? String)!, withClassName: (currentSessionDetails.objectForKey("ClassName") as? String)! , withStartTime: (currentSessionDetails.objectForKey("StartTime") as? String)!, withDelayTime:message)
    }
    
    
    
    // MARK: - Extend Time Alert view functions
    
    func showExtendTimeAlertForSessionDetaisl(details:AnyObject)
    {
        
        extendTimeSessiondetails = details
        
        let alertView = CustomAlertView(frame: CGRectMake(0, 0, 1024, 768))
        
        
        alertView.containerView = createDemoView()
        
        alertView.buttonTitles = NSMutableArray(objects: "Cancel", "Done") as [AnyObject]
        
        alertView.delegate = self
        
         delayTime = 1;
        
        
        alertView.useMotionEffects = true;
        
        let mySlider = UISlider(frame:CGRectMake(15, 90, 320, 20))
        
        let currentDate = NSDate()
         let differenceMinutes  = currentDate.minutesDiffernceBetweenDates(dateFormatter.dateFromString(extendTimeSessiondetails.objectForKey("StartTime") as! String)!, endDate: dateFormatter.dateFromString(extendTimeSessiondetails.objectForKey("EndTime") as! String)!)
        
        if differenceMinutes > 20
        {
            mySlider.maximumValue = 20;
        }
        else
        {
            
            mySlider.maximumValue = Float(differenceMinutes)
        }
        
        mySlider.minimumValue=1.00;

        mySlider.addTarget(self, action: "sliderHandler:", forControlEvents: UIControlEvents.ValueChanged)
        mySlider.tintColor = UIColor.greenColor();
        
        mExtTimelabel=UILabel(frame: CGRectMake(50, 20, 250, 40));
        mExtTimelabel.text = "Extend time with \(Int(delayTime)) min";
        mExtTimelabel.textColor = UIColor.blackColor();
        mExtTimelabel.textAlignment = .Center;
        alertView.containerView.addSubview(mExtTimelabel);
        alertView.containerView.addSubview(mySlider);
        alertView.show();

        
        
        
    }
    
    func createDemoView()   -> UIView
    {
        let customView = UIView(frame: CGRectMake(0, 0, 350, 150))
        customView.userInteractionEnabled = true
        return customView
    }
    
    func sliderHandler(sender:UISlider)
    {
        delayTime = sender.value;
        mExtTimelabel.text = "Extend time with \(Int(delayTime)) min"
    }
    
    func customdialogButtonTouchUpInside(alertView: AnyObject!, clickedButtonAtIndex buttonIndex: Int) {
        
        
        
        alertView.close()
        
        if buttonIndex == 1
        {
             let currentDate = NSDate()
            print(extendTimeSessiondetails)
            
            let differenceMinutes  = currentDate.minutesDiffernceBetweenDates(dateFormatter.dateFromString(extendTimeSessiondetails.objectForKey("StartTime") as! String)!, endDate: currentDate)
            
            delayTime = delayTime + Float(differenceMinutes)
            
            if let currentSessionDetails = extendTimeSessiondetails
            {
                 SSTeacherDataSource.sharedDataSource.extendSessionWithSessionId(currentSessionDetails.objectForKey("SessionId") as! String, withTime: "\(Int(delayTime))", WithDelegate: self)
            }
           
            
        }
        else
        {
            
            if let currentSessionDetails = extendTimeSessiondetails
            {
                if let scheduleTileView  = self.mScrollView.viewWithTag(Int(currentSessionDetails.objectForKey("SessionId") as! String)!) as? ScheduleScreenTile
                {
                    scheduleTileView.alertDismissed()
                }
            }
            
        }
        
    }
    
}