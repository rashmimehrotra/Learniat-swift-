//
//  MainTopicCell.swift
//  Learniat Teacher
//
//  Created by Deepak MK on 24/03/16.
//  Copyright © 2016 Mindshift. All rights reserved.
//

import Foundation


@objc protocol MainTopicCellDelegate
{
    
    
    optional func delegateSubtopicButtonPressedWithID(mainTopicId:String, withmainTopicname mainTopicName:String)
    
    
    
}


class MainTopicCell: UIView{
  
    
    
    var m_graspImageView    = UIImageView()
    
    var m_MainTopicLabel    = UILabel()
    
    var mSubTopicButton     = UIButton()
    
    var mMainTopicId          = "0"
    
    
    var m_progressView      = UIProgressView()
    
    var currentTopicDetails :AnyObject!
    
    
    var _delgate: AnyObject!
    
    
    
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
        
        m_MainTopicLabel = UILabel(frame: CGRectMake(m_graspImageView.frame.size.width + m_graspImageView.frame.origin.x + 10 , 0 , 280, self.frame.size.height))
        m_MainTopicLabel.font = UIFont(name:helveticaMedium, size: 18)
        self.addSubview(m_MainTopicLabel)
        m_MainTopicLabel.textColor = blackTextColor
        m_MainTopicLabel.textAlignment = .Left
        m_MainTopicLabel.lineBreakMode = .ByTruncatingMiddle
        
        

        mSubTopicButton.frame = CGRectMake(self.frame.size.width - 260 , 0 ,250 ,self.frame.size.height)
        self.addSubview(mSubTopicButton)
        mSubTopicButton.contentHorizontalAlignment = UIControlContentHorizontalAlignment.Right
        mSubTopicButton.setTitleColor(standard_Button, forState: .Normal)
        mSubTopicButton.setTitle("No SubTopics", forState: .Normal)
        mSubTopicButton.titleLabel?.font = UIFont(name: helveticaMedium, size: 18)
        mSubTopicButton.addTarget(self, action: "onSubtopicButton", forControlEvents: UIControlEvents.TouchUpInside)
        
        
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
    
    func setMainTopicDetails(topicDetails:AnyObject)
    {
        
        currentTopicDetails = topicDetails
        
        
        if let topicId = currentTopicDetails.objectForKey("Id")as? String
        {
            mMainTopicId = topicId
        }
        
        
        if let topicName = currentTopicDetails.objectForKey("Name")as? String
        {
            if let CumulativeTime = currentTopicDetails.objectForKey("CumulativeTime")as? String
            {
                m_MainTopicLabel.text = "\(topicName)(\(CumulativeTime))".capitalizedString
            }
            else
            {
                 m_MainTopicLabel.text = "\(topicName)".capitalizedString
            }
        }
        
        
        if let SubTopicCount = currentTopicDetails.objectForKey("TaggedSubTopicCount") as? String
        {
            if Int(SubTopicCount) <= 0
            {
                mSubTopicButton.setTitle("No Sub topics", forState: .Normal)
            }
            else if Int(SubTopicCount) == 1
            {
                mSubTopicButton.setTitle("\(SubTopicCount) Sub topic", forState: .Normal)
            }
            else
            {
                mSubTopicButton.setTitle("\(SubTopicCount) Sub topics", forState: .Normal)
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
    
    func onSubtopicButton()
    {
        if delegate().respondsToSelector(Selector("delegateSubtopicButtonPressedWithID:withmainTopicname:"))
        {
            if let topicName = currentTopicDetails.objectForKey("Name")as? String
            {
                 delegate().delegateSubtopicButtonPressedWithID!(mMainTopicId , withmainTopicname:topicName)
            }
          
            
            
        }

    }
    
}