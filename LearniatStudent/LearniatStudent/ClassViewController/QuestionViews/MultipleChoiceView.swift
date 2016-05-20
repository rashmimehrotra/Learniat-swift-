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
        self.backgroundColor = UIColor.whiteColor()
        
        
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
        
        
        mOptionsScrollView.frame = CGRectMake(0, mQuestionLabel.frame.origin.y + mQuestionLabel.frame.size.height , self.frame.size.width, self.frame.size.height - (mQuestionLabel.frame.origin.y + mQuestionLabel.frame.size.height))
        self.addSubview(mOptionsScrollView)
        
        self.addSubview(mReplyStatusLabelView)
        mReplyStatusLabelView.textColor = UIColor.whiteColor()
        mReplyStatusLabelView.backgroundColor = dark_Yellow
        mReplyStatusLabelView.font = UIFont (name: helveticaBold, size: 16)
        mReplyStatusLabelView.textAlignment = .Center

        
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
        
        
          let options = currentQuestionDetails.objectForKey(kOptionTagMain)?.objectForKey(kOptionTag)
        
        
        if options != nil
        {
            if (options!.isKindOfClass(NSMutableArray))
            {
                optionsArray = options as! NSMutableArray
            }
            else
            {
                optionsArray.addObject(options!)
            }
            
            
            optionsArray.shuffleValue()
            
            
            var positionY :CGFloat = 10
            
            var positionX :CGFloat = 10
            
            for index in 0  ..< optionsArray.count
            {
                let currentOptionDetails = optionsArray.objectAtIndex(index)
                
                let optionTile = multipleResponseOptionView(frame: CGRectMake(positionX, positionY, (mOptionsScrollView.frame.size.width/2) - 20, 100))
                
                optionTile.setOptionDetails(currentOptionDetails)
                
                optionTile.setdelegate(self)
                
                optionTile.layer.borderColor = standard_Button.CGColor
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
            mOptionsScrollView.contentSize = CGSizeMake(0, positionY)
        }
    }
    
    
    
    // MARK: - options delegate Functions
    
    func delegateOptionTouchedWithState(state: Bool, withCurrentOptionDetails Details:AnyObject, withCurrentOption mOptionView:multipleResponseOptionView)
    {
        if currentQuestionType == MultipleChoice
        {
            
            
            let array : NSMutableArray = NSMutableArray()
            
            let subViews = mOptionsScrollView.subviews
            
            for optionView in subViews
            {
                if optionView.isKindOfClass(multipleResponseOptionView)
                {
                    array.addObject(optionView)
                }
            }
            
            
            
            for index in 0  ..< array.count  
            {
                let mOptions :multipleResponseOptionView = array.objectAtIndex(index) as! multipleResponseOptionView
                
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
                        
                        selectedOptions.addObject(Details)
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
                if selectedOptions.containsObject(Details) == false
                {
                    selectedOptions.addObject(Details)
                }
            }
            else
            {
                if selectedOptions.containsObject(Details) == true
                {
                    selectedOptions.removeObject(Details)
                }
            }
            
        }
        if selectedOptions.count>0
        {
            mSendButton.setTitleColor(standard_Button, forState: .Normal)
            
            mSendButton.enabled = true
        }
        else{
            mSendButton.setTitleColor(UIColor.lightGrayColor(), forState: .Normal)
            
            mSendButton.enabled = false
        }
        
    }


    func onSendButton()
    {
        
         mTopbarImageView.hidden = true
        if currentQuestionType == MultipleChoice || currentQuestionType == MultipleResponse
        {
            if selectedOptions.count > 0
            {
                let optionsArray = NSMutableArray()
                
                for index in 0  ..< selectedOptions.count
                {
                    let mOptions = selectedOptions.objectAtIndex(index)
                    
                    optionsArray.addObject(mOptions.objectForKey("OptionText") as! String)
                }
                
                 SSStudentDataSource.sharedDataSource.sendObjectvieAnswer(optionsArray.componentsJoinedByString(";;;"), withQuestionType: currentQuestionType, withQuestionLogId: questionLogId, withsessionId: (sessionDetails.objectForKey("SessionId") as! String), withDelegate: self)
                
                
            }
        }
    }
    
    func onDontKnowButton()
    {
        SSStudentMessageHandler.sharedMessageHandler.sendDontKnowMessageToTeacher()
       
        mReplyStatusLabelView.frame = CGRectMake((self.frame.size.width - (mTopbarImageView.frame.size.height * 2)) / 2, 0, mTopbarImageView.frame.size.height * 2, mTopbarImageView.frame.size.height / 1.5)
        mReplyStatusLabelView.hidden = false
        mReplyStatusLabelView.text = "Don't Know"
        mTopbarImageView.hidden = true
        
        let subViews = mOptionsScrollView.subviews
        
        for optionView in subViews
        {
            if optionView.isKindOfClass(multipleResponseOptionView)
            {
                optionView.userInteractionEnabled = false
            }
        }
         SSStudentDataSource.sharedDataSource.answerSent = true
    }

    
    func didGetAnswerSentWithDetails(details: AnyObject)
    {
    SSStudentMessageHandler.sharedMessageHandler.sendAnswerToQuestionMessageToTeacherWithAnswerString(details.objectForKey("AssessmentAnswerId") as! String)
        
        
        mReplyStatusLabelView.frame = CGRectMake((self.frame.size.width - (mTopbarImageView.frame.size.height * 2)) / 2, 0, mTopbarImageView.frame.size.height * 2, mTopbarImageView.frame.size.height / 1.5)
       
        mReplyStatusLabelView.hidden = false
        
        mReplyStatusLabelView.text = "Reply sent"
        
        mTopbarImageView.hidden = true
        
        let subViews = mOptionsScrollView.subviews
        
        for optionView in subViews
        {
            if optionView.isKindOfClass(multipleResponseOptionView)
            {
                optionView.userInteractionEnabled = false
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
        }
        

         let subViews = mOptionsScrollView.subviews.flatMap{ $0 as? multipleResponseOptionView }
        
        for mOptions in subViews
        {
            if mOptions.isKindOfClass(multipleResponseOptionView)
            {
                mOptions.checkOptionAnswerState()
            }
        }
        
    }
    
    
}