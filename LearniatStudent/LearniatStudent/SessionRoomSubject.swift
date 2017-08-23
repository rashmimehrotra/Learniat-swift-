//
//  SessionRoomSubject.swift
//  LearniatStudent
//
//  Created by Sourabh on 13/08/17.
//  Copyright © 2017 Mindshift. All rights reserved.
//

import Foundation
import Signals
import ObjectMapper

public class SubjectSessionState{
    public static var Open = "OPEN"
    public static var Begin = "BEGIN"
    public static var Ended = "ENDED"
    public static var Cancelled = "CANCELLED"
    public static var Scheduled = "SCHEDULED"
}


public class SessionRoomSubject: Mappable, RoomSubjectProtocol{
    
    var topic:Topic!
    var isStateChanged:Bool = false
    var roomId:String = ""
    var sessionState:String = SubjectSessionState.Scheduled
    let topicChanged = Signal<Topic>()
    let topicStateChanged = Signal<Topic>()
    let sessionStateChanged = Signal<(roomId:String, sessionState:String)>()
    
    required convenience public init?(map: Map)
    {
        self.init()
        
    }
    
    public init(){
        
    }
    
    public func mapping(map: Map) {
        self.topic      <- map[XMPPModelConstants.kTopic]
        self.isStateChanged <- map[XMPPModelConstants.kIsStateChanged]
        self.roomId <- map[XMPPModelConstants.kRoomId]
        self.sessionState <- map[XMPPModelConstants.kSessionState]
    }
    
  
   
    
    
    public init(topicId: String, topicName: String, topicState: String, roomId:String, isStateChanged:Bool, sessionState:String){
        var topic:Topic = Topic(topicId:topicId, topicState:topicState, topicName:topicName)
        self.topic = topic
        self.roomId = roomId
        self.isStateChanged = isStateChanged
        self.sessionState = sessionState
    }
    
    
    public func setRoomSubject(json:String){
        let map = Map(mappingType: .fromJSON, JSON: (json.parseJSONString.jsonData as! [String: Any]) )
        
        
        let newRoomSubject:SessionRoomSubject = SessionRoomSubject()
        newRoomSubject.topic <- map[XMPPModelConstants.kTopic]
        newRoomSubject.roomId <- map[XMPPModelConstants.kRoomId]
        newRoomSubject.isStateChanged <- map[XMPPModelConstants.kIsStateChanged]
        newRoomSubject.sessionState <- map[XMPPModelConstants.kSessionState]
        
        //TODO: This part to be moved, when sigleton architecture comes
        // Instead setter will set global singleton
        objc_sync_enter(self)
        signalChanges(oldRoomSubject: self, newRoomSubject: newRoomSubject)
        self.topic = newRoomSubject.topic
        self.isStateChanged = newRoomSubject.isStateChanged
        self.roomId = newRoomSubject.roomId
        self.sessionState = newRoomSubject.sessionState
        objc_sync_exit(self)
    }
    
    
    
    //TODO: This part to be moved, when sigleton architecture comes
    func signalChanges(oldRoomSubject:SessionRoomSubject, newRoomSubject:SessionRoomSubject){
        if oldRoomSubject.topic.topicId != newRoomSubject.topic.topicId && newRoomSubject.topic.topicId != "" {
            topicChanged.fire(newRoomSubject.topic)
        }
        else if oldRoomSubject.topic.topicState != newRoomSubject.topic.topicState{
            topicStateChanged.fire(newRoomSubject.topic)
        }
        if newRoomSubject.isStateChanged == true{
            sessionStateChanged.fire((roomId:self.roomId,sessionState:newRoomSubject.sessionState))
        }
    }
    
    
    public func getRoomSubject() -> String{
        return self.toJSONString()!
    }
    
    public func getRoomUrl() -> String{
        return "room_\(self.roomId)@conference.\(SSStudentMessageHandler.sharedMessageHandler.kBaseXMPPURL)"
    }
    
    
}
