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
    
    
    @objc optional func delegateStudentQueryRecievedWithId(_ queryId:String, withStudentId stundentId:String)
    
    
    
}


class StudentQuerySelectionView: UIView,APIManagerDelegate
{

    var _delgate: AnyObject!
    
    func setdelegate(_ delegate:AnyObject)
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
    
    
    func setQueryWithDetails(_ queryDetails:NSMutableArray, withStudentDetails studentDetails:AnyObject)
    {
        
        _currentStudentDetails = studentDetails
        if queryDetails.count > 0
        {
            queryDetails.shuffle()
            
            
           if let queryText = queryDetails.firstObject as? String
           {
                if let StudentId = _currentStudentDetails.object(forKey: "StudentId") as? String
                {
                    if SSTeacherDataSource.sharedDataSource.isSubtopicStarted == true
                    {
                        sendQueryWithDetails(queryText, witStudentId: StudentId)
                        
                    }
                }
            }
        }
    }
    
    func sendQueryWithDetails(_ query:String,witStudentId StudentId:String)
    {
        
        let manager = APIManager()
        
        let urlString = String(format: "%@<Sunstone><Action><Service>SaveStudentQuery</Service><StudentId>%@</StudentId><SessionId>%@</SessionId><QueryText>%@</QueryText><Anonymous>0</Anonymous></Action></Sunstone>",URLPrefix,StudentId,SSTeacherDataSource.sharedDataSource.currentLiveSessionId,query)
        
        manager.downloadDataURL(urlString, withServiceName: kServiceSaveStudentQuery, withDelegate: self, with: eHTTPGetRequest, withReturningDelegate:delegate())
    }
    func delegateDidGetServiceResponse(withDetails dict: NSMutableDictionary!, wIthServiceName serviceName: String!, withRetruningDelegate returningDelegate: AnyObject!) {
        
        if SSTeacherDataSource.sharedDataSource.isSubtopicStarted == true
        {
            let refinedDetails = (dict.object(forKey: kSunstone)! as AnyObject).object(forKey: kSSAction)!
            
            
            if serviceName == kServiceSaveStudentQuery
            {
                if let QueryId = (refinedDetails as AnyObject).object(forKey: "QueryId") as? String
                {
                    
                    
                    
                    if let StudentId = _currentStudentDetails.object(forKey: "StudentId") as? String
                    {
                        delegate().delegateStudentQueryRecievedWithId!(QueryId, withStudentId: StudentId)
                    }
                    
                }
            }
            
        }
    }
    
    
    
    
    func delegateServiceErrorMessage(_ message: String!, withServiceName ServiceName: String!, withErrorCode code: String!)
    {
        
    }
    
    
    
}
    
