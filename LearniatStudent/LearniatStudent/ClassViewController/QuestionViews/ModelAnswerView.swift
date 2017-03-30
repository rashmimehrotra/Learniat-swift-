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
        
        
        modelAnswerLabel.frame = CGRect(x: 5, y: 0, width: self.frame.size.width - 10 , height: 35)
        modelAnswerLabel.textColor = UIColor.white
        self.addSubview(modelAnswerLabel)
        modelAnswerLabel.lineBreakMode = NSLineBreakMode.byTruncatingTail;
        modelAnswerLabel.font = UIFont(name: "Roboto-Regular", size: 12)
        modelAnswerLabel.numberOfLines = 4
        modelAnswerLabel.textAlignment = .center
        
        
        containerView.frame = CGRect(x: 5,y: 35, width: 90,height: 60)
        self.addSubview(containerView)
        containerView.backgroundColor = UIColor.white
        
        
        
        
        
        
        
        
       
        
    }
    
    
    required init?(coder aDecoder: NSCoder)
    {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func setScribbleImageName(_ scribbleName:String , withOverlayImage overlay:UIImage)
    {
        
        
        let overlayImage = UIImageView(frame:containerView.frame)
        self.addSubview(overlayImage)
        overlayImage.contentMode = .scaleAspectFit
        overlayImage.image = overlay
        
        
        
        let urlString = UserDefaults.standard.object(forKey: k_INI_SCRIBBLE_IMAGE_URL) as! String
        
        if let checkedUrl = URL(string: "\(urlString)/\(scribbleName)")
        {
            let teacherImage = CustomProgressImageView(frame:containerView.frame)
            self.addSubview(teacherImage)
            teacherImage.contentMode = .scaleAspectFit
            teacherImage.downloadImage(checkedUrl, withFolderType: folderType.studentAnswer, withResizeValue: teacherImage.frame.size)
        }
    }
    
    func setTextAnswerText(_ textAnswer:String)
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
        testAnswerLable.text = textAnswer
    }
    
    
    
}
