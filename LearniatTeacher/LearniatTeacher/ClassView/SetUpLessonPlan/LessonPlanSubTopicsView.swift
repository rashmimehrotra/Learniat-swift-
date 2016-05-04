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
    
    
    
    
    
    
    optional func delegateCellStatewithChecMarkState(checkMark:Int)
    
    optional func delegateSubTopicViewQuestionButtonPressedwithDetails(subTopicDetails:AnyObject)

    
    
}



class LessonPlanSubTopicsView: UIView,SSTeacherDataSourceDelegate,UIGestureRecognizerDelegate,LessonPlanSubTopicCellDelegate,LessonPlanQuestionViewDelegate
{
    
    
    var mTopicsContainerView        = UIScrollView()
    
    var mSubtopicsDetails          = NSMutableArray()
    
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

        mTopicsContainerView.frame = CGRectMake(0,0, self.frame.size.width,self.frame.size.height )
        self.addSubview(mTopicsContainerView)
        mTopicsContainerView.backgroundColor = lightGrayTopBar
        mTopicsContainerView.userInteractionEnabled = true
    }
    
    
    required init?(coder aDecoder: NSCoder)
    {
        fatalError("init(coder:) has not been implemented")
        
        
    }
    
    func setSubtopicsArray(subTopicArray:NSMutableArray, withSelectedState selectedState:Bool)
    {
         mSubtopicsDetails.removeAllObjects()
        mSubtopicsDetails = subTopicArray
        addTopicsForheight(selectedState)
    }
   
    
    func addTopicsForheight(selectedState:Bool)
    {
        
        
        
        if mSubtopicsDetails.count <= 0
        {
            
            mTopicsContainerView.hidden = true
        }
        else
        {
            mTopicsContainerView.hidden = false
        }
        
        
        
      
        
        
        
        var positionY :CGFloat = 0
        
        for index in 0 ..< mSubtopicsDetails.count
        {
            let currentTopicDetails = mSubtopicsDetails.objectAtIndex(index)
            let topicCell = LessonPlanSubTopicCell(frame: CGRectMake(0  , positionY, mTopicsContainerView.frame.size.width, 55))
            topicCell.setdelegate(self)
            topicCell.setSubTopicTopicDetails(currentTopicDetails, withSelectedState: selectedState)
            mTopicsContainerView.addSubview(topicCell)
            positionY = positionY + topicCell.frame.size.height
        }
        
        mTopicsContainerView.contentSize = CGSizeMake(0, 0)
        
    }
    
    
     // MARK: - subTopic cell delegate functions
    
    
    func delegateQuestionPressedWithSubTopicDetails(topicDetails: AnyObject)
    {
        
//        let SubTopicsView = LessonPlanQuestionView(frame: CGRectMake(self.frame.size.width,0,self.frame.size.width,self.frame.size.height ))
//        SubTopicsView.setCurrentMainTopicDetails(topicDetails)
//        
//        UIView.animateWithDuration(0.6, animations: {
//             SubTopicsView.frame =  CGRectMake(0,0,self.frame.size.width,self.frame.size.height )
//            })
//        
//        
//        SubTopicsView.setdelegate(self)
//        self.addSubview(SubTopicsView)
        
        if delegate().respondsToSelector(#selector(LessonPlanSubTopicsViewDelegate.delegateSubTopicViewQuestionButtonPressedwithDetails(_:)))
        {
            delegate().delegateSubTopicViewQuestionButtonPressedwithDetails!(topicDetails)
        }
        
    }
    
    
    func delegateSubtopicCellCheckMarkPressed()
    {
        var selectedState = 0

        var notSelectedState = 0

        for index in 0 ..< mSubtopicsDetails.count
        {
            let currentSubTopicDetails = mSubtopicsDetails.objectAtIndex(index)
            
            if let topicId = currentSubTopicDetails.objectForKey("Id")as? String
            {
               if SSTeacherDataSource.sharedDataSource.taggedTopicIdArray.containsObject(topicId)
               {
                    selectedState = selectedState + 1
                }
                else
               {
                    notSelectedState = notSelectedState + 1
                }
            }
        }
        
        
        if mSubtopicsDetails.count == selectedState
        {
            selectedState  = 1
        }
        else if mSubtopicsDetails.count == notSelectedState
        {
            selectedState  = 0
        }
        else
        {
            selectedState  = 2
        }

        if delegate().respondsToSelector(#selector(LessonPlanSubTopicsViewDelegate.delegateCellStatewithChecMarkState))
        {
            delegate().delegateCellStatewithChecMarkState!(selectedState)
            
        }
        
    }
    
    
    
    
    
      // MARK: - Question view delegate functions
    func delegateSubTopicRemovedWithTopicDetails(topicDetails: AnyObject)
    {
//        if let topicId = topicDetails.objectForKey("Id")as? String
//        {
//            if let topicCell  = mTopicsContainerView.viewWithTag(Int(topicId)!) as? LessonPlanSubTopicCell
//            {
//                UIView.animateWithDuration(0.5)
//                    {
//                        topicCell.mSubTopicButton.backgroundColor = standard_Button
//                }
//                
//                
//            }
//            
//        }
    }
    
    
    func checkMarkStateChangedWithState(state:Bool)
    {
        
        let subViews =  mTopicsContainerView.subviews.flatMap{ $0 as? LessonPlanSubTopicCell }
        for topicCell in subViews
        {
            if topicCell.isKindOfClass(LessonPlanSubTopicCell)
            {
                if state == true
                {
                    topicCell.selectCell()
                }
                else
                {
                    topicCell.unselectCell()
                }
            }
        }
        
    }
    
    
    func searchTopicNameWithSearchText(searchtext:String)
    {
        let subViews =  mTopicsContainerView.subviews.flatMap{ $0 as? LessonPlanSubTopicCell }
        for topicCell in subViews
        {
            if topicCell.isKindOfClass(LessonPlanSubTopicCell)
            {
                topicCell.searchingForTextInmainTopicWithText(searchtext)
            }
        }
    }
    
    
}