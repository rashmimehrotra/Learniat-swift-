//
//  TimeTableModel.swift
//  LearniatStudent
//
//  Created by Deepak on 7/1/17.
//  Copyright © 2017 administrator. All rights reserved.
//

import Foundation
import RealmSwift
import ObjectMapper



class TimeTableModel: Object,Mappable
{
    
    
    dynamic var SessionId: Int = 0
    dynamic var TeacherName:String?
    dynamic var TeacherId:Int = 0
    dynamic var ClassId:Int = 0
    dynamic var ClassName :String?
    dynamic var RoomName :String?
    dynamic var RoomId:String?
    dynamic var SubjectName:String?
    dynamic var SubjectId:Int = 0
    dynamic var StartTime:String?
    dynamic var EndTime :String?
    dynamic var SessionState:Int = 0
    dynamic var SeatsConfigured:Int = 0
    dynamic var StudentsRegistered:Int = 0
    dynamic var PreallocatedSeats:Int = 0
    
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
        return "SessionId"
    }
    
    
    func mapping(map: Map)
    {
        
        
        
    }
    
    
    
    func setTimeTableModelWithJsonData(json:[String:Any])
    {
        let map = Map(mappingType: .fromJSON, JSON: json )
        
        if SessionId == 0
        {
            SessionId <- map[kSessionId]
        }
        
        
        TeacherName     <- map[kTeacherName]
        TeacherId       <- map[kTeacherId]
        ClassId         <- map[kClassId]
        ClassName       <- map[kClassName]
        RoomName        <- map[kRoomName]
        RoomId          <- map[kRoomId]
        SubjectName     <- map[kSubjectName]
        SubjectId       <- map[kSubjectId]
        StartTime       <- map[kStartTime]
        EndTime         <- map[kEndTime]
        SessionState    <- map[kSessionState]
        SeatsConfigured <- map[kSeatsConfigured]
        StudentsRegistered  <- map[kStudentsRegistered]
        PreallocatedSeats   <- map[kPreallocatedSeats]
       
        
        
        
    }
    
}
