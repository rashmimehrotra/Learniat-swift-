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
    
    @objc optional func delegateGetaggregateWithOptionId(_ optionId: String, withView barButton: BarView)
    
    
    @objc optional func delegateTeacherEvaluatedReplyWithDetails(_ details:AnyObject, withStudentId studentId:String)
    
    
    @objc optional func delegateQuestionSentWithQuestionDetails(_ questionDetails: AnyObject)
    
    
}

class SSTeacherSubmissionView: UIView,SubmissionMRQViewDelegate,SubmissionSubjectiveViewDelegate,OneStringGraphViewDelegate,OnewordAnswerViewDelegate,CollaborationMRQViewDelegate
{
    var _delgate: AnyObject!
    
    var mMRQSubmissionView : SubmissionMRQView!
    
    var mMTCSubmissionView : SubmissionMTCView!
    
    var mScribbleSubmissionView : SubmissionSubjectiveView!
    
    var mOneStringQuestionView : OneStringGraphView!
    
    var mOneWordQuestionView : OnewordAnswerView!
    
    var mCollaborationMRQView   :CollaborationMRQView!
    
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
        noSubmissionLabel.frame = CGRect(x: 0, y: (self.frame.size.height - 300)/2, width: self.frame.size.width, height: 300)
        self.addSubview(noSubmissionLabel)
        noSubmissionLabel.text = "There are no submission Yet"
        noSubmissionLabel.textColor = blackTextColor
        noSubmissionLabel.isHidden = false
        noSubmissionLabel.textAlignment = .center
        noSubmissionLabel.font =  UIFont(name: helveticaMedium, size: 35);
    }
    
    
    func setdelegate(_ delegate:AnyObject)
    {
        _delgate = delegate;
    }
    
    func   delegate()->AnyObject
    {
        return _delgate;
    }
    
    
    func addMRQQuestionWithDetails(_ details:AnyObject)
    {
        if mMRQSubmissionView == nil
        {
            mMRQSubmissionView = SubmissionMRQView()
            mMRQSubmissionView.frame = CGRect(x: 0, y: 0, width: self.frame.size.width, height: self.frame.size.height)
            self.addSubview(mMRQSubmissionView)
            mMRQSubmissionView.setdelegate(self)
        }
        mMRQSubmissionView.addGraphViewforWithQuestionDetails(details)
        noSubmissionLabel.isHidden = true
        mMRQSubmissionView.isHidden = false
        
        mCurrentQuestionDetails = details
        
        if mCollaborationMRQView != nil
        {
            mCollaborationMRQView.removeFromSuperview()
            mCollaborationMRQView = nil
            
        }
        
    }
    
    func addMTCQuestionWithDetails(_ details:AnyObject)
    {
        if mMTCSubmissionView == nil
        {
            mMTCSubmissionView = SubmissionMTCView()
            mMTCSubmissionView.frame = CGRect(x: 0, y: 0, width: self.frame.size.width, height: self.frame.size.height)
            self.addSubview(mMTCSubmissionView)
            mMTCSubmissionView.setdelegate(self)
        }
        mMTCSubmissionView.addGraphViewforWithQuestionDetails(details)
        noSubmissionLabel.isHidden = true
        mMTCSubmissionView.isHidden = false
         mCurrentQuestionDetails = details
        
        if mCollaborationMRQView != nil
        {
            mCollaborationMRQView.removeFromSuperview()
            mCollaborationMRQView = nil
            
        }
    }
    
    
    
    func addScribbleQuestionWithDetails(_ details:AnyObject)
    {
        if mScribbleSubmissionView == nil
        {
            mScribbleSubmissionView = SubmissionSubjectiveView(frame: CGRect(x: 0, y: 0, width: self.frame.size.width, height: self.frame.size.height))
            self.addSubview(mScribbleSubmissionView)
            mScribbleSubmissionView.setdelegate(self)
        }
        noSubmissionLabel.isHidden = false
        mScribbleSubmissionView.isHidden = true
        mCurrentQuestionDetails = details
        if mCollaborationMRQView != nil
        {
            mCollaborationMRQView.removeFromSuperview()
            mCollaborationMRQView = nil
            
        }
    }
    
    
    func addOneStringQuestionWithDetails(_ details:AnyObject)
    {
        if mOneStringQuestionView == nil
        {
            
            mOneStringQuestionView = OneStringGraphView(frame: CGRect(x: 0, y: 0, width: self.frame.size.width, height: self.frame.size.height))
            self.addSubview(mOneStringQuestionView)
            mOneStringQuestionView.setdelegate(self)
            
            if let questionName = (details.object(forKey: "Name")) as? String
            {
                mOneStringQuestionView.setQuestionName(questionName , withDetails:details )
            }
            
        }
        
        if mOneWordQuestionView == nil
        {
            
            mOneWordQuestionView = OnewordAnswerView(frame: CGRect(x: 0, y: 0, width: self.frame.size.width, height: self.frame.size.height))
            self.addSubview(mOneWordQuestionView)
            mOneWordQuestionView.setdelegate(self)
            
            if let questionName = (details.object(forKey: "Name")) as? String
            {
                mOneWordQuestionView.setQuestionName(questionName, withDetails:details)
            }
            
            
            
        }
        mOneWordQuestionView.isHidden = true
        
        noSubmissionLabel.isHidden = true
        mOneStringQuestionView.isHidden = false
        mCurrentQuestionDetails = details
        if mCollaborationMRQView != nil
        {
            mCollaborationMRQView.removeFromSuperview()
            mCollaborationMRQView = nil
            
        }
    }
    
    
    
    func addOneWordQuestionViewWithDetails(_ details:AnyObject)
    {
        
//        noSubmissionLabel.hidden = true
//        mOneWordQuestionView.hidden = false
//        mCurrentQuestionDetails = details
        
        if mCollaborationMRQView != nil
        {
            mCollaborationMRQView.removeFromSuperview()
            mCollaborationMRQView = nil
            
        }
    }
    
    
   
    
    
    
    
    func studentAnswerRecievedWIthDetails(_ details:AnyObject, withStudentDict studentdict:AnyObject)
    {
        
        
        noSubmissionLabel.isHidden = true
        
        if let questionType = mCurrentQuestionDetails.object(forKey: kQuestionType) as? String
        {
            
            if (questionType  == kOverlayScribble  || questionType == kFreshScribble)
            {
                mScribbleSubmissionView.setStudentAnswerWithAnswer(details, withStudentDict: studentdict, withQuestionDict:mCurrentQuestionDetails)
                mScribbleSubmissionView.isHidden = false
            }
            else if (questionType == kText)
            {
                mScribbleSubmissionView.setStudentAnswerWithAnswer(details, withStudentDict: studentdict, withQuestionDict:mCurrentQuestionDetails)
                mScribbleSubmissionView.isHidden = false
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
    
    
    func SetStudentOneStringAnswer(_ studentAnswer:String,withStudentDict studentdict:AnyObject)
    {
       
        if mOneStringQuestionView !=  nil
        {            
            if let questionType = mCurrentQuestionDetails.object(forKey: kQuestionType) as? String
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
    
    func studentSubmissionEvaluatedWithDetails(_ evaluationDetails:AnyObject, withStdentId StudentId:String)
    {
        if mScribbleSubmissionView != nil
        {
            mScribbleSubmissionView.submissionEvaluatedWithDetails(evaluationDetails, withStudentId: StudentId)
            
        }
    }
    
    
    
    func studentAnswerWithdrawnWithStudentId(_ studentId:String)
    {
        if mScribbleSubmissionView != nil
        {
            if mScribbleSubmissionView.removeStudentAnswerWithStudentId(studentId) <= 0
            {
                mScribbleSubmissionView.isHidden = true
                mScribbleSubmissionView.resetAllButtonState()
                
                noSubmissionLabel.isHidden = false
            }
            
            
            
        }

    }
    
    
    func questionClearedByTeacher()
    {
        noSubmissionLabel.isHidden = false
        if mMRQSubmissionView != nil
        {
            mMRQSubmissionView.isHidden = true
        }
        if mMTCSubmissionView != nil
        {
            mMTCSubmissionView.isHidden = true
        }
        
        if mScribbleSubmissionView != nil
        {
            mScribbleSubmissionView.isHidden = true
            mScribbleSubmissionView.questionCleared()
            
        }
        
        if mOneStringQuestionView != nil
        {
            mOneStringQuestionView.isHidden = true
            mOneStringQuestionView.removeFromSuperview()
            mOneStringQuestionView = nil
        }
        
        if mOneWordQuestionView != nil
        {
            mOneWordQuestionView.isHidden = true
            mOneWordQuestionView.removeFromSuperview()
            mOneWordQuestionView = nil
            
        }
        
    }
    
    
    
     // MARK: - MRQ GraphView delegate
    
    func delegateOptionTouchedWithId(_ optionId: String, withView barButton: BarView) {
        
        if delegate().responds(to: #selector(SSTeacherSubmissionViewDelegate.delegateGetaggregateWithOptionId(_:withView:)))
        {
            delegate().delegateGetaggregateWithOptionId!(optionId,withView:barButton)
        }
        
    }
    
    
    // MARK: - SubJectiveView   delegate
    
    func delegateStudentSubmissionEvaluatedWithDetails(_ evaluationDetails: AnyObject, withStudentId studentId: String, withSubmissionCount SubmissionCount: Int)
    {
        
        if SubmissionCount <= 0 {
            mScribbleSubmissionView.isHidden = true
            mScribbleSubmissionView.resetAllButtonState()
            noSubmissionLabel.isHidden = false
        }
        
       

        
        if delegate().responds(to: #selector(SSTeacherSubmissionViewDelegate.delegateTeacherEvaluatedReplyWithDetails(_:withStudentId:))) {
            delegate().delegateTeacherEvaluatedReplyWithDetails!(evaluationDetails, withStudentId: studentId)
        }
    }
    
    
    // MARK: - Graph or  wordCloud delegate
    
    
    func delegateGraphButtonPressed()
    {
        if mOneStringQuestionView !=  nil
        {
             mOneStringQuestionView.isHidden = false
           
        }
        
        if mOneWordQuestionView !=  nil
        {
            mOneWordQuestionView.isHidden = true
            
        }
    }
    
    func delegateWordCloudButtonPressed()
    {
        if mOneWordQuestionView !=  nil
        {
            mOneWordQuestionView.isHidden = false
            
        }
        
        if mOneStringQuestionView !=  nil
        {
            mOneStringQuestionView.isHidden = true
            
        }
        
    }
    
    // MARK: - MRQ Collaboration
    
    func addCollaborationMRQView()
    {
        if mCollaborationMRQView == nil
        {
            mCollaborationMRQView = CollaborationMRQView(frame: CGRect(x: 0, y: 0, width: self.frame.size.width, height: self.frame.size.height))
            self.addSubview(mCollaborationMRQView)
            mCollaborationMRQView.setdelegate(self)
            DispatchQueue.main.async(execute: {
                self.mCollaborationMRQView.loadAllSubView()
            })
            
            
            
        }
        
        mCollaborationMRQView.isHidden = false
        noSubmissionLabel.isHidden = true
    }
    
    
    func addCollaborationMRQViewWithCategoryName(_ categoryName:String)
    {
        
        
      
    }
    
    func addCollaborationSuggestionWithDetails(_ details:AnyObject)
    {
        if mCollaborationMRQView != nil
        {
          mCollaborationMRQView.addCollaborationSuggestionWithDetails(details)
        }
    }
    
    func delegateQuestionCreationDismissed()
    {
        mCollaborationMRQView.isHidden = true
        mCollaborationMRQView.removeFromSuperview()
        mCollaborationMRQView = nil
        noSubmissionLabel.isHidden = false

    }
    
    func delegateQuestionSaved()
    {
        
        self.makeToast("New question added", duration: 5.0, position: .bottom)
        if mCollaborationMRQView != nil
        {
            mCollaborationMRQView.isHidden = true
            mCollaborationMRQView.removeFromSuperview()
            mCollaborationMRQView = nil
            noSubmissionLabel.isHidden = false
        }
       
    }
    
    
    func delegateQuestionSentWithDetails(details:AnyObject)
    {
        mCollaborationMRQView.isHidden = true
        mCollaborationMRQView.removeFromSuperview()
        mCollaborationMRQView = nil
        noSubmissionLabel.isHidden = false
        
        delegate().delegateQuestionSentWithQuestionDetails!(details)

    }
    
    
}
