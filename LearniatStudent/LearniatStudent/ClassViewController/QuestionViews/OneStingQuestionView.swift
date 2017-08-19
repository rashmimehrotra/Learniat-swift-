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
        mSendButton.addTarget(self, action: #selector(OneStingQuestionView.onSendButton), for: UIControlEvents.touchUpInside)
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
        mDontKnow.addTarget(self, action: #selector(OneStingQuestionView.onDontKnowButton), for: UIControlEvents.touchUpInside)
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
        
        
        
        mContainerView.frame = CGRect(x: (self.frame.size.width - (remainingHeight * 1.5))/2 ,y: mQuestionLabel.frame.size.height + mQuestionLabel.frame.origin.y , width: remainingHeight * 1.5 ,height: 50)
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
        
        
        mAnswerLabel.frame = CGRect(x: 5,y: 5,width: mContainerView.frame.size.width - 10 , height: mContainerView.frame.size.height - 10)
        mContainerView.addSubview(mAnswerLabel)
        mAnswerLabel.font = UIFont (name: helveticaRegular, size: 18)
        mAnswerLabel.numberOfLines = 100
        mAnswerLabel.lineBreakMode = .byWordWrapping
        mAnswerLabel.textColor = topbarColor
        mAnswerLabel.textAlignment = .center
        
        mAnswerTextView = CustomTextView(frame:CGRect(x: (self.frame.size.width - (remainingHeight * 1.5))/2 ,y: mQuestionLabel.frame.size.height + mQuestionLabel.frame.origin.y , width: remainingHeight * 1.5 , height: 160))
        self.addSubview(mAnswerTextView)
        mAnswerTextView.setdelegate(self)
        mAnswerTextView.setPlaceHolder("Write your answer", withStartSting: "answer")
        
        
        
        self.addSubview(mReplyStatusLabel)
        mReplyStatusLabel.textColor = UIColor.white
        mReplyStatusLabel.backgroundColor = dark_Yellow
        mReplyStatusLabel.font = UIFont (name: helveticaBold, size: 16)
        mReplyStatusLabel.textAlignment = .center
        
        
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
          
            mReplyStatusLabel.frame = CGRect(x: (self.frame.size.width - (mTopbarImageView.frame.size.height * 2)) / 2, y: 0, width: mTopbarImageView.frame.size.height * 2, height: mTopbarImageView.frame.size.height / 1.5)
            
            mReplyStatusLabel.isHidden = false
            
            mReplyStatusLabel.text = "Reply sent"
            

            mTopbarImageView.isHidden = true
            mAnswerTextView.isHidden = true

            mAnswerLabel.text =  mAnswerTextView.getTextOfCurrentTextView()
            
           
                      mAnswerTextView.isHidden = true
            mContainerView.isHidden = false
            
             SSStudentDataSource.sharedDataSource.sendTextAnswer(mAnswerTextView.getTextOfCurrentTextView().removeWhitespace().removeSpecialCharsFromString().capitalized, withQuestionType: currentQuestionType, withQuestionLogId: questionLogId, withsessionId: (sessionDetails.object(forKey: RAPIConstants.SessionID.rawValue) as! String), withDelegate: self)
            
           
            
        }
        
        
    }
    
    
    func didGetAnswerSentWithDetails(_ details: AnyObject)
    {
         SSStudentDataSource.sharedDataSource.answerSent = true
        SSStudentMessageHandler.sharedMessageHandler.sendOneStringAnswerWithAnswer(mAnswerTextView.getTextOfCurrentTextView())
        
        if  let AssessmentAnswerId =  details.object(forKey: "AssessmentAnswerId") as? String
        {
            
            if currentQuestionType == TextAuto
            {
                
                var isAnswerCorrect :Bool = false
                
                 var currentOptionsArray         = NSMutableArray()
                
                if currentQuestionDetails.object(forKey: kOptionTagMain) != nil
                {
                    if let options = (currentQuestionDetails.object(forKey: kOptionTagMain) as AnyObject).object(forKey: kOptionTag)as? NSMutableArray
                    {
                        currentOptionsArray = options
                    }
                    else{
                        
                        if let options = (currentQuestionDetails.object(forKey: kOptionTagMain) as AnyObject).object(forKey: kOptionTag) as? NSMutableDictionary
                        {
                            currentOptionsArray.add(options)
                        }
                    }
                }
                
                
               
                
                
                
                
                
                for index in currentOptionsArray
                {
                    if let optionText = (index as AnyObject).object(forKey: "OptionText") as? String
                    {
                        if optionText.removeWhitespace().removeSpecialCharsFromString().capitalized == mAnswerTextView.getTextOfCurrentTextView().removeWhitespace().removeSpecialCharsFromString().capitalized
                        {
                            isAnswerCorrect = true
                            break
                            
                        }
                    }
                }
                
                if isAnswerCorrect == true
                {
                     SSStudentDataSource.sharedDataSource.updateStudentAnswerScoreWithAssessmentAnswerId(AssessmentAnswerId, withRating: "5", WithDelegate: self)
                }
                else
                {
                     SSStudentDataSource.sharedDataSource.updateStudentAnswerScoreWithAssessmentAnswerId(AssessmentAnswerId, withRating: "1", WithDelegate: self)
                }
            }
        }
        
    }
    
    func onDontKnowButton()
    {
        SSStudentMessageHandler.sharedMessageHandler.sendDontKnowMessageToTeacher()
        
        mReplyStatusLabel.frame = CGRect(x: (self.frame.size.width - (mTopbarImageView.frame.size.height * 2)) / 2, y: 0, width: mTopbarImageView.frame.size.height * 2, height: mTopbarImageView.frame.size.height / 1.5)
        mReplyStatusLabel.isHidden = false
        mReplyStatusLabel.text = "Don't Know"

        mTopbarImageView.isHidden = true
        mAnswerTextView.isHidden = true
        mAnswerLabel.text =  mAnswerTextView.getTextOfCurrentTextView()
        
        SSStudentDataSource.sharedDataSource.answerSent = true
    }
    func FreezMessageFromTeacher()
    {
        if SSStudentDataSource.sharedDataSource.answerSent == false
        {
            onSendButton()
            
        }
        
        
        if currentQuestionType == TextAuto
        {
            
            var isAnswerCorrect :Bool = false
           var currentOptionsArray         = NSMutableArray()
           if  let options = (currentQuestionDetails.object(forKey: kOptionTagMain) as AnyObject).object(forKey: kOptionTag) as? NSMutableArray
           {
                 currentOptionsArray = options
            }
            
           else
           {
             if let options = (currentQuestionDetails.object(forKey: kOptionTagMain) as AnyObject).object(forKey: kOptionTag) as? NSMutableDictionary
             {
                 currentOptionsArray.add(options)
            }
            
//                let options = (currentQuestionDetails.object(forKey: kOptionTagMain) as AnyObject).object(forKey: kOptionTag)
            
            }
            
            for index in currentOptionsArray
            {
                if let optionText = (index as AnyObject).object(forKey: "OptionText") as? String
                {
                    if optionText.removeWhitespace().removeSpecialCharsFromString().capitalized == mAnswerTextView.getTextOfCurrentTextView().removeWhitespace().removeSpecialCharsFromString().capitalized
                    {
                        isAnswerCorrect = true
                        break
                        
                    }
                }
            }
            
            if isAnswerCorrect == true
            {
                mAnswerLabel.textColor = whiteColor
                mContainerView.backgroundColor = standard_Green
                mContainerView.layer.borderWidth = 0
            }
            else
            {
                mAnswerLabel.textColor = whiteColor
                mContainerView.backgroundColor = standard_Red
                mContainerView.layer.borderWidth = 0
            }
            
            
            addCorrectAnswerWithArray(currentOptionsArray)
            
        }
        
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
    
    
    
    func addCorrectAnswerWithArray(_ correctAnswersArray:NSMutableArray)
    {
       
        let mCorrectAnswersScrollView = UIScrollView(frame: CGRect(x: mContainerView.frame.origin.x, y: mContainerView.frame.origin.y + mContainerView.frame.size.height + 30 ,width: mContainerView.frame.size.width ,height: self.frame.size.height - ( mContainerView.frame.origin.y + mContainerView.frame.size.height + 30)))
        self.addSubview(mCorrectAnswersScrollView)
        
        
        let correctOptionsLabel = UILabel(frame: CGRect(x: 0,y: 10 ,width: mCorrectAnswersScrollView.frame.size.width ,height: 30))
        mCorrectAnswersScrollView.addSubview(correctOptionsLabel)
        correctOptionsLabel.numberOfLines = 100
        correctOptionsLabel.lineBreakMode = .byWordWrapping
        
        correctOptionsLabel.text = "Correct options are :"
        correctOptionsLabel.textAlignment = .center
        
        
        
        var currentYPOsition = correctOptionsLabel.frame.origin.y + correctOptionsLabel.frame.size.height + 10
        for index in correctAnswersArray
        {
            if let optionText = (index as AnyObject).object(forKey: "OptionText") as? String
            {
                
                let OptionsLabel = UILabel(frame: CGRect(x: 0,y: currentYPOsition ,width: mCorrectAnswersScrollView.frame.size.width ,height: 30))
                mCorrectAnswersScrollView.addSubview(OptionsLabel)
                OptionsLabel.numberOfLines = 100
                OptionsLabel.lineBreakMode = .byWordWrapping
                OptionsLabel.textAlignment = .center
                OptionsLabel.text = "\(optionText.capitalized)"
                currentYPOsition = currentYPOsition + OptionsLabel.frame.size.height + 10
                OptionsLabel.textColor = whiteColor
                OptionsLabel.backgroundColor = standard_Green
                
                
            }
        }
        
        mCorrectAnswersScrollView.contentSize = CGSize(width: 0, height: currentYPOsition)
        
    }
    
    
}
