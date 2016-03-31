//
//  SubtopicController.swift
//  LearniatTeacher
//
//  Created by Deepak MK on 30/03/16.
//  Copyright © 2016 Mindshift. All rights reserved.
//

import Foundation


@objc protocol SubtopicControllerDelegate
{
    
    
    optional func delegateSubTopicBackButtonPressed()
    
    optional func delegateSubtopicStateChanedWithID(subTopicId:String, withState state:Bool, withSubtopicName subTopicName:String, withmainTopicName mainTopicName:String)
    
    
    optional func delegateQuestionButtonPressedWithSubtopicId(subtopicId:String, withSubTopicName subTopicName:String, withMainTopicId mainTopicId:String, withMainTopicName mainTopicName:String)
    
    
    optional func delegateSubtopicHiddenWithCumulativeTime(cumulativeTime:String)
    
    optional func delegateStopCumulativeTimmer()
    
    optional func delegateDoneButtonPressed()
    
}


class SubtopicController: UIViewController, SSTeacherDataSourceDelegate
{
    var _delgate: AnyObject!
    
    var currentSessionDetails       :AnyObject!
    
    var mTopicsContainerView        = UIScrollView()
    
    var mSubtopciDetails          = NSMutableArray()
    
    var startedmainTopicId           = ""
    
    var mActivityIndicator  = UIActivityIndicatorView(activityIndicatorStyle:.Gray)
    
    var  mTopicName  = UILabel()

    var currentMainTopicId                  = ""
    
    var startedSubtopicID                   = ""
    
    var currentCumulativeTime              = ""
    
    
    func setdelegate(delegate:AnyObject)
    {
        _delgate = delegate;
    }
    
    func   delegate()->AnyObject
    {
        return _delgate;
    }

    
    override func viewDidLoad() {
      
        super.viewDidLoad()
        self.view.setNeedsLayout()
        self.view.layoutIfNeeded()
        
        
    }
    
    func setPreferredSize(size:CGSize, withSessionDetails details:AnyObject)
    {
        
        
        
        currentSessionDetails = details
        
        let mTopbarImageView = UIImageView(frame: CGRectMake(0, 0, size.width, 44))
        mTopbarImageView.backgroundColor = UIColor.whiteColor()
        self.view.addSubview(mTopbarImageView)
        mTopbarImageView.userInteractionEnabled = true
        
        
        
        
        
        
        mTopicsContainerView.frame = CGRectMake(0, 44, size.width, size.height - 44)
        mTopicsContainerView.backgroundColor = UIColor.whiteColor()
        self.view.addSubview(mTopicsContainerView)
        mTopicsContainerView.hidden = true
        
        
        let seperatorView = UIView(frame: CGRectMake(0 ,mTopbarImageView.frame.size.height - 1 , mTopbarImageView.frame.size.width,1))
        seperatorView.backgroundColor = LineGrayColor;
        mTopbarImageView.addSubview(seperatorView)
        
        
        let  mDoneButton = UIButton(frame: CGRectMake(mTopbarImageView.frame.size.width - 210,  0, 200 ,mTopbarImageView.frame.size.height))
        mTopbarImageView.addSubview(mDoneButton)
        mDoneButton.addTarget(self, action: "onDoneButton", forControlEvents: UIControlEvents.TouchUpInside)
        mDoneButton.setTitleColor(standard_Button, forState: .Normal)
        mDoneButton.setTitle("Done", forState: .Normal)
        mDoneButton.contentHorizontalAlignment = UIControlContentHorizontalAlignment.Right
        mDoneButton.titleLabel?.font = UIFont(name: helveticaMedium, size: 20)
        
        
        mTopicName.frame = CGRectMake((mTopbarImageView.frame.size.width - 200)/2, 0 , 200, mTopbarImageView.frame.size.height)
        mTopicName.font = UIFont(name:helveticaMedium, size: 20)
        mTopbarImageView.addSubview(mTopicName)
        mTopicName.textColor = UIColor.blackColor()
        mTopicName.text = "Topics"
        mTopicName.textAlignment = .Center
        
        
        mActivityIndicator.frame = CGRectMake(20, 0, mTopbarImageView.frame.size.height,mTopbarImageView.frame.size.height)
        mTopbarImageView.addSubview(mActivityIndicator)
        mActivityIndicator.hidesWhenStopped = true
        mActivityIndicator.hidden = true
        
        
    }
    
