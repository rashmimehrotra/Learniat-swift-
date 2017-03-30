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
    
    
    @objc optional func delegateGoodQueryButtonPressedWithDetails(_ queryDetails:AnyObject)
    
    @objc optional func delegateTextReplyButtonPressedWithDetails(_ queryDetails:AnyObject, withButton textButton:UIButton)
    
    @objc optional func delegateDismissButtonPressedWithDetails(_ queryDetails:AnyObject)
    
    
}


class QuerySubview: UIView, SSTeacherDataSourceDelegate
{
    var _delgate: AnyObject!
    
    var currentQueryDetails = NSMutableDictionary()
    
    var mStudentImage        = CustomProgressImageView()
    
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
        
        self.backgroundColor = UIColor.white
        
        
        
        mStudentImage.frame = CGRect(x: 10,y: 10 , width: 40 ,height: 40)
        self.addSubview(mStudentImage)
        mStudentImage.backgroundColor = UIColor.clear
        mStudentImage.layer.cornerRadius = mStudentImage.frame.size.width/16;
        mStudentImage.layer.masksToBounds = true
        
        mStudentName.frame = CGRect(x: mStudentImage.frame.origin.x + mStudentImage.frame.size.width + 10,y: mStudentImage.frame.origin.y,width: 400,height: mStudentImage.frame.size.height / 1.8)
        mStudentName.textAlignment = .center;
        mStudentName.textColor = blackTextColor
        self.addSubview(mStudentName)
        mStudentName.backgroundColor = UIColor.clear
        mStudentName.textAlignment = .left;
        mStudentName.font = UIFont(name: helveticaMedium, size: 18)
        
        
        
        mQueryLabel.frame = CGRect(x: mStudentName.frame.origin.x,y: mStudentImage.frame.origin.y + mStudentImage.frame.size.height  ,width: self.frame.size.width - mStudentName.frame.origin.x ,height: mStudentImage.frame.size.height / 2)
        mQueryLabel.textAlignment = .left;
        mQueryLabel.textColor = blackTextColor
        self.addSubview(mQueryLabel)
        mQueryLabel.backgroundColor = UIColor.clear
        mQueryLabel.font = UIFont(name: helveticaRegular, size: 18)
        mQueryLabel.lineBreakMode = .byTruncatingMiddle
        mQueryLabel.numberOfLines = 20
        mQueryLabel.contentMode = .top;
        
        
        mDismissButton.frame = CGRect(x: self.frame.size.width - 70, y: 0, width: 70 , height: 40)
        self.addSubview(mDismissButton)
      
