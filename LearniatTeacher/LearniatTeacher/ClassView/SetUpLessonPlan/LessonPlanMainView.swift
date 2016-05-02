//
//  LessonPlanMainView.swift
//  LearniatTeacher
//
//  Created by mindshift_Deepak on 16/04/16.
//  Copyright © 2016 Mindshift. All rights reserved.
//

import Foundation



class LessonPlanMainView: UIView,SSTeacherDataSourceDelegate,LessonPlanMainViewDelegate,LessonPlanSubTopicsViewDelegate
{
    


    var _currentSessionDetails       :AnyObject!
    
    var mTopicsContainerView        = UIScrollView()
    
    var mMaintopicsDetails          = NSMutableArray()
    
    var fullLessonPlan              = NSMutableArray()
    
    var  mTopicName                 = UILabel()
    
    var _currentTopicDetails:AnyObject!
    
    override init(frame: CGRect)
    {
        
        super.init(frame:frame)
        
        
        self.backgroundColor = lightGrayTopBar
       
        
        mTopicsContainerView.frame = CGRectMake(0, 0, self.frame.size.width,self.frame.size.height)
        self.addSubview(mTopicsContainerView)
        mTopicsContainerView.backgroundColor = lightGrayTopBar
        mTopicsContainerView.hidden = true
        
    }
    
    
    required init?(coder aDecoder: NSCoder)
    {
        fatalError("init(coder:) has not been implemented")
        
        
    }
    
    
    func setCurrentSessionDetails(sessionDetails:AnyObject, withFullLessonPlanDetails _fullLessonPlan:AnyObject)
    {
        _currentTopicDetails = _fullLessonPlan
        
          mMaintopicsDetails.removeAllObjects()
        
        let classCheckingVariable = _fullLessonPlan.objectForKey("MainTopics")!.objectForKey("MainTopic")!
        
        if classCheckingVariable.isKindOfClass(NSMutableArray)
        {
            mMaintopicsDetails = classCheckingVariable as! NSMutableArray
        }
        else
        {
            mMaintopicsDetails.addObject(_fullLessonPlan.objectForKey("MainTopics")!.objectForKey("MainTopic")!)
            
        }
        
        
        
        addTopicsForheight()
        
    }
    
    func addTopicsForheight()
    {
        
        if mMaintopicsDetails.count <= 0
        {
            mTopicName.text = "No Topics found"
            
            mTopicsContainerView.hidden = true
        }
        else
        {
             mTopicName.hidden = true
            mTopicsContainerView.hidden = false
        }
        
        
        
        
        
        var positionY :CGFloat = 10
        
        for index in 0 ..< mMaintopicsDetails.count
        {
            let currentTopicDetails = mMaintopicsDetails.objectAtIndex(index)
            let topicCell = LessonPlanMainViewCell(frame: CGRectMake(10  , positionY, mTopicsContainerView.frame.size.width - 20, 60))
            topicCell.setdelegate(self)
            topicCell.setMainTopicDetails(currentTopicDetails, withIndexPath: index)
            mTopicsContainerView.addSubview(topicCell)
            positionY = positionY + topicCell.frame.size.height + 10
        }
        
        mTopicsContainerView.contentSize = CGSizeMake(0, positionY + 20)
        
    }
    
    // MARK: - mainTopic cell delegate functions
    
    func delegateSubTopicCellPressedWithMainTopicDetails(topicDetails: AnyObject, withIndexValue indexValue: Int) {
        
        
       let SubTopicsView = LessonPlanSubTopicsView(frame: CGRectMake(0,0,self.frame.size.width,self.frame.size.height ))
        SubTopicsView.setCurrentMainTopicDetails(topicDetails, withMainTopicIndexPath: indexValue)
        SubTopicsView.setdelegate(self)
        self.addSubview(SubTopicsView)
        
        
    }
    
    
    func delegateMainTopicCheckMarkPressedWithState(SelectedState:Bool, withIndexValue indexValue:Int, withCurrentTopicDatails details:AnyObject)
    {
        
        if indexValue < mMaintopicsDetails.count
        {
            mMaintopicsDetails.replaceObjectAtIndex(indexValue, withObject: details)
            
        }
        
        _currentTopicDetails.setObject(mMaintopicsDetails, forKey: "MainTopic")
        
        _currentTopicDetails.setObject(_currentTopicDetails, forKey: "MainTopics")

        
    }
    
    // MARK: - subTopic View delegate functions
    
