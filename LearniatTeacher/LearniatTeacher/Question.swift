//
//  Question.swift
//  LearniatStudent
//
//  Created by Sourabh on 13/08/17.
//  Copyright © 2017 Mindshift. All rights reserved.
//

import Foundation
import EVReflection


public class QuestionState{
    public static let Started = "Started"
    public static let Ended = "Ended"
    public static let Frozen = "Frozen"
}


public class Question : EVObject{
    
    public required convenience init() {
        self.init()
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
