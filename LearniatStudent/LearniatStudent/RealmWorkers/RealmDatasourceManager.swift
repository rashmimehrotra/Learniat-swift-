//
//  RealmDatasourceManager.swift
//  LearniatStudent
//
//  Created by Deepak on 7/15/17.
//  Copyright © 2017 Mindshift. All rights reserved.
//

import Foundation
class RealmDatasourceManager: NSObject {
    
    
    static func saveUserDetailsWithJsonData(jsonVlaue:AnyObject, withScreenState state:PresentScreen) {
        UserDataManager().saveUserDataWithJsonData(userValue: jsonVlaue,withscreenState: state)
    }
    
    static func saveScreenStateOfUser(screenState:PresentScreen, withUserId userID:String) {
        UserDataManager().saveUserScreenState(userID: userID, withscreenState: screenState)
    }
    
    static func checkForLiveAndupdateStateToLive(screenState:PresentScreen, withUserId userID:String) {
       UserDataManager().checkforBackgroundAndUpdateState(userID: userID, withscreenState: screenState)
    }
    
    static func getUserModel()->UserDataModel {
        let userModel = RealmManager.shared.realm.objects(UserDataModel.self).first!
        return userModel
    }
    
    static func saveTimeTableWithJsonData(data:NSArray) {
        TimeTableDataManager().saveTimeTableDataWithJsonData(timeTableArray: data)
    }
    
    static func getTimeTables()->[TimeTableModel] {
        return TimeTableDataManager().getTodaySchedules()
    }
    
    static func updateSessionStateWithSessionId(sessionID:Int, withSessionState state:Int) {
       try! RealmManager.shared.realm.write {
            let session = RealmManager.shared.realm.object(ofType: TimeTableModel.self, forPrimaryKey: sessionID)
            session?.SessionState = state
        }
    }
}
