//
//  SubTopicsView.swift
//  LearniatTeacher
//
//  Created by Deepak MK on 25/04/16.
//  Copyright © 2016 Mindshift. All rights reserved.
//

import Foundation
@objc protocol SubTopicsViewDelegate
{
    
    
    optional func delegateSubTopicBackButtonPressed()
    
    optional func delegateSubtopicStateChanedWithSubTopicDetails(subTopicDetails:AnyObject, withState state:Bool, withmainTopicName mainTopicName:String)
    
    
    optional func delegateQuestionButtonPressedWithSubtopicId(subtopicId:String, withSubTopicName subTopicName:String, withMainTopicId mainTopicId:String, withMainTopicName mainTopicName:String)
    

    optional func delegateDoneButtonPressed()
    
    optional func delegateTopicsSizeChangedWithHeight(height:CGFloat)
    
}

class SubTopicsView: UIView,SSTeacherDataSourceDelegate, SubTopicCellDelegate
{
    var _delgate: AnyObject!
    
    
    var currentSessionDetails       :AnyObject!
    
    var mTopicsContainerView        = UIScrollView()
    
    var mActivityIndicator  = UIActivityIndicatorView(activityIndicatorStyle:.Gray)
    
    var  mTopicName  = UILabel()
    
    var currentMainTopicId                  = ""
    
    var startedSubtopicID                   = ""
    
    
     var currentMainTopicsViewHeight :CGFloat = 0
    
    
    var cumulativeTimer                    = NSTimer()
    
