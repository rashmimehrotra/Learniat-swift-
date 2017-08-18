//
//  Topic.swift
//  LearniatStudent
//
//  Created by Sourabh on 13/08/17.
//  Copyright © 2017 Mindshift. All rights reserved.
//

import Foundation
import EVReflection

public class TopicState{
    public static var Started = "Started"
    public static var Ended = "Ended"
}

public class Topic: EVObject{
    var topicId:String = ""
    var topicState:String = TopicState.Started
    var topicName:String = ""
    
    
     required public init() {
        super.init()
    }
    
    public init(topicId:String, topicState:String, topicName:String){
        self.topicId = topicId
        self.topicName = topicName
        self.topicState = topicState
    }
    
    
}
