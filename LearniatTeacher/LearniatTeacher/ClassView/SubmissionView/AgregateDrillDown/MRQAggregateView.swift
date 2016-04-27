//
//  MRQAggregateView.swift
//  LearniatTeacher
//
//  Created by Deepak MK on 04/04/16.
//  Copyright © 2016 Mindshift. All rights reserved.
//

import Foundation
class MRQAggregateView: UIView
{
    
    
    var studentsScrollview : UIScrollView = UIScrollView()
    
    
    override init(frame: CGRect)
    {
        
        super.init(frame:frame)
        
        studentsScrollview.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)
        self.addSubview(studentsScrollview)
      studentsScrollview.userInteractionEnabled = true
        
        
        
    }
    
    
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
        
        
    }
    
    
    
    func showAggregateWithDetails(details:AnyObject) -> CGFloat
    {
        
        
        
        
        let subViews = studentsScrollview.subviews
        
        for subview in subViews
        {
            subview.removeFromSuperview()
        }
        

        
        
        var studentIdArray      = [NSString]()
        var studentNameArray    = [NSString]()
        var participationArray  = [NSString]()
        var graspIndexArray     = [NSString]()
        
        
        
        
        if let StudentId = details.objectForKey("StudentId") as? NSString
        {
            studentIdArray = StudentId.componentsSeparatedByString(";;;")
            
            if let StudentName = details.objectForKey("StudentName") as? NSString
            {
                studentNameArray = StudentName.componentsSeparatedByString(";;;")
            }
            
            if let GraspIndex = details.objectForKey("GraspIndex") as? NSString
            {
                graspIndexArray = GraspIndex.componentsSeparatedByString(";;;")
            }
            
            if let ParticipationIndex = details.objectForKey("ParticipationIndex") as? NSString
            {
                participationArray = ParticipationIndex.componentsSeparatedByString(";;;")
            }
        }
        
        
        
        
        
        var positionY:CGFloat = 0
        
        
        var height :CGFloat = CGFloat((studentIdArray.count * 70))
        
        
        if height > UIScreen.mainScreen().bounds.height - 100
        {
            height = UIScreen.mainScreen().bounds.height - 100
        }
        
        studentsScrollview.frame = CGRectMake(0, 0, self.frame.size.width, height)

        
        
        for index in 0..<studentIdArray.count
        {
            let studentId = studentIdArray[index]
            let studentName = studentNameArray[index]
            let participationIndex = participationArray[index]
            let graspIndex = graspIndexArray[index]
            
            
            let agregateCell = AggregateCell(frame: CGRectMake(10,positionY,studentsScrollview.frame.size.width - 20,70))
            studentsScrollview.addSubview(agregateCell)
            agregateCell.addStudentId(studentId, withName: studentName, withgraspLevel: graspIndex, withParticipation: participationIndex.floatValue)
            
            positionY = positionY + agregateCell.frame.size.height
            
            
        }
        
        
        studentsScrollview.contentSize = CGSizeMake(0, positionY)
        
        return height
        
        
    }
    
    
}