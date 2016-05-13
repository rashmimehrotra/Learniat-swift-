//
//  StudentVolunteeringView.swift
//  LearniatStudent
//
//  Created by Deepak MK on 12/05/16.
//  Copyright © 2016 Mindshift. All rights reserved.
//

import Foundation
import UIKit
class StudentVolunteeringView: UIView,SSStudentDataSourceDelegate
{
    var mStudentImage        = CustomProgressImageView()
    
    var mStudentName         = UILabel()
    
    var mQueryLabel         = UILabel()
    
    var mLikeButton         = UIButton()
    
    var mDislikeButton      = UIButton()
    
    var mAnsweringLabel     = UILabel()

    
    override init(frame: CGRect)
    {
        super.init(frame: frame)
        
       
        self.backgroundColor = whiteBackgroundColor
        
        
        
        mStudentImage.frame = CGRectMake((self.frame.size.width - 80 )/2,60 , 80 ,80)
        self.addSubview(mStudentImage)
        mStudentImage.backgroundColor = UIColor.clearColor()
        
        
        
        mStudentImage.layer.cornerRadius = mStudentImage.frame.size.width/16;
        mStudentImage.layer.masksToBounds = true
        
        
        
        
        
        mStudentName.frame = CGRectMake(10,mStudentImage.frame.origin.y + mStudentImage.frame.size.height ,self.frame.size.width - 20, mStudentImage.frame.size.height)
        mStudentName.textAlignment = .Center;
        mStudentName.textColor = blackTextColor
        self.addSubview(mStudentName)
        mStudentName.backgroundColor = UIColor.clearColor()
        mStudentName.textAlignment = .Center;
        mStudentName.font = UIFont(name: helveticaMedium, size: 25)
        
        
        
        
        
        mAnsweringLabel.frame = CGRectMake(10,mStudentName.frame.origin.y + mStudentName.frame.size.height ,self.frame.size.width - 20, mStudentImage.frame.size.height)
        mAnsweringLabel.textAlignment = .Center;
        mAnsweringLabel.textColor = blackTextColor
        self.addSubview(mAnsweringLabel)
        mAnsweringLabel.backgroundColor = UIColor.clearColor()
        mAnsweringLabel.textAlignment = .Center;
        mStudentName.font = UIFont(name: helveticaMedium, size: 16)

        
        
        
        mQueryLabel.frame = CGRectMake(10,(self.frame.size.height - self.frame.size.height/2)/2,self.frame.size.width - 20,self.frame.size.height / 2)
        mQueryLabel.textAlignment = .Center;
        mQueryLabel.textColor = blackTextColor
        self.addSubview(mQueryLabel)
        mQueryLabel.backgroundColor = UIColor.clearColor()
        mQueryLabel.font = UIFont(name: HelveticaNeueThin, size: 20)
        mQueryLabel.lineBreakMode = .ByTruncatingMiddle
        mQueryLabel.numberOfLines = 20
        mQueryLabel.contentMode = .Top;
        
        
        mDislikeButton.frame = CGRectMake(10,mQueryLabel.frame.origin.y  + mQueryLabel.frame.size .height + 20 ,self.frame.size.width/4 , 40)

        self.addSubview(mDislikeButton)
        mDislikeButton.addTarget(self, action: #selector(QRVSubView.onVolunteerButton), forControlEvents: UIControlEvents.TouchUpInside)
        mDislikeButton.setImage(UIImage(named: "Unlike_Selected.png"), forState: .Normal)
        mDislikeButton.imageView?.contentMode = .ScaleAspectFit
        
        mLikeButton.frame = CGRectMake(self.frame.size.width - (10 + self.frame.size.width/4),mQueryLabel.frame.origin.y  + mQueryLabel.frame.size .height + 20 ,self.frame.size.width/4 , 40)
        
        self.addSubview(mLikeButton)
        mLikeButton.addTarget(self, action: #selector(QRVSubView.onVolunteerButton), forControlEvents: UIControlEvents.TouchUpInside)
        mLikeButton.setImage(UIImage(named: "Like_Selected.png"), forState: .Normal)
        mLikeButton.imageView?.contentMode = .ScaleAspectFit
        
    }
    
    required init?(coder aDecoder: NSCoder)
    {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    func setVolunteeringDetails(details:AnyObject)
    {
        
        
        if let StudentId = details.objectForKey("AnsweringStudentId") as? String
        {
            
            if StudentId == SSStudentDataSource.sharedDataSource.currentUserId
            {
                mStudentImage.contentMode = .ScaleAspectFit
                mStudentImage.image = UIImage(named: "MikeImage.png")
                mAnsweringLabel.text = "Please answer the following query"
            }
            else
            {
                mAnsweringLabel.text = "Answering query"
                let urlString = NSUserDefaults.standardUserDefaults().objectForKey(k_INI_UserProfileImageURL) as! String
                
                if let checkedUrl = NSURL(string: "\(urlString)/\(StudentId)_79px.jpg")
                {
                    mStudentImage.contentMode = .ScaleAspectFit
                    mStudentImage.downloadImage(checkedUrl, withFolderType: folderType.ProFilePics)
                }
            }
        }
        
        if let StudentName = details.objectForKey("StudentName") as? String
        {
            mStudentName.text = StudentName
        }
        
        if let QueryId = details.objectForKey("QueryId") as? String
        {
            
            
            if SSStudentDataSource.sharedDataSource.QRVQueryDictonary.objectForKey(QueryId) != nil
            {
                if let queryText = SSStudentDataSource.sharedDataSource.QRVQueryDictonary.objectForKey(QueryId) as? String
                {
                    mQueryLabel.text = queryText
                }
                
            }
            
            
        }
        
    }
    
    
}