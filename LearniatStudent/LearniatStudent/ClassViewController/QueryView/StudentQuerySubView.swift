//
//  StudentQuerySubView.swift
//  Learniat_Student_Iphone
//
//  Created by mindshift_Deepak on 11/02/16.
//  Copyright © 2016 mindShiftApps. All rights reserved.
//

import Foundation

@objc protocol StudentQuerySubViewDelegate
{
    
    
   
    optional func delegateQueryWithDrawnwithQueryId(queryId:Int)
    
}



class StudentQuerySubView: UIView {
    var _delgate: AnyObject!
    
    var studentImageView    = UIImageView()
    
    var studentName         = UILabel()
    
    var queryState          = UILabel()
    
    
    var queryText           = UILabel()
    
    var replyStatusImageView : UIImageView!
    
    var mTeacherimage           = UIImageView()
    
    var goodQueryLabel : UIView = UIView()
    
    var teacherReplyText :  UILabel!
    
    var teacherReplyBackGround =   UIImageView()
    
    var replyEvaluated             :Bool = false
    
    var mWithdrawButton           = UIButton()
    
    
    
    
    override init(frame: CGRect) {
        super.init(frame:frame)
        
        addAllSUbQuerySubView()
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
    
    
    
    func addAllSUbQuerySubView()
    {
        
        studentImageView = UIImageView(frame: CGRectMake(10,10, 30,30))
        self.addSubview(studentImageView)
        studentImageView.image = UIImage(named: "Seat.png")
        let urlString = NSUserDefaults.standardUserDefaults().objectForKey(k_INI_UserProfileImageURL) as! String
        
        if let checkedUrl = NSURL(string: "\(urlString)/\(SSStudentDataSource.sharedDataSource.currentUserId)_79px.jpg")
        {
            studentImageView.contentMode = .ScaleAspectFit
            studentImageView.downloadImage(checkedUrl, withFolderType: folderType.ProFilePics)
            studentImageView.layer.cornerRadius = studentImageView.frame.size.width / 2
        }

        
        
        studentName.frame = CGRectMake(50, 10, (self.frame.size.width-50)/2, 30)
        self.addSubview(studentName)
        studentName.numberOfLines = 4
        studentName.lineBreakMode = .ByTruncatingMiddle
        studentName.textAlignment = .Left
        studentName.text = SSStudentDataSource.sharedDataSource.currentUserName.capitalizedString
        studentName.textColor = UIColor(red: 36/255.0, green: 68/255.0, blue: 99/255.0, alpha: 1)
        studentName.font =  UIFont (name: "Roboto-Regular", size: 16)
        
        
        
        queryState.frame = CGRectMake(self.frame.size.width - (self.frame.size.width-50)/2 , 10, (self.frame.size.width-65)/2, 30)
        self.addSubview(queryState)
        queryState.numberOfLines = 4
        queryState.lineBreakMode = .ByTruncatingMiddle
        queryState.textAlignment = .Right
        queryState.text = "Cancelled"
        queryState.textColor = standard_Red
        queryState.font =  UIFont (name: "Roboto-Regular", size: 16)
        queryState.hidden = true 
        
        
        
        mWithdrawButton.frame = CGRectMake(self.frame.size.width - (self.frame.size.width-50)/2 , 10, (self.frame.size.width-65)/2, 30)
        mWithdrawButton.setTitle("WITHDRAW", forState: .Normal)
        self.addSubview(mWithdrawButton)
        mWithdrawButton.addTarget(self, action: #selector(StudentQuerySubView.onWithDrawButton), forControlEvents: UIControlEvents.TouchUpInside)
        mWithdrawButton.setTitleColor(standard_Button, forState: .Normal)
        mWithdrawButton.titleLabel?.font = UIFont (name: "Roboto-Regular", size: 14)
        mWithdrawButton.contentHorizontalAlignment = .Right
        
        
        let lineView = UIImageView(frame: CGRectMake(50, queryState.frame.origin.y + queryState.frame.size.height, (self.frame.size.width-50), 1))
        lineView.backgroundColor = topicsLineColor
        self.addSubview(lineView)
        
        
        
        queryText.frame = CGRectMake(50, lineView.frame.origin.y + lineView.frame.size.height + 5, (self.frame.size.width - 60), 30)
        self.addSubview(queryText)
        queryText.numberOfLines = 4
        queryText.lineBreakMode = .ByTruncatingMiddle
        queryText.textAlignment = .Left
        queryText.textColor = textColor
        queryText.font =  UIFont (name: "Roboto-Regular", size: 16)
        
        
    }
    
    
    
    
    
    func getQueryTextSizeWithText(query:String) -> CGFloat
    {
        queryText.text = query
        var height :CGFloat = 100
        
        height = heightForView(query, font: queryText.font, width: queryText.frame.size.width)
        
        queryText.frame = CGRectMake(queryText.frame.origin.x, queryText.frame.origin.y, queryText.frame.size.width, height)
        
        height = height + 60
        
        return height
        
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

    func addreplyView()
    {
        if replyStatusImageView == nil
        {
            replyStatusImageView = UIImageView(frame: CGRectMake(queryText.frame.origin.x, queryText.frame.size.height + queryText.frame.origin.y + 5, queryText.frame.size.width, 40))
            self.addSubview(replyStatusImageView)
            replyStatusImageView.hidden = true
            
            let lineView2 = UIImageView(frame: CGRectMake(0, 0, (replyStatusImageView.frame.size.width), 1))
            lineView2.backgroundColor = topicsLineColor
            replyStatusImageView.addSubview(lineView2)
            
            
            mTeacherimage = UIImageView(frame: CGRectMake(0,5, 25,25))
            replyStatusImageView.addSubview(mTeacherimage)
            mTeacherimage.image = UIImage(named: "Seat.png")
            let urlString = NSUserDefaults.standardUserDefaults().objectForKey(k_INI_UserProfileImageURL) as! String
            
            if let checkedUrl = NSURL(string: "\(urlString)/\(SSStudentDataSource.sharedDataSource.currentTeacherId)_79px.jpg")
            {
                mTeacherimage.contentMode = .ScaleAspectFit
                mTeacherimage.downloadImage(checkedUrl, withFolderType: folderType.ProFilePics)
                mTeacherimage.layer.cornerRadius = mTeacherimage.frame.size.width / 2
            }
            
            
            
            
            goodQueryLabel.frame = CGRectMake(30 , 5, replyStatusImageView.frame.size.width-30, 25)
            replyStatusImageView.addSubview(goodQueryLabel)
            
            
            let goodLabel = UILabel(frame:  CGRectMake(goodQueryLabel.frame.size.width - 150 ,0, 150, 25))
            goodQueryLabel.addSubview(goodLabel)
            goodLabel.numberOfLines = 4
            goodLabel.lineBreakMode = .ByTruncatingMiddle
            goodLabel.textAlignment = .Center
            goodLabel.text = "GOOD QUESTION"
            goodLabel.textColor = standard_Green
            goodLabel.font =  UIFont (name: "Roboto-Regular", size: 16)
            goodQueryLabel.hidden = true
            
            let goodImage = UIImageView(frame:  CGRectMake(goodLabel.frame.origin.x - 20 , 2.5, 20,20))
            goodImage.image = UIImage(named: "ic_thumb_up_green_48dp.png")
            goodQueryLabel.addSubview(goodImage)
            
            
            
            teacherReplyBackGround = UIImageView(frame: CGRectMake(5, goodQueryLabel.frame.origin.y + goodQueryLabel.frame.size.height + 5, (replyStatusImageView.frame.size.width - 10), 20))
            replyStatusImageView.addSubview(teacherReplyBackGround)
            teacherReplyBackGround.backgroundColor =  UIColor(red: 246/255.0, green: 246/255.0, blue: 246/255.0, alpha: 1)
            teacherReplyBackGround.layer.cornerRadius = 3
            
            teacherReplyText = UILabel()
            teacherReplyText.frame = CGRectMake(5,  5, teacherReplyBackGround .frame.size.width - 10,teacherReplyBackGround .frame.size.height - 10)
            teacherReplyBackGround.addSubview(teacherReplyText)
            teacherReplyText.numberOfLines = 4
            teacherReplyText.lineBreakMode = .ByTruncatingMiddle
            teacherReplyText.textAlignment = .Left
            teacherReplyText.textColor = textColor
            teacherReplyText.font =  UIFont (name: "Roboto-Regular", size: 16)
            teacherReplyBackGround.hidden = true
            
        }
    }
    
    func teacherReplayWithBadgeId(badgeId:String, withText teachertext:String) -> CGFloat
    {
        
        addreplyView()
        
        
        var heightOfTeacherText = heightForView(teachertext, font: teacherReplyText.font, width: teacherReplyText.frame.size.width)
        
        
        if teachertext != "" &&  teachertext != "(null)"
        {
            
            teacherReplyBackGround.frame = CGRectMake(teacherReplyBackGround.frame.origin.x, teacherReplyBackGround.frame.origin.y, teacherReplyBackGround.frame.size.width, heightOfTeacherText + 10)
            
            teacherReplyText.frame = CGRectMake(teacherReplyText.frame.origin.x, teacherReplyText.frame.origin.y, teacherReplyText.frame.size.width, heightOfTeacherText)
           
            teacherReplyBackGround.hidden = false
            
            teacherReplyText.text = teachertext
            
            heightOfTeacherText = heightOfTeacherText + 50
        }
        
        
        if heightOfTeacherText < 40
        {
            heightOfTeacherText = 40
        }
        
        replyStatusImageView.frame = CGRectMake(replyStatusImageView.frame.origin.x, replyStatusImageView.frame.origin.y, replyStatusImageView.frame.size.width, heightOfTeacherText)
        replyStatusImageView.hidden = false
        if badgeId == "1"
        {
            goodQueryLabel.hidden = false
        }
        
        replyEvaluated = true
        
        return (replyStatusImageView.frame.origin.y + replyStatusImageView.frame.size.height)
        
    }
    
    func isQueryEvaluated()->Bool
    {
        
        return replyEvaluated
    }
    
    
    func onWithDrawButton()
    {
        delegate().delegateQueryWithDrawnwithQueryId!(self.tag)
        self.removeFromSuperview()
    }
    
}