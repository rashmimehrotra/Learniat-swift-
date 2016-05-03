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
    
    
    
    optional func delegateSubTopicCellPressedWithMainTopicDetails(topicDetails:AnyObject, withCell topicCell:LessonPlanMainViewCell , withHeight height:CGFloat)
    
}


class LessonPlanMainViewCell: UIView , LessonPlanSubTopicsViewDelegate
{
    
        let dateFormatter = NSDateFormatter()
    
    var m_graspImageView    = UIImageView()
    
    var m_MainTopicLabel    = UILabel()
    
    var mSubTopicButton     = UIButton()
    
    
    var mQuestionsButton     = UIButton()
    
    var mMainTopicId          = "0"
    
     let checkBoxImage       = UIImageView()
    
    var m_progressView      = UIProgressView()
    
    var currentTopicDetails :AnyObject!
    
    let mMainTopicView = UIView()
    
    var  isSelected             = true
    
    var _delgate: AnyObject!
    
    var m_checkBoxButton :UIButton!
    
    
    var currentSubtopicsArray = NSMutableArray()
    
    var currentindexPath    = 0
    
    var SubTopicsView :LessonPlanSubTopicsView!
    
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
        
         mMainTopicView.frame = CGRectMake(0, 0, self.frame.size.width ,self.frame.size.height)
        self.addSubview(mMainTopicView)
        mMainTopicView.backgroundColor = whiteBackgroundColor
        
        
        let button = UIButton(frame:CGRectMake(0, 0, self.frame.size.width ,self.frame.size.height));
        mMainTopicView.addSubview(button)
         button.addTarget(self, action: #selector(LessonPlanMainViewCell.onSubtopicButton), forControlEvents: UIControlEvents.TouchUpInside)
        
        
        
        
         m_checkBoxButton = UIButton(frame:CGRectMake(0, 0, self.frame.size.height ,self.frame.size.height));
        mMainTopicView.addSubview(m_checkBoxButton);
        m_checkBoxButton.backgroundColor = UIColor.whiteColor()
       
        checkBoxImage.frame = CGRectMake((m_checkBoxButton.frame.size.width - 20 )/2  , (m_checkBoxButton.frame.size.height - 20) / 2,20,20)
        checkBoxImage.image = UIImage(named:"Checked.png");
        mMainTopicView.addSubview(checkBoxImage);
        m_checkBoxButton.addTarget(self, action: #selector(LessonPlanMainViewCell.checkMarkPressed), forControlEvents: UIControlEvents.TouchUpInside)

        
        
        m_graspImageView.frame = CGRectMake(m_checkBoxButton.frame.size.width + m_checkBoxButton.frame.origin.x + 10, (self.frame.size.height - (self.frame.size.height / 1.8))/2 ,self.frame.size.height / 1.8,self.frame.size.height / 1.8)
        mMainTopicView.addSubview(m_graspImageView)
        m_graspImageView.image = UIImage(named: "00.png")
        m_graspImageView.contentMode = .ScaleAspectFit
        
        
        mSubTopicButton.frame = CGRectMake(self.frame.size.width - 160 , 10 ,150 ,self.frame.size.height - 20)
        mMainTopicView.addSubview(mSubTopicButton)
        mSubTopicButton.contentHorizontalAlignment = UIControlContentHorizontalAlignment.Right
        mSubTopicButton.setTitleColor(standard_Button, forState: .Normal)
        mSubTopicButton.setTitle("No SubTopics", forState: .Normal)
        mSubTopicButton.titleLabel?.font = UIFont(name: helveticaRegular, size: 20)
        mSubTopicButton.addTarget(self, action: #selector(LessonPlanMainViewCell.onSubtopicButton), forControlEvents: UIControlEvents.TouchUpInside)
        mSubTopicButton.layer.cornerRadius = (mSubTopicButton.frame.size.height)/3
        
        
        
        
        mQuestionsButton.frame = CGRectMake(mSubTopicButton.frame.origin.x - 160 , 10 ,150 ,self.frame.size.height - 20)
        mMainTopicView.addSubview(mQuestionsButton)
        mQuestionsButton.contentHorizontalAlignment = UIControlContentHorizontalAlignment.Center
        mQuestionsButton.setTitleColor(standard_Green, forState: .Normal)
        mQuestionsButton.setTitle("No Question", forState: .Normal)
        mQuestionsButton.titleLabel?.font = UIFont(name: helveticaRegular, size: 20)
        mQuestionsButton.addTarget(self, action: #selector(LessonPlanMainViewCell.onSubtopicButton), forControlEvents: UIControlEvents.TouchUpInside)
        mQuestionsButton.layer.cornerRadius = (mSubTopicButton.frame.size.height)/3

        
      
        var remainingWidth = m_graspImageView.frame.size.width + m_graspImageView.frame.origin.x + mSubTopicButton.frame.size.width + mQuestionsButton.frame.size.width + 40
        
        remainingWidth = mMainTopicView.frame.size.width - remainingWidth
        
        
        
        
        
        
        m_MainTopicLabel = UILabel(frame: CGRectMake(m_graspImageView.frame.size.width + m_graspImageView.frame.origin.x + 10 , (self.frame.size.height - (self.frame.size.height / 1.3))/2  , remainingWidth, self.frame.size.height / 1.3 ))
        m_MainTopicLabel.font = UIFont(name:helveticaRegular, size: 18)
        mMainTopicView.addSubview(m_MainTopicLabel)
        m_MainTopicLabel.textColor = blackTextColor
        m_MainTopicLabel.textAlignment = .Left
        m_MainTopicLabel.lineBreakMode = .ByTruncatingMiddle
        
        
        m_progressView.userInteractionEnabled = false;
        mMainTopicView.addSubview(m_progressView)
        m_progressView.frame  = CGRectMake(m_graspImageView.frame.origin.x,m_MainTopicLabel.frame.origin.y + m_MainTopicLabel.frame.size.height - 5, self.frame.size.width - (m_graspImageView.frame.origin.x + 10) , 1)
        m_progressView.progressTintColor = standard_Button;
        let transform: CGAffineTransform = CGAffineTransformMakeScale(1.0, 1.3);
        m_progressView.transform = transform;
        
        let lineView = UIImageView(frame:CGRectMake(0, mMainTopicView.frame.size.height-1, mMainTopicView.frame.size.width, 1))
        lineView.backgroundColor = LineGrayColor
        mMainTopicView.addSubview(lineView)
        

        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - set mainTopic details functions
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
       
        
         getSubtopicsCountWithMainTopicsDetails(currentTopicDetails)
        
        
        
        
        let subTopicHeight:CGFloat = CGFloat(currentSubtopicsArray.count) * 55
        
        if SubTopicsView == nil
        {
            SubTopicsView = LessonPlanSubTopicsView(frame: CGRectMake(m_checkBoxButton.frame.origin.x + m_checkBoxButton.frame.size.width,mMainTopicView.frame.size.height,self.frame.size.width - (m_checkBoxButton.frame.origin.x + m_checkBoxButton.frame.size.width),subTopicHeight ))
            SubTopicsView.setSubtopicsArray(currentSubtopicsArray, withSelectedState: isSelected)
            SubTopicsView.setdelegate(self)
            self.addSubview(SubTopicsView)
            SubTopicsView.hidden = true
        }
        
        
    }
    
    
    
    func getSubtopicsCountWithMainTopicsDetails(_mainTopicDetails:AnyObject)->NSMutableArray
    {
       
        var subTopicsDetails = NSMutableArray()
        
        if  let classCheckingVariable = _mainTopicDetails.objectForKey("SubTopics")?.objectForKey("SubTopic")
        {
            if classCheckingVariable.isKindOfClass(NSMutableArray)
            {
                subTopicsDetails = classCheckingVariable as! NSMutableArray
            }
            else
            {
                subTopicsDetails.addObject(_mainTopicDetails.objectForKey("SubTopics")!.objectForKey("SubTopic")!)
                
            }
            
        }
        
        
        
        currentSubtopicsArray = subTopicsDetails
        
        if let Tagged = currentTopicDetails.objectForKey("Tagged") as? String
        {
            if Tagged == "1"
            {
                selectSubtopicsWithState(true)
                checkBoxImage.image = UIImage(named:"Checked.png");

                isSelected = true
                
                for index in 0..<subTopicsDetails.count
                {
                    let subTopicDict = subTopicsDetails.objectAtIndex(index)
                    
                    if let s_Tagged = subTopicDict.objectForKey("Tagged") as? String
                    {
                        if s_Tagged == "0"
                        {
                            checkBoxImage.image = UIImage(named:"halfChecked.png");
                            
                            if let topicId = subTopicDict.objectForKey("Id")as? String
                            {
                                if SSTeacherDataSource.sharedDataSource.taggedTopicIdArray.containsObject(topicId) == true
                                {
                                    SSTeacherDataSource.sharedDataSource.taggedTopicIdArray.removeObject(topicId)
                                }
                            }
                            
                        }
                    }
                }
                
                
            }
            else
            {
                checkBoxImage.image = UIImage(named:"Unchecked.png");
                selectSubtopicsWithState(false)
                isSelected = false
                
            }
            
            
        }
        
        getQuestionsCountWithSubTopicDetails(subTopicsDetails)
        
        
        
        
        
        
        if Int(subTopicsDetails.count) <= 0
        {
            mSubTopicButton.setTitle("No Sub topics", forState: .Normal)
            mSubTopicButton.enabled = false
            mSubTopicButton.setTitleColor(lightGrayColor, forState: .Normal)
        }
        else if Int(subTopicsDetails.count) == 1
        {
            mSubTopicButton.setTitle("\(subTopicsDetails.count) Sub topic", forState: .Normal)
        }
        else
        {
            mSubTopicButton.setTitle("\(subTopicsDetails.count) Sub topics", forState: .Normal)
        }
        
        return subTopicsDetails
    }
    
    
    func getQuestionsCountWithSubTopicDetails(subTopicsDetails:NSMutableArray)
    {
        
        
        var questionsCount = 0
        
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
            }
            
            questionsCount = questionsCount + questionDetails.count
            
        }
        
        
          mQuestionsButton.setTitleColor(standard_Green, forState: .Normal)
        
        if questionsCount <= 0
        {
            mQuestionsButton.setTitle("No Questions", forState: .Normal)
            mQuestionsButton.enabled = false
              mQuestionsButton.setTitleColor(lightGrayColor, forState: .Normal)
        }
        else if questionsCount == 1
        {
            mQuestionsButton.setTitle("\(questionsCount) Question", forState: .Normal)
        }
        else
        {
            mQuestionsButton.setTitle("\(questionsCount) Questions", forState: .Normal)
        }
        
    }
    
    
    // MARK: - Buttons functions
    func onSubtopicButton()
    {
        
        
        
        
        var subTopicHeight:CGFloat = CGFloat(currentSubtopicsArray.count) * 55
        
         if SubTopicsView.hidden == false
         {
            SubTopicsView.hidden = true
            
            subTopicHeight = mMainTopicView.frame.size.height
            
         }
        else
        {
            SubTopicsView.hidden = false
            subTopicHeight = mMainTopicView.frame.size.height + subTopicHeight
            
        }
        
        
        
        
        
        

        if delegate().respondsToSelector(#selector(LessonPlanMainViewDelegate.delegateSubTopicCellPressedWithMainTopicDetails(_:withCell:withHeight:)))
        {
            delegate().delegateSubTopicCellPressedWithMainTopicDetails!(currentTopicDetails, withCell: self, withHeight: subTopicHeight)
        }
        
    }
    
    func checkMarkPressed()
    {
        if isSelected == true
        {
            
            selectSubtopicsWithState(false)
            
            checkBoxImage.image = UIImage(named:"Unchecked.png");
            isSelected = false
            
            if SubTopicsView != nil
            {
                SubTopicsView.checkMarkStateChangedWithState(false)
                
            }
            
            
        }
        else
        {
            selectSubtopicsWithState(true)
            checkBoxImage.image = UIImage(named:"Checked.png");
            isSelected = true
            if SubTopicsView != nil
            {
                SubTopicsView.checkMarkStateChangedWithState(true)
                
            }
        }
        
    }
    
    // MARK: - SubTopicDelegate  functions
    
    func delegateCellStatewithChecMarkState(checkMark: Int)
    {
        if checkMark == 0
        {
            checkBoxImage.image = UIImage(named:"Unchecked.png");
            isSelected = false
            if let topicId = currentTopicDetails.objectForKey("Id")as? String
            {
                if SSTeacherDataSource.sharedDataSource.taggedTopicIdArray.containsObject(topicId) == true
                {
                    SSTeacherDataSource.sharedDataSource.taggedTopicIdArray.removeObject(topicId)
                }
            }
        }
        else if checkMark == 1
        {
            checkBoxImage.image = UIImage(named:"Checked.png");
            if let topicId = currentTopicDetails.objectForKey("Id")as? String
            {
                
                if SSTeacherDataSource.sharedDataSource.taggedTopicIdArray.containsObject(topicId) == false
                {
                    SSTeacherDataSource.sharedDataSource.taggedTopicIdArray.addObject(topicId)
                }
            }
            isSelected = true
        }
        else
        {
            checkBoxImage.image = UIImage(named:"halfChecked.png");
            
            if let topicId = currentTopicDetails.objectForKey("Id")as? String
            {
                
                if SSTeacherDataSource.sharedDataSource.taggedTopicIdArray.containsObject(topicId) == false
                {
                    SSTeacherDataSource.sharedDataSource.taggedTopicIdArray.addObject(topicId)
                }
            }
            
            isSelected = true
        }
    }
    
    
    // MARK: - Extra func functions
    
    func selectSubtopicsWithState(selected:Bool)
    {
        
        if let topicId = currentTopicDetails.objectForKey("Id")as? String
        {
            
                if selected == true
                {
                    if SSTeacherDataSource.sharedDataSource.taggedTopicIdArray.containsObject(topicId) == false
                    {
                        SSTeacherDataSource.sharedDataSource.taggedTopicIdArray.addObject(topicId)
                    }
                    
                }
                else
                {
                    if SSTeacherDataSource.sharedDataSource.taggedTopicIdArray.containsObject(topicId) == true
                    {
                        SSTeacherDataSource.sharedDataSource.taggedTopicIdArray.removeObject(topicId)
                    }
                    
                }
            }
        
        
        
        for index in 0 ..< currentSubtopicsArray.count
        {
            let TopicDetails = currentSubtopicsArray.objectAtIndex(index)
            
            
            if let topicId = TopicDetails.objectForKey("Id")as? String
            {
                if selected == true
                {
                    if SSTeacherDataSource.sharedDataSource.taggedTopicIdArray.containsObject(topicId) == false
                    {
                        SSTeacherDataSource.sharedDataSource.taggedTopicIdArray.addObject(topicId)
                    }
                    
                }
                else
                {
                    if SSTeacherDataSource.sharedDataSource.taggedTopicIdArray.containsObject(topicId) == true
                    {
                        SSTeacherDataSource.sharedDataSource.taggedTopicIdArray.removeObject(topicId)
                    }
                    
                }
            }
        }
    }
    
    
     // MARK: - Searching functions
    func searchingForTextInmainTopicWithText(searchtext:String)
    {
        m_MainTopicLabel.attributedText = searchtext.getAttributeText(m_MainTopicLabel.text!.capitalizedString, withSubString: searchtext.capitalizedString)
        
        
        if SubTopicsView != nil
        {
            SubTopicsView.searchTopicNameWithSearchText(searchtext)
        }
        
    }
    
    
    
    
}