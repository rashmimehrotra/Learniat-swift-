//
//  SubmissionMTCView.swift
//  LearniatTeacher
//
//  Created by Deepak MK on 06/04/16.
//  Copyright © 2016 Mindshift. All rights reserved.
//

import Foundation

@objc protocol SubmissionMTCViewDelegate
{
    
    optional func delegateOptionTouchedWithId(optionId: String, withView barButton: BarView)
    
    
}



class SubmissionMTCView: UIView,StudentAnswerGraphViewDelegate
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
        
        
        
        let leftSideArray = NSMutableArray()
        
        let RightSideArray = NSMutableArray()
        
        for index in 0 ..< optionArray.count
        {
            
            let optionDict = optionArray.objectAtIndex(index)
            
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
        
        if let questionName = (_currentQuestionDetials.objectForKey("Name")) as? String
        {
            studentGraphView.loadMTCViewWithOPtions(leftSideArray,WithRightSideOptionArray: RightSideArray, withQuestion: questionName)
        }
        else
        {
            studentGraphView.loadMTCViewWithOPtions(leftSideArray,WithRightSideOptionArray: RightSideArray, withQuestion: "")
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
        
        
        
        for answerIndex in 0 ..< studentAnsweOptions.count
        {
            let answerOptiondict = studentAnsweOptions.objectAtIndex(answerIndex)
            
            
            if let OldSequence = answerOptiondict.objectForKey("OldSequence") as? String
            {
                if let Sequence = answerOptiondict.objectForKey("Sequence") as? String
                {
                    if OldSequence == Sequence
                    {
                        if let rightOptionText = (answerOptiondict.objectForKey("OptionText")) as? String
                         {
                            studentGraphView.increaseBarValueWithOptionText(rightOptionText)
                        }
                        
                        
                    }
                }
            }
           
        }
        
        //        let optionIdValues = getOptionIdArrayWithGivenOPtions(studentFinalAsnwer)
//        
//        for (var index = 0; index < optionIdValues.count; index++)
//        {
//            if let optionId = optionIdValues.objectAtIndex(index) as? String
//            {
//                studentGraphView.increaseBarValueWithOPtionID(optionId)
//            }
//        }
        
        
        
    }
    // MARK: - GraphView delegate
    
    func delegateBarTouchedWithId(optionId: String, withView barButton: BarView) {
        
        if delegate().respondsToSelector(#selector(SubmissionMTCViewDelegate.delegateOptionTouchedWithId(_:withView:)))
        {
            delegate().delegateOptionTouchedWithId!(optionId,withView:barButton)
        }
        
    }
    
    func delegateShareButtonClickedWithDetails(details: AnyObject)
    {
         SSTeacherMessageHandler.sharedMessageHandler.shareGraphtoiPhoneStudentId("question_\(SSTeacherDataSource.sharedDataSource.currentLiveSessionId)", withDetails: details)
        
    }
    
    
    
    
}