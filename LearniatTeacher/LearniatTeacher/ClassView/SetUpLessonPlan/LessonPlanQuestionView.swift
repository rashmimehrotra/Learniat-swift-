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
    
    
    
    @objc optional func delegateSubTopicRemovedWithTopicDetails(_ topicDetails:AnyObject)
    
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
    
    func setdelegate(_ delegate:AnyObject)
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
        
        
        self.backgroundColor =  UIColor.clear
        
        
        let backGroundView = UIView(frame:CGRect(x: 0,y: 0, width: self.frame.size.width,height: self.frame.size.height))
        self.addSubview(backGroundView)
        backGroundView.backgroundColor = blackTextColor
        backGroundView.alpha = 0.5
        
        
        
        mTopicsContainerView.frame = CGRect(x: 100,y: 60, width: self.frame.size.width - 200,height: self.frame.size.height - 60 )
        self.addSubview(mTopicsContainerView)
        mTopicsContainerView.backgroundColor = whiteBackgroundColor
        mTopicsContainerView.layer.shadowRadius = 1.0;
        
        mTopicsContainerView.layer.shadowColor = UIColor.black.cgColor
        mTopicsContainerView.layer.shadowOpacity = 0.3
        mTopicsContainerView.layer.shadowOffset = CGSize.zero
        mTopicsContainerView.layer.shadowRadius = 10

        
        
