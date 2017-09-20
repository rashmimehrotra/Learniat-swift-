//
//  CollaborationElementCell.swift
//  LearniatTeacher
//
//  Created by Deepak MK on 22/03/17.
//  Copyright © 2017 Mindshift. All rights reserved.
//

import UIKit

class CollaborationElementCell: UIView
{
    
    var studentImage    = CustomProgressImageView()
    
    var StudentName     = DynamicFontSize()
    
    var mSuggestiontext = DynamicFontSize()
    
    var mCorrectButton  = UIButton()
    
    var mWrongButton    = UIButton()
    
    var mIgnoreButton   = UIButton()
    
    var mCurrentSelectedState    = collaborationState.ignored
    
    var mSuggestionDetails :AnyObject!
    
    override init(frame: CGRect)
    {
        super.init(frame:frame)
        
        self.backgroundColor = UIColor.white
        studentImage.frame = CGRect(x: 5, y: 5, width: 40, height: 40)
        self.addSubview(studentImage)
        
        
        StudentName.frame = CGRect(x: 50, y: 5, width: 70, height: 40)
        //        StudentName.backgroundColor = UIColor.greenColor()
        StudentName.isHidden = false
        StudentName.textAlignment = .center;
        StudentName.numberOfLines=10;
        StudentName.lineBreakMode = .byTruncatingMiddle
        StudentName.textColor = standard_TextGrey
        self.addSubview(StudentName)
        
        
        mSuggestiontext = DynamicFontSize(frame: CGRect(x: StudentName.frame.origin.x + StudentName.frame.size.width + 5, y: 5,width: 100, height: 40))
        mSuggestiontext.font = UIFont(name:helveticaMedium, size: 18)
        self.addSubview(mSuggestiontext)
        mSuggestiontext.textColor = blackTextColor
        mSuggestiontext.textAlignment = .left
        mSuggestiontext.lineBreakMode = .byTruncatingMiddle
        
        
        
        
        mWrongButton.frame = CGRect(x: mSuggestiontext.frame.origin.x + mSuggestiontext.frame.size.width + 5, y: 5, width: 40, height: 40)
        mWrongButton.setImage(UIImage(named: "wrongMatch.png"), for: UIControlState())
        self.addSubview(mWrongButton)
        mWrongButton.addTarget(self, action: #selector(CollaborationSuggestionCell.onWrongButtonPressed), for: UIControlEvents.touchUpInside)
        
        mCorrectButton.frame = CGRect(x: mWrongButton.frame.origin.x + mWrongButton.frame.size.width + 5, y: 5, width: 40, height: 40)
        mCorrectButton.setImage(UIImage(named: "correctMatch.png"), for: UIControlState())
        //        mCorrectButton.imageView?.contentMode = .ScaleAspectFit
        self.addSubview(mCorrectButton)
        mCorrectButton.addTarget(self, action: #selector(CollaborationSuggestionCell.onCorrectButtonPressed), for: UIControlEvents.touchUpInside)
        
        
        
        
        mIgnoreButton.frame = CGRect(x:mWrongButton.frame.origin.x + mWrongButton.frame.size.width + 5, y: 5, width: 40, height: 40)
        mIgnoreButton.setImage(UIImage(named: "IgnoreCollaboration.png"), for: UIControlState())
        //        mCorrectButton.imageView?.contentMode = .ScaleAspectFit
        self.addSubview(mIgnoreButton)
        mIgnoreButton.isHidden = true
        mIgnoreButton.addTarget(self, action: #selector(CollaborationSuggestionCell.onIgnoreButtonPressed), for: UIControlEvents.touchUpInside)
        
        
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    func SetSuggestionDetails(_ details:AnyObject)->(width:CGFloat, height:CGFloat)
    {
        
        let ContainerSizeheight:CGFloat = 50
        
        mSuggestionDetails = details
        if let StudentId = details.object(forKey: "studentID") as? String
        {
            let urlString = UserDefaults.standard.object(forKey: k_INI_UserProfileImageURL) as! String
            
            if let checkedUrl = URL(string: "\(urlString)/\(StudentId)_79px.jpg")
            {
                studentImage.contentMode = .scaleAspectFit
                studentImage.downloadImage(checkedUrl, withFolderType: folderType.proFilePics)
            }
        }
        
        studentImage.backgroundColor = standard_Button_Disabled
        studentImage.layer.cornerRadius = 4
        studentImage.contentMode = .scaleAspectFit
        
        studentImage.layer.masksToBounds = true
        
        if let _StudentName = details.object(forKey: "StudentName") as? String
        {
            StudentName.text = "\(_StudentName):"
        }
        
        StudentName.text = "DB:"
        
        
        if let mSuggestion = details.object(forKey: "ElementText") as? String
        {
            mSuggestiontext.text = mSuggestion
            
        }
        
        onCorrectButtonPressed()
        
        return (320,ContainerSizeheight)
        
    }
    
    
    func onCorrectButtonPressed()
    {
        mCorrectButton.isHidden = true
        mWrongButton.isHidden = true
        mIgnoreButton.isHidden = false
        self.backgroundColor = UIColor(red: 76/255.0, green:217/255.0, blue:100/255.0, alpha: 0.3)
        mCurrentSelectedState    = collaborationState.selected
    }
    
    
    func onWrongButtonPressed()
    {
        
        mCorrectButton.isHidden = true
        mWrongButton.isHidden = true
        mIgnoreButton.isHidden = false
        self.backgroundColor = UIColor(red: 255/255.0, green:59/255.0, blue:48/255.0, alpha: 0.3)
        mCurrentSelectedState    = collaborationState.rejected
    }
    
    func onIgnoreButtonPressed()
    {
        
        mCorrectButton.isHidden = false
        mWrongButton.isHidden = false
        mIgnoreButton.isHidden = true
        self.backgroundColor = UIColor.white
        mCurrentSelectedState    = collaborationState.ignored
    }
    
    
    
}
