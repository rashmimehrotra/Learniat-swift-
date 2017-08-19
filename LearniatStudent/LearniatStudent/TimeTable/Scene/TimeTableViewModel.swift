//
//  TimeTableViewModel.swift
//  LearniatStudent
//
//  Created by Deepak on 8/7/17.
//  Copyright © 2017 Mindshift. All rights reserved.
//

import Foundation
class TimeTableViewModel: NSObject {
   
    /// This variable used to store the positions of each hour
    var positionsArray:Dictionary<String,CGFloat> = Dictionary()

    /// Load all schedule from server
    func loadSchedulesFromServer() {
        SSStudentDataSource.sharedDataSource.getTimeTableWithUserId(userID: SSStudentDataSource.sharedDataSource.currentUserId, withSuccessHandle: { (result) in
            if let arrayObjects = (result as AnyObject).object(forKey: RAPIConstants.SessionsHeader.rawValue) as? NSArray {
               RealmDatasourceManager.saveTimeTableWithJsonData(data: arrayObjects)
            }
        }) { (error) in
            print(error)
        }
    }
    
    /// This func will be used to refresh the status of App using refresh Api
    func refreshSchedules() {
        SSStudentDataSource.sharedDataSource.refreshApp(success: { (details) in
            self.evaluateRefreshedData(details: details)
        }) { (error) in
            
        }
    }
    
    /// This func returns the values from local table
    ///
    /// - Returns: Returns session tiles details from local DB
    func LoadSchedulesFromLocalServer()->[TimeTableModel] {
        return RealmDatasourceManager.getTimeTables()
    }
    
    /// This returns the position of every hour
    ///
    /// - Parameters:
    ///   - _hour: Input hour
    ///   - minute: Input minutes
    /// - Returns: Returning values
     func getPositionWithHour(_ _hour : Int, withMinute minute:Int) -> CGFloat {
        var  hour = _hour
        var returningValue = CGFloat()
        if hour < 0 {
            hour = 0
        }
        returningValue = positionsArray[(String("\(hour)"))]! + CGFloat(minute) * halfHourMultipleRatio
        return returningValue
    }
    
    /// This func returns the size of each tiles with using starting time and ending time
    ///
    /// - Parameters:
    ///   - startHour: Session start hour
    ///   - startMinute: Session start minute
    ///   - endHour: Session end hour
    ///   - endMinute: Session end minute
    /// - Returns: Returns size of each tile 
    func getSizeOfCalendarEvernWithStarthour(_ startHour: Int, withstartMinute startMinute:Int, withEndHour endHour:Int, withEndMinute endMinute:Int) -> CGFloat{
        let startPosition = getPositionWithHour(startHour, withMinute: startMinute)
        let endposition = getPositionWithHour(endHour, withMinute: endMinute)
        let sizeOfEvent = endposition - startPosition
        return sizeOfEvent
    }
    
    /// This func returns the string value for time
    ///
    /// - Parameter index: hour value
    /// - Returns: hour String 
    func getTimelabelWithIndexvalue(index:Int)->String {
       var hourString = "am"
        if index == 0 {
            hourString = "\(12) am"
        } else if index == 12 {
            hourString = "Noon"
        } else if index < 12 {
            hourString = "\(index) am"
        } else if index > 12 {
            hourString = "\(index - 12) pm"
        }
        return hourString
    }
}

// MARK: - This is used to evaluate the data came from refresh api
extension TimeTableViewModel {
    
    /// This func is used to update user and session state which is returned from the refresh API
    ///
    /// - Parameter details: Refresh API details
    func evaluateRefreshedData(details:AnyObject) {
        if let sessions = details.object(forKey: kAllSessions) as? NSArray {
            evaluateSessionsState(sessions: sessions)
        }
        
        if let Summary = details.object(forKey: kSummary) as? NSArray, Summary.count > 0  {
            evaluateSessionSummary(summary: Summary)
        }
    }
    
    /// This func is used to Evalate the session summary
    ///
    /// - Parameter summary: Session summary details
    func evaluateSessionSummary(summary:NSArray) {
        let details = summary.firstObject as AnyObject
        if let CurrentSessionState = details.object(forKey: "CurrentSessionState") as? Int{
            let currentSessionId:Int = (summary.value(forKey: "CurrentSessionId") as! NSArray)[0] as! Int
            SSStudentDataSource.sharedDataSource.currentLiveSessionId = String(currentSessionId)
            self.joinOrLeaveXMPPSessionRoom(sessionState:SessionState(rawValue: CurrentSessionState)!, roomName:String(describing:currentSessionId))
        }
        if let NextClassSessionState = details.object(forKey: "NextClassSessionState") as? Int{
            let nextSessionId:Int = (summary.value(forKey: "NextClassSessionId") as! NSArray)[0] as! Int
            self.joinOrLeaveXMPPSessionRoom(sessionState:SessionState(rawValue: NextClassSessionState)!, roomName:String(describing:nextSessionId))
        }
        
    }
    /// This func evaluates the sessions state sent from the Refresh API
    ///
    /// - Parameter sessions: Sessions
    func evaluateSessionsState(sessions:NSArray) {
        for case let session as AnyObject in sessions {
            if let sessionID = session.object(forKey: kClassSessionId) as? Int {
                if let sessionState = session.object(forKey: kSession_state) as? Int {
                    RealmDatasourceManager.updateSessionStateWithSessionId(sessionID: sessionID, withSessionState: sessionState)
                }
            }
        }
         SSStudentDataSource.sharedDataSource.TimeTableSaveSignal.fire(true)
    }
    
    
    /// This func will be used to add users to room
    ///
    /// - Parameters:
    ///   - sessionState: sessionState
    ///   - roomName:  Room name which needs t be joined
    func joinOrLeaveXMPPSessionRoom(sessionState: SessionState, roomName: String){
        if sessionState == .Live || sessionState == .Opened || sessionState == .Scheduled{
            SSStudentMessageHandler.sharedMessageHandler.createRoomWithRoomName(String(format:"room_%@",roomName), withHistory: "0")
        } else {
            SSStudentMessageHandler.sharedMessageHandler.checkAndRemoveJoinedRoomsArrayWithRoomid(String(format:"room_%@",roomName))
        }
    }
}

