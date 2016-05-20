//
//  ScribbleQuestionView.swift
//  LearniatStudent
//
//  Created by Deepak MK on 16/05/16.
//  Copyright © 2016 Mindshift. All rights reserved.
//

import Foundation


@objc protocol ScribbleQuestionViewDelegate
{
    
    optional func delegateEditButtonPressedWithOverlayImage(overlay:UIImage)
    
    
}



class ScribbleQuestionView: UIView,SSStudentDataSourceDelegate,ImageUploadingDelegate
{
   
    var currentQuestionDetails:AnyObject!
    
    var mTopbarImageView = UIImageView()
    
    var mQuestionLabel = UILabel()
    
    var mSendButton = UIButton()
    
    var mDontKnow = UIButton()

    var sessionDetails:AnyObject!
    
    var questionLogId = ""
    
    let imageUploading = ImageUploading()
    
    var currentQuestionType :String!
    
    var mReplyStatusLabelView           = UILabel()
    
    
    var mContainerView = UIView()
    
    var mOverlayImageView        = CustomProgressImageView()
    
    
    var mAnswerImage            = UIImageView()
    
    var mEditButton         = UIButton()
    
    var mWithDrawButton     = UIButton()

    var sendButtonSpinner : UIActivityIndicatorView!
    
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
        
        
        self.backgroundColor = whiteBackgroundColor
        
        imageUploading.setDelegate(self)
        
