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
        
        
        
        mTopbarImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: self.frame.size.width, height: 60))
        mTopbarImageView.backgroundColor = lightGrayTopBar
        self.addSubview(mTopbarImageView)
        mTopbarImageView.isUserInteractionEnabled = true
        mTopbarImageView.isUserInteractionEnabled = true
        
        
        mSendButton.frame = CGRect(x: mTopbarImageView.frame.size.width - 210, y: 0,width: 200,height: mTopbarImageView.frame.size.height )
        mTopbarImageView.addSubview(mSendButton)
        mSendButton.addTarget(self, action: #selector(StudentPollingView.onSendButton), for: UIControlEvents.touchUpInside)
        mSendButton.setTitle("Send", for: UIControlState())
        mSendButton.contentHorizontalAlignment = UIControlContentHorizontalAlignment.right
        mSendButton.titleLabel?.font = UIFont (name: helveticaMedium, size: 20)
        mSendButton.setTitleColor(UIColor.lightGray, for: UIControlState())
        mSendButton.isEnabled = false
        
        
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
    
    required init?(coder aDecoder: NSCoder)
    {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func onSendButton()
    {
        if selectedOPtionText != ""
        {
             SSStudentMessageHandler.sharedMessageHandler.sendPollOptionSelectedWithoptionText(selectedOPtionText)
           
            mReplyStatusLabelView.frame = CGRect(x: (self.frame.size.width - (mTopbarImageView.frame.size.height * 2)) / 2, y: 0, width: mTopbarImageView.frame.size.height * 2, height: mTopbarImageView.frame.size.height / 1.5)
            mReplyStatusLabelView.isHidden = false
            mReplyStatusLabelView.text = "Reply sent"
            mTopbarImageView.isHidden = true
            
            
            
            let subViews = mOptionsScrollView.subviews.flatMap{ $0 as? PollingSubView }
            
            for mOptions in subViews
            {
                if mOptions.isKind(of: PollingSubView.self)
                {
                   
                    mOptions.isUserInteractionEnabled = false
                }
            }

        }
       
    }
    
    func setQuestionOptionsWithDetails(_ details:AnyObject)
    {
        
        
        var optionsArray  = [String]()
        
        if let questionName = details.object(forKey: "questionName") as? String
        {
            mQuestionLabel.text = questionName
        }
        
        if let Options = details.object(forKey: "selectedOptions") as? String
        {
            optionsArray = Options.components(separatedBy: ";;;")
        }
        
        
        var currentPositionY:CGFloat = 10
        
        for index  in 0 ..< optionsArray.count
        {
            let optionText = optionsArray[index]
            
            let mPollingOptions = PollingSubView(frame:CGRect(x: (self.frame.size.width - 400)/2,y: currentPositionY , width: 400, height: 60 ))
            mPollingOptions.setdelegate(self)
            mPollingOptions.setOptionDetails(optionText)
            mOptionsScrollView.addSubview(mPollingOptions)
            
            mPollingOptions.layer.borderColor = textColor.cgColor
            mPollingOptions.layer.cornerRadius = mPollingOptions.frame.size.height / 2
            mPollingOptions.layer.borderWidth = 1
            mPollingOptions.layer.masksToBounds = true
            currentPositionY = currentPositionY + mPollingOptions.frame.size.height + 20
            
        }
        
         mOptionsScrollView.contentSize = CGSize(width: 0, height: currentPositionY)
    }
    
    func delegateOptionTouchedWithText(_ optionText: String, withPollingView pollingView: PollingSubView, withState state: Bool) {
        
        let subViews = mOptionsScrollView.subviews.flatMap{ $0 as? PollingSubView }
        
        for mOptions in subViews
        {
            if mOptions.isKind(of: PollingSubView.self)
            {
                if state == true
                {
                    mSendButton.setTitleColor(standard_Button, for: UIControlState())
                    mSendButton.isEnabled = true
                    if mOptions != pollingView
                    {
                        mOptions.setSelectedState(false)
                    }
                    selectedOPtionText = optionText
                    
                }
                else
                {
                    mSendButton.setTitleColor(lightGrayColor, for: UIControlState())
                    mSendButton.isEnabled = false
                    mOptions.setSelectedState(false)
                    selectedOPtionText = ""
                }
                
            }
        }
        
    }
    
    
}
