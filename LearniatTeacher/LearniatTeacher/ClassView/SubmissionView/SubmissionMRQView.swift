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
    
    @objc optional func delegateOptionTouchedWithId(_ optionId: String, withView barButton: BarView)
    
    
}


class SubmissionMRQView: UIView,StudentAnswerGraphViewDelegate
{
    var _delgate: AnyObject!
    
    
    var studentGraphView : StudentAnswerGraphView!
    
    var _currentQuestionDetials:AnyObject!
    
    var currentQuestionOptionsArray = NSMutableArray()
    
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
        super.init(frame:frame)
        
        
    }
    
    
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    func addGraphViewforWithQuestionDetails(_ _currentQuestionDetials:AnyObject)
    {
        
        var optionArray = NSMutableArray()
        
        if let options = _currentQuestionDetials.object(forKey: kOptionTagMain)
        {
            if let classCheckingVariable = (options as AnyObject).object(forKey: "Option") as? NSMutableArray
            {
                optionArray = classCheckingVariable
                
            }
            else
            {
                if let option =  (options as AnyObject).object(forKey: "Option") as? NSMutableDictionary
                {
                    optionArray.add(option)
                }
            }
        }
        
        currentQuestionOptionsArray = optionArray
        
        if studentGraphView == nil
        {
            studentGraphView = StudentAnswerGraphView(frame: CGRect(x: 0, y: 0, width: self.frame.size.width, height: self.frame.size.height))
            self.addSubview(studentGraphView)
            studentGraphView.setdelegate(self)
        }
        
        if let questionName = (_currentQuestionDetials.object(forKey: "Name")) as? String
        {
            studentGraphView.loadMRQViewWithOPtions(optionArray, withQuestion: questionName)
        }
        else
        {
            studentGraphView.loadMRQViewWithOPtions(optionArray, withQuestion: "")
        }
    }
    
    
    func didgetStudentsAnswerWithDetails(_ details:AnyObject)
    {
        
        var studentAnsweOptions = NSMutableArray()
        if let options = details.object(forKey: kOptionTagMain)
        {
            if let classCheckingVariable = (options as AnyObject).object(forKey: "Option") as? NSMutableArray
            {
                studentAnsweOptions = classCheckingVariable
               
            }
            else
            {
                studentAnsweOptions.add((details.object(forKey: kOptionTagMain)! as AnyObject).object(forKey: "Option")!)
                
            }
        }
        
        
        
        let studentFinalAsnwer = NSMutableArray()
        for answerIndex in 0 ..< studentAnsweOptions.count
        {
            let answerOptiondict = studentAnsweOptions.object(at: answerIndex)
            
            if let answerOptionText = (answerOptiondict as AnyObject).object(forKey: "OptionText") as? String
            {
                studentFinalAsnwer.add(answerOptionText)
                
            }
        }
        
        
        
        let optionIdValues = getOptionIdArrayWithGivenOPtions(studentFinalAsnwer)
        
        for index in 0 ..< optionIdValues.count
        {
            if let optionId = optionIdValues.object(at: index) as? String
            {
                studentGraphView.increaseBarValueWithOPtionID(optionId)
            }
        }
        
        
        
    }
    
    
    
    
    
    func getOptionIdArrayWithGivenOPtions(_ answerOptionsArray:NSMutableArray) -> NSMutableArray
    {
        
        let optionIdArray = NSMutableArray()
        
        
        for answerIndex in 0 ..< currentQuestionOptionsArray.count
        {
            let questionOptiondict = currentQuestionOptionsArray.object(at: answerIndex)
            
            if let OptionText = (questionOptiondict as AnyObject).object(forKey: "OptionText") as? String
            {
                
                for index in 0 ..< answerOptionsArray.count
                {
                    if let answerOption = answerOptionsArray.object(at: index) as? String
                    {
                        if OptionText == answerOption
                        {
                            if let optionId = (questionOptiondict as AnyObject).object(forKey: "OptionId") as? String
                            {
                                optionIdArray.add(optionId)
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
    
    func delegateBarTouchedWithId(_ optionId: String, withView barButton: BarView) {
        
        if delegate().responds(to: #selector(SubmissionMRQViewDelegate.delegateOptionTouchedWithId(_:withView:)))
        {
            delegate().delegateOptionTouchedWithId!(optionId,withView:barButton)
        }
        
    }
    
    func delegateShareButtonClickedWithDetails(_ details: AnyObject)
    {
        SSTeacherMessageHandler.sharedMessageHandler.shareGraphtoiPhoneStudentId("question_\(SSTeacherDataSource.sharedDataSource.currentLiveSessionId)", withDetails: details)
        
    }
    
    
    
    
}
