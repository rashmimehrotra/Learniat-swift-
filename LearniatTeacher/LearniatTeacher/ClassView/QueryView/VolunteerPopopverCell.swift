//
//  VolunteerPopopverCell.swift
//  LearniatTeacher
//
//  Created by Deepak MK on 13/05/16.
//  Copyright © 2016 Mindshift. All rights reserved.
//

import Foundation
import UIKit

@objc protocol VolunteerPopopverCellDelegate
{
    
    
    optional func delegateCellPressedWithVolunteerDetails(volunteerDetails:AnyObject)
    
    
    
    
}

class VolunteerPopopverCell: UIView
{
    var _delgate: AnyObject!
    
    var mStudentImage        = CustomProgressImageView()
    
    var mStudentName         = UILabel()
    
    var mGiveAnswerButton       = UIButton()

    var currentVolunteerDetails     :AnyObject!
    
    override init(frame: CGRect)
    {
        super.init(frame: frame)
        
        mStudentImage.frame = CGRectMake(10,10 , 40 ,40)
        self.addSubview(mStudentImage)
        mStudentImage.backgroundColor = UIColor.clearColor()
        mStudentImage.layer.cornerRadius = mStudentImage.frame.size.width/16;
        mStudentImage.layer.masksToBounds = true
        
        mStudentName.frame = CGRectMake(mStudentImage.frame.origin.x + mStudentImage.frame.size.width + 10, mStudentImage.frame.origin.y,100,mStudentImage.frame.size.height)
        mStudentName.textAlignment = .Center;
        mStudentName.textColor = blackTextColor
        self.addSubview(mStudentName)
        mStudentName.backgroundColor = UIColor.clearColor()
        mStudentName.textAlignment = .Left;
        mStudentName.font = UIFont(name: helveticaMedium, size: 18)
        
        
        mGiveAnswerButton.frame = CGRectMake(mStudentName.frame.origin.x + mStudentName.frame.size.width  - 10 , 0, 140, self.frame.size.height)
        mGiveAnswerButton.setTitle("Give Answer", forState: .Normal)
        self.addSubview(mGiveAnswerButton)
        mGiveAnswerButton.setTitleColor(standard_Button, forState: .Normal)
        mGiveAnswerButton.contentHorizontalAlignment = UIControlContentHorizontalAlignment.Right
        mGiveAnswerButton.titleLabel?.font = UIFont(name: helveticaRegular, size: 16)
        mGiveAnswerButton.addTarget(self, action: #selector(VolunteerPopopverCell.onGiveAnswerButton), forControlEvents: .TouchUpInside)
        mGiveAnswerButton.backgroundColor = UIColor.clearColor()

        
    }
    
    required init?(coder aDecoder: NSCoder)
    {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setdelegate(delegate:AnyObject)
    {
        _delgate = delegate;
    }
    
    func   delegate()->AnyObject
    {
        return _delgate;
    }
    
    
    func onGiveAnswerButton()
    {
        delegate().delegateCellPressedWithVolunteerDetails!(currentVolunteerDetails)
    }
    
    func setVolunteersDetails(volunteersDetails:AnyObject)
    {
        currentVolunteerDetails = volunteersDetails

        if let StudentName = currentVolunteerDetails.objectForKey("StudentName") as? String
        {
            mStudentName.text       = StudentName
        }
        
        
        if let StudentId = currentVolunteerDetails.objectForKey("StudentId") as? String
        {
            let urlString = NSUserDefaults.standardUserDefaults().objectForKey(k_INI_UserProfileImageURL) as! String
            
            if let checkedUrl = NSURL(string: "\(urlString)/\(StudentId)_79px.jpg")
            {
                mStudentImage.contentMode = .ScaleAspectFit
                mStudentImage.downloadImage(checkedUrl, withFolderType: folderType.ProFilePics)
            }
        }
    }
    
    
}