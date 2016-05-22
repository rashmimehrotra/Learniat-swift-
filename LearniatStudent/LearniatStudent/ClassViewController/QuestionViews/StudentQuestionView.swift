//
//  StudentQuestionView.swift
//  LearniatStudent
//
//  Created by Deepak MK on 10/05/16.
//  Copyright © 2016 Mindshift. All rights reserved.
//

import Foundation

@objc protocol StudentQuestionViewDelegate
{
    
    optional func delegateFullScreenButtonPressedWithOverlayImage(overlay:UIImage)
    
    
}





class StudentQuestionView: UIView,StudentAnswerGraphViewDelegate,ScribbleQuestionViewDelegate,SSStudentDataSourceDelegate
{
    var noQuestionslabel = UILabel()
    
    var currentQuestionDetails :AnyObject!
    
    var mMultipleQuestion : MultipleChoiceView!
    
    var mMatchColumn        :MatchColumnView!
    
     var mScribbleQuestion        :ScribbleQuestionView!
    
    var currentQuestionType = ""
    
    var currentOptionsArray         = NSMutableArray()
    
    var mSharedGraphView            : StudentAnswerGraphView!
    
    
    var _delgate: AnyObject!
    
    func setdelegate(delegate:AnyObject)
    {
        _delgate = delegate;
    }
    
