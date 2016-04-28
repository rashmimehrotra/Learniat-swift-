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
        selectAllButton.addTarget(self, action: #selector(SubjectiveLeftSideView.onSelectAllButton), forControlEvents: UIControlEvents.TouchUpInside)

    
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
        
        
        
        
        currentPositionY = currentPositionY + subjectiveCell.frame.size.height + 10
        totlStudentsCount = totlStudentsCount + 1
        refreshScrollView()
        
        mScrollView.contentSize = CGSizeMake(0, currentPositionY)
        
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
        
        
        
        if delegate().respondsToSelector(#selector(SubjectiveLeftSideViewDelegate.delegateStudentSelectedWithState(_:withStudentDetails:withAnswerDetails:)))
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
    
    func removeStudentsWithStudentsId(studentId:String)
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
    
    
    func onSelectAllButton()
    {
        
        if selectAllImageview.image == UIImage(named: "Unchecked.png")
        {
            selectAllImageview.image = UIImage(named: "Checked.png")
            
            
            
            let subViews = mScrollView.subviews.flatMap{ $0 as? SubjectiveStudentContainer }
            
            for subview in subViews
            {
                if subview.isKindOfClass(SubjectiveStudentContainer)
                {
                    
                    subview.currentSelectionState = kUnSelected
                    
                    subview.checkMarkPressedWith()
                  
                }
            }
        

            
            
        }
        else
        {
            selectAllImageview.image = UIImage(named: "Unchecked.png")
            
            let subViews = mScrollView.subviews.flatMap{ $0 as? SubjectiveStudentContainer }
            
            for subview in subViews
            {
                if subview.isKindOfClass(SubjectiveStudentContainer)
                {
                    
                    subview.currentSelectionState = kSelected
                    
                    subview.checkMarkPressedWith()
                    
                }
            }

        }
        
    }
    
    
    func refreshScrollView()
    {
        
        
        currentPositionY = 10
        totlStudentsCount = 0
        let subViews = mScrollView.subviews
        for subjectiveCell in subViews
        {
            if subjectiveCell.isKindOfClass(SubjectiveStudentContainer)
            {
                subjectiveCell.frame = CGRectMake(subjectiveCell.frame.origin.x ,currentPositionY,mScrollView.frame.size.width,mScrollView.frame.size.width)
                totlStudentsCount = totlStudentsCount + 1
                currentPositionY = currentPositionY + subjectiveCell.frame.size.height + 10
            }
        }
        
        mScrollView.contentSize = CGSizeMake(0, currentPositionY)
        
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