//
//  UserModel.swift
//  LearniatStudent
//
//  Created by Deepak on 7/1/17.
//  Copyright © 2017 administrator. All rights reserved.
//

import Foundation
import RealmSwift
import ObjectMapper
class UserDataModel: Object,Mappable
{
    
    
    @objc dynamic var userId: Int = 0
    @objc dynamic var userName:String?
    @objc dynamic var SchoolId:Int = 0
    @objc dynamic var userState:Int = 0
    @objc dynamic var screenState:Int = 0
    
    //Impl. of Mappable protocol
    required convenience init?(map: Map) {
        self.init()
    }
    
    
    // Specify properties to ignore (Realm won't persist these)
    
    //  override static func ignoredProperties() -> [String] {
    //    return []
    //  }
    
    override static func primaryKey() -> String? {
        return "userId"
    }
    
    
    func mapping(map: Map) {
        userId >>> map[kUserId]
    }
    
    
    
    func setUserModelWithJsonData(json:[String:Any]) {
        let map = Map(mappingType: .fromJSON, JSON: json )
        if userId == 0 {
            userId <- map[kUserId]
        }
        SchoolId <- map[kSchoolId]
        userName <- map[kUserName]
        userState <- map[kExisting_state]
    }
    
    func saveScreenState(state:PresentScreen) {
        screenState = state.rawValue
        updateUserStateWithScreenState(screenState: state.rawValue)
       
        var previousState:Int = PresentScreen.LoginScreen.rawValue
        let userstateModel = RealmManager.shared.realm.objects(userStateTransaction.self)
        
        if userstateModel.count > 0  {
            let lastTransaction = userstateModel.last
            previousState = (lastTransaction?.currentState)!
        }
        
        let userTransactionModel = userStateTransaction()
        userTransactionModel.saveNewTranscation(_state: state.rawValue, _previousState: previousState,withUserId:userId)
        RealmManager.shared.realm.create(userStateTransaction.self, value: userTransactionModel as Any, update: true)

    }
    
    
    private func updateUserStateWithScreenState(screenState:Int) {
        switch screenState {
        case PresentScreen.ScheduleScreen.rawValue ,PresentScreen.JoinScreen.rawValue :
            userState = UserStateInt.Free.rawValue
            break
        case PresentScreen.LiveScreen.rawValue :
            userState = UserStateInt.Live.rawValue
            break
        case PresentScreen.LiveBackground.rawValue :
            userState = UserStateInt.BackGround.rawValue
            break
        case PresentScreen.waitingForTeacherScreen.rawValue :
            userState = UserStateInt.Occupied.rawValue
            break

        default:
            userState = UserStateInt.Free.rawValue
        }
    }
}
