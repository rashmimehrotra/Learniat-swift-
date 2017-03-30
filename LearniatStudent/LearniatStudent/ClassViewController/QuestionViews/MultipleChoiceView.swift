//
//  MultipleChoiceView.swift
//  LearniatStudent
//
//  Created by Deepak MK on 10/05/16.
//  Copyright © 2016 Mindshift. All rights reserved.
//

import Foundation
class MultipleChoiceView: UIView,SSStudentDataSourceDelegate
{
    
    var currentQuestionDetails:AnyObject!
    
    var mTopbarImageView = UIImageView()
    
    var mQuestionLabel = UILabel()
    
    var mSendButton = UIButton()
    
    var mDontKnow = UIButton()
    
    var mOptionsScrollView      = UIScrollView()
    
    var optionsArray :NSMutableArray = NSMutableArray()

     var currentQuestionType :String!
    
    var selectedOptions: NSMutableArray = NSMutableArray()
    
    var sessionDetails:AnyObject!
    
    var questionLogId = ""
    
    
    var mReplyStatusLabelView           = UILabel()
    
    override init(frame: CGRect)
    {
        super.init(frame: frame)
        self.backgroundColor = UIColor.white
        
        
        mTopbarImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: self.frame.size.width, height: 60))
        mTopbarImageView.backgroundColor = lightGrayTopBar
        self.addSubview(mTopbarImageView)
        mTopbarImageView.isUserInteractionEnabled = true
        mTopbarImageView.isUserInteractionEnabled = true
        
        
        mSendButton.frame = CGRect(x: mTopbarImageView.frame.size.width - 210, y: 0,width: 200,height: mTopbarImageView.frame.size.height )
        mTopbarImageView.addSubview(mSendButton)
        mSendButton.addTarget(self, action: #selector(MultipleChoiceView.onSendButton), for: UIControlEvents.touchUpInside)
        mSendButton.setTitle("Send", for: UIControlState())
        mSendButton.contentHorizontalAlignment = UIControlContentHorizontalAlignment.right
        mSendButton.titleLabel?.font = UIFont (name: helveticaMedium, size: 20)
        mSendButton.setTitleColor(UIColor.lightGray, for: UIControlState())
        mSendButton.isEnabled = false
        
        mDontKnow.frame = CGRect(x: 10, y: 0,width: 200,height: mTopbarImageView.frame.size.height )
        mTopbarImageView.addSubview(mDontKnow)
        mDontKnow.addTarget(self, action: #selector(MultipleChoiceView.onDontKnowButton), for: UIControlEvents.touchUpInside)
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
        
        
        mOptionsScrollView.frame = CGRect(x: 0, y: mQuestionLabel.frame.origin.y + mQuestionLabel.frame.size.height , width: self.frame.size.width, height: self.frame.size.height - (mQuestionLabel.frame.origin.y + mQuestionLabel.frame.size.height))
        self.addSubview(mOptionsScrollView)
        
        self.addSubview(mReplyStatusLabelView)
        mReplyStatusLabelView.textColor = UIColor.white
        mReplyStatusLabelView.backgroundColor = dark_Yellow
        mReplyStatusLabelView.font = UIFont (name: helveticaBold, size: 16)
        mReplyStatusLabelView.textAlignment = .center

        
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
        
        
         if let options = (currentQuestionDetails.object(forKey: kOptionTagMain) as AnyObject).object(forKey: kOptionTag) as? NSMutableArray
         {
            optionsArray = options
        }
        else
         {
            if let options = (currentQuestionDetails.object(forKey: kOptionTagMain) as AnyObject).object(forKey: kOptionTag) as? NSMutableDictionary
            {
                optionsArray.add(options)
            }
            
            //let options = (currentQuestionDetails.object(forKey: kOptionTagMain) as AnyObject).object(forKey: kOptionTag)
            
        }
        
        optionsArray.shuffleValue()
        
        
        var positionY :CGFloat = 10
        
        var positionX :CGFloat = 10
        
        for index in 0  ..< optionsArray.count
        {
            let currentOptionDetails = optionsArray.object(at: index)
            
            let optionTile = multipleResponseOptionView(frame: CGRect(x: positionX, y: positionY, width: (mOptionsScrollView.frame.size.width/2) - 20, height: 100))
            
            optionTile.setOptionDetails(currentOptionDetails as AnyObject)
            
            optionTile.setdelegate(self)
            
            optionTile.layer.borderColor = standard_Button.cgColor
            optionTile.layer.cornerRadius = optionTile.frame.size.height / 2
            optionTile.layer.borderWidth = 1
            optionTile.layer.masksToBounds = true
            
            
            mOptionsScrollView.addSubview(optionTile)
            
            if positionX == 10
            {
                positionX = (mOptionsScrollView.frame.size.width/2) + 10
            }
            else
            {
                positionX = 10
                positionY = positionY + optionTile.frame.size.height + 20
            }
            
            
            
        }
        mOptionsScrollView.contentSize = CGSize(width: 0, height: positionY)
    }
    
    
    
    // MARK: - options delegate Functions
    
    func delegateOptionTouchedWithState(_ state: Bool, withCurrentOptionDetails Details:AnyObject, withCurrentOption mOptionView:multipleResponseOptionView)
    {
        if currentQuestionType == MultipleChoice
        {
            
            
            let array : NSMutableArray = NSMutableArray()
            
            let subViews = mOptionsScrollView.subviews
            
            for optionView in subViews
            {
                if optionView.isKind(of: multipleResponseOptionView.self)
                {
                    array.add(optionView)
                }
            }
            
            
            
            for index in 0  ..< array.count  
            {
                let mOptions :multipleResponseOptionView = array.object(at: index) as! multipleResponseOptionView
                
                if state == true
                {
                    if mOptions.currentOptionId != mOptionView.currentOptionId
                    {
                        if mOptions.getselectedState() == true
                        {
                            mOptions.setSelectedState(false)
                        }
                    }
                    else
                    {
                        selectedOptions.removeAllObjects()
                        
                        selectedOptions.add(Details)
                    }
                }
                else
                {
                    mOptions.setSelectedState(false)
                    
                    selectedOptions.removeAllObjects()
                }
                
                
            }
            
        }
        else if currentQuestionType == MultipleResponse
        {
            
            if state == true
            {
                if selectedOptions.contains(Details) == false
                {
                    selectedOptions.add(Details)
                }
            }
            else
            {
                if selectedOptions.contains(Details) == true
                {
                    selectedOptions.remove(Details)
                }
            }
            
        }
        if selectedOptions.count>0
        {
            mSendButton.setTitleColor(standard_Button, for: UIControlState())
            
            mSendButton.isEnabled = true
        }
        else{
            mSendButton.setTitleColor(UIColor.lightGray, for: UIControlState())
            
            mSendButton.isEnabled = false
        }
        
    }


    func onSendButton()
    {
        
         mTopbarImageView.isHidden = true
        if currentQuestionType == MultipleChoice || currentQuestionType == MultipleResponse
        {
            if selectedOptions.count > 0
            {
                let optionsArray = NSMutableArray()
                
                for index in 0  ..< selectedOptions.count
                {
                    let mOptions = selectedOptions.object(at: index)
                    
                    optionsArray.add((mOptions as AnyObject).object(forKey: "OptionText") as! String)
                }
                
                 SSStudentDataSource.sharedDataSource.sendObjectvieAnswer(optionsArray.componentsJoined(by: ";;;"), withQuestionType: currentQuestionType, withQuestionLogId: questionLogId, withsessionId: (sessionDetails.object(forKey: "SessionId") as! String), withDelegate: self)
                
                
            }
        }
    }
    
    func onDontKnowButton()
    {
        SSStudentMessageHandler.sharedMessageHandler.sendDontKnowMessageToTeacher()
       
        mReplyStatusLabelView.frame = CGRect(x: (self.frame.size.width - (mTopbarImageView.frame.size.height * 2)) / 2, y: 0, width: mTopbarImageView.frame.size.height * 2, height: mTopbarImageView.frame.size.height / 1.5)
        mReplyStatusLabelView.isHidden = false
        mReplyStatusLabelView.text = "Don't Know"
        mTopbarImageView.isHidden = true
        
        let subViews = mOptionsScrollView.subviews
        
        for optionView in subViews
        {
            if optionView.isKind(of: multipleResponseOptionView.self)
            {
                optionView.isUserInteractionEnabled = false
            }
        }
         SSStudentDataSource.sharedDataSource.answerSent = true
    }

    
    func didGetAnswerSentWithDetails(_ details: AnyObject)
    {
    SSStudentMessageHandler.sharedMessageHandler.sendAnswerToQuestionMessageToTeacherWithAnswerString(details.object(forKey: "AssessmentAnswerId") as! String)
        
        
        mReplyStatusLabelView.frame = CGRect(x: (self.frame.size.width - (mTopbarImageView.frame.size.height * 2)) / 2, y: 0, width: mTopbarImageView.frame.size.height * 2, height: mTopbarImageView.frame.size.height / 1.5)
       
        mReplyStatusLabelView.isHidden = false
        
        mReplyStatusLabelView.text = "Reply sent"
        
        mTopbarImageView.isHidden = true
        
        let subViews = mOptionsScrollView.subviews
        
        for optionView in subViews
        {
            if optionView.isKind(of: multipleResponseOptionView.self)
            {
                optionView.isUserInteractionEnabled = false
            }
        }
        
        
        SSStudentDataSource.sharedDataSource.answerSent = true
        
    }
    
    
    func FreezMessageFromTeacher()
    {
        if SSStudentDataSource.sharedDataSource.answerSent == false
        {
            if selectedOptions.count > 0
            {
                onSendButton()
                
                
            }
            else
            {
                onDontKnowButton()
            }
            
            
            
            mReplyStatusLabelView.isHidden = false
            mReplyStatusLabelView.text = "Frozen"
            
        }
        

         let subViews = mOptionsScrollView.subviews.flatMap{ $0 as? multipleResponseOptionView }
        
        for mOptions in subViews
        {
            if mOptions.isKind(of: multipleResponseOptionView.self)
            {
                mOptions.checkOptionAnswerState()
            }
        }
        
    }
    
    
}
