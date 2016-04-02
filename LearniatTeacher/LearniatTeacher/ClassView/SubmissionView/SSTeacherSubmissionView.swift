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
    
    
    func addQuestionWithDetails(details:AnyObject)
    {
        if mMRQSubmissionView == nil
        {
            mMRQSubmissionView = SubmissionMRQView()
            mMRQSubmissionView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)
            self.addSubview(mMRQSubmissionView)
            mMRQSubmissionView.setdelegate(self)
        }
        mMRQSubmissionView.addGraphViewforWithQuestionDetails(details)
    }
    
    
    func studentAnswerRecievedWIthDetails(details:AnyObject)
    {
        if mMRQSubmissionView !=  nil
        {
            mMRQSubmissionView.didgetStudentsAnswerWithDetails(details)
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