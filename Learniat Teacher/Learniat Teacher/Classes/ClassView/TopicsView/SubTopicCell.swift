//
//  SubTopicCell.swift
//  Learniat Teacher
//
//  Created by Deepak MK on 24/03/16.
//  Copyright © 2016 Mindshift. All rights reserved.
//

import Foundation



@objc protocol SubTopicCellDelegate
{
    
    
    optional func delegateQuestionButtonPressedWithID(subTopicId:String, withSubTopicName subTopicName:String)
    
    optional func delegateSubTopicCellStartedWithId(subTopicId:String, witStatedState isStarted:Bool,withSubTopicName subTopicName:String)
    
}

class SubTopicCell: UIView{
    
    
    
    var m_graspImageView    = UIImageView()
    
    var m_SubTopicLabel    = UILabel()
    
    var mQuestionsButton     = UIButton()
    
    var mSubTopicId          = "0"
    
    
    var m_progressView      = UIProgressView()
    
    var startButton         = UIButton()
    
    
    var _delgate: AnyObject!
    
    var cumulativeTimer                    = NSTimer()
    
    var currentSubTopicDetails :AnyObject!
    
    
    
    func setdelegate(delegate:AnyObject)
    {
        _delgate = delegate;
    }
    
    func   delegate()->AnyObject
    {
        return _delgate;
    }
    
    
    override init(frame: CGRect)
    {
        super.init(frame:frame)
        
        
        
        self.backgroundColor = whiteBackgroundColor
        
        let seperatorView = UIView(frame: CGRectMake(0 ,self.frame.size.height - 1 , self.frame.size.width,1))
        seperatorView.backgroundColor = topicsLineColor;
        self.addSubview(seperatorView)
        
        
        
        m_graspImageView.frame = CGRectMake(10, (self.frame.size.height - 22)/2 , 34,22)
        self.addSubview(m_graspImageView)
        m_graspImageView.image = UIImage(named: "00.png")
        //        m_graspImageView.backgroundColor = standard_Button
        
        m_SubTopicLabel = UILabel(frame: CGRectMake(m_graspImageView.frame.size.width + m_graspImageView.frame.origin.x + 5 , 0 , self.frame.size.width / 2, self.frame.size.height))
        m_SubTopicLabel.font = UIFont(name:helveticaMedium, size: 18)
        self.addSubview(m_SubTopicLabel)
        m_SubTopicLabel.textColor = blackTextColor
        m_SubTopicLabel.textAlignment = .Left
        m_SubTopicLabel.lineBreakMode = .ByTruncatingMiddle
        
        
        
        startButton.frame = CGRectMake(m_SubTopicLabel.frame.origin.x + m_SubTopicLabel.frame.size.width  , 0 ,self.frame.size.width / 5  ,self.frame.size.height)
        self.addSubview(startButton)
        startButton.contentHorizontalAlignment = UIControlContentHorizontalAlignment.Center
        startButton.setTitleColor(standard_Green, forState: .Normal)
        startButton.setTitle("Start", forState: .Normal)
        startButton.titleLabel?.font = UIFont(name: helveticaMedium, size: 18)
        startButton.addTarget(self, action: "onStartButton", forControlEvents: UIControlEvents.TouchUpInside)
        
        
        
        mQuestionsButton.frame = CGRectMake(self.frame.size.width - (self.frame.size.width / 5 + 10) , 0 ,self.frame.size.width / 5  ,self.frame.size.height)
        self.addSubview(mQuestionsButton)
        mQuestionsButton.contentHorizontalAlignment = UIControlContentHorizontalAlignment.Right
        mQuestionsButton.setTitleColor(standard_Button_Disabled, forState: .Normal)
        mQuestionsButton.setTitle("No questions", forState: .Normal)
        mQuestionsButton.titleLabel?.font = UIFont(name: helveticaMedium, size: 18)
        mQuestionsButton.addTarget(self, action: "onQuestionsButton", forControlEvents: UIControlEvents.TouchUpInside)
        mQuestionsButton.enabled = false
        mQuestionsButton.titleLabel!.lineBreakMode = .ByTruncatingMiddle
        
        m_progressView.userInteractionEnabled = false;
        self.addSubview(m_progressView)
        m_progressView.frame  = CGRectMake(10, self.frame.size.height - 10, self.frame.size.width - 20 , 1)
        m_progressView.progressTintColor = standard_Button;
        let transform: CGAffineTransform = CGAffineTransformMakeScale(1.0, 1.5);
        m_progressView.transform = transform;
        
        
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setMainTopicDetails(currentTopicDetails:AnyObject)
    {
        
        currentSubTopicDetails = currentTopicDetails
        
        if let topicId = currentTopicDetails.objectForKey("Id")as? String
        {
            mSubTopicId = topicId
        }
        
        
        if let topicName = currentTopicDetails.objectForKey("Name")as? String
        {
            if let CumulativeTime = currentTopicDetails.objectForKey("CumulativeTime")as? String
            {
                m_SubTopicLabel.text = "\(topicName)(\(CumulativeTime))".capitalizedString
            }
            else
            {
                m_SubTopicLabel.text = "\(topicName)".capitalizedString
            }
        }
        
        
        if let QuestionCount = currentTopicDetails.objectForKey("QuestionCount") as? String
        {
            
            mQuestionsButton.setTitleColor(standard_Button_Disabled, forState: .Normal)
            mQuestionsButton.enabled = false

            
            if Int(QuestionCount) <= 0
            {
                mQuestionsButton.setTitle("No questions", forState: .Normal)
            }
            else if Int(QuestionCount) == 1
            {
                mQuestionsButton.setTitle("\(QuestionCount) Question", forState: .Normal)
                mQuestionsButton.setTitleColor(standard_Button, forState: .Normal)
                mQuestionsButton.enabled = true

            }
            else
            {
                mQuestionsButton.setTitle("\(QuestionCount) Questions", forState: .Normal)
                mQuestionsButton.setTitleColor(standard_Button, forState: .Normal)
                mQuestionsButton.enabled = true

            }
        }
        
        
        if let giValue = currentTopicDetails.objectForKey("GraspIndex") as? NSString
        {
            var graspIndexValue = giValue.integerValue
            
            if (graspIndexValue>0)
            {
                graspIndexValue = graspIndexValue/10;
                
            }
            
            if (graspIndexValue>10)
            {
                graspIndexValue = 10;
            }
            
            if (graspIndexValue<0)
            {
                graspIndexValue=0;
            }
            
            m_graspImageView.image = UIImage(named:"\(graspIndexValue)0.png")
        }
        
        
        if let PercentageStarted = currentTopicDetails.objectForKey("PercentageStarted") as? NSString
        {
            var percentageValue :Float =  PercentageStarted.floatValue
            
            percentageValue = percentageValue / 100
            
            m_progressView.progress = percentageValue
        }
        
    }
    
    func onQuestionsButton()
    {
        if delegate().respondsToSelector(Selector("delegateQuestionButtonPressedWithID:withSubTopicName:"))
        {
            if let topicName = currentSubTopicDetails.objectForKey("Name")as? String
            {
                delegate().delegateQuestionButtonPressedWithID!(mSubTopicId, withSubTopicName: topicName)
            }
            
        }
    }
    
    func onStartButton()
    {
        if let topicName = currentSubTopicDetails.objectForKey("Name")as? String
        {
            if delegate().respondsToSelector(Selector("delegateSubTopicCellStartedWithId:witStatedState:withSubTopicName:"))
            {
                
                if startButton.titleLabel?.text == "Start" || startButton.titleLabel?.text == "Resume"
                {
                    delegate().delegateSubTopicCellStartedWithId!(mSubTopicId, witStatedState: true ,withSubTopicName:topicName )
                    startButton.setTitle("Stop", forState: .Normal)
                    startButton.setTitleColor(standard_Red, forState: .Normal)
                    cumulativeTimer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: "udpateCumulativeTime", userInfo: nil, repeats: true)
                    
                }
                else
                {
                    delegate().delegateSubTopicCellStartedWithId!(mSubTopicId, witStatedState: false ,withSubTopicName:topicName)
                    startButton.setTitle("Resume", forState: .Normal)
                    startButton.setTitleColor(standard_Green, forState: .Normal)
                    cumulativeTimer.invalidate()
                }
                
            }
        }
    }
    
    
    func udpateCumulativeTime()
    {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "HH:mm:ss"
        
        var _string :String = ""
        var currentDate = NSDate()
        
        
        if let CumulativeTime = currentSubTopicDetails.objectForKey("CumulativeTime")as? String
        {
             currentDate = currentDate.addSeconds(1, withDate: dateFormatter.dateFromString(CumulativeTime)!)
             _string = dateFormatter.stringFromDate(currentDate)
             currentSubTopicDetails.setObject(_string, forKey: "CumulativeTime")
            
        }
        
       
        
        
       
       
        if let topicName = currentSubTopicDetails.objectForKey("Name")as? String
        {
            if let CumulativeTime = currentSubTopicDetails.objectForKey("CumulativeTime")as? String
            {
                m_SubTopicLabel.text = "\(topicName)(\(CumulativeTime))".capitalizedString
            }
            else
            {
                m_SubTopicLabel.text = "\(topicName)".capitalizedString
            }
        }
        
       
        
        print(_string)
    }
    
    
}