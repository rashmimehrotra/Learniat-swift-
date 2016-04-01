//
//  StudentAnswerOptionsView.swift
//  LearniatTeacher
//
//  Created by Deepak MK on 01/04/16.
//  Copyright © 2016 Mindshift. All rights reserved.
//

import Foundation
class StudentAnswerOptionsView: UIView
{
    
    var _currentQuestionDetials :AnyObject!
    
    var _studentFinalAnswerOptions = NSMutableArray()
    
    override init(frame: CGRect) {
        
        super.init(frame:frame)
        
    }
    
    
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
        
        
    }
    
    
    func addOptionsWithAnswerDetails(answerDetails: AnyObject, withQuestionDetails questionDetails :AnyObject)
    {
        _currentQuestionDetials = questionDetails
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
        
        
        
        if let Type = _currentQuestionDetials.objectForKey("Type") as? String
        {
            if Type == "Multiple Choice"
            {
                addSingleResponseQuestionAnswerWithDetails(answerDetails,withQuestionOptionsArray: optionArray)
            }
            else if Type == "Multiple Response"
            {
                addMultipleResponseQuestionAnswerWithDetails(answerDetails,withQuestionOptionsArray: optionArray)
            }
        }
    }
    
    
    func addSingleResponseQuestionAnswerWithDetails(answerDetails:AnyObject, withQuestionOptionsArray questionOptions:NSMutableArray)
    {
        let studentAnsweOption = NSMutableArray()
        
        if let options = answerDetails.objectForKey("Options")
        {
            if let classCheckingVariable = options.objectForKey("Option")
            {
                if let _studentAnswerOption = classCheckingVariable.objectForKey("OptionText") as?String
                {
                    studentAnsweOption .addObject( _studentAnswerOption)
                }
            }
        }
        
        let optionsDetails =  getOptionsValuesWithOptionsArray(studentAnsweOption, withQuestionOptions: questionOptions)
        addCheckMarksForMultipleResponseWithOptionsDetails(optionsDetails)
        
    }
    
    func addMultipleResponseQuestionAnswerWithDetails(answerDetails:AnyObject, withQuestionOptionsArray questionOptions:NSMutableArray)
    {
        var studentAnsweOptions = NSMutableArray()
        if let options = answerDetails.objectForKey("Options")
        {
            if let classCheckingVariable = options.objectForKey("Option")
            {
                if classCheckingVariable.isKindOfClass(NSMutableArray)
                {
                    studentAnsweOptions = classCheckingVariable as! NSMutableArray
                }
                else
                {
                    studentAnsweOptions.addObject(answerDetails.objectForKey("Options")!.objectForKey("Option")!)
                    
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
        
        
        let optionsDetails =  getOptionsValuesWithOptionsArray(studentFinalAsnwer, withQuestionOptions: questionOptions)
        addCheckMarksForMultipleResponseWithOptionsDetails(optionsDetails)
        
        
        
    }
    
    
    func getOptionsValuesWithOptionsArray(answerOptions:NSMutableArray, withQuestionOptions questionOptions:NSMutableArray)-> NSMutableArray
    {
        
        for (var index = 0; index < questionOptions.count; index++)
        {
            let questionOptiondict = questionOptions.objectAtIndex(index)
            
            if let questionOptionText = questionOptiondict.objectForKey("OptionText") as? String
            {
                for (var answerIndex = 0; answerIndex < answerOptions.count; answerIndex++)
                {
                    if let answerOptionText = answerOptions.objectAtIndex(answerIndex) as? String
                    {
                        if answerOptionText == questionOptionText
                        {
                            if let IsAnswer = questionOptiondict.objectForKey("IsAnswer") as? String
                            {
                                if IsAnswer == "1"
                                {
                                    questionOptiondict.setObject(KCorretValue, forKey: "IsAnswer")
                                    questionOptions.replaceObjectAtIndex(index, withObject: questionOptiondict)
                                }
                                else
                                {
                                    questionOptiondict.setObject(kWrongvalue, forKey: "IsAnswer")
                                    questionOptions.replaceObjectAtIndex(index, withObject: questionOptiondict)
                                }
                            }
                            
                            
                            break
                        }
                        
                    }
                }
            }
        }
        
        for (var index = 0; index < questionOptions.count; index++)
        {
            let questionOptiondict = questionOptions.objectAtIndex(index)
            
            if let IsAnswer = questionOptiondict.objectForKey("IsAnswer") as? String
            {
                if IsAnswer == "0" || IsAnswer == "1"
                {
                    questionOptiondict.setObject(kMissedValue, forKey: "IsAnswer")
                    questionOptions.replaceObjectAtIndex(index, withObject: questionOptiondict)
                }
                
            }
        }
        
        _studentFinalAnswerOptions = questionOptions
        
        return questionOptions
    }
    
    
    func addCheckMarksForMultipleResponseWithOptionsDetails(optionsDetails:NSMutableArray)
    {
        
        
        
        let subViews = self.subviews.flatMap{ $0 as? UIImageView }
        
        for subview in subViews
        {
            if subview.isKindOfClass(UIImageView)
            {
                subview.removeFromSuperview()
            }
        }
        
        
        if optionsDetails.count > 0
        {
            var  count :CGFloat = CGFloat(optionsDetails.count)
            var numberOfRow :CGFloat = 1
            var numberOfcolumn :CGFloat = 1
            
            
            
            if (count % 2 != 0)
            {
                
                count = count+1;
            }
            
            numberOfcolumn = count / 2;
            numberOfRow = 2;
            
            
            var barWidth = self.frame.size.width / numberOfcolumn
            let widthSpace = (barWidth * 0.6)
            barWidth = (barWidth * 0.4)
            var width = widthSpace / 2
            
            var barHeight = self.frame.size.height / numberOfRow
            
            let heightSpace = (barHeight * 0.6)
            barHeight = (barHeight * 0.4)
            var height = heightSpace / 2
            
            var optionsArrayCount = 0
            
            
            for (var i = 0; i < Int(numberOfRow); i++)
            {
                for (var j = 0; j < Int(numberOfcolumn); j++)
                {
                    let containerView =  UIImageView(frame:CGRectMake(width, height, barWidth, barHeight))
                    self.addSubview(containerView);
                    
                    let studentDesk = UIImageView()
                    
                    if containerView.frame.size.width > containerView.frame.size.height
                    {
                        studentDesk.frame = CGRectMake((containerView.frame.size.width - containerView.frame.size.height)/2 , (containerView.frame.size.width - containerView.frame.size.height)/2, containerView.frame.size.height, containerView.frame.size.height)
                    }
                    else
                    {
                        studentDesk.frame = CGRectMake((containerView.frame.size.height - containerView.frame.size.width)/2 , (containerView.frame.size.height - containerView.frame.size.width)/2, containerView.frame.size.width, containerView.frame.size.width)
                    }
                    
                    containerView.addSubview(studentDesk)
                    
                    studentDesk.contentMode = .ScaleAspectFit
                    
                    studentDesk.backgroundColor = topicsLineColor
                    
                    if optionsArrayCount < optionsDetails.count
                    {
                        let questionOptiondict = optionsDetails.objectAtIndex(optionsArrayCount)
                        
                        if let IsAnswer = questionOptiondict.objectForKey("IsAnswer") as? String
                        {
                            if IsAnswer == KCorretValue
                            {
                                studentDesk.image = UIImage(named: "Check.png")
                                studentDesk.backgroundColor = UIColor.clearColor()
                            }
                            else if IsAnswer == kWrongvalue
                            {
                                studentDesk.image = UIImage(named: "X.png")
                                studentDesk.backgroundColor = UIColor.clearColor()
                            }
                        }
                        optionsArrayCount = optionsArrayCount + 1
                    }
                    width = width + widthSpace + barWidth;
                }
                width=widthSpace/2;
                height=height+heightSpace+barHeight;
            }
        }
    }
    
    
    
}