    func getSubtopicsDetailsWithMainTopicId(mainTopicId:String, withMainTopicName mainTopicname:String, withStartedSubtopicID _startedSubtopicID:String, withCumulativeTime cumulativeTime: String)
    {
        
        currentCumulativeTime = cumulativeTime
        currentMainTopicId = mainTopicId
        startedSubtopicID = _startedSubtopicID
        mTopicName.text = mainTopicname
        
        if let currentMainTopicDetails = SSTeacherDataSource.sharedDataSource.subTopicDetailsDictonary.objectForKey(currentMainTopicId) as? NSMutableArray
        {
            
            if currentMainTopicDetails.count > 0
            {
                addSubtopicWithCurrentSubtopicsArray(currentMainTopicDetails)
            }
            else
            {
                if let ClassId = currentSessionDetails.objectForKey("ClassId") as? String
                {
                    
                    if let SubjectId = currentSessionDetails.objectForKey("SubjectId") as? String
                    {
                        
                        mActivityIndicator.hidden = false
                        mActivityIndicator.startAnimating()
                        
                        SSTeacherDataSource.sharedDataSource.getAllNodesWithClassId(ClassId, withSubjectId: SubjectId, withTopicId: currentMainTopicId, withType: onlySubTopics, withDelegate: self)
                    }
                }
            }
        }
        else
        {
            if let ClassId = currentSessionDetails.objectForKey("ClassId") as? String
            {
                
                if let SubjectId = currentSessionDetails.objectForKey("SubjectId") as? String
                {
                    
                    mActivityIndicator.hidden = false
                    mActivityIndicator.startAnimating()
                    
                    SSTeacherDataSource.sharedDataSource.getAllNodesWithClassId(ClassId, withSubjectId: SubjectId, withTopicId: currentMainTopicId, withType: onlySubTopics, withDelegate: self)
                }
            }
        }
    }
    
    
    func didGetAllNodesWithDetails(details: AnyObject)
    {
        if let statusString = details.objectForKey("Status") as? String
        {
            if statusString == kSuccessString
            {
                var mMaintopicsDetails = NSMutableArray()
                let classCheckingVariable = details.objectForKey("SubTopics")!.objectForKey("SubTopic")!
                
                if classCheckingVariable.isKindOfClass(NSMutableArray)
                {
                    mMaintopicsDetails = classCheckingVariable as! NSMutableArray
                }
                else
                {
                    mMaintopicsDetails.addObject(details.objectForKey("SubTopics")!.objectForKey("SubTopic")!)
                    
                }
                addSubtopicWithCurrentSubtopicsArray(mMaintopicsDetails)
                
                SSTeacherDataSource.sharedDataSource.setSubTopicDictonaryWithDict(mMaintopicsDetails, withKey: currentMainTopicId)
            }
        }
    }
    
