//
//  ModelAnswerFullViewSubView.swift
//  LearniatStudent
//
//  Created by Deepak MK on 27/05/16.
//  Copyright © 2016 Mindshift. All rights reserved.
//

import Foundation
class ModelAnswerFullViewSubView: UIView
{
    
    var studentImageView    = UIImageView()
    
    var studentName         = UILabel()
    
    let containerView       = UIView()
    
    override init(frame: CGRect)
    {
        super.init(frame: frame)
        
        studentImageView = UIImageView(frame: CGRectMake(10,10, 40,40))
        self.addSubview(studentImageView)
        studentImageView.image = UIImage(named: "Seat.png")
      
        
        
        
        studentName.frame = CGRectMake(60, 10, (self.frame.size.width-60), 40)
        self.addSubview(studentName)
        studentName.numberOfLines = 4
        studentName.lineBreakMode = .ByTruncatingMiddle
        studentName.textAlignment = .Left
        studentName.text = ""
        studentName.textColor = UIColor(red: 36/255.0, green: 68/255.0, blue: 99/255.0, alpha: 1)
        studentName.font =  UIFont (name: "Roboto-Regular", size: 16)
        

        let remainingHeight = self.frame.size.height - (60)
        
        
        containerView.frame = CGRectMake((self.frame.size.width - (remainingHeight * 1.5))/2, 60, remainingHeight * 1.5 ,remainingHeight)
        self.addSubview(containerView)
        containerView.backgroundColor = UIColor.whiteColor()
        
        
        

     
        
    }
    
    
    func setModelAnswerDetails(details:AnyObject , withOverlay overlaya:UIImage)
    {
        
        if details.objectForKey("StudentId") != nil
        {
            if let StudentId = details.objectForKey("StudentId") as? String
            {
               
                let urlString = NSUserDefaults.standardUserDefaults().objectForKey(k_INI_UserProfileImageURL) as! String
                
                if let checkedUrl = NSURL(string: "\(urlString)/\(StudentId)_79px.jpg")
                {
                    studentImageView.contentMode = .ScaleAspectFit
                    studentImageView.downloadImage(checkedUrl, withFolderType: folderType.ProFilePics)
                    studentImageView.layer.cornerRadius = 5
                }
            }
        }
        
        
        let overlayImageImage = UIImageView(frame:containerView.frame)
        self.addSubview(overlayImageImage)
        overlayImageImage.contentMode = .ScaleAspectFit
        overlayImageImage.image = overlaya
        
        
        
        if let _StudentName = details.objectForKey("StudentName") as? String
        {
            studentName.text = _StudentName.capitalizedString
        }
        
        
        
        if details.objectForKey("Image") != nil
        {
            if let scribbleName = details.objectForKey("Image") as? String
            {
                let urlString = NSUserDefaults.standardUserDefaults().objectForKey(k_INI_SCRIBBLE_IMAGE_URL) as! String
                
                if let checkedUrl = NSURL(string: "\(urlString)/\(scribbleName)")
                {
                    let answerImage = UIImageView(frame:containerView.frame)
                    self.addSubview(answerImage)
                    answerImage.contentMode = .ScaleAspectFit
                    answerImage.downloadImage(checkedUrl, withFolderType: folderType.StudentAnswer, withResizeValue: answerImage.frame.size)
                }
            }
            else
            {
                if let TextAnswer = details.objectForKey("TextAnswer") as? String
                {
                    let testAnswerLable = UILabel()
                    testAnswerLable.frame = containerView.frame
                    testAnswerLable.textColor = textColor
                    self.addSubview(testAnswerLable)
                    testAnswerLable.lineBreakMode = NSLineBreakMode.ByTruncatingTail;
                    testAnswerLable.font = UIFont(name: "Roboto-Regular", size: 16)
                    testAnswerLable.numberOfLines = 10
                    testAnswerLable.backgroundColor = UIColor.whiteColor()
                    containerView.bringSubviewToFront(testAnswerLable)
                    testAnswerLable.textAlignment = .Center
                    testAnswerLable.text = TextAnswer
                }
            }
        }
        
        else
        {
            if let TextAnswer = details.objectForKey("TextAnswer") as? String
            {
                let testAnswerLable = UILabel()
                testAnswerLable.frame = containerView.frame
                testAnswerLable.textColor = textColor
                self.addSubview(testAnswerLable)
                testAnswerLable.lineBreakMode = NSLineBreakMode.ByTruncatingTail;
                testAnswerLable.font = UIFont(name: "Roboto-Regular", size: 12)
                testAnswerLable.numberOfLines = 10
                testAnswerLable.backgroundColor = UIColor.whiteColor()
                containerView.bringSubviewToFront(testAnswerLable)
                testAnswerLable.textAlignment = .Center
                testAnswerLable.text = TextAnswer
            }
        }
        
        
        
        
       
        
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
}