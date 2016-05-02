//
//  PollCompletedView.swift
//  LearniatTeacher
//
//  Created by Deepak MK on 28/04/16.
//  Copyright © 2016 Mindshift. All rights reserved.
//

import Foundation
class PollCompletedView: UIView
{
    var _delgate: AnyObject!
    
    var questionNamelabel = UILabel()
    
    
    func setdelegate(delegate:AnyObject)
    {
        _delgate = delegate;
    }
    
    func   delegate()->AnyObject
    {
        return _delgate;
    }
    
    override init(frame: CGRect)
    {
        
        super.init(frame:frame)
        
        
        self.backgroundColor = UIColor.whiteColor()
        let mResendButton  = UIButton(frame :CGRectMake(10, 0, 100, 30))
        mResendButton.setTitle("Resend", forState: .Normal)
        mResendButton.setTitleColor(standard_Green, forState: .Normal)
        self.addSubview(mResendButton);
        mResendButton.imageView?.contentMode = .ScaleAspectFit
        mResendButton.contentHorizontalAlignment = UIControlContentHorizontalAlignment.Left
        mResendButton.addTarget(self, action: #selector(PollingGraphView.onStopButton), forControlEvents: UIControlEvents.TouchUpInside)
        
        
        
        let mFullScreenButton  = UIButton(frame :CGRectMake(self.frame.size.width - 105, 0, 100, 30))
        mFullScreenButton.setTitle("Full screen", forState: .Normal)
        mFullScreenButton.setTitleColor(standard_Button, forState: .Normal)
        self.addSubview(mFullScreenButton);
        mFullScreenButton.imageView?.contentMode = .ScaleAspectFit
        mFullScreenButton.addTarget(self, action: #selector(PollingGraphView.onStopButton), forControlEvents: UIControlEvents.TouchUpInside)
        mFullScreenButton.contentHorizontalAlignment = UIControlContentHorizontalAlignment.Right
        
        
        
        
        let lineView = UIImageView(frame:CGRectMake(0, mFullScreenButton.frame.size.height + 5 , self.frame.size.width, 2))
        lineView.backgroundColor = lightGrayTopBar
        self.addSubview(lineView)
        
        
        questionNamelabel.frame =  CGRectMake(40,lineView.frame.origin.y + lineView.frame.size.height ,self.frame.size.width - 80 ,30)
        self.addSubview(questionNamelabel)
        questionNamelabel.font = UIFont (name: helveticaRegular, size: 18)
        questionNamelabel.textColor = blackTextColor
        questionNamelabel.textAlignment = .Center
        
        
    }
    
    
    func setGraphDetailsWithQuestionName(questioName:String)
    {
        questionNamelabel.text = questioName
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    
    
    
}