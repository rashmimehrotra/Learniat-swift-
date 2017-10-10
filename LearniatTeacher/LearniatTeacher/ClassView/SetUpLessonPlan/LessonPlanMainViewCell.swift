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
    
    
    
    @objc optional func delegateSubTopicCellPressedWithMainTopicDetails(_ topicDetails:AnyObject, withCell topicCell:LessonPlanMainViewCell , withHeight height:CGFloat)
    
    
    @objc optional func delegateQuestionButtonPressedWithDetails(_ topicDetails:AnyObject)
    
}


class LessonPlanMainViewCell: UIView , LessonPlanSubTopicsViewDelegate,SSTeacherDataSourceDelegate
{
    
        let dateFormatter = DateFormatter()
    
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
        
        
        
        
        
         dateFormatter.dateFormat = "HH:mm:ss"
        
         mMainTopicView.frame = CGRect(x: 0, y: 0, width: self.frame.size.width ,height: self.frame.size.height)
        self.addSubview(mMainTopicView)
        mMainTopicView.backgroundColor = whiteBackgroundColor
        
        
        let button = UIButton(frame:CGRect(x: 0, y: 0, width: self.frame.size.width ,height: self.frame.size.height));
        mMainTopicView.addSubview(button)
         button.addTarget(self, action: #selector(LessonPlanMainViewCell.onSubtopicButton), for: UIControlEvents.touchUpInside)
        
        
        
        
         m_checkBoxButton = UIButton(frame:CGRect(x: 0, y: 0, width: self.frame.size.height ,height: self.frame.size.height));
        mMainTopicView.addSubview(m_checkBoxButton);
        m_checkBoxButton.backgroundColor = UIColor.white
       
        checkBoxImage.frame = CGRect(x: (m_checkBoxButton.frame.size.width - 20 )/2  , y: (m_checkBoxButton.frame.size.height - 20) / 2,width: 20,height: 20)
        checkBoxImage.image = UIImage(named:"Checked.png");
        mMainTopicView.addSubview(checkBoxImage);
        m_checkBoxButton.addTarget(self, action: #selector(LessonPlanMainViewCell.checkMarkPressed), for: UIControlEvents.touchUpInside)

        
        
        m_graspImageView.frame = CGRect(x: m_checkBoxButton.frame.size.width + m_checkBoxButton.frame.origin.x + 10, y: (self.frame.size.height - (self.frame.size.height / 1.8))/2 ,width: self.frame.size.height / 1.8,height: self.frame.size.height / 1.8)
        mMainTopicView.addSubview(m_graspImageView)
        m_graspImageView.image = UIImage(named: "00.png")
        m_graspImageView.contentMode = .scaleAspectFit
        
        
        mSubTopicButton.frame = CGRect(x: self.frame.size.width - 160 , y: 10 ,width: 150 ,height: self.frame.size.height - 20)
        mMainTopicView.addSubview(mSubTopicButton)
        mSubTopicButton.contentHorizontalAlignment = UIControlContentHorizontalAlignment.right
        mSubTopicButton.setTitleColor(standard_Button, for: UIControlState())
        mSubTopicButton.setTitle("No SubTopics", for: UIControlState())
        mSubTopicButton.titleLabel?.font = UIFont(name: helveticaRegular, size: 20)
        mSubTopicButton.addTarget(self, action: #selector(LessonPlanMainViewCell.onSubtopicButton), for: UIControlEvents.touchUpInside)
        mSubTopicButton.layer.cornerRadius = (mSubTopicButton.frame.size.height)/3
        
        
        
        
        mQuestionsButton.frame = CGRect(x: mSubTopicButton.frame.origin.x - 160 , y: 10 ,width: 150 ,height: self.frame.size.height - 20)
        mMainTopicView.addSubview(mQuestionsButton)
        mQuestionsButton.contentHorizontalAlignment = UIControlContentHorizontalAlignment.center
        mQuestionsButton.setTitleColor(standard_Green, for: UIControlState())
        mQuestionsButton.setTitle("No Question", for: UIControlState())
        mQuestionsButton.titleLabel?.font = UIFont(name: helveticaRegular, size: 20)
        mQuestionsButton.addTarget(self, action: #selector(LessonPlanMainViewCell.onSubtopicButton), for: UIControlEvents.touchUpInside)
        mQuestionsButton.layer.cornerRadius = (mSubTopicButton.frame.size.height)/3

        
      
        var remainingWidth = m_graspImageView.frame.size.width + m_graspImageView.frame.origin.x + mSubTopicButton.frame.size.width + mQuestionsButton.frame.size.width + 40
        
        remainingWidth = mMainTopicView.frame.size.width - remainingWidth
        
        
        
        
        
        
        m_MainTopicLabel = UILabel(frame: CGRect(x: m_graspImageView.frame.size.width + m_graspImageView.frame.origin.x + 10 , y: (self.frame.size.height - (self.frame.size.height / 1.3))/2  , width: remainingWidth, height: self.frame.size.height / 1.3 ))
        m_MainTopicLabel.font = UIFont(name:helveticaRegular, size: 18)
        mMainTopicView.addSubview(m_MainTopicLabel)
        m_MainTopicLabel.textColor = blackTextColor
        m_MainTopicLabel.textAlignment = .left
        m_MainTopicLabel.lineBreakMode = .byTruncatingMiddle
        
        
        m_progressView.isUserInteractionEnabled = false;
        mMainTopicView.addSubview(m_progressView)
        m_progressView.frame  = CGRect(x: m_graspImageView.frame.origin.x,y: m_MainTopicLabel.frame.origin.y + m_MainTopicLabel.frame.size.height - 5, width: self.frame.size.width - (m_graspImageView.frame.origin.x + 10) , height: 1)
        m_progressView.progressTintColor = standard_Button;
        let transform: CGAffineTransform = CGAffineTransform(scaleX: 1.0, y: 1.3);
        m_progressView.transform = transform;
        
        let lineView = UIImageView(frame:CGRect(x: 0, y: mMainTopicView.frame.size.height-1, width: mMainTopicView.frame.size.width, height: 1))
        lineView.backgroundColor = LineGrayColor
        mMainTopicView.addSubview(lineView)
        

        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - set mainTopic details functions
    func setMainTopicDetails(_ topicDetails:AnyObject, withIndexPath indexPath:Int)
    {
        
        
        currentTopicDetails = topicDetails
        currentindexPath = indexPath

        if let topicId = currentTopicDetails.object(forKey: "Id")as? String
        {
            mMainTopicId = topicId
            
            self.tag = Int(topicId)!
        }
        
        
        if var topicName = currentTopicDetails.object(forKey: "Name")as? String
        {
            topicName = topicName.capitalized
            
            if let CumulativeTime = currentTopicDetails.object(forKey: "CumulativeTime")as? String
            {
                m_MainTopicLabel.text = "\(topicName)(\(CumulativeTime))".capitalized
            }
            else
            {
                m_MainTopicLabel.text = "\(topicName)".capitalized
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
       
        
        getSubtopicsCountWithMainTopicsDetails(currentTopicDetails)
        
        let subTopicHeight:CGFloat = CGFloat(currentSubtopicsArray.count) * 55
        
        if SubTopicsView == nil
        {
            SubTopicsView = LessonPlanSubTopicsView(frame: CGRect(x: m_checkBoxButton.frame.origin.x + m_checkBoxButton.frame.size.width,y: mMainTopicView.frame.size.height,width: self.frame.size.width - (m_checkBoxButton.frame.origin.x + m_checkBoxButton.frame.size.width),height: subTopicHeight ))
            SubTopicsView.setSubtopicsArray(currentSubtopicsArray, withSelectedState: isSelected)
            SubTopicsView.setdelegate(self)
            self.addSubview(SubTopicsView)
            SubTopicsView.isHidden = true
        }
        
        
    }
    
    
    
    func getSubtopicsCountWithMainTopicsDetails(_ _mainTopicDetails:AnyObject)->NSMutableArray
    {
       
        var subTopicsDetails = NSMutableArray()
        
        
        
        if  let classCheckingVariable = _mainTopicDetails.object(forKey: "SubTopics") as? NSMutableDictionary
        {
            if  let classCheckingVariable = classCheckingVariable.object(forKey: "SubTopic") as? NSMutableArray
            {
                subTopicsDetails = classCheckingVariable
                
                
            }
            else if let questionVariable = classCheckingVariable.object(forKey: "SubTopic") as? NSMutableDictionary
            {
                subTopicsDetails.add(questionVariable)
                
            }
        }
        
        
//        if  let classCheckingVariable = (_mainTopicDetails.object(forKey: "SubTopics") as AnyObject).object(forKey: "SubTopic") as? NSMutableArray
//        {
//           subTopicsDetails = classCheckingVariable
//        }
//        else
//        {
//            subTopicsDetails.add((_mainTopicDetails.object(forKey: "SubTopics")! as AnyObject).object(forKey: "SubTopic")!)
//            
//        }
//        
        
        
        currentSubtopicsArray = subTopicsDetails
        
        if let Tagged = currentTopicDetails.object(forKey: "Tagged") as? String
        {
            if Tagged == "1"
            {
                selectSubtopicsWithState(true)
                checkBoxImage.image = UIImage(named:"Checked.png");

                isSelected = true
                
                for index in 0..<subTopicsDetails.count
                {
                    let subTopicDict = subTopicsDetails.object(at: index)
                    
                    if let s_Tagged = (subTopicDict as AnyObject).object(forKey: "Tagged") as? String
                    {
                        if s_Tagged == "0"
                        {
                            checkBoxImage.image = UIImage(named:"halfChecked.png");
                            
                            if let topicId = (subTopicDict as AnyObject).object(forKey: "Id")as? String
                            {
                                if SSTeacherDataSource.sharedDataSource.taggedTopicIdArray.contains(topicId) == true
                                {
                                    SSTeacherDataSource.sharedDataSource.taggedTopicIdArray.remove(topicId)
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
            mSubTopicButton.setTitle("No Sub topics", for: UIControlState())
            mSubTopicButton.isEnabled = false
            mSubTopicButton.setTitleColor(lightGrayColor, for: UIControlState())
        }
        else if Int(subTopicsDetails.count) == 1
        {
            mSubTopicButton.setTitle("\(subTopicsDetails.count) Sub topic", for: UIControlState())
        }
        else
        {
            mSubTopicButton.setTitle("\(subTopicsDetails.count) Sub topics", for: UIControlState())
        }
        
        return subTopicsDetails
    }
    
    
    func getQuestionsCountWithSubTopicDetails(_ subTopicsDetails:NSMutableArray)
    {
        
        
        var questionsCount = 0
        
        for index in 0..<subTopicsDetails.count
        {
            let subTopicDict = subTopicsDetails.object(at: index)
            
            var questionDetails = NSMutableArray()
            
            if ((subTopicDict as AnyObject).object(forKey: "Questions") != nil)
            {
               if  let classCheckingVariable = ((subTopicDict as AnyObject).object(forKey: "Questions")! as AnyObject).object(forKey: "Question") as? NSMutableArray
               {
                    questionDetails = classCheckingVariable
                }
                
                else
                {
                    questionDetails.add(((subTopicDict as AnyObject).object(forKey: "Questions")! as AnyObject).object(forKey: "Question")!)
                    
                }
            }
            
            questionsCount = questionsCount + questionDetails.count
            
        }
        
        
          mQuestionsButton.setTitleColor(standard_Green, for: UIControlState())
        
        if questionsCount <= 0
        {
            mQuestionsButton.setTitle("No Questions", for: UIControlState())
            mQuestionsButton.isEnabled = false
              mQuestionsButton.setTitleColor(lightGrayColor, for: UIControlState())
        }
        else if questionsCount == 1
        {
            mQuestionsButton.setTitle("\(questionsCount) Question", for: UIControlState())
        }
        else
        {
            mQuestionsButton.setTitle("\(questionsCount) Questions", for: UIControlState())
        }
        
    }
    
    
    // MARK: - Buttons functions
    func onSubtopicButton()
    {
    
        
        var subTopicHeight:CGFloat = CGFloat(currentSubtopicsArray.count) * 55
        
         if SubTopicsView.isHidden == false
         {
            SubTopicsView.isHidden = true
            
            subTopicHeight = mMainTopicView.frame.size.height
         }
        else
        {
            SubTopicsView.isHidden = false
            subTopicHeight = mMainTopicView.frame.size.height + subTopicHeight
            
        }
        
        if delegate().responds(to: #selector(LessonPlanMainViewDelegate.delegateSubTopicCellPressedWithMainTopicDetails(_:withCell:withHeight:)))
        {
            delegate().delegateSubTopicCellPressedWithMainTopicDetails!(currentTopicDetails, withCell: self, withHeight: subTopicHeight)
        }
        
    }
    
    
    func onQuestionButton()
    {
        if delegate().responds(to: #selector(LessonPlanMainViewDelegate.delegateQuestionButtonPressedWithDetails(_:)))
        {
            delegate().delegateQuestionButtonPressedWithDetails!(currentTopicDetails)
        }
    }
    
    func delegateSubTopicViewQuestionButtonPressedwithDetails(_ subTopicDetails: AnyObject)
    {
        if delegate().responds(to: #selector(LessonPlanMainViewDelegate.delegateQuestionButtonPressedWithDetails(_:)))
        {
            delegate().delegateQuestionButtonPressedWithDetails!(subTopicDetails)
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
    
    func delegateCellStatewithChecMarkState(_ checkMark: Int)
    {
        if checkMark == 0
        {
            checkBoxImage.image = UIImage(named:"Unchecked.png");
            isSelected = false
            if let topicId = currentTopicDetails.object(forKey: "Id")as? String
            {
                if SSTeacherDataSource.sharedDataSource.taggedTopicIdArray.contains(topicId) == true
                {
                    SSTeacherDataSource.sharedDataSource.taggedTopicIdArray.remove(topicId)
                }
            }
        }
        else if checkMark == 1
        {
            checkBoxImage.image = UIImage(named:"Checked.png");
            if let topicId = currentTopicDetails.object(forKey: "Id")as? String
            {
                
                if SSTeacherDataSource.sharedDataSource.taggedTopicIdArray.contains(topicId) == false
                {
                    SSTeacherDataSource.sharedDataSource.taggedTopicIdArray.add(topicId)
                }
            }
            isSelected = true
        }
        else
        {
            checkBoxImage.image = UIImage(named:"halfChecked.png");
            
            if let topicId = currentTopicDetails.object(forKey: "Id")as? String
            {
                
                if SSTeacherDataSource.sharedDataSource.taggedTopicIdArray.contains(topicId) == false
                {
                    SSTeacherDataSource.sharedDataSource.taggedTopicIdArray.add(topicId)
                }
            }
            
            isSelected = true
        }
    }
    
    
    // MARK: - Extra func functions
    
    func selectSubtopicsWithState(_ selected:Bool)
    {
        
        if let topicId = currentTopicDetails.object(forKey: "Id")as? String
        {
            
                if selected == true
                {
                    if SSTeacherDataSource.sharedDataSource.taggedTopicIdArray.contains(topicId) == false
                    {
                        SSTeacherDataSource.sharedDataSource.taggedTopicIdArray.add(topicId)
                    }
                    
                }
                else
                {
                    if SSTeacherDataSource.sharedDataSource.taggedTopicIdArray.contains(topicId) == true
                    {
                        SSTeacherDataSource.sharedDataSource.taggedTopicIdArray.remove(topicId)
                    }
                    
                }
            }
        
        
        
        for index in 0 ..< currentSubtopicsArray.count
        {
            let TopicDetails = currentSubtopicsArray.object(at: index)
            
            
            if let topicId = (TopicDetails as AnyObject).object(forKey: "Id")as? String
            {
                if selected == true
                {
                    if SSTeacherDataSource.sharedDataSource.taggedTopicIdArray.contains(topicId) == false
                    {
                        SSTeacherDataSource.sharedDataSource.taggedTopicIdArray.add(topicId)
                    }
                    
                }
                else
                {
                    if SSTeacherDataSource.sharedDataSource.taggedTopicIdArray.contains(topicId) == true
                    {
                        SSTeacherDataSource.sharedDataSource.taggedTopicIdArray.remove(topicId)
                    }
                    
                }
            }
        }
    }
    
    
     // MARK: - Searching functions
    func searchingForTextInmainTopicWithText(_ searchtext:String)
    {
        m_MainTopicLabel.attributedText = searchtext.getAttributeText(m_MainTopicLabel.text!.capitalized, withSubString: searchtext.capitalized)
        
        
        if SubTopicsView != nil
        {
            SubTopicsView.searchTopicNameWithSearchText(searchtext)
        }
        
    }
    
    
    
    
}
