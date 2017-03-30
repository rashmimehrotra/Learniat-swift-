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
    override init(frame: CGRect)
    {
        super.init(frame: frame)
        
         self.backgroundColor = whiteBackgroundColor
        
    }
    
    required init?(coder aDecoder: NSCoder)
    {
        fatalError("init(coder:) has not been implemented")
    }
    
    func didGetCollaborationStartedMessageWithCategoryName(_ category:String , withCategoryID categoryId:String)
    {
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
        if mStudentSidePolling != nil{
            mStudentSidePolling.removeFromSuperview()
            mStudentSidePolling = nil
            
        }
        
        mStudentSidePolling = StudentPollingView(frame:CGRect(x: 0,y: 0,width: self.frame.size.width, height: self.frame.size.height))
        self.addSubview(mStudentSidePolling)
        mStudentSidePolling.setQuestionOptionsWithDetails(details)
        
        
        
    }
    
    
    func didGetPollingStopped()
    {
        if mStudentSidePolling != nil
        {
            mStudentSidePolling.removeFromSuperview()
            mStudentSidePolling = nil
            
        }
    }
    
}
