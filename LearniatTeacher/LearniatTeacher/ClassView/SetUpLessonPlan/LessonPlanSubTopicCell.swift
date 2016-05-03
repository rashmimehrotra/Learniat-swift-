//
//  LessonPlanSubTopicCell.swift
//  LearniatTeacher
//
//  Created by mindshift_Deepak on 16/04/16.
//  Copyright © 2016 Mindshift. All rights reserved.
//

import Foundation
@objc protocol  LessonPlanSubTopicCellDelegate
{
    
    
    
    optional func delegateQuestionPressedWithSubTopicDetails(topicDetails:AnyObject)
    
    optional func delegateSubtopicCellCheckMarkPressed()
}


class  LessonPlanSubTopicCell: UIView{
    
    let dateFormatter = NSDateFormatter()
    
    var m_graspImageView    = UIImageView()
    
    var m_MainTopicLabel    = UILabel()
    
    var mSubTopicButton     = UIButton()
    
    var mMainTopicId          = "0"
    
    let checkBoxImage       = UIImageView()
    
    var m_progressView      = UIProgressView()
    
    var currentTopicDetails :AnyObject!
    
    
    var     isSelected          = true
    
    var _delgate: AnyObject!
    
    
    var m_checkBoxButton :UIButton!
    
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
        
        
       
