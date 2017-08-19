//
//  RoomSubject.swift
//  LearniatStudent
//
//  Created by Sourabh on 13/08/17.
//  Copyright © 2017 Mindshift. All rights reserved.
//

import Foundation
import EVReflection
import Signals

public class QuestionRoomSubject: EVObject, RoomSubjectProtocol{
     /// This function can be used to validate JSON prior to mapping. Return nil to cancel mapping at this point
   
    var question:Question
    var roomId:String = ""
    
    let questionChanged = Signal<Question>()
    let questionStateChanged = Signal<Question>()
    
    public convenience required init(){
        self.init()
    }
    

    public init(questionId: String, questionType: String, questionState: String, roomId:String){
        var question:Question = Question(questionId: questionId, questionState: questionState, questionType: questionType)
        self.question = question
        self.roomId = roomId
    }
    
    
    public func setRoomSubject(json:String){
        let newRoomSubject:QuestionRoomSubject = QuestionRoomSubject(json: json)
        
        //TODO: This part to be moved, when sigleton architecture comes
        // Instead setter will set global singleton
        objc_sync_enter(self)
        signalChanges(oldRoomSubject: self, newRoomSubject: newRoomSubject)
        self.question = newRoomSubject.question
        self.roomId = newRoomSubject.roomId
        objc_sync_exit(self)
        
        
    }
    
    
    //TODO: This part to be moved, when sigleton architecture comes
    func signalChanges(oldRoomSubject:QuestionRoomSubject, newRoomSubject:QuestionRoomSubject){
        if oldRoomSubject.question.questionId != newRoomSubject.question.questionId{
            questionChanged.fire(newRoomSubject.question)
        }
        else if oldRoomSubject.question.questionState != newRoomSubject.question.questionState{
            questionStateChanged.fire(newRoomSubject.question)
        }
    }
    
    
    public func getRoomSubject() -> String{
        return self.toJsonString()
    }
    
    public func getRoomUrl() -> String{
        return "question_\(self.roomId)@conference.\(SSTeacherMessageHandler.sharedMessageHandler.kBaseXMPPURL)"
    }

    
    
}
