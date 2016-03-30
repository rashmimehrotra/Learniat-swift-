//
//  SSTeachermainTopicController.swift
//  Learniat Teacher
//
//  Created by Deepak MK on 24/03/16.
//  Copyright © 2016 Mindshift. All rights reserved.
//

import Foundation

@objc protocol SSTeachermainTopicControllerDelegate
{
    
    
    optional func delegateShowSubTopicWithMainTopicId(mainTopicID:String, WithMainTopicName mainTopicName:String)
    
    optional func delegateDoneButtonPressed()
    
}



class SSTeachermainTopicController: UIViewController, SSTeacherDataSourceDelegate,MainTopicCellDelegate
{
    
    var currentSessionDetails       :AnyObject!
    
    var mTopicsContainerView        = UIScrollView()
    
    var mMaintopicsDetails          = NSMutableArray()
    
    var mActivityIndicator  = UIActivityIndicatorView(activityIndicatorStyle:.Gray)
    
    var  mTopicName  = UILabel()
    
    
    var _delgate: AnyObject!
   
    
    
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
    
    
    
    func getTopicsDetails()
    {
        
        if mMaintopicsDetails.count > 0
        {
            addTopicsForheight()
        }
        else
        {
            if let ClassId = currentSessionDetails.objectForKey("ClassId") as? String
            {
                
                if let SubjectId = currentSessionDetails.objectForKey("SubjectId") as? String
                {
                    
                    let subViews = mTopicsContainerView.subviews.flatMap{ $0 as? MainTopicCell }
                    
                    for subview in subViews
                    {
                        if subview.isKindOfClass(MainTopicCell)
                        {
                            subview.removeFromSuperview()
                        }
                    }
                    
                    mActivityIndicator.hidden = false
                    mActivityIndicator.startAnimating()
                    
                    SSTeacherDataSource.sharedDataSource.getAllNodesWithClassId(ClassId, withSubjectId: SubjectId, withTopicId: "", withType: onlyMainTopics, withDelegate: self)
                }
                
                
            }
        }
        
        
    }
    
    
     // MARK: - datasource delegate functions
    
    func didGetAllNodesWithDetails(details: AnyObject) {

        mMaintopicsDetails.removeAllObjects()
        
        if let statusString = details.objectForKey("Status") as? String
        {
            if statusString == kSuccessString
            {
                
                let classCheckingVariable = details.objectForKey("MainTopics")!.objectForKey("MainTopic")!
                
                if classCheckingVariable.isKindOfClass(NSMutableArray)
                {
                    mMaintopicsDetails = classCheckingVariable as! NSMutableArray
                }
                else
                {
                    mMaintopicsDetails.addObject(details.objectForKey("MainTopics")!.objectForKey("MainTopic")!)
                    
                }
                
                addTopicsForheight()
            }
        }
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
            mTopicName.text = "Topics"
            mTopicsContainerView.hidden = false
        }
        
        
       
        
        let topicsArray = NSMutableArray()
        for var index = 0; index < mMaintopicsDetails.count ; index++
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
            let topicCell = MainTopicCell(frame: CGRectMake(0  , positionY, mTopicsContainerView.frame.size.width, 60))
            topicCell.setdelegate(self)
            topicCell.setMainTopicDetails(currentTopicDetails)
            mTopicsContainerView.addSubview(topicCell)
            positionY = positionY + topicCell.frame.size.height
        }
        
       mTopicsContainerView.contentSize = CGSizeMake(0, positionY + 20)
        
        mActivityIndicator.stopAnimating()
    }
    
    
    func onDoneButton()
    {
        if delegate().respondsToSelector(Selector("delegateDoneButtonPressed"))
        {
            delegate().delegateDoneButtonPressed!()
        }
    }
    
    
    func delegateSubtopicButtonPressedWithID(mainTopicId: String, withmainTopicname mainTopicName: String) {
        
        if delegate().respondsToSelector(Selector("delegateShowSubTopicWithMainTopicId:WithMainTopicName:"))
        {
            delegate().delegateShowSubTopicWithMainTopicId!(mainTopicId ,WithMainTopicName:mainTopicName )
        }
        
    }
    
    
}