
//
//  ScheduleScreenTile.swift
//  Learniat_Student_Iphone
//
//  Created by Deepak MK on 01/02/16.
//  Copyright © 2016 mindShiftApps. All rights reserved.
//

import Foundation

@objc protocol ScheduleScreenTileDelegate
{
    
    optional func delegateScheduleTileTouchedWithState(state: String, withCurrentTileDetails Details:AnyObject)
    
    optional func delegateRefreshSchedule()
    
}

class ScheduleScreenTile: UIImageView, UIGestureRecognizerDelegate
{
    
    
    let alertExtendingMunites  = 120
    
    let alertTimeConditionValue  = 120
    
    var mClassName = UIVerticalAlignLabel()
    
    var _delgate: AnyObject!
    
    var sessionDetails : AnyObject!
    
    
    var circleImage                     = UIImageView()
    
    var cancelledImageView              = UIImageView()
    
    var mSeatingLabel                   = UIVerticalAlignLabel()
    
    var mSeatingAlertImageView          = UIImageView()
    
    var mDifferenceTimeLabel            = UIVerticalAlignLabel()
    
    var overDueTimer                    = NSTimer()
    
    var nextSessionTimer                = NSTimer()
    
    var alertTimeValue                  = 0
    
    
    override init(frame: CGRect) {
        
        super.init(frame:frame)
    }
    
    
    
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func setdelegate(delegate:AnyObject)
    {
        _delgate = delegate;
    }
    
    func   delegate()->AnyObject
    {
        return _delgate;
    }
    
    
    func loadAllViewObjects()
    {
        
        self.userInteractionEnabled = true
        
        cancelledImageView = UIImageView(frame: CGRectMake(0, 0, self.frame.size.width, self.frame.size.height))
        self.addSubview(cancelledImageView)
        cancelledImageView.image = UIImage(named: "CalendarBubbleRed.png")
        cancelledImageView.hidden = true
        
        
        let tap = UITapGestureRecognizer(target: self, action: Selector("handleTap:"))
        tap.delegate = self
        self.addGestureRecognizer(tap)
        
        
        
        
        
        self.addSubview(mClassName)
        mClassName.adjustsFontSizeToFitWidth = true
        mClassName.minimumScaleFactor = 0.2
        mClassName.lineBreakMode = NSLineBreakMode.ByTruncatingTail;
        mClassName.numberOfLines = 4
        mClassName.verticalAlignment = .VerticalAlignmentTop
        mClassName.textAlignment = .Left
        self.addSubview(circleImage)
        circleImage.hidden = true
        
        
       
        
        self.addSubview(mSeatingLabel)
        mSeatingLabel.adjustsFontSizeToFitWidth = true
        mSeatingLabel.minimumScaleFactor = 0.2
        mSeatingLabel.lineBreakMode = NSLineBreakMode.ByTruncatingTail;
        mSeatingLabel.numberOfLines = 4
        mSeatingLabel.verticalAlignment = .VerticalAlignmentTop
        mSeatingLabel.textColor = standard_Red
        mSeatingLabel.textAlignment = .Left
        
        
        
        self.addSubview(mDifferenceTimeLabel)
        mDifferenceTimeLabel.adjustsFontSizeToFitWidth = true
        mDifferenceTimeLabel.minimumScaleFactor = 0.2
        mDifferenceTimeLabel.lineBreakMode = NSLineBreakMode.ByTruncatingTail;
        mDifferenceTimeLabel.numberOfLines = 4
        mDifferenceTimeLabel.verticalAlignment = .VerticalAlignmentTop
        mDifferenceTimeLabel.textColor = UIColor.blackColor()
        mDifferenceTimeLabel.textAlignment = .Center
        
        
        
        
        
        mSeatingAlertImageView.image = UIImage(named: "Alert_Icon.png")
        self.addSubview(mSeatingAlertImageView)
        mSeatingAlertImageView.hidden = true

        
    }
    
    func handleTap(sender: UITapGestureRecognizer? = nil)
    {
        // handling code
        
        let sessionState = sessionDetails.objectForKey(kSessionState) as! String
        
        delegate().delegateScheduleTileTouchedWithState!(sessionState, withCurrentTileDetails: sessionDetails)
        
    }
    
