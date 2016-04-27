//
//  StudentAnswerSelectionView.swift
//  LearniatTeacher
//
//  Created by mindshift_Deepak on 26/04/16.
//  Copyright © 2016 Mindshift. All rights reserved.
//

import Foundation
let kServiceSendAnswer   =   "SendAnswer"

@objc protocol StudentAnswerSelectionViewDelegate
{
    
    
    optional func delegateStudentAnswerRecievedWithDetails(answerId:String, withStudentid stundentId:String)
    
    
    
}


class StudentAnswerSelectionView: UIView,APIManagerDelegate
{
    
    var _currentQuestionDetails :AnyObject!
    var _currentStudentDetails  :AnyObject!
    
    
    var _delgate: AnyObject!
    
    
    override init(frame: CGRect)
    {
        super.init(frame:frame)
        
        

    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setdelegate(delegate:AnyObject)
    {
        _delgate = delegate;
    }
    
    func   delegate()->AnyObject
    {
        return _delgate;
    }
    
    
    func setCurrentQuestionDetails(questionDetails:AnyObject, withCurrentStudentDetails studentDetail:AnyObject)
    {
        _currentQuestionDetails = questionDetails
        _currentStudentDetails = studentDetail
        selectMultipleOPtionsWithQuestionDetails(questionDetails)
    }
    
    
    
    
    
    
    
    
    func selectMultipleOPtionsWithQuestionDetails(questionDetails:AnyObject)
    {
        
        var optionArray = NSMutableArray()
        
        if let options = questionDetails.objectForKey("Options")
        {
            if let classCheckingVariable = options.objectForKey("Option")
            {
                if classCheckingVariable.isKindOfClass(NSMutableArray)
                {
                    optionArray = classCheckingVariable as! NSMutableArray
                }
                else
                {
                    optionArray.addObject(questionDetails.objectForKey("Options")!.objectForKey("Option")!)
                    
                }
            }
        }
        
        optionArray.shuffle()
        let optionSelectedArray = NSMutableArray()
        
        if optionArray.count > 0
        {
            var aRandomInt = Int.random(1...optionArray.count)
            
            if aRandomInt > optionArray.count
            {
                aRandomInt = 3
            }
            for index  in 0..<3
            {
                let optionDict = optionArray.objectAtIndex(index)
                if let questionOptionText = optionDict.objectForKey("OptionText") as? String
                {
                    optionSelectedArray.addObject(questionOptionText)
                }
            }
        }
        
        if optionSelectedArray.count > 0
        {
            let optionsString = optionSelectedArray.componentsJoinedByString(";;;")
            if let StudentId = _currentStudentDetails.objectForKey("StudentId") as? String
            {
                if let Type = _currentQuestionDetails.objectForKey("Type") as? String
                {
                    if SSTeacherDataSource.sharedDataSource.currentQuestionLogId != ""
                    {
                        if SSTeacherDataSource.sharedDataSource.isQuestionSent == true
                        {
                           sendAnswerWithOptionText(optionsString, witStudentId: StudentId, withQuestionLogId: SSTeacherDataSource.sharedDataSource.currentQuestionLogId, withQuestionType: Type)
                        }
                        
                    }
                   
                }
                
            }
            
            
            
        }
        
        
    }
    
    
    
    func sendAnswerWithOptionText(OptionText:String,witStudentId StudentId:String, withQuestionLogId QuestionLogId:String, withQuestionType type:String)
    {
        
        let manager = APIManager()
        
        let urlString = String(format: "%@<Sunstone><Action><Service>SendAnswer</Service><StudentId>%@</StudentId><OptionText>%@</OptionText><SessionId>%@</SessionId><QuestionLogId>%@</QuestionLogId><QuestionType>%@</QuestionType></Action></Sunstone>",URLPrefix,StudentId,OptionText,SSTeacherDataSource.sharedDataSource.currentLiveSessionId,QuestionLogId,type)
        
        manager.downloadDataURL(urlString, withServiceName: kServiceSendAnswer, withDelegate: self, withRequestType: eHTTPGetRequest)
    }
    
    
    
   
    
    
    func delegateDidGetServiceResponseWithDetails(dict: NSMutableDictionary!, WIthServiceName serviceName: String!)
    {
        if SSTeacherDataSource.sharedDataSource.isQuestionSent == true
        {
            let refinedDetails = dict.objectForKey(kSunstone)!.objectForKey(kSSAction)!
            
            
            if serviceName == kServiceSendAnswer
            {
                if let AssessmentAnswerId = refinedDetails.objectForKey("AssessmentAnswerId") as? String{
                    if delegate().respondsToSelector(#selector(StudentAnswerSelectionViewDelegate.delegateStudentAnswerRecievedWithDetails(_:withStudentid:)))
                    {
                        if let StudentId = _currentStudentDetails.objectForKey("StudentId") as? String
                        {
                            delegate().delegateStudentAnswerRecievedWithDetails!(AssessmentAnswerId, withStudentid: StudentId)
                        }
                       
                    }
                }
            }
            
        }
    }
    
    
    
    
    func delegateServiceErrorMessage(message: String!, withServiceName ServiceName: String!, withErrorCode code: String!)
    {
        
    }
    
    
}