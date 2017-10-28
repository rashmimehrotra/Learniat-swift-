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
    
    
    @objc dynamic var SessionId: Int = 0
    @objc dynamic var TeacherName:String?
    @objc dynamic var TeacherId:Int = 0
    @objc dynamic var ClassId:Int = 0
    @objc dynamic var ClassName :String?
    @objc dynamic var RoomName :String?
    @objc dynamic var RoomId:String?
    @objc dynamic var SubjectName:String?
    @objc dynamic var SubjectId:Int = 0
    @objc dynamic var StartTime:String?
    @objc dynamic var EndTime :String?
    @objc dynamic var SessionState:Int = 0
    @objc dynamic var SeatsConfigured:Int = 0
    @objc dynamic var StudentsRegistered:Int = 0
    @objc dynamic var PreallocatedSeats:Int = 0
    
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
