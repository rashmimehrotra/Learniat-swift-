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
    
    
    optional  func smhDidgetStudentQueryWithDetails(queryId:String)
    
    
    
}

class StudentQueryDemo: UIView, StudentQuerySelectionViewDelegate
{
    var notLiveStudentsDetails = NSMutableArray()

    var demoQueriesArray = NSMutableArray()
    
    
    var _delgate: AnyObject!
    
    func setdelegate(delegate:AnyObject)
    {
        _delgate = delegate;
    }
    
    func   delegate()->AnyObject
    {
        return _delgate;
    }
    
    var plistLoader = PlistDownloder()
    
    var totalStudentsCount = 0
    
    override init(frame: CGRect)
    {
        super.init(frame:frame)
        
        
        
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func sendDummyQueriesWithStudentDetails(studentDetails:NSMutableArray)
    {
        demoQueriesArray.removeAllObjects()

        notLiveStudentsDetails.removeAllObjects()
        
        for index in 0..<studentDetails.count
        {
            let currentStudentsDict = studentDetails.objectAtIndex(index)
            if let _StudentState = currentStudentsDict.objectForKey("StudentState") as? String
            {
                if _StudentState !=  StudentLive && _StudentState !=  StudentLiveBackground
                {
                    notLiveStudentsDetails.addObject(currentStudentsDict)
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
            
            if SSTeacherDataSource.sharedDataSource.mDemoQuerySubTopicsArray.containsObject(subTopicId)
            {
                let  url = NSURL(string: "\(kDemoPlistUrl)/Query_\(subTopicId).plist")
                
                let mDemoMaseterFileDetails = plistLoader.returnDictonarywithUrl(url)
                
                if  mDemoMaseterFileDetails != nil
                {
                    
                    if mDemoMaseterFileDetails.objectForKey("Queries") != nil
                    {
                        if let classCheckingVariable = mDemoMaseterFileDetails.objectForKey("Queries")
                        {
                            if classCheckingVariable.isKindOfClass(NSMutableArray)
                            {
                                demoQueriesArray = classCheckingVariable as! NSMutableArray
                            }
                            else
                            {
                                demoQueriesArray.addObject(mDemoMaseterFileDetails.objectForKey("Queries")!)
                                
                            }
                        }
                    }
                }
            }
            
            
            if demoQueriesArray.count > 0
            {
                let currentStudentsDict = notLiveStudentsDetails.objectAtIndex(totalStudentsCount)
                let studentsQuery = StudentQuerySelectionView()
                studentsQuery.setdelegate(self)
                studentsQuery.setQueryWithDetails(demoQueriesArray, withStudentDetails: currentStudentsDict)
                totalStudentsCount = totalStudentsCount - 1

            }
        }
    }
    
    func delegateStudentQueryRecievedWithId(queryId: String, withStudentId stundentId: String) {
        
        if SSTeacherDataSource.sharedDataSource.isSubtopicStarted == true
        {
            if delegate().respondsToSelector(#selector(StudentQueryDemoDelegate.smhDidgetStudentQueryWithDetails(_:)))
            {
                delegate().smhDidgetStudentQueryWithDetails!(queryId)
            }
            
            if totalStudentsCount >= 0
            {
                if totalStudentsCount < notLiveStudentsDetails.count
                {
                    let currentStudentsDict = notLiveStudentsDetails.objectAtIndex(totalStudentsCount)
                    let studentsQuery = StudentQuerySelectionView()
                    studentsQuery.setdelegate(self)
                    studentsQuery.setQueryWithDetails(demoQueriesArray, withStudentDetails: currentStudentsDict)
                    
                    totalStudentsCount = totalStudentsCount - 1
                }
                else
                {
                    totalStudentsCount = notLiveStudentsDetails.count - 1
                }
            }
        }
        
    }
    
}