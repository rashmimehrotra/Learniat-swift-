//
//  QuizModeView.swift
//  LearniatTeacher
//
//  Created by Deepak MK on 01/06/16.
//  Copyright © 2016 Mindshift. All rights reserved.
//

import Foundation
import UIKit
class QuizModeView: UIView
{
    
    
    var currentQuestionsArray = NSMutableArray()
    
    override init(frame: CGRect)
    {
        super.init(frame: frame)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func setQuestionWithDetails(questionsArray:NSMutableArray)
    {
        
        currentQuestionsArray.removeAllObjects()
        
        for index in 0 ..< questionsArray.count
        {
            let questionDict  = questionsArray.objectAtIndex(index)
            
            if let questionType = questionDict.objectForKey("Type")as? NSString
            {
                if questionType == kMRQ || questionType == kMCQ
                {
                    
                }
            }
            
            
        }
    }
    
}