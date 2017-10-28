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
    
    
    @objc optional func delegateWithDrawButtonPressed()
    
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
        
        self.backgroundColor = UIColor.white
        
        
        
        mStudentImage.frame = CGRect(x: 10,y: 10 , width: 40 ,height: 40)
        self.addSubview(mStudentImage)
        mStudentImage.backgroundColor = UIColor.clear
        
        if let StudentId = SSStudentDataSource.sharedDataSource.currentUserId
        {
            let urlString = UserDefaults.standard.object(forKey: k_INI_UserProfileImageURL) as! String
            
            if let checkedUrl = URL(string: "\(urlString)/\(StudentId)_79px.jpg")
            {
                mStudentImage.contentMode = .scaleAspectFit
                mStudentImage.downloadImage(checkedUrl, withFolderType: folderType.proFilePics)
            }
        }
        
        mStudentImage.layer.cornerRadius = mStudentImage.frame.size.width/16;
        mStudentImage.layer.masksToBounds = true
        
        
        
        
        
        mStudentName.frame = CGRect(x: mStudentImage.frame.origin.x + mStudentImage.frame.size.width + 10,y: mStudentImage.frame.origin.y,width: 400,height: mStudentImage.frame.size.height / 1.8)
        mStudentName.textAlignment = .center;
        mStudentName.textColor = blackTextColor
        self.addSubview(mStudentName)
        mStudentName.backgroundColor = UIColor.clear
        mStudentName.textAlignment = .left;
        mStudentName.font = UIFont(name: helveticaMedium, size: 18)
        mStudentName.text = SSStudentDataSource.sharedDataSource.currentUserName.capitalized
        
        
        mQueryLabel.frame = CGRect(x: mStudentName.frame.origin.x,y: mStudentImage.frame.origin.y + mStudentImage.frame.size.height  ,width: self.frame.size.width - mStudentName.frame.origin.x ,height: mStudentImage.frame.size.height / 2)
        mQueryLabel.textAlignment = .left;
        mQueryLabel.textColor = blackTextColor
        self.addSubview(mQueryLabel)
        mQueryLabel.backgroundColor = UIColor.clear
        mQueryLabel.font = UIFont(name: helveticaRegular, size: 18)
        mQueryLabel.lineBreakMode = .byTruncatingMiddle
        mQueryLabel.numberOfLines = 20
        mQueryLabel.contentMode = .top;
        
        
        mWithDrawButton.frame = CGRect(x: self.frame.size.width - 150, y: 0, width: 140 , height: 40)
        self.addSubview(mWithDrawButton)
        mWithDrawButton.addTarget(self, action: #selector(QuerySubview.onDismissButton), for: UIControlEvents.touchUpInside)
         mWithDrawButton.setTitleColor(standard_Button, for: UIControlState())
         mWithDrawButton.setTitle("Withdraw", for: UIControlState())
        mWithDrawButton.contentHorizontalAlignment = UIControlContentHorizontalAlignment.right
        
        
        
        goodQueryLabel = UILabel(frame:  CGRect(x: self.frame.size.width - 130 ,y: mStudentName.frame.origin.y, width: 120,height: mStudentName.frame.size.height))
        self.addSubview(goodQueryLabel)
        goodQueryLabel.lineBreakMode = .byTruncatingMiddle
        goodQueryLabel.textAlignment = .right
        goodQueryLabel.text = "GOOD QUERY"
        goodQueryLabel.textColor = blackTextColor
        goodQueryLabel.font =  UIFont (name: helveticaMedium, size: 16)
        goodQueryLabel.isHidden = true
        
        goodImage = UIImageView(frame:  CGRect(x: goodQueryLabel.frame.origin.x - 25 , y: mStudentName.frame.origin.y, width: 25,height: 25))
        goodImage.image = UIImage(named:"Thumbs_Up.png")
        self.addSubview(goodImage)
        goodImage.isHidden = true

        
        
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
    
    
    func setQueryWithDetails(_ queryText:String, withQueryId QueryId:String) -> CGFloat
    {
        var getQueryHeight :CGFloat = 80
        
        
        getQueryHeight = heightForView(queryText, font: mQueryLabel.font, width: mQueryLabel.frame.size.width)
        
        mQueryLabel.text = queryText
        mQueryLabel.frame = CGRect(x: mQueryLabel.frame.origin.x ,y: mQueryLabel.frame.origin.y - 5,width: mQueryLabel.frame.size.width,height: getQueryHeight)
        getQueryHeight = getQueryHeight + 60
        
        if getQueryHeight < 80
        {
            getQueryHeight = 80
        }
        
        currentQueryID = QueryId;
        
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
    
    func setQueryReplyWithDetiails(_ details:AnyObject)
    {
        var teacherTextReply = ""
        
        if  let _teacherTextReply =  ( details.object(forKey: "TeacherReplyText") as? String)
        {
            teacherTextReply = _teacherTextReply
        }
        if teacherTextReply.isEmpty
        {
            teacherTextReply = ""
        }
        
        
        
        
        if let badgeId = details.object(forKey: "BadgeId") as? String
        {
            if badgeId == "1"
            {
               goodQueryLabel.isHidden = false
                 goodImage.isHidden = false
            }
            else
            {
                goodQueryLabel.isHidden = true
                 goodImage.isHidden = true
            }
        }
        else
        {
            goodQueryLabel.isHidden = true
        }
        
        
        let dismissFlag = ( details.object(forKey: "DismissFlag") as! String)
        
        
        
        
        
        if dismissFlag == "1"
        {
            if goodQueryLabel.isHidden == true
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

    
    @objc func onDismissButton()
    {
        
        delegate().delegateWithDrawButtonPressed!()
        self.removeFromSuperview()

    }
    
    func onMuteButton()
    {
        
    }
    
}
