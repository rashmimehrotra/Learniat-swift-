//
//  SSTeacherSchedulePopoverController.swift
//  LearniatTeacher
//
//  Created by Deepak MK on 13/04/16.
//  Copyright © 2016 Mindshift. All rights reserved.
//

import Foundation

@objc protocol SSTeacherSchedulePopoverControllerDelegate
{
    
    @objc optional func delegateSessionEnded()
    
    @objc optional func delegateMoveToScheduleScreen()
    
    
}

class SSTeacherSchedulePopoverController: UIViewController,SSTeacherDataSourceDelegate
{
    
    var _delgate: AnyObject!
    
    
    var _currentScreenSize = CGSize()
    
    var activityIndicator  : UIActivityIndicatorView!
    
    var mScrollView:UIScrollView!
    
    var positionsArray:Dictionary<String,CGFloat> = Dictionary()
    
    var mCurrentTimeLine :CurrentTimeLineView!
    
    var timer = Timer()
    
    var  mEndClassButton = UIButton()
    
    override func viewWillDisappear(_ animated: Bool)
    {
        
         timer.invalidate()
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.view.backgroundColor = lightGrayTopBar
        
        
        self.view.setNeedsLayout()
        self.view.layoutIfNeeded()
        
        let  mTopbarImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: _currentScreenSize.width, height: 50))
        mTopbarImageView.backgroundColor = UIColor.white
        self.view.addSubview(mTopbarImageView)
        mTopbarImageView.isUserInteractionEnabled = true
        
        let mTodaysSchedule = UILabel(frame: CGRect(x: (mTopbarImageView.frame.size.width - 200)/2, y: 0, width: 200, height: mTopbarImageView.frame.size.height))
        mTodaysSchedule.font = UIFont(name:helveticaRegular, size: 20)
        mTodaysSchedule.text = "Today's schedule"
        mTopbarImageView.addSubview(mTodaysSchedule)
        mTodaysSchedule.textColor = blackTextColor
        
        
        
        let  mDoneButton = UIButton(frame: CGRect(x: mTopbarImageView.frame.size.width - 120, y: 0, width: 100, height: 40))
        mDoneButton.addTarget(self, action: #selector(SSTeacherSchedulePopoverController.onDoneButton), for: UIControlEvents.touchUpInside)
        mDoneButton.setTitleColor(standard_Button, for: UIControlState())
        mDoneButton.setTitle("Done", for: UIControlState())
        mDoneButton.contentHorizontalAlignment = UIControlContentHorizontalAlignment.right
        mDoneButton.titleLabel?.font = UIFont(name: helveticaMedium, size: 20)
        mTopbarImageView.addSubview(mDoneButton)
        

         activityIndicator  =  UIActivityIndicatorView(activityIndicatorStyle:.gray)
        activityIndicator.frame = CGRect(x: mDoneButton.frame.origin.x - 40,  y: 0,width: mTopbarImageView.frame.size.height,height: mTopbarImageView.frame.size.height)
        mTopbarImageView.addSubview(activityIndicator)
        activityIndicator.isHidden = true
        
        
        
        mScrollView = UIScrollView(frame: CGRect(x: 0,y: mTopbarImageView.frame.size.height,width: _currentScreenSize.width,height: _currentScreenSize.height - (mTopbarImageView.frame.size.height * 2)))
        mScrollView.backgroundColor = UIColor.clear
        self.view.addSubview(mScrollView)
        
        
          addNumberOfLinesToScrollView()
        
        
          mEndClassButton = UIButton(frame: CGRect(x: 0, y: _currentScreenSize.height - 50 , width: _currentScreenSize.width, height: 50))
        mEndClassButton.addTarget(self, action: #selector(SSTeacherSchedulePopoverController.onEndSession), for: UIControlEvents.touchUpInside)
        mEndClassButton.setTitleColor(standard_Red, for: UIControlState())
        mEndClassButton.setTitle("End class", for: UIControlState())
        mEndClassButton.contentHorizontalAlignment = UIControlContentHorizontalAlignment.center
        mEndClassButton.titleLabel?.font = UIFont(name: helveticaMedium, size: 20)
        self.view.addSubview(mEndClassButton)
        mEndClassButton.backgroundColor = UIColor.white
        
        
        SSTeacherDataSource.sharedDataSource.getScheduleOfTeacher(self)
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
        
        
        let currentDate = Date()
        mCurrentTimeLine = CurrentTimeLineView(frame: CGRect(x: 0, y: 0 , width: self.view.frame.size.width-30, height: 10))
        mScrollView.addSubview(mCurrentTimeLine)
        mCurrentTimeLine.addToCurrentTimewithHours(getPositionWithHour(currentDate.hour(), withMinute: currentDate.minute()))
        mScrollView.contentOffset = CGPoint(x: 0,y: mCurrentTimeLine.frame.origin.y-self.view.frame.size.height/3);
        
        
        
        timer = Timer.scheduledTimer(timeInterval: 60, target: self, selector: #selector(SSTeacherSchedulePopoverController.timerAction), userInfo: nil, repeats: true)
        
        
        
    }
    
    
    func addNumberOfLinesToScrollView()
    {
        var positionY: CGFloat = 30
        var hourValue = 1
        
        
      
        
         for index in 0 ..< 24
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
    
    
    func setCurrentScreenSize(_ size:CGSize)
    {
        _currentScreenSize = size
    }
   
    func setdelegate(_ delegate:AnyObject)
    {
        _delgate = delegate;
    }
    
    func   delegate()->AnyObject
    {
        return _delgate;
    }
    
    
    var _Popover:UIPopoverController!
    
    func setPopover(_ popover:UIPopoverController)
    {
        _Popover = popover
    }
    
    func popover()-> UIPopoverController
    {
        return _Popover
    }
    
    
    func onDoneButton()
    {
       popover().dismiss(animated: true)
    }
    
    
    func onEndSession()
    {
        if delegate().responds(to: #selector(SSTeacherSchedulePopoverControllerDelegate.delegateSessionEnded))
        {
            popover().dismiss(animated: true)
            
            delegate().delegateSessionEnded!()
            
            mEndClassButton.setTitleColor(lightGrayColor, for: UIControlState())
            mEndClassButton.setTitle("Ending session, Please wait", for: UIControlState())
            mEndClassButton.isUserInteractionEnabled = false
            self.view.isUserInteractionEnabled = false 
            
        }
    }
    
    
    
    func timerAction()
    {
        let currentDate = Date()
        
        let currentHour = (currentDate.hour())
        
        mCurrentTimeLine.addToCurrentTimewithHours(getPositionWithHour(currentHour, withMinute: currentDate.minute()))
        
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
        var sessionDetailsArray = NSMutableArray()
        
        if let statusString = details.object(forKey: "Status") as? String {
            if statusString == kSuccessString {
                mScrollView.isHidden = false
                if let classCheckingVariable = (details.object(forKey: kSessions)! as AnyObject).object(forKey: kSubSession) as? NSMutableArray {
                       sessionDetailsArray = classCheckingVariable
                } else {
                    sessionDetailsArray.add((details.object(forKey: kSessions)! as AnyObject).object(forKey: kSubSession)!)
                }
            } else {
                mScrollView.isHidden = true
            }
        }
        
        for index in 0 ..< sessionDetailsArray.count {
            let dict = sessionDetailsArray.object(at: index)
            let startDate :String = ((dict as AnyObject).object(forKey: kStartTime) as! String)
            let endDate = ((dict as AnyObject).object(forKey: kEndTime) as! String!)
            let totalSize = getSizeOfCalendarEvernWithStarthour(startDate.hourValue(), withstartMinute: startDate.minuteValue(), withEndHour: (endDate?.hourValue())!, withEndMinute: (endDate?.minuteValue())!)
            let StartPositionOfTile = getPositionWithHour(startDate.hourValue(), withMinute: startDate.minuteValue())
            checkSessionStateWithDetails(details: dict as AnyObject)
            let scheduleTileView = ScheduleScreenTile(frame: CGRect(x: 85, y: StartPositionOfTile, width: self.view.frame.size.width-95, height: totalSize))
            mScrollView.addSubview(scheduleTileView)
            scheduleTileView.setdelegate(self)
            
            let sessionid = (dict as AnyObject).object(forKey: kSessionId) as! String
            scheduleTileView.tag = Int(sessionid)!
            scheduleTileView.setCurrentSessionDetails(dict as AnyObject)
        }
        
        
        
        let currentDate = Date()
        let currentHour = (currentDate.hour())
        mCurrentTimeLine.addToCurrentTimewithHours(getPositionWithHour(currentHour, withMinute: currentDate.minute()))
        UIView.animate(withDuration: 0.5, animations: {
            self.mScrollView.contentOffset = CGPoint(x: 0,y: self.mCurrentTimeLine.frame.origin.y - self.view.frame.size.height/3);
        })
        
        
        
            activityIndicator.isHidden = true
            activityIndicator.stopAnimating()
        SSTeacherMessageHandler.sharedMessageHandler.refreshApp()

        
    }
    
    private func checkSessionStateWithDetails(details:AnyObject) {
        if let sessionid = details.object(forKey: kSessionId) as? String {
            if let _SessionState = details.object(forKey: kSessionState) as? String {
                if sessionid == SSTeacherDataSource.sharedDataSource.currentLiveSessionId {
                    if _SessionState != kLive {
                        if delegate().responds(to: #selector(SSTeacherSchedulePopoverControllerDelegate.delegateMoveToScheduleScreen)) {
                            delegate().delegateMoveToScheduleScreen!()
                        }
                        
                    }
                }
            }
        }
        
    }
    
    // MARK: - Returning Functions
    
    func getPositionWithHour(_ _hour : Int, withMinute minute:Int) -> CGFloat
    {
        //        hour = hour
        
        var hour = _hour
        
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


}
