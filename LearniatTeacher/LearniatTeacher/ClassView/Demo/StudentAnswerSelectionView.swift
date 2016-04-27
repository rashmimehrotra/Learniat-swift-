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
        
        if let questionType = _currentQuestionDetails.objectForKey("Type") as? String
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
    
    
    
    
    
    func selectMulitipleChoiceOptionsWithQuestionDetails(questionDetails:AnyObject)
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
        
        if optionArray.count > 0
        {
            var aRandomInt = randomInt(1, max: optionArray.count - 1)
            
            if aRandomInt > optionArray.count
            {
                aRandomInt = optionArray.count - 1
            }
            let optionDict = optionArray.objectAtIndex(aRandomInt)
            if let optionsString = optionDict.objectForKey("OptionText") as? String
            {
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
        
        
        
        
    }
    
    
    
    
    func selectMultipleResponseOptionsWithQuestionDetails(questionDetails:AnyObject)
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
            var aRandomInt = randomInt(1, max: optionArray.count - 1)
            
            if aRandomInt > optionArray.count
            {
                aRandomInt = optionArray.count - 1
            }
            for index  in 0..<aRandomInt
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
    
    
    func selectMatchColumnOptionsWithQuestionDetails(questionDetails:AnyObject)
    {
        var optionArray = NSMutableArray()
        
        let RightSideArray = NSMutableArray()
        
        
        
        
        
        let classCheckingVariable = questionDetails.objectForKey("Options")!.objectForKey("Option")!
        
        if classCheckingVariable.isKindOfClass(NSMutableArray)
        {
            optionArray = classCheckingVariable as! NSMutableArray
        }
        else
        {
            optionArray.addObject(questionDetails.objectForKey("Options")!.objectForKey("Option")!)
            
        }
        
        
        
        for index in 0 ..< optionArray.count
        {
            
            let optionDict = optionArray.objectAtIndex(index)
            if let Column = optionDict.objectForKey("Column") as? String
            {
                if Column == "2"
                {
                    RightSideArray.addObject(optionDict)
                    
                }
            }
        }
        
        RightSideArray.shuffle()
        
        let sequenceArray = NSMutableArray()
        for index in 0..<RightSideArray.count
        {
            
            let optionDict = RightSideArray.objectAtIndex(index)
            if let Sequence = optionDict.objectForKey("Sequence") as? String
            {
                sequenceArray.addObject(Sequence)
            }
        }
        
        
        if sequenceArray.count > 0
        {
            let optionsString = sequenceArray.componentsJoinedByString(";;;")
            if let StudentId = _currentStudentDetails.objectForKey("StudentId") as? String
            {
                if let Type = _currentQuestionDetails.objectForKey("Type") as? String
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
    
    func selectScribbleWithQuestionDetails(questionDetails:AnyObject)
    {
        
        if let topicId = questionDetails.objectForKey("Id")as? String
        {
            if SSTeacherDataSource.sharedDataSource.mDemoQuestionsIdArray.containsObject(topicId)
            {
                let  url = NSURL(string: "\(kDemoPlistUrl)/Question_\(topicId).plist")
                
                let plistLoader = PlistDownloder()
                
                let mDemoMaseterFileDetails = plistLoader.returnDictonarywithUrl(url)
                
                if  mDemoMaseterFileDetails != nil
                {
                    var demoScribbleImageArray = NSMutableArray()
                    
                    if mDemoMaseterFileDetails.objectForKey("ScribbleImagePaths") != nil
                    {
                        if let classCheckingVariable = mDemoMaseterFileDetails.objectForKey("ScribbleImagePaths")
                        {
                            if classCheckingVariable.isKindOfClass(NSMutableArray)
                            {
                                demoScribbleImageArray = classCheckingVariable as! NSMutableArray
                            }
                            else
                            {
                                demoScribbleImageArray.addObject(mDemoMaseterFileDetails.objectForKey("ScribbleImagePaths")!)
                                
                            }
                        }
                    }
                    
                    demoScribbleImageArray.shuffle()
                    
                    if demoScribbleImageArray.count > 0
                    {
                        if let imagePath = demoScribbleImageArray.firstObject as? String
                        {
                            if let StudentId = _currentStudentDetails.objectForKey("StudentId") as? String
                            {
                                if let Type = _currentQuestionDetails.objectForKey("Type") as? String
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
    
    func selectTextWithQuestionDetails(questionDetails:AnyObject)
    {
        
        if let topicId = questionDetails.objectForKey("Id")as? String
        {
            if SSTeacherDataSource.sharedDataSource.mDemoQuestionsIdArray.containsObject(topicId)
            {
                let  url = NSURL(string: "\(kDemoPlistUrl)/Question_\(topicId).plist")
                
                let plistLoader = PlistDownloder()
                
                let mDemoMaseterFileDetails = plistLoader.returnDictonarywithUrl(url)
                
                if  mDemoMaseterFileDetails != nil
                {
                    var demoScribbleImageArray = NSMutableArray()
                    
                    if mDemoMaseterFileDetails.objectForKey("TextAnswers") != nil
                    {
                        if let classCheckingVariable = mDemoMaseterFileDetails.objectForKey("TextAnswers")
                        {
                            if classCheckingVariable.isKindOfClass(NSMutableArray)
                            {
                                demoScribbleImageArray = classCheckingVariable as! NSMutableArray
                            }
                            else
                            {
                                demoScribbleImageArray.addObject(mDemoMaseterFileDetails.objectForKey("TextAnswers")!)
                                
                            }
                        }
                    }
                    
                    demoScribbleImageArray.shuffle()
                    
                    if demoScribbleImageArray.count > 0
                    {
                        if let imagePath = demoScribbleImageArray.firstObject as? String
                        {
                            if let StudentId = _currentStudentDetails.objectForKey("StudentId") as? String
                            {
                                if let Type = _currentQuestionDetails.objectForKey("Type") as? String
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
    
    
    
    func sendAnswerWithOptionText(OptionText:String,witStudentId StudentId:String, withQuestionLogId QuestionLogId:String, withQuestionType type:String)
    {
        
        let manager = APIManager()
        
        let urlString = String(format: "%@<Sunstone><Action><Service>SendAnswer</Service><StudentId>%@</StudentId><OptionText>%@</OptionText><SessionId>%@</SessionId><QuestionLogId>%@</QuestionLogId><QuestionType>%@</QuestionType></Action></Sunstone>",URLPrefix,StudentId,OptionText,SSTeacherDataSource.sharedDataSource.currentLiveSessionId,QuestionLogId,type)
        
        manager.downloadDataURL(urlString, withServiceName: kServiceSendAnswer, withDelegate: self, withRequestType: eHTTPGetRequest)
    }
    
    
    
    func sendAnswerForMTCWithOptionText(OptionText:String,witStudentId StudentId:String, withQuestionLogId QuestionLogId:String, withQuestionType type:String)
    {
        
        let manager = APIManager()
        
        let urlString = String(format: "%@<Sunstone><Action><Service>SendAnswer</Service><StudentId>%@</StudentId><Sequence>%@</Sequence><SessionId>%@</SessionId><QuestionLogId>%@</QuestionLogId><QuestionType>%@</QuestionType></Action></Sunstone>",URLPrefix,StudentId,OptionText,SSTeacherDataSource.sharedDataSource.currentLiveSessionId,QuestionLogId,type)
        
        manager.downloadDataURL(urlString, withServiceName: kServiceSendAnswer, withDelegate: self, withRequestType: eHTTPGetRequest)
    }
    
    
    func sendAnswerForScribbleQuestionWithImagePath(imagePath:String,witStudentId StudentId:String, withQuestionLogId QuestionLogId:String, withQuestionType type:String)
    {
        
        let manager = APIManager()
        
        let urlString = String(format: "%@<Sunstone><Action><Service>SendAnswer</Service><StudentId>%@</StudentId><ImagePath>%@</ImagePath><SessionId>%@</SessionId><QuestionLogId>%@</QuestionLogId><QuestionType>%@</QuestionType></Action></Sunstone>",URLPrefix,StudentId,imagePath,SSTeacherDataSource.sharedDataSource.currentLiveSessionId,QuestionLogId,type)
        
        manager.downloadDataURL(urlString, withServiceName: kServiceSendAnswer, withDelegate: self, withRequestType: eHTTPGetRequest)
    }
    
    
    
    func sendAnswerForTextQuestionWithImagePath(textAnswer:String,witStudentId StudentId:String, withQuestionLogId QuestionLogId:String, withQuestionType type:String)
    {
        
        let manager = APIManager()
        
        let urlString = String(format: "%@<Sunstone><Action><Service>SendAnswer</Service><StudentId>%@</StudentId><TextAnswer>%@</TextAnswer><SessionId>%@</SessionId><QuestionLogId>%@</QuestionLogId><QuestionType>%@</QuestionType></Action></Sunstone>",URLPrefix,StudentId,textAnswer,SSTeacherDataSource.sharedDataSource.currentLiveSessionId,QuestionLogId,type)
        
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
    
    
    func randomInt(min: Int, max:Int) -> Int
    {
        return min + Int(arc4random_uniform(UInt32(max - min + 1)))
    }

    
}