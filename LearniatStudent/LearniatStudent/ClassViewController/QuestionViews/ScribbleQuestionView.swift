//
//  ScribbleQuestionView.swift
//  LearniatStudent
//
//  Created by Deepak MK on 16/05/16.
//  Copyright © 2016 Mindshift. All rights reserved.
//

import Foundation
class ScribbleQuestionView: UIView
{
   
    var currentQuestionDetails:AnyObject!
    
    var mTopbarImageView = UIImageView()
    
    var mQuestionLabel = UILabel()
    
    var mSendButton = UIButton()
    
    var mDontKnow = UIButton()

    var sessionDetails:AnyObject!
    
    var questionLogId = ""
    
    
    var mReplyStatusLabelView           = UILabel()
    
    
    var mContainerView = CustomProgressImageView()

    
    override init(frame: CGRect)
    {
        super.init(frame: frame)
        
        
        self.backgroundColor = whiteBackgroundColor
        
        
        mTopbarImageView = UIImageView(frame: CGRectMake(0, 0, self.frame.size.width, 60))
        mTopbarImageView.backgroundColor = lightGrayTopBar
        self.addSubview(mTopbarImageView)
        mTopbarImageView.userInteractionEnabled = true
        mTopbarImageView.userInteractionEnabled = true
        
        
        mSendButton.frame = CGRectMake(mTopbarImageView.frame.size.width - 210, 0,200,mTopbarImageView.frame.size.height )
        mTopbarImageView.addSubview(mSendButton)
        mSendButton.addTarget(self, action: #selector(MultipleChoiceView.onSendButton), forControlEvents: UIControlEvents.TouchUpInside)
        mSendButton.setTitle("Send", forState: .Normal)
        mSendButton.contentHorizontalAlignment = UIControlContentHorizontalAlignment.Right
        mSendButton.titleLabel?.font = UIFont (name: helveticaMedium, size: 20)
        mSendButton.setTitleColor(UIColor.lightGrayColor(), forState: .Normal)
        mSendButton.enabled = false
        
        mDontKnow.frame = CGRectMake(10, 0,200,mTopbarImageView.frame.size.height )
        mTopbarImageView.addSubview(mDontKnow)
        mDontKnow.addTarget(self, action: #selector(MultipleChoiceView.onDontKnowButton), forControlEvents: UIControlEvents.TouchUpInside)
        mDontKnow.setTitle("Don't know", forState: .Normal)
        mDontKnow.contentHorizontalAlignment = UIControlContentHorizontalAlignment.Left
        mDontKnow.setTitleColor(standard_Button, forState: .Normal)
        mDontKnow.titleLabel?.font = UIFont (name: helveticaMedium, size: 20)
        
        mQuestionLabel.frame = CGRectMake(10, mTopbarImageView.frame.size.height + mTopbarImageView.frame.origin.y, self.frame.size.width-20, 80)
        mQuestionLabel.numberOfLines = 20;
        mQuestionLabel.textAlignment = .Center
        self.addSubview(mQuestionLabel)
        mQuestionLabel.textColor = topbarColor
        mQuestionLabel.font = UIFont (name: helveticaRegular, size: 20)
        mQuestionLabel.lineBreakMode = .ByTruncatingMiddle
        self.addSubview(mReplyStatusLabelView)
        mReplyStatusLabelView.textColor = UIColor.whiteColor()
        mReplyStatusLabelView.backgroundColor = dark_Yellow
        mReplyStatusLabelView.font = UIFont (name: helveticaBold, size: 16)
        mReplyStatusLabelView.textAlignment = .Center
        
        
        
        
        var remainingHeight = self.frame.size.height  - (mQuestionLabel.frame.size.height + mQuestionLabel.frame.origin.y)
        
        remainingHeight = remainingHeight / 1.2
        
        
        mContainerView.frame = CGRectMake((self.frame.size.width - (remainingHeight * 1.5))/2 ,mQuestionLabel.frame.size.height + mQuestionLabel.frame.origin.y , remainingHeight * 1.5 , remainingHeight)
        self.addSubview(mContainerView)
        mContainerView.backgroundColor = UIColor.clearColor()
        
        
        
        
        
        
        

        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func setQuestionDetails(details:AnyObject, withsessionDetails _sessionDetails:AnyObject, withQuestionLogId _logId:String)
    {
        currentQuestionDetails = details
        questionLogId = _logId
        sessionDetails = _sessionDetails
        
//        currentQuestionType = (details.objectForKey(kQuestionType) as? String)
        
        
        if (details.objectForKey(kQuestionName) as? String) != ""
        {
            mQuestionLabel.text = (details.objectForKey(kQuestionName) as? String)
        }
        
        
        
        
        if (details.objectForKey("Scribble") != nil)
        {
        
            
            if let Scribble = details.objectForKey("Scribble") as? String
            {
                let urlString = NSUserDefaults.standardUserDefaults().objectForKey(k_INI_UserProfileImageURL) as! String
                
                if let checkedUrl = NSURL(string: "\(urlString)/\(Scribble).png")
                {
                    mContainerView.contentMode = .ScaleAspectFit
                    mContainerView.downloadImage(checkedUrl, withFolderType: folderType.questionImage)
                }
            }
        }
       
        

        
        print(details)
        

    }
    
    
    
}