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

    
}
