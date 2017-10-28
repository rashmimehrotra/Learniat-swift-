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
        self.backgroundColor = UIColor.white
        
        
        mTopbarImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: self.frame.size.width, height: 60))
        mTopbarImageView.backgroundColor = lightGrayTopBar
        self.addSubview(mTopbarImageView)
        mTopbarImageView.isUserInteractionEnabled = true
        mTopbarImageView.isUserInteractionEnabled = true
        
        
        mSendButton.frame = CGRect(x: mTopbarImageView.frame.size.width - 210, y: 0,width: 200,height: mTopbarImageView.frame.size.height )
        mTopbarImageView.addSubview(mSendButton)
        mSendButton.addTarget(self, action: #selector(MatchColumnView.onSendButton), for: UIControlEvents.touchUpInside)
        mSendButton.setTitle("Send", for: UIControlState())
        mSendButton.contentHorizontalAlignment = UIControlContentHorizontalAlignment.right
        mSendButton.titleLabel?.font = UIFont (name: helveticaMedium, size: 20)
        mSendButton.setTitleColor(standard_Button, for: UIControlState())
        mSendButton.isEnabled = true
        
        mDontKnow.frame = CGRect(x: 10, y: 0,width: 200,height: mTopbarImageView.frame.size.height )
        mTopbarImageView.addSubview(mDontKnow)
        mDontKnow.addTarget(self, action: #selector(MatchColumnView.onDontKnowButton), for: UIControlEvents.touchUpInside)
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
        
        
        
        
      
        
        
       
       
        mMatchColumnTableView.frame = CGRect( x: 0, y: mQuestionLabel.frame.origin.y + mQuestionLabel.frame.size.height , width: (self.frame.size.width), height: self.frame.size.height - (mQuestionLabel.frame.origin.y + mQuestionLabel.frame.size.height))
        self.addSubview(mMatchColumnTableView)
        
        
        
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
        
        if rightOptionArray.count == leftOptionsArray.count
        {
           mMatchColumnTableView.updateMatchColoumnQuestionDict(details)
        }
        
    }

    
    @objc func onSendButton()
    {
        
        SSStudentDataSource.sharedDataSource.sendMTCAnswer( mMatchColumnTableView.onSendButton(), withQuestionType: currentQuestionType, withQuestionLogId: questionLogId, withsessionId: (sessionDetails.object(forKey: "SessionId") as! String), withDelegate: self)
        
       
    }
    
    @objc func onDontKnowButton()
    {
        mMatchColumnTableView.onDontKnowButton()
    }
    
    func FreezMessageFromTeacher()
    {
        if SSStudentDataSource.sharedDataSource.answerSent == false
        {
            onSendButton()
            
        }
        mMatchColumnTableView.freezMessageFromTeacher()
       
        mReplyStatusLabelView.isHidden = false
        mReplyStatusLabelView.text = "Frozen"
        
    }
    
    // MARK: - datasource delegate Functions
    
    func didGetAnswerSentWithDetails(_ details: AnyObject)
    {
        if let Status = details.object(forKey: "Status") as? String
        {
            if Status == kSuccessString
            {
                SSStudentMessageHandler.sharedMessageHandler.sendAnswerToQuestionMessageToTeacherWithAnswerString(details.object(forKey: "AssessmentAnswerId") as! String)
                
                
                mReplyStatusLabelView.frame = CGRect(x: (self.frame.size.width - (mTopbarImageView.frame.size.height * 2)) / 2, y: 0, width: mTopbarImageView.frame.size.height * 2, height: mTopbarImageView.frame.size.height / 1.5)
                
                mReplyStatusLabelView.isHidden = false
                
                mReplyStatusLabelView.text = "Reply sent"
                
                mTopbarImageView.isHidden = true
                
                SSStudentDataSource.sharedDataSource.answerSent = true
            }
        }
        self.FreezMessageFromTeacher()
    }
   
}
