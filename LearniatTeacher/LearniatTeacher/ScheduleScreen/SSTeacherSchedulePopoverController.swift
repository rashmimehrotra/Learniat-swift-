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
    
    optional func delegateSessionEnded()
    
    
}

class SSTeacherSchedulePopoverController: UIViewController,SSTeacherDataSourceDelegate
{
    
    var _delgate: AnyObject!
    
    var _Popover:AnyObject!
    
    var _currentScreenSize = CGSize()
    
    var activityIndicator  : UIActivityIndicatorView!
    
    var mScrollView:UIScrollView!
    
    var positionsArray:Dictionary<String,CGFloat> = Dictionary()
    
    var mCurrentTimeLine :CurrentTimeLineView!
    
    var timer = NSTimer()
    
    
    override func viewWillDisappear(animated: Bool)
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
        
        let  mTopbarImageView = UIImageView(frame: CGRectMake(0, 0, _currentScreenSize.width, 50))
        mTopbarImageView.backgroundColor = UIColor.whiteColor()
        self.view.addSubview(mTopbarImageView)
        mTopbarImageView.userInteractionEnabled = true
        
        let mTodaysSchedule = UILabel(frame: CGRectMake((mTopbarImageView.frame.size.width - 200)/2, 0, 200, mTopbarImageView.frame.size.height))
        mTodaysSchedule.font = UIFont(name:helveticaRegular, size: 20)
        mTodaysSchedule.text = "Today's schedule"
        mTopbarImageView.addSubview(mTodaysSchedule)
        mTodaysSchedule.textColor = blackTextColor
        
        
        
        let  mDoneButton = UIButton(frame: CGRectMake(mTopbarImageView.frame.size.width - 120, 0, 100, 40))
        mDoneButton.addTarget(self, action: #selector(SSTeacherSchedulePopoverController.onDoneButton), forControlEvents: UIControlEvents.TouchUpInside)
        mDoneButton.setTitleColor(standard_Button, forState: .Normal)
        mDoneButton.setTitle("Done", forState: .Normal)
        mDoneButton.contentHorizontalAlignment = UIControlContentHorizontalAlignment.Right
        mDoneButton.titleLabel?.font = UIFont(name: helveticaMedium, size: 20)
        mTopbarImageView.addSubview(mDoneButton)
        

         activityIndicator  =  UIActivityIndicatorView(activityIndicatorStyle:.Gray)
        activityIndicator.frame = CGRectMake(mDoneButton.frame.origin.x - 40,  0,mTopbarImageView.frame.size.height,mTopbarImageView.frame.size.height)
        mTopbarImageView.addSubview(activityIndicator)
        activityIndicator.hidden = true
        
        
        
        mScrollView = UIScrollView(frame: CGRectMake(0,mTopbarImageView.frame.size.height,_currentScreenSize.width,_currentScreenSize.height - (mTopbarImageView.frame.size.height * 2)))
        mScrollView.backgroundColor = UIColor.clearColor()
        self.view.addSubview(mScrollView)
        
        
          addNumberOfLinesToScrollView()
        
        
        let  mEndClassButton = UIButton(frame: CGRectMake(0, _currentScreenSize.height - 50 , _currentScreenSize.width, 50))
        mEndClassButton.addTarget(self, action: #selector(SSTeacherSchedulePopoverController.onEndSession), forControlEvents: UIControlEvents.TouchUpInside)
        mEndClassButton.setTitleColor(standard_Red, forState: .Normal)
        mEndClassButton.setTitle("End class", forState: .Normal)
        mEndClassButton.contentHorizontalAlignment = UIControlContentHorizontalAlignment.Center
        mEndClassButton.titleLabel?.font = UIFont(name: helveticaMedium, size: 20)
        self.view.addSubview(mEndClassButton)
        mEndClassButton.backgroundColor = UIColor.whiteColor()
        
        
        SSTeacherDataSource.sharedDataSource.getScheduleOfTeacher(self)
        activityIndicator.hidden = false
        activityIndicator.startAnimating()
        
        
        let currentDate = NSDate()
        mCurrentTimeLine = CurrentTimeLineView(frame: CGRectMake(30, 0 , self.view.frame.size.width-30, 10))
        mScrollView.addSubview(mCurrentTimeLine)
        mCurrentTimeLine.addToCurrentTimewithHours(getPositionWithHour(currentDate.hour(), withMinute: currentDate.minute()))
        mScrollView.contentOffset = CGPointMake(0,mCurrentTimeLine.frame.origin.y-self.view.frame.size.height/3);
        
        
        
        timer = NSTimer.scheduledTimerWithTimeInterval(60, target: self, selector: #selector(SSTeacherSchedulePopoverController.timerAction), userInfo: nil, repeats: true)
        
        
        
    }
    
    
    func addNumberOfLinesToScrollView()
    {
        var positionY: CGFloat = 30
        var hourValue = 1
        
        
      
        
         for index in 0 ..< 24
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
    
    
    func setCurrentScreenSize(size:CGSize)
    {
        _currentScreenSize = size
    }
   
    func setdelegate(delegate:AnyObject)
    {
        _delgate = delegate;
    }
    
    func   delegate()->AnyObject
    {
        return _delgate;
    }
    
    func setPopover(popover:AnyObject)
    {
        _Popover = popover
    }
    
    func popover()-> AnyObject
    {
        return _Popover
    }
    
    
    
    func onDoneButton()
    {
        popover().dismissPopoverAnimated(true)
    }
    
    
    func onEndSession()
    {
        popover().dismissPopoverAnimated(true)
        
        if delegate().respondsToSelector(#selector(SSTeacherSchedulePopoverControllerDelegate.delegateSessionEnded))
        {
            delegate().delegateSessionEnded!()
        }
    }
    
    func timerAction()
    {
        let currentDate = NSDate()
        
        let currentHour = (currentDate.hour())
        
        mCurrentTimeLine.addToCurrentTimewithHours(getPositionWithHour(currentHour, withMinute: currentDate.minute()))
        
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
        var sessionDetailsArray = NSMutableArray()
        
        if let statusString = details.objectForKey("Status") as? String
        {
            if statusString == kSuccessString
            {
               
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
            
            scheduleTileView.tag = Int(sessionid)!
            scheduleTileView.setCurrentSessionDetails(dict)
           
            
            
            
        }
        
        
        
        let currentDate = NSDate()
        let currentHour = (currentDate.hour())
        mCurrentTimeLine.addToCurrentTimewithHours(getPositionWithHour(currentHour, withMinute: currentDate.minute()))
        UIView.animateWithDuration(0.5, animations: {
            self.mScrollView.contentOffset = CGPointMake(0,self.mCurrentTimeLine.frame.origin.y - self.view.frame.size.height/3);
        })
        
        
        
            activityIndicator.hidden = true
            activityIndicator.stopAnimating()
        
        
    }
    
    
    // MARK: - Returning Functions
    
    func getPositionWithHour(_hour : Int, withMinute minute:Int) -> CGFloat
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
    
    
    
    func getSizeOfCalendarEvernWithStarthour(startHour: Int, withstartMinute startMinute:Int, withEndHour endHour:Int, withEndMinute endMinute:Int) -> CGFloat
    {
        
        let startPosition = getPositionWithHour(startHour, withMinute: startMinute)
        
        let endposition = getPositionWithHour(endHour, withMinute: endMinute)
        
        
        let sizeOfEvent = endposition - startPosition
        
        
        return sizeOfEvent
    }


}