        self.backgroundColor = whiteBackgroundColor
        
        
        let button = UIButton(frame:CGRectMake(0, 0, self.frame.size.width ,self.frame.size.height));
        self.addSubview(button)
        button.addTarget(self, action: #selector(LessonPlanMainViewCell.checkMarkPressed), forControlEvents: UIControlEvents.TouchUpInside)
        

        
        
        m_checkBoxButton = UIButton(frame:CGRectMake(0, 0, self.frame.size.height ,self.frame.size.height));
        self.addSubview(m_checkBoxButton);
        m_checkBoxButton.backgroundColor = UIColor.whiteColor()
         m_checkBoxButton.addTarget(self, action: #selector(LessonPlanMainViewCell.checkMarkPressed), forControlEvents: UIControlEvents.TouchUpInside)
        checkBoxImage.frame = CGRectMake((m_checkBoxButton.frame.size.width - 20 )/2  , (m_checkBoxButton.frame.size.height - 20) / 2,20,20)
        checkBoxImage.image = UIImage(named:"Checked.png");
        self.addSubview(checkBoxImage);
        
        
        
        
        m_graspImageView.frame = CGRectMake(m_checkBoxButton.frame.size.width + m_checkBoxButton.frame.origin.x + 10, (self.frame.size.height - (self.frame.size.height / 1.8))/2 ,self.frame.size.height / 1.8,self.frame.size.height / 1.8)
        self.addSubview(m_graspImageView)
        m_graspImageView.image = UIImage(named: "00.png")
        m_graspImageView.contentMode = .ScaleAspectFit
        

        
        
        mSubTopicButton.frame = CGRectMake(self.frame.size.width - 160 , 10 ,150 ,self.frame.size.height - 20)
        self.addSubview(mSubTopicButton)
        mSubTopicButton.contentHorizontalAlignment = UIControlContentHorizontalAlignment.Right
        mSubTopicButton.setTitleColor(standard_Green, forState: .Normal)
        mSubTopicButton.setTitle("No Questions", forState: .Normal)
        mSubTopicButton.titleLabel?.font = UIFont(name: helveticaRegular, size: 18)
        mSubTopicButton.addTarget(self, action: #selector(LessonPlanSubTopicCell.onSubtopicButton), forControlEvents: UIControlEvents.TouchUpInside)
        mSubTopicButton.layer.cornerRadius = (mSubTopicButton.frame.size.height)/3
        
        
        var remainingWidth = m_graspImageView.frame.size.width + m_graspImageView.frame.origin.x + mSubTopicButton.frame.size.width + 30
        
        remainingWidth = self.frame.size.width - remainingWidth
        
        
        
        
        
        
        m_MainTopicLabel = UILabel(frame: CGRectMake(m_graspImageView.frame.size.width + m_graspImageView.frame.origin.x + 10 , (self.frame.size.height - (self.frame.size.height / 1.3))/2  , remainingWidth, self.frame.size.height / 1.3 ))
        m_MainTopicLabel.font = UIFont(name:helveticaRegular, size: 16)
        self.addSubview(m_MainTopicLabel)
        m_MainTopicLabel.textColor = blackTextColor
        m_MainTopicLabel.textAlignment = .Left
        m_MainTopicLabel.lineBreakMode = .ByTruncatingMiddle
        
        
        
        m_progressView.userInteractionEnabled = false;
        self.addSubview(m_progressView)
        m_progressView.frame  = CGRectMake(m_graspImageView.frame.origin.x,m_MainTopicLabel.frame.origin.y + m_MainTopicLabel.frame.size.height - 5, self.frame.size.width - (m_graspImageView.frame.origin.x + 10) , 1)
        m_progressView.progressTintColor = standard_Button;
        let transform: CGAffineTransform = CGAffineTransformMakeScale(1.0, 1.3);
        m_progressView.transform = transform;
        
        
        let lineView = UIImageView(frame:CGRectMake(0, self.frame.size.height-1, self.frame.size.width, 1))
        lineView.backgroundColor = LineGrayColor
        self.addSubview(lineView)
        
        
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setSubTopicTopicDetails(topicDetails:AnyObject , withSelectedState selectedState:Bool)
    {
        
        currentTopicDetails = topicDetails
        
        if let topicId = currentTopicDetails.objectForKey("Id")as? String
        {
                mMainTopicId = topicId
                  self.tag = Int(topicId)!
            
            
            
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
            
            
            
            
            if let Tagged = currentTopicDetails.objectForKey("Tagged") as? String
            {
                if Tagged == "1"
                {
                    checkBoxImage.image = UIImage(named:"Checked.png");
                    isSelected = true
                    
                    
                    if SSTeacherDataSource.sharedDataSource.taggedTopicIdArray.containsObject(topicId) == false
                    {
                        SSTeacherDataSource.sharedDataSource.taggedTopicIdArray.addObject(topicId)
                    }
                    
                }
                else
                {
                    checkBoxImage.image = UIImage(named:"Unchecked.png");
                    isSelected = false
                    
                    if SSTeacherDataSource.sharedDataSource.taggedTopicIdArray.containsObject(topicId) == true
                    {
                        SSTeacherDataSource.sharedDataSource.taggedTopicIdArray.removeObject(topicId)
                    }

                }
            }
            
            if selectedState == true
            {
                checkBoxImage.image = UIImage(named:"Checked.png");
                isSelected = true
                
                
                if SSTeacherDataSource.sharedDataSource.taggedTopicIdArray.containsObject(topicId) == false
                {
                    SSTeacherDataSource.sharedDataSource.taggedTopicIdArray.addObject(topicId)
                }
            }
            else
            {
                checkBoxImage.image = UIImage(named:"Unchecked.png");
                isSelected = false
                
                if SSTeacherDataSource.sharedDataSource.taggedTopicIdArray.containsObject(topicId) == true
                {
                    SSTeacherDataSource.sharedDataSource.taggedTopicIdArray.removeObject(topicId)
                }
            }
        
            
        }
        
        
        
        
        
        
        
        var subTopicsDetails = NSMutableArray()
        
        
        
        
        if  let classCheckingVariable = currentTopicDetails.objectForKey("Questions")?.objectForKey("Question")
        {
            if classCheckingVariable.isKindOfClass(NSMutableArray)
            {
                subTopicsDetails = classCheckingVariable as! NSMutableArray
            }
            else
            {
                subTopicsDetails.addObject(currentTopicDetails.objectForKey("Questions")!.objectForKey("Question")!)
                
            }
            
        }
        
        mSubTopicButton.setTitleColor(standard_Green, forState: .Normal)
        
        if Int(subTopicsDetails.count) <= 0
        {
            mSubTopicButton.setTitle("No Questions", forState: .Normal)
            mSubTopicButton.enabled = false
            mSubTopicButton.setTitleColor(lightGrayColor, forState: .Normal)

        }
        else if Int(subTopicsDetails.count) == 1
        {
            mSubTopicButton.setTitle("\(subTopicsDetails.count) Question", forState: .Normal)
        }
        else
        {
            mSubTopicButton.setTitle("\(subTopicsDetails.count) Questions", forState: .Normal)
        }
        
        
        
    }
    
    func onSubtopicButton()
    {
        if delegate().respondsToSelector(#selector(LessonPlanSubTopicCellDelegate.delegateQuestionPressedWithSubTopicDetails(_:)))
        {
            delegate().delegateQuestionPressedWithSubTopicDetails!(currentTopicDetails)
            mSubTopicButton.setTitleColor(standard_Green, forState: .Normal)
        }
        
    }
    
    func checkMarkPressed()
    {
        if delegate().respondsToSelector(#selector(LessonPlanSubTopicCellDelegate.delegateSubtopicCellCheckMarkPressed))
        {
           
            if isSelected == true
            {
                unselectCell()
            }
            else
            {
                selectCell()
            }
        }
        
        delegate().delegateSubtopicCellCheckMarkPressed!()
    }
    
    func selectCell()
    {
        if let topicId = currentTopicDetails.objectForKey("Id")as? String
        {
            checkBoxImage.image = UIImage(named:"Checked.png");
            isSelected = true
            if SSTeacherDataSource.sharedDataSource.taggedTopicIdArray.containsObject(topicId) == false
            {
                SSTeacherDataSource.sharedDataSource.taggedTopicIdArray.addObject(topicId)
            }
        }
    }
    
    func unselectCell()
    {
        if let topicId = currentTopicDetails.objectForKey("Id")as? String
        {
            checkBoxImage.image = UIImage(named:"Unchecked.png");
            isSelected = false
            
            if SSTeacherDataSource.sharedDataSource.taggedTopicIdArray.containsObject(topicId) == true
            {
                SSTeacherDataSource.sharedDataSource.taggedTopicIdArray.removeObject(topicId)
            }
        }
        
    }
    
    // MARK: - Searching functions
    func searchingForTextInmainTopicWithText(searchtext:String)
    {
        m_MainTopicLabel.attributedText = searchtext.getAttributeText(m_MainTopicLabel.text!.capitalizedString, withSubString: searchtext.capitalizedString)
//        if searchtext.isAttributeFound(m_MainTopicLabel.text!.capitalizedString, withSubString: searchtext.capitalizedString) == true
//        {
//            
//        }
        
        
    }
    
    
}
    
    
    

    
    
