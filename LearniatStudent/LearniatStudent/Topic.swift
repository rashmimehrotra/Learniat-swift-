//
//  Topic.swift
//  LearniatStudent
//
//  Created by Sourabh on 13/08/17.
//  Copyright © 2017 Mindshift. All rights reserved.
//

import Foundation
import ObjectMapper

public class TopicState{
    public static var Started = "Started"
    public static var Ended = "Ended"
}

public class Topic: NSObject, Mappable{
    var topicId:String = ""
    var topicState:String = TopicState.Started
    var topicName:String = ""
    
    
    required convenience public init?(map: Map)
    {
        self.init()
        self.topicId     <-  map[XMPPModelConstants.kTopicId]
        self.topicState <- map[XMPPModelConstants.kTopicState]
        self.topicName <- map[XMPPModelConstants.kTopicName]
        
    }
    
    public override init(){
        
    }
    
    public func mapping(map: Map) {
        self.topicId      >>> map[XMPPModelConstants.kTopicId]
        self.topicState >>> map[XMPPModelConstants.kTopicState]
        self.topicName >>> map[XMPPModelConstants.kTopicName]
    }
    
    
    public init(topicId:String, topicState:String, topicName:String){
        self.topicId = topicId
        self.topicName = topicName
        self.topicState = topicState
    }
    
    
}
