//
//  SSTeacherSubmissionView.swift
//  LearniatTeacher
//
//  Created by Deepak MK on 02/04/16.
//  Copyright © 2016 Mindshift. All rights reserved.
//

import Foundation
class SSTeacherSubmissionView: UIView
{
    var _delgate: AnyObject!
    
    var studentGraphView = StudentAnswerGraphView()
    
    
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
    
    
    func addGraphViewWithQuestionDetails(_currentQuestionDetials:AnyObject)
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
        

        
        
        studentGraphView.frame  = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)
        self.addSubview(studentGraphView)
        
        if let questionName = (_currentQuestionDetials.objectForKey("Name")) as? String
        {
             studentGraphView.loadViewWithOPtions(optionArray, withQuestion: questionName)
        }
        else
        {
             studentGraphView.loadViewWithOPtions(optionArray, withQuestion: "")
        }
        
        
       
        
        
    }
    
    
    
    
    
    
    
}