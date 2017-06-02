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
    
    @objc optional func delegateOptionTouchedWithId(_ optionId: String, withView barButton: BarView)
    
    
}



class SubmissionMTCView: UIView,StudentAnswerGraphViewDelegate
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
                optionArray.add((_currentQuestionDetials.object(forKey: kOptionTagMain)! as AnyObject).object(forKey: "Option")!)
                
            }
        }
        
        
        
        
        
        
        
        
        
        currentQuestionOptionsArray = optionArray
        
        if studentGraphView == nil
        {
            studentGraphView = StudentAnswerGraphView(frame: CGRect(x: 0, y: 0, width: self.frame.size.width, height: self.frame.size.height))
            self.addSubview(studentGraphView)
            studentGraphView.setdelegate(self)
        }
        
        
        
        let leftSideArray = NSMutableArray()
        
        let RightSideArray = NSMutableArray()
        
        for index in 0 ..< optionArray.count
        {
            
            let optionDict = optionArray.object(at: index)
            
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
        
        if let questionName = (_currentQuestionDetials.object(forKey: "Name")) as? String
        {
            studentGraphView.loadMTCViewWithOPtions(leftSideArray,WithRightSideOptionArray: RightSideArray, withQuestion: questionName)
        }
        else
        {
            studentGraphView.loadMTCViewWithOPtions(leftSideArray,WithRightSideOptionArray: RightSideArray, withQuestion: "")
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
        
        
        
        for answerIndex in 0 ..< studentAnsweOptions.count
        {
            let answerOptiondict = studentAnsweOptions.object(at: answerIndex)
            
            
            if let OldSequence = (answerOptiondict as AnyObject).object(forKey: "OldSequence") as? String
            {
                if let Sequence = (answerOptiondict as AnyObject).object(forKey: "Sequence") as? String
                {
                    if OldSequence == Sequence
                    {
                        if let rightOptionText = ((answerOptiondict as AnyObject).object(forKey: "OptionText")) as? String
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
    
    func delegateBarTouchedWithId(_ optionId: String, withView barButton: BarView) {
        
        if delegate().responds(to: #selector(SubmissionMTCViewDelegate.delegateOptionTouchedWithId(_:withView:)))
        {
            delegate().delegateOptionTouchedWithId!(optionId,withView:barButton)
        }
        
    }
    
    func delegateShareButtonClickedWithDetails(_ details: AnyObject)
    {
         SSTeacherMessageHandler.sharedMessageHandler.shareGraphtoiPhoneStudentId("question_\(SSTeacherDataSource.sharedDataSource.currentLiveSessionId)", withDetails: details)
        
    }
    
    
    
    
}
