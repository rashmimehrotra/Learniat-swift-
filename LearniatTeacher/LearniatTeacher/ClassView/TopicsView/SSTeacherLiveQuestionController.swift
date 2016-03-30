//
//  SSTeacherLiveQuestionController.swift
//  LearniatTeacher
//
//  Created by Deepak MK on 26/03/16.
//  Copyright © 2016 Mindshift. All rights reserved.
//

import Foundation

@objc protocol SSTeacherLiveQuestionControllerDelegate
{
    
    
    optional func delegateQuestionCleared(questionDetails:AnyObject, withCurrentmainTopicId mainTopicId:String, withCurrentMainTopicName mainTopicName:String)
  
    optional func delegateDoneButtonPressed()
    
}


class SSTeacherLiveQuestionController: UIViewController
{
    var _delgate: AnyObject!
    
    
    var currentSessionDetails       :AnyObject!
    
    var currentQuestionDetails       :AnyObject!
    
     var currentMainTopicId           = ""
    
    var currentMainTopicName          = ""
    
    var questionsDetailsDictonary:Dictionary<String, NSMutableArray> = Dictionary()
    
    
    func setdelegate(delegate:AnyObject)
    {
        _delgate = delegate;
    }
    
    func   delegate()->AnyObject
    {
        return _delgate;
    }
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        
        self.view.setNeedsLayout()
        self.view.layoutIfNeeded()
        
    }
    
    
    func setPreferredSize(size:CGSize, withSessionDetails details:AnyObject)
    {
        
        
        
        currentSessionDetails = details
        
        let mTopbarImageView = UIImageView(frame: CGRectMake(0, 0, size.width, 44))
        mTopbarImageView.backgroundColor = UIColor.whiteColor()
        self.view.addSubview(mTopbarImageView)
        mTopbarImageView.userInteractionEnabled = true
        
        
        
        let seperatorView = UIView(frame: CGRectMake(0 ,mTopbarImageView.frame.size.height - 1 , mTopbarImageView.frame.size.width,1))
        seperatorView.backgroundColor = LineGrayColor;
        mTopbarImageView.addSubview(seperatorView)
        
        
        let  mDoneButton = UIButton(frame: CGRectMake(mTopbarImageView.frame.size.width - 210,  0, 200 ,mTopbarImageView.frame.size.height))
        mTopbarImageView.addSubview(mDoneButton)
        mDoneButton.addTarget(self, action: "onDoneButton", forControlEvents: UIControlEvents.TouchUpInside)
        mDoneButton.setTitleColor(standard_Button, forState: .Normal)
        mDoneButton.setTitle("Done", forState: .Normal)
        mDoneButton.contentHorizontalAlignment = UIControlContentHorizontalAlignment.Right
        mDoneButton.titleLabel?.font = UIFont(name: helveticaMedium, size: 20)
        
        
        
        
        let  clearQuestion = UIButton(frame: CGRectMake(10,  0, 200 ,mTopbarImageView.frame.size.height))
        mTopbarImageView.addSubview(clearQuestion)
        clearQuestion.addTarget(self, action: "onClearQuestion", forControlEvents: UIControlEvents.TouchUpInside)
        clearQuestion.setTitleColor(standard_Button, forState: .Normal)
        clearQuestion.setTitle("Clear question", forState: .Normal)
        clearQuestion.contentHorizontalAlignment = UIControlContentHorizontalAlignment.Left
        clearQuestion.titleLabel?.font = UIFont(name: helveticaMedium, size: 20)
        
        
    }
    
    
    

    
    
    // MARK: - datasource delegate functions
    
    func setQuestionDetails(details:AnyObject, withMainTopciName mainTopicName:String, withMainTopicId mainTopicId:String)
    {
        currentQuestionDetails = details
        currentMainTopicId = mainTopicId
        currentMainTopicName = mainTopicName
        
    }
    
    
    
    func onDoneButton()
    {
        if delegate().respondsToSelector(Selector("delegateDoneButtonPressed"))
        {
            delegate().delegateDoneButtonPressed!()
        }
    }

    
    
    func onClearQuestion()
    {
        if delegate().respondsToSelector(Selector("delegateQuestionCleared:withCurrentmainTopicId:withCurrentMainTopicName:"))
        {
            delegate().delegateQuestionCleared!(currentQuestionDetails, withCurrentmainTopicId: currentMainTopicId, withCurrentMainTopicName: currentMainTopicName)
        }
    }
    
}