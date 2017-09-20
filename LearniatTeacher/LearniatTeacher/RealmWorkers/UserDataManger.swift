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
    
    
    func saveUserDataWithJsonData(userValue:AnyObject)
    {
        
        var user : UserDataModel!
        
        do {
            try RealmManager.shared.realm.write({
                if let userModel = RealmManager.shared.realm.object(ofType: UserDataModel.self, forPrimaryKey: userValue.value(forKey: kUserId))
                {
                    user = userModel
                }
                else
                {
                    user = UserDataModel()
                }
                
                
                user.setUserModelWithJsonData(json: userValue as! [String : Any])
                RealmManager.shared.realm.create(UserDataModel.self, value: user as Any, update: true)
            })
        } catch
        {
            
        }
    }
}
