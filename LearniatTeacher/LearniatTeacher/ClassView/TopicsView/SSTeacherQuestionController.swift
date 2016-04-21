//
//  SSTeacherQuestionController.swift
//  Learniat Teacher
//
//  Created by Deepak MK on 24/03/16.
//  Copyright © 2016 Mindshift. All rights reserved.
//

import Foundation


@objc protocol SSTeacherQuestionControllerDelegate
{
    
    
    optional func delegateQuestionSentWithQuestionDetails(questionDetails:AnyObject)
    
    
    optional func delegateQuestionBackButtonPressed(mainTopicId:String, withMainTopicName mainTopicName:String)
    
    optional func delegateDoneButtonPressed()
    
    
    optional func delegateScribbleQuestionWithSubtopicId(subTopicID:String)

    
    
}




class SSTeacherQuestionController: UIViewController,QuestionCellDelegate,SSTeacherDataSourceDelegate,UIPopoverControllerDelegate
{
    var _delgate: AnyObject!
    
    
    var currentSessionDetails       :AnyObject!
    
    var mTopicsContainerView        = UIScrollView()
    
    var mActivityIndicator  = UIActivityIndicatorView(activityIndicatorStyle:.Gray)
    
    var  mSubTopicName  = UILabel()
    
    var currentSubTopicId                  = ""
    
     var currentMainTopicID                 = ""
    
    var currentMainTopicName                = ""
    
    var isCurrentSubtopicStarted :Bool           = false
    
    
    var questionButtonsView         = UIView()
    
    var questionsDetailsDictonary:Dictionary<String, NSMutableArray> = Dictionary()
    
