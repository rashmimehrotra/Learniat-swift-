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
        
        
        
        registerKeyboardNotifications()
        
    }
    
    
    func registerKeyboardNotifications()
    {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(LessonPlanMainView.keyboardDidShow(_:)), name: UIKeyboardDidShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(LessonPlanMainView.keyboardWillHide(_:)), name: UIKeyboardWillHideNotification, object: nil)
    }
    
    func unregisterKeyboardNotifications()
    {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    func keyboardDidShow(notification: NSNotification)
    {
        let userInfo: NSDictionary = notification.userInfo!
        let keyboardSize = userInfo.objectForKey(UIKeyboardFrameBeginUserInfoKey)!.CGRectValue.size
        let contentInsets = UIEdgeInsetsMake(0, 0, keyboardSize.height, 0)
        mTopicsContainerView.contentInset = contentInsets
        mTopicsContainerView.scrollIndicatorInsets = contentInsets
        
        var viewRect = self.frame
        viewRect.size.height -= keyboardSize.height
       
        if CGRectContainsPoint(viewRect, mTopicsContainerView.frame.origin)
        {
            let scrollPoint = CGPointMake(0, mTopicsContainerView.frame.origin.y - keyboardSize.height)
            mTopicsContainerView.setContentOffset(scrollPoint, animated: true)
        }
    }
    
    func keyboardWillHide(notification: NSNotification)
    {
        mTopicsContainerView.contentInset = UIEdgeInsetsZero
        mTopicsContainerView.scrollIndicatorInsets = UIEdgeInsetsZero
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
        
        for index in 0 ..< mMaintopicsDetails.count
        {
            let currentTopicDetails = mMaintopicsDetails.objectAtIndex(index)
            let topicCell = LessonPlanMainViewCell(frame: CGRectMake(10  , positionY, mTopicsContainerView.frame.size.width - 20, 55))
            topicCell.setdelegate(self)
            topicCell.setMainTopicDetails(currentTopicDetails, withIndexPath: index)
            mTopicsContainerView.addSubview(topicCell)
            positionY = positionY + topicCell.frame.size.height + 10
        }
        
        mTopicsContainerView.contentSize = CGSizeMake(0, positionY + 20)
        
    }
    
    // MARK: - mainTopic cell delegate functions
    
    func delegateSubTopicCellPressedWithMainTopicDetails(topicDetails: AnyObject, withCell topicCell: LessonPlanMainViewCell, withHeight height: CGFloat)
    {
        topicCell.frame = CGRectMake(topicCell.frame.origin.x, topicCell.frame.origin.y, topicCell.frame.width, height)
        rearrangeScrollView()
    }
    
    func delegateQuestionButtonPressedWithDetails(topicDetails: AnyObject)
    {
        
        
        
        
                let SubTopicsView = LessonPlanQuestionView(frame: CGRectMake(0,0,self.frame.size.width,self.frame.size.height ))
                SubTopicsView.setCurrentMainTopicDetails(topicDetails)
        
                UIView.animateWithDuration(0.6, animations:
                    {
                     SubTopicsView.frame =  CGRectMake(0,0,self.frame.size.width,self.frame.size.height )
                    })
        
        
                SubTopicsView.setdelegate(self)
                self.addSubview(SubTopicsView)
        
    }
    
    func delegateMainTopicCheckMarkPressedWithState(SelectedState: Bool, withCurrentTopicDatails details: AnyObject)
    {
        
    }
    
    // MARK: - subTopic View delegate functions
    
    func delegateCellStateChangedWithState(SelectedState: Bool, withIndexValue indexValue: Int, withCurrentTopicDatails details: AnyObject, withChecMarkState checkMark: Int) {
        
//        if indexValue < mMaintopicsDetails.count
//        {
//            mMaintopicsDetails.replaceObjectAtIndex(indexValue, withObject: details)
//            
//        }
        

        

        
        
        
//        if let topicId = details.objectForKey("Id")as? String
//        {
//            if let topicCell  = mTopicsContainerView.viewWithTag(Int(topicId)!) as? LessonPlanMainViewCell
//            {
//
//                if checkMark == 1
//                {
//                    topicCell.checkBoxImage.image = UIImage(named:"Checked.png");
//                    topicCell.backgroundColor = UIColor.whiteColor()
//                }
//                else if checkMark == 0
//                {
//                    topicCell.checkBoxImage.image = UIImage(named:"Unchecked.png");
//                    topicCell.backgroundColor = UIColor.clearColor()
//                }
//                else
//                {
//                    topicCell.checkBoxImage.image = UIImage(named:"halfChecked.png");
//                    topicCell.backgroundColor = UIColor.whiteColor()
//                    
//                }
//                
//                
//            }
//            
//        }
        

    }
    
    
    
    func delegateSubTopicRemovedWithTopicDetails(topicDetails: AnyObject)
    {
//        if let topicId = topicDetails.objectForKey("Id")as? String
//        {
//            if let topicCell  = mTopicsContainerView.viewWithTag(Int(topicId)!) as? LessonPlanMainViewCell
//            {
//                UIView.animateWithDuration(0.5)
//                    {
////                     topicCell.mSubTopicButton.backgroundColor = standard_Button
//                }
//                
//               
//            }
//
//        }
    }
    
    
    func getAllSelectedtopicId() -> String
    {
        

        unregisterKeyboardNotifications()
        
       let topicDetailsString = SSTeacherDataSource.sharedDataSource.taggedTopicIdArray.componentsJoinedByString(",")
        
        
        return topicDetailsString 
    }
    
    func searchingStarted()
    {
        let subViews =  mTopicsContainerView.subviews.flatMap{ $0 as? LessonPlanMainViewCell }
        for topicCell in subViews
        {
            if topicCell.isKindOfClass(LessonPlanMainViewCell)
            {
               topicCell.SubTopicsView.hidden = true
                topicCell.onSubtopicButton()
            }
        }
    }
    
    func searchingStopped()
    {
        let subViews =  mTopicsContainerView.subviews.flatMap{ $0 as? LessonPlanMainViewCell }
        for topicCell in subViews
        {
            if topicCell.isKindOfClass(LessonPlanMainViewCell)
            {
                topicCell.SubTopicsView.hidden = false
                topicCell.onSubtopicButton()
            }
        }
    }
    
    func searchingTextWithSearchText(searchText:String)
    {
        let subViews =  mTopicsContainerView.subviews.flatMap{ $0 as? LessonPlanMainViewCell }
        for topicCell in subViews
        {
            if topicCell.isKindOfClass(LessonPlanMainViewCell)
            {
                topicCell.searchingForTextInmainTopicWithText(searchText)
            }
        }
    }
    
    
    
    
    func rearrangeScrollView()
    {
        
       
        
        var currentYPosition :CGFloat = 10
        
        let subViews =  mTopicsContainerView.subviews.flatMap{ $0 as? LessonPlanMainViewCell }
        for topicCell in subViews
        {
            if topicCell.isKindOfClass(LessonPlanMainViewCell)
            {
                UIView.animateWithDuration(0.2, animations:
                    {
                        topicCell.frame = CGRectMake(topicCell.frame.origin.x ,currentYPosition,topicCell.frame.size.width,topicCell.frame.size.height)
                })
                
                currentYPosition = currentYPosition + topicCell.frame.size.height + 10
            }
        }
        
          mTopicsContainerView.contentSize = CGSizeMake(0, currentYPosition)
    }
    
    
}