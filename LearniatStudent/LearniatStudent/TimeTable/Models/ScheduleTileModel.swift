//
//  ScheduleTileModel.swift
//  Learniat Teacher
//
//  Created by Deepak on 8/6/17.
//  Copyright © 2017 MBRDI. All rights reserved.
//

import Foundation
import ObjectMapper
class ScheduleTileModel: Mappable {
    var SessionId = 0
    var TeacherName:String?
    var SubjectName:String?
    var SubjectId = 0
    var ClassName:String?
    var StartTime:String?
    var EndTime:String?
    var SessionState = 0
    var RoomName:String?
    var SeatsConfigured = 0
    var StudentsRegistered = 0
    var PreAllocatedSeats = 0
    var OccupiedSeats = 0
    var Grade = 0
    
    
    required init?(map: Map) {
        
    }
    func mapping(map: Map) {
        
    }
    
    func setScheduleTileModelWithJsonData(json:[String:Any]) {
        let map = Map(mappingType: .fromJSON, JSON: json)
        SessionId <- map[kSessionId]
        TeacherName <- map[kTeacherName]
        SubjectName <- map[kSubjectName]
        SubjectId <- map[kSubjectId]
        ClassName <- map[kClassName]
        StartTime <- map[kStartTime]
        EndTime <- map[kEndTime]
        SessionState <- map[kSessionState]
        RoomName <- map[kRoomName]
        SeatsConfigured <- map[kSeatsConfigured]
        StudentsRegistered <- map[kStudentsRegistered]
        PreAllocatedSeats <- map[kPreAllocatedSeats]
        OccupiedSeats <- map[kOccupiedSeats]
        Grade <- map[kGrade]
    }
}
