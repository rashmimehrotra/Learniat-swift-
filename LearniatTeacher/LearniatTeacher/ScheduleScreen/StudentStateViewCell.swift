//
//  StudentStateViewCell.swift
//  LearniatTeacher
//
//  Created by Deepak MK on 27/03/17.
//  Copyright © 2017 Mindshift. All rights reserved.
//

import UIKit

class StudentStateViewCell: UIImageView {

    var mCurrentStudentDetails:AnyObject!
    var _delgate: AnyObject!
    
    var mStudentImage  = CustomProgressImageView()
    
    var mStudentName  = UILabel()
    
    var mStateLabel                     = UILabel()
    
    
    override init(frame: CGRect) {
        
        super.init(frame:frame)
        
        
        mStudentImage.frame = CGRect(x: (self.frame.size.width - self.frame.size.height / 1.5)/2  , y:  0 , width: self.frame.size.height / 1.5, height: self.frame.size.height / 1.5)
        self.addSubview(mStudentImage)
        mStudentImage.backgroundColor = UIColor.clear
        mStudentImage.layer.cornerRadius = mStudentImage.frame.size.width/16;
        mStudentImage.layer.masksToBounds = true
        
        
        mStudentName.frame = CGRect(x: 0,y: mStudentImage.frame.size.height + mStudentImage.frame.origin.y, width: self.frame.size.width, height: self.frame.size.height-(mStudentImage.frame.size.height + mStudentImage.frame.origin.y));
        mStudentName.textAlignment = .center;
        mStudentName.textColor = blackTextColor
        self.addSubview(mStudentName)
        mStudentName.backgroundColor = UIColor.clear
//        mStudentName.allowOrphans = true;
        mStudentName.textAlignment = .center;
        mStudentName.contentMode = .center;
        mStudentName.isHidden = false
        mStudentName.lineBreakMode = .byTruncatingMiddle
        mStudentName.numberOfLines = 2
        
        
        
        mStateLabel.frame = CGRect(x: mStudentImage.frame.origin.x ,y: mStudentImage.frame.size.height - (mStudentImage.frame.size.height/4), width: mStudentImage.frame.size.width, height: mStudentImage.frame.size.height/4);
        mStateLabel.textAlignment = .center;
        mStateLabel.textColor = whiteColor
        self.addSubview(mStateLabel)
        mStateLabel.backgroundColor = standard_Green
        //        mStudentName.allowOrphans = true;
        mStateLabel.textAlignment = .center;
        mStateLabel.contentMode = .center;
        mStateLabel.isHidden = true
        mStateLabel.lineBreakMode = .byTruncatingMiddle
        mStateLabel.numberOfLines = 2
        mStateLabel.alpha = 0.9
        mStateLabel.adjustsFontSizeToFitWidth = true

        
        
        
        
    }
    
    
    func setdelegate(_ delegate:AnyObject)
    {
        _delgate = delegate;
    }
    
    func   delegate()->AnyObject
    {
        return _delgate;
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func setStudentDetails(details:AnyObject)
    {
        mCurrentStudentDetails = details
        
        
        if let StudentName = mCurrentStudentDetails.object(forKey: "Name") as? String
        {
            mStudentName.text       = StudentName
        }
        
        if let StudentId = mCurrentStudentDetails.object(forKey: "StudentId") as? String
        {
            let urlString = UserDefaults.standard.object(forKey: k_INI_UserProfileImageURL) as! String
            
            if let checkedUrl = URL(string: "\(urlString)/\(StudentId)_79px.jpg")
            {
                mStudentImage.contentMode = .scaleAspectFit
                mStudentImage.downloadImage(checkedUrl, withFolderType: folderType.proFilePics)
                mStudentImage.layer.cornerRadius = mStudentImage.frame.size.width/16;
                mStudentImage.layer.masksToBounds = true
                
            }
        }
        
        if let _StudentState = mCurrentStudentDetails.object(forKey: "StudentState") as? String
        {
            
            setStudentState(_StudentState: _StudentState)
            
        }
        
        
    }
    
    func setStudentState(_StudentState:String)
    {
        mStateLabel.isHidden = false
         self.alpha = 1
        UIView.animate(withDuration: 0.5, animations:
            {
                if _StudentState ==  StudentSignedout || _StudentState == "8"
                {
                    self.mStateLabel.text = StudentSignedout
                    self.mStateLabel.backgroundColor = standard_Red
                    self.alpha = 0.5
                }
                else if _StudentState ==  StudentFree || _StudentState ==  StudentPreAllocated || _StudentState == "7" || _StudentState == "9"
                {
                    self.mStateLabel.text = StudentFree
                    self.mStateLabel.backgroundColor = standard_TextGrey
                }
                else if _StudentState == StudentOccupied || _StudentState == "10"
                {
                    self.mStateLabel.text = "Joined"
                    self.mStateLabel.backgroundColor = standard_Green
                }
                else
                {
                    self.mStateLabel.isHidden = true
                }
                
        })
    }
    
    
    

}