    func   delegate()->AnyObject
    {
        return _delgate;
    }
    
    
    override init(frame: CGRect)
    {
        super.init(frame: frame)
        
        
        self.backgroundColor = UIColor.whiteColor()
        
        
        noQuestionslabel.frame = CGRectMake(10, (self.frame.size.height - 40)/2, self.frame.size.width - 20,40)
        noQuestionslabel.font = UIFont(name:helveticaRegular, size: 40)
        noQuestionslabel.text = "There are no questions yet"
        self.addSubview(noQuestionslabel)
        noQuestionslabel.textColor = topbarColor
        noQuestionslabel.textAlignment = .Center
        
               
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setQuestionDetails(questionDetails: AnyObject , withType QuestionType :String, withSessionDetails sessionDetails:AnyObject,withQuestion _logId:String)
    {
        
        if mSharedGraphView != nil
        {
            mSharedGraphView.removeFromSuperview()
            mSharedGraphView = nil
        }
        
        currentQuestionDetails = questionDetails
        currentQuestionType = QuestionType
        print(questionDetails)
        
        noQuestionslabel.hidden = true
        
        
        if QuestionType == MultipleChoice || QuestionType == MultipleResponse
        {
            if mMultipleQuestion != nil{
                mMultipleQuestion.removeFromSuperview()
            }
            
            let options = currentQuestionDetails.objectForKey(kOptionTagMain)?.objectForKey(kOptionTag)
            
            
            if options != nil
            {
                if (options!.isKindOfClass(NSMutableArray))
                {
                    currentOptionsArray = options as! NSMutableArray
                }
                else
                {
                    currentOptionsArray.addObject(options!)
                }

            }
            
            
            mMultipleQuestion = MultipleChoiceView(frame:CGRectMake(0,0,self.frame.size.width,self.frame.size.height))
            self.addSubview(mMultipleQuestion)
            mMultipleQuestion.setQuestionDetails(questionDetails ,withsessionDetails: sessionDetails, withQuestionLogId: _logId)
        }
        else if QuestionType == MatchColumns
        {
            if mMatchColumn != nil{
                mMatchColumn.removeFromSuperview()
            }
            
            
            let options = currentQuestionDetails.objectForKey(kOptionTagMain)?.objectForKey(kOptionTag)
            
            
            if options != nil
            {
                if (options!.isKindOfClass(NSMutableArray))
                {
                    currentOptionsArray = options as! NSMutableArray
                }
                else
                {
                    currentOptionsArray.addObject(options!)
                }
                
            }
            
            
            mMatchColumn = MatchColumnView(frame:CGRectMake(0,0,self.frame.size.width,self.frame.size.height))
            self.addSubview(mMatchColumn)
            mMatchColumn.setQuestionDetails(questionDetails ,withsessionDetails: sessionDetails, withQuestionLogId: _logId)
        }
        else if QuestionType == kOverlayScribble || QuestionType == kFreshScribble
        {
            
            if mScribbleQuestion != nil{
                mScribbleQuestion.removeFromSuperview()
            }
            
            mScribbleQuestion = ScribbleQuestionView(frame:CGRectMake(0,0,self.frame.size.width,self.frame.size.height))
            self.addSubview(mScribbleQuestion)
            mScribbleQuestion.setdelegate(self)
            mScribbleQuestion.setQuestionDetails(questionDetails ,withsessionDetails: sessionDetails, withQuestionLogId: _logId)
        }
    }
    
    
    
    func questionCleared()
    {
        if mMultipleQuestion != nil
        {
            mMultipleQuestion.removeFromSuperview()
        }
        
        if mMatchColumn != nil
        {
            mMatchColumn.removeFromSuperview()
        }
        
        if mScribbleQuestion != nil
        {
            mScribbleQuestion.removeFromSuperview()
        }
        
        noQuestionslabel.hidden = false
        if SSStudentDataSource.sharedDataSource.answerSent == true
        {
            self.makeToast("Question cleared by teacher.", duration: 2.0, position: .Bottom)
        }
        
        if mSharedGraphView != nil
        {
            mSharedGraphView.removeFromSuperview()
            mSharedGraphView = nil
        }
        
        

    }
    
    func didgetFreezMessageFromTeacher()
    {
        if currentQuestionType == MultipleChoice || currentQuestionType == MultipleResponse
        {
            if mMultipleQuestion != nil
            {
                mMultipleQuestion.FreezMessageFromTeacher()
            }
        }
        else if currentQuestionType == MatchColumns
        {
            if mMatchColumn != nil
            {
                mMatchColumn.FreezMessageFromTeacher()
            }
        }
        else if currentQuestionType == kOverlayScribble || currentQuestionType == kFreshScribble
        {
            if mScribbleQuestion != nil
            {
                mScribbleQuestion.FreezMessageFromTeacher()
            }
        }
    }
    
    func didGetGraphSharedWithDetails(details:AnyObject)
    {
        
        print(details)
        
        if currentQuestionDetails == nil
        {
            return
        }
        
        if mSharedGraphView == nil
        {
            mSharedGraphView = StudentAnswerGraphView(frame:CGRectMake(0,0,self.frame.size.width,self.frame.size.height))
            self.addSubview(mSharedGraphView)
            self.bringSubviewToFront(mSharedGraphView)
            mSharedGraphView.setdelegate(self)
            
            
            
            
            if currentQuestionType == MultipleChoice || currentQuestionType == MultipleResponse
            {
                if (currentQuestionDetails.objectForKey(kQuestionName) as? String) != ""
                {
                    mSharedGraphView.loadMRQViewWithOPtions(currentOptionsArray, withQuestion: (currentQuestionDetails.objectForKey(kQuestionName) as! String))
                }
                else
                {
                    mSharedGraphView.loadMRQViewWithOPtions(currentOptionsArray, withQuestion: "")
                }
                
                
                
                
                var optionsValueDetails = NSMutableDictionary()
                
                if let optionsDetails = details.objectForKey("Details") as? NSMutableDictionary
                {
                    optionsValueDetails = optionsDetails
                    
                }
                
                
                for index  in 0 ..< currentOptionsArray.count
                {
                    
                    let optionsDict = currentOptionsArray.objectAtIndex(index)
                    
                    if let optionId = optionsDict.objectForKey("OptionId") as? String
                    {
                        if let value = optionsValueDetails.objectForKey("option_\(optionId)") as? String
                        {
                            
                            mSharedGraphView.increaseMultiplevalu(Int(value)!, withOptionId: optionId)
                            
                        }
                    }
                    
                    
                }

                
                
            }
            else
            {
                let leftSideArray = NSMutableArray()
                
                let RightSideArray = NSMutableArray()
                
                for index in 0 ..< currentOptionsArray.count
                {
                    
                    let optionDict = currentOptionsArray.objectAtIndex(index)
                    
                    if let Column = optionDict.objectForKey("Column") as? String
                    {
                        if Column == "1"
                        {
                            leftSideArray.addObject(optionDict)
                        }
                        else if Column == "2"
                        {
                            RightSideArray.addObject(optionDict)
                            
                        }
                        
                    }
                }
                
                
                
                if (currentQuestionDetails.objectForKey(kQuestionName) as? String) != ""
                {
                    
                    mSharedGraphView.loadMTCViewWithOPtions(leftSideArray, WithRightSideOptionArray: RightSideArray, withQuestion: (currentQuestionDetails.objectForKey(kQuestionName) as! String))
                   
                }
                else
                {
                    mSharedGraphView.loadMTCViewWithOPtions(leftSideArray, WithRightSideOptionArray: RightSideArray, withQuestion: "")
                }
                
                
                
                var optionsValueDetails = NSMutableDictionary()
                
                if let optionsDetails = details.objectForKey("Details") as? NSMutableDictionary
                {
                    optionsValueDetails = optionsDetails
                    
                }
                
                
                for index  in 0 ..< currentOptionsArray.count
                {
                    
                    let optionsDict = currentOptionsArray.objectAtIndex(index)
                    
                    if let optionId = optionsDict.objectForKey("OptionId") as? String
                    {
                        if let value = optionsValueDetails.objectForKey("option_\(optionId)") as? String
                        {
                            if let optiontext = optionsDict.objectForKey("OptionText") as? String
                            {
                                 mSharedGraphView.increaseMTCMultiplevalu(Int(value)!, withOptionText: optiontext)
                            }
                        }
                    }
                    
                    
                }
                

                
                
            }
           
            
            
            
            
        }
        
    }
    
    
    func delegateShareButtonClickedWithDetails()
    {
        mSharedGraphView.removeFromSuperview()
        mSharedGraphView = nil
        
    }
    
    func didgetTeacherEvaluatingMessage()
    {
        if mScribbleQuestion != nil{
            mScribbleQuestion.didGetEvaluatingMessage()
        }
    }
    
    
    func delegateEditButtonPressedWithOverlayImage(overlay: UIImage)
    {
        delegate().delegateFullScreenButtonPressedWithOverlayImage!(overlay)
    }
    
    func setFullScreenDrawnImage(image:UIImage)
    {
        if mScribbleQuestion != nil
        {
            mScribbleQuestion.setDrawnImage(image)
        }

    }
    
    func getFeedbackDetailsWithId(AssesmentAnswerId:String)
    {
        SSStudentDataSource.sharedDataSource.getFeedbackFromTeacherForAssesment(AssesmentAnswerId, withDelegate: self)
    }
    func didGetAnswerFeedBackWithDetails(details: AnyObject) {
        
        if mScribbleQuestion != nil
        {
            mScribbleQuestion.getFeedBackDetails(details)
        }
        
        
        
    }
    
    
    func getPeakViewMessage()
    {
        if mScribbleQuestion != nil
        {
            mScribbleQuestion.getPeakViewMessageFromTeacher()
        }
    }
    
    func didgetErrorMessage(message: String, WithServiceName serviceName: String) {
        
    }
    
}