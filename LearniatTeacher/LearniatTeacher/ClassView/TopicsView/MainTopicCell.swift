//
//  MainTopicCell.swift
//  Learniat Teacher
//
//  Created by Deepak MK on 24/03/16.
//  Copyright © 2016 Mindshift. All rights reserved.
//

import Foundation
// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}

// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func <= <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l <= r
  default:
    return !(rhs < lhs)
  }
}



@objc protocol MainTopicCellDelegate
{
    
    
    @objc optional func delegateSubtopicButtonPressedWithID(_ mainTopicId:String, withmainTopicname mainTopicName:String)
    
    
    
}


class MainTopicCell: UIView{
  
    
    
    var m_graspImageView    = UIImageView()
    
    var m_MainTopicLabel    = UILabel()
    
    var mSubTopicButton     = UIButton()
    
    var mMainTopicId          = "0"
    
    
    var m_progressView      = UIProgressView()
    
    var currentTopicDetails :AnyObject!
    
    
    var _delgate: AnyObject!
    
    
    
    func setdelegate(_ delegate:AnyObject)
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
        
        let seperatorView = UIView(frame: CGRect(x: 0 ,y: self.frame.size.height - 1 , width: self.frame.size.width,height: 1))
        seperatorView.backgroundColor = topicsLineColor;
        self.addSubview(seperatorView)
        
        
        
        m_graspImageView.frame = CGRect(x: 10, y: (self.frame.size.height - 22)/2 , width: 34,height: 22)
        self.addSubview(m_graspImageView)
        m_graspImageView.image = UIImage(named: "00.png")
//        m_graspImageView.backgroundColor = standard_Button
        
        m_MainTopicLabel = UILabel(frame: CGRect(x: m_graspImageView.frame.size.width + m_graspImageView.frame.origin.x + 10 , y: 0 , width: 280, height: self.frame.size.height))
        m_MainTopicLabel.font = UIFont(name:helveticaMedium, size: 18)
        self.addSubview(m_MainTopicLabel)
        m_MainTopicLabel.textColor = blackTextColor
        m_MainTopicLabel.textAlignment = .left
        m_MainTopicLabel.lineBreakMode = .byTruncatingMiddle
        
        

        mSubTopicButton.frame = CGRect(x: self.frame.size.width - 260 , y: 0 ,width: 250 ,height: self.frame.size.height)
        self.addSubview(mSubTopicButton)
        mSubTopicButton.contentHorizontalAlignment = UIControlContentHorizontalAlignment.right
        mSubTopicButton.setTitleColor(standard_Button, for: UIControlState())
        mSubTopicButton.setTitle("No SubTopics", for: UIControlState())
        mSubTopicButton.titleLabel?.font = UIFont(name: helveticaMedium, size: 18)
        mSubTopicButton.addTarget(self, action: #selector(MainTopicCell.onSubtopicButton), for: UIControlEvents.touchUpInside)
        
        
        m_progressView.isUserInteractionEnabled = false;
        self.addSubview(m_progressView)
        m_progressView.frame  = CGRect(x: 10, y: self.frame.size.height - 10, width: self.frame.size.width - 20 , height: 1)
        m_progressView.progressTintColor = standard_Button;
        let transform: CGAffineTransform = CGAffineTransform(scaleX: 1.0, y: 1.5);
        m_progressView.transform = transform;
        
        
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setMainTopicDetails(_ topicDetails:AnyObject)
    {
        
        currentTopicDetails = topicDetails
        
        
        if let topicId = currentTopicDetails.object(forKey: "Id")as? String
        {
            mMainTopicId = topicId
            self.tag = Int(topicId)!
            
            
             if SSTeacherDataSource.sharedDataSource.startedMainTopicId == topicId && SSTeacherDataSource.sharedDataSource.isSubtopicStarted == true
             {
                m_MainTopicLabel.textColor = standard_Green
            }
            else
             {
                m_MainTopicLabel.textColor = blackTextColor
            }
            
        }
        
        if let topicName = currentTopicDetails.object(forKey: "Name")as? String
        {
            if let CumulativeTime = currentTopicDetails.object(forKey: "CumulativeTime")as? String
            {
                m_MainTopicLabel.text = "\(topicName)(\(CumulativeTime)) \(mMainTopicId)".capitalized
            }
            else
            {
                 m_MainTopicLabel.text = "\(topicName)".capitalized
            }
        }
        
        //Help
        if let SubTopicCount = currentTopicDetails.object(forKey: "TaggedSubTopicCount") as? String
        {
            if Int(SubTopicCount) <= 0
            {
                mSubTopicButton.setTitle("No Sub topics", for: UIControlState())
            }
            else if Int(SubTopicCount) == 1
            {
                mSubTopicButton.setTitle("\(SubTopicCount) Sub topic", for: UIControlState())
            }
            else
            {
                mSubTopicButton.setTitle("\(SubTopicCount) Sub topics", for: UIControlState())
            }
        }
        
        
        if let giValue = currentTopicDetails.object(forKey: "GraspIndex") as? NSString
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
        
        
        if let PercentageStarted = currentTopicDetails.object(forKey: "PercentageStarted") as? NSString
        {
            var percentageValue :Float =  PercentageStarted.floatValue
            
            percentageValue = percentageValue / 100
            
           m_progressView.progress = percentageValue
        }
        
    }
    
    func onSubtopicButton()
    {
        if delegate().responds(to: #selector(MainTopicCellDelegate.delegateSubtopicButtonPressedWithID(_:withmainTopicname:)))
        {
            if let topicName = currentTopicDetails.object(forKey: "Name")as? String
            {
                 delegate().delegateSubtopicButtonPressedWithID!(mMainTopicId , withmainTopicname:topicName)
            }
          
            
            
        }

    }
    
}
