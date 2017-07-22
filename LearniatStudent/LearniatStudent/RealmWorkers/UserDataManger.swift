//
//  UserDataManger.swift
//  LearniatStudent
//
//  Created by Deepak on 7/1/17.
//  Copyright © 2017 administrator. All rights reserved.
//

import Foundation
import ObjectMapper
import RealmSwift


class UserDataManager: NSObject
{
    override init() {  }
    
    
    func saveUserDataWithJsonData(userValue:AnyObject, withscreenState state:PresentScreen) {
        var user : UserDataModel!
        do {
            try RealmManager.shared.realm.write({
                if let userModel = RealmManager.shared.realm.object(ofType: UserDataModel.self, forPrimaryKey: userValue[kUserId]) {
                    user = userModel
                } else {
                    user = UserDataModel()
                }
                user.setUserModelWithJsonData(json: userValue as! [String : Any])
                user.saveScreenState(state: state)
                RealmManager.shared.realm.create(UserDataModel.self, value: user as Any, update: true)
            })
        } catch
        {
            
        }
    }
    
    
    
    func saveUserScreenState(userID:String, withscreenState state:PresentScreen) {
        do {
            try RealmManager.shared.realm.write({
                if let userModel = RealmManager.shared.realm.object(ofType: UserDataModel.self, forPrimaryKey: Int(userID)) {
                    userModel.saveScreenState(state: state)
                    RealmManager.shared.realm.create(UserDataModel.self, value: userModel as Any, update: true)
                }
            })
        } catch {
            
        }
    }
    
    
    func checkforBackgroundAndUpdateState(userID:String, withscreenState currentState:PresentScreen) {
        
        do {
            try RealmManager.shared.realm.write({
                if let userModel = RealmManager.shared.realm.object(ofType: UserDataModel.self, forPrimaryKey: Int(userID)) {
                    if userModel.screenState == PresentScreen.LiveScreen.rawValue , userModel.screenState == PresentScreen.LiveBackground.rawValue {
                       userModel.saveScreenState(state: currentState)
                    }
                    RealmManager.shared.realm.create(UserDataModel.self, value: userModel as Any, update: true)
                } })
        } catch {
            
        }
        
    }
    
}