//
//  SessionRoomSubject.swift
//  LearniatStudent
//
//  Created by Sourabh on 13/08/17.
//  Copyright © 2017 Mindshift. All rights reserved.
//

import Foundation
import Signals
import EVReflection



public class SessionRoomSubject: EVObject, RoomSubjectProtocol{
    
    var topic:Topic!
    var isStateChanged:Bool = false
    var roomId:String = ""
    let topicChanged = Signal<Topic>()
    let topicStateChanged = Signal<Topic>()
    let sessionStateChanged = Signal<(String)>()
    
     required public init() {
        super.init()
    }
    
    public init(topicId: String, topicName: String, topicState: String, roomId:String, isStateChanged:Bool){
        var topic:Topic = Topic(topicId:topicId, topicState:topicState, topicName:topicName)
        self.topic = topic
        self.roomId = roomId
        self.isStateChanged = isStateChanged
    }
    
    
    public func setRoomSubject(json:String){
        let newRoomSubject:SessionRoomSubject = SessionRoomSubject(json:json)
        
        //TODO: This part to be moved, when sigleton architecture comes
        // Instead setter will set global singleton
        objc_sync_enter(self)
        signalChanges(oldRoomSubject: self, newRoomSubject: newRoomSubject)
        self.topic = newRoomSubject.topic
        self.isStateChanged = newRoomSubject.isStateChanged
        self.roomId = newRoomSubject.roomId
        objc_sync_exit(self)
    }
    
    
    
    //TODO: This part to be moved, when sigleton architecture comes
    func signalChanges(oldRoomSubject:SessionRoomSubject, newRoomSubject:SessionRoomSubject){
        if oldRoomSubject.topic.topicId != newRoomSubject.topic.topicId{
            topicChanged.fire(newRoomSubject.topic)
        }
        else if oldRoomSubject.topic.topicState != newRoomSubject.topic.topicState{
            topicStateChanged.fire(newRoomSubject.topic)
        }
        if newRoomSubject.isStateChanged == true{
            sessionStateChanged.fire((self.roomId))
        }
    }
    
    
    public func getRoomSubject() -> String{
        return self.toJsonString()
    }
    
    public func getRoomUrl() -> String{
        return "room_\(self.roomId)@conference.\(SSStudentMessageHandler.sharedMessageHandler.kBaseXMPPURL)"
    }
    
    
}
