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
    
    
    optional func delegateGoodQueryButtonPressedWithDetails(queryDetails:AnyObject)
    
    optional func delegateTextReplyButtonPressedWithDetails(queryDetails:AnyObject)
    
    optional func delegateDismissButtonPressedWithDetails(queryDetails:AnyObject)
    
    
}


class QuerySubview: UIView, SSTeacherDataSourceDelegate
{
    var _delgate: AnyObject!
    
    var currentQueryDetails:AnyObject!
    
    var mStudentImage        = UIImageView()
    
    var mStudentName         = UILabel()
    
    var mQueryLabel         = UILabel()
    
    let mDismissButton       = UIButton()
    
    let mTextReplyButton    = UIButton()
    
    let mGoodQueryButton    = UIButton()
    
    let mMuteButtonImage         = UIImageView()
    
    var muteStateString         = "0"
    
    
    var currentReplyDetails :AnyObject!
    
    override init(frame: CGRect)
    {
        
        super.init(frame:frame)
        
        self.backgroundColor = UIColor.whiteColor()
        
        
        
        mStudentImage.frame = CGRectMake(10,10 , 40 ,40)
        self.addSubview(mStudentImage)
        mStudentImage.backgroundColor = UIColor.clearColor()
        mStudentImage.layer.cornerRadius = mStudentImage.frame.size.width/16;
        mStudentImage.layer.masksToBounds = true
        
        mStudentName.frame = CGRectMake(mStudentImage.frame.origin.x + mStudentImage.frame.size.width + 10,mStudentImage.frame.origin.y,400,mStudentImage.frame.size.height / 1.8)
        mStudentName.textAlignment = .Center;
        mStudentName.textColor = blackTextColor
        self.addSubview(mStudentName)
        mStudentName.backgroundColor = UIColor.clearColor()
        mStudentName.textAlignment = .Left;
        mStudentName.font = UIFont(name: helveticaMedium, size: 18)
        
        
        
        mQueryLabel.frame = CGRectMake(mStudentName.frame.origin.x,mStudentImage.frame.origin.y + mStudentImage.frame.size.height  ,self.frame.size.width - mStudentName.frame.origin.x ,mStudentImage.frame.size.height / 2)
        mQueryLabel.textAlignment = .Left;
        mQueryLabel.textColor = blackTextColor
        self.addSubview(mQueryLabel)
        mQueryLabel.backgroundColor = UIColor.clearColor()
        mQueryLabel.font = UIFont(name: helveticaRegular, size: 18)
        mQueryLabel.lineBreakMode = .ByTruncatingMiddle
        mQueryLabel.numberOfLines = 20
        mQueryLabel.contentMode = .Top;
        
        
        mDismissButton.frame = CGRectMake(self.frame.size.width - 70, 0, 70 , 40)
        self.addSubview(mDismissButton)
      
        let dismissImage = UIImageView(frame: CGRectMake((mDismissButton.frame.size.width - 25 ) / 2  , (mDismissButton.frame.size.height - 25 ) / 2, 25, 25))
        dismissImage.image = UIImage(named: "Dismissed.png")
        dismissImage.contentMode = .ScaleAspectFit
        mDismissButton.addSubview(dismissImage)
        mDismissButton.addTarget(self, action: #selector(QuerySubview.onDismissButton), forControlEvents: UIControlEvents.TouchUpInside)
        
        
        let lineImage = UIImageView(frame:CGRectMake(mDismissButton.frame.origin.x, 5, 1, mDismissButton.frame.size.height - 10));
        lineImage.backgroundColor = whiteBackgroundColor
        self.addSubview(lineImage);
        
        
        mTextReplyButton.frame = CGRectMake(lineImage.frame.origin.x - 150, 0, 150 , 40)
        self.addSubview(mTextReplyButton)
        mTextReplyButton.setTitle("Text Reply", forState: .Normal)
        mTextReplyButton.setTitleColor(standard_Button, forState: .Normal)
        mTextReplyButton.addTarget(self, action: #selector(QuerySubview.onTextReplyButton), forControlEvents: UIControlEvents.TouchUpInside)
        
        
        let lineImage2 = UIImageView(frame:CGRectMake(mTextReplyButton.frame.origin.x, 5, 1, mDismissButton.frame.size.height - 10));
        lineImage2.backgroundColor = whiteBackgroundColor
        self.addSubview(lineImage2);
        
        
        
        mGoodQueryButton.frame = CGRectMake(mTextReplyButton.frame.origin.x - 150, 0, 150 , 40)
        self.addSubview(mGoodQueryButton)
        mGoodQueryButton.setTitle("Good query", forState: .Normal)
        mGoodQueryButton.setTitleColor(standard_Button, forState: .Normal)
        mGoodQueryButton.addTarget(self, action: #selector(QuerySubview.onGoodQueryButton), forControlEvents: UIControlEvents.TouchUpInside)
        
        
        
        
        let lineImage3 = UIImageView(frame:CGRectMake(mGoodQueryButton.frame.origin.x, 5, 1, mDismissButton.frame.size.height - 10));
        lineImage3.backgroundColor = whiteBackgroundColor
        self.addSubview(lineImage3);
        
        
       let mMuteButton = UIButton()
        mMuteButton.frame = CGRectMake(mGoodQueryButton.frame.origin.x - 80, 0, 80 , 40)
        self.addSubview(mMuteButton)
        mMuteButton.addTarget(self, action: #selector(QuerySubview.onMuteButton), forControlEvents: UIControlEvents.TouchUpInside)
        
        mMuteButtonImage.frame = CGRectMake((mMuteButton.frame.size.width - 25 ) / 2  , (mMuteButton.frame.size.height - 25 ) / 2, 25, 25)
        mMuteButtonImage.image = UIImage(named: "Mute_gray.png")
        mMuteButtonImage.contentMode = .ScaleAspectFit
        mMuteButton.addSubview(mMuteButtonImage)
        
        
        
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
    
    
    func setQueryWithDetails(details:AnyObject) -> CGFloat
    {
        currentQueryDetails = details
        var getQueryHeight :CGFloat = 80
        
        
        if let queryText = details.objectForKey("QueryText") as? String
        {
            getQueryHeight = heightForView(queryText, font: mQueryLabel.font, width: mQueryLabel.frame.size.width)
            
            mQueryLabel.text = queryText
            mQueryLabel.frame = CGRectMake(mQueryLabel.frame.origin.x ,mQueryLabel.frame.origin.y - 5,mQueryLabel.frame.size.width,getQueryHeight)
            getQueryHeight = getQueryHeight + 60
        }
        
        if getQueryHeight < 80
        {
            getQueryHeight = 80
        }
        
        
       
        
        if let StudentName = currentQueryDetails.objectForKey("StudentName") as? String
        {
            mStudentName.text       = StudentName
        }
        
        
        if let StudentId = currentQueryDetails.objectForKey("StudentId") as? String
        {
            let urlString = NSUserDefaults.standardUserDefaults().objectForKey(k_INI_UserProfileImageURL) as! String
            
            if let checkedUrl = NSURL(string: "\(urlString)/\(StudentId)_79px.jpg")
            {
                mStudentImage.contentMode = .ScaleAspectFit
                mStudentImage.downloadImage(checkedUrl, withFolderType: folderType.ProFilePics)
            }
        }

        
        if let QueryId = details.objectForKey("QueryId") as? String
        {
            currentQueryDetails.setObject(QueryId, forKey: "QueryId")
        }
        
        
        if let StudentId = details.objectForKey("StudentId") as? String
        {
            currentQueryDetails.setObject(StudentId, forKey: "StudentId")
        }
        
        
        currentQueryDetails.setObject("0", forKey: "GoodQuery")
        
        currentQueryDetails.setObject("", forKey: "TeacherReplyText")
        
        currentQueryDetails.setObject("0", forKey: "DismissFlag")
        
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
    
    
    
    func  onGoodQueryButton()
    {
        
        
        mGoodQueryButton.enabled = false
        mGoodQueryButton.setTitleColor(UIColor.lightGrayColor(), forState: .Normal)
        
        currentQueryDetails.setObject("1", forKey: "GoodQuery")
        
        
       SSTeacherDataSource.sharedDataSource.replyToDoubtWithDetails(currentQueryDetails, WithDelegate: self)
        
        
        if delegate().respondsToSelector(#selector(QuerySubviewDelegate.delegateGoodQueryButtonPressedWithDetails(_:)))
        {
            delegate().delegateGoodQueryButtonPressedWithDetails!(currentQueryDetails)
        }
    }
    
    func onTextReplyButton()
    {
        
        mTextReplyButton.enabled = false
        mTextReplyButton.setTitleColor(blackTextColor, forState: .Normal)

        
        if delegate().respondsToSelector(#selector(QuerySubviewDelegate.delegateTextReplyButtonPressedWithDetails(_:)))
        {
            delegate().delegateTextReplyButtonPressedWithDetails!(currentQueryDetails)
        }
    }

    
    func onDismissButton()
    {
        
        currentQueryDetails.setObject("1", forKey: "DismissFlag")
        SSTeacherDataSource.sharedDataSource.replyToDoubtWithDetails(currentQueryDetails, WithDelegate: self)

    }
    
    func onMuteButton()
    {
        if muteStateString == "0"
        {
            muteStateString = "1"
            mMuteButtonImage.image = UIImage(named: "Mute_red.png")
            self.backgroundColor = UIColor.clearColor()
            mGoodQueryButton.hidden = true
            mTextReplyButton.hidden = true
            mDismissButton.hidden = true
            if let StudentId = currentQueryDetails.objectForKey("StudentId") as? String
            {
                SSTeacherMessageHandler.sharedMessageHandler.sendMuteMessageToStudentWithStudentId(StudentId, withStatus: muteStateString)
            }
           
            
        }
        else
        {
            muteStateString = "0"
            mMuteButtonImage.image = UIImage(named: "Mute_gray.png")
            self.backgroundColor = UIColor.whiteColor()
            mGoodQueryButton.hidden = false
            mTextReplyButton.hidden = false
            mDismissButton.hidden = false
            if let StudentId = currentQueryDetails.objectForKey("StudentId") as? String
            {
                SSTeacherMessageHandler.sharedMessageHandler.sendMuteMessageToStudentWithStudentId(StudentId, withStatus: muteStateString)
            }

        }
    }
    
    
    
    func didGetQueryRespondedWithDetails(details: AnyObject)
    {
        
        
        if let StudentId = currentQueryDetails.objectForKey("StudentId") as? String
        {
            if let QueryId = currentQueryDetails.objectForKey("QueryId") as? String
            {
                SSTeacherMessageHandler.sharedMessageHandler.sendQueryFeedbackToStudentWitId(StudentId, withQueryId: QueryId)
                
                
                if let dismissFlag = currentQueryDetails.objectForKey("DismissFlag") as? String
                {
                    if  dismissFlag == "1"
                    {
                            if delegate().respondsToSelector(#selector(QuerySubviewDelegate.delegateDismissButtonPressedWithDetails(_:)))
                            {
                                delegate().delegateDismissButtonPressedWithDetails!(currentQueryDetails)
                            }
                    }
                    

                }
                
            }

        }
        
        

    }
    
}