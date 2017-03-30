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
    
    @objc optional func smhDidgetStudentPollWithDetails(_ optionValue:String)
    
    
    
}


class StudentPollingView: UIView
{
    var _delgate: AnyObject!
    
     var notLiveStudentsDetails = NSMutableArray()
    
    func setdelegate(_ delegate:AnyObject)
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
    
    
    
    func sendDummyPollingWithStudents(_ studentDetails:NSMutableArray, withOPtionsArray optionArray:NSMutableArray)
    {
        
        
        notLiveStudentsDetails.removeAllObjects()
        
        for index in 0..<studentDetails.count
        {
            let currentStudentsDict = studentDetails.object(at: index)
            if let _StudentState = (currentStudentsDict as AnyObject).object(forKey: "StudentState") as? String
            {
                if _StudentState !=  StudentLive && _StudentState !=  StudentLiveBackground
                {
                    notLiveStudentsDetails.add(currentStudentsDict)
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

            
            if let optionsString = optionArray.object(at: aRandomInt) as? String
            {
                delegate().smhDidgetStudentPollWithDetails!(optionsString)
            }

        }
        
       
        
        
        
        
        
        
        
    }
    func randomInt(_ min: Int, max:Int) -> Int
    {
        return min + Int(arc4random_uniform(UInt32(max - min + 1)))
    }

    
}
