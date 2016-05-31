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



class LessonPlanQuestionView: UIView,SSTeacherDataSourceDelegate,UIGestureRecognizerDelegate,LessonPlanSubTopicCellDelegate,UIPopoverControllerDelegate
{
    
    
    var _currentSessionDetails       :AnyObject!
    
    var mTopicsContainerView        = UIScrollView()
    
    var mQuestionsDetails          = NSMutableArray()
    
    var fullSubTopicLessonPlan              = NSMutableArray()
    
    var _currentMainTopicDetails      :AnyObject!
    
    var mainTopicCell           :LessonPlanMainViewCell!
    
    var _delgate: AnyObject!
   
    var questionButtonsView         = UIView()
    
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
        
        
        let backGroundView = UIView(frame:CGRectMake(0,0, self.frame.size.width,self.frame.size.height))
        self.addSubview(backGroundView)
        backGroundView.backgroundColor = blackTextColor
        backGroundView.alpha = 0.5
        
        
        
        mTopicsContainerView.frame = CGRectMake(100,60, self.frame.size.width - 200,self.frame.size.height - 104 )
        self.addSubview(mTopicsContainerView)
        mTopicsContainerView.backgroundColor = whiteBackgroundColor
        mTopicsContainerView.layer.shadowRadius = 1.0;
        
        mTopicsContainerView.layer.shadowColor = UIColor.blackColor().CGColor
        mTopicsContainerView.layer.shadowOpacity = 0.3
        mTopicsContainerView.layer.shadowOffset = CGSizeZero
        mTopicsContainerView.layer.shadowRadius = 10

        
        
//        questionButtonsView.frame = CGRectMake(100, mTopicsContainerView.frame.size.height + mTopicsContainerView.frame.origin.y, mTopicsContainerView.frame.size.width, 44)
        self.addSubview(questionButtonsView)
        questionButtonsView.backgroundColor = UIColor.whiteColor()
        questionButtonsView.layer.shadowColor = UIColor.blackColor().CGColor
        questionButtonsView.layer.shadowOpacity = 0.3
        questionButtonsView.layer.shadowOffset = CGSizeZero
        questionButtonsView.layer.shadowRadius = 10
        
        let  mScribbleButton = UIButton(frame: CGRectMake(20,  0, 160 ,questionButtonsView.frame.size.height))
        questionButtonsView.addSubview(mScribbleButton)
        mScribbleButton.addTarget(self, action: #selector(LessonPlanQuestionView.onScribbleButton), forControlEvents: UIControlEvents.TouchUpInside)
        mScribbleButton.setTitleColor(standard_Button, forState: .Normal)
        mScribbleButton.setTitle("Scribble", forState: .Normal)
        mScribbleButton.contentHorizontalAlignment = UIControlContentHorizontalAlignment.Left
        mScribbleButton.titleLabel?.font = UIFont(name: helveticaMedium, size: 20)
        
        
        let  mMatchColumn = UIButton(frame: CGRectMake(220,  0, 160 ,questionButtonsView.frame.size.height))
        questionButtonsView.addSubview(mMatchColumn)
        mMatchColumn.addTarget(self, action: #selector(LessonPlanQuestionView.onMTCButton), forControlEvents: UIControlEvents.TouchUpInside)
        mMatchColumn.setTitleColor(standard_Button, forState: .Normal)
        mMatchColumn.setTitle("MTC", forState: .Normal)
        mMatchColumn.contentHorizontalAlignment = UIControlContentHorizontalAlignment.Center
        mMatchColumn.titleLabel?.font = UIFont(name: helveticaMedium, size: 20)
        
        
        let  mMRQ = UIButton(frame: CGRectMake(questionButtonsView.frame.size.width - 180 ,  0, 160 ,questionButtonsView.frame.size.height))
        questionButtonsView.addSubview(mMRQ)
        mMRQ.addTarget(self, action: #selector(LessonPlanQuestionView.onMRQButton), forControlEvents: UIControlEvents.TouchUpInside)
        mMRQ.setTitleColor(standard_Button, forState: .Normal)
        mMRQ.setTitle("MRQ", forState: .Normal)
        mMRQ.contentHorizontalAlignment = UIControlContentHorizontalAlignment.Right
        mMRQ.titleLabel?.font = UIFont(name: helveticaMedium, size: 20)
        

        
        
         let imageview =  UIImageView(frame: CGRectMake(100  , 0, mTopicsContainerView.frame.size.width , 60))
        self.addSubview(imageview)
        imageview.backgroundColor = lightGrayTopBar
        
        mainTopicCell = LessonPlanMainViewCell(frame: CGRectMake(100  , 0, mTopicsContainerView.frame.size.width , 60))
        mainTopicCell.setdelegate(self)
        mainTopicCell.layer.cornerRadius = 5
        self.addSubview(mainTopicCell)
        mainTopicCell.mMainTopicView.backgroundColor = UIColor.whiteColor()
        mainTopicCell.mSubTopicButton.hidden = true
        mainTopicCell.checkBoxImage.hidden = true
        mainTopicCell.m_checkBoxButton.hidden = true
        mainTopicCell.mQuestionsButton.hidden = true
        mainTopicCell.layer.shadowColor = UIColor.blackColor().CGColor
        mainTopicCell.layer.shadowOpacity = 0.3
        mainTopicCell.layer.shadowOffset = CGSizeZero
        mainTopicCell.layer.shadowRadius = 5

        
        
        let  mDoneButton = UIButton(frame: CGRectMake( 10, 0, 100, 60))
        mDoneButton.addTarget(self, action: #selector(LessonPlanQuestionView.onBackButton), forControlEvents: UIControlEvents.TouchUpInside)
        mDoneButton.contentHorizontalAlignment = UIControlContentHorizontalAlignment.Left
        mainTopicCell.addSubview(mDoneButton)
        mDoneButton.setImage(UIImage(named: "arrow_Blue.png"), forState: .Normal)
        mDoneButton.imageView?.contentMode = .ScaleAspectFit
        
    }
    
    
    required init?(coder aDecoder: NSCoder)
    {
        fatalError("init(coder:) has not been implemented")
        
        
    }
    
    func onScribbleButton()
    {
        
    }
    
    
    func onMTCButton()
    {
        
    }
    
    func onMRQButton()
    {
        
    }

    
    func setCurrentMainTopicDetails(mainTopicDetails:AnyObject)
    {
        
        _currentMainTopicDetails = mainTopicDetails
        
        mQuestionsDetails.removeAllObjects()
        print(mainTopicDetails)
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
        
        
        
        var positionY :CGFloat = 10
        
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
        self.removeFromSuperview()
        
    }
    
    
    // MARK: - subTopic cell delegate functions
    
    
    func delegateQuestionPressedWithSubTopicDetails(topicDetails: AnyObject)
    {
        
        
    }
    
    func delegateOnInfoButtonWithDetails(questionDetails:AnyObject, withButton infoButton:UIImageView)
    {
        
        
        
        let buttonPosition :CGPoint = infoButton.convertPoint(CGPointZero, toView: self)
        
        
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
                    height: 1), inView: self, permittedArrowDirections: .Right, animated: true)
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
                    height: 1), inView: self, permittedArrowDirections: .Right, animated: true)
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
                    height: 1), inView: self, permittedArrowDirections: .Right, animated: true)
            }
        }
    }
    
    
}