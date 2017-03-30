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
        
        studentsScrollview.frame = CGRect(x: 0, y: 0, width: self.frame.size.width, height: self.frame.size.height)
        self.addSubview(studentsScrollview)
      studentsScrollview.isUserInteractionEnabled = true
        
        
        
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
        
        
        
        
        if let StudentId = details.object(forKey: "StudentId") as? NSString
        {
            studentIdArray =  StudentId.components(separatedBy: ";;;")
            
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
        
        
        
        
        
        var positionY:CGFloat = 0
        
        
        var height :CGFloat = CGFloat((studentIdArray.count * 70))
        
        
        if height > UIScreen.main.bounds.height - 100
        {
            height = UIScreen.main.bounds.height - 100
        }
        
        studentsScrollview.frame = CGRect(x: 0, y: 0, width: self.frame.size.width, height: height)

        
        
        for index in 0..<studentIdArray.count
        {
            let studentId = studentIdArray[index]
            let studentName = studentNameArray[index]
            let participationIndex = participationArray[index]
            let graspIndex = graspIndexArray[index]
            
            
            let agregateCell = AggregateCell(frame: CGRect(x: 10,y: positionY,width: studentsScrollview.frame.size.width - 20,height: 70))
            studentsScrollview.addSubview(agregateCell)
            agregateCell.addStudentId(studentId as NSString, withName: studentName as NSString, withgraspLevel: graspIndex as NSString, withParticipation: Float(participationIndex)!)
            
            positionY = positionY + agregateCell.frame.size.height
            
            
        }
        
        
        studentsScrollview.contentSize = CGSize(width: 0, height: positionY)
        
        return height
        
        
    }
    
    
}
