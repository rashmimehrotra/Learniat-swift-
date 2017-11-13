//
//  CurrentSessionModel.swift
//  Learniat Teacher
//
//  Created by Deepak, Mk (623-Extern) on 12/11/17.
//  Copyright © 2017 Mindshift. All rights reserved.
//

import Foundation
enum SessionKey:String {
    case SessionID = "SessionId"
    case ClassName  = "ClassName"
    case StartTime  = "StartTime"
    case EndTime    = "EndTime"
    case RoomName   = "RoomName"
    case RoomId     = "RoomId"
}


class SessionModel: NSObject {
    var SessionID  = ""
    var ClassName  = ""
    var sessionStartTime  = ""
    var sessionEndTime  = ""
    var RoomID  = ""
    var RoomName  = ""
    
}
class CurrentSessionViewModel: NSObject {
    let _sessionModel = SessionModel()
    
    init(sessionDetails:AnyObject) {
        super.init()
        
        self.setSessionDetails(currentSessionDetails: sessionDetails)
    }
    
    func getClassName() -> String {
         return "\(_sessionModel.ClassName)(R:\(_sessionModel.RoomName))"
    }
    
    func getClassProgressTime() -> CGFloat {
        let  StartTime = _sessionModel.sessionStartTime
        let  EndTime = _sessionModel.sessionEndTime
        
        let currentDate = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        var totalminutes = currentDate.minutesDiffernceBetweenDates(dateFormatter.date(from: StartTime)!, endDate: dateFormatter.date(from: EndTime )!)
        totalminutes = totalminutes * 60
        
        var minutesCovered = currentDate.minutesDiffernceBetweenDates(dateFormatter.date(from: StartTime )!, endDate:currentDate )
        minutesCovered = minutesCovered * 60
        
        let progressValue :CGFloat = CGFloat(minutesCovered) / CGFloat(totalminutes)
        return progressValue
    }
    

    func getRemainClassTime() ->Int {
        let currentDate = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let  EndTime = _sessionModel.sessionEndTime
        let remainingMinutes = currentDate.minutesDiffernceBetweenDates(currentDate, endDate: dateFormatter.date(from: EndTime)!)
        return remainingMinutes
    }
    
    
    
    func getStartTimeLabelText() -> String {
        let currentDate = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let startTime = _sessionModel.sessionStartTime.stringFromTimeInterval(currentDate.timeIntervalSince(dateFormatter.date(from: _sessionModel.sessionStartTime)!)).fullString
        return "Started : \(startTime)"
    }
    
    
    func getEndTimeLabelText()->String {
        let  EndTime = _sessionModel.sessionEndTime
        
        let currentDate = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
       
        let hrsPerMinute = hmsFrom(seconds: currentDate.secondsDiffernceBetweenDates(currentDate, endDate:dateFormatter.date(from: EndTime )! ))
        let minutes = self.getStringFrom(seconds: hrsPerMinute.minutes)
        let seconds = self.getStringFrom(seconds: hrsPerMinute.seconds)
        return "\(minutes):\(seconds)"
    }
    
    
    
}


extension CurrentSessionViewModel {
    fileprivate func setSessionDetails(currentSessionDetails:AnyObject) {
        
        if let sessionid = currentSessionDetails.object(forKey: SessionKey.SessionID.rawValue) as? String {
            _sessionModel.SessionID = sessionid
        }
        
        if let className = currentSessionDetails.object(forKey: SessionKey.ClassName.rawValue) as? String {
            _sessionModel.ClassName = className
        }
        
        if let  StartTime = currentSessionDetails.object(forKey: SessionKey.StartTime.rawValue) as? String {
            _sessionModel.sessionStartTime = StartTime
        }
        
        if let  EndTime = currentSessionDetails.object(forKey: SessionKey.EndTime.rawValue) as? String {
            _sessionModel.sessionEndTime = EndTime
        }
        
        if let roomName = currentSessionDetails.object(forKey: SessionKey.RoomName.rawValue) as? String {
            _sessionModel.RoomName = roomName
        }
        
        if let roomID  = currentSessionDetails.object(forKey: SessionKey.RoomId.rawValue) as? String {
            _sessionModel.RoomID = roomID
        } 
    }
    
    fileprivate func hmsFrom(seconds: Int)->(hours: Int, minutes: Int, seconds: Int) {
        
        return (seconds / 3600, (seconds % 3600) / 60, (seconds % 3600) % 60)
        
    }
    
    fileprivate func getStringFrom(seconds: Int) -> String {
        
        return seconds < 10 ? "0\(seconds)" : "\(seconds)"
    }

}
