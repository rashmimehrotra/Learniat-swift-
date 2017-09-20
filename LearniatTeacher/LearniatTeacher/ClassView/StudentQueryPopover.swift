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
    
    func setdelegate(_ delegate:AnyObject)
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
        
        
        
        
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: 320, height: 40))
        headerView.backgroundColor = lightGrayTopBar
        self.view.addSubview(headerView);
        
        
        let seperatorView = UIView(frame: CGRect(x: 0, y: headerView.frame.size.height-1, width: headerView.frame.size.width, height: 1))
        seperatorView.backgroundColor = LineGrayColor
        headerView.addSubview(seperatorView);
        
        
        
        
        
        
        
        let headerlabel = UILabel(frame: CGRect(x: 20, y: 0, width: 200, height: 40))
        headerlabel.text = kOverlayScribble
        headerView.addSubview(headerlabel)
        headerlabel.textAlignment = .left;
        headerlabel.font = UIFont(name: helveticaRegular, size: 20)
        headerlabel.textColor  = blackTextColor
        
        
        
        let  mDoneButton = UIButton(frame: CGRect(x: headerView.frame.size.width - 120, y: 0, width: 100, height: 40))
        mDoneButton.addTarget(self, action: #selector(StudentQueryPopover.onDoneButton), for: UIControlEvents.touchUpInside)
        mDoneButton.setTitleColor(standard_Button, for: UIControlState())
        mDoneButton.setTitle("Done", for: UIControlState())
        mDoneButton.contentHorizontalAlignment = UIControlContentHorizontalAlignment.right
        mDoneButton.titleLabel?.font = UIFont(name: helveticaMedium, size: 20)
        headerView.addSubview(mDoneButton)
        
        
        
        
        
        
        
        
        if let StudentName = _currentQueryDetails.object(forKey: "StudentName") as? String
        {
            headerlabel.text = StudentName
        }
        
        
        
        let studentAnswertext = UILabel(frame: CGRect(x: 10,y: seperatorView.frame.origin.y + seperatorView.frame.size.height ,width: 300,height: 180))
        self.view.addSubview(studentAnswertext)
        
       
        
        studentAnswertext.font = UIFont(name: helveticaRegular, size: 16)
        studentAnswertext.textColor = blackTextColor
        studentAnswertext.lineBreakMode = .byTruncatingMiddle
        studentAnswertext.numberOfLines = 10
        studentAnswertext.textAlignment = .center
        if let TextAnswer = _currentQueryDetails.object(forKey: "QueryText") as? String
        {
            studentAnswertext.text = TextAnswer
            var totalSize = TextAnswer.heightForView(TextAnswer, font: studentAnswertext.font, width: studentAnswertext.frame.size.width)
            
            if totalSize < 70
            {
                totalSize = 70
            }
            studentAnswertext.frame =  CGRect(x: 10,y: seperatorView.frame.origin.y + seperatorView.frame.size.height ,width: 300,height: totalSize)
            
            self.preferredContentSize = CGSize(width: 320, height: totalSize + 40 )
            
        }
        
        
        
        
        
        
        
    }
    
    func setQueryWithDetails(_ queryDetails:AnyObject, withStudentDetials StudentDict:AnyObject)
    {
        _currentStudentDict = StudentDict
        _currentQueryDetails = queryDetails
    }
    
    
    
    var _Popover:UIPopoverController!
    
    func setPopover(_ popover:UIPopoverController)
    {
        _Popover = popover
    }
    
    func popover()-> UIPopoverController
    {
        return _Popover
    }
    
    
    func onDoneButton()
    {
       popover().dismiss(animated: true)
        
    }
    
}