    func delegateCellStateChangedWithState(SelectedState: Bool, withIndexValue indexValue: Int, withCurrentTopicDatails details: AnyObject, withChecMarkState checkMark: Int) {
        
        if indexValue < mMaintopicsDetails.count
        {
            mMaintopicsDetails.replaceObjectAtIndex(indexValue, withObject: details)
            
        }
        
        _currentTopicDetails.setObject(mMaintopicsDetails, forKey: "MainTopic")
        
        _currentTopicDetails.setObject(_currentTopicDetails, forKey: "MainTopics")
        
        
        
        if let topicId = details.objectForKey("Id")as? String
        {
            if let topicCell  = mTopicsContainerView.viewWithTag(Int(topicId)!) as? LessonPlanMainViewCell
            {

                if checkMark == 1
                {
                    topicCell.checkBoxImage.image = UIImage(named:"Checked.png");
                    topicCell.backgroundColor = UIColor.whiteColor()
                }
                else if checkMark == 0
                {
                    topicCell.checkBoxImage.image = UIImage(named:"Unchecked.png");
                    topicCell.backgroundColor = UIColor.clearColor()
                }
                else
                {
                    topicCell.checkBoxImage.image = UIImage(named:"halfChecked.png");
                    topicCell.backgroundColor = UIColor.whiteColor()
                    
                }
                
                
            }
            
        }
        

    }
    
    
    
    func delegateSubTopicRemovedWithTopicDetails(topicDetails: AnyObject)
    {
        if let topicId = topicDetails.objectForKey("Id")as? String
        {
            if let topicCell  = mTopicsContainerView.viewWithTag(Int(topicId)!) as? LessonPlanMainViewCell
            {
                UIView.animateWithDuration(0.5)
                    {
                     topicCell.mSubTopicButton.backgroundColor = standard_Button
                }
                
               
            }

        }
    }
    
    
    func getAllSelectedtopicId() -> String
    {
        
        let topicsIdDetails = NSMutableArray()
        
        
        for index in 0 ..< mMaintopicsDetails.count 
        {
            let currentTopicDetails = mMaintopicsDetails.objectAtIndex(index)
            
            if let Tagged = currentTopicDetails.objectForKey("Tagged") as? String
            {
                if Tagged == "1"
                {
                   
                    if let topicId = currentTopicDetails.objectForKey("Id")as? String
                    {
                        topicsIdDetails.addObject(topicId)
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
                    
                    
                    
                    for SubTopicIndex in 0 ..< subTopicsDetails.count 
                    {
                        let _currentSubTopicDetails = subTopicsDetails.objectAtIndex(SubTopicIndex)
                        if let Tagged = _currentSubTopicDetails.objectForKey("Tagged") as? String
                        {
                            if Tagged == "1"
                            {
                                
                                if let topicId = _currentSubTopicDetails.objectForKey("Id")as? String
                                {
                                    topicsIdDetails.addObject(topicId)
                                }
                            }
                        }
                       
                    }
                }
                
            }
        }

        
       let topicDetailsString = topicsIdDetails.componentsJoinedByString(",")
        
        
        return topicDetailsString 
    }
    
    
    func searchingTextWithSearchText(searchText:String, withSearchedTopics topics:NSMutableArray)
    {
        for index in 0 ..< mMaintopicsDetails.count
        {
            let currentTopicDetails = mMaintopicsDetails.objectAtIndex(index)
            
            if let topicId = currentTopicDetails.objectForKey("Id")as? String
            {
                
                 if let topicCell  = mTopicsContainerView.viewWithTag(Int(topicId)!) as? LessonPlanMainViewCell
                 {
                    topicCell.m_MainTopicLabel.textColor = blackTextColor
                    if let topicName = currentTopicDetails.objectForKey("Name")as? String
                    {
                        if let CumulativeTime = currentTopicDetails.objectForKey("CumulativeTime")as? String
                        {
                            topicCell.m_MainTopicLabel.text = "\(topicName)(\(CumulativeTime))".capitalizedString
                        }
                        else
                        {
                            topicCell.m_MainTopicLabel.text = "\(topicName)".capitalizedString
                        }
                        
                        topicCell.m_MainTopicLabel.attributedText = topicName.getAttributeText(topicCell.m_MainTopicLabel.text!.capitalizedString, withSubString: "")
                    }
                }
            }
        }
        
        
        
        for index in 0 ..< topics.count
        {
            let currentTopicDetails = topics.objectAtIndex(index)
            
            if let topicId = currentTopicDetails.objectForKey("Id")as? String
            {
                
                if let topicCell  = mTopicsContainerView.viewWithTag(Int(topicId)!) as? LessonPlanMainViewCell
                {
                    
                    if let topicName = currentTopicDetails.objectForKey("Name")as? String
                    {
                        if let CumulativeTime = currentTopicDetails.objectForKey("CumulativeTime")as? String
                        {
                           topicCell.m_MainTopicLabel.text = "\(topicName)(\(CumulativeTime))".capitalizedString
                        }
                        else
                        {
                           topicCell.m_MainTopicLabel.text = "\(topicName)".capitalizedString
                        }
                        
                        topicCell.m_MainTopicLabel.attributedText = topicName.getAttributeText(topicCell.m_MainTopicLabel.text!.capitalizedString, withSubString: searchText.capitalizedString)
                    }
                }
            }
        }
        
        
    }
    
}