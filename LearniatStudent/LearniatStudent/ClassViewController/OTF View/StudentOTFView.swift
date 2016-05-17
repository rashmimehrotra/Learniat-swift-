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
    
    override init(frame: CGRect)
    {
        super.init(frame: frame)
        
         self.backgroundColor = whiteBackgroundColor
        
    }
    
    required init?(coder aDecoder: NSCoder)
    {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    func didGetPollingStartedWithDetills(details:AnyObject)
    {
        if mStudentSidePolling != nil{
            mStudentSidePolling.removeFromSuperview()
            mStudentSidePolling = nil
            
        }
        
        mStudentSidePolling = StudentPollingView(frame:CGRectMake(0,0,self.frame.size.width, self.frame.size.height))
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