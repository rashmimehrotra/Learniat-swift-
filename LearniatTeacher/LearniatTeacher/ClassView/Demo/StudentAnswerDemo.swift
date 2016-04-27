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
    
    
    optional  func smhDidgetStudentAnswerMessageWithStudentId(StudentId: String, withAnswerString answerStrin:String)
    
    
    
}



class StudentAnswerDemo: UIView,StudentAnswerSelectionViewDelegate
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

    override init(frame: CGRect)
    {
        super.init(frame:frame)
        
        
        
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func sendDummyAnswerWithQuestionDetails(questionDetails:AnyObject, withStudentDetails studentDetails:NSMutableArray)
    {

        for index in 0..<studentDetails.count
        {
            let currentStudentsDict = studentDetails.objectAtIndex(index)
            if let _StudentState = currentStudentsDict.objectForKey("StudentState") as? String
            {
                if _StudentState !=  StudentLive && _StudentState !=  StudentLiveBackground
                {
                   
                    let studentsAnswer = StudentAnswerSelectionView()
                    studentsAnswer.setdelegate(self)
                    studentsAnswer.setCurrentQuestionDetails(questionDetails, withCurrentStudentDetails: currentStudentsDict)
                }
            }
        }
        
    }
    
    func delegateStudentAnswerRecievedWithDetails(answerId: String, withStudentid stundentId: String) {
        
        
        if SSTeacherDataSource.sharedDataSource.isQuestionSent == true
        {
            if delegate().respondsToSelector(#selector(StudentAnswerDemoDelegate.smhDidgetStudentAnswerMessageWithStudentId(_:withAnswerString:)))
            {
                delegate().smhDidgetStudentAnswerMessageWithStudentId!(stundentId, withAnswerString: answerId)
            }
        }
        
        
        
    }
    
}