    func setCurrentSessionDetails(details :AnyObject)
    {
        
        
        loadAllViewObjects()
        
        
        
        sessionDetails = details

        updateSessionColorWithSessionState(sessionDetails.objectForKey(kSessionState) as! String)
        
        updatSeatinglabelWithDetials(details)
        let classNameWithRoom = String(format:"%@(%@)",(details.objectForKey(kClassName) as! String),(details.objectForKey(kRoomName) as! String))
        mClassName.text = classNameWithRoom
    
        
        self.layer.masksToBounds = true
        
        self.layer.cornerRadius = 5
    }
    
    
    
    
    
    func updateSessionColorWithSessionState(sessionState:String)
    {
        
        cancelledImageView.hidden = true
        circleImage.hidden = false
        
        
        switch sessionState
        {
            case kScheduled:
                self.backgroundColor = scheduledColor
                self.layer.borderColor = scheduledBorderColor.CGColor
                self.layer.borderWidth = 1
                mClassName.textColor = UIColor.blackColor()
                
                setClassNameWithFont(helveticaMedium)
                circleImage.backgroundColor = scheduledBorderColor
                
                break
                
            case kopened:
                self.backgroundColor = OpenedColor
                self.layer.borderColor = OpenedBorderColor.CGColor
                self.layer.borderWidth = 1
                mClassName.textColor = UIColor.blackColor()
                
                setClassNameWithFont(helveticaRegular)
                circleImage.backgroundColor = OpenedBorderColor
                
                
                break
                
            case kLive:
                self.backgroundColor = LiveColor
                mClassName.textColor = UIColor.whiteColor()
                
                setClassNameWithFont(helveticaRegular)
                circleImage.backgroundColor = UIColor.whiteColor()
                
                
                if self.frame.size.height > 40
                {
                    circleImage.frame = CGRectMake(10, 8, 24, 24)
                    circleImage.layer.cornerRadius = circleImage.frame.size.width/2
                    circleImage.layer.masksToBounds = true
                    
                    let LiveLabel = UILabel(frame: CGRectMake(0,0,circleImage.frame.size.width,circleImage.frame.size.height))
                    circleImage.addSubview(LiveLabel)
                    LiveLabel.text = "Live"
                    LiveLabel.font = UIFont(name:helveticaRegular, size: 9)
                    LiveLabel.textColor = LiveColor
                    LiveLabel.textAlignment = .Center
                }
                
                else
                {
                    circleImage.frame = CGRectMake(10, 2, self.frame.size.height - 4,self.frame.size.height - 4)
                    circleImage.layer.cornerRadius = circleImage.frame.size.width/2
                    circleImage.layer.masksToBounds = true
                    
                    let LiveLabel = UILabel(frame: CGRectMake(0,0,circleImage.frame.size.width,circleImage.frame.size.height))
                    circleImage.addSubview(LiveLabel)
                    LiveLabel.text = "Live"
                    LiveLabel.font = UIFont(name:helveticaRegular, size: 9)
                    LiveLabel.textColor = LiveColor
                    LiveLabel.textAlignment = .Center
                }
                
               

                
                break
                
            case kCanClled:
                
                self.layer.borderColor = CancelledBorderColor.CGColor
                self.layer.borderWidth = 1
                mClassName.textColor = standard_TextGrey
                cancelledImageView.hidden = false
                setClassNameWithFont(helveticaRegular)
                circleImage.backgroundColor = CancelledBorderColor

                break
                
            case kEnded:
                self.backgroundColor = EndedColor
                mClassName.textColor = standard_TextGrey
                setClassNameWithFont(helveticaRegular)

                circleImage.hidden = true
                
                break
                
                
            default: break
                
        }
    }
    
    
    
    
    func updatSeatinglabelWithDetials(details:AnyObject)
    {
        
        
         mSeatingLabel.hidden = true
         mSeatingAlertImageView.hidden = true
       if let sessionState = details.objectForKey(kSessionState) as? String
        {
            
            
            
            
            switch sessionState
            {
                case kScheduled:
                   if let StudentsRegistered = details.objectForKey("StudentsRegistered") as? String
                   {
                        if let PreAllocatedSeats = details.objectForKey("PreAllocatedSeats") as? String
                        {
                            if let OccupiedSeats = details.objectForKey("OccupiedSeats") as? String
                            {
                                
                                if Int(StudentsRegistered) > Int(PreAllocatedSeats)! + Int(OccupiedSeats)!
                                {
                                    
                                    mSeatingLabel.hidden = false
                                     mSeatingAlertImageView.hidden = false
                                     if (Int(StudentsRegistered)>1)
                                     {
                                        mSeatingLabel.text = "\(Int(StudentsRegistered)! - (Int(PreAllocatedSeats)! + Int(OccupiedSeats)!)) Students are not allocated"
                                    }
                                    else
                                     {
                                         mSeatingLabel.text = "\(Int(StudentsRegistered)! - (Int(PreAllocatedSeats)! + Int(OccupiedSeats)!)) Student is not allocated"
                                    }
                                }
                            }
                        }
                   }
                    break
                    
                case kopened:
                    if let StudentsRegistered = details.objectForKey("StudentsRegistered") as? String
                    {
                        if let PreAllocatedSeats = details.objectForKey("PreAllocatedSeats") as? String
                        {
                            if let OccupiedSeats = details.objectForKey("OccupiedSeats") as? String
                            {
                                
                                if Int(StudentsRegistered) > Int(PreAllocatedSeats)! + Int(OccupiedSeats)!
                                {
                                    
                                    mSeatingLabel.hidden = false
                                    mSeatingAlertImageView.hidden = false
                                    if (Int(StudentsRegistered)>1)
                                    {
                                        mSeatingLabel.text = "\(Int(StudentsRegistered)! - (Int(PreAllocatedSeats)! + Int(OccupiedSeats)!)) Students are not allocated"
                                    }
                                    else
                                    {
                                        mSeatingLabel.text = "\(Int(StudentsRegistered)! - (Int(PreAllocatedSeats)! + Int(OccupiedSeats)!)) Student is not allocated"
                                    }
                                }
                            }
                        }
                    }
                    
                    break
                    
                default:
                    mSeatingLabel.hidden = true
                    break
            }

        }
        
    }
    
    
    func setClassNameWithFont(fontname: String)
    {
        if self.frame.size.height/2 < 20
        {
            mClassName.frame = CGRectMake(40, 4, self.frame.size.width/3, (self.frame.size.height/1.2))
            
            mClassName.font = UIFont(name: fontname, size: (self.frame.size.height/2))
            
            circleImage.frame = CGRectMake(15, 6, 15, 15)
            
            
            
            mSeatingLabel.frame =  CGRectMake(self.frame.size.width - (self.frame.size.width/3.5), 4, self.frame.size.width/3.5, (self.frame.size.height/1.2))
            
            mSeatingLabel.font = UIFont(name: helveticaBold, size: (self.frame.size.height/2))
            
            mSeatingAlertImageView.frame = CGRectMake(mSeatingLabel.frame.origin.x - 30, 4, 20, 20)
            
            
            mDifferenceTimeLabel.frame = CGRectMake(mClassName.frame.origin.x  + mClassName.frame.size.width + 20, 4, self.frame.size.width/3 , (self.frame.size.height/1.2))
             mDifferenceTimeLabel.font = UIFont(name: helveticaRegular, size: (self.frame.size.height/2))
            
            
        }
        else
        {
            mClassName.frame = CGRectMake(40, 10, self.frame.size.width/3, (self.frame.size.height/1.2))
            
            mClassName.font = UIFont(name: fontname, size: 18)
            
            circleImage.frame = CGRectMake(15, 15, 15, 15)
            
            
            mSeatingLabel.frame =  CGRectMake(self.frame.size.width - (self.frame.size.width/3.5), 10, self.frame.size.width/3.5, (self.frame.size.height/1.2))
            mSeatingLabel.font = UIFont(name: helveticaBold, size: 18)
            
            
            mSeatingAlertImageView.frame = CGRectMake(mSeatingLabel.frame.origin.x - 30, 13, 20, 20)
            
            
            mDifferenceTimeLabel.frame = CGRectMake(mClassName.frame.origin.x  + mClassName.frame.size.width + 20, 10, self.frame.size.width/4 , (self.frame.size.height/1.2))
            mDifferenceTimeLabel.font = UIFont(name: helveticaRegular, size: 18)

            

        }
        circleImage.layer.cornerRadius = circleImage.frame.size.width/2
        circleImage.layer.masksToBounds = true

    }
    
    
    func OverDueSessionIsWithDetails(details:AnyObject)
    {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        var _string :String = ""
        let currentDate = NSDate()
        _string = _string.stringFromTimeInterval(currentDate.timeIntervalSinceDate(dateFormatter.dateFromString((sessionDetails.objectForKey("StartTime") as! String))!)).fullString
        
        mDifferenceTimeLabel.text = "Overdue: \(_string)"
        
        
        self.backgroundColor = standard_Red
        mSeatingAlertImageView.image = UIImage(named: "Blue_Alert.png")
        mSeatingLabel.textColor = UIColor.whiteColor()
        
        overDueTimer.invalidate()
        nextSessionTimer.invalidate()
        
        overDueTimer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: "updateOverdueSession", userInfo: nil, repeats: true)
    }
    
    
    func updateOverdueSession()
    {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        var _string :String = ""
        let currentDate = NSDate()
        _string = _string.stringFromTimeInterval(currentDate.timeIntervalSinceDate(dateFormatter.dateFromString((sessionDetails.objectForKey("StartTime") as! String))!)).fullString
        
        mDifferenceTimeLabel.text = "Overdue: \(_string)"
        
        
        
        
        if let endTime = sessionDetails.objectForKey("EndTime") as? String
        {
            let isGreater = currentDate.isGreaterThanDate((dateFormatter.dateFromString(endTime)!))
            
            let isEqual = currentDate.isEqualToDate((dateFormatter.dateFromString(endTime)!))
           
            if isGreater == true || isEqual == true
            {
                if delegate().respondsToSelector(Selector("delegateRefreshSchedule"))
                {
                    delegate().delegateRefreshSchedule!()
                }
            }
            
           
        }
        
    }
    
    
    
    func nextSessionUpdatingWithdetails(details:AnyObject)
    {
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        var _string :String = ""
        let currentDate = NSDate()
        _string = _string.stringFromTimeInterval(dateFormatter.dateFromString((sessionDetails.objectForKey("StartTime") as! String))!.timeIntervalSinceDate(currentDate)).fullString
        
        mDifferenceTimeLabel.text = "Starts in about: \(_string)"

        overDueTimer.invalidate()
        nextSessionTimer.invalidate()
        nextSessionTimer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: "updateNextSession", userInfo: nil, repeats: true)
        
        
         let differenceMinutes  = currentDate.minutesAndSecondsDiffernceBetweenDates(currentDate, endDate: dateFormatter.dateFromString(sessionDetails.objectForKey("StartTime") as! String)!)
        
        if differenceMinutes.second < alertTimeConditionValue
        {
            alertTimeValue = differenceMinutes.second
        }
        else
        {
            alertTimeValue = alertExtendingMunites
        }
        
    }
    
    func updateNextSession()
    {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        var _string :String = ""
        let currentDate = NSDate()
        _string = _string.stringFromTimeInterval(dateFormatter.dateFromString((sessionDetails.objectForKey("StartTime") as! String))!.timeIntervalSinceDate(currentDate)).fullString
        
        mDifferenceTimeLabel.text = "Starts in about: \(_string)"
        
        
        
        let differenceMinutes  = currentDate.minutesAndSecondsDiffernceBetweenDates(currentDate, endDate: dateFormatter.dateFromString(sessionDetails.objectForKey("StartTime") as! String)!)
        
        
        if differenceMinutes.second <= 0
        {
            let isLesserValue = currentDate.isGreaterThanDate(dateFormatter.dateFromString(sessionDetails.objectForKey("StartTime") as! String)!)
            
            if isLesserValue == true
            {
                overDueTimer.invalidate()
                nextSessionTimer.invalidate()
                alertTimeValue = alertExtendingMunites
                if delegate().respondsToSelector(Selector("delegateRefreshSchedule"))
                {
                    delegate().delegateRefreshSchedule!()
                }
            }
        }
        else if differenceMinutes.second == alertTimeConditionValue
        {
            overDueTimer.invalidate()
            nextSessionTimer.invalidate()
            alertTimeValue = alertExtendingMunites
            if delegate().respondsToSelector(Selector("delegateRefreshSchedule"))
            {
                delegate().delegateRefreshSchedule!()
            }
        }
        else if differenceMinutes.second < alertTimeConditionValue
        {
            
            if alertTimeValue <= 0
            {
                overDueTimer.invalidate()
                nextSessionTimer.invalidate()
                alertTimeValue = alertExtendingMunites
                if delegate().respondsToSelector(Selector("delegateRefreshSchedule"))
                {
                    delegate().delegateRefreshSchedule!()
                }
            }
            else
            {
                alertTimeValue = alertTimeValue - 1
            }
        }
        
    }
    
    func alertDismissed()
    {
        alertTimeValue = alertExtendingMunites
    }
    
    
    func stopAllTimmers()
    {
        overDueTimer.invalidate()
        nextSessionTimer.invalidate()
    }
    
}