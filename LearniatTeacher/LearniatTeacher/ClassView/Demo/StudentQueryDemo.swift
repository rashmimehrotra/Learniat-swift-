//
//  StudentQueryDemo.swift
//  LearniatTeacher
//
//  Created by Deepak MK on 27/04/16.
//  Copyright © 2016 Mindshift. All rights reserved.
//

import Foundation

@objc protocol StudentQueryDemoDelegate
{
    
    
    @objc optional  func smhDidgetStudentQueryWithDetails(_ queryId:String)
    
    
    
}

class StudentQueryDemo: UIView, StudentQuerySelectionViewDelegate
{
    var notLiveStudentsDetails = NSMutableArray()

    var demoQueriesArray = NSMutableArray()
    
    
    var _delgate: AnyObject!
    
    func setdelegate(_ delegate:AnyObject)
    {
        _delgate = delegate;
    }
    
    func   delegate()->AnyObject
    {
        return _delgate;
    }
    
    var plistLoader = PlistDownloder()
    
    var totalStudentsCount = 0
    var mTotalQueriesCount = 0
    
    override init(frame: CGRect)
    {
        super.init(frame:frame)
        
        
        
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func sendDummyQueriesWithStudentDetails(_ studentDetails:NSMutableArray)
    {
        demoQueriesArray.removeAllObjects()

        notLiveStudentsDetails.removeAllObjects()
        
        for index in 0..<studentDetails.count
        {
            let currentStudentsDict = studentDetails.object(at: index)
            if let _StudentState = (currentStudentsDict as AnyObject).object(forKey: "StudentState") as? String
            {
                if _StudentState !=  StudentLive && _StudentState !=  StudentLiveBackground
                {
                    notLiveStudentsDetails.add(currentStudentsDict)
                    totalStudentsCount = totalStudentsCount + 1
                }
            }
        }
        
        notLiveStudentsDetails.shuffle()
        
        if totalStudentsCount >= notLiveStudentsDetails.count
        {
            totalStudentsCount = notLiveStudentsDetails.count - 1
        }
        
        
        if SSTeacherDataSource.sharedDataSource.startedSubTopicId != ""
        {
            let subTopicId = SSTeacherDataSource.sharedDataSource.startedSubTopicId
            
            if SSTeacherDataSource.sharedDataSource.mDemoQuerySubTopicsArray.contains(subTopicId)
            {
                let  url = URL(string: "\(kDemoPlistUrl)/Query_\(subTopicId).plist")
                
                let mDemoMaseterFileDetails = plistLoader.returnDictonarywithUrl(url)
                
                if  mDemoMaseterFileDetails != nil
                {
                    
                    if mDemoMaseterFileDetails?.object(forKey: "Queries") != nil
                    {
                        if let classCheckingVariable = mDemoMaseterFileDetails?.object(forKey: "Queries") as? NSMutableArray
                        {
                            demoQueriesArray = classCheckingVariable
                            
                        }
                        else
                        {
                            demoQueriesArray.add(mDemoMaseterFileDetails?.object(forKey: "Queries") as AnyObject)
                            
                        }
                    }
                }
            }
            
            
            if demoQueriesArray.count > 0
            {
                mTotalQueriesCount = demoQueriesArray.count - 1
                let currentStudentsDict = notLiveStudentsDetails.object(at: totalStudentsCount)
                let studentsQuery = StudentQuerySelectionView()
                studentsQuery.setdelegate(self)
                studentsQuery.setQueryWithDetails(demoQueriesArray, withStudentDetails: currentStudentsDict as AnyObject)
                totalStudentsCount = totalStudentsCount - 1

            }
        }
    }
    
    func delegateStudentQueryRecievedWithId(_ queryId: String, withStudentId stundentId: String) {
        
        if SSTeacherDataSource.sharedDataSource.isSubtopicStarted == true
        {
            if delegate().responds(to: #selector(StudentQueryDemoDelegate.smhDidgetStudentQueryWithDetails(_:)))
            {
                delegate().smhDidgetStudentQueryWithDetails!(queryId)
            }
            
            if mTotalQueriesCount > 0
            {
                if totalStudentsCount >= 0
                {
                    if totalStudentsCount < notLiveStudentsDetails.count
                    {
                        let currentStudentsDict = notLiveStudentsDetails.object(at: totalStudentsCount)
                        let studentsQuery = StudentQuerySelectionView()
                        studentsQuery.setdelegate(self)
                        studentsQuery.setQueryWithDetails(demoQueriesArray, withStudentDetails: currentStudentsDict as AnyObject)
                        
                        totalStudentsCount = totalStudentsCount - 1
                        mTotalQueriesCount = mTotalQueriesCount - 1
                    }
                    else
                    {
                        totalStudentsCount = notLiveStudentsDetails.count - 1
                        mTotalQueriesCount = mTotalQueriesCount - 1
                    }
                }
            }
            
            
        }
        
    }
    
}
