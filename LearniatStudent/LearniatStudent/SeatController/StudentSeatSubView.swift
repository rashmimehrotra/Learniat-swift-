//
//  StudentSeatSubView.swift
//  LearniatStudent
//
//  Created by Deepak MK on 22/04/16.
//  Copyright © 2016 Mindshift. All rights reserved.
//

import Foundation
@objc protocol StudentSeatSubViewDelegate
{
    
    @objc optional func delegateStudentTileTouched()
    
    
}

class StudentSeatSubView: UIView,SSStudentDataSourceDelegate
{
    
    
    var currentStudentDetails :AnyObject!
    
    var cellWith : CGFloat = 0
    
    var cellHeight : CGFloat = 0
    
    var refrenceDeskImageView = UIImageView()
    
    var mStudentImage  = CustomProgressImageView()
    
    var mMiddleStudentName  = UILabel()
    
    var answerDeskImageView  = LBorderView()
    
    
    var _delgate: AnyObject!
    
    func setdelegate(_ delegate:AnyObject)
    {
        _delgate = delegate;
    }
    
    func   delegate()->AnyObject
    {
        return _delgate;
    }
    
    
    override init(frame: CGRect) {
        
        super.init(frame:frame)
        
        
        self.backgroundColor = UIColor.clear
        
        var deskSize:CGFloat = self.frame.size.width
        
        
        
        if (self.frame.size.height > self.frame.size.width)
        {
            deskSize = self.frame.size.width;
        }
        else if (self.frame.size.width>self.frame.size.height)
        {
            deskSize=self.frame.size.height;
        }
        else if(self.frame.size.width==self.frame.size.height)
        {
            deskSize=self.frame.size.width;
        }
        
        
        
        refrenceDeskImageView.frame = CGRect(x: (self.frame.size.width-deskSize)/2, y: (self.frame.size.height-deskSize)/2,width: deskSize,height: deskSize )
        self.addSubview(refrenceDeskImageView)
        refrenceDeskImageView.backgroundColor = UIColor.clear
        cellWith = refrenceDeskImageView.frame.size.width
        cellHeight = cellWith / 2
        refrenceDeskImageView.isUserInteractionEnabled = true
        
        
        
        mStudentImage.frame = CGRect(x: (refrenceDeskImageView.frame.size.width - (refrenceDeskImageView.frame.size.width / 3.5))/2, y: (refrenceDeskImageView.frame.size.width / 3.5) / 8, width: refrenceDeskImageView.frame.size.width / 3.5, height: refrenceDeskImageView.frame.size.width / 3.5)
        refrenceDeskImageView.addSubview(mStudentImage)
        mStudentImage.backgroundColor = UIColor.clear
        
        
        answerDeskImageView.frame = CGRect(x: (refrenceDeskImageView.frame.size.width-refrenceDeskImageView.frame.size.width/1.1)/2, y: (mStudentImage.frame.size.height+cellHeight/8),width: refrenceDeskImageView.frame.size.width/1.1, height: refrenceDeskImageView.frame.size.width/1.65)
        refrenceDeskImageView.addSubview(answerDeskImageView)
        answerDeskImageView.borderType = BorderTypeSolid;
       
        answerDeskImageView.borderWidth = 1;
        answerDeskImageView.borderColor = LineGrayColor;

        
        mMiddleStudentName.frame = CGRect(x: (refrenceDeskImageView.frame.size.width-refrenceDeskImageView.frame.size.width/1.1)/2, y: (mStudentImage.frame.size.height+cellHeight/8),width: refrenceDeskImageView.frame.size.width/1.1, height: refrenceDeskImageView.frame.size.width/1.65)
        refrenceDeskImageView.addSubview(mMiddleStudentName)
        mMiddleStudentName.backgroundColor = UIColor.clear;
        mMiddleStudentName.textAlignment = .center;
        mMiddleStudentName.numberOfLines=10;
        mMiddleStudentName.lineBreakMode = .byTruncatingMiddle
        mMiddleStudentName.textColor = UIColor.white

        
        
    }
    
    
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
        
        
    }
    
    
    func setStudentDetails(_ details: AnyObject)
    {
        currentStudentDetails = details
        
        
        if let StudentName = currentStudentDetails.object(forKey: "StudentName") as? String
        {
            mMiddleStudentName.text = StudentName
        }
        
        
        if let StudentId = currentStudentDetails.object(forKey: "StudentId") as? String
        {
            
            if StudentId == SSStudentDataSource.sharedDataSource.currentUserId
            {
                mMiddleStudentName.isHidden = true
                answerDeskImageView.backgroundColor = standard_Green
                answerDeskImageView.borderColor = standard_Green;
                
                
                let  mBackButton = UIButton(frame: CGRect(x: 10, y: 10, width: answerDeskImageView.frame.size.width - 20 ,height: answerDeskImageView.frame.size.height - 20  ))
                answerDeskImageView.addSubview(mBackButton)
                mBackButton.setTitle("Join", for: UIControlState())
                mBackButton.setTitleColor(UIColor.white, for: UIControlState())
                mBackButton.titleLabel?.font = UIFont(name: helveticaMedium, size: 18)
                mBackButton.addTarget(self, action: #selector(StudentSeatViewController.onBack), for: UIControlEvents.touchUpInside)
                mBackButton.contentHorizontalAlignment = UIControlContentHorizontalAlignment.center
                mBackButton.layer.borderColor = UIColor.white.cgColor
                mBackButton.layer.borderWidth = 2
                mBackButton.layer.cornerRadius = mBackButton.frame.size.width / 16

                let  mDoneButton = UIButton()
                mDoneButton.frame = answerDeskImageView.frame
                refrenceDeskImageView.addSubview(mDoneButton)
                mDoneButton.addTarget(self, action: #selector(StudentSeatSubView.onDeskPressed), for: UIControlEvents.touchUpInside)
                
                
            }
            
            let urlString = UserDefaults.standard.object(forKey: k_INI_UserProfileImageURL) as! String
            
            if let checkedUrl = URL(string: "\(urlString)/\(StudentId)_79px.jpg")
            {
                mStudentImage.contentMode = .scaleAspectFit
                mStudentImage.downloadImage(checkedUrl, withFolderType: folderType.proFilePics)
                mStudentImage.layer.cornerRadius = mStudentImage.frame.size.width/16;
                mStudentImage.layer.masksToBounds = true
                
            }
        }
    }
    
    
    func onDeskPressed()
    {
        if delegate().responds(to: #selector(StudentSeatSubViewDelegate.delegateStudentTileTouched))
        {
            
            delegate().delegateStudentTileTouched!()
            
        }
    }
    
}
