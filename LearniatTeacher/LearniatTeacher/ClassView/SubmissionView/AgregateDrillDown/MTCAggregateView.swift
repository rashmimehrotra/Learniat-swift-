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
        
        studentsScrollview.frame = CGRect(x: 0, y: 0, width: self.frame.size.width, height: self.frame.size.height)
        self.addSubview(studentsScrollview)
        studentsScrollview.isPagingEnabled = true
        
        
        
    }
    
    
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
        
        
    }
    
    
    
    func showAggregateWithDetails(_ details:AnyObject) -> CGFloat
    {
        
        
        
        
        let subViews = studentsScrollview.subviews
        
        for subview in subViews
        {
            subview.removeFromSuperview()
        }
        
        
        
        
        var studentIdArray      = [String]()
        var studentNameArray    = [String]()
        var participationArray  = [String]()
        var graspIndexArray     = [String]()
        
        
        
        var wrongStudentIdArray      = [String]()
        var wrongStudentNameArray    = [String]()
        var wrongParticipationArray  = [String]()
        var wrongGraspIndexArray     = [String]()
        
        
        
        
        if let StudentId = details.object(forKey: "StudentId") as? NSString
        {
            studentIdArray = StudentId.components(separatedBy: ";;;")
            
            if let StudentName = details.object(forKey: "StudentName") as? NSString
            {
                studentNameArray = StudentName.components(separatedBy: ";;;")
            }
            
            if let GraspIndex = details.object(forKey: "GraspIndex") as? NSString
            {
                graspIndexArray = GraspIndex.components(separatedBy: ";;;")
            }
            
            if let ParticipationIndex = details.object(forKey: "ParticipationIndex") as? NSString
            {
                participationArray = ParticipationIndex.components(separatedBy: ";;;")
            }
        }
        
        
        if let worngStudentId = details.object(forKey: "StudentIdWrong") as? NSString
        {
            wrongStudentIdArray = worngStudentId.components(separatedBy: ";;;")
            
            if let wrongStudentName = details.object(forKey: "StudentNameWrong") as? NSString
            {
                wrongStudentNameArray = wrongStudentName.components(separatedBy: ";;;")
            }
            
            if let GraspIndexWrong = details.object(forKey: "GraspIndexWrong") as? NSString
            {
                wrongGraspIndexArray = GraspIndexWrong.components(separatedBy: ";;;")
            }
            
            if let ParticipationIndexWrong = details.object(forKey: "ParticipationIndexWrong") as? NSString
            {
                wrongParticipationArray = ParticipationIndexWrong.components(separatedBy: ";;;")
            }
        }
        
        
        
        
        
       
        
        
        let correctStudentsLabel = UILabel(frame:CGRect(x: 0, y: 0, width: studentsScrollview.frame.size.width, height: 40))
        correctStudentsLabel.text = "Answered correctly"
        studentsScrollview.addSubview(correctStudentsLabel)
        correctStudentsLabel.textAlignment = .center
        correctStudentsLabel.textColor = UIColor.white
        correctStudentsLabel.backgroundColor = standard_Green
        correctStudentsLabel.font = UIFont(name: helveticaMedium, size: 18);
        
         var positionY:CGFloat = 40
        
        for index in 0..<studentIdArray.count
        {
            let studentId = studentIdArray[index]
            let studentName = studentNameArray[index]
            let participationIndex = participationArray[index]
            let graspIndex = graspIndexArray[index]
            
            
            let agregateCell = AggregateCell(frame: CGRect(x: 0,y: positionY,width: studentsScrollview.frame.size.width,height: 70))
            studentsScrollview.addSubview(agregateCell)
            agregateCell.addStudentId(studentId as NSString, withName: studentName as NSString, withgraspLevel: graspIndex as NSString, withParticipation: Float(participationIndex)! )
            
            positionY = positionY + agregateCell.frame.size.height
            
            
        }
        
        
        let wrongStudentsLabel = UILabel(frame:CGRect(x: studentsScrollview.frame.size.width, y: 0, width: studentsScrollview.frame.size.width, height: 40))
        wrongStudentsLabel.text = "Incorrectly"
        studentsScrollview.addSubview(wrongStudentsLabel)
        wrongStudentsLabel.textAlignment = .center
        wrongStudentsLabel.textColor = UIColor.white
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
        
        
        
        if height > UIScreen.main.bounds.height - 100
        {
            height = UIScreen.main.bounds.height - 100
        }
        
        studentsScrollview.frame = CGRect(x: 0, y: 0, width: self.frame.size.width, height: height)
        
        
        positionY = 40
        for index in 0..<wrongStudentIdArray.count
        {
            let studentId = wrongStudentIdArray[index]
            let studentName = wrongStudentNameArray[index]
            let participationIndex = wrongParticipationArray[index]
            let graspIndex = wrongGraspIndexArray[index]
            
            
            let agregateCell = AggregateCell(frame: CGRect(x: studentsScrollview.frame.size.width,y: positionY,width: studentsScrollview.frame.size.width,height: 70))
            studentsScrollview.addSubview(agregateCell)
            agregateCell.addStudentId(studentId as NSString, withName: studentName as NSString, withgraspLevel: graspIndex as NSString, withParticipation: Float(participationIndex)!)
            
            positionY = positionY + agregateCell.frame.size.height
            
            
        }
        
        
        
        
        
       
        studentsScrollview.contentSize = CGSize(width: studentsScrollview.frame.size.width * 2, height: positionY)
        return height
        
        
    }
    
    
}
