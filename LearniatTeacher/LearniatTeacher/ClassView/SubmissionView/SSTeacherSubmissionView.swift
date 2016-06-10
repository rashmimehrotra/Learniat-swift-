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
    
    
    optional func delegateTeacherEvaluatedReplyWithDetails(details:AnyObject, withStudentId studentId:String)
    
    
    
    
}

class SSTeacherSubmissionView: UIView,SubmissionMRQViewDelegate,SubmissionSubjectiveViewDelegate,OneStringGraphViewDelegate,OnewordAnswerViewDelegate
{
    var _delgate: AnyObject!
    
    var mMRQSubmissionView : SubmissionMRQView!
    
    var mMTCSubmissionView : SubmissionMTCView!
    
    var mScribbleSubmissionView : SubmissionSubjectiveView!
    
    var mOneStringQuestionView : OneStringGraphView!
    
    var mOneWordQuestionView : OnewordAnswerView!
    
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
        noSubmissionLabel.hidden = false
        mScribbleSubmissionView.hidden = true
        mCurrentQuestionDetails = details
    }
    
    
    func addOneStringQuestionWithDetails(details:AnyObject)
    {
        if mOneStringQuestionView == nil
        {
            
            mOneStringQuestionView = OneStringGraphView(frame: CGRectMake(0, 0, self.frame.size.width, self.frame.size.height))
            self.addSubview(mOneStringQuestionView)
            mOneStringQuestionView.setdelegate(self)
            
            if let questionName = (details.objectForKey("Name")) as? String
            {
                mOneStringQuestionView.setQuestionName(questionName , withDetails:details )
            }
        }
        
        if mOneWordQuestionView == nil
        {
            
            mOneWordQuestionView = OnewordAnswerView(frame: CGRectMake(0, 0, self.frame.size.width, self.frame.size.height))
            self.addSubview(mOneWordQuestionView)
            mOneWordQuestionView.setdelegate(self)
            
            if let questionName = (details.objectForKey("Name")) as? String
            {
                mOneWordQuestionView.setQuestionName(questionName, withDetails:details)
            }
            
            
            
        }
        mOneWordQuestionView.hidden = true
        
        noSubmissionLabel.hidden = true
        mOneStringQuestionView.hidden = false
        mCurrentQuestionDetails = details
    }
    
    
    
    func addOneWordQuestionViewWithDetails(details:AnyObject)
    {
        
//        noSubmissionLabel.hidden = true
//        mOneWordQuestionView.hidden = false
//        mCurrentQuestionDetails = details
    }
    
    
    
    func studentAnswerRecievedWIthDetails(details:AnyObject, withStudentDict studentdict:AnyObject)
    {
        
        
        noSubmissionLabel.hidden = true
        
        if let questionType = mCurrentQuestionDetails.objectForKey("Type") as? String
        {
            
            if (questionType  == kOverlayScribble  || questionType == kFreshScribble)
            {
                mScribbleSubmissionView.setStudentAnswerWithAnswer(details, withStudentDict: studentdict, withQuestionDict:mCurrentQuestionDetails)
                mScribbleSubmissionView.hidden = false
            }
            else if (questionType == kText)
            {
                mScribbleSubmissionView.setStudentAnswerWithAnswer(details, withStudentDict: studentdict, withQuestionDict:mCurrentQuestionDetails)
                mScribbleSubmissionView.hidden = false
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
    
    
    func SetStudentOneStringAnswer(studentAnswer:String,withStudentDict studentdict:AnyObject)
    {
       
        if mOneStringQuestionView !=  nil
        {
//             mOneStringQuestionView.hidden = false
            
            if let questionType = mCurrentQuestionDetails.objectForKey("Type") as? String
            {
                if (questionType  == kOverlayScribble  || questionType == kFreshScribble)
                {
                    mOneStringQuestionView.setOptionWithString(studentAnswer, withCheckingState: true)
                }
                else
                {
                    mOneStringQuestionView.setOptionWithString(studentAnswer, withCheckingState:false )
                }
            }
            
            
        }
        
        
        
        if mOneWordQuestionView !=  nil
        {
//            mOneWordQuestionView.hidden = false
            mOneWordQuestionView.setOptionWithString(studentAnswer)
        }

        
    }
    
    func studentSubmissionEvaluatedWithDetails(evaluationDetails:AnyObject, withStdentId StudentId:String)
    {
        if mScribbleSubmissionView != nil
        {
            mScribbleSubmissionView.submissionEvaluatedWithDetails(evaluationDetails, withStudentId: StudentId)
            
        }
    }
    
    
    
    func studentAnswerWithdrawnWithStudentId(studentId:String)
    {
        if mScribbleSubmissionView != nil
        {
            if mScribbleSubmissionView.removeStudentAnswerWithStudentId(studentId) <= 0
            {
                mScribbleSubmissionView.hidden = true
                noSubmissionLabel.hidden = false
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
        
        if mScribbleSubmissionView != nil
        {
            mScribbleSubmissionView.hidden = true
            mScribbleSubmissionView.questionCleared()
            
        }
        
        if mOneStringQuestionView != nil
        {
            mOneStringQuestionView.hidden = true
            mOneStringQuestionView.removeFromSuperview()
            mOneStringQuestionView = nil
        }
        
        if mOneWordQuestionView != nil
        {
            mOneWordQuestionView.hidden = true
            mOneWordQuestionView.removeFromSuperview()
            mOneWordQuestionView = nil
            
        }
        
    }
    
    
    
     // MARK: - MRQ GraphView delegate
    
    func delegateOptionTouchedWithId(optionId: String, withView barButton: BarView) {
        
        if delegate().respondsToSelector(#selector(SSTeacherSubmissionViewDelegate.delegateGetaggregateWithOptionId(_:withView:)))
        {
            delegate().delegateGetaggregateWithOptionId!(optionId,withView:barButton)
        }
        
    }
    
    
    // MARK: - SubJectiveView   delegate
    
    func delegateStudentSubmissionEvaluatedWithDetails(evaluationDetails: AnyObject, withStudentId studentId: String, withSubmissionCount SubmissionCount: Int)
    {
        
        if SubmissionCount <= 0
        {
            mScribbleSubmissionView.hidden = true
            noSubmissionLabel.hidden = false
        }
        
        if delegate().respondsToSelector(#selector(SSTeacherSubmissionViewDelegate.delegateTeacherEvaluatedReplyWithDetails(_:withStudentId:)))
        {
            delegate().delegateTeacherEvaluatedReplyWithDetails!(evaluationDetails, withStudentId: studentId)
        }
    }
    
    
    // MARK: - Graph or  wordCloud delegate
    
    
    func delegateGraphButtonPressed()
    {
        if mOneStringQuestionView !=  nil
        {
             mOneStringQuestionView.hidden = false
           
        }
        
        if mOneWordQuestionView !=  nil
        {
            mOneWordQuestionView.hidden = true
            
        }
    }
    
    func delegateWordCloudButtonPressed()
    {
        if mOneWordQuestionView !=  nil
        {
            mOneWordQuestionView.hidden = false
            
        }
        
        if mOneStringQuestionView !=  nil
        {
            mOneStringQuestionView.hidden = true
            
        }
        
    }
    
    
    
    
    
}