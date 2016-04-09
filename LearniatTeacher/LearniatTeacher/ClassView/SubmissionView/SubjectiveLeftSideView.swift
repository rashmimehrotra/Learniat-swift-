//
//  SubjectiveLeftSideView.swift
//  LearniatTeacher
//
//  Created by Deepak MK on 07/04/16.
//  Copyright © 2016 Mindshift. All rights reserved.
//

import Foundation


@objc protocol SubjectiveLeftSideViewDelegate
{
    
    optional func delegateStudentSelectedWithState(state:Bool, withStudentDetails studentDetails:AnyObject, withAnswerDetails answerDetails:AnyObject)
    
    
    
}


class SubjectiveLeftSideView: UIView,SubjectiveStudentContainerDelegate
{
    var _delgate: AnyObject!
    
    var _currentStudentAnswerDetails:AnyObject!
    
    var _currentStudentDetails :AnyObject!
    
    var mScrollView = UIScrollView()
    
    var selectAllImageview = UIImageView()
    
    var currentPositionY :CGFloat = 10
    
    var selectedStudentsArray = NSMutableArray()
    
    
    var totlStudentsCount           = 0
    
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
        
        self.backgroundColor =  blackTextColor
        
        let headerLabel = UILabel(frame: CGRectMake(30, 0, 80, 50));
        headerLabel.textAlignment = .Center;
        headerLabel.text = "SelectAll";
        headerLabel.textColor = LineGrayColor
        headerLabel.backgroundColor = UIColor.clearColor();
        self.addSubview(headerLabel)
        
        
        
        selectAllImageview = UIImageView(frame: CGRectMake(7.0, 15, 20,20))
        self.addSubview(selectAllImageview)
        selectAllImageview.image = UIImage(named: "Unchecked.png")
        
        let selectAllButton = UIButton()
        selectAllButton.frame = CGRectMake(0, 0, self.frame.size.width, 50)
        self.addSubview(selectAllButton)
        selectAllButton.setTitleColor(LineGrayColor, forState: .Normal)
        

    
        mScrollView.frame = CGRectMake(0, 50, self.frame.size.width, self.frame.size.height - 50 )
        self.addSubview(mScrollView)
        
    }
    
    required init?(coder aDecoder: NSCoder)
    {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    func addStudentSubmissionWithStudentAnswer(studentAnswer:AnyObject, withStudentDetails studentDict:AnyObject, withOverlay overlay:String)
    {
        
        
        _currentStudentAnswerDetails = studentAnswer
        _currentStudentDetails = studentDict
        
        let subjectiveCell = SubjectiveStudentContainer(frame: CGRectMake(0 ,currentPositionY,mScrollView.frame.size.width,mScrollView.frame.size.width))
        subjectiveCell.setdelegate(self)
        subjectiveCell.setStudentAnswerDetails(studentAnswer, withStudentDetails: studentDict,withOverlay:overlay)
        if let studentId = studentDict.objectForKey("StudentId") as? NSString
        {
            subjectiveCell.tag = studentId.integerValue
        }
        
        mScrollView.addSubview(subjectiveCell)
        
        
        mScrollView.contentSize = CGSizeMake(0, currentPositionY)
        
        currentPositionY = currentPositionY + subjectiveCell.frame.size.height + 10
        totlStudentsCount = totlStudentsCount + 1
        refreshScrollView()
        
    }
    
     // MARK: - SubjectiveStudentContainer Delegate
    
    func delegateCheckmarkPressedWithState(state: Bool, withStudentDetails studentDetails: AnyObject, withAnswerDetails answerDetails: AnyObject) {
        
        if state == true
        {
            
            if let studentId = studentDetails.objectForKey("StudentId") as? String
            {
                if !selectedStudentsArray.containsObject(studentId)
                {
                    selectedStudentsArray.addObject(studentId)
                }
            }
          
            
        }
        else
        {
            if let studentId = studentDetails.objectForKey("StudentId") as? String
            {
                if selectedStudentsArray.containsObject(studentId)
                {
                    selectedStudentsArray.removeObject(studentId)
                }
            }
            
        }
        
        
        
        if delegate().respondsToSelector(Selector("delegateStudentSelectedWithState:withStudentDetails:withAnswerDetails:"))
        {
            delegate().delegateStudentSelectedWithState!(state, withStudentDetails: studentDetails, withAnswerDetails: answerDetails)
        }
        
        
        if selectedStudentsArray.count <= 0
        {
            selectAllImageview.image = UIImage(named: "Unchecked.png")
        }
        else if totlStudentsCount > selectedStudentsArray.count
        {
            selectAllImageview.image = UIImage(named: "halfChecked.png")
        }
        else
        {
            selectAllImageview.image = UIImage(named: "Checked.png")
        }
    }
    
    
    func clearedQuestion()
    {
        let subViews = mScrollView.subviews
        currentPositionY = 10
        selectedStudentsArray.removeAllObjects()
         selectAllImageview.image = UIImage(named: "Unchecked.png")
        for subview in subViews
        {
            subview.removeFromSuperview()
        }
    }
    
    func feedbackSentToStudentsWithStudentsId(studentId:String)
    {
        if selectedStudentsArray.containsObject(studentId)
        {
            selectedStudentsArray.removeObject(studentId)
        }
        
        if let studentDeskView  = mScrollView.viewWithTag(Int(studentId)!) as? SubjectiveStudentContainer
        {
            studentDeskView.removeFromSuperview()
        }
        
        refreshScrollView()
        

    }
    
    
    
    func refreshScrollView()
    {
        
        
        currentPositionY = 10
        
        let subViews = mScrollView.subviews
        for subjectiveCell in subViews
        {
            if subjectiveCell.isKindOfClass(SubjectiveStudentContainer)
            {
                subjectiveCell.frame = CGRectMake(subjectiveCell.frame.origin.x ,currentPositionY,mScrollView.frame.size.width,mScrollView.frame.size.width)
                
                currentPositionY = currentPositionY + subjectiveCell.frame.size.height + 10
            }
        }
        
        
        if selectedStudentsArray.count <= 0
        {
            selectAllImageview.image = UIImage(named: "Unchecked.png")
        }
        else if totlStudentsCount > selectedStudentsArray.count
        {
            selectAllImageview.image = UIImage(named: "halfChecked.png")
        }
        else
        {
            selectAllImageview.image = UIImage(named: "Checked.png")
        }
        
    }
    
}