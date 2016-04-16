//
//  LessonPlanSubTopicsView.swift
//  LearniatTeacher
//
//  Created by mindshift_Deepak on 16/04/16.
//  Copyright © 2016 Mindshift. All rights reserved.
//

import Foundation

@objc protocol  LessonPlanSubTopicsViewDelegate
{
    
    
    
    optional func delegateSubTopicRemovedWithTopicDetails(topicDetails:AnyObject)
    
}



class LessonPlanSubTopicsView: UIView,SSTeacherDataSourceDelegate,UIGestureRecognizerDelegate,LessonPlanSubTopicCellDelegate
{
    
    
    var _currentSessionDetails       :AnyObject!
    
    var mTopicsContainerView        = UIScrollView()
    
    var mMaintopicsDetails          = NSMutableArray()
    
    var fullSubTopicLessonPlan              = NSMutableArray()
    
    var _currentMainTopicDetails      :AnyObject!
    
    var mainTopicCell           :LessonPlanMainViewCell!
    
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
        
        
        self.backgroundColor =  UIColor.clearColor()
        
        let bacGroundView = UIView(frame: CGRectMake(0, 0, self.frame.size.width,self.frame.size.height))
        self.addSubview(bacGroundView)
        bacGroundView.backgroundColor = blackTextColor
        bacGroundView.alpha = 0.4
        let tap = UITapGestureRecognizer(target: self, action: Selector("handleTap:"))
        tap.delegate = self
        bacGroundView.addGestureRecognizer(tap)

        
        mTopicsContainerView.frame = CGRectMake(60, 0, self.frame.size.width - 120,self.frame.size.height)
        self.addSubview(mTopicsContainerView)
        mTopicsContainerView.backgroundColor = lightGrayTopBar
        
       
        
        
        mainTopicCell = LessonPlanMainViewCell(frame: CGRectMake(10  , 0, mTopicsContainerView.frame.size.width - 20 , 60))
        mainTopicCell.setdelegate(self)
        mainTopicCell.layer.cornerRadius = 5
        mTopicsContainerView.addSubview(mainTopicCell)
        mainTopicCell.backgroundColor = UIColor.clearColor()
        mainTopicCell.mSubTopicButton.hidden = true
        mainTopicCell.checkBoxImage.hidden = true
        mainTopicCell.m_checkBoxButton.hidden = true
        
        
        
        let lineImage = UIImageView(frame: CGRectMake(0  , mainTopicCell.frame.origin.y + mainTopicCell.frame.size.height + 10 , mTopicsContainerView.frame.size.width , 2))
        lineImage.backgroundColor = lightGrayColor
        
        mTopicsContainerView.addSubview(lineImage)
        
    }
    
    
    required init?(coder aDecoder: NSCoder)
    {
        fatalError("init(coder:) has not been implemented")
        
        
    }
    
    
    func setCurrentMainTopicDetails(mainTopicDetails:AnyObject)
    {
        
        _currentMainTopicDetails = mainTopicDetails
        
        mMaintopicsDetails.removeAllObjects()
        
        let classCheckingVariable = mainTopicDetails.objectForKey("SubTopics")!.objectForKey("SubTopic")!
        
        if classCheckingVariable.isKindOfClass(NSMutableArray)
        {
            mMaintopicsDetails = classCheckingVariable as! NSMutableArray
        }
        else
        {
            mMaintopicsDetails.addObject(mainTopicDetails.objectForKey("SubTopics")!.objectForKey("SubTopic")!)
            
        }
        
        addTopicsForheight()
        
         mainTopicCell.setMainTopicDetails(mainTopicDetails)
        
        
        
        
    }
    
  
    
    func addTopicsForheight()
    {
        
        
        
        if mMaintopicsDetails.count <= 0
        {
            
            mTopicsContainerView.hidden = true
        }
        else
        {
            mTopicsContainerView.hidden = false
        }
        
        
        
      
        
        
        
        var positionY :CGFloat = 80
        
        for var index = 0; index < mMaintopicsDetails.count ; index++
        {
            let currentTopicDetails = mMaintopicsDetails.objectAtIndex(index)
            let topicCell = LessonPlanSubTopicCell(frame: CGRectMake(10  , positionY, mTopicsContainerView.frame.size.width - 20, 60))
            topicCell.setdelegate(self)
            topicCell.setSubTopicTopicDetails(currentTopicDetails)
            mTopicsContainerView.addSubview(topicCell)
            positionY = positionY + topicCell.frame.size.height + 10
        }
        
        mTopicsContainerView.contentSize = CGSizeMake(0, positionY + 20)
        
    }
    
    func handleTap(sender: UITapGestureRecognizer? = nil)
    {
        
        if delegate().respondsToSelector(Selector("delegateSubTopicRemovedWithTopicDetails:"))
        {
            delegate().delegateSubTopicRemovedWithTopicDetails!(_currentMainTopicDetails)
        }
        
        self.removeFromSuperview()
    }
    
    
     // MARK: - subTopic cell delegate functions
    
    
    func delegateQuestionPressedWithSubTopicDetails(topicDetails: AnyObject)
    {
        
        let SubTopicsView = LessonPlanQuestionView(frame: CGRectMake(0,0,self.frame.size.width,self.frame.size.height ))
        SubTopicsView.setCurrentMainTopicDetails(topicDetails)
        SubTopicsView.setdelegate(self)
        self.addSubview(SubTopicsView)
    }
    
    
}