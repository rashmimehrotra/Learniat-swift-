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
    
    optional func delegateStudentTileTouched()
    
    
}

class StudentSeatSubView: UIView,SSStudentDataSourceDelegate
{
    
    
    var currentStudentDetails :AnyObject!
    
    var cellWith : CGFloat = 0
    
    var cellHeight : CGFloat = 0
    
    var refrenceDeskImageView = UIImageView()
    
    var mStudentImage  = UIImageView()
    
    var mMiddleStudentName  = UILabel()
    
    var answerDeskImageView  = LBorderView()
    
    
    var _delgate: AnyObject!
    
    func setdelegate(delegate:AnyObject)
    {
        _delgate = delegate;
    }
    
    func   delegate()->AnyObject
    {
        return _delgate;
    }
    
    
    override init(frame: CGRect) {
        
        super.init(frame:frame)
        
        
        self.backgroundColor = UIColor.clearColor()
        
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
        
        
        
        refrenceDeskImageView.frame = CGRectMake((self.frame.size.width-deskSize)/2, (self.frame.size.height-deskSize)/2,deskSize,deskSize )
        self.addSubview(refrenceDeskImageView)
        refrenceDeskImageView.backgroundColor = UIColor.clearColor()
        cellWith = refrenceDeskImageView.frame.size.width
        cellHeight = cellWith / 2
        refrenceDeskImageView.userInteractionEnabled = true
        
        
        
        mStudentImage.frame = CGRectMake((refrenceDeskImageView.frame.size.width - (refrenceDeskImageView.frame.size.width / 3.5))/2, (refrenceDeskImageView.frame.size.width / 3.5) / 8, refrenceDeskImageView.frame.size.width / 3.5, refrenceDeskImageView.frame.size.width / 3.5)
        refrenceDeskImageView.addSubview(mStudentImage)
        mStudentImage.backgroundColor = UIColor.clearColor()
        
        
        answerDeskImageView.frame = CGRectMake((refrenceDeskImageView.frame.size.width-refrenceDeskImageView.frame.size.width/1.1)/2, (mStudentImage.frame.size.height+cellHeight/8),refrenceDeskImageView.frame.size.width/1.1, refrenceDeskImageView.frame.size.width/1.65)
        refrenceDeskImageView.addSubview(answerDeskImageView)
        answerDeskImageView.borderType = BorderTypeSolid;
       
        answerDeskImageView.borderWidth = 1;
        answerDeskImageView.borderColor = LineGrayColor;

        
        mMiddleStudentName.frame = CGRectMake((refrenceDeskImageView.frame.size.width-refrenceDeskImageView.frame.size.width/1.1)/2, (mStudentImage.frame.size.height+cellHeight/8),refrenceDeskImageView.frame.size.width/1.1, refrenceDeskImageView.frame.size.width/1.65)
        refrenceDeskImageView.addSubview(mMiddleStudentName)
        mMiddleStudentName.backgroundColor = UIColor.clearColor();
        mMiddleStudentName.textAlignment = .Center;
        mMiddleStudentName.numberOfLines=10;
        mMiddleStudentName.lineBreakMode = .ByTruncatingMiddle
        mMiddleStudentName.textColor = UIColor.whiteColor()

        
        
    }
    
    
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
        
        
    }
    
    
    func setStudentDetails(details: AnyObject)
    {
        currentStudentDetails = details
        
        
        if let StudentName = currentStudentDetails.objectForKey("StudentName") as? String
        {
            mMiddleStudentName.text = StudentName
        }
        
        
        if let StudentId = currentStudentDetails.objectForKey("StudentId") as? String
        {
            
            if StudentId == SSStudentDataSource.sharedDataSource.currentUserId
            {
                mMiddleStudentName.hidden = true
                answerDeskImageView.backgroundColor = standard_Green
                answerDeskImageView.borderColor = standard_Green;
                
                
                let  mBackButton = UIButton(frame: CGRectMake(10, 10, answerDeskImageView.frame.size.width - 20 ,answerDeskImageView.frame.size.height - 20  ))
                answerDeskImageView.addSubview(mBackButton)
                mBackButton.setTitle("Join", forState: .Normal)
                mBackButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
                mBackButton.titleLabel?.font = UIFont(name: helveticaMedium, size: 18)
                mBackButton.addTarget(self, action: #selector(StudentSeatViewController.onBack), forControlEvents: UIControlEvents.TouchUpInside)
                mBackButton.contentHorizontalAlignment = UIControlContentHorizontalAlignment.Center
                mBackButton.layer.borderColor = UIColor.whiteColor().CGColor
                mBackButton.layer.borderWidth = 2
                mBackButton.layer.cornerRadius = mBackButton.frame.size.width / 16

                let  mDoneButton = UIButton()
                mDoneButton.frame = answerDeskImageView.frame
                refrenceDeskImageView.addSubview(mDoneButton)
                mDoneButton.addTarget(self, action: #selector(StudentSeatSubView.onDeskPressed), forControlEvents: UIControlEvents.TouchUpInside)
                
                
            }
            
            let urlString = NSUserDefaults.standardUserDefaults().objectForKey(k_INI_UserProfileImageURL) as! String
            
            if let checkedUrl = NSURL(string: "\(urlString)/\(StudentId)_79px.jpg")
            {
                mStudentImage.contentMode = .ScaleAspectFit
                mStudentImage.downloadImage(checkedUrl, withFolderType: folderType.ProFilePics)
                mStudentImage.layer.cornerRadius = mStudentImage.frame.size.width/16;
                mStudentImage.layer.masksToBounds = true
                
            }
        }
    }
    
    
    func onDeskPressed()
    {
        if delegate().respondsToSelector(#selector(StudentSeatSubViewDelegate.delegateStudentTileTouched))
        {
            
            delegate().delegateStudentTileTouched!()
            
        }
    }
    
}