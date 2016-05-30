//
//  ModelAnswerView.swift
//  Learniat_Student_Iphone
//
//  Created by Deepak MK on 29/02/16.
//  Copyright © 2016 mindShiftApps. All rights reserved.
//

import Foundation
class ModelAnswerView: UIView
{
    
    let modelAnswerLabel = UILabel()
    
   
    
    let containerView = UILabel()
    
    
    
    override init(frame: CGRect) {
        
        super.init(frame:frame)
        
        
        modelAnswerLabel.frame = CGRectMake(5, 0, self.frame.size.width - 10 , 35)
        modelAnswerLabel.textColor = UIColor.whiteColor()
        self.addSubview(modelAnswerLabel)
        modelAnswerLabel.lineBreakMode = NSLineBreakMode.ByTruncatingTail;
        modelAnswerLabel.font = UIFont(name: "Roboto-Regular", size: 12)
        modelAnswerLabel.numberOfLines = 4
        modelAnswerLabel.textAlignment = .Center
        
        
        containerView.frame = CGRectMake(5,35, 90,60)
        self.addSubview(containerView)
        containerView.backgroundColor = UIColor.whiteColor()
        
        
        
        
        
        
        
        
       
        
    }
    
    
    required init?(coder aDecoder: NSCoder)
    {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func setScribbleImageName(scribbleName:String , withOverlayImage overlay:UIImage)
    {
        
        
        let overlayImage = UIImageView(frame:containerView.frame)
        self.addSubview(overlayImage)
        overlayImage.contentMode = .ScaleAspectFit
        overlayImage.image = overlay
        
        
        
        let urlString = NSUserDefaults.standardUserDefaults().objectForKey(k_INI_SCRIBBLE_IMAGE_URL) as! String
        
        if let checkedUrl = NSURL(string: "\(urlString)/\(scribbleName)")
        {
            let teacherImage = UIImageView(frame:containerView.frame)
            self.addSubview(teacherImage)
            teacherImage.contentMode = .ScaleAspectFit
            teacherImage.downloadImage(checkedUrl, withFolderType: folderType.StudentAnswer, withResizeValue: teacherImage.frame.size)
        }
    }
    
    func setTextAnswerText(textAnswer:String)
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
        testAnswerLable.text = textAnswer
    }
    
    
    
}