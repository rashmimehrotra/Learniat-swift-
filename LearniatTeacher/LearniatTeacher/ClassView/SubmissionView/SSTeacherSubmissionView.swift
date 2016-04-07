//
//  SSTeacherSubmissionView.swift
//  LearniatTeacher
//
//  Created by Deepak MK on 02/04/16.
//  Copyright © 2016 Mindshift. All rights reserved.
//

import Foundation

@objc protocol SSTeacherSubmissionViewDelegate
{
    
    optional func delegateGetaggregateWithOptionId(optionId: String, withView barButton: BarView)
    
    
}

class SSTeacherSubmissionView: UIView,SubmissionMRQViewDelegate
{
    var _delgate: AnyObject!
    
    var mMRQSubmissionView : SubmissionMRQView!
    
    var mMTCSubmissionView : SubmissionMTCView!
    
    var mScribbleSubmissionView : SubmissionSubjectiveView!
    
    var noSubmissionLabel = UILabel()
    
    var mCurrentQuestionDetails:AnyObject!
   
    
    override init(frame: CGRect)
    {
        
        super.init(frame:frame)
        
        
       
    }
    
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
        
        
    }
    
    
    
    func loadViewWithDetails()
    {
        noSubmissionLabel.frame = CGRectMake(0, (self.frame.size.height - 300)/2, self.frame.size.width, 300)
        self.addSubview(noSubmissionLabel)
        noSubmissionLabel.text = "There are no submission Yet"
        noSubmissionLabel.textColor = blackTextColor
        noSubmissionLabel.hidden = false
        noSubmissionLabel.textAlignment = .Center
        noSubmissionLabel.font =  UIFont(name: helveticaMedium, size: 35);
    }
    
    
    func setdelegate(delegate:AnyObject)
    {
        _delgate = delegate;
    }
    
    func   delegate()->AnyObject
    {
        return _delgate;
    }
    
    
    func addMRQQuestionWithDetails(details:AnyObject)
    {
        if mMRQSubmissionView == nil
        {
            mMRQSubmissionView = SubmissionMRQView()
            mMRQSubmissionView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)
            self.addSubview(mMRQSubmissionView)
            mMRQSubmissionView.setdelegate(self)
        }
        mMRQSubmissionView.addGraphViewforWithQuestionDetails(details)
        noSubmissionLabel.hidden = true
        mMRQSubmissionView.hidden = false
        
        mCurrentQuestionDetails = details
        
    }
    
    func addMTCQuestionWithDetails(details:AnyObject)
    {
        if mMTCSubmissionView == nil
        {
            mMTCSubmissionView = SubmissionMTCView()
            mMTCSubmissionView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)
            self.addSubview(mMTCSubmissionView)
            mMTCSubmissionView.setdelegate(self)
        }
        mMTCSubmissionView.addGraphViewforWithQuestionDetails(details)
        noSubmissionLabel.hidden = true
        mMTCSubmissionView.hidden = false
         mCurrentQuestionDetails = details
    }
    
    
    
    func addScribbleQuestionWithDetails(details:AnyObject)
    {
        if mScribbleSubmissionView == nil
        {
            mScribbleSubmissionView = SubmissionSubjectiveView(frame: CGRectMake(0, 0, self.frame.size.width, self.frame.size.height))
            self.addSubview(mScribbleSubmissionView)
            mScribbleSubmissionView.setdelegate(self)
        }
        noSubmissionLabel.hidden = true
        mScribbleSubmissionView.hidden = false
        mCurrentQuestionDetails = details
    }
    
    
    
    func studentAnswerRecievedWIthDetails(details:AnyObject, withStudentDict studentdict:AnyObject)
    {
        
        
        
        
        if let questionType = mCurrentQuestionDetails.objectForKey("Type") as? String
        {
            
            if (questionType  == kOverlayScribble  || questionType == kFreshScribble)
            {
                mScribbleSubmissionView.setStudentAnswerWithAnswer(details, withStudentDict: studentdict, withQuestionDict:mCurrentQuestionDetails)
            }
            else if (questionType == kText)
            {
                mScribbleSubmissionView.setStudentAnswerWithAnswer(details, withStudentDict: studentdict, withQuestionDict:mCurrentQuestionDetails)
            }
            else if (questionType == kMatchColumn)
            {
                if mMTCSubmissionView !=  nil
                {
                    mMTCSubmissionView.didgetStudentsAnswerWithDetails(details)
                }
            }
            else
            {
                if mMRQSubmissionView !=  nil
                {
                    mMRQSubmissionView.didgetStudentsAnswerWithDetails(details)
                }
                
            }
        }
        
        
       
        
        
        
        
        
    }
    
    func questionClearedByTeacher()
    {
        noSubmissionLabel.hidden = false
        if mMRQSubmissionView != nil
        {
            mMRQSubmissionView.hidden = true
        }
        if mMTCSubmissionView != nil
        {
            mMTCSubmissionView.hidden = true
        }
        
    }
    
    
    
     // MARK: - MRQ GraphView delegate
    
    func delegateOptionTouchedWithId(optionId: String, withView barButton: BarView) {
        
        if delegate().respondsToSelector(Selector("delegateGetaggregateWithOptionId:withView:"))
        {
            delegate().delegateGetaggregateWithOptionId!(optionId,withView:barButton)
        }
        
    }
    
    
    
}