        let dismissImage = UIImageView(frame: CGRect(x: (mDismissButton.frame.size.width - 25 ) / 2  , y: (mDismissButton.frame.size.height - 25 ) / 2, width: 25, height: 25))
        dismissImage.image = UIImage(named: "Dismissed.png")
        dismissImage.contentMode = .scaleAspectFit
        mDismissButton.addSubview(dismissImage)
        mDismissButton.addTarget(self, action: #selector(QuerySubview.onDismissButton), for: UIControlEvents.touchUpInside)
        
        
        let lineImage = UIImageView(frame:CGRect(x: mDismissButton.frame.origin.x, y: 5, width: 1, height: mDismissButton.frame.size.height - 10));
        lineImage.backgroundColor = whiteBackgroundColor
        self.addSubview(lineImage);
        
        
        mTextReplyButton.frame = CGRect(x: lineImage.frame.origin.x - 150, y: 0, width: 150 , height: 40)
        self.addSubview(mTextReplyButton)
        mTextReplyButton.setTitle("Text Reply", for: UIControlState())
        mTextReplyButton.setTitleColor(standard_Button, for: UIControlState())
        mTextReplyButton.addTarget(self, action: #selector(QuerySubview.onTextReplyButton), for: UIControlEvents.touchUpInside)
        
        
        let lineImage2 = UIImageView(frame:CGRect(x: mTextReplyButton.frame.origin.x, y: 5, width: 1, height: mDismissButton.frame.size.height - 10));
        lineImage2.backgroundColor = whiteBackgroundColor
        self.addSubview(lineImage2);
        
        
        
        mGoodQueryButton.frame = CGRect(x: mTextReplyButton.frame.origin.x - 150, y: 0, width: 150 , height: 40)
        self.addSubview(mGoodQueryButton)
        mGoodQueryButton.setTitle("Good Question", for: UIControlState())
        mGoodQueryButton.setTitleColor(standard_Button, for: UIControlState())
        mGoodQueryButton.addTarget(self, action: #selector(QuerySubview.onGoodQueryButton), for: UIControlEvents.touchUpInside)
        
        
        
        
        let lineImage3 = UIImageView(frame:CGRect(x: mGoodQueryButton.frame.origin.x, y: 5, width: 1, height: mDismissButton.frame.size.height - 10));
        lineImage3.backgroundColor = whiteBackgroundColor
        self.addSubview(lineImage3);
        
        
       let mMuteButton = UIButton()
        mMuteButton.frame = CGRect(x: mGoodQueryButton.frame.origin.x - 80, y: 0, width: 80 , height: 40)
        self.addSubview(mMuteButton)
        mMuteButton.addTarget(self, action: #selector(QuerySubview.onMuteButton), for: UIControlEvents.touchUpInside)
        
        mMuteButtonImage.frame = CGRect(x: (mMuteButton.frame.size.width - 25 ) / 2  , y: (mMuteButton.frame.size.height - 25 ) / 2, width: 25, height: 25)
        mMuteButtonImage.image = UIImage(named: "Mute_gray.png")
        mMuteButtonImage.contentMode = .scaleAspectFit
        mMuteButton.addSubview(mMuteButtonImage)
        
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
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
    
    
    func setQueryWithDetails(_ details:AnyObject) -> CGFloat
    {
        currentQueryDetails = details as! NSMutableDictionary
        var getQueryHeight :CGFloat = 80
        
        
        if let queryText = details.object(forKey: "QueryText") as? String
        {
            getQueryHeight = heightForView(queryText, font: mQueryLabel.font, width: mQueryLabel.frame.size.width)
            
            mQueryLabel.text = queryText
            mQueryLabel.frame = CGRect(x: mQueryLabel.frame.origin.x ,y: mQueryLabel.frame.origin.y - 5,width: mQueryLabel.frame.size.width,height: getQueryHeight)
            getQueryHeight = getQueryHeight + 60
        }
        
        if getQueryHeight < 80
        {
            getQueryHeight = 80
        }
        
        
       
        
        if let StudentName = currentQueryDetails.object(forKey: "StudentName") as? String
        {
            mStudentName.text       = StudentName
        }
        
        
        if let StudentId = currentQueryDetails.object(forKey: "StudentId") as? String
        {
            let urlString = UserDefaults.standard.object(forKey: k_INI_UserProfileImageURL) as! String
            
            if let checkedUrl = URL(string: "\(urlString)/\(StudentId)_79px.jpg")
            {
                mStudentImage.contentMode = .scaleAspectFit
                mStudentImage.downloadImage(checkedUrl, withFolderType: folderType.proFilePics)
            }
        }

        
        if let QueryId = details.object(forKey: "QueryId") as? String
        {
            currentQueryDetails.setObject(QueryId, forKey: "QueryId" as NSCopying)
        }
        
        
        if let StudentId = details.object(forKey: "StudentId") as? String
        {
            currentQueryDetails.setObject(StudentId, forKey: "StudentId" as NSCopying)
        }
        
        
        currentQueryDetails.setObject("0", forKey: "GoodQuery" as NSCopying)
        
        currentQueryDetails.setObject("", forKey: "TeacherReplyText" as NSCopying)
        
        currentQueryDetails.setObject("0", forKey: "DismissFlag" as NSCopying)
        
        return getQueryHeight
        
    }
    
    

    
    
    func heightForView(_ text:String, font:UIFont, width:CGFloat) -> CGFloat
    {
        let label:UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: width, height: CGFloat.greatestFiniteMagnitude))
        label.numberOfLines = 0
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.font = font
        label.text = text
        
        label.sizeToFit()
        return label.frame.height
    }
    
    
    
    func  onGoodQueryButton()
    {
        
        
        mGoodQueryButton.isEnabled = false
        mGoodQueryButton.setTitleColor(UIColor.lightGray, for: UIControlState())
        
        currentQueryDetails.setObject("1", forKey: "GoodQuery" as NSCopying)
        
        
       SSTeacherDataSource.sharedDataSource.replyToDoubtWithDetails(currentQueryDetails, WithDelegate: self)
        
        
        if delegate().responds(to: #selector(QuerySubviewDelegate.delegateGoodQueryButtonPressedWithDetails(_:)))
        {
            delegate().delegateGoodQueryButtonPressedWithDetails!(currentQueryDetails)
        }
    }
    
    func onTextReplyButton()
    {
        
        
        if delegate().responds(to: #selector(QuerySubviewDelegate.delegateTextReplyButtonPressedWithDetails(_:withButton:)))
        {
            delegate().delegateTextReplyButtonPressedWithDetails!(currentQueryDetails, withButton: mTextReplyButton)
        }
    }

    
    func textReplySentWithText(_ text:String)
    {
        mTextReplyButton.isEnabled = false
        mTextReplyButton.setTitleColor(lightGrayColor, for: UIControlState())
        currentQueryDetails.setObject(text, forKey: "TeacherReplyText" as NSCopying)
        SSTeacherDataSource.sharedDataSource.replyToDoubtWithDetails(currentQueryDetails, WithDelegate: self)
        

    }
    
    func onDismissButton()
    {
        
        currentQueryDetails.setObject("1", forKey: "DismissFlag" as NSCopying)
        SSTeacherDataSource.sharedDataSource.replyToDoubtWithDetails(currentQueryDetails, WithDelegate: self)

    }
    
    func onMuteButton()
    {
        if muteStateString == "0"
        {
            muteStateString = "1"
            mMuteButtonImage.image = UIImage(named: "Mute_red.png")
            self.backgroundColor = UIColor.clear
            mGoodQueryButton.isHidden = true
            mTextReplyButton.isHidden = true
            mDismissButton.isHidden = true
            if let StudentId = currentQueryDetails.object(forKey: "StudentId") as? String
            {
                SSTeacherMessageHandler.sharedMessageHandler.sendMuteMessageToStudentWithStudentId(StudentId, withStatus: muteStateString)
            }
           
            
        }
        else
        {
            muteStateString = "0"
            mMuteButtonImage.image = UIImage(named: "Mute_gray.png")
            self.backgroundColor = UIColor.white
            mGoodQueryButton.isHidden = false
            mTextReplyButton.isHidden = false
            mDismissButton.isHidden = false
            if let StudentId = currentQueryDetails.object(forKey: "StudentId") as? String
            {
                SSTeacherMessageHandler.sharedMessageHandler.sendMuteMessageToStudentWithStudentId(StudentId, withStatus: muteStateString)
            }

        }
    }
    
    
    
    func didGetQueryRespondedWithDetails(_ details: AnyObject)
    {
        
        
        if let StudentId = currentQueryDetails.object(forKey: "StudentId") as? String
        {
            if let QueryId = currentQueryDetails.object(forKey: "QueryId") as? String
            {
                SSTeacherMessageHandler.sharedMessageHandler.sendQueryFeedbackToStudentWitId(StudentId, withQueryId: QueryId)
                
                
                if let dismissFlag = currentQueryDetails.object(forKey: "DismissFlag") as? String
                {
                    if  dismissFlag == "1"
                    {
                            if delegate().responds(to: #selector(QuerySubviewDelegate.delegateDismissButtonPressedWithDetails(_:)))
                            {
                                delegate().delegateDismissButtonPressedWithDetails!(currentQueryDetails)
                            }
                    }
                    

                }
                
            }

        }
        
        

    }
    
}
