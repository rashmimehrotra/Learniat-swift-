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



class SubmissionMTCView: UIView {
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
        
        
         print(optionArray)
        
        
        
        
        
        let leftSideArray = NSMutableArray()
        
        let RightSideArray = NSMutableArray()
        
        for var index = 0; index < optionArray.count ; index++
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
        
        
//        for var index = 0; index < leftSideArray.count ; index++
//        {
//            
//            let leftSideOptionDict = leftSideArray.objectAtIndex(index)
//            let rightSideOptionDict = RightSideArray.objectAtIndex(index)
//            
//            if var leftOptionText = (leftSideOptionDict.objectForKey("OptionText")) as? String
//            {
//                if let rightOptionText = (rightSideOptionDict.objectForKey("OptionText")) as? String
//                {
//                    leftOptionText = "\(leftOptionText)->\(rightOptionText)"
//                    
//                    leftSideOptionDict.setObject(leftOptionText, forKey: "OptionText")
//                    
//                    leftSideArray.replaceObjectAtIndex(index, withObject: leftSideOptionDict)
//                    
//                }
//            }
//            
//            
//            
//            
//            
//        }
        
        
        
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
        
        
        
        for (var answerIndex = 0; answerIndex < studentAnsweOptions.count; answerIndex++)
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
        
        if delegate().respondsToSelector(Selector("delegateOptionTouchedWithId:withView:"))
        {
            delegate().delegateOptionTouchedWithId!(optionId,withView:barButton)
        }
        
    }
    
    
}