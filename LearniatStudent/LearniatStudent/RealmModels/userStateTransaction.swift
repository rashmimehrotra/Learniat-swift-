//
//  userStateTransaction.swift
//  LearniatStudent
//
//  Created by Deepak on 7/15/17.
//  Copyright © 2017 Mindshift. All rights reserved.
//

import Foundation
import RealmSwift
import ObjectMapper
class userStateTransaction: Object,Mappable
{
    @objc dynamic var primeryKey = 0
    @objc dynamic var userId = 0
    @objc dynamic var previousState:Int = 0
    @objc dynamic var currentState:Int = 0
    @objc dynamic var timeStamp:String?
    //Impl. of Mappable protocol
    required convenience init?(map: Map) {
        self.init()
    }
    
    
    // Specify properties to ignore (Realm won't persist these)
    
    //  override static func ignoredProperties() -> [String] {
    //    return []
    //  }
    
    override static func primaryKey() -> String? {
        return "primeryKey"
    }
    
    func mapping(map: Map) {

    }
    
    
    func saveNewTranscation(_state:Int, _previousState:Int, withUserId _userId:Int) {
        currentState = _state
        previousState = _previousState
        timeStamp = getCurrentTime()
        incrementPrimeryKey()
        userId = _userId
    }
    
    
    func incrementPrimeryKey() {
         let  counts =  RealmManager.shared.realm.objects(userStateTransaction.self).count
        primeryKey = counts + 1
        
    }
    
    func getCurrentTime()->String {
        let date = Date()
        let calendar = Calendar.current
        
        let hour = calendar.component(.hour, from: date)
        let minutes = calendar.component(.minute, from: date)
        let seconds = calendar.component(.second, from: date)
        return("\(hour):\(minutes):\(seconds)")
    }
    
}
