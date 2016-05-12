//
//  StudentQuestionView.swift
//  LearniatStudent
//
//  Created by Deepak MK on 10/05/16.
//  Copyright © 2016 Mindshift. All rights reserved.
//

import Foundation
class StudentQuestionView: UIView
{
    var noQuestionslabel = UILabel()
    
    var currentQuestionDetails :AnyObject!
    
    var mMultipleQuestion : MultipleChoiceView!
    
    var mMatchColumn        :MatchColumnView!
    
    var currentQuestionType = ""
    
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
        
        currentQuestionDetails = questionDetails
        currentQuestionType = QuestionType
        print(questionDetails)
        
        noQuestionslabel.hidden = true
        
        
        if QuestionType == MultipleChoice || QuestionType == MultipleResponse
        {
            if mMultipleQuestion != nil{
                mMultipleQuestion.removeFromSuperview()
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
            
            mMatchColumn = MatchColumnView(frame:CGRectMake(0,0,self.frame.size.width,self.frame.size.height))
            self.addSubview(mMatchColumn)
            mMatchColumn.setQuestionDetails(questionDetails ,withsessionDetails: sessionDetails, withQuestionLogId: _logId)
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
        noQuestionslabel.hidden = false
        if SSStudentDataSource.sharedDataSource.answerSent == true
        {
            self.makeToast("Question cleared by teacher.", duration: 2.0, position: .Bottom)
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
        
        
    }
    
    
}