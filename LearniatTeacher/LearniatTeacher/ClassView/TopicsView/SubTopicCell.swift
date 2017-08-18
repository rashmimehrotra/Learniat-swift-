//
//  SubTopicCell.swift
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




@objc protocol SubTopicCellDelegate
{
    
    
    @objc optional func delegateQuestionButtonPressedWithID(_ subTopicId:String, withSubTopicName subTopicName:String)
    
    @objc optional func delegateSubTopicCellStartedWithDetails(_ subTopicDetails:AnyObject, witStatedState isStarted:Bool)
    
    @objc optional func delegateShowAlert()
    
}

class SubTopicCell: UIView{
    
    
    
    var m_graspImageView    = UIImageView()
    
    var m_SubTopicLabel    = UILabel()
    
    var mDemoLabel          = UILabel()
    
    var mQuestionsButton     = UIButton()
    
    var mSubTopicId          = "0"
    
    
    var m_progressView      = UIProgressView()
    
    var startButton         = UIButton()
    
    
    var _delgate: AnyObject!
    
    
    var currentSubTopicDetails :AnyObject!
    
    
    
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
        
        m_SubTopicLabel = UILabel(frame: CGRect(x: m_graspImageView.frame.size.width + m_graspImageView.frame.origin.x + 5 , y: 0 , width: self.frame.size.width / 2, height: self.frame.size.height))
        m_SubTopicLabel.font = UIFont(name:helveticaMedium, size: 18)
        self.addSubview(m_SubTopicLabel)
        m_SubTopicLabel.textColor = blackTextColor
        m_SubTopicLabel.textAlignment = .left
        m_SubTopicLabel.lineBreakMode = .byTruncatingMiddle
        
        
        
