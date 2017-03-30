//
//  TextTypeQuestionView.swift
//  LearniatStudent
//
//  Created by Deepak MK on 23/05/16.
//  Copyright © 2016 Mindshift. All rights reserved.
//

import Foundation
class TextTypeQuestionView: UIView,SSStudentDataSourceDelegate, CustomTextViewDelegate
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
    
    var mWithDrawButton     = UIButton()
    
    var sendButtonSpinner : UIActivityIndicatorView!

     var mContainerView = UIView()
    
    var mAnswerLabel        = UILabel()
    
    var modelAnswerScrollView = UIScrollView()
    
    var isModelAnswerRecieved = false

     var modelAnswerArray = NSMutableArray()
    
    var _delgate: AnyObject!
    
    func setdelegate(_ delegate:AnyObject)
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
        
        
        mTopbarImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: self.frame.size.width, height: 60))
        mTopbarImageView.backgroundColor = lightGrayTopBar
        self.addSubview(mTopbarImageView)
        mTopbarImageView.isUserInteractionEnabled = true
        
        
        mSendButton.frame = CGRect(x: mTopbarImageView.frame.size.width - 210, y: 0,width: 200,height: mTopbarImageView.frame.size.height )
        mTopbarImageView.addSubview(mSendButton)
        mSendButton.addTarget(self, action: #selector(TextTypeQuestionView.onSendButton), for: UIControlEvents.touchUpInside)
        mSendButton.setTitle("Send", for: UIControlState())
        mSendButton.contentHorizontalAlignment = UIControlContentHorizontalAlignment.right
        mSendButton.titleLabel?.font = UIFont (name: helveticaMedium, size: 20)
        mSendButton.setTitleColor(UIColor.lightGray, for: UIControlState())
        mSendButton.isEnabled = false
        
        
        sendButtonSpinner = UIActivityIndicatorView(activityIndicatorStyle:.whiteLarge);
        sendButtonSpinner.frame = mSendButton.frame;
        mTopbarImageView.addSubview(sendButtonSpinner);
        sendButtonSpinner.isHidden = true;
        

        
        
        mDontKnow.frame = CGRect(x: 10, y: 0,width: 200,height: mTopbarImageView.frame.size.height )
        mTopbarImageView.addSubview(mDontKnow)
        mDontKnow.addTarget(self, action: #selector(TextTypeQuestionView.onDontKnowButton), for: UIControlEvents.touchUpInside)
        mDontKnow.setTitle("Don't know", for: UIControlState())
        mDontKnow.contentHorizontalAlignment = UIControlContentHorizontalAlignment.left
        mDontKnow.setTitleColor(standard_Button, for: UIControlState())
        mDontKnow.titleLabel?.font = UIFont (name: helveticaMedium, size: 20)
        
        mQuestionLabel.frame = CGRect(x: 10, y: mTopbarImageView.frame.size.height + mTopbarImageView.frame.origin.y, width: self.frame.size.width-20, height: 80)
        mQuestionLabel.numberOfLines = 20;
        mQuestionLabel.textAlignment = .center
        self.addSubview(mQuestionLabel)
        mQuestionLabel.textColor = topbarColor
        mQuestionLabel.font = UIFont (name: helveticaRegular, size: 20)
        mQuestionLabel.lineBreakMode = .byTruncatingMiddle
        
     
        var remainingHeight = self.frame.size.height  - (mQuestionLabel.frame.size.height + mQuestionLabel.frame.origin.y)
        
        remainingHeight = remainingHeight / 1.2
        
        
        
        mContainerView.frame = CGRect(x: (self.frame.size.width - (remainingHeight * 1.5))/2 ,y: mQuestionLabel.frame.size.height + mQuestionLabel.frame.origin.y , width: remainingHeight * 1.5 , height: remainingHeight)
        self.addSubview(mContainerView)
        mContainerView.backgroundColor = UIColor.white
        mContainerView.layer.shadowColor = progressviewBackground.cgColor;
        mContainerView.layer.shadowOffset = CGSize(width: 0,height: 0);
        mContainerView.layer.shadowOpacity = 1;
        mContainerView.layer.shadowRadius = 1.0;
        mContainerView.clipsToBounds = false;
        mContainerView.layer.borderColor = topicsLineColor.cgColor
        mContainerView.layer.borderWidth = 1
        mContainerView.isHidden = true
        
        
        mAnswerLabel.frame = CGRect(x: 0,y: 0,width: mContainerView.frame.size.width,height: mContainerView.frame.size.height)
        mContainerView.addSubview(mAnswerLabel)
        mAnswerLabel.font = UIFont (name: helveticaRegular, size: 18)
        mAnswerLabel.numberOfLines = 100
        mAnswerLabel.lineBreakMode = .byWordWrapping
        mAnswerLabel.textColor = topbarColor
        
        mAnswerTextView = CustomTextView(frame:CGRect(x: (self.frame.size.width - (remainingHeight * 1.5))/2 ,y: mQuestionLabel.frame.size.height + mQuestionLabel.frame.origin.y , width: remainingHeight * 1.5 , height: 160))
        self.addSubview(mAnswerTextView)
        mAnswerTextView.setdelegate(self)
        mAnswerTextView.setPlaceHolder("Write your answer", withStartSting: "answer")

        
        
        self.addSubview(mReplyStatusLabel)
        mReplyStatusLabel.textColor = UIColor.white
        mReplyStatusLabel.backgroundColor = dark_Yellow
        mReplyStatusLabel.font = UIFont (name: helveticaBold, size: 16)
        mReplyStatusLabel.textAlignment = .center
        
        
        mWithDrawButton.frame = CGRect(x: mContainerView.frame.origin.x, y: mContainerView.frame.size.height + mContainerView.frame.origin.y + 1, width: mContainerView.frame.size.width, height: 40)
        self.addSubview(mWithDrawButton)
        mWithDrawButton.setTitle("Withdraw", for: UIControlState())
        mWithDrawButton.setTitleColor(standard_Button, for: UIControlState())
        mWithDrawButton.addTarget(self, action: #selector(TextTypeQuestionView.onWithDrawButton), for: UIControlEvents.touchUpInside)
        mWithDrawButton.layer.borderColor = topicsLineColor.cgColor
        mWithDrawButton.layer.borderWidth = 1
        mWithDrawButton.backgroundColor = whiteColor
        mWithDrawButton.isHidden = true

        modelAnswerScrollView.frame = CGRect(x: self.frame.size.width - 110, y: mTopbarImageView.frame.origin.y + mTopbarImageView.frame.size.height, width: 110, height: self.frame.size.height - (mTopbarImageView.frame.origin.y + mTopbarImageView.frame.size.height));
        self.addSubview(modelAnswerScrollView)
        modelAnswerScrollView.isHidden = true
        
        let longGesture = UITapGestureRecognizer(target: self, action: #selector(ScribbleQuestionView.Long)) //Long function will call when user long press on button.
        modelAnswerScrollView.addGestureRecognizer(longGesture)
        
        
        
    }
    
    
    func Long()
    {
        
        let modelAnswerFullView = ModelAnswerFullView(frame:CGRect(x: 10,y: 10,width: self.frame.size.width - 20, height: self.frame.size.height - 20 ))
        self.addSubview(modelAnswerFullView)
        modelAnswerFullView.setModelAnswerDetailsArray(modelAnswerArray, withQuestionName: mQuestionLabel.text!,withOverlayImage: UIImage())
        
               
        modelAnswerFullView.layer.shadowRadius = 1.0;
        
        modelAnswerFullView.layer.shadowColor = UIColor.black.cgColor
        modelAnswerFullView.layer.shadowOpacity = 0.3
        modelAnswerFullView.layer.shadowOffset = CGSize.zero
        modelAnswerFullView.layer.shadowRadius = 10

        
//        modelAnswerFullView.layer.shadowColor = progressviewBackground.CGColor;
//        modelAnswerFullView.layer.shadowOffset = CGSizeMake(0,0);
//        modelAnswerFullView.layer.shadowOpacity = 1;
//        modelAnswerFullView.layer.shadowRadius = 1.0;
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func setQuestionDetails(_ details:AnyObject, withsessionDetails _sessionDetails:AnyObject, withQuestionLogId _logId:String)
    {
        currentQuestionDetails = details
        questionLogId = _logId
        sessionDetails = _sessionDetails
        
        currentQuestionType = (details.object(forKey: kQuestionType) as? String)
        
        
        if (details.object(forKey: kQuestionName) as? String) != ""
        {
            mQuestionLabel.text = (details.object(forKey: kQuestionName) as? String)
        }
    }
    
    
    func onSendButton()
    {
       if  mAnswerTextView.getTextOfCurrentTextView() != ""
       {
            sendButtonSpinner.isHidden = false
            sendButtonSpinner.startAnimating()
            mSendButton.isHidden = true
            mWithDrawButton.isHidden = false
            SSStudentDataSource.sharedDataSource.sendTextAnswer(mAnswerTextView.getTextOfCurrentTextView(), withQuestionType: currentQuestionType, withQuestionLogId: questionLogId, withsessionId: (sessionDetails.object(forKey: "SessionId") as! String), withDelegate: self)
            mAnswerTextView.isHidden = true
            mContainerView.isHidden = false
        
            mAnswerLabel.text = mAnswerTextView.getTextOfCurrentTextView()
            let height =  heightForView(mAnswerLabel.text!, font: mAnswerLabel.font, width: mAnswerLabel.frame.size.width)
            mAnswerLabel.frame = CGRect(x: 5, y: 5, width: mAnswerLabel.frame.size.width - 10 , height: height )
        
        }
        
        
    }
    
    func onDontKnowButton()
    {
        SSStudentMessageHandler.sharedMessageHandler.sendDontKnowMessageToTeacher()
        
        mReplyStatusLabel.frame = CGRect(x: (self.frame.size.width - (mTopbarImageView.frame.size.height * 2)) / 2, y: 0, width: mTopbarImageView.frame.size.height * 2, height: mTopbarImageView.frame.size.height / 1.5)
        mReplyStatusLabel.isHidden = false
        mReplyStatusLabel.text = "Don't Know"
        
        mAnswerTextView.isHidden = true
        mTopbarImageView.isHidden = true
        mContainerView.isHidden = false
        
        mAnswerLabel.text = mAnswerTextView.getTextOfCurrentTextView()
        
        let height =  heightForView(mAnswerLabel.text!, font: mAnswerLabel.font, width: mAnswerLabel.frame.size.width)
        mAnswerLabel.frame = CGRect(x: 5, y: 5, width: mAnswerLabel.frame.size.width - 10 , height: height )

        mWithDrawButton.isHidden = true
        SSStudentDataSource.sharedDataSource.answerSent = true
    }
    
    
    func onWithDrawButton()
    {
        mContainerView.isHidden = true
        mAnswerTextView.isHidden = false
        mWithDrawButton.isHidden = true
        mTopbarImageView.isHidden = false
        mSendButton.isHidden = false
        mReplyStatusLabel.isHidden = true
        sendButtonSpinner.isHidden = true
        sendButtonSpinner.stopAnimating()

        SSStudentMessageHandler.sharedMessageHandler.sendWithDrawMessageToTeacher()
    }
    
    func didGetAnswerSentWithDetails(_ details: AnyObject)
    {
        SSStudentMessageHandler.sharedMessageHandler.sendAnswerToQuestionMessageToTeacherWithAnswerString(details.object(forKey: "AssessmentAnswerId") as! String)
        
        
        mReplyStatusLabel.frame = CGRect(x: (self.frame.size.width - (mTopbarImageView.frame.size.height * 2)) / 2, y: 0, width: mTopbarImageView.frame.size.height * 2, height: mTopbarImageView.frame.size.height / 1.5)
        
        mReplyStatusLabel.isHidden = false
        
        mReplyStatusLabel.text = "Reply sent"
        
        mTopbarImageView.isHidden = true
        
        
        mWithDrawButton.isHidden = true
        
        SSStudentDataSource.sharedDataSource.answerSent = true
        mWithDrawButton.isHidden = false
        
        if isModelAnswerRecieved  == true
        {
            SSStudentDataSource.sharedDataSource.getModelAnswerFromTeacherForQuestionLogId(questionLogId, withDelegate: self)
        }
        
    }
    
    func didgetErrorMessage(_ message: String, WithServiceName serviceName: String)
    {
        sendButtonSpinner.isHidden = true
        sendButtonSpinner.stopAnimating()
        mSendButton.isHidden = false
        
    }
    
    func didGetEvaluatingMessage()
    {
        mWithDrawButton.isHidden = true
        mReplyStatusLabel.text = "Evaluating..."
    }
    
    func getFeedBackDetails(_ details:AnyObject)
    {
        
        
        mReplyStatusLabel.text = "Evaluated"
        
        let teacherReplyStatusView = UIImageView(frame:CGRect(x: mWithDrawButton.frame.origin.x, y: mWithDrawButton.frame.origin.y, width: mWithDrawButton.frame.size.width, height: mWithDrawButton.frame.size.height))
        teacherReplyStatusView.backgroundColor = topbarColor
        self.addSubview(teacherReplyStatusView)
        
        
        
        var badgeValue    = 0
        var starCount   = 0
        
        if (details.object(forKey: "BadgeId") != nil)
        {
            if let badgeId = details.object(forKey: "BadgeId") as? String
            {
                badgeValue = Int(badgeId)!
            }
        }
        
        
        if (details.object(forKey: "Rating") != nil)
        {
            if let Rating = details.object(forKey: "Rating") as? String
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
            
            
            let starBackGround = UIImageView(frame: CGRect(x: width, y: 0, width: teacherReplyStatusView.frame.size.height*CGFloat(starCount) , height: teacherReplyStatusView.frame.size.height))
            teacherReplyStatusView.addSubview(starBackGround)
            starBackGround.backgroundColor = UIColor.clear
            
            
            
            
            
            
            
            var starWidth = starBackGround.frame.size.height
            let starSpace = starWidth * 0.2
            
            starWidth = starWidth * 0.8
            
            var positionX:CGFloat = 0
            for _ in 0  ..< starCount
            {
                let starImage = UIImageView(frame: CGRect(x: positionX,y: 0, width: starWidth ,height: starBackGround.frame.size.height))
                starBackGround.addSubview(starImage)
                starImage.image = UIImage(named: "Star_Selected.png")
                starImage.contentMode = .scaleAspectFit
                positionX = positionX + starImage.frame.size.width + starSpace
            }
            
            
            
            
            
            
            if badgeValue > 0
            {
                
                let badgeImage = CustomProgressImageView(frame: CGRect(x: teacherReplyStatusView.frame.size.width - (starWidth + 10) ,y: 0, width: starWidth ,height: starBackGround.frame.size.height))
                teacherReplyStatusView.addSubview(badgeImage)
                badgeImage.image = UIImage(named: "ic_thumb_up_green_48dp.png")
                
                
                
                let urlString = UserDefaults.standard.object(forKey: k_INI_Badges) as! String
                
                if let checkedUrl = URL(string: ("\(urlString)/\(badgeValue).png"))
                {
                    badgeImage.contentMode = .scaleAspectFit
                    badgeImage.downloadImage(checkedUrl, withFolderType: folderType.badgesImages)
                }
                
                
                
            }
            
            
            
        }
        
        
        if (details.object(forKey: "ImagePath") != nil)
        {
            if let Scribble = details.object(forKey: "ImagePath") as? String
            {
                let urlString = UserDefaults.standard.object(forKey: k_INI_QuestionsImageUrl) as! String
                
                if let checkedUrl = URL(string: "\(urlString)/\(Scribble).png")
                {
                    let teacherImage = CustomProgressImageView(frame:CGRect(x: 0, y: 0, width: mContainerView.frame.size.width, height: mContainerView.frame.size.height))
                    mContainerView.addSubview(teacherImage)
                    teacherImage.contentMode = .scaleAspectFit
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
        
        mReplyStatusLabel.isHidden = false
        mReplyStatusLabel.text = "Frozen"
        
    }
    
    func getPeakViewMessageFromTeacher()
    {
        
        if  mAnswerTextView.getTextOfCurrentTextView() != ""
        {
            SSStudentMessageHandler.sharedMessageHandler.sendPeakViewMessageToTeacherWithImageData(mAnswerTextView.getTextOfCurrentTextView())
        }
        
        
        
        
        
    }

    func delegateTextViewTextChanged(_ chnagedText:String)
    {
        if chnagedText != ""
        {
            mSendButton.isEnabled = true
            mSendButton.setTitleColor(standard_Button, for: UIControlState())
            
            
        }
        else
        {
            mSendButton.isEnabled = false
            mSendButton.setTitleColor(lightGrayColor, for: UIControlState())
            

        }
    }
    
    
    func heightForView(_ text:String, font:UIFont, width:CGFloat) -> CGFloat
    {
        let label:UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: width, height: CGFloat.greatestFiniteMagnitude))
        label.numberOfLines = 0
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.font = font
        label.text = text
        
        label.sizeToFit()
        return label.frame.height
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
    func didGetAllModelAnswerWithDetails(_ details: AnyObject)
    {
        
        
        modelAnswerArray.removeAllObjects()
        
        
        let subViews = modelAnswerScrollView.subviews
        
        for subview in subViews
        {
            if subview.isKind(of: ModelAnswerView.self)
            {
                subview.removeFromSuperview()
            }
        }
        
        if let _modelAnswerArray = (details.object(forKey: "AssessmentAnswerIdList") as AnyObject).object(forKey: "AssessmentAnswerId") as? NSMutableArray
        {
            showModelAnswerWithDetailsArray(_modelAnswerArray)
            modelAnswerArray = _modelAnswerArray
        }
        else
        {
            let testVariable :NSMutableArray = NSMutableArray()
            testVariable.add((details.object(forKey: "AssessmentAnswerIdList")! as AnyObject).object(forKey: "AssessmentAnswerId")!)
            showModelAnswerWithDetailsArray(testVariable)
            modelAnswerArray = testVariable
            
        }
        
    }
    
    func showModelAnswerWithDetailsArray(_ modelAnswersArray:NSMutableArray)
    {
        print(modelAnswersArray)
        
        
        let subViews = modelAnswerScrollView.subviews
        
        for subview in subViews
        {
            if subview.isKind(of: ModelAnswerView.self)
            {
                subview.removeFromSuperview()
            }
        }
        
        
        modelAnswerScrollView.isHidden = false
        
        
        var positionY:CGFloat = 10
        
        for index in 0  ..< modelAnswersArray.count
        {
            
            let dict = modelAnswersArray.object(at: index)
            
            let modelAnswer  = ModelAnswerView(frame: CGRect(x: 5, y: positionY, width: 100, height: 100))
            modelAnswerScrollView.addSubview(modelAnswer)
            if (dict as AnyObject).object(forKey: "TextAnswer") != nil{
                if let TextAnswer = (dict as AnyObject).object(forKey: "TextAnswer") as? String
                {
                    modelAnswer.setTextAnswerText(TextAnswer)
                }
            }
            
            
            
            
            if (dict as AnyObject).object(forKey: "StudentId") as! String == SSStudentDataSource.sharedDataSource.currentUserId
            {
                modelAnswer.backgroundColor = standard_Green
                modelAnswer.modelAnswerLabel.text = "Your answer selected as model answer"
                
            }
            else
            {
                modelAnswer.backgroundColor =  UIColor(red: 0.0/255.0, green: 174.0/255.0, blue: 239.0/255.0, alpha: 1)
                
                modelAnswer.modelAnswerLabel.text = "Model Answer"
            }
            positionY = positionY + modelAnswer.frame.size.height + 10
            
        }
        
        modelAnswerScrollView.contentSize = CGSize(width: 0,height: positionY)
        mWithDrawButton.isHidden = true
        mTopbarImageView.isHidden = true
        
        
    }
    

    
    
}