    var touchLocation :CGPoint!
    
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
        mDoneButton.addTarget(self, action: #selector(SSTeacherQuestionController.onDoneButton), forControlEvents: UIControlEvents.TouchUpInside)
        mDoneButton.setTitleColor(standard_Button, forState: .Normal)
        mDoneButton.setTitle("Done", forState: .Normal)
        mDoneButton.contentHorizontalAlignment = UIControlContentHorizontalAlignment.Right
        mDoneButton.titleLabel?.font = UIFont(name: helveticaMedium, size: 20)
        
        
        
        
        let  mBackButton = UIButton(frame: CGRectMake(10,  0, 200 ,mTopbarImageView.frame.size.height))
        mTopbarImageView.addSubview(mBackButton)
        mBackButton.addTarget(self, action: #selector(SSTeacherQuestionController.onBackButton), forControlEvents: UIControlEvents.TouchUpInside)
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
        
        
        
        questionButtonsView.frame = CGRectMake(0, mTopicsContainerView.frame.size.height + mTopicsContainerView.frame.origin.y, mTopicsContainerView.frame.size.width, 44)
        self.view.addSubview(questionButtonsView)
        questionButtonsView.backgroundColor = UIColor.whiteColor()
        
        
        let  mScribbleButton = UIButton(frame: CGRectMake(20,  0, 160 ,mTopbarImageView.frame.size.height))
        questionButtonsView.addSubview(mScribbleButton)
        mScribbleButton.addTarget(self, action: #selector(SSTeacherQuestionController.onScribbleButton), forControlEvents: UIControlEvents.TouchUpInside)
        mScribbleButton.setTitleColor(standard_Button, forState: .Normal)
        mScribbleButton.setTitle("Scribble", forState: .Normal)
        mScribbleButton.contentHorizontalAlignment = UIControlContentHorizontalAlignment.Left
        mScribbleButton.titleLabel?.font = UIFont(name: helveticaMedium, size: 20)
        
        
        let  mMatchColumn = UIButton(frame: CGRectMake(220,  0, 160 ,mTopbarImageView.frame.size.height))
        questionButtonsView.addSubview(mMatchColumn)
        mMatchColumn.addTarget(self, action: #selector(SSTeacherQuestionController.onMTCButton), forControlEvents: UIControlEvents.TouchUpInside)
        mMatchColumn.setTitleColor(standard_Button, forState: .Normal)
        mMatchColumn.setTitle("MTC", forState: .Normal)
        mMatchColumn.contentHorizontalAlignment = UIControlContentHorizontalAlignment.Center
        mMatchColumn.titleLabel?.font = UIFont(name: helveticaMedium, size: 20)
        
        
        let  mMRQ = UIButton(frame: CGRectMake(mTopbarImageView.frame.size.width - 180 ,  0, 160 ,mTopbarImageView.frame.size.height))
        questionButtonsView.addSubview(mMRQ)
        mMRQ.addTarget(self, action: #selector(SSTeacherQuestionController.onMRQButton), forControlEvents: UIControlEvents.TouchUpInside)
        mMRQ.setTitleColor(standard_Button, forState: .Normal)
        mMRQ.setTitle("MRQ", forState: .Normal)
        mMRQ.contentHorizontalAlignment = UIControlContentHorizontalAlignment.Right
        mMRQ.titleLabel?.font = UIFont(name: helveticaMedium, size: 20)
        
        
        
        
        
        
    }
    
    
    
    func clearQuestionTopicId(subTopicId:String)
    {
        if (questionsDetailsDictonary[subTopicId] != nil)
        {
            questionsDetailsDictonary.removeValueForKey(subTopicId)
        }
    }
    
    
    
    func getQuestionsDetailsWithsubTopicId(subTopicId:String, withSubTopicName subTopicName:String, withMainTopicId mainTopicId:String, withMainTopicName mainTopicName:String, withSubtopicStarted isStarted:Bool)
    {
        
        currentMainTopicID = mainTopicId
        currentMainTopicName = mainTopicName
        
        currentSubTopicId = subTopicId
        
        isCurrentSubtopicStarted = isStarted
        
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
        
        
      var height :CGFloat = 44
        
        var positionY :CGFloat = 0
        
        for index in 0 ..< mMaintopicsDetails.count 
        {
            let currentTopicDetails = mMaintopicsDetails.objectAtIndex(index)
            
            
            let topicCell = QuestionCell(frame: CGRectMake(0  , positionY, mTopicsContainerView.frame.size.width, 60))
            topicCell.setdelegate(self)
         
            topicCell.frame =   CGRectMake(0  , positionY, mTopicsContainerView.frame.size.width, topicCell.getCurrentCellHeightWithDetails(currentTopicDetails, WIthCountValue: index + 1))
            
            
            if isCurrentSubtopicStarted == true
            {
                topicCell.mSendButton.hidden = false
            }
            else
            {
                topicCell.mSendButton.hidden = true
            }
            
            
            mTopicsContainerView.addSubview(topicCell)
            height = height + topicCell.frame.size.height
            
            positionY = positionY + topicCell.frame.size.height
        }
        
        
        
        
        if height > UIScreen.mainScreen().bounds.height - 100
        {
            height = UIScreen.mainScreen().bounds.height - 100
        }
        
        
        self.preferredContentSize = CGSize(width: 600, height: height)
        
        mTopicsContainerView.frame = CGRectMake(0, 44, mTopicsContainerView.frame.size.width, height - 88)
        
        mTopicsContainerView.contentSize = CGSizeMake(0, positionY + 20)
        
        questionButtonsView.frame = CGRectMake(0, mTopicsContainerView.frame.size.height + mTopicsContainerView.frame.origin.y, mTopicsContainerView.frame.size.width, 44)
        
        mActivityIndicator.stopAnimating()
    }
    
    
    
    var _Popover:AnyObject!
    
    func setPopover(popover:AnyObject)
    {
        _Popover = popover
    }
    
    func popover()-> AnyObject
    {
        return _Popover
    }
    func onDoneButton()
    {
        popover().dismissPopoverAnimated(true)
        
    }
    
    
//    func onDoneButton()
//    {
//        if delegate().respondsToSelector(Selector("delegateDoneButtonPressed"))
//        {
//            delegate().delegateDoneButtonPressed!()
//        }
//    }
    
    func onBackButton()
    {
        if delegate().respondsToSelector(#selector(SSTeacherQuestionControllerDelegate.delegateQuestionBackButtonPressed(_:withMainTopicName:)))
        {
            delegate().delegateQuestionBackButtonPressed!(currentMainTopicID, withMainTopicName: currentMainTopicName)
        }
    }
    
    
    
    func onScribbleButton()
    {
        
        if isCurrentSubtopicStarted == true
        {
            
            
            
            if delegate().respondsToSelector(#selector(SSTeacherQuestionControllerDelegate.delegateScribbleQuestionWithSubtopicId(_:)))
            {
                delegate().delegateScribbleQuestionWithSubtopicId!(currentSubTopicId)
                
                popover().dismissPopoverAnimated(true)
            }
        }
        else
        {
            
        }
        
      
    }
    
    
    func onMTCButton()
    {
        
    }
    
    func onMRQButton()
    {
        
    }
    
    
    
    // MARK: - Question delegate functions
    
    
    func delegateSendQuestionDetails(questionDetails: AnyObject) {
        
        if delegate().respondsToSelector(#selector(SSTeacherQuestionControllerDelegate.delegateQuestionSentWithQuestionDetails(_:)))
        {
            delegate().delegateQuestionSentWithQuestionDetails!(questionDetails)
            
        }
    }
    
    func delegateOnInfoButtonWithDetails(questionDetails: AnyObject, withButton infoButton: UIButton) {
        
        
        
        let buttonPosition :CGPoint = infoButton.convertPoint(CGPointZero, toView: self.view)
       
        
        if let questionType = questionDetails.objectForKey("Type") as? String
        {
            if questionType == "Overlay Scribble"
            {
                let questionInfoController = ScribbleQuestionInfoScreen()
                questionInfoController.setdelegate(self)
                
                questionInfoController.setScribbleInfoDetails(questionDetails)
                
                
                questionInfoController.preferredContentSize = CGSizeMake(400,317)
                
                let   classViewPopOverController = UIPopoverController(contentViewController: questionInfoController)
                questionInfoController.setPopover(classViewPopOverController)
                classViewPopOverController.popoverContentSize = CGSizeMake(400,317);
                classViewPopOverController.delegate = self;
                
                classViewPopOverController.presentPopoverFromRect(CGRect(
                    x:buttonPosition.x ,
                    y:buttonPosition.y + infoButton.frame.size.height / 2,
                    width: 1,
                    height: 1), inView: self.view, permittedArrowDirections: .Right, animated: true)
            }
            else if questionType == "Multiple Response" || questionType == "Multiple Choice"  
            {
                let questionInfoController = SingleResponceOption()
                

                questionInfoController.setQuestionDetails(questionDetails)
                
                
                questionInfoController.preferredContentSize = CGSizeMake(400,317)
                
                let   classViewPopOverController = UIPopoverController(contentViewController: questionInfoController)
                questionInfoController.setPopover(classViewPopOverController)
                classViewPopOverController.popoverContentSize = CGSizeMake(400,317);
                classViewPopOverController.delegate = self;
                
                classViewPopOverController.presentPopoverFromRect(CGRect(
                    x:buttonPosition.x ,
                    y:buttonPosition.y + infoButton.frame.size.height / 2,
                    width: 1,
                    height: 1), inView: self.view, permittedArrowDirections: .Right, animated: true)
            }
            else if questionType == "Match Columns"
            {
                let questionInfoController = MatchColumnOption()
                questionInfoController.setdelegate(self)
                
                questionInfoController.setQuestionDetails(questionDetails)
                
                
                questionInfoController.preferredContentSize = CGSizeMake(400,317)
                
                let   classViewPopOverController = UIPopoverController(contentViewController: questionInfoController)
                questionInfoController.setPopover(classViewPopOverController)
                classViewPopOverController.popoverContentSize = CGSizeMake(400,317);
                classViewPopOverController.delegate = self;
                
                classViewPopOverController.presentPopoverFromRect(CGRect(
                    x:buttonPosition.x ,
                    y:buttonPosition.y + infoButton.frame.size.height / 2,
                    width: 1,
                    height: 1), inView: self.view, permittedArrowDirections: .Right, animated: true)
            }
        }
    }
    
}