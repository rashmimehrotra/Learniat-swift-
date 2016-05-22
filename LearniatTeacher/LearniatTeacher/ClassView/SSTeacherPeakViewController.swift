//
//  SSTeacherPeakViewController.swift
//  LearniatTeacher
//
//  Created by Deepak MK on 21/05/16.
//  Copyright © 2016 Mindshift. All rights reserved.
//

import Foundation
import UIKit
class SSTeacherPeakViewController: UIViewController
{
    
     var _currentStudentDict:AnyObject!
    
    var peakImage = UIImage()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
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
        mDoneButton.addTarget(self, action: #selector(StudentQueryPopover.onDoneButton), forControlEvents: UIControlEvents.TouchUpInside)
        mDoneButton.setTitleColor(standard_Button, forState: .Normal)
        mDoneButton.setTitle("Done", forState: .Normal)
        mDoneButton.contentHorizontalAlignment = UIControlContentHorizontalAlignment.Right
        mDoneButton.titleLabel?.font = UIFont(name: helveticaMedium, size: 20)
        headerView.addSubview(mDoneButton)
        
        
        
        
        
        
        
        
        if let StudentName = _currentStudentDict.objectForKey("Name") as? String
        {
            headerlabel.text = StudentName
        }
        
        let overLayImageView = CustomProgressImageView(frame: CGRectMake(0,headerView.frame.origin.y + headerView.frame.size.height ,270,180))
        self.view.addSubview(overLayImageView)
        overLayImageView.image = peakImage
        
        
        

    }
    
    func setStudentDetails(StudentDict:AnyObject,  withPeakImage _peakImage:UIImage)
    {
        _currentStudentDict = StudentDict
        
        peakImage = _peakImage
        
        
        
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