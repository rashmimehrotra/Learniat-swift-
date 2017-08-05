//
//  StudentOTFView.swift
//  LearniatStudent
//
//  Created by Deepak MK on 16/05/16.
//  Copyright © 2016 Mindshift. All rights reserved.
//

import Foundation
import UIKit
class StudentOTFView: UIView
{
     var mStudentSidePolling     :StudentPollingView!
    var mStudentCollaborationView : StudentCollaborationView!
    
    var noQuestionslabel = UILabel()
    
    override init(frame: CGRect)
    {
        super.init(frame: frame)
        
         self.backgroundColor = whiteBackgroundColor
        
        noQuestionslabel.frame = CGRect(x: 10, y: (self.frame.size.height - 60)/2, width: self.frame.size.width - 20,height: 60)
        noQuestionslabel.font = UIFont(name:helveticaRegular, size: 40)
        noQuestionslabel.text = "Polling not yet started"
        self.addSubview(noQuestionslabel)
        noQuestionslabel.textColor = topbarColor
        noQuestionslabel.textAlignment = .center
        noQuestionslabel.isHidden = false
        
    }
    
    required init?(coder aDecoder: NSCoder)
    {
        fatalError("init(coder:) has not been implemented")
    }
    
    func didGetCollaborationStartedMessageWithCategoryName(_ category:String , withCategoryID categoryId:String)
    {
        noQuestionslabel.isHidden = true
        
        if mStudentSidePolling != nil{
            mStudentSidePolling.removeFromSuperview()
            mStudentSidePolling = nil
            
        }
        
        if mStudentCollaborationView != nil{
            mStudentCollaborationView.removeFromSuperview()
            mStudentCollaborationView = nil
            
        }
        
        mStudentCollaborationView = StudentCollaborationView(frame:CGRect(x: 0,y: 0,width: self.frame.size.width, height: self.frame.size.height))
        self.addSubview(mStudentCollaborationView)
        mStudentCollaborationView.setCategoryName(category, withCategoryID: categoryId)
        
    }
    
    
    func didGetPollingStartedWithDetills(_ details:AnyObject)
    {
        noQuestionslabel.isHidden = true
        
        if mStudentSidePolling != nil{
            mStudentSidePolling.removeFromSuperview()
            mStudentSidePolling = nil
            
        }
        
        mStudentSidePolling = StudentPollingView(frame:CGRect(x: 0,y: 0,width: self.frame.size.width, height: self.frame.size.height))
        self.addSubview(mStudentSidePolling)
        mStudentSidePolling.setQuestionOptionsWithDetails(details)
        
        
        
    }
    
    
    func didGetsuggestionStatusWithState(state:String)
    {
        if mStudentCollaborationView != nil
        {
            mStudentCollaborationView.setSuggestionStatus(status: state)
        }
    }
    
    func didGetPollingStopped()
    {
        if mStudentSidePolling != nil
        {
            mStudentSidePolling.removeFromSuperview()
            mStudentSidePolling = nil
        }
        noQuestionslabel.isHidden = false
    }
    
    func didGetCollaborationStopped()
    {
        if mStudentCollaborationView != nil
        {
            mStudentCollaborationView.removeFromSuperview()
            mStudentCollaborationView = nil
            
        }
        noQuestionslabel.isHidden = false
    }
    
}
