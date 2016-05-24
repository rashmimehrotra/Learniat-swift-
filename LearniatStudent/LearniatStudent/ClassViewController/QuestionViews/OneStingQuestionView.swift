//
//  OneStingQuestionView.swift
//  LearniatStudent
//
//  Created by Deepak MK on 24/05/16.
//  Copyright © 2016 Mindshift. All rights reserved.
//

import Foundation
class OneStingQuestionView: UIView,SSStudentDataSourceDelegate
{
    
    var mTopbarImageView    = UIImageView()
    
    var mQuestionLabel      = UILabel()
    
    var mSendButton         = UIButton()
    
    var mDontKnow           = UIButton()
    
    var mReplyStatusLabel   = UILabel()
    
    var questionLogId       = ""
    
    var currentQuestionDetails  :AnyObject!
    
    var currentQuestionType     :String!
    
    var sessionDetails          :AnyObject!
    
    
    var mAnswerTextView         : CustomTextView!
    
    
    var sendButtonSpinner : UIActivityIndicatorView!
    
    var mContainerView = UIView()
    
    var mAnswerLabel        = UILabel()

    
    var _delgate: AnyObject!
    
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
        super.init(frame: frame)
        
        
        mTopbarImageView = UIImageView(frame: CGRectMake(0, 0, self.frame.size.width, 60))
        mTopbarImageView.backgroundColor = lightGrayTopBar
        self.addSubview(mTopbarImageView)
        mTopbarImageView.userInteractionEnabled = true
        
        
        mSendButton.frame = CGRectMake(mTopbarImageView.frame.size.width - 210, 0,200,mTopbarImageView.frame.size.height )
        mTopbarImageView.addSubview(mSendButton)
        mSendButton.addTarget(self, action: #selector(OneStingQuestionView.onSendButton), forControlEvents: UIControlEvents.TouchUpInside)
        mSendButton.setTitle("Send", forState: .Normal)
        mSendButton.contentHorizontalAlignment = UIControlContentHorizontalAlignment.Right
        mSendButton.titleLabel?.font = UIFont (name: helveticaMedium, size: 20)
        mSendButton.setTitleColor(UIColor.lightGrayColor(), forState: .Normal)
        mSendButton.enabled = false
        
        
        sendButtonSpinner = UIActivityIndicatorView(activityIndicatorStyle:.WhiteLarge);
        sendButtonSpinner.frame = mSendButton.frame;
        mTopbarImageView.addSubview(sendButtonSpinner);
        sendButtonSpinner.hidden = true;
        
        
        
        
        mDontKnow.frame = CGRectMake(10, 0,200,mTopbarImageView.frame.size.height )
        mTopbarImageView.addSubview(mDontKnow)
        mDontKnow.addTarget(self, action: #selector(OneStingQuestionView.onDontKnowButton), forControlEvents: UIControlEvents.TouchUpInside)
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
        
        
        var remainingHeight = self.frame.size.height  - (mQuestionLabel.frame.size.height + mQuestionLabel.frame.origin.y)
        
        remainingHeight = remainingHeight / 1.2
        
        
        
        mContainerView.frame = CGRectMake((self.frame.size.width - (remainingHeight * 1.5))/2 ,mQuestionLabel.frame.size.height + mQuestionLabel.frame.origin.y , remainingHeight * 1.5 ,50)
        self.addSubview(mContainerView)
        mContainerView.backgroundColor = UIColor.whiteColor()
        mContainerView.layer.shadowColor = progressviewBackground.CGColor;
        mContainerView.layer.shadowOffset = CGSizeMake(0,0);
        mContainerView.layer.shadowOpacity = 1;
        mContainerView.layer.shadowRadius = 1.0;
        mContainerView.clipsToBounds = false;
        mContainerView.layer.borderColor = topicsLineColor.CGColor
        mContainerView.layer.borderWidth = 1
        mContainerView.hidden = true
        
        
        mAnswerLabel.frame = CGRectMake(5,5,mContainerView.frame.size.width - 10 , mContainerView.frame.size.height - 10)
        mContainerView.addSubview(mAnswerLabel)
        mAnswerLabel.font = UIFont (name: helveticaRegular, size: 18)
        mAnswerLabel.numberOfLines = 100
        mAnswerLabel.lineBreakMode = .ByWordWrapping
        mAnswerLabel.textColor = topbarColor
        
        mAnswerTextView = CustomTextView(frame:CGRectMake((self.frame.size.width - (remainingHeight * 1.5))/2 ,mQuestionLabel.frame.size.height + mQuestionLabel.frame.origin.y , remainingHeight * 1.5 , 160))
        self.addSubview(mAnswerTextView)
        mAnswerTextView.setdelegate(self)
        mAnswerTextView.setPlaceHolder("Write your answer", withStartSting: "answer")
        
        
        
        self.addSubview(mReplyStatusLabel)
        mReplyStatusLabel.textColor = UIColor.whiteColor()
        mReplyStatusLabel.backgroundColor = dark_Yellow
        mReplyStatusLabel.font = UIFont (name: helveticaBold, size: 16)
        mReplyStatusLabel.textAlignment = .Center
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setQuestionDetails(details:AnyObject, withsessionDetails _sessionDetails:AnyObject, withQuestionLogId _logId:String)
    {
        currentQuestionDetails = details
        questionLogId = _logId
        sessionDetails = _sessionDetails
        
        currentQuestionType = (details.objectForKey(kQuestionType) as? String)
        
        
        if (details.objectForKey(kQuestionName) as? String) != ""
        {
            mQuestionLabel.text = (details.objectForKey(kQuestionName) as? String)
        }
    }
    
    
    func onSendButton()
    {
        if  mAnswerTextView.getTextOfCurrentTextView() != ""
        {
//            sendButtonSpinner.hidden = false
//            sendButtonSpinner.startAnimating()
//          
//            mReplyStatusLabel.frame = CGRectMake((self.frame.size.width - (mTopbarImageView.frame.size.height * 2)) / 2, 0, mTopbarImageView.frame.size.height * 2, mTopbarImageView.frame.size.height / 1.5)
//            
//            mReplyStatusLabel.hidden = false
//            
//            mReplyStatusLabel.text = "Reply sent"
//            
//            mTopbarImageView.hidden = true
//            mAnswerTextView.hidden = true
            mAnswerLabel.text =  mAnswerTextView.getTextOfCurrentTextView().removeWhitespace()
            
            
            SSStudentMessageHandler.sharedMessageHandler.sendOneStringAnswerWithAnswer(mAnswerTextView.getTextOfCurrentTextView())
//            mAnswerTextView.hidden = true
//            mContainerView.hidden = false
            
           
            
        }
        
        
    }
    
    func onDontKnowButton()
    {
        SSStudentMessageHandler.sharedMessageHandler.sendDontKnowMessageToTeacher()
        
        mReplyStatusLabel.frame = CGRectMake((self.frame.size.width - (mTopbarImageView.frame.size.height * 2)) / 2, 0, mTopbarImageView.frame.size.height * 2, mTopbarImageView.frame.size.height / 1.5)
        mReplyStatusLabel.hidden = false
        mReplyStatusLabel.text = "Don't Know"
        mTopbarImageView.hidden = true
        mAnswerTextView.hidden = true
        mAnswerLabel.text =  mAnswerTextView.getTextOfCurrentTextView().removeWhitespace()
        
        SSStudentDataSource.sharedDataSource.answerSent = true
    }
    func FreezMessageFromTeacher()
    {
        if SSStudentDataSource.sharedDataSource.answerSent == false
        {
            onSendButton()
            
        }
    }
    
    func getPeakViewMessageFromTeacher()
    {
        
        if  mAnswerTextView.getTextOfCurrentTextView() != ""
        {
            SSStudentMessageHandler.sharedMessageHandler.sendPeakViewMessageToTeacherWithImageData(mAnswerTextView.getTextOfCurrentTextView())
        }
        
        
        
        
        
    }
    
    func delegateTextViewTextChanged(chnagedText:String)
    {
        if chnagedText != ""
        {
            mSendButton.enabled = true
            mSendButton.setTitleColor(standard_Button, forState: .Normal)
            
            
        }
        else
        {
            mSendButton.enabled = false
            mSendButton.setTitleColor(lightGrayColor, forState: .Normal)
            
            
        }
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
    
}