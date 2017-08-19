//
//  TimeTableViewController.swift
//  LearniatStudent
//
//  Created by Deepak on 8/7/17.
//  Copyright © 2017 Mindshift. All rights reserved.
//

import Foundation
class TimeTableViewController: UIViewController {
    
    var mViewModel = TimeTableViewModel()
    var mTeacherImageView: CustomProgressImageView!
    var mTopbarImageView: UIImageView!
    var mTeacherName: UILabel!
    var mRefreshButton: UIButton!
    var mTeacherImageButton = UIButton()
    var mNoSessionLabel: UILabel!
    var mNoSessionSubLabel:UILabel!
    var mScrollView:UIScrollView!
    var mCurrentTimeLine :CurrentTimeLineView!
    var mAppVersionNumber = UILabel();
    var activityIndicator  = UIActivityIndicatorView(activityIndicatorStyle:.whiteLarge)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.enableRequiredDelegates()
        self.view.backgroundColor = darkBackgroundColor
        self.observeSignals()
        self.addUIContentsToView()
        self.loadScheduleScreen()
    }
}

// MARK: - Buttons functions
extension TimeTableViewController {
    
    /// This func will be used to do soft refresh, that means app will fire only refresh app API
    ///
    /// - Parameter sender: sender
    func softRefresh(_ sender: AnyObject) {
        self.loadScheduleScreen()
    }
    
    /// This func will be used to do hard refresh, that means app will fire only GetMytodays session API
    ///
    /// - Parameter sender: sender
    func hardRefresh(_ sender: AnyObject) {
        mViewModel.loadSchedulesFromServer()
    }
    
    /// This function wil be called when user taps on teacher image
    func onTeacherImage() {
        let questionInfoController = SSSettingsViewController()
        questionInfoController.setDelegate(self)
        questionInfoController.scheduleScrrenTeacherImagePressed();
        let classViewPopOverController = UIPopoverController(contentViewController: questionInfoController)
        classViewPopOverController.contentSize = CGSize(width: 310, height: 145);
        questionInfoController.setPopOver(classViewPopOverController)
        classViewPopOverController.present(from: CGRect(
            x:mTeacherImageButton.frame.origin.x ,
            y:mTeacherImageButton.frame.origin.y + mTeacherImageButton.frame.size.height,
            width: 1,
            height: 1), in: self.view, permittedArrowDirections: .up, animated: true)
    }
}

// MARK: - ViewModel functions and view Delegate functions
extension TimeTableViewController {
    
    /// This func will be used to observer the signals from differnt classes
    fileprivate func observeSignals() {
        SSStudentDataSource.sharedDataSource.TimeTableSaveSignal.subscribe(on: self) { (isSuccess) in
            self.addTilesForScheduleScreen(timeTables: self.mViewModel.LoadSchedulesFromLocalServer())
        }
    }
    
    /// This func is used to enable all the delegates that are required for this class
    fileprivate func enableRequiredDelegates() {
        SSStudentMessageHandler.sharedMessageHandler.setdelegate(self)
    }
    
    /// This func will get the schedules from the server
    fileprivate func getSchedulesFromServer() {
        mViewModel.loadSchedulesFromServer()
    }
    
    /// This refresh the schedule screen
    fileprivate func loadScheduleScreen() {
        if mViewModel.LoadSchedulesFromLocalServer().count <= 0  {
            mViewModel.loadSchedulesFromServer()
        } else {
            mViewModel.refreshSchedules()
        }
    }
    
    func delegateScheduleTileTouchedWithSessionDetails(_ details: NSMutableDictionary, message:String) {
        if details != nil {
            let seatController = StudentSeatViewController()
            seatController.setCurrentSessionDetails(details)
            self.present(seatController, animated: true, completion: nil)
        }
    }
}

// MARK: - Message delegate functions
extension TimeTableViewController:SSStudentMessageHandlerDelegate {
   
