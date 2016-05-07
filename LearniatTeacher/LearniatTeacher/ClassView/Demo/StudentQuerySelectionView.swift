//
//  StudentQuerySelectionView.swift
//  LearniatTeacher
//
//  Created by Deepak MK on 27/04/16.
//  Copyright © 2016 Mindshift. All rights reserved.
//

import Foundation

let kServiceSaveStudentQuery   =   "SaveStudentQuery"

@objc protocol StudentQuerySelectionViewDelegate
{
    
    
    optional func delegateStudentQueryRecievedWithId(queryId:String, withStudentId stundentId:String)
    
    
    
}


class StudentQuerySelectionView: UIView,APIManagerDelegate
{

    var _delgate: AnyObject!
    
    func setdelegate(delegate:AnyObject)
    {
        _delgate = delegate;
    }
    
    func   delegate()->AnyObject
    {
        return _delgate;
    }
    

    var _currentStudentDetails  :AnyObject!
   
    
    override init(frame: CGRect)
    {
        super.init(frame:frame)
        
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func setQueryWithDetails(queryDetails:NSMutableArray, withStudentDetails studentDetails:AnyObject)
    {
        
        _currentStudentDetails = studentDetails
        if queryDetails.count > 0
        {
            queryDetails.shuffle()
            
            
           if let queryText = queryDetails.firstObject as? String
           {
                if let StudentId = _currentStudentDetails.objectForKey("StudentId") as? String
                {
                    if SSTeacherDataSource.sharedDataSource.isSubtopicStarted == true
                    {
                        sendQueryWithDetails(queryText, witStudentId: StudentId)
                        
                    }
                }
            }
        }
    }
    
    func sendQueryWithDetails(query:String,witStudentId StudentId:String)
    {
        
        let manager = APIManager()
        
        let urlString = String(format: "%@<Sunstone><Action><Service>SaveStudentQuery</Service><StudentId>%@</StudentId><SessionId>%@</SessionId><QueryText>%@</QueryText><Anonymous>0</Anonymous></Action></Sunstone>",URLPrefix,StudentId,SSTeacherDataSource.sharedDataSource.currentLiveSessionId,query)
        
        manager.downloadDataURL(urlString, withServiceName: kServiceSaveStudentQuery, withDelegate: self, withRequestType: eHTTPGetRequest, withReturningDelegate:delegate())
    }
    func delegateDidGetServiceResponseWithDetails(dict: NSMutableDictionary!, WIthServiceName serviceName: String!, withRetruningDelegate returningDelegate: AnyObject!) {
        
        if SSTeacherDataSource.sharedDataSource.isSubtopicStarted == true
        {
            let refinedDetails = dict.objectForKey(kSunstone)!.objectForKey(kSSAction)!
            
            
            if serviceName == kServiceSaveStudentQuery
            {
                if let QueryId = refinedDetails.objectForKey("QueryId") as? String
                {
                    
                    
                    
                    if let StudentId = _currentStudentDetails.objectForKey("StudentId") as? String
                    {
                        delegate().delegateStudentQueryRecievedWithId!(QueryId, withStudentId: StudentId)
                    }
                    
                }
            }
            
        }
    }
    
    
    
    
    func delegateServiceErrorMessage(message: String!, withServiceName ServiceName: String!, withErrorCode code: String!)
    {
        
    }
    
    
    
}
    