//
//  LessonPlanQuestionView.swift
//  LearniatTeacher
//
//  Created by mindshift_Deepak on 16/04/16.
//  Copyright © 2016 Mindshift. All rights reserved.
//

import Foundation

@objc protocol  LessonPlanQuestionViewDelegate
{
    
    
    
    optional func delegateSubTopicRemovedWithTopicDetails(topicDetails:AnyObject)
    
}



class LessonPlanQuestionView: UIView,SSTeacherDataSourceDelegate,UIGestureRecognizerDelegate,LessonPlanSubTopicCellDelegate
{
    
    
    var _currentSessionDetails       :AnyObject!
    
    var mTopicsContainerView        = UIScrollView()
    
    var mQuestionsDetails          = NSMutableArray()
    
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
        
        mTopicsContainerView.frame = CGRectMake(100, 0, self.frame.size.width - 200,self.frame.size.height)
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
        
        let  mDoneButton = UIButton(frame: CGRectMake( 10, 0, 100, 60))
        mDoneButton.addTarget(self, action: #selector(LessonPlanQuestionView.onBackButton), forControlEvents: UIControlEvents.TouchUpInside)
        mDoneButton.contentHorizontalAlignment = UIControlContentHorizontalAlignment.Left
        mTopicsContainerView.addSubview(mDoneButton)
        mDoneButton.setImage(UIImage(named: "arrow_Blue.png"), forState: .Normal)
        mDoneButton.imageView?.contentMode = .ScaleAspectFit
        
        
        
        
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
        
        mQuestionsDetails.removeAllObjects()
        
        let classCheckingVariable = mainTopicDetails.objectForKey("Questions")!.objectForKey("Question")!
        
        if classCheckingVariable.isKindOfClass(NSMutableArray)
        {
            mQuestionsDetails = classCheckingVariable as! NSMutableArray
        }
        else
        {
            mQuestionsDetails.addObject(mainTopicDetails.objectForKey("Questions")!.objectForKey("Question")!)
            
        }
        
        addTopicsForheight()
        
        mainTopicCell.setMainTopicDetails(mainTopicDetails, withIndexPath: 0)
        
        mainTopicCell.backgroundColor = UIColor.clearColor()
        
        
    }
    
    
    
    func addTopicsForheight()
    {
        
        
        
        if mQuestionsDetails.count <= 0
        {
            
            mTopicsContainerView.hidden = true
        }
        else
        {
            mTopicsContainerView.hidden = false
        }
        
        
        
        var positionY :CGFloat = 80
        
        for index in 0 ..< mQuestionsDetails.count 
        {
            let currentTopicDetails = mQuestionsDetails.objectAtIndex(index)
            let topicCell = LessonPlanQuestionViewCell(frame: CGRectMake(10  , positionY, mTopicsContainerView.frame.size.width - 20, 60))
            topicCell.setdelegate(self)
            topicCell.frame =   CGRectMake(10  , positionY, mTopicsContainerView.frame.size.width - 20 , topicCell.getCurrentCellHeightWithDetails(currentTopicDetails, WIthCountValue: index + 1))
            mTopicsContainerView.addSubview(topicCell)
            positionY = positionY + topicCell.frame.size.height + 10
        }
        
        mTopicsContainerView.contentSize = CGSizeMake(0, positionY + 20)
        
    }
    
    func onBackButton()
    {
        
        if delegate().respondsToSelector(#selector(LessonPlanQuestionViewDelegate.delegateSubTopicRemovedWithTopicDetails(_:)))
        {
            delegate().delegateSubTopicRemovedWithTopicDetails!(_currentMainTopicDetails)
        }
        
        
        UIView.animateWithDuration(0.6, animations:
            {
            self.frame =  CGRectMake(self.frame.size.width,0,self.frame.size.width,self.frame.size.height )
            },
            completion:
            { finished in
                self.removeFromSuperview()
        })
        
        
        
        
       
    }
    
    
    // MARK: - subTopic cell delegate functions
    
    
    func delegateQuestionPressedWithSubTopicDetails(topicDetails: AnyObject)
    {
        
        
    }
    
    
}