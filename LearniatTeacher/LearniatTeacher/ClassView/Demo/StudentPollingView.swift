//
//  StudentPollingView.swift
//  LearniatTeacher
//
//  Created by Deepak MK on 02/05/16.
//  Copyright © 2016 Mindshift. All rights reserved.
//

import Foundation
@objc protocol StudentPollingViewDelegate
{
    
    optional func smhDidgetStudentPollWithDetails(optionValue:String)
    
    
    
}


class StudentPollingView: UIView
{
    var _delgate: AnyObject!
    
     var notLiveStudentsDetails = NSMutableArray()
    
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
    
    
    required init?(coder aDecoder: NSCoder)
    {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    func sendDummyPollingWithStudents(studentDetails:NSMutableArray, withOPtionsArray optionArray:NSMutableArray)
    {
        
        
        notLiveStudentsDetails.removeAllObjects()
        
        for index in 0..<studentDetails.count
        {
            let currentStudentsDict = studentDetails.objectAtIndex(index)
            if let _StudentState = currentStudentsDict.objectForKey("StudentState") as? String
            {
                if _StudentState !=  StudentLive && _StudentState !=  StudentLiveBackground
                {
                    notLiveStudentsDetails.addObject(currentStudentsDict)
                }
            }
        }
        
        notLiveStudentsDetails.shuffle()
       
        
        
        for _  in 0..<notLiveStudentsDetails.count
        {
            var aRandomInt = randomInt(1, max: optionArray.count - 1)
            
            if aRandomInt > optionArray.count
            {
                aRandomInt = optionArray.count - 1
            }

            
            if let optionsString = optionArray.objectAtIndex(aRandomInt) as? String
            {
                delegate().smhDidgetStudentPollWithDetails!(optionsString)
            }

        }
        
       
        
        
        
        
        
        
        
    }
    func randomInt(min: Int, max:Int) -> Int
    {
        return min + Int(arc4random_uniform(UInt32(max - min + 1)))
    }

    
}