        startButton.frame = CGRect(x: m_SubTopicLabel.frame.origin.x + m_SubTopicLabel.frame.size.width  , y: 0 ,width: self.frame.size.width / 5  ,height: self.frame.size.height)
        self.addSubview(startButton)
        startButton.contentHorizontalAlignment = UIControlContentHorizontalAlignment.center
        startButton.setTitleColor(standard_Green, for: UIControlState())
        startButton.setTitle("Start", for: UIControlState())
        startButton.titleLabel?.font = UIFont(name: helveticaMedium, size: 18)
        startButton.addTarget(self, action: #selector(SubTopicCell.onStartButton), for: UIControlEvents.touchUpInside)
        
        
        
        mQuestionsButton.frame = CGRect(x: self.frame.size.width - (self.frame.size.width / 5 + 10) , y: 0 ,width: self.frame.size.width / 5  ,height: self.frame.size.height)
        self.addSubview(mQuestionsButton)
        mQuestionsButton.contentHorizontalAlignment = UIControlContentHorizontalAlignment.right
        mQuestionsButton.setTitleColor(standard_Button_Disabled, for: UIControlState())
        mQuestionsButton.setTitle("No questions", for: UIControlState())
        mQuestionsButton.titleLabel?.font = UIFont(name: helveticaMedium, size: 18)
        mQuestionsButton.addTarget(self, action: #selector(SubTopicCell.onQuestionsButton), for: UIControlEvents.touchUpInside)
        mQuestionsButton.isEnabled = false
        mQuestionsButton.titleLabel!.lineBreakMode = .byTruncatingMiddle
        
        m_progressView.isUserInteractionEnabled = false;
        self.addSubview(m_progressView)
        m_progressView.frame  = CGRect(x: 10, y: self.frame.size.height - 10, width: self.frame.size.width - 20 , height: 1)
        m_progressView.progressTintColor = standard_Button;
        let transform: CGAffineTransform = CGAffineTransform(scaleX: 1.0, y: 1.5);
        m_progressView.transform = transform;
        
        
        mDemoLabel = UILabel(frame: CGRect(x: 10 ,  y: 5 , width: 100, height: 10))
        mDemoLabel.font = UIFont(name:helveticaMedium, size: 10)
        self.addSubview(mDemoLabel)
        mDemoLabel.textColor = standard_Green
        mDemoLabel.textAlignment = .left
        mDemoLabel.lineBreakMode = .byTruncatingMiddle
        mDemoLabel.text = "Simulation"

        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setSubTopicDetails(_ currentTopicDetails:AnyObject)
    {
        
        currentSubTopicDetails = currentTopicDetails
        
        if let topicId = currentTopicDetails.object(forKey: "Id")as? String
        {
            if SSTeacherDataSource.sharedDataSource.mDemoQuerySubTopicsArray.count>0
            {
               if SSTeacherDataSource.sharedDataSource.mDemoQuerySubTopicsArray.contains(topicId)
               {
                    if UserDefaults.standard.bool(forKey: "isSimulateMode") == true
                    {
                       mDemoLabel.isHidden = false
                }
                else
                    {
                         mDemoLabel.isHidden = true
                }
                
                
                }
                else
               {
                    mDemoLabel.isHidden = true
                }
                
                
            }
            else
            {
                mDemoLabel.isHidden = true
            }
            
            mSubTopicId = topicId
            self.tag = Int(topicId)!
        }
        
        
        if let topicName = currentTopicDetails.object(forKey: "Name")as? String
        {
            if let CumulativeTime = currentTopicDetails.object(forKey: "CumulativeTime")as? String
            {
                m_SubTopicLabel.text = "\(topicName)(\(CumulativeTime)) \(mSubTopicId)".capitalized
            }
            else
            {
                m_SubTopicLabel.text = "\(topicName)".capitalized
            }
        }
        
        
        if let QuestionCount = currentTopicDetails.object(forKey: "QuestionCount") as? String
        {
            
            mQuestionsButton.setTitleColor(standard_Button_Disabled, for: UIControlState())
            mQuestionsButton.isEnabled = false

            
            if Int(QuestionCount) <= 0
            {
                mQuestionsButton.setTitle("No questions", for: UIControlState())
                mQuestionsButton.setTitleColor(standard_Button, for: UIControlState())
                mQuestionsButton.isEnabled = true
            }
            else if Int(QuestionCount) == 1
            {
                mQuestionsButton.setTitle("\(QuestionCount) Question", for: UIControlState())
                mQuestionsButton.setTitleColor(standard_Button, for: UIControlState())
                mQuestionsButton.isEnabled = true

            }
            else
            {
                mQuestionsButton.setTitle("\(QuestionCount) Questions", for: UIControlState())
                mQuestionsButton.setTitleColor(standard_Button, for: UIControlState())
                mQuestionsButton.isEnabled = true

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
        
        
        if let PercentageStarted = currentTopicDetails.object(forKey: "PercentageStarted") as? NSString {
            var percentageValue :Float =  PercentageStarted.floatValue
            percentageValue = percentageValue / 100
            m_progressView.progress = percentageValue
        }
        
        if SSTeacherDataSource.sharedDataSource.isQuestionSent == true {
            startButton.isHidden = true
        } else {
            startButton.isHidden = false
        }
    }
    
    func onQuestionsButton()
    {
        if delegate().responds(to: #selector(SubTopicCellDelegate.delegateQuestionButtonPressedWithID(_:withSubTopicName:)))
        {
            if let topicName = currentSubTopicDetails.object(forKey: "Name")as? String
            {
                delegate().delegateQuestionButtonPressedWithID!(mSubTopicId, withSubTopicName: topicName)
            }
            
        }
    }
    
    func onStartButton()
    {
        if delegate().responds(to: #selector(SubTopicCellDelegate.delegateSubTopicCellStartedWithDetails(_:witStatedState:)))
        {
            
            if startButton.titleLabel?.text == "Start" || startButton.titleLabel?.text == "Resume"
            {
                
                if SSTeacherDataSource.sharedDataSource.isSubtopicStarted == false
                {
                    if let topicId = currentSubTopicDetails.object(forKey: "Id")as? String
                    {
                        SSTeacherDataSource.sharedDataSource.isSubtopicStarted = true

                        SSTeacherDataSource.sharedDataSource.startedSubTopicId = topicId
                        
                        
                        if let topicName = currentSubTopicDetails.object(forKey: "Name")as? String
                        {
                             SSTeacherDataSource.sharedDataSource.startedSubTopicName = topicName
                        }
                        
                         delegate().delegateSubTopicCellStartedWithDetails!(currentSubTopicDetails, witStatedState: true)
                    }
                }
                else
                {
                    delegate().delegateShowAlert!()
                }
                
            }
            else
            {
                if SSTeacherDataSource.sharedDataSource.isQuestionSent == false
                {
                    delegate().delegateSubTopicCellStartedWithDetails!(currentSubTopicDetails, witStatedState: false)
                    
                    SSTeacherDataSource.sharedDataSource.isSubtopicStarted = false
                }
                else {
                    delegate().delegateShowAlert!()
                }
                
            }
            
        }
    }
    
}
