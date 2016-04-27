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
    
    
    
    optional func delegateCellStateChangedWithState(SelectedState:Bool, withIndexValue indexValue:Int, withCurrentTopicDatails details:AnyObject, withChecMarkState checkMark:Int)

    
    
}



class LessonPlanSubTopicsView: UIView,SSTeacherDataSourceDelegate,UIGestureRecognizerDelegate,LessonPlanSubTopicCellDelegate,LessonPlanQuestionViewDelegate
{
    
    
    var _currentSessionDetails       :AnyObject!
    
    var mTopicsContainerView        = UIScrollView()
    
    var mMaintopicsDetails          = NSMutableArray()
    
    var fullSubTopicLessonPlan              = NSMutableArray()
    
    var _currentMainTopicDetails      :AnyObject!
    
    var mainTopicCell           :LessonPlanMainViewCell!
    
    var _delgate: AnyObject!
    
    var _currentSubTopicIndexpath           = 0
    
    
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
//        let tap = UITapGestureRecognizer(target: self, action: Selector("handleTap:"))
//        tap.delegate = self
//        bacGroundView.addGestureRecognizer(tap)

        
        mTopicsContainerView.frame = CGRectMake(100,60, self.frame.size.width - 200,self.frame.size.height - 60 )
        self.addSubview(mTopicsContainerView)
        mTopicsContainerView.backgroundColor = lightGrayTopBar
        mTopicsContainerView.userInteractionEnabled = true
       
        
        let imageview =  UIImageView(frame: CGRectMake(100  , 0, mTopicsContainerView.frame.size.width , 60))
        self.addSubview(imageview)
        imageview.backgroundColor = lightGrayTopBar

        
        mainTopicCell = LessonPlanMainViewCell(frame: CGRectMake(100  , 0, mTopicsContainerView.frame.size.width , 60))
        mainTopicCell.setdelegate(self)
        mainTopicCell.layer.cornerRadius = 5
        self.addSubview(mainTopicCell)
        mainTopicCell.backgroundColor = UIColor.clearColor()
        mainTopicCell.mSubTopicButton.hidden = true
        mainTopicCell.checkBoxImage.hidden = true
        mainTopicCell.m_checkBoxButton.hidden = true
        mainTopicCell.mQuestionsButton.hidden = true
        
       
        
        
        let  mDoneButton = UIButton(frame: CGRectMake( 10, 0, 100, 60))
        mDoneButton.addTarget(self, action: #selector(LessonPlanSubTopicsView.onBackButton), forControlEvents: UIControlEvents.TouchUpInside)
        mDoneButton.contentHorizontalAlignment = UIControlContentHorizontalAlignment.Left
        mainTopicCell.addSubview(mDoneButton)
        mDoneButton.setImage(UIImage(named: "arrow_Blue.png"), forState: .Normal)
        mDoneButton.imageView?.contentMode = .ScaleAspectFit
}
    
    
    required init?(coder aDecoder: NSCoder)
    {
        fatalError("init(coder:) has not been implemented")
        
        
    }
    
    
    func setCurrentMainTopicDetails(mainTopicDetails:AnyObject, withMainTopicIndexPath indexPath:Int)
    {
        
        _currentMainTopicDetails = mainTopicDetails
        _currentSubTopicIndexpath = indexPath
        
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
        
         mainTopicCell.setMainTopicDetails(mainTopicDetails, withIndexPath: 0)
        
        mainTopicCell.backgroundColor = UIColor.clearColor()
        
        
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
        
        
        
      
        
        
        
        var positionY :CGFloat = 10
        
        for index in 0 ..< mMaintopicsDetails.count 
        {
            let currentTopicDetails = mMaintopicsDetails.objectAtIndex(index)
            let topicCell = LessonPlanSubTopicCell(frame: CGRectMake(10  , positionY, mTopicsContainerView.frame.size.width - 20, 60))
            topicCell.setdelegate(self)
            topicCell.setSubTopicTopicDetails(currentTopicDetails,withIndexValue: index)
            mTopicsContainerView.addSubview(topicCell)
            positionY = positionY + topicCell.frame.size.height + 10
        }
        
        mTopicsContainerView.contentSize = CGSizeMake(0, positionY + 20)
        
    }
    
    func onBackButton()
    {
        
        if delegate().respondsToSelector(#selector(LessonPlanSubTopicsViewDelegate.delegateSubTopicRemovedWithTopicDetails(_:)))
        {
            delegate().delegateSubTopicRemovedWithTopicDetails!(_currentMainTopicDetails)
        }
        
        self.removeFromSuperview()
    }
    
    
     // MARK: - subTopic cell delegate functions
    
    
    func delegateQuestionPressedWithSubTopicDetails(topicDetails: AnyObject)
    {
        
        let SubTopicsView = LessonPlanQuestionView(frame: CGRectMake(self.frame.size.width,0,self.frame.size.width,self.frame.size.height ))
        SubTopicsView.setCurrentMainTopicDetails(topicDetails)
        
        UIView.animateWithDuration(0.6, animations: {
             SubTopicsView.frame =  CGRectMake(0,0,self.frame.size.width,self.frame.size.height )
            })
        
        
        SubTopicsView.setdelegate(self)
        self.addSubview(SubTopicsView)
    }
    
    
    
    
    func delegateCheckMarkPressedWithState(SelectedState: Bool, withIndexValue indexValue: Int, withCurrentTopicDatails details: AnyObject) {
        
        
        if indexValue < mMaintopicsDetails.count
        {
            mMaintopicsDetails.replaceObjectAtIndex(indexValue, withObject: details)
            
        }
        
        _currentMainTopicDetails.setObject(mMaintopicsDetails, forKey: "SubTopic")
        
        _currentMainTopicDetails.setObject(_currentMainTopicDetails, forKey: "SubTopics")
        
        
        var selectedState = 0
        
        var notSelectedState = 0
        
        let subViews = mTopicsContainerView.subviews.flatMap{ $0 as? LessonPlanSubTopicCell }
        
        for subview in subViews
        {
            if subview.isKindOfClass(LessonPlanSubTopicCell)
            {
                if subview.isSelected == true
                {
                    selectedState = selectedState + 1
                }
                else if subview.isSelected == false
                {
                    notSelectedState = notSelectedState + 1
                }
                
            }
        }
        
        
        if mMaintopicsDetails.count == selectedState
        {
            selectedState  = 1
        }
        else if mMaintopicsDetails.count == notSelectedState
        {
            selectedState  = 0
        }
        else
        {
            selectedState  = 2
        }
        
        
        
        if delegate().respondsToSelector(#selector(LessonPlanSubTopicsViewDelegate.delegateCellStateChangedWithState(_:withIndexValue:withCurrentTopicDatails:withChecMarkState:)))
        {
            delegate().delegateCellStateChangedWithState!(SelectedState, withIndexValue: _currentSubTopicIndexpath, withCurrentTopicDatails: _currentMainTopicDetails,withChecMarkState:selectedState)

        }
        
    }
    
    
    
      // MARK: - Question view delegate functions
    func delegateSubTopicRemovedWithTopicDetails(topicDetails: AnyObject)
    {
        if let topicId = topicDetails.objectForKey("Id")as? String
        {
            if let topicCell  = mTopicsContainerView.viewWithTag(Int(topicId)!) as? LessonPlanSubTopicCell
            {
                UIView.animateWithDuration(0.5)
                    {
                        topicCell.mSubTopicButton.backgroundColor = standard_Button
                }
                
                
            }
            
        }
    }
    
    
}