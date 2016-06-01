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
    
     var modelAnswerScrollView = UIScrollView()
    
    var isModelAnswerRecieved = false
    
    var modelAnswerArray = NSMutableArray()
    
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
        mWithDrawButton.addTarget(self, action: #selector(ScribbleQuestionView.onWithDrawButton), forControlEvents: UIControlEvents.TouchUpInside)
        mWithDrawButton.layer.borderColor = topicsLineColor.CGColor
        mWithDrawButton.layer.borderWidth = 1
        mWithDrawButton.backgroundColor = whiteColor
        mWithDrawButton.hidden = true

        
        
        
        mOverlayImageView.frame = CGRectMake(0 ,0 , mContainerView.frame.size.width ,mContainerView.frame.size.height)
        mContainerView.addSubview(mOverlayImageView)
        
        
        mAnswerImage.frame = CGRectMake(0 ,0 , mContainerView.frame.size.width ,mContainerView.frame.size.height)
        mContainerView.addSubview(mAnswerImage)
        
        
        
        modelAnswerScrollView.frame = CGRectMake(self.frame.size.width - 110, mTopbarImageView.frame.origin.y + mTopbarImageView.frame.size.height, 110, self.frame.size.height - (mTopbarImageView.frame.origin.y + mTopbarImageView.frame.size.height));
        self.addSubview(modelAnswerScrollView)
        modelAnswerScrollView.hidden = true
        modelAnswerScrollView.userInteractionEnabled = true
        
        
        
        
        
        let longGesture = UITapGestureRecognizer(target: self, action: #selector(ScribbleQuestionView.Long)) //Long function will call when user long press on button.
        modelAnswerScrollView.addGestureRecognizer(longGesture)
        longGesture.numberOfTapsRequired = 1

        

        
    }
    
    func Long()
    {
        
        let modelAnswerFullView = ModelAnswerFullView(frame:CGRectMake(10,10,self.frame.size.width - 20, self.frame.size.height - 20 ))
        self.addSubview(modelAnswerFullView)
        
        if mOverlayImageView.image != nil
        {
           modelAnswerFullView.setModelAnswerDetailsArray(modelAnswerArray, withQuestionName: mQuestionLabel.text!, withOverlayImage: mOverlayImageView.image!)
        }
        else
        {
            modelAnswerFullView.setModelAnswerDetailsArray(modelAnswerArray, withQuestionName: mQuestionLabel.text!,withOverlayImage: UIImage())
        }
        
        
        modelAnswerFullView.layer.shadowRadius = 1.0;
        
        modelAnswerFullView.layer.shadowColor = UIColor.blackColor().CGColor
        modelAnswerFullView.layer.shadowOpacity = 0.3
        modelAnswerFullView.layer.shadowOffset = CGSizeZero
        modelAnswerFullView.layer.shadowRadius = 10

        
        
//        modelAnswerFullView.layer.shadowColor = progressviewBackground.CGColor;
//        modelAnswerFullView.layer.shadowOffset = CGSizeMake(0,0);
//        modelAnswerFullView.layer.shadowOpacity = 1;
//        modelAnswerFullView.layer.shadowRadius = 1.0;

    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func onEditButton()
    {
        if mOverlayImageView.image != nil
        {
            delegate().delegateEditButtonPressedWithOverlayImage!(mOverlayImageView.image!)
        }
        else
        {
            delegate().delegateEditButtonPressedWithOverlayImage!(UIImage())
        }
    }
    
    func onWithDrawButton()
    {
        mContainerView.hidden = true
        mEditButton.hidden = false
        mReplyStatusLabelView.hidden = true
        mTopbarImageView.hidden = false
        SSStudentDataSource.sharedDataSource.answerSent = false
        mWithDrawButton.hidden = true
        SSStudentMessageHandler.sharedMessageHandler.sendWithDrawMessageToTeacher()
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
        
        
        if isModelAnswerRecieved  == true
        {
            SSStudentDataSource.sharedDataSource.getModelAnswerFromTeacherForQuestionLogId(questionLogId, withDelegate: self)
        }
        

        
    }
    
    
    func didGetAllModelAnswerWithDetails(details: AnyObject)
    {
        
        
        modelAnswerArray.removeAllObjects()
        
        
        let subViews = modelAnswerScrollView.subviews
        
        for subview in subViews
        {
            if subview.isKindOfClass(ModelAnswerView)
            {
                subview.removeFromSuperview()
            }
        }
        
        if let _modelAnswerArray = details.objectForKey("AssessmentAnswerIdList")?.objectForKey("AssessmentAnswerId") as? NSMutableArray
        {
            showModelAnswerWithDetailsArray(_modelAnswerArray)
            modelAnswerArray = _modelAnswerArray
            
        }
        else
        {
            let testVariable :NSMutableArray = NSMutableArray()
            testVariable.addObject(details.objectForKey("AssessmentAnswerIdList")!.objectForKey("AssessmentAnswerId")!)
            showModelAnswerWithDetailsArray(testVariable)
            
            modelAnswerArray = testVariable
            
        }
        
        
        
        
    }
    
    func showModelAnswerWithDetailsArray(modelAnswersArray:NSMutableArray)
    {
        print(modelAnswersArray)
        
        
        let subViews = modelAnswerScrollView.subviews
        
        for subview in subViews
        {
            if subview.isKindOfClass(ModelAnswerView)
            {
                subview.removeFromSuperview()
            }
        }
        
        
        modelAnswerScrollView.hidden = false
        
        
        var positionY:CGFloat = 10
        
        for index in 0  ..< modelAnswersArray.count 
        {
            
            let dict = modelAnswersArray.objectAtIndex(index)
            
            print(dict)
            let modelAnswer  = ModelAnswerView(frame: CGRectMake(5, positionY, 100, 100))
            modelAnswerScrollView.addSubview(modelAnswer)
            if dict.objectForKey("Image") != nil
            {
                if let ScribbleName = dict.objectForKey("Image") as? String
                {
                    if mOverlayImageView.image != nil
                    {
                        modelAnswer.setScribbleImageName(ScribbleName, withOverlayImage: mOverlayImageView.image!)
                    }
                    else
                        {
                            modelAnswer.setScribbleImageName(ScribbleName, withOverlayImage: UIImage())
                    }
                    
                }
            }
            
            
            
            
            if dict.objectForKey("StudentId") as! String == SSStudentDataSource.sharedDataSource.currentUserId
            {
                modelAnswer.backgroundColor = standard_Green
                modelAnswer.modelAnswerLabel.text = "Your answer selected"
                
            }
            else
            {
                modelAnswer.backgroundColor =  UIColor(red: 0.0/255.0, green: 174.0/255.0, blue: 239.0/255.0, alpha: 1)
                
                modelAnswer.modelAnswerLabel.text = "Model Answer"
            }
            positionY = positionY + modelAnswer.frame.size.height + 10
            
        }
        
        modelAnswerScrollView.contentSize = CGSizeMake(0,positionY)
         mEditButton.hidden = true
        mWithDrawButton.hidden = true
        mTopbarImageView.hidden = true
        
        
    }
    
    
    func didgetErrorMessage(message: String, WithServiceName serviceName: String)
    {
        sendButtonSpinner.hidden = true
        sendButtonSpinner.stopAnimating()
        mSendButton.hidden = false
        mEditButton.hidden = false
        
    }
    
    func didGetEvaluatingMessage()
    {
        mWithDrawButton.hidden = true
         mReplyStatusLabelView.text = "Evaluating..."
    }
    
    func getFeedBackDetails(details:AnyObject)
    {
        
        
        mReplyStatusLabelView.text = "Evaluated"
        
        let teacherReplyStatusView = UIImageView(frame:CGRectMake(mWithDrawButton.frame.origin.x, mWithDrawButton.frame.origin.y, mWithDrawButton.frame.size.width, mWithDrawButton.frame.size.height))
        teacherReplyStatusView.backgroundColor = topbarColor
        self.addSubview(teacherReplyStatusView)
        
        
        
        var badgeValue    = 0
        var starCount   = 0
        
        if (details.objectForKey("BadgeId") != nil)
        {
            if let badgeId = details.objectForKey("BadgeId") as? String
            {
                 badgeValue = Int(badgeId)!
            }
        }
        
        
        if (details.objectForKey("Rating") != nil)
        {
            if let Rating = details.objectForKey("Rating") as? String
            {
                starCount = Int(Rating)!
            }
        }
        
        
        if starCount > 0
        {
            
            var width = (teacherReplyStatusView.frame.size.width -  (teacherReplyStatusView.frame.size.height*CGFloat(starCount) ))/2
            
            if badgeValue > 0
            {
                width = 10
            }
            
            
            let starBackGround = UIImageView(frame: CGRectMake(width, 0, teacherReplyStatusView.frame.size.height*CGFloat(starCount) , teacherReplyStatusView.frame.size.height))
            teacherReplyStatusView.addSubview(starBackGround)
            starBackGround.backgroundColor = UIColor.clearColor()
            
            
            
            
            
            
            
            var starWidth = starBackGround.frame.size.height
            let starSpace = starWidth * 0.2
            
            starWidth = starWidth * 0.8
            
            var positionX:CGFloat = 0
            for _ in 0  ..< starCount
            {
                let starImage = UIImageView(frame: CGRectMake(positionX,0, starWidth ,starBackGround.frame.size.height))
                starBackGround.addSubview(starImage)
                starImage.image = UIImage(named: "Star_Selected.png")
                starImage.contentMode = .ScaleAspectFit
                positionX = positionX + starImage.frame.size.width + starSpace
            }
            
            
            
            
            
            
            if badgeValue > 0
            {
                
                let badgeImage = UIImageView(frame: CGRectMake(teacherReplyStatusView.frame.size.width - (starWidth + 10) ,0, starWidth ,starBackGround.frame.size.height))
                teacherReplyStatusView.addSubview(badgeImage)
                badgeImage.image = UIImage(named: "ic_thumb_up_green_48dp.png")

                
                
                let urlString = NSUserDefaults.standardUserDefaults().objectForKey(k_INI_Badges) as! String
               
                if let checkedUrl = NSURL(string: ("\(urlString)/\(badgeValue).png"))
                {
                    badgeImage.contentMode = .ScaleAspectFit
                    badgeImage.downloadImage(checkedUrl, withFolderType: folderType.badgesImages)
                }
                
                
                
            }
            
           
            
        }
        
        
        if (details.objectForKey("ImagePath") != nil)
        {
            if let Scribble = details.objectForKey("ImagePath") as? String
            {
                let urlString = NSUserDefaults.standardUserDefaults().objectForKey(k_INI_QuestionsImageUrl) as! String
                
                if let checkedUrl = NSURL(string: "\(urlString)/\(Scribble).png")
                {
                    let teacherImage = UIImageView(frame:mOverlayImageView.frame)
                    mContainerView.addSubview(teacherImage)
                    teacherImage.contentMode = .ScaleAspectFit
                    teacherImage.downloadImage(checkedUrl, withFolderType: folderType.questionImage)
                }
            }
        }
        
        
        
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
        if mAnswerImage.image != nil
        {
            //Now use image to create into NSData format
            let imageData:NSData = UIImagePNGRepresentation(mAnswerImage.image!)!
            let strBase64:String = imageData.base64EncodedStringWithOptions(.Encoding64CharacterLineLength)
            SSStudentMessageHandler.sharedMessageHandler.sendPeakViewMessageToTeacherWithImageData(strBase64)

        }
        else{
            let imageData:NSData = UIImagePNGRepresentation(UIImage())!
            let strBase64:String = imageData.base64EncodedStringWithOptions(.Encoding64CharacterLineLength)
            SSStudentMessageHandler.sharedMessageHandler.sendPeakViewMessageToTeacherWithImageData(strBase64)

        }
    }
    
    
    func showModelAnswerWithDetails()
    {
        if SSStudentDataSource.sharedDataSource.answerSent == true
        {
            isModelAnswerRecieved = true
            SSStudentDataSource.sharedDataSource.getModelAnswerFromTeacherForQuestionLogId(questionLogId, withDelegate: self)
        }
        else
        {
            isModelAnswerRecieved = true
        }
    }
    
}