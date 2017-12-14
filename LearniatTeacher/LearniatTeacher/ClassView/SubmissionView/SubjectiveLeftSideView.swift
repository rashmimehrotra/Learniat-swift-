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
    
    @objc optional func delegateStudentSelectedWithState(_ state:Bool, withStudentDetails studentDetails:AnyObject, withAnswerDetails answerDetails:AnyObject)
    
    
    
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
        
        self.backgroundColor = UIColor(red: 28/255.0, green: 28/255.0, blue: 28/255.0, alpha: 1)
        
        let headerLabel = UILabel(frame: CGRect(x: 60, y: 0, width: 80, height: 50)); // x: 30
        headerLabel.textAlignment = .center;
        headerLabel.text = "SelectAll";
        headerLabel.textColor = standard_TextGrey
        headerLabel.backgroundColor = UIColor(red: 28/255.0, green: 28/255.0, blue: 28/255.0, alpha: 1)
        self.addSubview(headerLabel)
        
        
        
        selectAllImageview = UIImageView(frame: CGRect(x: 30, y: 15, width: 20,height: 20)) // x: 7.0
        self.addSubview(selectAllImageview)
        selectAllImageview.image = UIImage(named: "Unchecked.png")
        
        let selectAllButton = UIButton()
        selectAllButton.frame = CGRect(x: 0, y: 0, width: self.frame.size.width, height: 50)
        self.addSubview(selectAllButton)
        selectAllButton.setTitleColor(LineGrayColor, for: UIControlState())
        selectAllButton.addTarget(self, action: #selector(SubjectiveLeftSideView.onSelectAllButton), for: UIControlEvents.touchUpInside)

    
        mScrollView.frame = CGRect(x: 0, y: 50, width: self.frame.size.width, height: self.frame.size.height - 50 )
        self.addSubview(mScrollView)
        mScrollView.backgroundColor = blackTextColor
        
    }
    
    required init?(coder aDecoder: NSCoder)
    {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    func addStudentSubmissionWithStudentAnswer(_ studentAnswer:AnyObject, withStudentDetails studentDict:AnyObject, withOverlay overlay:String)
    {
        
        
        _currentStudentAnswerDetails = studentAnswer
        _currentStudentDetails = studentDict
        
        let subjectiveCell = SubjectiveStudentContainer(frame: CGRect(x: 0 ,y: currentPositionY,width: mScrollView.frame.size.width,height: mScrollView.frame.size.width))
        subjectiveCell.setdelegate(self)
        subjectiveCell.setStudentAnswerDetails(studentAnswer, withStudentDetails: studentDict,withOverlay:overlay)
        if let studentId = studentDict.object(forKey: "StudentId") as? NSString
        {
            subjectiveCell.tag = studentId.integerValue
        }
        
        mScrollView.addSubview(subjectiveCell)
        
        
        
        
        currentPositionY = currentPositionY + subjectiveCell.frame.size.height + 10
        totlStudentsCount = totlStudentsCount + 1
        refreshScrollView()
        
        mScrollView.contentSize = CGSize(width: 0, height: currentPositionY)
        
    }
    
     // MARK: - SubjectiveStudentContainer Delegate
    
    func delegateCheckmarkPressedWithState(_ state: Bool, withStudentDetails studentDetails: AnyObject, withAnswerDetails answerDetails: AnyObject) {
        
        if state == true
        {
            
            if let studentId = studentDetails.object(forKey: "StudentId") as? String
            {
                if !selectedStudentsArray.contains(studentId)
                {
                    selectedStudentsArray.add(studentId)
                }
            }
          
            
        }
        else
        {
            if let studentId = studentDetails.object(forKey: "StudentId") as? String
            {
                if selectedStudentsArray.contains(studentId)
                {
                    selectedStudentsArray.remove(studentId)
                }
            }
            
        }
        
        
        
        if delegate().responds(to: #selector(SubjectiveLeftSideViewDelegate.delegateStudentSelectedWithState(_:withStudentDetails:withAnswerDetails:)))
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
    
    func removeStudentsWithStudentsId(_ studentId:String)
    {
        if selectedStudentsArray.contains(studentId)
        {
            selectedStudentsArray.remove(studentId)
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
                if subview.isKind(of: SubjectiveStudentContainer.self)
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
                if subview.isKind(of: SubjectiveStudentContainer.self)
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
            if subjectiveCell.isKind(of: SubjectiveStudentContainer.self)
            {
                subjectiveCell.frame = CGRect(x: subjectiveCell.frame.origin.x ,y: currentPositionY,width: mScrollView.frame.size.width,height: mScrollView.frame.size.width)
                totlStudentsCount = totlStudentsCount + 1
                currentPositionY = currentPositionY + subjectiveCell.frame.size.height + 10
            }
        }
        
        mScrollView.contentSize = CGSize(width: 0, height: currentPositionY)
        
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
