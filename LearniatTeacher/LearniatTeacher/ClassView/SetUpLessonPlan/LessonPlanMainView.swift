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
        
        for var index = 0; index < mMaintopicsDetails.count ; index++
        {
            let currentTopicDetails = mMaintopicsDetails.objectAtIndex(index)
            let topicCell = LessonPlanMainViewCell(frame: CGRectMake(10  , positionY, mTopicsContainerView.frame.size.width - 20, 60))
            topicCell.setdelegate(self)
            topicCell.setMainTopicDetails(currentTopicDetails)
            mTopicsContainerView.addSubview(topicCell)
            positionY = positionY + topicCell.frame.size.height + 10
        }
        
        mTopicsContainerView.contentSize = CGSizeMake(0, positionY + 20)
        
    }
    
    // MARK: - mainTopic cell delegate functions
    
    func delegateSubTopicCellPressedWithMainTopicDetails(topicDetails: AnyObject)
    {
        
       let SubTopicsView = LessonPlanSubTopicsView(frame: CGRectMake(0,0,self.frame.size.width,self.frame.size.height ))
        SubTopicsView.setCurrentMainTopicDetails(topicDetails)
        SubTopicsView.setdelegate(self)
        self.addSubview(SubTopicsView)
        
        
    }
    
    // MARK: - subTopic View delegate functions
    
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
}