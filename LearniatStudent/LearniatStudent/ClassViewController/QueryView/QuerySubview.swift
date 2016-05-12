//
//  QuerySubview.swift
//  LearniatTeacher
//
//  Created by Deepak MK on 11/04/16.
//  Copyright © 2016 Mindshift. All rights reserved.
//

import Foundation


@objc protocol QuerySubviewDelegate
{
    
    
    optional func delegateWithDrawButtonPressed()
    
}


class QuerySubview: UIView
{
    var _delgate: AnyObject!
    
    var currentQueryID          = ""
    
    var mStudentImage        = CustomProgressImageView()
    
    var mStudentName         = UILabel()
    
    var mQueryLabel         = UILabel()
    
    let mWithDrawButton       = UIButton()
    
     var goodQueryLabel         = UILabel()
    
    var goodImage = UIImageView()
    
    var currentReplyDetails :AnyObject!
    
    override init(frame: CGRect)
    {
        
        super.init(frame:frame)
        
        self.backgroundColor = UIColor.whiteColor()
        
        
        
        mStudentImage.frame = CGRectMake(10,10 , 40 ,40)
        self.addSubview(mStudentImage)
        mStudentImage.backgroundColor = UIColor.clearColor()
        
        if let StudentId = SSStudentDataSource.sharedDataSource.currentUserId
        {
            let urlString = NSUserDefaults.standardUserDefaults().objectForKey(k_INI_UserProfileImageURL) as! String
            
            if let checkedUrl = NSURL(string: "\(urlString)/\(StudentId)_79px.jpg")
            {
                mStudentImage.contentMode = .ScaleAspectFit
                mStudentImage.downloadImage(checkedUrl, withFolderType: folderType.ProFilePics)
            }
        }
        
        mStudentImage.layer.cornerRadius = mStudentImage.frame.size.width/16;
        mStudentImage.layer.masksToBounds = true
        
        
        
        
        
        mStudentName.frame = CGRectMake(mStudentImage.frame.origin.x + mStudentImage.frame.size.width + 10,mStudentImage.frame.origin.y,400,mStudentImage.frame.size.height / 1.8)
        mStudentName.textAlignment = .Center;
        mStudentName.textColor = blackTextColor
        self.addSubview(mStudentName)
        mStudentName.backgroundColor = UIColor.clearColor()
        mStudentName.textAlignment = .Left;
        mStudentName.font = UIFont(name: helveticaMedium, size: 18)
        mStudentName.text = SSStudentDataSource.sharedDataSource.currentUserName.capitalizedString
        
        
        mQueryLabel.frame = CGRectMake(mStudentName.frame.origin.x,mStudentImage.frame.origin.y + mStudentImage.frame.size.height  ,self.frame.size.width - mStudentName.frame.origin.x ,mStudentImage.frame.size.height / 2)
        mQueryLabel.textAlignment = .Left;
        mQueryLabel.textColor = blackTextColor
        self.addSubview(mQueryLabel)
        mQueryLabel.backgroundColor = UIColor.clearColor()
        mQueryLabel.font = UIFont(name: helveticaRegular, size: 18)
        mQueryLabel.lineBreakMode = .ByTruncatingMiddle
        mQueryLabel.numberOfLines = 20
        mQueryLabel.contentMode = .Top;
        
        
        mWithDrawButton.frame = CGRectMake(self.frame.size.width - 150, 0, 140 , 40)
        self.addSubview(mWithDrawButton)
        mWithDrawButton.addTarget(self, action: #selector(QuerySubview.onDismissButton), forControlEvents: UIControlEvents.TouchUpInside)
         mWithDrawButton.setTitleColor(standard_Button, forState: .Normal)
         mWithDrawButton.setTitle("Withdraw", forState: .Normal)
        mWithDrawButton.contentHorizontalAlignment = UIControlContentHorizontalAlignment.Right
        
        
        
        goodQueryLabel = UILabel(frame:  CGRectMake(self.frame.size.width - 130 ,mStudentName.frame.origin.y, 120,mStudentName.frame.size.height))
        self.addSubview(goodQueryLabel)
        goodQueryLabel.lineBreakMode = .ByTruncatingMiddle
        goodQueryLabel.textAlignment = .Right
        goodQueryLabel.text = "GOOD QUERY"
        goodQueryLabel.textColor = blackTextColor
        goodQueryLabel.font =  UIFont (name: helveticaMedium, size: 16)
        goodQueryLabel.hidden = true
        
        goodImage = UIImageView(frame:  CGRectMake(goodQueryLabel.frame.origin.x - 25 , mStudentName.frame.origin.y, 25,25))
        goodImage.image = UIImage(named:"Thumbs_Up.png")
        self.addSubview(goodImage)
        goodImage.hidden = true

        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
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
    
    
    func setQueryWithDetails(queryText:String, withQueryId QueryId:String) -> CGFloat
    {
        var getQueryHeight :CGFloat = 80
        
        
        getQueryHeight = heightForView(queryText, font: mQueryLabel.font, width: mQueryLabel.frame.size.width)
        
        mQueryLabel.text = queryText
        mQueryLabel.frame = CGRectMake(mQueryLabel.frame.origin.x ,mQueryLabel.frame.origin.y - 5,mQueryLabel.frame.size.width,getQueryHeight)
        getQueryHeight = getQueryHeight + 60
        
        if getQueryHeight < 80
        {
            getQueryHeight = 80
        }
        
        currentQueryID = QueryId;
        
        return getQueryHeight
        
    }
    
    

    
    
    func heightForView(text:String, font:UIFont, width:CGFloat) -> CGFloat
    {
        let label:UILabel = UILabel(frame: CGRectMake(0, 0, width, CGFloat.max))
        label.numberOfLines = 0
        label.lineBreakMode = NSLineBreakMode.ByWordWrapping
        label.font = font
        label.text = text
        
        label.sizeToFit()
        return label.frame.height
    }
    
    func setQueryReplyWithDetiails(details:AnyObject)
    {
        var teacherTextReply = ""
        
        if  let _teacherTextReply =  ( details.objectForKey("TeacherReplyText") as? String)
        {
            teacherTextReply = _teacherTextReply
        }
        if teacherTextReply.isEmpty
        {
            teacherTextReply = ""
        }
        
        
        
        
        if let badgeId = details.objectForKey("BadgeId") as? String
        {
            if badgeId == "1"
            {
               goodQueryLabel.hidden = false
                 goodImage.hidden = false
            }
            else
            {
                goodQueryLabel.hidden = true
                 goodImage.hidden = true
            }
        }
        else
        {
            goodQueryLabel.hidden = true
        }
        
        
        let dismissFlag = ( details.objectForKey("DismissFlag") as! String)
        
        
        
        
        
        if dismissFlag == "1"
        {
            if goodQueryLabel.hidden == true
            {
                self.backgroundColor = RedCellBackground
            }
            
        }
        else
        {
            
            
        }

    }
    
    func  onGoodQueryButton()
    {
       
    }
    
    func onTextReplyButton()
    {
       
    }

    
    func onDismissButton()
    {
        
        delegate().delegateWithDrawButtonPressed!()
        self.removeFromSuperview()

    }
    
    func onMuteButton()
    {
        
    }
    
}