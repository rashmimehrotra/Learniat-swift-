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
    
    
   
    @objc optional func delegateQueryWithDrawnwithQueryId(_ queryId:Int)
    
}



class StudentQuerySubView: UIView {
    var _delgate: AnyObject!
    
    var studentImageView    = CustomProgressImageView()
    
    var studentName         = UILabel()
    
    var queryState          = UILabel()
    
    
    var queryText           = UILabel()
    
    var replyStatusImageView : UIImageView!
    
    var mTeacherimage           = CustomProgressImageView()
    
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
    
    func setdelegate(_ delegate:AnyObject)
    {
        _delgate = delegate;
    }
    
    func   delegate()->AnyObject
    {
        return _delgate;
    }
    
    
    
    func addAllSUbQuerySubView()
    {
        
        // By Ujjval
        // ==========================================
        
        let lineView = UIImageView(frame: CGRect(x: 0, y: 0, width: self.frame.size.width, height: 1))
        lineView.backgroundColor = topicsLineColor
        self.addSubview(lineView)
        
        // ==========================================
        
//        studentImageView = CustomProgressImageView(frame: CGRect(x: 10,y: 10, width: 30,height: 30))
        
        // By Ujjval
        // ==========================================
        
        studentImageView = CustomProgressImageView(frame: CGRect(x: 20,y: 10, width: 35,height: 35))
        
        // ==========================================
        
        self.addSubview(studentImageView)
//        studentImageView.image = UIImage(named: "Seat.png")
        
        // By Ujjval
        // ==========================================
        
        studentImageView.image = UIImage(named: "Anonymus.png")
        
        // ==========================================
        
        let urlString = UserDefaults.standard.object(forKey: k_INI_UserProfileImageURL) as! String
        
        let userID = urlString.appending("/").appending(SSStudentDataSource.sharedDataSource.currentUserId)
        
        
        if let checkedUrl = URL(string: "\(userID)_79px.jpg")

        {
            studentImageView.contentMode = .scaleAspectFit
            studentImageView.downloadImage(checkedUrl, withFolderType: folderType.proFilePics)
//            studentImageView.layer.cornerRadius = studentImageView.frame.size.width / 2
            
            // By Ujjval
            // ==========================================
            
            studentImageView.layer.cornerRadius = 5.0
            
            // ==========================================
        }

        
        
//        studentName.frame = CGRect(x: 50, y: 10, width: (self.frame.size.width-50)/2, height: 30)
        
        // By Ujjval
        // ==========================================
        
        studentName.frame = CGRect(x: 65, y: 10, width: (self.frame.size.width-65)/2, height: 35)
        
        // ==========================================
        
        self.addSubview(studentName)
        studentName.numberOfLines = 4
        studentName.lineBreakMode = .byTruncatingMiddle
        studentName.textAlignment = .left
        studentName.text = "as \(SSStudentDataSource.sharedDataSource.currentUserName.capitalized)"
        studentName.textColor = UIColor(red: 36/255.0, green: 68/255.0, blue: 99/255.0, alpha: 1)
//        studentName.font =  UIFont (name: "Roboto-Regular", size: 16)
        
        // By Ujjval
        // ==========================================
        
        studentName.font =  UIFont (name: "Roboto-Medium", size: 18)
        
        // ==========================================
        
        
        
//        queryState.frame = CGRect(x: self.frame.size.width - (self.frame.size.width-50)/2 , y: 10, width: (self.frame.size.width-65)/2, height: 30)
        
        // By Ujjval
        // ==========================================
        
        queryState.frame = CGRect(x: self.frame.size.width - (self.frame.size.width-65)/2 - 20 , y: 10, width: (self.frame.size.width-80)/2, height: 30)
        
        // ==========================================
        
        self.addSubview(queryState)
        queryState.numberOfLines = 4
        queryState.lineBreakMode = .byTruncatingMiddle
        queryState.textAlignment = .right
//        queryState.text = "Cancelled"
        queryState.textColor = standard_Red
        queryState.font =  UIFont (name: "Roboto-Regular", size: 16)
        queryState.isHidden = true
        
        // By Ujjval
        // ==========================================
        
        queryState.text = "Dismissed"
        
        // ==========================================
        
        
        
//        mWithdrawButton.frame = CGRect(x: self.frame.size.width - (self.frame.size.width-50)/2 , y: 10, width: (self.frame.size.width-65)/2, height: 30)
        
        // By Ujjval
        // ==========================================
        
        mWithdrawButton.frame = CGRect(x: self.frame.size.width - (self.frame.size.width-65)/2 , y: 10, width: (self.frame.size.width-80)/2, height: 30)
        
        // ==========================================
        
        mWithdrawButton.setTitle("WITHDRAW", for: UIControlState())
        self.addSubview(mWithdrawButton)
        mWithdrawButton.addTarget(self, action: #selector(StudentQuerySubView.onWithDrawButton), for: UIControlEvents.touchUpInside)
        mWithdrawButton.setTitleColor(standard_Button, for: UIControlState())
        mWithdrawButton.titleLabel?.font = UIFont (name: "Roboto-Regular", size: 14)
        mWithdrawButton.contentHorizontalAlignment = .right
        
        
//        
//        let lineView = UIImageView(frame: CGRect(x: 50, y: queryState.frame.origin.y + queryState.frame.size.height, width: (self.frame.size.width-50), height: 1))
//        lineView.backgroundColor = topicsLineColor
//        self.addSubview(lineView)
//        
        
        
//        queryText.frame = CGRect(x: 50, y: lineView.frame.origin.y + lineView.frame.size.height + 5, width: (self.frame.size.width - 60), height: 30)
        
        // By Ujjval
        // ==========================================
        
        queryText.frame = CGRect(x: 65, y: queryState.frame.origin.y + queryState.frame.size.height + 6, width: (self.frame.size.width - 75), height: 30)
        
        // ==========================================
        
        self.addSubview(queryText)
        queryText.numberOfLines = 4
        queryText.lineBreakMode = .byTruncatingMiddle
        queryText.textAlignment = .left
        queryText.textColor = textColor
        queryText.font =  UIFont (name: "Roboto-Regular", size: 16)
        
        
        // By Ujjval
        // ==========================================
        
        goodQueryLabel.frame = CGRect(x: self.frame.size.width - 170 ,y: 10, width: 150, height: 25)
        self.addSubview(goodQueryLabel)
        
        
        let goodLabel = UILabel(frame:  CGRect(x: 25 ,y: 0, width: 125, height: 25))
        goodQueryLabel.addSubview(goodLabel)
        goodLabel.numberOfLines = 4
        goodLabel.lineBreakMode = .byTruncatingMiddle
        goodLabel.textAlignment = .center
        goodLabel.text = "Good Question"
        goodLabel.textColor = blackTextColor
        goodLabel.font =  UIFont(name: "Roboto-Regular", size: 16)
        goodQueryLabel.isHidden = true
        
        let goodImage = UIImageView(frame:  CGRect(x: 0 , y: 2.5, width: 20,height: 20))
        goodImage.image = UIImage(named: "ic_thumb_up_green_48dp.png")
        goodQueryLabel.addSubview(goodImage)
        
        // ==========================================
        
    }
    
    
    
    
    
    func getQueryTextSizeWithText(_ query:String) -> CGFloat
    {
        queryText.text = query
        var height :CGFloat = 100
        
        height = heightForView(query, font: queryText.font, width: queryText.frame.size.width)
        
        queryText.frame = CGRect(x: queryText.frame.origin.x, y: queryText.frame.origin.y, width: queryText.frame.size.width, height: height)
        
        height = height + 60
        
        return height
        
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

    func addreplyView()
    {
        if replyStatusImageView == nil
        {
            replyStatusImageView = UIImageView(frame: CGRect(x: queryText.frame.origin.x, y: queryText.frame.size.height + queryText.frame.origin.y + 5, width: queryText.frame.size.width, height: 40))
            self.addSubview(replyStatusImageView)
            replyStatusImageView.isHidden = true
            
//            let lineView2 = UIImageView(frame: CGRect(x: 0, y: 0, width: (replyStatusImageView.frame.size.width), height: 1))
//            lineView2.backgroundColor = topicsLineColor
//            replyStatusImageView.addSubview(lineView2)
            
            
//            mTeacherimage = CustomProgressImageView(frame: CGRect(x: 0,y: 5, width: 25,height: 25))
            
            // By Ujjval
            // ==========================================
            
            mTeacherimage = CustomProgressImageView(frame: CGRect(x: 0,y: 5, width: 35,height: 35))
            
            // ==========================================
            
            replyStatusImageView.addSubview(mTeacherimage)
//            mTeacherimage.image = UIImage(named: "Seat.png")
            
            // By Ujjval
            // ==========================================
            
            mTeacherimage.image = UIImage(named: "Anonymus.png")
            
            // ==========================================
            
            let urlString = UserDefaults.standard.object(forKey: k_INI_UserProfileImageURL) as! String
            
            let userID = urlString.appending("/").appending(SSStudentDataSource.sharedDataSource.currentTeacherId)
            
            
            if let checkedUrl = URL(string: "\(userID)_79px.jpg")

            {
                mTeacherimage.contentMode = .scaleAspectFit
                mTeacherimage.downloadImage(checkedUrl, withFolderType: folderType.proFilePics)
//                mTeacherimage.layer.cornerRadius = mTeacherimage.frame.size.width / 2
                
                // By Ujjval
                // ==========================================
                
                mTeacherimage.layer.cornerRadius = 5.0
                
                // ==========================================
            }
            
            
            
            
//            goodQueryLabel.frame = CGRect(x: 30 , y: 5, width: replyStatusImageView.frame.size.width-30, height: 25)
//            replyStatusImageView.addSubview(goodQueryLabel)
//            
//            
//            let goodLabel = UILabel(frame:  CGRect(x: goodQueryLabel.frame.size.width - 150 ,y: 0, width: 150, height: 25))
//            goodQueryLabel.addSubview(goodLabel)
//            goodLabel.numberOfLines = 4
//            goodLabel.lineBreakMode = .byTruncatingMiddle
//            goodLabel.textAlignment = .center
//            goodLabel.text = "GOOD QUESTION"
//            goodLabel.textColor = standard_Green
//            goodLabel.font =  UIFont (name: "Roboto-Regular", size: 16)
//            goodQueryLabel.isHidden = true
//            
//            let goodImage = UIImageView(frame:  CGRect(x: goodLabel.frame.origin.x - 20 , y: 2.5, width: 20,height: 20))
//            goodImage.image = UIImage(named: "ic_thumb_up_green_48dp.png")
//            goodQueryLabel.addSubview(goodImage)
            
            
            
//            teacherReplyBackGround = UIImageView(frame: CGRect(x: 5, y: goodQueryLabel.frame.origin.y + goodQueryLabel.frame.size.height + 5, width: (replyStatusImageView.frame.size.width - 10), height: 20))
            
            // By Ujjval
            // ==========================================
            
            teacherReplyBackGround = UIImageView(frame: CGRect(x: 50, y: 5, width: (replyStatusImageView.frame.size.width - 50), height: 20))
            
            // ==========================================
            
            replyStatusImageView.addSubview(teacherReplyBackGround)
//            teacherReplyBackGround.backgroundColor =  UIColor(red: 246/255.0, green: 246/255.0, blue: 246/255.0, alpha: 1)
//            teacherReplyBackGround.layer.cornerRadius = 3
            
            // By Ujjval
            // ==========================================
            
            teacherReplyBackGround.backgroundColor =  UIColor.white
            teacherReplyBackGround.layer.cornerRadius = 5
            
            // ==========================================
            
            
            teacherReplyText = UILabel()
            teacherReplyText.frame = CGRect(x: 15,  y: 5, width: teacherReplyBackGround .frame.size.width - 30,height: teacherReplyBackGround .frame.size.height - 10)
            teacherReplyBackGround.addSubview(teacherReplyText)
            teacherReplyText.numberOfLines = 4
            teacherReplyText.lineBreakMode = .byTruncatingMiddle
            teacherReplyText.textAlignment = .left
            teacherReplyText.textColor = textColor
//            teacherReplyText.font =  UIFont (name: "Roboto-Regular", size: 16)
            teacherReplyBackGround.isHidden = true
            
            // By Ujjval
            // ==========================================
            
            teacherReplyText.font =  UIFont (name: "Roboto-Italic", size: 16)
            
            // ==========================================
            
        }
    }
    
    func teacherReplayWithBadgeId(_ badgeId:String, withText teachertext:String) -> CGFloat
    {
        
        addreplyView()
        
        
        var heightOfTeacherText = heightForView(teachertext, font: teacherReplyText.font, width: teacherReplyText.frame.size.width)
        
        // By Ujjval
        // Same height as student pic if single line text
        // ==========================================
        
        if heightOfTeacherText < 25
        {
            heightOfTeacherText = 25
        }
        
        // ==========================================
        
        if teachertext != "" &&  teachertext != "(null)"
        {
            
//            teacherReplyBackGround.frame = CGRect(x: teacherReplyBackGround.frame.origin.x, y: teacherReplyBackGround.frame.origin.y, width: teacherReplyBackGround.frame.size.width, height: heightOfTeacherText + 10)
            
//            teacherReplyText.frame = CGRect(x: teacherReplyText.frame.origin.x, y: teacherReplyText.frame.origin.y, width: teacherReplyText.frame.size.width, height: heightOfTeacherText)
            
            teacherReplyBackGround.isHidden = false
            
            teacherReplyText.text = teachertext
            
            // By Ujjval
            // Set white background view height
            // ==========================================
            
            teacherReplyText.sizeToFit()
            teacherReplyBackGround.frame = CGRect(x: teacherReplyBackGround.frame.origin.x, y: teacherReplyBackGround.frame.origin.y, width: teacherReplyBackGround.frame.size.width, height: teacherReplyText.frame.size.height + 20)
            teacherReplyText.frame = CGRect(x: 15, y: 5, width: teacherReplyBackGround.frame.size.width - 30, height: teacherReplyBackGround.frame.size.height - 10)
            
            // ==========================================
            
            heightOfTeacherText = heightOfTeacherText + 50
        }
        
        
        if heightOfTeacherText < 40
        {
            heightOfTeacherText = 40
        }
        
        replyStatusImageView.frame = CGRect(x: replyStatusImageView.frame.origin.x, y: replyStatusImageView.frame.origin.y, width: replyStatusImageView.frame.size.width, height: heightOfTeacherText)
        replyStatusImageView.isHidden = false
        if badgeId == "1"
        {
            goodQueryLabel.isHidden = false
        }
        
        replyEvaluated = true
        
        return (replyStatusImageView.frame.origin.y + replyStatusImageView.frame.size.height)
        
    }
    
    func isQueryEvaluated()->Bool
    {
        
        return replyEvaluated
    }
    
    
    @objc func onWithDrawButton()
    {
        delegate().delegateQueryWithDrawnwithQueryId!(self.tag)
        self.removeFromSuperview()
    }
    
}