    var currentCumulativeiTime              = ""
    
    
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
        
        
        let mTopbarImageView = UIImageView(frame: CGRectMake(0, 0, self.frame.size.width, 44))
        mTopbarImageView.backgroundColor = lightGrayTopBar
        self.addSubview(mTopbarImageView)
        mTopbarImageView.userInteractionEnabled = true
        
        
        
        
        
        
        mTopicsContainerView.frame = CGRectMake(0, 44, self.frame.size.width, self.frame.size.height - 44)
        mTopicsContainerView.backgroundColor = UIColor.whiteColor()
        self.addSubview(mTopicsContainerView)
        mTopicsContainerView.hidden = true
        
        
        let seperatorView = UIView(frame: CGRectMake(0 ,mTopbarImageView.frame.size.height - 1 , mTopbarImageView.frame.size.width,1))
        seperatorView.backgroundColor = LineGrayColor;
        mTopbarImageView.addSubview(seperatorView)
        
        
        let  mDoneButton = UIButton(frame: CGRectMake(mTopbarImageView.frame.size.width - 210,  0, 200 ,mTopbarImageView.frame.size.height))
        mTopbarImageView.addSubview(mDoneButton)
        mDoneButton.addTarget(self, action: #selector(SubTopicsView.onDoneButton), forControlEvents: UIControlEvents.TouchUpInside)
        mDoneButton.setTitleColor(standard_Button, forState: .Normal)
        mDoneButton.setTitle("Done", forState: .Normal)
        mDoneButton.contentHorizontalAlignment = UIControlContentHorizontalAlignment.Right
        mDoneButton.titleLabel?.font = UIFont(name: helveticaMedium, size: 20)
        
        
        
        
        let  mBackButton = UIButton(frame: CGRectMake(10,  0, 200 ,mTopbarImageView.frame.size.height))
        mTopbarImageView.addSubview(mBackButton)
        mBackButton.addTarget(self, action: #selector(SubTopicsView.onBackButton), forControlEvents: UIControlEvents.TouchUpInside)
        mBackButton.setTitleColor(standard_Button, forState: .Normal)
        mBackButton.setTitle("Back", forState: .Normal)
        mBackButton.contentHorizontalAlignment = UIControlContentHorizontalAlignment.Left
        mBackButton.titleLabel?.font = UIFont(name: helveticaMedium, size: 20)
        
        
        mTopicName.frame = CGRectMake((mTopbarImageView.frame.size.width - 400)/2, 0 , 400, mTopbarImageView.frame.size.height)
        mTopicName.font = UIFont(name:helveticaMedium, size: 20)
        mTopbarImageView.addSubview(mTopicName)
        mTopicName.textColor = UIColor.blackColor()
        mTopicName.text = "Sub topics"
        mTopicName.textAlignment = .Center
        mTopicName.lineBreakMode = .ByTruncatingMiddle
        
        mActivityIndicator.frame = CGRectMake(100, 0, mTopbarImageView.frame.size.height,mTopbarImageView.frame.size.height)
        mTopbarImageView.addSubview(mActivityIndicator)
        mActivityIndicator.hidesWhenStopped = true
        mActivityIndicator.hidden = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    func setSessionDetails(details:AnyObject)
    {
        currentSessionDetails = details
       
        
        
    }
    
    
    
    func clearSubTopicDetailsWithMainTopicId(mainTopicId:String)
    {
       
        if SSTeacherDataSource.sharedDataSource.subTopicDetailsDictonary.objectForKey(mainTopicId) != nil
        {
            SSTeacherDataSource.sharedDataSource.subTopicDetailsDictonary.removeObjectForKey(mainTopicId)
        }
    }
    
    
    func getSubtopicsDetailsWithMainTopicId(mainTopicId:String, withMainTopicName mainTopicname:String, withStartedSubtopicID _startedSubtopicID:String)
    {
        
        currentMainTopicId = mainTopicId
        startedSubtopicID = _startedSubtopicID
        mTopicName.text = mainTopicname
        
        
        
        
        
        
        if let currentMainTopicDetails = SSTeacherDataSource.sharedDataSource.subTopicDetailsDictonary.objectForKey(currentMainTopicId) as? NSMutableArray
        {
            
            if currentMainTopicDetails.count > 0
            {
                addTopicsWithDetailsArray(currentMainTopicDetails)
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
                    
                    let subViews = mTopicsContainerView.subviews.flatMap{ $0 as? SubTopicCell }
                    
                    for subview in subViews
                    {
                        if subview.isKindOfClass(SubTopicCell)
                        {
                            subview.removeFromSuperview()
                        }
                    }
                    mActivityIndicator.hidden = false
                    mActivityIndicator.startAnimating()
                    
                    SSTeacherDataSource.sharedDataSource.getAllNodesWithClassId(ClassId, withSubjectId: SubjectId, withTopicId: currentMainTopicId, withType: onlySubTopics, withDelegate: self)
                }
                
                
            }
        }
        
        
    }
    
    
    
    func updateSubtopicCumulativeTimeWithID(subToicId:String, withCumulativeTime cumulativeTime:String)
    {
        if let subTopicView  = mTopicsContainerView.viewWithTag(Int(subToicId)!) as? SubTopicCell
        {
            subTopicView.m_SubTopicLabel.text = cumulativeTime.capitalizedString
            
        }
    }
    
    
    // MARK: - datasource delegate functions
    
    func didGetAllNodesWithDetails(details: AnyObject) {
        
        
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
                
                
                SSTeacherDataSource.sharedDataSource.setSubTopicDictonaryWithDict(mMaintopicsDetails, withKey: currentMainTopicId)
                
                
                
                
                addTopicsWithDetailsArray(mMaintopicsDetails)
            }
        }
    }
    
    
    func addTopicsWithDetailsArray(mMaintopicsDetails:NSMutableArray)
    {
        
        
        
        if mMaintopicsDetails.count <= 0
        {
            mTopicsContainerView.hidden = true
        }
        else
        {
            mTopicsContainerView.hidden = false
        }
        
        
        
        
        let subViews = mTopicsContainerView.subviews.flatMap{ $0 as? SubTopicCell }
        
        for subview in subViews
        {
            if subview.isKindOfClass(SubTopicCell)
            {
                subview.removeFromSuperview()
            }
        }
        
        
        
        let topicsArray = NSMutableArray()
        for index in 0 ..< mMaintopicsDetails.count
        {
            
            
            let currentTopicDetails = mMaintopicsDetails.objectAtIndex(index)
            if let Tagged = currentTopicDetails.objectForKey("Tagged") as? String
            {
                if Tagged == "1"
                {
                    topicsArray.addObject(currentTopicDetails)
                }
            }
        }
        
        
        
        var height :CGFloat = CGFloat((topicsArray.count * 60) + 44)
        
        
        if height > UIScreen.mainScreen().bounds.height - 100
        {
            height = UIScreen.mainScreen().bounds.height - 100
        }
        
        
        currentMainTopicsViewHeight = height
        
        UIView.animateWithDuration(0.5, animations:
            {
                self.frame =  CGRectMake(self.frame.origin.x, self.frame.origin.y, 600, height)
        })
        
        
        
        mTopicsContainerView.frame = CGRectMake(0, 44, mTopicsContainerView.frame.size.width, height - 44)
        
        var positionY :CGFloat = 0
        
        for index in 0 ..< topicsArray.count
        {
            let currentTopicDetails = topicsArray.objectAtIndex(index)
            
            if let Tagged = currentTopicDetails.objectForKey("Tagged") as? String
            {
                if Tagged == "1"
                {
                    let topicCell = SubTopicCell(frame: CGRectMake(0  , positionY, mTopicsContainerView.frame.size.width, 60))
                    topicCell.setdelegate(self)
                    topicCell.setSubTopicDetails(currentTopicDetails)
                    
                    
                    if let id = currentTopicDetails.objectForKey("Id") as? String
                    {
                        if id == SSTeacherDataSource.sharedDataSource.startedSubTopicId && SSTeacherDataSource.sharedDataSource.isSubtopicStarted == true
                        {
                            topicCell.startButton.setTitle("Stop", forState: .Normal)
                            topicCell.startButton.setTitleColor(standard_Red, forState: .Normal)
                            
                            if let topicName = currentTopicDetails.objectForKey("Name")as? String
                            {
                                topicCell.m_SubTopicLabel.text = "\(topicName)(\(currentCumulativeiTime))".capitalizedString
                                
                            }
                           
                        }
                        else
                        {
                            topicCell.startButton.setTitle("Start", forState: .Normal)
                            topicCell.startButton.setTitleColor(standard_Green, forState: .Normal)
                        }
                    }
                    
                   
                    
                    mTopicsContainerView.addSubview(topicCell)
                    positionY = positionY + topicCell.frame.size.height
                    
                }
            }
            
            
        }
        
        mTopicsContainerView.contentSize = CGSizeMake(0, positionY + 20)
        
        mActivityIndicator.stopAnimating()
        
        
        if delegate().respondsToSelector(#selector(SubTopicsViewDelegate.delegateTopicsSizeChangedWithHeight(_:)))
        {
            delegate().delegateTopicsSizeChangedWithHeight!(height)
        }
    }
    
    
    func onBackButton()
    {
        if delegate().respondsToSelector(#selector(SubTopicsViewDelegate.delegateSubTopicBackButtonPressed))
        {
            delegate().delegateSubTopicBackButtonPressed!()
        }
    }
    
    
    // MARK: - SubTopics delegate functions
    
    func delegateQuestionButtonPressedWithID(subTopicId: String, withSubTopicName subTopicName: String) {
        
        if delegate().respondsToSelector(#selector(SubTopicsViewDelegate.delegateQuestionButtonPressedWithSubtopicId(_:withSubTopicName:withMainTopicId:withMainTopicName:)))
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
                    //                    delegate().delegateSubtopicHiddenWithCumulativeTime!((subview.currentSubTopicDetails.objectForKey("CumulativeTime")as? String)!)
                    
                }
                subview.removeFromSuperview()
            }
        }
    }
    
    
    func onDoneButton()
    {
        if delegate().respondsToSelector(#selector(SubTopicsViewDelegate.delegateDoneButtonPressed))
        {
            delegate().delegateDoneButtonPressed!()
        }
    }
  
    func delegateSubTopicCellStartedWithDetails(subTopicDetails: AnyObject, witStatedState isStarted: Bool) {
        
        
        
        if SSTeacherDataSource.sharedDataSource.subTopicDetailsDictonary.objectForKey(currentMainTopicId) != nil
        {
            SSTeacherDataSource.sharedDataSource.subTopicDetailsDictonary.removeObjectForKey(currentMainTopicId)
        }

        
        if isStarted == true
        {
            
            if SSTeacherDataSource.sharedDataSource.isSubtopicStarted == true
            {
                if let subTopicCellView  = mTopicsContainerView.viewWithTag(Int(SSTeacherDataSource.sharedDataSource.startedSubTopicId)!) as? SubTopicCell
                {
                    subTopicCellView.startButton.setTitle("Stop", forState: .Normal)
                    subTopicCellView.startButton.setTitleColor(standard_Red, forState: .Normal)
                    
                }
                
                if let CumulativeTime = subTopicDetails.objectForKey("CumulativeTime")as? String
                {
                    currentCumulativeiTime = CumulativeTime
                    
                }
                
                SSTeacherDataSource.sharedDataSource.startedMainTopicId = currentMainTopicId
                
                SSTeacherDataSource.sharedDataSource.startedMainTopicName = mTopicName.text!
                
                
                
                cumulativeTimer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: #selector(SubTopicsView.udpateCumulativeTime), userInfo: nil, repeats: true)
            }
            else
            {
                self.makeToast("Please stop current topic to start new topic.", duration: 5.0, position: .Bottom)
            }
            
            
        }
        else
        {
            cumulativeTimer.invalidate()
            
            if let subTopicCellView  = mTopicsContainerView.viewWithTag(Int(SSTeacherDataSource.sharedDataSource.startedSubTopicId)!) as? SubTopicCell
            {
                subTopicCellView.startButton.setTitle("Resume", forState: .Normal)
               subTopicCellView.startButton.setTitleColor(standard_Green, forState: .Normal)

            }
            
           
            

        }
        
        if delegate().respondsToSelector(#selector(SubTopicsViewDelegate.delegateSubtopicStateChanedWithSubTopicDetails(_:withState:withmainTopicName:)))
        {
            delegate().delegateSubtopicStateChanedWithSubTopicDetails!(subTopicDetails, withState: isStarted, withmainTopicName: mTopicName.text!)
        }
        
    }
    
    
    
    func udpateCumulativeTime()
    {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "HH:mm:ss"
        
        var _string :String = ""
        var currentDate = NSDate()
        
        if SSTeacherDataSource.sharedDataSource.startedSubTopicId != ""
        {
            if let subTopicCellView  = mTopicsContainerView.viewWithTag(Int(SSTeacherDataSource.sharedDataSource.startedSubTopicId)!) as? SubTopicCell
            {
                
                currentDate = currentDate.addSeconds(1, withDate: dateFormatter.dateFromString(currentCumulativeiTime)!)
                _string = dateFormatter.stringFromDate(currentDate)
                
                
                currentCumulativeiTime = _string
                
                
                if let topicName = subTopicCellView.currentSubTopicDetails.objectForKey("Name")as? String
                {
                    subTopicCellView.m_SubTopicLabel.text = "\(topicName)(\(_string))".capitalizedString
                    
                }
            }
        }
        else{
            cumulativeTimer.invalidate()
        }
        
        
    }
    
    
    
}