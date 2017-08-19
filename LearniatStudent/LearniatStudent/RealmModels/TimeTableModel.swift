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
    dynamic var RoomId:Int = 0
    dynamic var SubjectName:String?
    dynamic var SubjectId:Int = 0
    dynamic var StartTime:String?
    dynamic var EndTime :String?
    dynamic var SessionState:Int = 0
    dynamic var SeatsConfigured:Int = 0
    dynamic var StudentsRegistered:Int = 0
    dynamic var PreallocatedSeats:Int = 0
    
    //Impl. of Mappable protocol
    required convenience init?(map: Map) {
        self.init()
    }
    
    // Specify properties to ignore (Realm won't persist these)
    //  override static func ignoredProperties() -> [String] {
    //    return []
    //  }
    
    override static func primaryKey() -> String? {
        return "SessionId"
    }
    
    func mapping(map: Map){
        SessionId           >>> map[RAPIConstants.SessionID.rawValue]
        TeacherName         >>> map[RAPIConstants.TeacherName.rawValue]
        TeacherId           >>> map[RAPIConstants.TeacherId.rawValue]
        ClassId             >>> map[RAPIConstants.ClassId.rawValue]
        ClassName           >>> map[RAPIConstants.ClassName.rawValue]
        RoomName            >>> map[RAPIConstants.RoomName.rawValue]
        RoomId              >>> map[RAPIConstants.RoomId.rawValue]
        SubjectName         >>> map[RAPIConstants.SubjectName.rawValue]
        SubjectId           >>> map[RAPIConstants.SubjectId.rawValue]
        StartTime           >>> map[RAPIConstants.StartTime.rawValue]
        EndTime             >>> map[RAPIConstants.endTime.rawValue]
        SessionState        >>> map[RAPIConstants.SessionState.rawValue]
        SeatsConfigured     >>> map["SeatsConfigured"]
        StudentsRegistered  >>> map["stud_regist"]
        PreallocatedSeats   >>> map[RAPIConstants.PreAllocatedSeats.rawValue]
    }
    
    func setTimeTableModelWithJsonData(json:[String:Any]) {
        let map = Map(mappingType: .fromJSON, JSON: json )
        SessionId <- map[RAPIConstants.SessionID.rawValue]
    }
    
    func updateTimeTableModelWithJsonData(json:[String:Any]) {
        let map = Map(mappingType: .fromJSON, JSON: json )
        TeacherName     <- map[RAPIConstants.TeacherName.rawValue]
        TeacherId       <- map[RAPIConstants.TeacherId.rawValue]
        ClassId         <- map[RAPIConstants.ClassId.rawValue]
        ClassName       <- map[RAPIConstants.ClassName.rawValue]
        RoomName        <- map[RAPIConstants.RoomName.rawValue]
        RoomId          <- map[RAPIConstants.RoomId.rawValue]
        SubjectName     <- map[RAPIConstants.SubjectName.rawValue]
        SubjectId       <- map[RAPIConstants.SubjectId.rawValue]
        StartTime       <- map[RAPIConstants.StartTime.rawValue]
        EndTime         <- map[RAPIConstants.endTime.rawValue]
        SessionState    <- map[RAPIConstants.SessionState.rawValue]
        SeatsConfigured <- map["SeatsConfigured"]
        StudentsRegistered  <- map["stud_regist"]
        PreallocatedSeats   <- map[RAPIConstants.PreAllocatedSeats.rawValue]
    }
    
    func getJsonFromModel() ->AnyObject {
        return self.toJSON() as AnyObject
    }
}
