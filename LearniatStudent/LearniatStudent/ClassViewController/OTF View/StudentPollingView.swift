//
//  StudentPollingView.swift
//  LearniatStudent
//
//  Created by Deepak MK on 16/05/16.
//  Copyright © 2016 Mindshift. All rights reserved.
//

import Foundation
import UIKit
class StudentPollingView: UIView,PollingSubViewDelegate {
   
    var currentQuestionDetails:AnyObject!
    
    var mTopbarImageView = UIImageView()
    
    var mQuestionLabel = UILabel()
    
    var mSendButton = UIButton()
    
    var mOptionsScrollView      = UIScrollView()
    
    var selectedOptions: NSMutableArray = NSMutableArray()
    
    var selectedOPtionText = ""
    
    var mReplyStatusLabelView           = UILabel()
    
    override init(frame: CGRect)
    {
        super.init(frame: frame)
        
        
        
        mTopbarImageView = UIImageView(frame: CGRectMake(0, 0, self.frame.size.width, 60))
        mTopbarImageView.backgroundColor = lightGrayTopBar
        self.addSubview(mTopbarImageView)
        mTopbarImageView.userInteractionEnabled = true
        mTopbarImageView.userInteractionEnabled = true
        
        
        mSendButton.frame = CGRectMake(mTopbarImageView.frame.size.width - 210, 0,200,mTopbarImageView.frame.size.height )
        mTopbarImageView.addSubview(mSendButton)
        mSendButton.addTarget(self, action: #selector(StudentPollingView.onSendButton), forControlEvents: UIControlEvents.TouchUpInside)
        mSendButton.setTitle("Send", forState: .Normal)
        mSendButton.contentHorizontalAlignment = UIControlContentHorizontalAlignment.Right
        mSendButton.titleLabel?.font = UIFont (name: helveticaMedium, size: 20)
        mSendButton.setTitleColor(UIColor.lightGrayColor(), forState: .Normal)
        mSendButton.enabled = false
        
        
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
    
    required init?(coder aDecoder: NSCoder)
    {
        fatalError("init(coder:) has not been implemented")
    }
    
    func onSendButton()
    {
        if selectedOPtionText != ""
        {
             SSStudentMessageHandler.sharedMessageHandler.sendPollOptionSelectedWithoptionText(selectedOPtionText)
           
            mReplyStatusLabelView.frame = CGRectMake((self.frame.size.width - (mTopbarImageView.frame.size.height * 2)) / 2, 0, mTopbarImageView.frame.size.height * 2, mTopbarImageView.frame.size.height / 1.5)
            mReplyStatusLabelView.hidden = false
            mReplyStatusLabelView.text = "Reply sent"
            mTopbarImageView.hidden = true
            
            
            
            let subViews = mOptionsScrollView.subviews.flatMap{ $0 as? PollingSubView }
            
            for mOptions in subViews
            {
                if mOptions.isKindOfClass(PollingSubView)
                {
                   
                    mOptions.userInteractionEnabled = false
                }
            }

        }
       
    }
    
    func setQuestionOptionsWithDetails(details:AnyObject)
    {
        print(details)
        
        
        var optionsArray  = [String]()
        
        if let questionName = details.objectForKey("questionName") as? String
        {
            mQuestionLabel.text = questionName
        }
        
        if let Options = details.objectForKey("selectedOptions") as? String
        {
            optionsArray = Options.componentsSeparatedByString(";;;")
        }
        
        
        var currentPositionY:CGFloat = 10
        
        for index  in 0 ..< optionsArray.count
        {
            let optionText = optionsArray[index]
            
            let mPollingOptions = PollingSubView(frame:CGRectMake((self.frame.size.width - 400)/2,currentPositionY , 400, 60 ))
            mPollingOptions.setdelegate(self)
            mPollingOptions.setOptionDetails(optionText)
            mOptionsScrollView.addSubview(mPollingOptions)
            
            mPollingOptions.layer.borderColor = textColor.CGColor
            mPollingOptions.layer.cornerRadius = mPollingOptions.frame.size.height / 2
            mPollingOptions.layer.borderWidth = 1
            mPollingOptions.layer.masksToBounds = true
            currentPositionY = currentPositionY + mPollingOptions.frame.size.height + 20
            
        }
        
         mOptionsScrollView.contentSize = CGSizeMake(0, currentPositionY)
    }
    
    func delegateOptionTouchedWithText(optionText: String, withPollingView pollingView: PollingSubView, withState state: Bool) {
        
        let subViews = mOptionsScrollView.subviews.flatMap{ $0 as? PollingSubView }
        
        for mOptions in subViews
        {
            if mOptions.isKindOfClass(PollingSubView)
            {
                if state == true
                {
                    mSendButton.setTitleColor(standard_Button, forState: .Normal)
                    mSendButton.enabled = true
                    if mOptions != pollingView
                    {
                        mOptions.setSelectedState(false)
                    }
                    selectedOPtionText = optionText
                    
                }
                else
                {
                    mSendButton.setTitleColor(lightGrayColor, forState: .Normal)
                    mSendButton.enabled = false
                    mOptions.setSelectedState(false)
                    selectedOPtionText = ""
                }
                
            }
        }
        
    }
    
    
}