//        questionButtonsView.frame = CGRectMake(100, mTopicsContainerView.frame.size.height + mTopicsContainerView.frame.origin.y, mTopicsContainerView.frame.size.width, 44)
//        self.addSubview(questionButtonsView)
        questionButtonsView.backgroundColor = UIColor.white
        questionButtonsView.layer.shadowColor = UIColor.black.cgColor
        questionButtonsView.layer.shadowOpacity = 0.3
        questionButtonsView.layer.shadowOffset = CGSize.zero
        questionButtonsView.layer.shadowRadius = 10
        
        let  mScribbleButton = UIButton(frame: CGRect(x: 20,  y: 0, width: 160 ,height: questionButtonsView.frame.size.height))
        questionButtonsView.addSubview(mScribbleButton)
        mScribbleButton.addTarget(self, action: #selector(LessonPlanQuestionView.onScribbleButton), for: UIControlEvents.touchUpInside)
        mScribbleButton.setTitleColor(standard_Button, for: UIControlState())
        mScribbleButton.setTitle("Scribble", for: UIControlState())
        mScribbleButton.contentHorizontalAlignment = UIControlContentHorizontalAlignment.left
        mScribbleButton.titleLabel?.font = UIFont(name: helveticaMedium, size: 20)
        
        
        let  mMatchColumn = UIButton(frame: CGRect(x: 220,  y: 0, width: 160 ,height: questionButtonsView.frame.size.height))
        questionButtonsView.addSubview(mMatchColumn)
        mMatchColumn.addTarget(self, action: #selector(LessonPlanQuestionView.onMTCButton), for: UIControlEvents.touchUpInside)
        mMatchColumn.setTitleColor(standard_Button, for: UIControlState())
        mMatchColumn.setTitle("MTC", for: UIControlState())
        mMatchColumn.contentHorizontalAlignment = UIControlContentHorizontalAlignment.center
        mMatchColumn.titleLabel?.font = UIFont(name: helveticaMedium, size: 20)
        
        
        let  mMRQ = UIButton(frame: CGRect(x: questionButtonsView.frame.size.width - 180 ,  y: 0, width: 160 ,height: questionButtonsView.frame.size.height))
        questionButtonsView.addSubview(mMRQ)
        mMRQ.addTarget(self, action: #selector(LessonPlanQuestionView.onMRQButton), for: UIControlEvents.touchUpInside)
        mMRQ.setTitleColor(standard_Button, for: UIControlState())
        mMRQ.setTitle("MRQ", for: UIControlState())
        mMRQ.contentHorizontalAlignment = UIControlContentHorizontalAlignment.right
        mMRQ.titleLabel?.font = UIFont(name: helveticaMedium, size: 20)
        

        
        
         let imageview =  UIImageView(frame: CGRect(x: 100  , y: 0, width: mTopicsContainerView.frame.size.width , height: 60))
        self.addSubview(imageview)
        imageview.backgroundColor = lightGrayTopBar
        
        mainTopicCell = LessonPlanMainViewCell(frame: CGRect(x: 100  , y: 0, width: mTopicsContainerView.frame.size.width , height: 60))
        mainTopicCell.setdelegate(self)
        mainTopicCell.layer.cornerRadius = 5
        self.addSubview(mainTopicCell)
        mainTopicCell.mMainTopicView.backgroundColor = UIColor.white
        mainTopicCell.mSubTopicButton.isHidden = true
        mainTopicCell.checkBoxImage.isHidden = true
        mainTopicCell.m_checkBoxButton.isHidden = true
        mainTopicCell.mQuestionsButton.isHidden = true
        mainTopicCell.layer.shadowColor = UIColor.black.cgColor
        mainTopicCell.layer.shadowOpacity = 0.3
        mainTopicCell.layer.shadowOffset = CGSize.zero
        mainTopicCell.layer.shadowRadius = 5

        
        
        let  mDoneButton = UIButton(frame: CGRect( x: 10, y: 0, width: 100, height: 60))
        mDoneButton.addTarget(self, action: #selector(LessonPlanQuestionView.onBackButton), for: UIControlEvents.touchUpInside)
        mDoneButton.contentHorizontalAlignment = UIControlContentHorizontalAlignment.left
        mainTopicCell.addSubview(mDoneButton)
        mDoneButton.setImage(UIImage(named: "arrow_Blue.png"), for: UIControlState())
        mDoneButton.imageView?.contentMode = .scaleAspectFit
        
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

    
    func setCurrentMainTopicDetails(_ mainTopicDetails:AnyObject)
    {
        
        _currentMainTopicDetails = mainTopicDetails
        
        mQuestionsDetails.removeAllObjects()
        if let classCheckingVariable = (mainTopicDetails.object(forKey: "Questions")! as AnyObject).object(forKey: "Question") as? NSMutableArray
        {
            mQuestionsDetails = classCheckingVariable as! NSMutableArray
        }
        else
        {
            mQuestionsDetails.add((mainTopicDetails.object(forKey: "Questions")! as AnyObject).object(forKey: "Question")!)
            
        }
        
        addTopicsForheight()
        
        mainTopicCell.setMainTopicDetails(mainTopicDetails, withIndexPath: 0)
        
        mainTopicCell.backgroundColor = UIColor.clear
        
        
    }
    
    
    
    func addTopicsForheight()
    {
        
        
        
        if mQuestionsDetails.count <= 0
        {
            
            mTopicsContainerView.isHidden = true
        }
        else
        {
            mTopicsContainerView.isHidden = false
        }
        
        
        
        var positionY :CGFloat = 10
        
        for index in 0 ..< mQuestionsDetails.count 
        {
            let currentTopicDetails = mQuestionsDetails.object(at: index)
            let topicCell = LessonPlanQuestionViewCell(frame: CGRect(x: 10  , y: positionY, width: mTopicsContainerView.frame.size.width - 20, height: 60))
            topicCell.setdelegate(self)
            topicCell.frame =   CGRect(x: 10  , y: positionY, width: mTopicsContainerView.frame.size.width - 20 , height: topicCell.getCurrentCellHeightWithDetails(currentTopicDetails as AnyObject, WIthCountValue: index + 1))
            mTopicsContainerView.addSubview(topicCell)
            positionY = positionY + topicCell.frame.size.height + 10
        }
        
        mTopicsContainerView.contentSize = CGSize(width: 0, height: positionY + 20)
        
    }
    
    func onBackButton()
    {
        self.removeFromSuperview()
        
    }
    
    
    // MARK: - subTopic cell delegate functions
    
    
    func delegateQuestionPressedWithSubTopicDetails(_ topicDetails: AnyObject)
    {
        
        
    }
    
    func delegateOnInfoButtonWithDetails(_ questionDetails:AnyObject, withButton infoButton:UIImageView)
    {
        
        
        
        let buttonPosition :CGPoint = infoButton.convert(CGPoint.zero, to: self)
        
        
        if let questionType = questionDetails.object(forKey: kQuestionType) as? String
        {
            if questionType == kOverlayScribble
            {
                let questionInfoController = ScribbleQuestionInfoScreen()
                questionInfoController.setdelegate(self)
                
                questionInfoController.setScribbleInfoDetails(questionDetails)
                
                
                questionInfoController.preferredContentSize = CGSize(width: 400,height: 317)
                
                SSTeacherDataSource.sharedDataSource.mPopOverController = UIPopoverController(contentViewController: questionInfoController)
                questionInfoController.setPopover(SSTeacherDataSource.sharedDataSource.mPopOverController)
                SSTeacherDataSource.sharedDataSource.mPopOverController.contentSize = CGSize(width: 400,height: 317);
                SSTeacherDataSource.sharedDataSource.mPopOverController.delegate = self;
                
                SSTeacherDataSource.sharedDataSource.mPopOverController.present(from: CGRect(
                    x:buttonPosition.x ,
                    y:buttonPosition.y + infoButton.frame.size.height / 2,
                    width: 1,
                    height: 1), in: self, permittedArrowDirections: .right, animated: true)
            }
            else if questionType == kMRQ || questionType == kMCQ || questionType == TextAuto
            {
                let questionInfoController = SingleResponceOption()
                
                
                questionInfoController.setQuestionDetails(questionDetails)
                
                
                questionInfoController.preferredContentSize = CGSize(width: 400,height: 317)
                
                SSTeacherDataSource.sharedDataSource.mPopOverController = UIPopoverController(contentViewController: questionInfoController)
                questionInfoController.setPopover(SSTeacherDataSource.sharedDataSource.mPopOverController)
                SSTeacherDataSource.sharedDataSource.mPopOverController.contentSize = CGSize(width: 400,height: 317);
                SSTeacherDataSource.sharedDataSource.mPopOverController.delegate = self;
                
                SSTeacherDataSource.sharedDataSource.mPopOverController.present(from: CGRect(
                    x:buttonPosition.x ,
                    y:buttonPosition.y + infoButton.frame.size.height / 2,
                    width: 1,
                    height: 1), in: self, permittedArrowDirections: .right, animated: true)
            }
            else if questionType == kMatchColumn
            {
                let questionInfoController = MatchColumnOption()
                questionInfoController.setdelegate(self)
                
                questionInfoController.setQuestionDetails(questionDetails)
                
                
                questionInfoController.preferredContentSize = CGSize(width: 400,height: 317)
                
                SSTeacherDataSource.sharedDataSource.mPopOverController = UIPopoverController(contentViewController: questionInfoController)
                questionInfoController.setPopover(SSTeacherDataSource.sharedDataSource.mPopOverController)
                SSTeacherDataSource.sharedDataSource.mPopOverController.contentSize = CGSize(width: 400,height: 317);
                SSTeacherDataSource.sharedDataSource.mPopOverController.delegate = self;
                
                SSTeacherDataSource.sharedDataSource.mPopOverController.present(from: CGRect(
                    x:buttonPosition.x ,
                    y:buttonPosition.y + infoButton.frame.size.height / 2,
                    width: 1,
                    height: 1), in: self, permittedArrowDirections: .right, animated: true)
            }
        }
    }
    
    
}
