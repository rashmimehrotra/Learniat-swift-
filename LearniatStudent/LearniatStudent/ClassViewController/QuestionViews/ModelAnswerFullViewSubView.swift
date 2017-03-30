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
    
    var studentImageView    = CustomProgressImageView()
    
    var studentName         = UILabel()
    
    let containerView       = UIView()
    
    override init(frame: CGRect)
    {
        super.init(frame: frame)
        
        studentImageView = CustomProgressImageView(frame: CGRect(x: 10,y: 10, width: 40,height: 40))
        self.addSubview(studentImageView)
        studentImageView.image = UIImage(named: "Seat.png")
      
        
        
        
        studentName.frame = CGRect(x: 60, y: 10, width: (self.frame.size.width-60), height: 40)
        self.addSubview(studentName)
        studentName.numberOfLines = 4
        studentName.lineBreakMode = .byTruncatingMiddle
        studentName.textAlignment = .left
        studentName.text = ""
        studentName.textColor = UIColor(red: 36/255.0, green: 68/255.0, blue: 99/255.0, alpha: 1)
        studentName.font =  UIFont (name: "Roboto-Regular", size: 16)
        

        let remainingHeight = self.frame.size.height - (60)
        
        
        containerView.frame = CGRect(x: (self.frame.size.width - (remainingHeight * 1.5))/2, y: 60, width: remainingHeight * 1.5 ,height: remainingHeight)
        self.addSubview(containerView)
        containerView.backgroundColor = UIColor.white
        
        
        

     
        
    }
    
    
    func setModelAnswerDetails(_ details:AnyObject , withOverlay overlaya:UIImage)
    {
        
        if details.object(forKey: "StudentId") != nil
        {
            if let StudentId = details.object(forKey: "StudentId") as? String
            {
               
                let urlString = UserDefaults.standard.object(forKey: k_INI_UserProfileImageURL) as! String
                
                if let checkedUrl = URL(string: "\(urlString)/\(StudentId)_79px.jpg")
                {
                    studentImageView.contentMode = .scaleAspectFit
                    studentImageView.downloadImage(checkedUrl, withFolderType: folderType.proFilePics)
                    studentImageView.layer.cornerRadius = 5
                }
            }
        }
        
        
        let overlayImageImage = UIImageView(frame:containerView.frame)
        self.addSubview(overlayImageImage)
        overlayImageImage.contentMode = .scaleAspectFit
        overlayImageImage.image = overlaya
        
        
        
        if let _StudentName = details.object(forKey: "StudentName") as? String
        {
            studentName.text = _StudentName.capitalized
        }
        
        
        
        if details.object(forKey: "Image") != nil
        {
            if let scribbleName = details.object(forKey: "Image") as? String
            {
                let urlString = UserDefaults.standard.object(forKey: k_INI_SCRIBBLE_IMAGE_URL) as! String
                
                if let checkedUrl = URL(string: "\(urlString)/\(scribbleName)")
                {
                    let answerImage = CustomProgressImageView(frame:containerView.frame)
                    self.addSubview(answerImage)
                    answerImage.contentMode = .scaleAspectFit
                    answerImage.downloadImage(checkedUrl, withFolderType: folderType.studentAnswer, withResizeValue: answerImage.frame.size)
                }
            }
            else
            {
                if let TextAnswer = details.object(forKey: "TextAnswer") as? String
                {
                    let testAnswerLable = UILabel()
                    testAnswerLable.frame = containerView.frame
                    testAnswerLable.textColor = textColor
                    self.addSubview(testAnswerLable)
                    testAnswerLable.lineBreakMode = NSLineBreakMode.byTruncatingTail;
                    testAnswerLable.font = UIFont(name: "Roboto-Regular", size: 16)
                    testAnswerLable.numberOfLines = 10
                    testAnswerLable.backgroundColor = UIColor.white
                    containerView.bringSubview(toFront: testAnswerLable)
                    testAnswerLable.textAlignment = .center
                    testAnswerLable.text = TextAnswer
                }
            }
        }
        
        else
        {
            if let TextAnswer = details.object(forKey: "TextAnswer") as? String
            {
                let testAnswerLable = UILabel()
                testAnswerLable.frame = containerView.frame
                testAnswerLable.textColor = textColor
                self.addSubview(testAnswerLable)
                testAnswerLable.lineBreakMode = NSLineBreakMode.byTruncatingTail;
                testAnswerLable.font = UIFont(name: "Roboto-Regular", size: 12)
                testAnswerLable.numberOfLines = 10
                testAnswerLable.backgroundColor = UIColor.white
                containerView.bringSubview(toFront: testAnswerLable)
                testAnswerLable.textAlignment = .center
                testAnswerLable.text = TextAnswer
            }
        }
        
        
        
        
       
        
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
}
