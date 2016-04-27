//
//  MTCAggregateView.swift
//  LearniatTeacher
//
//  Created by Deepak MK on 06/04/16.
//  Copyright © 2016 Mindshift. All rights reserved.
//

import Foundation
class MTCAggregateView: UIView
{
    
    
    var studentsScrollview : UIScrollView = UIScrollView()
    
    
    override init(frame: CGRect)
    {
        
        super.init(frame:frame)
        
        studentsScrollview.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)
        self.addSubview(studentsScrollview)
        
        
        
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
        
        
        
        var wrongStudentIdArray      = [NSString]()
        var wrongStudentNameArray    = [NSString]()
        var wrongParticipationArray  = [NSString]()
        var wrongGraspIndexArray     = [NSString]()
        
        
        
        
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
        
        
        if let worngStudentId = details.objectForKey("StudentIdWrong") as? NSString
        {
            wrongStudentIdArray = worngStudentId.componentsSeparatedByString(";;;")
            
            if let wrongStudentName = details.objectForKey("StudentNameWrong") as? NSString
            {
                wrongStudentNameArray = wrongStudentName.componentsSeparatedByString(";;;")
            }
            
            if let GraspIndexWrong = details.objectForKey("GraspIndexWrong") as? NSString
            {
                wrongGraspIndexArray = GraspIndexWrong.componentsSeparatedByString(";;;")
            }
            
            if let ParticipationIndexWrong = details.objectForKey("ParticipationIndexWrong") as? NSString
            {
                wrongParticipationArray = ParticipationIndexWrong.componentsSeparatedByString(";;;")
            }
        }
        
        
        
        
        
       
        
        
        let correctStudentsLabel = UILabel(frame:CGRectMake(0, 0, studentsScrollview.frame.size.width, 40))
        correctStudentsLabel.text = "Answered correctly"
        studentsScrollview.addSubview(correctStudentsLabel)
        correctStudentsLabel.textAlignment = .Center
        correctStudentsLabel.textColor = UIColor.whiteColor()
        correctStudentsLabel.backgroundColor = standard_Green
        correctStudentsLabel.font = UIFont(name: helveticaMedium, size: 18);
        
         var positionY:CGFloat = 40
        
        for index in 0..<studentIdArray.count
        {
            let studentId = studentIdArray[index]
            let studentName = studentNameArray[index]
            let participationIndex = participationArray[index]
            let graspIndex = graspIndexArray[index]
            
            
            let agregateCell = AggregateCell(frame: CGRectMake(0,positionY,studentsScrollview.frame.size.width,70))
            studentsScrollview.addSubview(agregateCell)
            agregateCell.addStudentId(studentId, withName: studentName, withgraspLevel: graspIndex, withParticipation: participationIndex.floatValue)
            
            positionY = positionY + agregateCell.frame.size.height
            
            
        }
        
        
        let wrongStudentsLabel = UILabel(frame:CGRectMake(studentsScrollview.frame.size.width, 0, studentsScrollview.frame.size.width, 40))
        wrongStudentsLabel.text = "Incorrectly"
        studentsScrollview.addSubview(wrongStudentsLabel)
        wrongStudentsLabel.textAlignment = .Center
        wrongStudentsLabel.textColor = UIColor.whiteColor()
        wrongStudentsLabel.backgroundColor = standard_Red
        wrongStudentsLabel.font = UIFont(name: helveticaMedium, size: 18);
        
        
        
        var height:CGFloat = 100
        let correctStudentHeight :CGFloat = CGFloat((studentIdArray.count * 70))
        let wrongStudentHeight :CGFloat = CGFloat((wrongStudentIdArray.count * 70))
        
        if correctStudentHeight > wrongStudentHeight
        {
            height = correctStudentHeight + 40
        }
        else
        {
            height = wrongStudentHeight + 40
        }
        
        
        
        if height > UIScreen.mainScreen().bounds.height - 100
        {
            height = UIScreen.mainScreen().bounds.height - 100
        }
        
        studentsScrollview.frame = CGRectMake(0, 0, self.frame.size.width, height)
        
        
        positionY = 40
        for index in 0..<wrongStudentIdArray.count
        {
            let studentId = wrongStudentIdArray[index]
            let studentName = wrongStudentNameArray[index]
            let participationIndex = wrongParticipationArray[index]
            let graspIndex = wrongGraspIndexArray[index]
            
            
            let agregateCell = AggregateCell(frame: CGRectMake(studentsScrollview.frame.size.width,positionY,studentsScrollview.frame.size.width,70))
            studentsScrollview.addSubview(agregateCell)
            agregateCell.addStudentId(studentId, withName: studentName, withgraspLevel: graspIndex, withParticipation: participationIndex.floatValue)
            
            positionY = positionY + agregateCell.frame.size.height
            
            
        }
        
        
        
        
        
       
        studentsScrollview.contentSize = CGSizeMake(studentsScrollview.frame.size.width * 2, positionY)
        return height
        
        
    }
    
    
}