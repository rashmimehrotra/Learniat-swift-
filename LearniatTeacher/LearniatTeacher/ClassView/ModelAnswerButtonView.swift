//
//  ModelAnswerButtonView.swift
//  LearniatTeacher
//
//  Created by Deepak MK on 04/05/16.
//  Copyright © 2016 Mindshift. All rights reserved.
//

import Foundation
class ModelAnswerButtonView: UIButton
{
    
    var modelAnswerCountLabel = UILabel()
    
    
    var modelAnswerLabel        = UILabel()
    
    var mShareButton            = UIButton()
    
    override init(frame: CGRect)
    {
        super.init(frame: frame)
        
        
        modelAnswerCountLabel.frame = CGRectMake(10, 10, self.frame.size.height - 20, self.frame.size.height - 20)
        self.addSubview(modelAnswerCountLabel)
        modelAnswerCountLabel.layer.cornerRadius = modelAnswerCountLabel.frame.size.width / 2
        modelAnswerCountLabel.layer.masksToBounds = true
        modelAnswerCountLabel.backgroundColor = whiteColor
        modelAnswerCountLabel.textColor = standard_Green
        modelAnswerCountLabel.font = UIFont(name: helveticaMedium, size: 20);
        modelAnswerCountLabel.text = "0"
        modelAnswerCountLabel.textAlignment = .Center
        
        modelAnswerLabel.frame = CGRectMake((self.frame.size.width - 150)/2,0 ,150 ,self.frame.size.height)
        modelAnswerLabel.text = "Model answer selected"
        modelAnswerLabel.font = UIFont(name: helveticaMedium, size: 14);
        modelAnswerLabel.textAlignment = .Center;
        modelAnswerLabel.textColor = whiteColor
        self.addSubview(modelAnswerLabel);
        

        mShareButton.frame = CGRectMake(self.frame.size.width  -   self.frame.size.height  , 0, self.frame.size.height ,self.frame.size.height )
        mShareButton.backgroundColor = UIColor.clearColor()
        self.addSubview(mShareButton)
//        mShareButton.addTarget(self, action: #selector(StudentModelAnswerView.onSendAllButton), forControlEvents: UIControlEvents.TouchUpInside)
        
        let shareImage = UIImageView(frame:CGRectMake(10, 10, mShareButton.frame.size.width - 20 , mShareButton.frame.size.height - 20 ))
        shareImage.image = UIImage(named:"Share.png")
        mShareButton.addSubview(shareImage)
        shareImage.contentMode = .ScaleAspectFit
        
        

    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    
    
    
    func setModelAnswerCount(count:Int)
    {
        modelAnswerCountLabel.text = "\(count)"
    }
    
    
}