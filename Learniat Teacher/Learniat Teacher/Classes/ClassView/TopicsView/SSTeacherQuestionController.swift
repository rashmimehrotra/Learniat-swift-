//
//  SSTeacherQuestionController.swift
//  Learniat Teacher
//
//  Created by Deepak MK on 24/03/16.
//  Copyright © 2016 Mindshift. All rights reserved.
//

import Foundation

class SSTeacherQuestionController: UIViewController,SSTeacherDataSourceDelegate
{
    var _delgate: AnyObject!
    
    
    var currentSessionDetails       :AnyObject!
    
    var mTopicsContainerView        = UIScrollView()
    
    var mActivityIndicator  = UIActivityIndicatorView(activityIndicatorStyle:.Gray)
    
    var  mSubTopicName  = UILabel()
    
    var currentSubTopicId                  = ""
    
     var currentMainTopicID                 = ""
    
    var currentMainTopicName                = ""
    
    var questionsDetailsDictonary:Dictionary<String, NSMutableArray> = Dictionary()
    
    
    func setdelegate(delegate:AnyObject)
    {
        _delgate = delegate;
    }
    
    func   delegate()->AnyObject
    {
        return _delgate;
    }
    
    
    override func viewDidLoad()
    {
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
        mDoneButton.addTarget(self, action: "onScheduleScreenPopupPressed:", forControlEvents: UIControlEvents.TouchUpInside)
        mDoneButton.setTitleColor(standard_Button, forState: .Normal)
        mDoneButton.setTitle("Done", forState: .Normal)
        mDoneButton.contentHorizontalAlignment = UIControlContentHorizontalAlignment.Right
        mDoneButton.titleLabel?.font = UIFont(name: helveticaMedium, size: 20)
        
        
        
        
        let  mBackButton = UIButton(frame: CGRectMake(10,  0, 200 ,mTopbarImageView.frame.size.height))
        mTopbarImageView.addSubview(mBackButton)
        mBackButton.addTarget(self, action: "onBackButton", forControlEvents: UIControlEvents.TouchUpInside)
        mBackButton.setTitleColor(standard_Button, forState: .Normal)
        mBackButton.setTitle("Back", forState: .Normal)
        mBackButton.contentHorizontalAlignment = UIControlContentHorizontalAlignment.Left
        mBackButton.titleLabel?.font = UIFont(name: helveticaMedium, size: 20)
        
        
        mSubTopicName.frame = CGRectMake((mTopbarImageView.frame.size.width - 400)/2, 0 , 400, mTopbarImageView.frame.size.height)
        mSubTopicName.font = UIFont(name:helveticaMedium, size: 20)
        mTopbarImageView.addSubview(mSubTopicName)
        mSubTopicName.textColor = UIColor.blackColor()
        mSubTopicName.text = "Questions"
        mSubTopicName.textAlignment = .Center
        mSubTopicName.lineBreakMode = .ByTruncatingMiddle
        
        mActivityIndicator.frame = CGRectMake(100, 0, mTopbarImageView.frame.size.height,mTopbarImageView.frame.size.height)
        mTopbarImageView.addSubview(mActivityIndicator)
        mActivityIndicator.hidesWhenStopped = true
        mActivityIndicator.hidden = true
        
        
    }
    
    
    
    func getQuestionsDetailsWithsubTopicId(subTopicId:String, withSubTopicName subTopicName:String, withMainTopicId mainTopicId:String, withMainTopicName mainTopicName:String)
    {
        
        currentMainTopicID = mainTopicId
        currentMainTopicName = mainTopicName
        
        currentSubTopicId = subTopicId
        
        mSubTopicName.text = subTopicName
        if let currentMainTopicDetails = questionsDetailsDictonary[currentSubTopicId]
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
                        
                        SSTeacherDataSource.sharedDataSource.getAllNodesWithClassId(ClassId, withSubjectId: SubjectId, withTopicId: currentSubTopicId, withType: onlyQuestions, withDelegate: self)
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
                    
                    SSTeacherDataSource.sharedDataSource.getAllNodesWithClassId(ClassId, withSubjectId: SubjectId, withTopicId: currentSubTopicId, withType: onlyQuestions, withDelegate: self)
                }
                
                
            }
        }
        
        
    }
    
    
    // MARK: - datasource delegate functions
    
    func didGetAllNodesWithDetails(details: AnyObject) {
        
        print(details)
        
        if let statusString = details.objectForKey("Status") as? String
        {
            if statusString == kSuccessString
            {
                var mMaintopicsDetails = NSMutableArray()
                let classCheckingVariable = details.objectForKey("Questions")!.objectForKey("Question")!
                
                if classCheckingVariable.isKindOfClass(NSMutableArray)
                {
                    mMaintopicsDetails = classCheckingVariable as! NSMutableArray
                }
                else
                {
                    mMaintopicsDetails.addObject(details.objectForKey("Questions")!.objectForKey("Question")!)
                    
                }
                
                
                questionsDetailsDictonary[currentSubTopicId] = mMaintopicsDetails
                
                
                print(questionsDetailsDictonary)
                
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
        
        
        var height :CGFloat = CGFloat((mMaintopicsDetails.count * 60) + 44)
        
        
        if height > 700
        {
            height = 700
        }
        

        
        self.preferredContentSize = CGSize(width: 600, height: height)
        
        mTopicsContainerView.frame = CGRectMake(0, 44, mTopicsContainerView.frame.size.width, height - 44)
        
        var positionY :CGFloat = 0
        
        for var index = 0; index < mMaintopicsDetails.count ; index++
        {
            let currentTopicDetails = mMaintopicsDetails.objectAtIndex(index)
            
            
            let topicCell = QuestionCell(frame: CGRectMake(0  , positionY, mTopicsContainerView.frame.size.width, 60))
            topicCell.setdelegate(self)
         
            topicCell.frame =   CGRectMake(0  , positionY, mTopicsContainerView.frame.size.width, topicCell.getCurrentCellHeightWithDetails(currentTopicDetails, WIthCountValue: index + 1))
                        
            mTopicsContainerView.addSubview(topicCell)
            positionY = positionY + topicCell.frame.size.height
        }
        
        mTopicsContainerView.contentSize = CGSizeMake(0, positionY + 20)
        
        mActivityIndicator.stopAnimating()
    }
    
    
    func onBackButton()
    {
//        if delegate().respondsToSelector(Selector("delegateSubTopicBackButtonPressed"))
//        {
//            delegate().delegateSubTopicBackButtonPressed!()
//        }
    }
    
    
    
    
    
}