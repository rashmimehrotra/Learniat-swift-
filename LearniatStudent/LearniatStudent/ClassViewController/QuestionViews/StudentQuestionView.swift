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
    
    @objc optional func delegateFullScreenButtonPressedWithOverlayImage(_ overlay:UIImage, withQuestionName name:String)
    
    
}





class StudentQuestionView: UIView,StudentAnswerGraphViewDelegate,ScribbleQuestionViewDelegate,SSStudentDataSourceDelegate
{
    var noQuestionslabel = UILabel()
    
    var currentQuestionDetails :AnyObject!
    
    var mMultipleQuestion           : MultipleChoiceView!
    
    var mMatchColumn                :MatchColumnView!
    
    var mScribbleQuestion           :ScribbleQuestionView!
    
    var mTextQuestion               :TextTypeQuestionView!
    
    var mOneStringQuestionView               :OneStingQuestionView!
    
    var currentQuestionType = ""
    
    var currentOptionsArray         = NSMutableArray()
    
    var mSharedGraphView            : StudentAnswerGraphView!
    
    
   
    
    
    var _delgate: AnyObject!
    
    func setdelegate(_ delegate:AnyObject)
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
        
        
        self.backgroundColor = UIColor.white
        
        
        noQuestionslabel.frame = CGRect(x: 10, y: (self.frame.size.height - 40)/2, width: self.frame.size.width - 20,height: 40)
        noQuestionslabel.font = UIFont(name:helveticaRegular, size: 40)
        noQuestionslabel.text = "There are no questions yet"
        self.addSubview(noQuestionslabel)
        noQuestionslabel.textColor = topbarColor
        noQuestionslabel.textAlignment = .center
        
        
        
              
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setQuestionDetails(_ questionDetails: AnyObject , withType QuestionType :String, withSessionDetails sessionDetails:AnyObject,withQuestion _logId:String)
    {
        
        SSStudentDataSource.sharedDataSource.answerSent = false
        
        if mSharedGraphView != nil
        {
            mSharedGraphView.removeFromSuperview()
            mSharedGraphView = nil
        }
        
        currentQuestionDetails = questionDetails
        currentQuestionType = QuestionType
        print(questionDetails)
        
        noQuestionslabel.isHidden = true
        
        
        if QuestionType == MultipleChoice || QuestionType == MultipleResponse
        {
            if mMultipleQuestion != nil{
                mMultipleQuestion.removeFromSuperview()
            }
            
           if let options = (currentQuestionDetails.object(forKey: kOptionTagMain) as AnyObject).object(forKey: kOptionTag) as? NSMutableArray
           {
                currentOptionsArray = options 
            }
            
            else
           {
               if let options = (currentQuestionDetails.object(forKey: kOptionTagMain) as AnyObject).object(forKey: kOptionTag) as? NSMutableDictionary
               {
                    currentOptionsArray.add(options)
                }
            
            }
            
            
            mMultipleQuestion = MultipleChoiceView(frame:CGRect(x: 0,y: 0,width: self.frame.size.width,height: self.frame.size.height))
            self.addSubview(mMultipleQuestion)
            mMultipleQuestion.setQuestionDetails(questionDetails ,withsessionDetails: sessionDetails, withQuestionLogId: _logId)
        }
        else if QuestionType == MatchColumns
        {
            if mMatchColumn != nil{
                mMatchColumn.removeFromSuperview()
            }
            
            
           if let options = (currentQuestionDetails.object(forKey: kOptionTagMain) as AnyObject).object(forKey: kOptionTag)as?NSMutableArray
           {
              currentOptionsArray = options 
            }
            else
           {
//                let options = (currentQuestionDetails.object(forKey: kOptionTagMain) as AnyObject).object(forKey: kOptionTag)
            
            if let options = (currentQuestionDetails.object(forKey: kOptionTagMain) as AnyObject).object(forKey: kOptionTag) as? NSMutableDictionary
            {
                currentOptionsArray.add(options)
            }
            
            }
            
            
            
            
            mMatchColumn = MatchColumnView(frame:CGRect(x: 0,y: 0,width: self.frame.size.width,height: self.frame.size.height))
            self.addSubview(mMatchColumn)
            mMatchColumn.setQuestionDetails(questionDetails ,withsessionDetails: sessionDetails, withQuestionLogId: _logId)
        }
        else if QuestionType == kOverlayScribble || QuestionType == kFreshScribble
        {
            
            if mScribbleQuestion != nil{
                mScribbleQuestion.removeFromSuperview()
            }
            
            mScribbleQuestion = ScribbleQuestionView(frame:CGRect(x: 0,y: 0,width: self.frame.size.width,height: self.frame.size.height))
            self.addSubview(mScribbleQuestion)
            mScribbleQuestion.setdelegate(self)
            mScribbleQuestion.setQuestionDetails(questionDetails ,withsessionDetails: sessionDetails, withQuestionLogId: _logId)
        }
        else if QuestionType == kText
        {
            
            if mTextQuestion != nil{
                mTextQuestion.removeFromSuperview()
            }
            
            
            mTextQuestion = TextTypeQuestionView(frame:CGRect(x: 0,y: 0,width: self.frame.size.width,height: self.frame.size.height))
            self.addSubview(mTextQuestion)
            mTextQuestion.setdelegate(self)
            mTextQuestion.setQuestionDetails(questionDetails ,withsessionDetails: sessionDetails, withQuestionLogId: _logId)
            
        }
        else if QuestionType == OneString  || QuestionType == TextAuto
        {
            if mOneStringQuestionView != nil{
                mOneStringQuestionView.removeFromSuperview()
            }
            
            
            mOneStringQuestionView = OneStingQuestionView(frame:CGRect(x: 0,y: 0,width: self.frame.size.width,height: self.frame.size.height))
            self.addSubview(mOneStringQuestionView)
            mOneStringQuestionView.setdelegate(self)
            mOneStringQuestionView.setQuestionDetails(questionDetails ,withsessionDetails: sessionDetails, withQuestionLogId: _logId)
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
        
        if mTextQuestion != nil{
            mTextQuestion.removeFromSuperview()
        }
        
        if mOneStringQuestionView != nil{
            mOneStringQuestionView.removeFromSuperview()
        }
        
        
        noQuestionslabel.isHidden = false
        if SSStudentDataSource.sharedDataSource.answerSent == true
        {
            self.makeToast("Question cleared by teacher.", duration: 2.0, position: .bottom)
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
        else if currentQuestionType == kText
        {
            if mTextQuestion != nil
            {
                mTextQuestion.FreezMessageFromTeacher()
            }
        }
        else if currentQuestionType == OneString || currentQuestionType == TextAuto
        {
            if mOneStringQuestionView != nil
            {
                mOneStringQuestionView.FreezMessageFromTeacher()
            }
        }
        
        
    }
    
    func didGetGraphSharedWithDetails(_ details:AnyObject)
    {
        
        print(details)
        
        if currentQuestionDetails == nil
        {
            return
        }
        
        if mSharedGraphView == nil
        {
            mSharedGraphView = StudentAnswerGraphView(frame:CGRect(x: 0,y: 0,width: self.frame.size.width,height: self.frame.size.height))
            self.addSubview(mSharedGraphView)
            self.bringSubview(toFront: mSharedGraphView)
            mSharedGraphView.setdelegate(self)
            
            
            
            
            if currentQuestionType == MultipleChoice || currentQuestionType == MultipleResponse
            {
                if (currentQuestionDetails.object(forKey: kQuestionName) as? String) != ""
                {
                    mSharedGraphView.loadMRQViewWithOPtions(currentOptionsArray, withQuestion: (currentQuestionDetails.object(forKey: kQuestionName) as! String))
                }
                else
                {
                    mSharedGraphView.loadMRQViewWithOPtions(currentOptionsArray, withQuestion: "")
                }
                
                
                
                
                var optionsValueDetails = NSMutableDictionary()
                
                if let optionsDetails = details.object(forKey: "Details") as? NSMutableDictionary
                {
                    optionsValueDetails = optionsDetails
                    
                }
                
                
                for index  in 0 ..< currentOptionsArray.count
                {
                    
                    let optionsDict = currentOptionsArray.object(at: index)
                    
                    if let optionId = (optionsDict as AnyObject).object(forKey: "OptionId") as? String
                    {
                        if let value = optionsValueDetails.object(forKey: "option_\(optionId)") as? String
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
                    
                    let optionDict = currentOptionsArray.object(at: index)
                    
                    if let Column = (optionDict as AnyObject).object(forKey: "Column") as? String
                    {
                        if Column == "1"
                        {
                            leftSideArray.add(optionDict)
                        }
                        else if Column == "2"
                        {
                            RightSideArray.add(optionDict)
                            
                        }
                        
                    }
                }
                
                
                
                if (currentQuestionDetails.object(forKey: kQuestionName) as? String) != ""
                {
                    
                    mSharedGraphView.loadMTCViewWithOPtions(leftSideArray, WithRightSideOptionArray: RightSideArray, withQuestion: (currentQuestionDetails.object(forKey: kQuestionName) as! String))
                   
                }
                else
                {
                    mSharedGraphView.loadMTCViewWithOPtions(leftSideArray, WithRightSideOptionArray: RightSideArray, withQuestion: "")
                }
                
                
                
                var optionsValueDetails = NSMutableDictionary()
                
                if let optionsDetails = details.object(forKey: "Details") as? NSMutableDictionary
                {
                    optionsValueDetails = optionsDetails
                    
                }
                
                
                for index  in 0 ..< currentOptionsArray.count
                {
                    
                    let optionsDict = currentOptionsArray.object(at: index)
                    
                    if let optionId = (optionsDict as AnyObject).object(forKey: "OptionId") as? String
                    {
                        if let value = optionsValueDetails.object(forKey: "option_\(optionId)") as? String
                        {
                            if let optiontext = (optionsDict as AnyObject).object(forKey: "OptionText") as? String
                            {
                                 mSharedGraphView.increaseMTCMultiplevalu(Int(value)!, withOptionText: optiontext)
                            }
                        }
                    }
                    
                    
                }
                

                
                
            }
           
            
            
            
            
        }
        
        if SSStudentDataSource.sharedDataSource.answerSent == true
        {
            mSharedGraphView.isHidden = false
        }
        else
        {
            mSharedGraphView.isHidden = true
        }
        
        
    }
    
    
    func delegateShareButtonClickedWithDetails()
    {
        mSharedGraphView.removeFromSuperview()
        mSharedGraphView = nil
        
    }
    
    func didgetTeacherEvaluatingMessage()
    {
        if currentQuestionType == kOverlayScribble || currentQuestionType == kFreshScribble
        {
            if mScribbleQuestion != nil{
                mScribbleQuestion.didGetEvaluatingMessage()
            }

        }
        else if currentQuestionType == kText
        {
            if mTextQuestion != nil
            {
                mTextQuestion.didGetEvaluatingMessage()
            }

        }
        
    }
    
    
    func delegateEditButtonPressedWithOverlayImage(_ overlay: UIImage)
    {
        if (currentQuestionDetails.object(forKey: kQuestionName) as? String) != ""
        {
          delegate().delegateFullScreenButtonPressedWithOverlayImage!(overlay, withQuestionName: (currentQuestionDetails.object(forKey: kQuestionName) as! String))
        }
        else
        {
             delegate().delegateFullScreenButtonPressedWithOverlayImage!(overlay, withQuestionName: "")
        }
        
        
    }
    
    func setFullScreenDrawnImage(_ image:UIImage)
    {
        if mScribbleQuestion != nil
        {
            mScribbleQuestion.setDrawnImage(image)
        }

    }
    
    func getFeedbackDetailsWithId(_ AssesmentAnswerId:String)
    {
        SSStudentDataSource.sharedDataSource.getFeedbackFromTeacherForAssesment(AssesmentAnswerId, withDelegate: self)
    }
    func didGetAnswerFeedBackWithDetails(_ details: AnyObject) {
        
       
        print(details)
        
        if currentQuestionType == kOverlayScribble || currentQuestionType == kFreshScribble
        {
            if mScribbleQuestion != nil
            {
                mScribbleQuestion.getFeedBackDetails(details)
            }
            
        }
        else if currentQuestionType == kText
        {
            if mTextQuestion != nil
            {
                mTextQuestion.getFeedBackDetails(details)
            }
            
        }
        
        
    }
    
    
    func getPeakViewMessage()
    {
        
        if currentQuestionType == kOverlayScribble || currentQuestionType == kFreshScribble
        {
            if mScribbleQuestion != nil
            {
                mScribbleQuestion.getPeakViewMessageFromTeacher()
            }
            
        }
        else if currentQuestionType == kText
        {
            if mTextQuestion != nil
            {
                mTextQuestion.getPeakViewMessageFromTeacher()
            }
            
        }
        else if currentQuestionType == OneString || currentQuestionType == TextAuto
        {
            if mOneStringQuestionView != nil
            {
                mOneStringQuestionView.getPeakViewMessageFromTeacher()
            }
            
        }
        
        
       
    }
    
    func didgetErrorMessage(_ message: String, WithServiceName serviceName: String) {
        
    }
    
    
    func modelAnswrMessageRecieved()
    {
        if currentQuestionType == kOverlayScribble || currentQuestionType == kFreshScribble
        {
            if mScribbleQuestion != nil
            {
                mScribbleQuestion.showModelAnswerWithDetails()
            }
            
        }
        else if currentQuestionType == kText
        {
            if mTextQuestion != nil
            {
                mTextQuestion.showModelAnswerWithDetails()
            }
            
        }
    }
    
}
