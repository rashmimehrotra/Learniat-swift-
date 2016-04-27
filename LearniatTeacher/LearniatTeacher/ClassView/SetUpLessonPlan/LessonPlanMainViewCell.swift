//
//  LessonPlanMainViewCell.swift
//  LearniatTeacher
//
//  Created by mindshift_Deepak on 16/04/16.
//  Copyright © 2016 Mindshift. All rights reserved.
//

import Foundation


@objc protocol LessonPlanMainViewDelegate
{
    
    
    
    optional func delegateSubTopicCellPressedWithMainTopicDetails(topicDetails:AnyObject, withIndexValue indexValue:Int)
    
     optional func delegateMainTopicCheckMarkPressedWithState(SelectedState:Bool, withIndexValue indexValue:Int, withCurrentTopicDatails details:AnyObject)
    
}


class LessonPlanMainViewCell: UIView{
    
        let dateFormatter = NSDateFormatter()
    
    var m_graspImageView    = UIImageView()
    
    var m_MainTopicLabel    = UILabel()
    
    var mSubTopicButton     = UIButton()
    
    
    var mQuestionsButton     = UIButton()
    
    var mMainTopicId          = "0"
    
     let checkBoxImage       = UIImageView()
    
    var m_progressView      = UIProgressView()
    
    var currentTopicDetails :AnyObject!
    
    var     isSelected          = true
    
    var _delgate: AnyObject!
    
    var m_checkBoxButton :UIButton!
    
    var currentindexPath    = 0
    
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
        
        
        
        
        
         dateFormatter.dateFormat = "HH:mm:ss"
        
