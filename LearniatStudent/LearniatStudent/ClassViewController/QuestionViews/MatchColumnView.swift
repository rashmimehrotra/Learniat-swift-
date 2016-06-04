//
//  MatchColumnView.swift
//  LearniatStudent
//
//  Created by Deepak MK on 10/05/16.
//  Copyright © 2016 Mindshift. All rights reserved.
//

import Foundation
class MatchColumnView: UIView,SSStudentDataSourceDelegate
{
    
    var currentQuestionDetails:AnyObject!
    
    var mTopbarImageView = UIImageView()
    
    var mQuestionLabel = UILabel()
    
    var mSendButton = UIButton()
    
    var mDontKnow = UIButton()
    
    var mMatchColumnTableView      = SSStudentMatchTheColoumnView()
    
    
    var currentQuestionType :String!
    
    var sessionDetails:AnyObject!
    
    var questionLogId = ""
    
    
    var leftOptionsArray = NSMutableArray()
    
    var rightOptionArray    = NSMutableArray()
    
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
        mSendButton.addTarget(self, action: #selector(MatchColumnView.onSendButton), forControlEvents: UIControlEvents.TouchUpInside)
        mSendButton.setTitle("Send", forState: .Normal)
        mSendButton.contentHorizontalAlignment = UIControlContentHorizontalAlignment.Right
        mSendButton.titleLabel?.font = UIFont (name: helveticaMedium, size: 20)
        mSendButton.setTitleColor(standard_Button, forState: .Normal)
        mSendButton.enabled = true
        
        mDontKnow.frame = CGRectMake(10, 0,200,mTopbarImageView.frame.size.height )
        mTopbarImageView.addSubview(mDontKnow)
        mDontKnow.addTarget(self, action: #selector(MatchColumnView.onDontKnowButton), forControlEvents: UIControlEvents.TouchUpInside)
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
        
        
        
        
      
        
        
       
       
        mMatchColumnTableView.frame = CGRectMake( 0, mQuestionLabel.frame.origin.y + mQuestionLabel.frame.size.height , (self.frame.size.width), self.frame.size.height - (mQuestionLabel.frame.origin.y + mQuestionLabel.frame.size.height))
        self.addSubview(mMatchColumnTableView)
        
        
        
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
        
        if rightOptionArray.count == leftOptionsArray.count
        {
           mMatchColumnTableView.updateMatchColoumnQuestionDict(details)
        }
        
    }

    
    func onSendButton()
    {
        
        SSStudentDataSource.sharedDataSource.sendMTCAnswer( mMatchColumnTableView.onSendButton(), withQuestionType: currentQuestionType, withQuestionLogId: questionLogId, withsessionId: (sessionDetails.objectForKey("SessionId") as! String), withDelegate: self)
        
       
    }
    
    func onDontKnowButton()
    {
        mMatchColumnTableView.onDontKnowButton()
    }
    
    func FreezMessageFromTeacher()
    {
        if SSStudentDataSource.sharedDataSource.answerSent == false
        {
            onSendButton()
            
        }
        mMatchColumnTableView.FreezMessageFromTeacher()
       
        mReplyStatusLabelView.hidden = false
        mReplyStatusLabelView.text = "Frozen"
        
    }
    
    // MARK: - datasource delegate Functions
    
    func didGetAnswerSentWithDetails(details: AnyObject)
    {
        
        if let Status = details.objectForKey("Status") as? String
        {
            if Status == kSuccessString
            {
                SSStudentMessageHandler.sharedMessageHandler.sendAnswerToQuestionMessageToTeacherWithAnswerString(details.objectForKey("AssessmentAnswerId") as! String)
                
                
                mReplyStatusLabelView.frame = CGRectMake((self.frame.size.width - (mTopbarImageView.frame.size.height * 2)) / 2, 0, mTopbarImageView.frame.size.height * 2, mTopbarImageView.frame.size.height / 1.5)
                
                mReplyStatusLabelView.hidden = false
                
                mReplyStatusLabelView.text = "Reply sent"
                
                mTopbarImageView.hidden = true
                
                SSStudentDataSource.sharedDataSource.answerSent = true
            }
        }
        
        

        
    }
    
   
   
}