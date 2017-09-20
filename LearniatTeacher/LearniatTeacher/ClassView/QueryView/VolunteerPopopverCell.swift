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
    
    
    @objc optional func delegateCellPressedWithVolunteerDetails(_ volunteerDetails:AnyObject)
    
    
    
    
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
        
        mStudentImage.frame = CGRect(x: 10,y: 10 , width: 40 ,height: 40)
        self.addSubview(mStudentImage)
        mStudentImage.backgroundColor = UIColor.clear
        mStudentImage.layer.cornerRadius = mStudentImage.frame.size.width/16;
        mStudentImage.layer.masksToBounds = true
        
        mStudentName.frame = CGRect(x: mStudentImage.frame.origin.x + mStudentImage.frame.size.width + 10, y: mStudentImage.frame.origin.y,width: 100,height: mStudentImage.frame.size.height)
        mStudentName.textAlignment = .center;
        mStudentName.textColor = blackTextColor
        self.addSubview(mStudentName)
        mStudentName.backgroundColor = UIColor.clear
        mStudentName.textAlignment = .left;
        mStudentName.font = UIFont(name: helveticaMedium, size: 18)
        
        
        mGiveAnswerButton.frame = CGRect(x: mStudentName.frame.origin.x + mStudentName.frame.size.width  - 10 , y: 0, width: 140, height: self.frame.size.height)
        mGiveAnswerButton.setTitle("Give Answer", for: UIControlState())
        self.addSubview(mGiveAnswerButton)
        mGiveAnswerButton.setTitleColor(standard_Button, for: UIControlState())
        mGiveAnswerButton.contentHorizontalAlignment = UIControlContentHorizontalAlignment.right
        mGiveAnswerButton.titleLabel?.font = UIFont(name: helveticaRegular, size: 16)
        mGiveAnswerButton.addTarget(self, action: #selector(VolunteerPopopverCell.onGiveAnswerButton), for: .touchUpInside)
        mGiveAnswerButton.backgroundColor = UIColor.clear

        if SSTeacherDataSource.sharedDataSource.isVolunteerAnswering == false
        {
            mGiveAnswerButton.isHidden = false
        }
        else
        {
            mGiveAnswerButton.isHidden = true
        }
        
    }
    
    required init?(coder aDecoder: NSCoder)
    {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setdelegate(_ delegate:AnyObject)
    {
        _delgate = delegate;
    }
    
    func   delegate()->AnyObject
    {
        return _delgate;
    }
    
    
    func onGiveAnswerButton()
    {
        if SSTeacherDataSource.sharedDataSource.isVolunteerAnswering == false
        {
            SSTeacherDataSource.sharedDataSource.isVolunteerAnswering = true
            delegate().delegateCellPressedWithVolunteerDetails!(currentVolunteerDetails)
        }
        
    }
    
    func setVolunteersDetails(_ volunteersDetails:AnyObject)
    {
        currentVolunteerDetails = volunteersDetails

        if let StudentName = currentVolunteerDetails.object(forKey: "StudentName") as? String
        {
            mStudentName.text       = StudentName
        }
        
        
        if let StudentId = currentVolunteerDetails.object(forKey: "StudentId") as? String
        {
            let urlString = UserDefaults.standard.object(forKey: k_INI_UserProfileImageURL) as! String
            
            if let checkedUrl = URL(string: "\(urlString)/\(StudentId)_79px.jpg")
            {
                mStudentImage.contentMode = .scaleAspectFit
                mStudentImage.downloadImage(checkedUrl, withFolderType: folderType.proFilePics)
            }
        }
    }
    
    
}