         m_checkBoxButton = UIButton(frame:CGRectMake(0, 0, self.frame.size.width ,self.frame.size.height - 10));
        self.addSubview(m_checkBoxButton);
        checkBoxImage.frame = CGRectMake(10  , (self.frame.size .height - 20) / 2,20,20)
        checkBoxImage.image = UIImage(named:"Checked.png");
        self.addSubview(checkBoxImage);
        m_checkBoxButton.addTarget(self, action: #selector(LessonPlanMainViewCell.checkMarkPressed), forControlEvents: UIControlEvents.TouchUpInside)

        
        
        m_graspImageView.frame = CGRectMake(checkBoxImage.frame.size.width + checkBoxImage.frame.origin.x + 10, (self.frame.size.height - (self.frame.size.height / 1.8))/2 ,self.frame.size.height / 1.8,self.frame.size.height / 1.8)
        self.addSubview(m_graspImageView)
        m_graspImageView.image = UIImage(named: "00.png")
        m_graspImageView.contentMode = .ScaleAspectFit
        
        
        mSubTopicButton.frame = CGRectMake(self.frame.size.width - 160 , 10 ,150 ,self.frame.size.height - 20)
        self.addSubview(mSubTopicButton)
        mSubTopicButton.contentHorizontalAlignment = UIControlContentHorizontalAlignment.Center
        mSubTopicButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        mSubTopicButton.backgroundColor = standard_Button
        mSubTopicButton.setTitle("No SubTopics", forState: .Normal)
        mSubTopicButton.titleLabel?.font = UIFont(name: helveticaRegular, size: 20)
        mSubTopicButton.addTarget(self, action: #selector(LessonPlanMainViewCell.onSubtopicButton), forControlEvents: UIControlEvents.TouchUpInside)
        mSubTopicButton.layer.cornerRadius = (mSubTopicButton.frame.size.height)/3
        
        
        
        
        mQuestionsButton.frame = CGRectMake(mSubTopicButton.frame.origin.x - 160 , 10 ,150 ,self.frame.size.height - 20)
        self.addSubview(mQuestionsButton)
        mQuestionsButton.contentHorizontalAlignment = UIControlContentHorizontalAlignment.Center
        mQuestionsButton.setTitleColor(standard_Button, forState: .Normal)
        mQuestionsButton.setTitle("No Question", forState: .Normal)
        mQuestionsButton.titleLabel?.font = UIFont(name: helveticaRegular, size: 20)
        mQuestionsButton.addTarget(self, action: #selector(LessonPlanMainViewCell.onSubtopicButton), forControlEvents: UIControlEvents.TouchUpInside)
        mQuestionsButton.layer.cornerRadius = (mSubTopicButton.frame.size.height)/3

        
      
        var remainingWidth = m_graspImageView.frame.size.width + m_graspImageView.frame.origin.x + mSubTopicButton.frame.size.width + mQuestionsButton.frame.size.width + 40
        
        remainingWidth = self.frame.size.width - remainingWidth
        
        
        
        
        
        
        m_MainTopicLabel = UILabel(frame: CGRectMake(m_graspImageView.frame.size.width + m_graspImageView.frame.origin.x + 10 , (self.frame.size.height - (self.frame.size.height / 1.3))/2  , remainingWidth, self.frame.size.height / 1.3 ))
        m_MainTopicLabel.font = UIFont(name:helveticaRegular, size: 18)
        self.addSubview(m_MainTopicLabel)
        m_MainTopicLabel.textColor = blackTextColor
        m_MainTopicLabel.textAlignment = .Left
        m_MainTopicLabel.lineBreakMode = .ByTruncatingMiddle
        
        
        m_progressView.userInteractionEnabled = false;
        self.addSubview(m_progressView)
        m_progressView.frame  = CGRectMake(0, self.frame.size.height - 3 , self.frame.size.width , 1)
        m_progressView.progressTintColor = standard_Button;
        let transform: CGAffineTransform = CGAffineTransformMakeScale(1.0, 2);
        m_progressView.transform = transform;
        
        
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setMainTopicDetails(topicDetails:AnyObject, withIndexPath indexPath:Int)
    {
        
        
        currentTopicDetails = topicDetails
        currentindexPath = indexPath

        if let topicId = currentTopicDetails.objectForKey("Id")as? String
        {
            mMainTopicId = topicId
            
            self.tag = Int(topicId)!
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
        
        
        
      
        
        
        
        
        var subTopicsDetails = NSMutableArray()
        
       
        
        
       if  let classCheckingVariable = currentTopicDetails.objectForKey("SubTopics")?.objectForKey("SubTopic")
       {
            if classCheckingVariable.isKindOfClass(NSMutableArray)
            {
                subTopicsDetails = classCheckingVariable as! NSMutableArray
            }
            else
            {
                subTopicsDetails.addObject(currentTopicDetails.objectForKey("SubTopics")!.objectForKey("SubTopic")!)
                
            }

        }
        
        
        
        
        
        if let Tagged = currentTopicDetails.objectForKey("Tagged") as? String
        {
            if Tagged == "1"
            {
                checkBoxImage.image = UIImage(named:"Checked.png");
                self.backgroundColor = UIColor.whiteColor()
                isSelected = true
                
                
                if subTopicsDetails.count > 0
                {
                    for index in 0..<subTopicsDetails.count
                    {
                        let subTopicDict = subTopicsDetails.objectAtIndex(index)
                      
                        if let s_Tagged = subTopicDict.objectForKey("Tagged") as? String
                        {
                            if s_Tagged == "0"
                            {
                                checkBoxImage.image = UIImage(named:"halfChecked.png");
                            }
                        }
                        
                        var questionDetails = NSMutableArray()
                        
                        if (subTopicDict.objectForKey("Questions") != nil)
                        {
                            let classCheckingVariable = subTopicDict.objectForKey("Questions")!.objectForKey("Question")!
                            
                            if classCheckingVariable.isKindOfClass(NSMutableArray)
                            {
                                questionDetails = classCheckingVariable as! NSMutableArray
                            }
                            else
                            {
                                questionDetails.addObject(subTopicDict.objectForKey("Questions")!.objectForKey("Question")!)
                                
                            }
                            
                            
                            if Int(questionDetails.count) <= 0
                            {
                                mQuestionsButton.setTitle("No Questions", forState: .Normal)
                                mQuestionsButton.enabled = false
                                mQuestionsButton.backgroundColor = lightGrayColor
                            }
                            else if Int(subTopicsDetails.count) == 1
                            {
                                mQuestionsButton.setTitle("\(subTopicsDetails.count) Question", forState: .Normal)
                            }
                            else
                            {
                                mQuestionsButton.setTitle("\(subTopicsDetails.count) Questions", forState: .Normal)
                            }
                        }
                        
                        
                        
                    }
                }
                
            }
            else
            {
                checkBoxImage.image = UIImage(named:"Unchecked.png");
                self.backgroundColor = UIColor.clearColor()
                isSelected = false
                
                
                for index in 0..<subTopicsDetails.count
                {
                    let subTopicDict = subTopicsDetails.objectAtIndex(index)
                    
                    var questionDetails = NSMutableArray()
                    
                    if (subTopicDict.objectForKey("Questions") != nil)
                    {
                        let classCheckingVariable = subTopicDict.objectForKey("Questions")!.objectForKey("Question")!
                        
                        if classCheckingVariable.isKindOfClass(NSMutableArray)
                        {
                            questionDetails = classCheckingVariable as! NSMutableArray
                        }
                        else
                        {
                            questionDetails.addObject(subTopicDict.objectForKey("Questions")!.objectForKey("Question")!)
                            
                        }
                        
                        
                        if Int(questionDetails.count) <= 0
                        {
                            mQuestionsButton.setTitle("No Questions", forState: .Normal)
                            mQuestionsButton.enabled = false
                            mQuestionsButton.backgroundColor = lightGrayColor
                        }
                        else if Int(subTopicsDetails.count) == 1
                        {
                            mQuestionsButton.setTitle("\(subTopicsDetails.count) Question", forState: .Normal)
                        }
                        else
                        {
                            mQuestionsButton.setTitle("\(subTopicsDetails.count) Questions", forState: .Normal)
                        }
                    }
                    
                }
                
                
            }
        }
        
        
        
        
        if Int(subTopicsDetails.count) <= 0
        {
            mSubTopicButton.setTitle("No Sub topics", forState: .Normal)
            mSubTopicButton.enabled = false
            mSubTopicButton.backgroundColor = lightGrayColor
        }
        else if Int(subTopicsDetails.count) == 1
        {
            mSubTopicButton.setTitle("\(subTopicsDetails.count) Sub topic", forState: .Normal)
        }
        else
        {
            mSubTopicButton.setTitle("\(subTopicsDetails.count) Sub topics", forState: .Normal)
        }

        
        
    }
    
    func onSubtopicButton()
    {
        if delegate().respondsToSelector(#selector(LessonPlanMainViewDelegate.delegateSubTopicCellPressedWithMainTopicDetails(_:withIndexValue:)))
        {
            delegate().delegateSubTopicCellPressedWithMainTopicDetails!(currentTopicDetails,withIndexValue:currentindexPath)
            mSubTopicButton.backgroundColor = standard_Green
        }
        
    }
    
    func checkMarkPressed()
    {
        
        var subTopicsDetails = NSMutableArray()
        
        if  let classCheckingVariable = currentTopicDetails.objectForKey("SubTopics")?.objectForKey("SubTopic")
        {
            if classCheckingVariable.isKindOfClass(NSMutableArray)
            {
                subTopicsDetails = classCheckingVariable as! NSMutableArray
            }
            else
            {
                subTopicsDetails.addObject(currentTopicDetails.objectForKey("SubTopics")!.objectForKey("SubTopic")!)
                
            }
            
        }

        
       
        
        
        
        
        if isSelected == true
        {
            for index in 0 ..< subTopicsDetails.count
            {
                let currentTopicDetails = subTopicsDetails.objectAtIndex(index)
                currentTopicDetails.setObject("0", forKey: "Tagged")
                subTopicsDetails.replaceObjectAtIndex(index, withObject: currentTopicDetails)
            }
            
             currentTopicDetails.setObject("0", forKey: "Tagged")
            currentTopicDetails.setObject(subTopicsDetails, forKey: "SubTopic")
            
            currentTopicDetails.setObject(currentTopicDetails, forKey: "SubTopics")
            
            checkBoxImage.image = UIImage(named:"Unchecked.png");
            self.backgroundColor = UIColor.clearColor()
            delegate().delegateMainTopicCheckMarkPressedWithState!(false, withIndexValue: currentindexPath, withCurrentTopicDatails: currentTopicDetails)
            isSelected = false
            
           
            
            
        }
        else
        {
            
            for index in 0 ..< subTopicsDetails.count 
            {
                let currentTopicDetails = subTopicsDetails.objectAtIndex(index)
                currentTopicDetails.setObject("1", forKey: "Tagged")
                subTopicsDetails.replaceObjectAtIndex(index, withObject: currentTopicDetails)
            }
            
             currentTopicDetails.setObject("1", forKey: "Tagged")
            currentTopicDetails.setObject(subTopicsDetails, forKey: "SubTopic")
            
            currentTopicDetails.setObject(currentTopicDetails, forKey: "SubTopics")
            
            
            checkBoxImage.image = UIImage(named:"Checked.png");
            self.backgroundColor = UIColor.whiteColor()
            delegate().delegateMainTopicCheckMarkPressedWithState!(true, withIndexValue: currentindexPath, withCurrentTopicDatails: currentTopicDetails)
            isSelected = true
        }
        
    }
    
    
}