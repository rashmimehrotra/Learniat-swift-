//
//  RoomSubject.swift
//  LearniatStudent
//
//  Created by Sourabh on 13/08/17.
//  Copyright © 2017 Mindshift. All rights reserved.
//

import Foundation
import Signals
import ObjectMapper


public class QuestionRoomSubject: Mappable, RoomSubjectProtocol{
    /// This function can be used to validate JSON prior to mapping. Return nil to cancel mapping at this point
    
    var question:Question!
    var roomId:String = ""
    
    let questionChanged = Signal<Question>()
    let questionStateChanged = Signal<Question>()
    
    

    required convenience public init?(map: Map)
    {
        self.init()

    }
    
    public init(){
        
    }
    
    public init(questionId: String, questionType: String, questionState: String, roomId:String){
        let question:Question = Question(questionId: questionId, questionState: questionState, questionType: questionType)
        self.question = question
        self.roomId = roomId
    }
    
    
    public func mapping(map: Map) {
        self.question      >>> map[XMPPModelConstants.KQuestion]
        self.roomId >>> map[XMPPModelConstants.kRoomId]
    }
    
    public func setRoomSubject(json:String){
        let map = Map(mappingType: .fromJSON, JSON: (json.parseJSONString.jsonData as! [String: Any]) )
        

        let newRoomSubject:QuestionRoomSubject = QuestionRoomSubject()
        newRoomSubject.question <- map[XMPPModelConstants.KQuestion]
        newRoomSubject.roomId <- map[XMPPModelConstants.kRoomId]
        //TODO: This part to be moved, when sigleton architecture comes
        // Instead setter will set global singleton
        objc_sync_enter(self)
        signalChanges(oldRoomSubject: self, newRoomSubject: newRoomSubject)
        self.question     = newRoomSubject.question
        self.roomId       = newRoomSubject.roomId
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
        return self.toJSONString()!
    }
    
    public func getRoomUrl() -> String{
        return "question_\(self.roomId)@conference.\(SSStudentMessageHandler.sharedMessageHandler.kBaseXMPPURL)"
    }
    
    
    
    
}
