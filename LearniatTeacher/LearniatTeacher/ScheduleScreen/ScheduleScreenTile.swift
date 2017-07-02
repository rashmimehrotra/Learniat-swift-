
//
//  ScheduleScreenTile.swift
//  Learniat_Student_Iphone
//
//  Created by Deepak MK on 01/02/16.
//  Copyright © 2016 mindShiftApps. All rights reserved.
//

import Foundation
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


@objc protocol ScheduleScreenTileDelegate
{
    
    @objc optional func delegateScheduleTileTouchedWithState(_ state: String, withCurrentTileDetails Details:AnyObject)
    
    @objc optional func delegateRefreshSchedule()
    
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
    
    var overDueTimer                    = Timer()
    
    var nextSessionTimer                = Timer()
    
    var alertTimeValue                  = 0
    
    
    override init(frame: CGRect) {
        
        super.init(frame:frame)
    }
    
    
    
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func setdelegate(_ delegate:AnyObject)
    {
        _delgate = delegate;
    }
    
    func   delegate()->AnyObject
    {
        return _delgate;
    }
    
    
    func loadAllViewObjects()
    {
        
        self.isUserInteractionEnabled = true
        
        cancelledImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: self.frame.size.width, height: self.frame.size.height))
        self.addSubview(cancelledImageView)
        cancelledImageView.image = UIImage(named: "CalendarBubbleRed.png")
        cancelledImageView.isHidden = true
        
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(ScheduleScreenTile.handleTap(_:)))
        tap.delegate = self
        self.addGestureRecognizer(tap)
        
        
        
        
        
        self.addSubview(mClassName)
        mClassName.adjustsFontSizeToFitWidth = true
        mClassName.minimumScaleFactor = 0.2
        mClassName.lineBreakMode = NSLineBreakMode.byTruncatingTail;
        mClassName.numberOfLines = 4
        mClassName.verticalAlignment = .verticalAlignmentTop
        mClassName.textAlignment = .left
        self.addSubview(circleImage)
        circleImage.isHidden = true
        
        
        
        
        self.addSubview(mSeatingLabel)
        mSeatingLabel.adjustsFontSizeToFitWidth = true
        mSeatingLabel.minimumScaleFactor = 0.2
        mSeatingLabel.lineBreakMode = NSLineBreakMode.byTruncatingTail;
        mSeatingLabel.numberOfLines = 4
        mSeatingLabel.verticalAlignment = .verticalAlignmentTop
        mSeatingLabel.textColor = standard_Red
        mSeatingLabel.textAlignment = .left
        
        
        
        self.addSubview(mDifferenceTimeLabel)
        mDifferenceTimeLabel.adjustsFontSizeToFitWidth = true
        mDifferenceTimeLabel.minimumScaleFactor = 0.2
        mDifferenceTimeLabel.lineBreakMode = NSLineBreakMode.byTruncatingTail;
        mDifferenceTimeLabel.numberOfLines = 4
        mDifferenceTimeLabel.verticalAlignment = .verticalAlignmentTop
        mDifferenceTimeLabel.textColor = UIColor.black
        mDifferenceTimeLabel.textAlignment = .center
        
        
        
        
        
        mSeatingAlertImageView.image = UIImage(named: "Alert_Icon.png")
        self.addSubview(mSeatingAlertImageView)
        mSeatingAlertImageView.isHidden = true
        
        
    }
    
    func handleTap(_ sender: UITapGestureRecognizer? = nil)
    {
        // handling code
        
        let sessionState = sessionDetails.object(forKey: kSessionState) as! String
        
        
        if delegate().responds(to: #selector(ScheduleScreenTileDelegate.delegateScheduleTileTouchedWithState(_:withCurrentTileDetails:)))
        {
            delegate().delegateScheduleTileTouchedWithState!(sessionState, withCurrentTileDetails: sessionDetails)
        }
        
        
        
    }
    
    func setCurrentSessionDetails(_ details :AnyObject)
    {
        
        
        loadAllViewObjects()
        
        
        
        sessionDetails = details
        
        updateSessionColorWithSessionState(sessionDetails.object(forKey: kSessionState) as! String)
        
        updatSeatinglabelWithDetials(details)
        let classNameWithRoom = String(format:"%@ (%@) (%@)",(details.object(forKey: kClassName) as! String),(details.object(forKey: kRoomName) as! String),(details.object(forKey: kSessionId) as! String))
        mClassName.text = classNameWithRoom
        
        
        self.layer.masksToBounds = true
        
        self.layer.cornerRadius = 5
    }
    
    
    
    
    
    func updateSessionColorWithSessionState(_ sessionState:String)
    {
        
        cancelledImageView.isHidden = true
        circleImage.isHidden = false
        
        
        switch sessionState
        {
        case kScheduled:
            self.backgroundColor = scheduledColor
            self.layer.borderColor = scheduledBorderColor.cgColor
            self.layer.borderWidth = 1
            mClassName.textColor = UIColor.black
            
            setClassNameWithFont(helveticaMedium)
            circleImage.backgroundColor = scheduledBorderColor
            
            break
            
        case kopened:
            self.backgroundColor = OpenedColor
            self.layer.borderColor = OpenedBorderColor.cgColor
            self.layer.borderWidth = 1
            mClassName.textColor = UIColor.black
            
            setClassNameWithFont(helveticaRegular)
            circleImage.backgroundColor = OpenedBorderColor
            
            
            break
            
        case kLive:
            self.backgroundColor = LiveColor
            mClassName.textColor = UIColor.white
            
            setClassNameWithFont(helveticaRegular)
            circleImage.backgroundColor = UIColor.white
            
            
            if self.frame.size.height > 40
            {
                circleImage.frame = CGRect(x: 10, y: 8, width: 24, height: 24)
                circleImage.layer.cornerRadius = circleImage.frame.size.width/2
                circleImage.layer.masksToBounds = true
                
                let LiveLabel = UILabel(frame: CGRect(x: 0,y: 0,width: circleImage.frame.size.width,height: circleImage.frame.size.height))
                circleImage.addSubview(LiveLabel)
                LiveLabel.text = "Live"
                LiveLabel.font = UIFont(name:helveticaRegular, size: 9)
                LiveLabel.textColor = LiveColor
                LiveLabel.textAlignment = .center
            }
                
            else
            {
                circleImage.frame = CGRect(x: 10, y: 2, width: self.frame.size.height - 4,height: self.frame.size.height - 4)
                circleImage.layer.cornerRadius = circleImage.frame.size.width/2
                circleImage.layer.masksToBounds = true
                
                let LiveLabel = UILabel(frame: CGRect(x: 0,y: 0,width: circleImage.frame.size.width,height: circleImage.frame.size.height))
                circleImage.addSubview(LiveLabel)
                LiveLabel.text = "Live"
                LiveLabel.font = UIFont(name:helveticaRegular, size: 9)
                LiveLabel.textColor = LiveColor
                LiveLabel.textAlignment = .center
            }
            
            
            
            
            break
            
        case kCanClled:
            
            self.layer.borderColor = CancelledBorderColor.cgColor
            self.layer.borderWidth = 1
            mClassName.textColor = standard_TextGrey
            cancelledImageView.isHidden = false
            setClassNameWithFont(helveticaRegular)
            circleImage.backgroundColor = CancelledBorderColor
            
            break
            
        case kEnded:
            self.backgroundColor = EndedColor
            mClassName.textColor = standard_TextGrey
            setClassNameWithFont(helveticaRegular)
            
            circleImage.isHidden = true
            
            break
            
            
        default: break
            
        }
    }
    
    
    
    
    func updatSeatinglabelWithDetials(_ details:AnyObject)
    {
        
        
        mSeatingLabel.isHidden = true
        mSeatingAlertImageView.isHidden = true
        if let sessionState = details.object(forKey: kSessionState) as? String
        {
            
            
            
            
            switch sessionState
            {
            case kScheduled:
                if let StudentsRegistered = details.object(forKey: "StudentsRegistered") as? String
                {
                    if let PreAllocatedSeats = details.object(forKey: "PreAllocatedSeats") as? String
                    {
                        if let OccupiedSeats = details.object(forKey: "OccupiedSeats") as? String
                        {
                            
                            if Int(StudentsRegistered) > Int(PreAllocatedSeats)! + Int(OccupiedSeats)!
                            {
                                
                                mSeatingLabel.isHidden = false
                                mSeatingAlertImageView.isHidden = false
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
                if let StudentsRegistered = details.object(forKey: "StudentsRegistered") as? String
                {
                    if let PreAllocatedSeats = details.object(forKey: "PreAllocatedSeats") as? String
                    {
                        if let OccupiedSeats = details.object(forKey: "OccupiedSeats") as? String
                        {
                            
                            if Int(StudentsRegistered) > Int(PreAllocatedSeats)! + Int(OccupiedSeats)!
                            {
                                
                                mSeatingLabel.isHidden = false
                                mSeatingAlertImageView.isHidden = false
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
                mSeatingLabel.isHidden = true
                break
            }
            
        }
        
    }
    
    
    func setClassNameWithFont(_ fontname: String)
    {
        if self.frame.size.height/2 < 20
        {
            mClassName.frame = CGRect(x: 40, y: 4, width: self.frame.size.width/3, height: (self.frame.size.height/1.2))
            
            mClassName.font = UIFont(name: fontname, size: (self.frame.size.height/2))
            
            circleImage.frame = CGRect(x: 15, y: 6, width: 15, height: 15)
            
            
            
            mSeatingLabel.frame =  CGRect(x: self.frame.size.width - (self.frame.size.width/3.5), y: 4, width: self.frame.size.width/3.5, height: (self.frame.size.height/1.2))
            
            mSeatingLabel.font = UIFont(name: helveticaBold, size: (self.frame.size.height/2))
            
            mSeatingAlertImageView.frame = CGRect(x: mSeatingLabel.frame.origin.x - 30, y: 4, width: 20, height: 20)
            
            
            mDifferenceTimeLabel.frame = CGRect(x: mClassName.frame.origin.x  + mClassName.frame.size.width + 20, y: 4, width: self.frame.size.width/3 , height: (self.frame.size.height/1.2))
            mDifferenceTimeLabel.font = UIFont(name: helveticaRegular, size: (self.frame.size.height/2))
            
            
        }
        else
        {
            mClassName.frame = CGRect(x: 40, y: 10, width: self.frame.size.width/3, height: (self.frame.size.height/1.2))
            
            mClassName.font = UIFont(name: fontname, size: 18)
            
            circleImage.frame = CGRect(x: 15, y: 15, width: 15, height: 15)
            
            
            mSeatingLabel.frame =  CGRect(x: self.frame.size.width - (self.frame.size.width/3.5), y: 10, width: self.frame.size.width/3.5, height: (self.frame.size.height/1.2))
            mSeatingLabel.font = UIFont(name: helveticaBold, size: 18)
            
            
            mSeatingAlertImageView.frame = CGRect(x: mSeatingLabel.frame.origin.x - 30, y: 13, width: 20, height: 20)
            
            
            mDifferenceTimeLabel.frame = CGRect(x: mClassName.frame.origin.x  + mClassName.frame.size.width + 20, y: 10, width: self.frame.size.width/4 , height: (self.frame.size.height/1.2))
            mDifferenceTimeLabel.font = UIFont(name: helveticaRegular, size: 18)
            
            
            
        }
        circleImage.layer.cornerRadius = circleImage.frame.size.width/2
        circleImage.layer.masksToBounds = true
        
    }
    
    
    func OverDueSessionIsWithDetails(_ details:AnyObject)
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        var _string :String = ""
        let currentDate = Date()
        _string = _string.stringFromTimeInterval(currentDate.timeIntervalSince(dateFormatter.date(from: (sessionDetails.object(forKey: "StartTime") as! String))!)).fullString
        
        mDifferenceTimeLabel.text = "Overdue: \(_string)"
        
        
        self.backgroundColor = standard_Red
        mSeatingAlertImageView.image = UIImage(named: "Blue_Alert.png")
        mSeatingLabel.textColor = UIColor.white
        
        overDueTimer.invalidate()
        nextSessionTimer.invalidate()
        
        overDueTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(ScheduleScreenTile.updateOverdueSession), userInfo: nil, repeats: true)
    }
    
    
    func updateOverdueSession()
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        var _string :String = ""
        let currentDate = Date()
        _string = _string.stringFromTimeInterval(currentDate.timeIntervalSince(dateFormatter.date(from: (sessionDetails.object(forKey: "StartTime") as! String))!)).fullString
        
        mDifferenceTimeLabel.text = "Overdue: \(_string)"
        
        
        
        
        if let endTime = sessionDetails.object(forKey: "EndTime") as? String
        {
            let isGreater = currentDate.isGreaterThanDate((dateFormatter.date(from: endTime)!))
            
            let isEqual = currentDate == (dateFormatter.date(from: endTime)!)
            
            if isGreater == true || isEqual == true
            {
                if delegate().responds(to: #selector(ScheduleScreenTileDelegate.delegateRefreshSchedule))
                {
                    delegate().delegateRefreshSchedule!()
                }
            }
            
            
        }
        
    }
    
    
    
    func nextSessionUpdatingWithdetails(_ details:AnyObject)
    {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        var _string :String = ""
        let currentDate = Date()
        _string = _string.stringFromTimeInterval(dateFormatter.date(from: (sessionDetails.object(forKey: "StartTime") as! String))!.timeIntervalSince(currentDate)).fullString
        
        mDifferenceTimeLabel.text = "Starts in about: \(_string)"
        
        overDueTimer.invalidate()
        nextSessionTimer.invalidate()
        nextSessionTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(ScheduleScreenTile.updateNextSession), userInfo: nil, repeats: true)
        
        
        let differenceMinutes  = currentDate.minutesAndSecondsDiffernceBetweenDates(currentDate, endDate: dateFormatter.date(from: sessionDetails.object(forKey: "StartTime") as! String)!)
        
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
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        var _string :String = ""
        let currentDate = Date()
        _string = _string.stringFromTimeInterval(dateFormatter.date(from: (sessionDetails.object(forKey: "StartTime") as! String))!.timeIntervalSince(currentDate)).fullString
        
        mDifferenceTimeLabel.text = "Starts in about: \(_string)"
        
        
        
        let differenceMinutes  = currentDate.minutesAndSecondsDiffernceBetweenDates(currentDate, endDate: dateFormatter.date(from: sessionDetails.object(forKey: "StartTime") as! String)!)
        
        
        if differenceMinutes.second <= 0
        {
            let isLesserValue = currentDate.isGreaterThanDate(dateFormatter.date(from: sessionDetails.object(forKey: "StartTime") as! String)!)
            
            if isLesserValue == true
            {
                overDueTimer.invalidate()
                nextSessionTimer.invalidate()
                alertTimeValue = alertExtendingMunites
                if delegate().responds(to: #selector(ScheduleScreenTileDelegate.delegateRefreshSchedule))
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
            if delegate().responds(to: #selector(ScheduleScreenTileDelegate.delegateRefreshSchedule))
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
                if delegate().responds(to: #selector(ScheduleScreenTileDelegate.delegateRefreshSchedule))
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
