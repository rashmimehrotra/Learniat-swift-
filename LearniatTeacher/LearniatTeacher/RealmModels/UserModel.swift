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
    
    
    dynamic var userId: Int = 0
    dynamic var userName:String?
    dynamic var SchoolId:Int = 0
    dynamic var userState:Int = 0
    
    
    //Impl. of Mappable protocol
    required convenience init?(map: Map)
    {
        self.init()
    }
    
    
    // Specify properties to ignore (Realm won't persist these)
    
    //  override static func ignoredProperties() -> [String] {
    //    return []
    //  }
    
    override static func primaryKey() -> String?
    {
        return "userId"
    }
    
    
    func mapping(map: Map)
    {
        userId >>> map[kUserId]
        
      
        
    }
    
    
    
    func setUserModelWithJsonData(json:[String:Any])
    {
        let map = Map(mappingType: .fromJSON, JSON: json )
        
        if userId == 0
        {
            userId <- map[kUserId]
        }
        
        SchoolId <- map[kSchoolId]
        userName <- map[kUserName]
        userState <- map[kExisting_state]
        
      
        
    }
    
}