    func addSubtopicWithCurrentSubtopicsArray(subTopicArray:NSMutableArray)
    {
        if subTopicArray.count <= 0
        {
            mTopicsContainerView.hidden = true
        }
        else
        {
            mTopicsContainerView.hidden = false
        }
        
        
        
        
        let topicsArray = NSMutableArray()
        for var index = 0; index < subTopicArray.count ; index++
        {
            
            
            let currentTopicDetails = subTopicArray.objectAtIndex(index)
            
            if let Tagged = currentTopicDetails.objectForKey("Tagged") as? String
            {
                if Tagged == "1"
                {
                    topicsArray.addObject(currentTopicDetails)
                }
            }
        }
        
        var height :CGFloat = CGFloat((topicsArray.count * 60) + 44)
        
        
        if height > 700
        {
            height = 700
        }
        
        
        self.preferredContentSize = CGSize(width: 600, height: height)
        
        
        
        mTopicsContainerView.frame = CGRectMake(0, 44, mTopicsContainerView.frame.size.width, height - 44)
        
        var positionY :CGFloat = 0
        
        for var index = 0; index < topicsArray.count ; index++
        {
            let currentTopicDetails = topicsArray.objectAtIndex(index)
            let topicCell = SubTopicCell(frame: CGRectMake(0  , positionY, mTopicsContainerView.frame.size.width, 60))
            topicCell.setdelegate(self)
            topicCell.setMainTopicDetails(currentTopicDetails)

            if let id = currentTopicDetails.objectForKey("Id") as? String
            {
                if id == startedSubtopicID
                {
                    topicCell.startButton.setTitle("Stop", forState: .Normal)
                    topicCell.startButton.setTitleColor(standard_Red, forState: .Normal)
                    topicCell.subTopicStatred()
                    delegate().delegateStopCumulativeTimmer!()
                    
                    
                    if currentCumulativeTime != ""
                    {
                        currentTopicDetails.setObject(currentCumulativeTime, forKey: "CumulativeTime")
                    }
                }
                else
                {
                    topicCell.startButton.setTitle("Start", forState: .Normal)
                    topicCell.startButton.setTitleColor(standard_Green, forState: .Normal)
                    topicCell.subTopicStopped()
                }
            }
            
            
            
            mTopicsContainerView.addSubview(topicCell)
            positionY = positionY + topicCell.frame.size.height
        }
        
        mTopicsContainerView.contentSize = CGSizeMake(0, positionY + 20)
        
        mActivityIndicator.stopAnimating()
    }
    
    func onBackButton()
    {
        if delegate().respondsToSelector(Selector("delegateSubTopicBackButtonPressed"))
        {
            delegate().delegateSubTopicBackButtonPressed!()
        }
    }
    
    
    // MARK: - SubTopics delegate functions
    
    func delegateQuestionButtonPressedWithID(subTopicId: String, withSubTopicName subTopicName: String) {
        
        if delegate().respondsToSelector(Selector("delegateQuestionButtonPressedWithSubtopicId:withSubTopicName:withMainTopicId:withMainTopicName:"))
        {
            
            delegate().delegateQuestionButtonPressedWithSubtopicId!(subTopicId, withSubTopicName: subTopicName, withMainTopicId: currentMainTopicId, withMainTopicName: mTopicName.text!)
        }
        
        
        
        let subViews = mTopicsContainerView.subviews.flatMap{ $0 as? SubTopicCell }
        
        for subview in subViews
        {
            if subview.isKindOfClass(SubTopicCell)
            {
                if subview.startButton.titleLabel?.text == "Stop"
                {
                    delegate().delegateSubtopicHiddenWithCumulativeTime!((subview.currentSubTopicDetails.objectForKey("CumulativeTime")as? String)!)
                    
                }
                subview.subTopicStopped()
                subview.removeFromSuperview()
            }
        }
        
        
        
    }
    
    func onDoneButton()
    {
        if delegate().respondsToSelector(Selector("delegateDoneButtonPressed"))
        {
            delegate().delegateDoneButtonPressed!()
        }
    }
    
    func delegateSubTopicCellStartedWithId(subTopicId:String, witStatedState isStarted:Bool,withSubTopicName subTopicName:String)
    {
        if delegate().respondsToSelector(Selector("delegateSubtopicStateChanedWithID:withState:withSubtopicName:withmainTopicName:"))
        {
            delegate().delegateSubtopicStateChanedWithID!(subTopicId, withState: isStarted,withSubtopicName:subTopicName,withmainTopicName: mTopicName.text!)
        }
        
    }
}