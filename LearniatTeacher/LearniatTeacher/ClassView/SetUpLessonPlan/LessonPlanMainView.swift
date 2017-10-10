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
       
        
        mTopicsContainerView.frame = CGRect(x: 0, y: 0, width: self.frame.size.width,height: self.frame.size.height)
        self.addSubview(mTopicsContainerView)
        mTopicsContainerView.backgroundColor = lightGrayTopBar
        mTopicsContainerView.isHidden = true
        
        
        
        registerKeyboardNotifications()
        
    }
    
    
    func registerKeyboardNotifications()
    {
        NotificationCenter.default.addObserver(self, selector: #selector(LessonPlanMainView.keyboardDidShow(_:)), name: NSNotification.Name.UIKeyboardDidShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(LessonPlanMainView.keyboardWillHide(_:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    func unregisterKeyboardNotifications()
    {
        NotificationCenter.default.removeObserver(self)
    }
    
    func keyboardDidShow(_ notification: Notification)
    {
        let userInfo: NSDictionary = notification.userInfo! as NSDictionary
        let keyboardSize = (userInfo.object(forKey: UIKeyboardFrameBeginUserInfoKey)! as AnyObject).cgRectValue.size
        let contentInsets = UIEdgeInsetsMake(0, 0, keyboardSize.height, 0)
        mTopicsContainerView.contentInset = contentInsets
        mTopicsContainerView.scrollIndicatorInsets = contentInsets
        
        var viewRect = self.frame
        viewRect.size.height -= keyboardSize.height
       
        if viewRect.contains(mTopicsContainerView.frame.origin)
        {
            let scrollPoint = CGPoint(x: 0, y: mTopicsContainerView.frame.origin.y - keyboardSize.height)
            mTopicsContainerView.setContentOffset(scrollPoint, animated: true)
        }
    }
    
    func keyboardWillHide(_ notification: Notification)
    {
        mTopicsContainerView.contentInset = UIEdgeInsets.zero
        mTopicsContainerView.scrollIndicatorInsets = UIEdgeInsets.zero
    }

    
    
    
    required init?(coder aDecoder: NSCoder)
    {
        fatalError("init(coder:) has not been implemented")
        
        
    }
    
    
    func setCurrentSessionDetails(_ sessionDetails:AnyObject, withFullLessonPlanDetails _fullLessonPlan:AnyObject)
    {
        
          mMaintopicsDetails.removeAllObjects()
        
        if let classCheckingVariable = (_fullLessonPlan.object(forKey: "MainTopics")! as AnyObject).object(forKey: "MainTopic") as? NSMutableArray
        {
            mMaintopicsDetails = classCheckingVariable
        }
        else
        {
            mMaintopicsDetails.add((_fullLessonPlan.object(forKey: "MainTopics")! as AnyObject).object(forKey: "MainTopic")!)
            
        }
        
        addTopicsForheight()
        
    }
    
    func addTopicsForheight()
    {
        
        if mMaintopicsDetails.count <= 0
        {
            mTopicName.text = "No Topics found"
            
            mTopicsContainerView.isHidden = true
        }
        else
        {
             mTopicName.isHidden = true
            mTopicsContainerView.isHidden = false
        }
        
        var positionY :CGFloat = 10
        
        for index in 0 ..< mMaintopicsDetails.count
        {
            let currentTopicDetails = mMaintopicsDetails.object(at: index)
            let topicCell = LessonPlanMainViewCell(frame: CGRect(x: 10  , y: positionY, width: mTopicsContainerView.frame.size.width - 20, height: 55))
            topicCell.setdelegate(self)
            topicCell.setMainTopicDetails(currentTopicDetails as AnyObject, withIndexPath: index)
            mTopicsContainerView.addSubview(topicCell)
            positionY = positionY + topicCell.frame.size.height + 10
        }
        
        mTopicsContainerView.contentSize = CGSize(width: 0, height: positionY + 20)
        
    }
    
    // MARK: - mainTopic cell delegate functions
    
    func delegateSubTopicCellPressedWithMainTopicDetails(_ topicDetails: AnyObject, withCell topicCell: LessonPlanMainViewCell, withHeight height: CGFloat)
    {
        topicCell.frame = CGRect(x: topicCell.frame.origin.x, y: topicCell.frame.origin.y, width: topicCell.frame.width, height: height)
        rearrangeScrollView()
    }
    
    func delegateQuestionButtonPressedWithDetails(_ topicDetails: AnyObject)
    {
                let SubTopicsView = LessonPlanQuestionView(frame: CGRect(x: 0,y: 0,width: self.frame.size.width,height: self.frame.size.height ))
                SubTopicsView.setCurrentMainTopicDetails(topicDetails)
        
                UIView.animate(withDuration: 0.6, animations:
                    {
                     SubTopicsView.frame =  CGRect(x: 0,y: 0,width: self.frame.size.width,height: self.frame.size.height )
                    })
        
        
                SubTopicsView.setdelegate(self)
                self.addSubview(SubTopicsView)
        
    }
    
    func delegateMainTopicCheckMarkPressedWithState(_ SelectedState: Bool, withCurrentTopicDatails details: AnyObject)
    {
        
    }
    
    // MARK: - subTopic View delegate functions
    
    func delegateCellStateChangedWithState(_ SelectedState: Bool, withIndexValue indexValue: Int, withCurrentTopicDatails details: AnyObject, withChecMarkState checkMark: Int) {
        
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
    
    
    
    func delegateSubTopicRemovedWithTopicDetails(_ topicDetails: AnyObject)
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
        
       let topicDetailsString = SSTeacherDataSource.sharedDataSource.taggedTopicIdArray.componentsJoined(by: ",")
        
        
        return topicDetailsString 
    }
    
    func searchingStarted()
    {
        let subViews =  mTopicsContainerView.subviews.flatMap{ $0 as? LessonPlanMainViewCell }
        for topicCell in subViews
        {
            if topicCell.isKind(of: LessonPlanMainViewCell.self)
            {
               topicCell.SubTopicsView.isHidden = true
                topicCell.onSubtopicButton()
            }
        }
    }
    
    func searchingStopped()
    {
        let subViews =  mTopicsContainerView.subviews.flatMap{ $0 as? LessonPlanMainViewCell }
        for topicCell in subViews
        {
            if topicCell.isKind(of: LessonPlanMainViewCell.self)
            {
                topicCell.SubTopicsView.isHidden = false
                topicCell.onSubtopicButton()
            }
        }
    }
    
    func searchingTextWithSearchText(_ searchText:String)
    {
        let subViews =  mTopicsContainerView.subviews.flatMap{ $0 as? LessonPlanMainViewCell }
        for topicCell in subViews
        {
            if topicCell.isKind(of: LessonPlanMainViewCell.self)
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
            if topicCell.isKind(of: LessonPlanMainViewCell.self)
            {
                UIView.animate(withDuration: 0.2, animations:
                    {
                        topicCell.frame = CGRect(x: topicCell.frame.origin.x ,y: currentYPosition,width: topicCell.frame.size.width,height: topicCell.frame.size.height)
                })
                
                currentYPosition = currentYPosition + topicCell.frame.size.height + 10
            }
        }
        
          mTopicsContainerView.contentSize = CGSize(width: 0, height: currentYPosition)
    }
    
    
}
