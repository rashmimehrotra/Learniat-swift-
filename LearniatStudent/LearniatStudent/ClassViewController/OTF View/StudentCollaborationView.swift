//
//  StudentCollaborationView.swift
//  LearniatStudent
//
//  Created by Deepak MK on 02/02/17.
//  Copyright © 2017 Mindshift. All rights reserved.
//

import Foundation
import UIKit

class StudentCollaborationView: UIView,SSStudentDataSourceDelegate
{
    
    
    var mTopbarImageView = UIImageView()
    
    var mQuestionLabel = UILabel()
    
    var mSendButton = UIButton()

    var mAnswerTextView : CustomTextView!
    
    var mReplyStatusLabelView           = UILabel()
    
    var currentCategoryID = ""
    
    override init(frame: CGRect)
    {
        super.init(frame: frame)
       
        
    }
    
    
    func setCategoryName(_ Category:String, withCategoryID CategoryId:String)
    {
        
        currentCategoryID = CategoryId
        
        mTopbarImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: self.frame.size.width, height: 40))
        mTopbarImageView.backgroundColor = whiteColor
        self.addSubview(mTopbarImageView)
        mTopbarImageView.isUserInteractionEnabled = true
        mTopbarImageView.isUserInteractionEnabled = true
        
        
        mSendButton.frame = CGRect(x: mTopbarImageView.frame.size.width - 210, y: 0,width: 200,height: mTopbarImageView.frame.size.height )
        mTopbarImageView.addSubview(mSendButton)
        mSendButton.addTarget(self, action: #selector(StudentCollaborationView.onSendButton), for: UIControlEvents.touchUpInside)
        mSendButton.setTitle("Send", for: UIControlState())
        mSendButton.contentHorizontalAlignment = UIControlContentHorizontalAlignment.right
        mSendButton.titleLabel?.font = UIFont (name: helveticaMedium, size: 20)
        mSendButton.setTitleColor(UIColor.lightGray, for: UIControlState())
        mSendButton.isEnabled = false
        
        
        mQuestionLabel.frame = CGRect(x: 10, y: mTopbarImageView.frame.size.height + mTopbarImageView.frame.origin.y, width: self.frame.size.width-20, height: 40)
        mQuestionLabel.numberOfLines = 20;
        mQuestionLabel.textAlignment = .center
        self.addSubview(mQuestionLabel)
        mQuestionLabel.textColor = UIColor.black
        mQuestionLabel.font = UIFont (name: helveticaRegular, size: 20)
        mQuestionLabel.lineBreakMode = .byTruncatingMiddle
        
        mQuestionLabel.text = Category
        
        
        
        mAnswerTextView = CustomTextView(frame:CGRect(x: 50, y: mQuestionLabel.frame.origin.y + mQuestionLabel.frame.size.height + 10 ,width: self.frame.size.width - 100 ,height: 100))
        self.addSubview(mAnswerTextView)
        mAnswerTextView.setdelegate(self)
        mAnswerTextView.setPlaceHolder("Write your suggestion", withStartSting: "Suggestion")
        
        mReplyStatusLabelView.frame = CGRect(x: (self.frame.size.width - (mTopbarImageView.frame.size.height * 2)) / 2, y: 0, width: mTopbarImageView.frame.size.height * 2, height: mTopbarImageView.frame.size.height / 1.2)
        self.addSubview(mReplyStatusLabelView)
        mReplyStatusLabelView.textColor = UIColor.white
        mReplyStatusLabelView.backgroundColor = dark_Yellow
        mReplyStatusLabelView.font = UIFont (name: helveticaBold, size: 16)
        mReplyStatusLabelView.textAlignment = .center
        mReplyStatusLabelView.isHidden = true
        
        
    }
    
    
    func delegateTextViewTextChanged(_ chnagedText: String) {
        
        if chnagedText != ""
        {
            mSendButton.isEnabled = true
            mSendButton.setTitleColor(standard_Button, for: UIControlState())
        }
        else
        {
            mSendButton.setTitleColor(UIColor.lightGray, for: UIControlState())
            mSendButton.isEnabled = false
        }
    }
    
    
    required init?(coder aDecoder: NSCoder)
    {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    @objc func onSendButton()
    {
        mSendButton.loadingIndicator(show: true)
        
        mTopbarImageView.isHidden = true
        
        mAnswerTextView.mQuestionTextView.resignFirstResponder()
        
        mAnswerTextView.isUserInteractionEnabled = false
        
        mReplyStatusLabelView.frame = CGRect(x:(self.frame.size.width - (mTopbarImageView.frame.size.height * 3)) / 2,y:0, width:mTopbarImageView.frame.size.height * 3,height: mReplyStatusLabelView.frame.size.height)
        
        mReplyStatusLabelView.isHidden = false
        
        mReplyStatusLabelView.text = "Reply Sending"

        
        
        SSStudentDataSource.sharedDataSource.recordSuggestionWithSuggestionText(mAnswerTextView.getTextOfCurrentTextView(), withCategoryId: currentCategoryID, withTopicId: SSStudentDataSource.sharedDataSource.currentSubtopicID, withDelegate: self)
        
        
//        SSStudentDataSource.sharedDataSource.recordSuggestionWithSuggestionText(mAnswerTextView.getTextOfCurrentTextView(), withCategoryTitle: mQuestionLabel.text!, withTopicId: SSStudentDataSource.sharedDataSource.currentSubtopicID, withDelegate: self)
        
    }
    
    func didGetRecordedSuggestionWithDetails(_ details: AnyObject) {
        
        
        if let Status = details.object(forKey: "Status") as? String
        {
            if Status==kSuccessString
            {
                if let SuggestionId = details.object(forKey: "SuggestionId") as? String
                {
                    SSStudentMessageHandler.sharedMessageHandler.sendCollaborationSuggestion(mAnswerTextView.getTextOfCurrentTextView(), withSuggestionID: SuggestionId)
                }
                
                mReplyStatusLabelView.isHidden = false
                mReplyStatusLabelView.text = "Reply Sent"
                
                mAnswerTextView.isUserInteractionEnabled = false

                
            }
            else
            {
                 mTopbarImageView.isHidden = false
                mReplyStatusLabelView.isHidden = true
                mAnswerTextView.mQuestionTextView.isUserInteractionEnabled = true
            }
        }
        
    }
    
    
    func setSuggestionStatus(status:String)
    {
        
        let lable = UILabel(frame:CGRect(x: mAnswerTextView.frame.origin.x, y: mAnswerTextView.frame.origin.y + mAnswerTextView.frame.size.height, width:mAnswerTextView.frame.size.width, height: 50))
        self.addSubview(lable);
       lable.textColor = UIColor.white
        lable.font = UIFont (name: helveticaMedium, size: 20)
        lable.textAlignment = .center
        
        if status == "29"
        {
            lable.backgroundColor = standard_Green
            
            lable.text = "Selected"
        }
        else if status == "28"
        {
            lable.backgroundColor = standard_Red
             lable.text = "Rejected"
        }
        else
        {
            lable.backgroundColor = standard_TextGrey
            lable.text = "Ignored"
        }
        
    }
    
    
}
