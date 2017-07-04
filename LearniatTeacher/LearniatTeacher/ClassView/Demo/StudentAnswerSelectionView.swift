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
    
    
    @objc optional func delegateStudentAnswerRecievedWithDetails(_ answerId:String, withStudentid stundentId:String)
    
    
    
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
    
    func setdelegate(_ delegate:AnyObject)
    {
        _delgate = delegate;
    }
    
    func   delegate()->AnyObject
    {
        return _delgate;
    }
    
    
    func setCurrentQuestionDetails(_ questionDetails:AnyObject, withCurrentStudentDetails studentDetail:AnyObject)
    {
        _currentQuestionDetails = questionDetails
        _currentStudentDetails = studentDetail
        
        if let questionType = _currentQuestionDetails.object(forKey: kQuestionType) as? String
        {
            if (questionType == kMCQ)
            {
                selectMulitipleChoiceOptionsWithQuestionDetails(questionDetails)
            }
            else if (questionType == kMRQ)
            {
                selectMultipleResponseOptionsWithQuestionDetails(questionDetails)
            }
            else if (questionType == kMatchColumn)
            {
                selectMatchColumnOptionsWithQuestionDetails(questionDetails)
            }
            else if (questionType == kOverlayScribble || questionType == kFreshScribble )
            {
                selectScribbleWithQuestionDetails(questionDetails)
            }
            else if (questionType == kText)
            {
                selectTextWithQuestionDetails(questionDetails)
            }
        }
        
    }
    
    
    
    
    
    func selectMulitipleChoiceOptionsWithQuestionDetails(_ questionDetails:AnyObject)
    {
        
        print(questionDetails)
        var optionArray = NSMutableArray()
        
        if let options = questionDetails.object(forKey: kOptionTagMain)
        {
            if let classCheckingVariable = (options as AnyObject).object(forKey: "Option") as? NSMutableArray
            {
                optionArray = classCheckingVariable
                
                
            }
            else
            {
                optionArray.add((questionDetails.object(forKey: kOptionTagMain)! as AnyObject).object(forKey: "Option")!)
                
            }
        }
        
        optionArray.shuffle()
        
        if optionArray.count > 0
        {
            var aRandomInt = randomInt(1, max: optionArray.count - 1)
            
            if aRandomInt > optionArray.count
            {
                aRandomInt = optionArray.count - 1
            }
            let optionDict = optionArray.object(at: aRandomInt)
            if let optionsString = (optionDict as AnyObject).object(forKey: "OptionText") as? String
            {
                if let StudentId = _currentStudentDetails.object(forKey: "StudentId") as? String
                {
                    if let Type = _currentQuestionDetails.object(forKey: kQuestionType) as? String
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
        
        
        
        
    }
    
    
    
    
    func selectMultipleResponseOptionsWithQuestionDetails(_ questionDetails:AnyObject)
    {
        print(questionDetails)
        var optionArray = NSMutableArray()
        
        if let options = questionDetails.object(forKey: kOptionTagMain)
        {
            if let classCheckingVariable = (options as AnyObject).object(forKey: "Option") as? NSMutableArray
            {
               
                optionArray = classCheckingVariable
                
                
            }
            else
            {
                optionArray.add((questionDetails.object(forKey: kOptionTagMain)! as AnyObject).object(forKey: "Option")!)
                
            }
        }
        
        optionArray.shuffle()
        let optionSelectedArray = NSMutableArray()
        
        if optionArray.count > 0
        {
            var aRandomInt = randomInt(1, max: optionArray.count - 1)
            
            if aRandomInt > optionArray.count
            {
                aRandomInt = optionArray.count - 1
            }
            for index  in 0..<aRandomInt
            {
                let optionDict = optionArray.object(at: index)
                if let questionOptionText = (optionDict as AnyObject).object(forKey: "OptionText") as? String
                {
                    optionSelectedArray.add(questionOptionText)
                }
            }
        }
        
        if optionSelectedArray.count > 0
        {
            let optionsString = optionSelectedArray.componentsJoined(by: ";;;")
            if let StudentId = _currentStudentDetails.object(forKey: "StudentId") as? String
            {
                if let Type = _currentQuestionDetails.object(forKey: kQuestionType) as? String
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
    
    
    func selectMatchColumnOptionsWithQuestionDetails(_ questionDetails:AnyObject)
    {
        var optionArray = NSMutableArray()
        
        let RightSideArray = NSMutableArray()
        
        
        
        
        
       if let classCheckingVariable = (questionDetails.object(forKey: kOptionTagMain)! as AnyObject).object(forKey: "Option") as? NSMutableArray
       {
            optionArray = classCheckingVariable
        }
        else
        {
            optionArray.add((questionDetails.object(forKey: kOptionTagMain)! as AnyObject).object(forKey: "Option")!)
            
        }
        
        
        
        for index in 0 ..< optionArray.count
        {
            
            let optionDict = optionArray.object(at: index)
            if let Column = (optionDict as AnyObject).object(forKey: "Column") as? String
            {
                if Column == "2"
                {
                    RightSideArray.add(optionDict)
                    
                }
            }
        }
        
        RightSideArray.shuffle()
        
        let sequenceArray = NSMutableArray()
        for index in 0..<RightSideArray.count
        {
            
            let optionDict = RightSideArray.object(at: index)
            if let Sequence = (optionDict as AnyObject).object(forKey: "Sequence") as? String
            {
                sequenceArray.add(Sequence)
            }
        }
        
        
        if sequenceArray.count > 0
        {
            let optionsString = sequenceArray.componentsJoined(by: ";;;")
            if let StudentId = _currentStudentDetails.object(forKey: "StudentId") as? String
            {
                if let Type = _currentQuestionDetails.object(forKey: kQuestionType) as? String
                {
                    if SSTeacherDataSource.sharedDataSource.currentQuestionLogId != ""
                    {
                        if SSTeacherDataSource.sharedDataSource.isQuestionSent == true
                        {
                            sendAnswerForMTCWithOptionText(optionsString, witStudentId: StudentId, withQuestionLogId: SSTeacherDataSource.sharedDataSource.currentQuestionLogId, withQuestionType: Type)
                        }
                        
                    }
                    
                }
                
            }
        }
    }
    
    func selectScribbleWithQuestionDetails(_ questionDetails:AnyObject)
    {
        
        if let topicId = questionDetails.object(forKey: "Id")as? String
        {
            if SSTeacherDataSource.sharedDataSource.mDemoQuestionsIdArray.contains(topicId)
            {
                let  url = URL(string: "\(kDemoPlistUrl)/Question_\(topicId).plist")
                
                let plistLoader = PlistDownloder()
                
                let mDemoMaseterFileDetails = plistLoader.returnDictonarywithUrl(url)
                
                if  mDemoMaseterFileDetails != nil
                {
                    var demoScribbleImageArray = NSMutableArray()
                    
                    if mDemoMaseterFileDetails?.object(forKey: "ScribbleImagePaths") != nil
                    {
                        if let classCheckingVariable = mDemoMaseterFileDetails?.object(forKey: "ScribbleImagePaths") as? NSMutableArray
                        {
                            demoScribbleImageArray = classCheckingVariable
                        }
                        else
                        {
                            demoScribbleImageArray.add(mDemoMaseterFileDetails?.object(forKey: "ScribbleImagePaths")!)
                            
                        }
                    }
                    
                    demoScribbleImageArray.shuffle()
                    
                    if demoScribbleImageArray.count > 0
                    {
                        if let imagePath = demoScribbleImageArray.firstObject as? String
                        {
                            if let StudentId = _currentStudentDetails.object(forKey: "StudentId") as? String
                            {
                                if let Type = _currentQuestionDetails.object(forKey: kQuestionType) as? String
                                {
                                    if SSTeacherDataSource.sharedDataSource.currentQuestionLogId != ""
                                    {
                                        if SSTeacherDataSource.sharedDataSource.isQuestionSent == true
                                        {
                                            sendAnswerForScribbleQuestionWithImagePath(imagePath, witStudentId: StudentId, withQuestionLogId:SSTeacherDataSource.sharedDataSource.currentQuestionLogId, withQuestionType: Type)
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
    func selectTextWithQuestionDetails(_ questionDetails:AnyObject)
    {
        
        if let topicId = questionDetails.object(forKey: "Id")as? String
        {
            if SSTeacherDataSource.sharedDataSource.mDemoQuestionsIdArray.contains(topicId)
            {
                let  url = URL(string: "\(kDemoPlistUrl)/Question_\(topicId).plist")
                
                let plistLoader = PlistDownloder()
                
                let mDemoMaseterFileDetails = plistLoader.returnDictonarywithUrl(url)
                
                if  mDemoMaseterFileDetails != nil
                {
                    var demoScribbleImageArray = NSMutableArray()
                    
                    if mDemoMaseterFileDetails?.object(forKey: "TextAnswers") != nil
                    {
                        if let classCheckingVariable = mDemoMaseterFileDetails?.object(forKey: "TextAnswers") as? NSMutableArray
                        {
                            demoScribbleImageArray = classCheckingVariable
                            
                            
                        }
                        else
                        {
                            demoScribbleImageArray.add(mDemoMaseterFileDetails?.object(forKey: "TextAnswers")!)
                            
                        }
                    }
                    
                    demoScribbleImageArray.shuffle()
                    
                    if demoScribbleImageArray.count > 0
                    {
                        if let imagePath = demoScribbleImageArray.firstObject as? String
                        {
                            if let StudentId = _currentStudentDetails.object(forKey: "StudentId") as? String
                            {
                                if let Type = _currentQuestionDetails.object(forKey: kQuestionType) as? String
                                {
                                    if SSTeacherDataSource.sharedDataSource.currentQuestionLogId != ""
                                    {
                                        if SSTeacherDataSource.sharedDataSource.isQuestionSent == true
                                        {
                                            sendAnswerForTextQuestionWithImagePath(imagePath, witStudentId: StudentId, withQuestionLogId:SSTeacherDataSource.sharedDataSource.currentQuestionLogId, withQuestionType: Type)
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
    
    
    func sendAnswerWithOptionText(_ OptionText:String,witStudentId StudentId:String, withQuestionLogId QuestionLogId:String, withQuestionType type:String)
    {
        
        let manager = APIManager()
        
        let urlString = String(format: "%@<Sunstone><Action><Service>SendAnswer</Service><StudentId>%@</StudentId><OptionText>%@</OptionText><SessionId>%@</SessionId><QuestionLogId>%@</QuestionLogId><QuestionType>%@</QuestionType></Action></Sunstone>",URLPrefix,StudentId,OptionText,SSTeacherDataSource.sharedDataSource.currentLiveSessionId,QuestionLogId,type)
        
        manager.downloadDataURL(urlString, withServiceName: kServiceSendAnswer, withDelegate: self, with: eHTTPGetRequest, withReturningDelegate: self)
    }
    
    
    
    func sendAnswerForMTCWithOptionText(_ OptionText:String,witStudentId StudentId:String, withQuestionLogId QuestionLogId:String, withQuestionType type:String)
    {
        
        let manager = APIManager()
        
        let urlString = String(format: "%@<Sunstone><Action><Service>SendAnswer</Service><StudentId>%@</StudentId><Sequence>%@</Sequence><SessionId>%@</SessionId><QuestionLogId>%@</QuestionLogId><QuestionType>%@</QuestionType></Action></Sunstone>",URLPrefix,StudentId,OptionText,SSTeacherDataSource.sharedDataSource.currentLiveSessionId,QuestionLogId,type)
        
        manager.downloadDataURL(urlString, withServiceName: kServiceSendAnswer, withDelegate: self, with: eHTTPGetRequest , withReturningDelegate: self)
    }
    
    
    func sendAnswerForScribbleQuestionWithImagePath(_ imagePath:String,witStudentId StudentId:String, withQuestionLogId QuestionLogId:String, withQuestionType type:String)
    {
        
        let manager = APIManager()
        
        let urlString = String(format: "%@<Sunstone><Action><Service>SendAnswer</Service><StudentId>%@</StudentId><ImagePath>%@</ImagePath><SessionId>%@</SessionId><QuestionLogId>%@</QuestionLogId><QuestionType>%@</QuestionType></Action></Sunstone>",URLPrefix,StudentId,imagePath,SSTeacherDataSource.sharedDataSource.currentLiveSessionId,QuestionLogId,type)
        
        manager.downloadDataURL(urlString, withServiceName: kServiceSendAnswer, withDelegate: self, with: eHTTPGetRequest, withReturningDelegate: self)
    }
    
    
    
    func sendAnswerForTextQuestionWithImagePath(_ textAnswer:String,witStudentId StudentId:String, withQuestionLogId QuestionLogId:String, withQuestionType type:String)
    {
        
        let manager = APIManager()
        
        let urlString = String(format: "%@<Sunstone><Action><Service>SendAnswer</Service><StudentId>%@</StudentId><TextAnswer>%@</TextAnswer><SessionId>%@</SessionId><QuestionLogId>%@</QuestionLogId><QuestionType>%@</QuestionType></Action></Sunstone>",URLPrefix,StudentId,textAnswer,SSTeacherDataSource.sharedDataSource.currentLiveSessionId,QuestionLogId,type)
        
        manager.downloadDataURL(urlString, withServiceName: kServiceSendAnswer, withDelegate: self, with: eHTTPGetRequest, withReturningDelegate: self)
    }
    
    
    
     func delegateDidGetServiceResponse(withDetails dict: NSMutableDictionary!, wIthServiceName serviceName: String!, withRetruningDelegate returningDelegate: Any!)
    {
        if SSTeacherDataSource.sharedDataSource.isQuestionSent == true
        {
            let refinedDetails = (dict.object(forKey: kSunstone)! as AnyObject).object(forKey: kSSAction)!
            
            
            if serviceName == kServiceSendAnswer
            {
                if let AssessmentAnswerId = (refinedDetails as AnyObject).object(forKey: "AssessmentAnswerId") as? String{
                    if delegate().responds(to: #selector(StudentAnswerSelectionViewDelegate.delegateStudentAnswerRecievedWithDetails(_:withStudentid:)))
                    {
                        if let StudentId = _currentStudentDetails.object(forKey: "StudentId") as? String
                        {
                            delegate().delegateStudentAnswerRecievedWithDetails!(AssessmentAnswerId, withStudentid: StudentId)
                        }
                       
                    }
                }
            }
            
        }
    }
    
    
    
    
    func delegateServiceErrorMessage(_ message: String!, withServiceName ServiceName: String!, withErrorCode code: String!)
    {
        
    }
    
    
    func randomInt(_ min: Int, max:Int) -> Int
    {
        return min + Int(arc4random_uniform(UInt32(max - min + 1)))
    }

    
}
