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
    
    
    var mExtTimelabel: UILabel = UILabel();

    
    var sessionAlertView    :UIAlertController!
    
    var extendTimeSessiondetails : AnyObject!
    
    var activityIndicator  = UIActivityIndicatorView(activityIndicatorStyle:.whiteLarge)
    
    var delayTime:Float = 0
    
    var liveSessionDetails          : AnyObject!
    
    var sessionUpdatedLive          :Bool = false
    
    var mAppVersionNumber               = UILabel();
    
     fileprivate var foregroundNotification: NSObjectProtocol!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.view.backgroundColor = darkBackgroundColor
        
        
        self.view.setNeedsLayout()
        self.view.layoutIfNeeded()

        
        
        foregroundNotification = NotificationCenter.default.addObserver(forName: NSNotification.Name.UIApplicationWillEnterForeground, object: nil, queue: OperationQueue.main) {
            [unowned self] notification in
            
            if self.sessionAlertView != nil
            {
                if self.sessionAlertView.isBeingPresented
                {
                    self.sessionAlertView.dismiss(animated: true, completion: nil)
                }
            }
            
             SSStudentDataSource.sharedDataSource.getScheduleOfTheDay(self)
        }
        
        
        SSStudentMessageHandler.sharedMessageHandler.setdelegate(self)
        
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        mTopbarImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: (self.view.frame.size.height)/12))
        mTopbarImageView.backgroundColor = topbarColor
        self.view.addSubview(mTopbarImageView)
        mTopbarImageView.isUserInteractionEnabled = true
        
        
        
        
        
        mTeacherImageView = CustomProgressImageView(frame: CGRect(x: 15, y: 15, width: mTopbarImageView.frame.size.height - 20 ,height: mTopbarImageView.frame.size.height - 20))
        mTeacherImageView.backgroundColor = lightGrayColor
        mTopbarImageView.addSubview(mTeacherImageView)
        mTeacherImageView.layer.masksToBounds = true
        mTeacherImageView.layer.cornerRadius = 2
        
        
        let urlString = UserDefaults.standard.object(forKey: k_INI_UserProfileImageURL) as! String
        
        
        let userID = urlString.appending("/").appending(SSStudentDataSource.sharedDataSource.currentUserId)

        
        if let checkedUrl = URL(string: "\(userID)_79px.jpg")
        {
            mTeacherImageView.contentMode = .scaleAspectFit
            mTeacherImageView.downloadImage(checkedUrl, withFolderType: folderType.proFilePics)
        }
        
        
        mTeacherImageButton.frame = CGRect(x: 0, y: 0, width: mTopbarImageView.frame.size.height , height: mTopbarImageView.frame.size.height)
        mTopbarImageView.addSubview(mTeacherImageButton)
        mTeacherImageButton.addTarget(self, action: #selector(SSStudentScheduleViewController.onTeacherImage), for: UIControlEvents.touchUpInside)
        
        
        
        
        mTeacherName = UILabel(frame: CGRect(x: mTeacherImageView.frame.origin.x + mTeacherImageView.frame.size.width + 10, y: mTeacherImageView.frame.origin.y, width: 200, height: 20))
        mTeacherName.font = UIFont(name:helveticaMedium, size: 20)
        mTeacherName.text = SSStudentDataSource.sharedDataSource.currentUserName.capitalized
        mTopbarImageView.addSubview(mTeacherName)
        mTeacherName.textColor = UIColor.white
        
        
        
        let mTeacher = UILabel(frame: CGRect(x: mTeacherImageView.frame.origin.x + mTeacherImageView.frame.size.width + 10, y: 40, width: 200, height: 20))
        mTeacher.font = UIFont(name:helveticaRegular, size: 16)
        mTeacher.text = "Student"
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
        mRefreshButton.addTarget(self, action: #selector(SSStudentScheduleViewController.onRefreshButton(_:)), for: UIControlEvents.touchUpInside)
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
        mNoSessionLabel.text = "You do not have any sessions today!"
        self.view.addSubview(mNoSessionLabel)
        mNoSessionLabel.textColor = UIColor.white
        mNoSessionLabel.textAlignment = .center
        
        
        mNoSessionSubLabel = UILabel(frame: CGRect(x: 10, y: mNoSessionLabel.frame.origin.y + mNoSessionLabel.frame.size.height + 0, width: self.view.frame.size.width - 20,height: 40))
        mNoSessionSubLabel.font = UIFont(name:helveticaRegular, size: 20)
        mNoSessionSubLabel.text = "Enjoy your day :)"
        self.view.addSubview(mNoSessionSubLabel)
        mNoSessionSubLabel.textColor = UIColor.white
        mNoSessionSubLabel.alpha = 0.5
        mNoSessionSubLabel.textAlignment = .center
        
        
        
        
        mScrollView = UIScrollView(frame: CGRect(x: 0,y: mTopbarImageView.frame.size.height,width: self.view.frame.size.width,height: self.view.frame.size.height - mTopbarImageView.frame.size.height))
        mScrollView.backgroundColor = darkBackgroundColor
        self.view.addSubview(mScrollView)
        mScrollView.isHidden = true
        
        SSStudentDataSource.sharedDataSource.getScheduleOfTheDay(self)
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
        
        
        
        addNumberOfLinesToScrollView()
        
        
        let currentDate = Date()
        mCurrentTimeLine = CurrentTimeLineView(frame: CGRect(x: 30, y: 0 , width: self.view.frame.size.width-30, height: 10))
        mScrollView.addSubview(mCurrentTimeLine)
        mCurrentTimeLine.addToCurrentTimewithHours(getPositionWithHour(currentDate.hour(), withMinute: currentDate.minute()))
        mScrollView.contentOffset = CGPoint(x: 0,y: mCurrentTimeLine.frame.origin.y-self.view.frame.size.height/3);
        
        
        
         timer = Timer.scheduledTimer(timeInterval: 60, target: self, selector: #selector(SSStudentScheduleViewController.timerAction), userInfo: nil, repeats: true)
        
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
        SSStudentDataSource.sharedDataSource.getScheduleOfTheDay(self)
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
    }
    
    func timerAction()
    {
        let currentDate = Date()
        
        let currentHour = (currentDate.hour())
        
        
        
        
        mCurrentTimeLine.addToCurrentTimewithHours(getPositionWithHour(currentHour, withMinute: currentDate.minute()))
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
         self.view.makeToast(message, duration: 2.0, position: .bottom)
        
        activityIndicator.isHidden = true
        activityIndicator.stopAnimating()
        
    }
    
    // MARK: - Teacher datasource Delegate
    
    func didGetSchedulesWithDetials(_ details: AnyObject)
    {

        sessionUpdatedLive = false
        print(details)
        
        if self.sessionAlertView != nil
        {
            if self.sessionAlertView.isBeingPresented
            {
                self.sessionAlertView.dismiss(animated: true, completion: nil)
            }
        }
        
        
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
            
            
            let scheduleTileView = ScheduleScreenTile(frame: CGRect(x: 75, y: StartPositionOfTile, width: self.view.frame.size.width-85, height: totalSize))
            mScrollView.addSubview(scheduleTileView)
            scheduleTileView.setdelegate(self)
            
            
            let sessionid = (dict as AnyObject).object(forKey: kSessionId) as! String
           
            sessionIdDictonary[sessionid] = dict as AnyObject?
            scheduleTileView.tag = Int(sessionid)!
            scheduleTileView.setCurrentSessionDetails(dict as AnyObject)
            
            let sessionState = (dict as AnyObject).object(forKey: kSessionState) as! String
            if sessionState == kLiveString || sessionState == kopenedString || sessionState == kScheduledString
            {
                SSStudentMessageHandler.sharedMessageHandler.createRoomWithRoomName(String(format:"room_%@",((dict as AnyObject).object(forKey: kSessionId) as! String)), withHistory: "0")
            }
            else
            {
                SSStudentMessageHandler.sharedMessageHandler.checkAndRemoveJoinedRoomsArrayWithRoomid(String(format:"room_%@",((dict as AnyObject).object(forKey: kSessionId) as! String)))
            }
            
            
            
            
        }
        
        
        
        let currentDate = Date()
        let currentHour = (currentDate.hour())
        mCurrentTimeLine.addToCurrentTimewithHours(getPositionWithHour(currentHour, withMinute: currentDate.minute()))
        UIView.animate(withDuration: 0.5, animations: {
            self.mScrollView.contentOffset = CGPoint(x: 0,y: self.mCurrentTimeLine.frame.origin.y - self.view.frame.size.height/3);
            self.mScrollView.bringSubview(toFront: self.mCurrentTimeLine)
        })
       
        
        activityIndicator.isHidden = true
        activityIndicator.stopAnimating()

        
        
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
    
    
    
    // MARK: - session checking Functions
    
    
    
    
    
    
    // MARK: - ScheduleScreen tile delegate functions
    
    func delegateRefreshSchedule()
    {
        SSStudentDataSource.sharedDataSource.getScheduleOfTheDay(self)
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
        
    }
    
    
    
    
    // MARK: - Alert functions
    
    
    func delegateScheduleTileTouchedWithState(_ state: String, withCurrentTileDetails Details: AnyObject) {
        
        
        if let SessionState = Details.object(forKey: "SessionState") as? String
        {
            if SessionState == kScheduledString
            {
                 self.view.makeToast("You can not enter to scheduled session" , duration: 0.5, position: .bottom)
                onRefreshButton(UIButton())
                
            }
            else  if SessionState == kCanClledString
            {
                self.view.makeToast("This class was cancelled.", duration: 0.5, position: .bottom)
                onRefreshButton(UIButton())
                
            }
            else  if SessionState == kEndedString
            {
                self.view.makeToast("This class has already ended.", duration: 0.5, position: .bottom)
                onRefreshButton(UIButton())
            }
            else if SessionState == kLiveString
            {
                let seatController = StudentSeatViewController()
                seatController.setCurrentSessionDetails(Details)
                self.present(seatController, animated: true, completion: nil)
            }
            else if SessionState == kopenedString
            {
                let seatController = StudentSeatViewController()
                seatController.setCurrentSessionDetails(Details)
                self.present(seatController, animated: true, completion: nil)
            }
        }

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
       self.view.makeToast("Reconnecting in \(delay) seconds", duration: 0.5, position: .bottom)
        
        activityIndicator.startAnimating()
        activityIndicator.isHidden = false
        AppDelegate.sharedDataSource.showReconnecting()
        
    }
    
    
    func smhDidgetTimeExtendedWithDetails(_ Details: AnyObject)
    {
        
        delegateRefreshSchedule()
    }
    
    func smhDidGetSessionEndMessageWithDetails(_ details: AnyObject)
    {
        delegateRefreshSchedule()
        
    }
    
    
     // MARK: - Extra functions
    
    func secondsToMinutesSeconds (_ seconds : Double) -> (Double, Double)
    {
        let (_,  minf) = modf (seconds / 3600)
        let (min, secf) = modf (60 * minf)
        return ( min, 60 * secf)
    }
    
    
    
   
    // MARK: - Change screen Functions
   
    
    func beginClassWithDetails(_ details:AnyObject)
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
    
    func Settings_performLogout()
    {
        
        SSStudentDataSource.sharedDataSource.updateStudentStatus(UserState.SignedOut.rawValue, ofSession: SSStudentDataSource.sharedDataSource.currentLiveSessionId, withDelegate: self)
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
        
    }
    
    func didGetUpdatedUserStateWithDetails(_ details: AnyObject)
    {
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
                    
                    
                    SSStudentMessageHandler.sharedMessageHandler.goOffline()
                    performSegue(withIdentifier: "ScheduleToLogin", sender: nil)
                    
                    activityIndicator.isHidden = true
                    activityIndicator.stopAnimating()
                    
                }
            }
        }
        
    }
    
    func Settings_XmppReconnectButtonClicked()
    {
        SSStudentMessageHandler.sharedMessageHandler.performReconnet()
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
    }
    
    
}