        mTopbarImageView = UIImageView(frame: CGRectMake(0, 0, self.frame.size.width, 60))
        mTopbarImageView.backgroundColor = lightGrayTopBar
        self.addSubview(mTopbarImageView)
        mTopbarImageView.userInteractionEnabled = true
        mTopbarImageView.userInteractionEnabled = true
        
        
        mSendButton.frame = CGRectMake(mTopbarImageView.frame.size.width - 210, 0,200,mTopbarImageView.frame.size.height )
        mTopbarImageView.addSubview(mSendButton)
        mSendButton.addTarget(self, action: #selector(ScribbleQuestionView.onSendButton), forControlEvents: UIControlEvents.TouchUpInside)
        mSendButton.setTitle("Send", forState: .Normal)
        mSendButton.contentHorizontalAlignment = UIControlContentHorizontalAlignment.Right
        mSendButton.titleLabel?.font = UIFont (name: helveticaMedium, size: 20)
        mSendButton.setTitleColor(standard_Button, forState: .Normal)
        
        
        
        sendButtonSpinner = UIActivityIndicatorView(activityIndicatorStyle:.WhiteLarge);
        sendButtonSpinner.frame = mSendButton.frame;
        mTopbarImageView.addSubview(sendButtonSpinner);
        sendButtonSpinner.hidden = true;
        
        
        
        mDontKnow.frame = CGRectMake(10, 0,200,mTopbarImageView.frame.size.height )
        mTopbarImageView.addSubview(mDontKnow)
        mDontKnow.addTarget(self, action: #selector(ScribbleQuestionView.onDontKnowButton), forControlEvents: UIControlEvents.TouchUpInside)
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
        mContainerView.backgroundColor = UIColor.whiteColor()
        mContainerView.layer.shadowColor = progressviewBackground.CGColor;
        mContainerView.layer.shadowOffset = CGSizeMake(0,0);
        mContainerView.layer.shadowOpacity = 1;
        mContainerView.layer.shadowRadius = 1.0;
        mContainerView.clipsToBounds = false;
        mContainerView.layer.borderColor = topicsLineColor.CGColor
        mContainerView.layer.borderWidth = 1
        
        mEditButton.frame = CGRectMake(mContainerView.frame.origin.x, mContainerView.frame.size.height + mContainerView.frame.origin.y, mContainerView.frame.size.width, 40)
        self.addSubview(mEditButton)
        mEditButton.setTitle("Edit", forState: .Normal)
        mEditButton.setTitleColor(standard_Button, forState: .Normal)
         mEditButton.addTarget(self, action: #selector(ScribbleQuestionView.onEditButton), forControlEvents: UIControlEvents.TouchUpInside)
        mEditButton.layer.borderColor = topicsLineColor.CGColor
        mEditButton.layer.borderWidth = 1
        mEditButton.backgroundColor = whiteColor
        
        
        
        mWithDrawButton.frame = CGRectMake(mContainerView.frame.origin.x, mContainerView.frame.size.height + mContainerView.frame.origin.y, mContainerView.frame.size.width, 40)
        self.addSubview(mWithDrawButton)
        mWithDrawButton.setTitle("Withdraw", forState: .Normal)
        mWithDrawButton.setTitleColor(standard_Button, forState: .Normal)
        mWithDrawButton.addTarget(self, action: #selector(ScribbleQuestionView.onEditButton), forControlEvents: UIControlEvents.TouchUpInside)
        mWithDrawButton.layer.borderColor = topicsLineColor.CGColor
        mWithDrawButton.layer.borderWidth = 1
        mWithDrawButton.backgroundColor = whiteColor
        mWithDrawButton.hidden = true

        
        
        
        mOverlayImageView.frame = CGRectMake(0 ,0 , mContainerView.frame.size.width ,mContainerView.frame.size.height)
        mContainerView.addSubview(mOverlayImageView)
        
        
        mAnswerImage.frame = CGRectMake(0 ,0 , mContainerView.frame.size.width ,mContainerView.frame.size.height)
        mContainerView.addSubview(mAnswerImage)
        
        
        

        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func onEditButton()
    {
        
        delegate().delegateEditButtonPressedWithOverlayImage!(mOverlayImageView.image!)
    }
    
    func onSendButton()
    {
        if mAnswerImage.image != nil
        {
            let currentDate = NSDate()
            
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = "yyyy-mm-dd HH:mm:ss"
            
            sendButtonSpinner.hidden = false
            sendButtonSpinner.startAnimating()
            mSendButton.hidden = true
            mEditButton.hidden = true
            mWithDrawButton.hidden = false
            
            let currentDateString = dateFormatter.stringFromDate(currentDate)
            
            
            var nameOfImage  = "SS-\(SSStudentDataSource.sharedDataSource.currentUserId)-\(SSStudentDataSource.sharedDataSource.currentLiveSessionId)-\(currentDateString)"
            nameOfImage =  nameOfImage.stringByReplacingOccurrencesOfString(" ", withString: "")
            
            
            imageUploading.uploadImageWithImage(mAnswerImage.image, withImageName: nameOfImage, withUserId: SSStudentDataSource.sharedDataSource.currentUserId)
        }
        
        
    }
    
    func onDontKnowButton()
    {
        SSStudentMessageHandler.sharedMessageHandler.sendDontKnowMessageToTeacher()
        
        mReplyStatusLabelView.frame = CGRectMake((self.frame.size.width - (mTopbarImageView.frame.size.height * 2)) / 2, 0, mTopbarImageView.frame.size.height * 2, mTopbarImageView.frame.size.height / 1.5)
        mReplyStatusLabelView.hidden = false
        mReplyStatusLabelView.text = "Don't Know"
        mTopbarImageView.hidden = true
        
       mEditButton.hidden = true
        mWithDrawButton.hidden = true
        SSStudentDataSource.sharedDataSource.answerSent = true
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
        
        
        
        
        if (details.objectForKey("Scribble") != nil)
        {
        
            
            if let Scribble = details.objectForKey("Scribble") as? String
            {
                let urlString = NSUserDefaults.standardUserDefaults().objectForKey(k_INI_QuestionsImageUrl) as! String
                
                if let checkedUrl = NSURL(string: "\(urlString)/\(Scribble)")
                {
                    mOverlayImageView.contentMode = .ScaleAspectFit
                    mOverlayImageView.downloadImage(checkedUrl, withFolderType: folderType.questionImage)
                }
            }
        }
       
        

        
        print(details)
        

    }
    
    
    
    func setDrawnImage(image:UIImage)
    {
       mAnswerImage.image = image
    }
    
    
    // MARK: - ImageUploading delegate
    
    func ImageUploadedWithName(name: String!)
    {
        var nameOfImage = name
        if name.rangeOfString(".png") == nil
        {
           nameOfImage = "upload/\(name).png"
        }
        
        
        
        
       SSStudentDataSource.sharedDataSource.sendScribbleAnswer(nameOfImage, withQuestionType: currentQuestionType, withQuestionLogId: questionLogId, withsessionId: (sessionDetails.objectForKey("SessionId") as! String), withDelegate: self)
       
    }
    
    func ErrorInUploadingWithName(name: String!) {
        
        sendButtonSpinner.hidden = true
        sendButtonSpinner.stopAnimating()
        mSendButton.hidden = false
        mEditButton.hidden = false
        mWithDrawButton.hidden = true
    }
    
    
    func didGetAnswerSentWithDetails(details: AnyObject)
    {
        SSStudentMessageHandler.sharedMessageHandler.sendAnswerToQuestionMessageToTeacherWithAnswerString(details.objectForKey("AssessmentAnswerId") as! String)
        
        
        mReplyStatusLabelView.frame = CGRectMake((self.frame.size.width - (mTopbarImageView.frame.size.height * 2)) / 2, 0, mTopbarImageView.frame.size.height * 2, mTopbarImageView.frame.size.height / 1.5)
        
        mReplyStatusLabelView.hidden = false
        
        mReplyStatusLabelView.text = "Reply sent"
        
        mTopbarImageView.hidden = true
        
        mEditButton.hidden = true
        
        mWithDrawButton.hidden = true
        
        SSStudentDataSource.sharedDataSource.answerSent = true
        mWithDrawButton.hidden = false
        
    }
    
    func didgetErrorMessage(message: String, WithServiceName serviceName: String)
    {
        sendButtonSpinner.hidden = true
        sendButtonSpinner.stopAnimating()
        mSendButton.hidden = false
        mEditButton.hidden = false
        
    }
}