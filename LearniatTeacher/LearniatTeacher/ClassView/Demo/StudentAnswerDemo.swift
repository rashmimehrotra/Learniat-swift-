//
//  StudentAnswerDemo.swift
//  LearniatTeacher
//
//  Created by mindshift_Deepak on 26/04/16.
//  Copyright © 2016 Mindshift. All rights reserved.
//

import Foundation

@objc protocol StudentAnswerDemoDelegate
{
    
    
    @objc optional  func smhDidgetStudentAnswerMessageWithStudentId(_ StudentId: String, withAnswerString answerStrin:String)
    
    
    
}



class StudentAnswerDemo: UIView,StudentAnswerSelectionViewDelegate
{
    
    
    
    var notLiveStudentsDetails = NSMutableArray()
    
    
    
    var currentQuestionDetails:AnyObject!
    
    var _delgate: AnyObject!
    
    func setdelegate(_ delegate:AnyObject)
    {
        _delgate = delegate;
    }
    
    func   delegate()->AnyObject
    {
        return _delgate;
    }

    var totalStudentsCount = 0
    
    override init(frame: CGRect)
    {
        super.init(frame:frame)
        
        
        
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func sendDummyAnswerWithQuestionDetails(_ questionDetails:AnyObject, withStudentDetails studentDetails:NSMutableArray)
    {

        
        currentQuestionDetails = questionDetails
        
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
        if let questionType = questionDetails.object(forKey: kQuestionType) as? String
        {
            if (questionType == kOverlayScribble || questionType == kFreshScribble )
            {
                if totalStudentsCount > 5
                {
                    totalStudentsCount = 5
                }
            }
        }
        
        
        
        let currentStudentsDict = notLiveStudentsDetails.object(at: totalStudentsCount)
        let studentsAnswer = StudentAnswerSelectionView()
        studentsAnswer.setdelegate(self)
        studentsAnswer.setCurrentQuestionDetails(questionDetails, withCurrentStudentDetails: currentStudentsDict as AnyObject)
        
        totalStudentsCount = totalStudentsCount - 1
        
    }
    
    func delegateStudentAnswerRecievedWithDetails(_ answerId: String, withStudentid stundentId: String) {
        
        
        if SSTeacherDataSource.sharedDataSource.isQuestionSent == true
        {
            if delegate().responds(to: #selector(StudentAnswerDemoDelegate.smhDidgetStudentAnswerMessageWithStudentId(_:withAnswerString:)))
            {
                delegate().smhDidgetStudentAnswerMessageWithStudentId!(stundentId, withAnswerString: answerId)
            }
            
            if totalStudentsCount >= 0
            {
                if totalStudentsCount < notLiveStudentsDetails.count
                {
                    let currentStudentsDict = notLiveStudentsDetails.object(at: totalStudentsCount)
                    let studentsAnswer = StudentAnswerSelectionView()
                    studentsAnswer.setdelegate(self)
                    studentsAnswer.setCurrentQuestionDetails(currentQuestionDetails, withCurrentStudentDetails:
                        currentStudentsDict as AnyObject)
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
