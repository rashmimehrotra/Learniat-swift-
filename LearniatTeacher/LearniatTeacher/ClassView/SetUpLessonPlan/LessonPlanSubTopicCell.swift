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
    
    
    
    @objc optional func delegateQuestionPressedWithSubTopicDetails(_ topicDetails:AnyObject)
    
    @objc optional func delegateSubtopicCellCheckMarkPressed()
}


class  LessonPlanSubTopicCell: UIView{
    
    let dateFormatter = DateFormatter()
    
    var m_graspImageView    = UIImageView()
    
    var m_MainTopicLabel    = UILabel()
    
    var mSubTopicButton     = UIButton()
    
    var mSubTopicTagStatus     = UILabel()
    
    var mMainTopicId          = "0"
    
    let checkBoxImage       = UIImageView()
    
    var m_progressView      = UIProgressView()
    
    var currentTopicDetails :AnyObject!
    
    
    var     isSelected          = true
    
    var _delgate: AnyObject!
    
    
    var m_checkBoxButton :UIButton!
    
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
        
        self.backgroundColor = whiteBackgroundColor
        
        
        let button = UIButton(frame:CGRect(x: 0, y: 0, width: self.frame.size.width ,height: self.frame.size.height));
        self.addSubview(button)
        button.addTarget(self, action: #selector(LessonPlanMainViewCell.checkMarkPressed), for: UIControlEvents.touchUpInside)
        

        
        
        m_checkBoxButton = UIButton(frame:CGRect(x: 0, y: 0, width: self.frame.size.height ,height: self.frame.size.height));
        self.addSubview(m_checkBoxButton);
        m_checkBoxButton.backgroundColor = UIColor.white
         m_checkBoxButton.addTarget(self, action: #selector(LessonPlanMainViewCell.checkMarkPressed), for: UIControlEvents.touchUpInside)
        checkBoxImage.frame = CGRect(x: (m_checkBoxButton.frame.size.width - 20 )/2  , y: (m_checkBoxButton.frame.size.height - 20) / 2,width: 20,height: 20)
        checkBoxImage.image = UIImage(named:"Checked.png");
        self.addSubview(checkBoxImage);
        
        
        
        
        m_graspImageView.frame = CGRect(x: m_checkBoxButton.frame.size.width + m_checkBoxButton.frame.origin.x + 10, y: (self.frame.size.height - (self.frame.size.height / 1.8))/2 ,width: self.frame.size.height / 1.8,height: self.frame.size.height / 1.8)
        self.addSubview(m_graspImageView)
        m_graspImageView.image = UIImage(named: "00.png")
        m_graspImageView.contentMode = .scaleAspectFit
        

        
        
        mSubTopicButton.frame = CGRect(x: self.frame.size.width - 160 , y: 10 ,width: 150 ,height: self.frame.size.height - 20)
        self.addSubview(mSubTopicButton)
        mSubTopicButton.contentHorizontalAlignment = UIControlContentHorizontalAlignment.right
        mSubTopicButton.setTitleColor(standard_Green, for: UIControlState())
        mSubTopicButton.setTitle("No Questions", for: UIControlState())
        mSubTopicButton.titleLabel?.font = UIFont(name: helveticaRegular, size: 18)
        mSubTopicButton.addTarget(self, action: #selector(LessonPlanSubTopicCell.onSubtopicButton), for: UIControlEvents.touchUpInside)
        mSubTopicButton.layer.cornerRadius = (mSubTopicButton.frame.size.height)/3
        
        
        mSubTopicTagStatus.frame = CGRect(x: mSubTopicButton.frame.origin.x - 90 , y: 10 ,width: 150 ,height: self.frame.size.height - 20)
        self.addSubview(mSubTopicTagStatus)
        mSubTopicTagStatus.textColor = lightGrayColor
        mSubTopicTagStatus.textAlignment = .left
        mSubTopicTagStatus.lineBreakMode = .byTruncatingMiddle
        
        
        
        
        var remainingWidth = m_graspImageView.frame.size.width + m_graspImageView.frame.origin.x + mSubTopicButton.frame.size.width + 30
        
        remainingWidth = self.frame.size.width - remainingWidth
        
        
        
        
        
        
        m_MainTopicLabel = UILabel(frame: CGRect(x: m_graspImageView.frame.size.width + m_graspImageView.frame.origin.x + 10 , y: (self.frame.size.height - (self.frame.size.height / 1.3))/2  , width: remainingWidth, height: self.frame.size.height / 1.3 ))
        m_MainTopicLabel.font = UIFont(name:helveticaRegular, size: 16)
        self.addSubview(m_MainTopicLabel)
        m_MainTopicLabel.textColor = blackTextColor
        m_MainTopicLabel.textAlignment = .left
        m_MainTopicLabel.lineBreakMode = .byTruncatingMiddle
        
        
        
        m_progressView.isUserInteractionEnabled = false;
        self.addSubview(m_progressView)
        m_progressView.frame  = CGRect(x: m_graspImageView.frame.origin.x,y: m_MainTopicLabel.frame.origin.y + m_MainTopicLabel.frame.size.height - 5, width: self.frame.size.width - (m_graspImageView.frame.origin.x + 10) , height: 1)
        m_progressView.progressTintColor = standard_Button;
        let transform: CGAffineTransform = CGAffineTransform(scaleX: 1.0, y: 1.3);
        m_progressView.transform = transform;
        
        
        let lineView = UIImageView(frame:CGRect(x: 0, y: self.frame.size.height-1, width: self.frame.size.width, height: 1))
        lineView.backgroundColor = LineGrayColor
        self.addSubview(lineView)
        
        
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setSubTopicTopicDetails(_ topicDetails:AnyObject , withSelectedState selectedState:Bool)
    {
        
        currentTopicDetails = topicDetails
        
        if let topicId = currentTopicDetails.object(forKey: "Id")as? String
        {
                mMainTopicId = topicId
                  self.tag = Int(topicId)!
            
            
            
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
            
            
            
            
            if let Tagged = currentTopicDetails.object(forKey: "Tagged") as? String
            {
                /*
                if Tagged == "1"
                {
                    checkBoxImage.image = UIImage(named:"Checked.png");
                    isSelected = true
                    
                    
                    if SSTeacherDataSource.sharedDataSource.taggedTopicIdArray.contains(topicId) == false
                    {
                        SSTeacherDataSource.sharedDataSource.taggedTopicIdArray.add(topicId)
                    }
                    
                }
                else
                {
                    checkBoxImage.image = UIImage(named:"Unchecked.png");
                    isSelected = false
                    
                    if SSTeacherDataSource.sharedDataSource.taggedTopicIdArray.contains(topicId) == true
                    {
                        SSTeacherDataSource.sharedDataSource.taggedTopicIdArray.remove(topicId)
                    }

                }*/
                
                
                if Tagged == "0"
                {
                    checkBoxImage.image = UIImage(named:"Unchecked.png");
                    isSelected = false
                    mSubTopicTagStatus.text = ""
                    
                } else if Tagged == "1"{
                    
                    checkBoxImage.image = UIImage(named:"Checked.png");
                    isSelected = true
                    mSubTopicTagStatus.text = ""
                
                }else if Tagged == "2"{
                    
                    checkBoxImage.image = UIImage(named:"Checked.png");
                    isSelected = true
                    mSubTopicTagStatus.text = "Complete"
                }
                else if Tagged == "3"{
                    
                    checkBoxImage.image = UIImage(named:"Unchecked.png");
                    isSelected = false
                    mSubTopicTagStatus.text = "Complete"
                }
                
            }
            
//            if selectedState == true
//            {
//                checkBoxImage.image = UIImage(named:"Checked.png");
//                isSelected = true
//                
//                
//                if SSTeacherDataSource.sharedDataSource.taggedTopicIdArray.containsObject(topicId) == false
//                {
//                    SSTeacherDataSource.sharedDataSource.taggedTopicIdArray.addObject(topicId)
//                }
//            }
//            else
//            {
//                checkBoxImage.image = UIImage(named:"Unchecked.png");
//                isSelected = false
//                
//                if SSTeacherDataSource.sharedDataSource.taggedTopicIdArray.containsObject(topicId) == true
//                {
//                    SSTeacherDataSource.sharedDataSource.taggedTopicIdArray.removeObject(topicId)
//                }
//            }
        
            
        }
        
        
        
        
        
        
        
        var subTopicsDetails = NSMutableArray()
        
        
        if  let classCheckingVariable = currentTopicDetails.object(forKey: "Questions") as? NSMutableDictionary
        {
            if  let classCheckingVariable = classCheckingVariable.object(forKey: "Question") as? NSMutableArray
            {
                subTopicsDetails = classCheckingVariable
                
                
            }
            else if let questionVariable = classCheckingVariable.object(forKey: "Question") as? NSMutableDictionary
            {
                subTopicsDetails.add(questionVariable)
                
            }
        }
        
        
        
        mSubTopicButton.setTitleColor(standard_Green, for: UIControlState())
        
        if Int(subTopicsDetails.count) <= 0
        {
            mSubTopicButton.setTitle("No Questions", for: UIControlState())
            mSubTopicButton.isEnabled = false
            mSubTopicButton.setTitleColor(lightGrayColor, for: UIControlState())

        }
        else if Int(subTopicsDetails.count) == 1
        {
            mSubTopicButton.setTitle("\(subTopicsDetails.count) Question", for: UIControlState())
        }
        else
        {
            mSubTopicButton.setTitle("\(subTopicsDetails.count) Questions", for: UIControlState())
        }
        
        
        
        
        
    }
    
    func onSubtopicButton()
    {
        if delegate().responds(to: #selector(LessonPlanSubTopicCellDelegate.delegateQuestionPressedWithSubTopicDetails(_:)))
        {
            delegate().delegateQuestionPressedWithSubTopicDetails!(currentTopicDetails)
            mSubTopicButton.setTitleColor(standard_Green, for: UIControlState())
        }
        
    }
    
    func checkMarkPressed()
    {
        if delegate().responds(to: #selector(LessonPlanSubTopicCellDelegate.delegateSubtopicCellCheckMarkPressed))
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
        if let topicId = currentTopicDetails.object(forKey: "Id")as? String
        {
            checkBoxImage.image = UIImage(named:"Checked.png");
            isSelected = true
            if SSTeacherDataSource.sharedDataSource.taggedTopicIdArray.contains(topicId) == false
            {
                SSTeacherDataSource.sharedDataSource.taggedTopicIdArray.add(topicId)
            }
        }
    }
    
    func unselectCell()
    {
        if let topicId = currentTopicDetails.object(forKey: "Id")as? String
        {
            checkBoxImage.image = UIImage(named:"Unchecked.png");
            isSelected = false
            
            if SSTeacherDataSource.sharedDataSource.taggedTopicIdArray.contains(topicId) == true
            {
                SSTeacherDataSource.sharedDataSource.taggedTopicIdArray.remove(topicId)
            }
        }
        
    }
    
    // MARK: - Searching functions
    func searchingForTextInmainTopicWithText(_ searchtext:String)
    {
        m_MainTopicLabel.attributedText = searchtext.getAttributeText(m_MainTopicLabel.text!.capitalized, withSubString: searchtext.capitalized)
//        if searchtext.isAttributeFound(m_MainTopicLabel.text!.capitalizedString, withSubString: searchtext.capitalizedString) == true
//        {
//            
//        }
        
        
    }
    
    
}
    
    
    

    
    