    /// This func will be called when stream state is changed
    ///
    /// - Parameter state: Changed state
    func smhDidRecieveStreamConnectionsState(_ state: Bool) {
        activityIndicator.stopAnimating()
        activityIndicator.isHidden = true
    }
    
    /// This func will be called when Authentication of user got changed
    ///
    /// - Parameters:
    ///   - state: Changed state
    ///   - userName: changed user name
    func smhDidReciveAuthenticationState(_ state: Bool, WithName userName: String) {
        activityIndicator.stopAnimating()
        activityIndicator.isHidden = true
        AppDelegate.sharedDataSource.hideReconnecting()
    }
    
    /// This func will be called when stream is trying to reconnect
    ///
    /// - Parameter delay: delay details
    func smhStreamReconnectingWithDelay(_ delay: Int32) {
        self.view.makeToast("Reconnecting in \(delay) seconds", duration: 0.5, position: .bottom)
        activityIndicator.startAnimating()
        activityIndicator.isHidden = false
        AppDelegate.sharedDataSource.showReconnecting()
    }
    
    /// This func will be called when session state changed
    ///
    /// - Parameter Details: Details of the message
    func smhDidgetTimeExtendedWithDetails(_ Details: AnyObject){
        loadScheduleScreen()
    }
    
    /// This func will be called when user got end session message from teacher
    ///
    /// - Parameter details: Details of the message
    func smhDidGetSessionEndMessageWithDetails(_ details: AnyObject) {
        loadScheduleScreen()
        
    }
}

// MARK: - Calculation functions for view
extension TimeTableViewController {
    
