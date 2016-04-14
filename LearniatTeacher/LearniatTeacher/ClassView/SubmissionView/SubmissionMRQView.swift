//
//  SubmissionMRQView.swift
//  LearniatTeacher
//
//  Created by Deepak MK on 02/04/16.
//  Copyright © 2016 Mindshift. All rights reserved.
//

import Foundation

@objc protocol SubmissionMRQViewDelegate
{
    
    optional func delegateOptionTouchedWithId(optionId: String, withView barButton: BarView)
    
    
}


class SubmissionMRQView: UIView,StudentAnswerGraphViewDelegate
{
    var _delgate: AnyObject!
    
    
    var studentGraphView : StudentAnswerGraphView!
    
    var _currentQuestionDetials:AnyObject!
    
    var currentQuestionOptionsArray = NSMutableArray()
    
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
        super.init(frame:frame)
        
        
    }
    
    
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    func addGraphViewforWithQuestionDetails(_currentQuestionDetials:AnyObject)
    {
        
        var optionArray = NSMutableArray()
        
        if let options = _currentQuestionDetials.objectForKey("Options")
        {
            if let classCheckingVariable = options.objectForKey("Option")
            {
                if classCheckingVariable.isKindOfClass(NSMutableArray)
                {
                    optionArray = classCheckingVariable as! NSMutableArray
                }
                else
                {
                    optionArray.addObject(_currentQuestionDetials.objectForKey("Options")!.objectForKey("Option")!)
                    
                }
            }
        }
        
        currentQuestionOptionsArray = optionArray
        
        if studentGraphView == nil
        {
            studentGraphView = StudentAnswerGraphView(frame: CGRectMake(0, 0, self.frame.size.width, self.frame.size.height))
            self.addSubview(studentGraphView)
            studentGraphView.setdelegate(self)
        }
        
        if let questionName = (_currentQuestionDetials.objectForKey("Name")) as? String
        {
            studentGraphView.loadMRQViewWithOPtions(optionArray, withQuestion: questionName)
        }
        else
        {
            studentGraphView.loadMRQViewWithOPtions(optionArray, withQuestion: "")
        }
    }
    
    
    func didgetStudentsAnswerWithDetails(details:AnyObject)
    {
        
        var studentAnsweOptions = NSMutableArray()
        if let options = details.objectForKey("Options")
        {
            if let classCheckingVariable = options.objectForKey("Option")
            {
                if classCheckingVariable.isKindOfClass(NSMutableArray)
                {
                    studentAnsweOptions = classCheckingVariable as! NSMutableArray
                }
                else
                {
                    studentAnsweOptions.addObject(details.objectForKey("Options")!.objectForKey("Option")!)
                    
                }
            }
        }
        
        
        
        let studentFinalAsnwer = NSMutableArray()
        for (var answerIndex = 0; answerIndex < studentAnsweOptions.count; answerIndex++)
        {
            let answerOptiondict = studentAnsweOptions.objectAtIndex(answerIndex)
            
            if let answerOptionText = answerOptiondict.objectForKey("OptionText") as? String
            {
                studentFinalAsnwer.addObject(answerOptionText)
                
            }
        }
        
        
        
        let optionIdValues = getOptionIdArrayWithGivenOPtions(studentFinalAsnwer)
        
        for (var index = 0; index < optionIdValues.count; index++)
        {
            if let optionId = optionIdValues.objectAtIndex(index) as? String
            {
                studentGraphView.increaseBarValueWithOPtionID(optionId)
            }
        }
        
        
        
    }
    
    
    
    
    
    func getOptionIdArrayWithGivenOPtions(answerOptionsArray:NSMutableArray) -> NSMutableArray
    {
        
        let optionIdArray = NSMutableArray()
        
        
        for (var answerIndex = 0; answerIndex < currentQuestionOptionsArray.count; answerIndex++)
        {
            let questionOptiondict = currentQuestionOptionsArray.objectAtIndex(answerIndex)
            
            if let OptionText = questionOptiondict.objectForKey("OptionText") as? String
            {
                
                for (var index = 0; index < answerOptionsArray.count; index++)
                {
                    if let answerOption = answerOptionsArray.objectAtIndex(index) as? String
                    {
                        if OptionText == answerOption
                        {
                            if let optionId = questionOptiondict.objectForKey("OptionId") as? String
                            {
                                optionIdArray.addObject(optionId)
                            }
                            
                            
                            break
                            
                        }
                    }
                }
                
                
            }
        }
        
        return optionIdArray
        
    }
    
    // MARK: - GraphView delegate
    
    func delegateBarTouchedWithId(optionId: String, withView barButton: BarView) {
        
        if delegate().respondsToSelector(Selector("delegateOptionTouchedWithId:withView:"))
        {
            delegate().delegateOptionTouchedWithId!(optionId,withView:barButton)
        }
        
    }
    
    func delegateShareButtonClickedWithDetails(details: AnyObject)
    {
        SSTeacherMessageHandler.sharedMessageHandler.shareGraphtoiPhoneStudentId("question_\(SSTeacherDataSource.sharedDataSource.currentLiveSessionId)", withDetails: details)
        
    }
    
    
    
    
}