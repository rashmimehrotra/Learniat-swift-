//
//  Question.swift
//  LearniatStudent
//
//  Created by Sourabh on 13/08/17.
//  Copyright © 2017 Mindshift. All rights reserved.
//

import Foundation
import ObjectMapper


public class QuestionState{
    public static let Started = "Started"
    public static let Ended = "Ended"
    public static let Frozen = "Frozen"
}


public class Question : NSObject, Mappable{
    
    
    required convenience public init?(map: Map)
    {
        self.init()
        
    }
    
    public override init(){
        
    }
    
    public func mapping(map: Map) {
        self.questionId      >>> map[XMPPModelConstants.kQuestionId]
        self.questionState >>> map[XMPPModelConstants.kQuestionState]
        self.questionType >>> map[XMPPModelConstants.kQuestionType]
    }
    
    
    public init(questionId:String, questionState:String, questionType:String) {
        self.questionId = questionId
        self.questionType = questionType
        self.questionState = questionState
    }
    
    
    var questionId:String = ""
    var questionState:String = QuestionState.Started
    var questionType:String = ""
    
    
    
    
    
}