    /// This func will add all the UI contents required for this viewController
    fileprivate func addUIContentsToView() {
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
        if let checkedUrl = URL(string: "\(userID)_79px.jpg") {
            mTeacherImageView.contentMode = .scaleAspectFit
            mTeacherImageView.downloadImage(checkedUrl, withFolderType: folderType.proFilePics)
        }
        
        mTeacherImageButton.frame = CGRect(x: 0, y: 0, width: mTopbarImageView.frame.size.height , height: mTopbarImageView.frame.size.height)
        mTopbarImageView.addSubview(mTeacherImageButton)
        mTeacherImageButton.addTarget(self, action: #selector(TimeTableViewController.onTeacherImage), for: UIControlEvents.touchUpInside)
        
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
        mRefreshButton.isHidden = false
        let tapGesture = UITapGestureRecognizer(target: self, action:#selector(TimeTableViewController.softRefresh(_:)))
        let twoTapGesture = UITapGestureRecognizer(target: self, action: #selector(TimeTableViewController.hardRefresh(_:)))
        tapGesture.numberOfTapsRequired = 1
        twoTapGesture.numberOfTapsRequired = 2
        mRefreshButton.addGestureRecognizer(tapGesture)
        mRefreshButton.addGestureRecognizer(twoTapGesture)
        
        mAppVersionNumber = UILabel(frame: CGRect(x: mRefreshButton.frame.origin.x - (mRefreshButton.frame.size.width + mRefreshButton.frame.size.width + 10), y: 0,width: (mRefreshButton.frame.size.width*2),height: mTopbarImageView.frame.size.height ))
        mTopbarImageView.addSubview(mAppVersionNumber)
        mAppVersionNumber.textAlignment = .right
        mAppVersionNumber.textColor = UIColor.white
        if let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
            let buildNumber: String = Bundle.main.object(forInfoDictionaryKey: "CFBundleVersion") as! String
            mAppVersionNumber.text = "V = \(version).".appending(buildNumber)
        }
        
        activityIndicator.frame = CGRect(x: mRefreshButton.frame.origin.x - 60,  y: 0,width: mTopbarImageView.frame.size.height,height: mTopbarImageView.frame.size.height)
        mTopbarImageView.addSubview(activityIndicator)
        activityIndicator.isHidden = true
        activityIndicator.stopAnimating()
        
        mNoSessionLabel = UILabel(frame: CGRect(x: 10, y: (self.view.frame.size.height - 40)/2, width: self.view.frame.size.width - 20,height: 40))
        mNoSessionLabel.font = UIFont(name:helveticaMedium, size: 30)
        mNoSessionLabel.text = "Please wait we are loading your sessions"
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
        
        addNumberOfLinesToScrollView()
        
        let currentDate = Date()
        mCurrentTimeLine = CurrentTimeLineView(frame: CGRect(x: 30, y: 0 , width: self.view.frame.size.width-30, height: 10))
        mCurrentTimeLine.addToCurrentTimewithHours(mViewModel.getPositionWithHour(currentDate.hour(), withMinute: currentDate.minute()))
        mScrollView.addSubview(mCurrentTimeLine)
        mScrollView.contentOffset = CGPoint(x: 0,y: mCurrentTimeLine.frame.origin.y-self.view.frame.size.height/3);
    }
    
    /// Add number of lines in scrollview
    fileprivate func addNumberOfLinesToScrollView() {
        var positionY: CGFloat = 30
        
        for index in 0 ..< 25 {
            let hourlabel = UILabel(frame: CGRect(x: 10, y: positionY-15,width: 50,height: 30))
            mScrollView.addSubview(hourlabel)
            hourlabel.textColor = standard_TextGrey
            hourlabel.text = mViewModel.getTimelabelWithIndexvalue(index: index)
            hourlabel.font = UIFont (name: helveticaRegular, size: 16)
            hourlabel.textAlignment = NSTextAlignment.right
            
            let hourLineView = ScheduleScreenLineView()
            hourLineView.frame = CGRect(x: 70, y: positionY, width: self.view.frame.size.width-70, height: 1)
            mViewModel.positionsArray[String("\(index)")] = positionY
            mScrollView.addSubview(hourLineView)
            
            if index != 24 {
                let halfHourLineView =  DottedLine()
                halfHourLineView.frame = CGRect(x: 75, y: positionY + (oneHourDiff/2), width: self.view.frame.size.width-80, height: 2)
                mScrollView.addSubview(halfHourLineView)
                halfHourLineView.drawDashedBorderAroundView(with: UIColor(red: 153/255.0, green: 153/255.0, blue: 153/255.0, alpha: 1))
                positionY = positionY + oneHourDiff
            }
        }
        mScrollView.contentSize = CGSize(width: 0, height: positionY + oneHourDiff / 2 )
    }
    
    /// This func is used to add tiles for schedule screen
    ///
    /// - Parameter timeTable: Details of every tiles
    fileprivate func addTilesForScheduleScreen(timeTables:[TimeTableModel]) {
        self.removeAllSessionFromScrollview()
        for session in timeTables {
            let startTime = session.StartTime!
            let endTime = session.EndTime!
            let totalSize = mViewModel.getSizeOfCalendarEvernWithStarthour(startTime.hourValue(), withstartMinute: startTime.minuteValue(), withEndHour: endTime.hourValue(), withEndMinute: endTime.minuteValue())
            let StartPositionOfTile = mViewModel.getPositionWithHour(startTime.hourValue(), withMinute: startTime.minuteValue())
            let scheduleTileView = TimeTableTileView(frame: CGRect(x: 75, y: StartPositionOfTile, width: self.view.frame.size.width-85, height: totalSize))
            mScrollView.addSubview(scheduleTileView)
            scheduleTileView._delgate = self
            scheduleTileView.tag = session.SessionId
            scheduleTileView.setTileWithModelDetails(model: session)
        }
    }
    
    /// This func will remove all the sessions from scrollview
    fileprivate func removeAllSessionFromScrollview() {
        for case let session as TimeTableTileView in mScrollView.subviews {
            session.removeFromSuperview()
        }
    }
}


