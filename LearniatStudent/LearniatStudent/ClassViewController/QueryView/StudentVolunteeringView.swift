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
    
    var oldVote             = "0"
    
    var newVote             = "0"

    
    override init(frame: CGRect)
    {
        super.init(frame: frame)
        
       
        self.backgroundColor = whiteBackgroundColor
        
        
        
        mStudentImage.frame = CGRect(x: (self.frame.size.width - 80 )/2,y: 60 , width: 80 ,height: 80)
        self.addSubview(mStudentImage)
        mStudentImage.backgroundColor = UIColor.clear
        
        
        
        mStudentImage.layer.cornerRadius = mStudentImage.frame.size.width/16;
        mStudentImage.layer.masksToBounds = true
        
        
        
        
        
        mStudentName.frame = CGRect(x: 10,y: mStudentImage.frame.origin.y + mStudentImage.frame.size.height ,width: self.frame.size.width - 20, height: mStudentImage.frame.size.height)
        mStudentName.textAlignment = .center;
        mStudentName.textColor = blackTextColor
        self.addSubview(mStudentName)
        mStudentName.backgroundColor = UIColor.clear
        mStudentName.textAlignment = .center;
        mStudentName.font = UIFont(name: helveticaMedium, size: 25)
        
        
        
        
        
        mAnsweringLabel.frame = CGRect(x: 10,y: mStudentName.frame.origin.y + mStudentName.frame.size.height ,width: self.frame.size.width - 20, height: mStudentImage.frame.size.height)
        mAnsweringLabel.textAlignment = .center;
        mAnsweringLabel.textColor = blackTextColor
        self.addSubview(mAnsweringLabel)
        mAnsweringLabel.backgroundColor = UIColor.clear
        mAnsweringLabel.textAlignment = .center;
        mStudentName.font = UIFont(name: helveticaMedium, size: 16)

        
        
        
        mQueryLabel.frame = CGRect(x: 10,y: (self.frame.size.height - self.frame.size.height/2)/2,width: self.frame.size.width - 20,height: self.frame.size.height / 2)
        mQueryLabel.textAlignment = .center;
        mQueryLabel.textColor = blackTextColor
        self.addSubview(mQueryLabel)
        mQueryLabel.backgroundColor = UIColor.clear
        mQueryLabel.font = UIFont(name: HelveticaNeueThin, size: 20)
        mQueryLabel.lineBreakMode = .byTruncatingMiddle
        mQueryLabel.numberOfLines = 20
        mQueryLabel.contentMode = .top;
        
        
        mDislikeButton.frame = CGRect(x: 10,y: mQueryLabel.frame.origin.y  + mQueryLabel.frame.size .height + 20 ,width: self.frame.size.width/4 , height: 40)

        self.addSubview(mDislikeButton)
        mDislikeButton.addTarget(self, action: #selector(StudentVolunteeringView.onDislikeButton), for: UIControlEvents.touchUpInside)
        mDislikeButton.setImage(UIImage(named: "Unlike_Selected.png"), for: UIControlState())
        mDislikeButton.imageView?.contentMode = .scaleAspectFit
        
        mLikeButton.frame = CGRect(x: self.frame.size.width - (10 + self.frame.size.width/4),y: mQueryLabel.frame.origin.y  + mQueryLabel.frame.size .height + 20 ,width: self.frame.size.width/4 , height: 40)
        
        self.addSubview(mLikeButton)
        mLikeButton.addTarget(self, action: #selector(StudentVolunteeringView.onLikeButton), for: UIControlEvents.touchUpInside)
        mLikeButton.setImage(UIImage(named: "Like_Selected.png"), for: UIControlState())
        mLikeButton.imageView?.contentMode = .scaleAspectFit
        
    }
    
    required init?(coder aDecoder: NSCoder)
    {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func onLikeButton()
    {
        newVote = "1"
        
        SSStudentMessageHandler.sharedMessageHandler.sendQueryLikedAndDislikeMessagetoTeacherwithNewVote(newVote)
        mLikeButton.isEnabled = false
        mDislikeButton.isEnabled = true
        mDislikeButton.setImage(UIImage(named: "Unlike_Selected.png"), for: UIControlState())
         mLikeButton.setImage(UIImage(named: "Like_Disabled.png"), for: UIControlState())
    }
    
    func onDislikeButton()
    {
        newVote = "-1"
        SSStudentMessageHandler.sharedMessageHandler.sendQueryLikedAndDislikeMessagetoTeacherwithNewVote(newVote)
        mLikeButton.isEnabled = true
        mDislikeButton.isEnabled = false
         mLikeButton.setImage(UIImage(named: "Like_Selected.png"), for: UIControlState())
        mDislikeButton.setImage(UIImage(named: "Unlike_Disabled.png"), for: UIControlState())
    }
    
    
    
    func setVolunteeringDetails(_ details:AnyObject)
    {
        
        
        if let StudentId = details.object(forKey: "AnsweringStudentId") as? String
        {
            
            if StudentId == SSStudentDataSource.sharedDataSource.currentUserId
            {
                mStudentImage.contentMode = .scaleAspectFit
                mStudentImage.image = UIImage(named: "MikeImage.png")
                mAnsweringLabel.text = "Please answer the following query"
               mLikeButton.isHidden = true
                mDislikeButton.isHidden = true
                
            }
            else
            {
                mAnsweringLabel.text = "Answering query"
                mLikeButton.isHidden = false
                mDislikeButton.isHidden = false
                let urlString = UserDefaults.standard.object(forKey: k_INI_UserProfileImageURL) as! String
                
                if let checkedUrl = URL(string: "\(urlString)/\(StudentId)_79px.jpg")
                {
                    mStudentImage.contentMode = .scaleAspectFit
                    mStudentImage.downloadImage(checkedUrl, withFolderType: folderType.proFilePics)
                }
            }
        }
        
        if let StudentName = details.object(forKey: "StudentName") as? String
        {
            mStudentName.text = StudentName
        }
        
        if let QueryId = details.object(forKey: "QueryId") as? String
        {
            
            
            if SSStudentDataSource.sharedDataSource.QRVQueryDictonary.object(forKey: QueryId) != nil
            {
                if let queryText = SSStudentDataSource.sharedDataSource.QRVQueryDictonary.object(forKey: QueryId) as? String
                {
                    mQueryLabel.text = queryText
                }
                
            }
            
            
        }
        
    }
    
    
}
