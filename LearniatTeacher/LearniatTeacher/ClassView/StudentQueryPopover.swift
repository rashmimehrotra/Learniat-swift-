//
//  StudentQueryPopover.swift
//  LearniatTeacher
//
//  Created by Deepak MK on 12/04/16.
//  Copyright © 2016 Mindshift. All rights reserved.
//

import Foundation
class StudentQueryPopover: UIViewController
{
    var _delgate: AnyObject!
    
    var _currentStudentDict:AnyObject!
    
    var _currentQueryDetails:AnyObject!
    
    func setdelegate(delegate:AnyObject)
    {
        _delgate = delegate;
    }
    
    func   delegate()->AnyObject
    {
        return _delgate;
    }
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        
        //        self.view.setNeedsLayout()
        //        self.view.layoutIfNeeded()
        
        
        
        
        let headerView = UIView(frame: CGRectMake(0, 0, 320, 40))
        headerView.backgroundColor = lightGrayTopBar
        self.view.addSubview(headerView);
        
        
        let seperatorView = UIView(frame: CGRectMake(0, headerView.frame.size.height-1, headerView.frame.size.width, 1))
        seperatorView.backgroundColor = LineGrayColor
        headerView.addSubview(seperatorView);
        
        
        
        
        
        
        
        let headerlabel = UILabel(frame: CGRectMake(20, 0, 200, 40))
        headerlabel.text = kOverlayScribble
        headerView.addSubview(headerlabel)
        headerlabel.textAlignment = .Left;
        headerlabel.font = UIFont(name: helveticaRegular, size: 20)
        headerlabel.textColor  = blackTextColor
        
        
        
        let  mDoneButton = UIButton(frame: CGRectMake(headerView.frame.size.width - 120, 0, 100, 40))
        mDoneButton.addTarget(self, action: "onDoneButton", forControlEvents: UIControlEvents.TouchUpInside)
        mDoneButton.setTitleColor(standard_Button, forState: .Normal)
        mDoneButton.setTitle("Done", forState: .Normal)
        mDoneButton.contentHorizontalAlignment = UIControlContentHorizontalAlignment.Right
        mDoneButton.titleLabel?.font = UIFont(name: helveticaMedium, size: 20)
        headerView.addSubview(mDoneButton)
        
        
        
        
        
        
        
        
        if let StudentName = _currentQueryDetails.objectForKey("StudentName") as? String
        {
            headerlabel.text = StudentName
        }
        
        
        
        let studentAnswertext = UILabel(frame: CGRectMake(10,seperatorView.frame.origin.y + seperatorView.frame.size.height ,300,180))
        self.view.addSubview(studentAnswertext)
        
       
        
        studentAnswertext.font = UIFont(name: helveticaRegular, size: 16)
        studentAnswertext.textColor = blackTextColor
        studentAnswertext.lineBreakMode = .ByTruncatingMiddle
        studentAnswertext.numberOfLines = 10
        studentAnswertext.textAlignment = .Center
        if let TextAnswer = _currentQueryDetails.objectForKey("QueryText") as? String
        {
            studentAnswertext.text = TextAnswer
            var totalSize = TextAnswer.heightForView(TextAnswer, font: studentAnswertext.font, width: studentAnswertext.frame.size.width)
            
            if totalSize < 70
            {
                totalSize = 70
            }
            studentAnswertext.frame =  CGRectMake(10,seperatorView.frame.origin.y + seperatorView.frame.size.height ,300,totalSize)
            
            self.preferredContentSize = CGSize(width: 320, height: totalSize + 40 )
            
        }
        
        
        
        
        
        
        
    }
    
    func setQueryWithDetails(queryDetails:AnyObject, withStudentDetials StudentDict:AnyObject)
    {
        _currentStudentDict = StudentDict
        _currentQueryDetails = queryDetails
    }
    
    
    var _Popover:AnyObject!
    func setPopover(popover:AnyObject)
    {
        _Popover = popover
    }
    
    func popover()-> AnyObject
    {
        return _Popover
    }
    func onDoneButton()
    {
        popover().dismissPopoverAnimated(true)
        
    }
    
}