//
//  QuestionsView.swift
//  LearniatTeacher
//
//  Created by Deepak MK on 25/04/16.
//  Copyright © 2016 Mindshift. All rights reserved.
//

import Foundation

@objc protocol QuestionsViewDelegate
{
    
    
    @objc optional func delegateQuestionSentWithQuestionDetails(_ questionDetails:AnyObject)
    
    
    @objc optional func delegateQuestionBackButtonPressed(_ mainTopicId:String, withMainTopicName mainTopicName:String)
    
    @objc optional func delegateDoneButtonPressed()
    
    
    @objc optional func delegateScribbleQuestionWithSubtopicId(_ subTopicID:String)
    
    @objc optional func delegateTopicsSizeChangedWithHeight(_ height:CGFloat)
    
    @objc optional func delegateQuizmodePressedwithQuestions(_ questionArray:NSMutableArray)
    
    @objc optional func delegateMtcQuestionWithSubtopicId(_ subTopicId:String)
    
    @objc optional func delegateMRQQuestionWithSubtopicId(_ subTopicId:String)
}


class QuestionsView: UIView,QuestionCellDelegate,SSTeacherDataSourceDelegate,UIPopoverControllerDelegate
{
    var _delgate: AnyObject!
    
    
    var currentSessionDetails       :AnyObject!
    
    var mTopicsContainerView        = UIScrollView()
    
    var mActivityIndicator  = UIActivityIndicatorView(activityIndicatorStyle:.gray)
    
    var  mSubTopicName  = UILabel()
    
    var currentSubTopicId                  = ""
    
    var currentMainTopicID                 = ""
    
    var currentMainTopicName                = ""
    
    var isCurrentSubtopicStarted :Bool           = false
    
     var currentMainTopicsViewHeight :CGFloat = 0
    
    var questionButtonsView         = UIView()
    
    var questionsDetailsDictonary:Dictionary<String, NSMutableArray> = Dictionary()
    
    var touchLocation :CGPoint!
    
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
        
        
        let mTopbarImageView = UIImageView(frame: CGRect(x: 0, y: 0,width: self.frame.size.width, height: 44))
        mTopbarImageView.backgroundColor = UIColor.white
        self.addSubview(mTopbarImageView)
        mTopbarImageView.isUserInteractionEnabled = true
        
        
        
        
        
        
        mTopicsContainerView.frame = CGRect(x: 0, y: 44, width: self.frame.size.width, height: self.frame.size.height - 44)
        mTopicsContainerView.backgroundColor = UIColor.white
        self.addSubview(mTopicsContainerView)
        mTopicsContainerView.isHidden = true
        
        
        let seperatorView = UIView(frame: CGRect(x: 0 ,y: mTopbarImageView.frame.size.height - 1 , width: mTopbarImageView.frame.size.width,height: 1))
        seperatorView.backgroundColor = LineGrayColor;
        mTopbarImageView.addSubview(seperatorView)
        
        
        let  mDoneButton = UIButton(frame: CGRect(x: mTopbarImageView.frame.size.width - 210,  y: 0, width: 200 ,height: mTopbarImageView.frame.size.height))
        mTopbarImageView.addSubview(mDoneButton)
        mDoneButton.addTarget(self, action: #selector(QuestionsView.onDoneButton), for: UIControlEvents.touchUpInside)
        mDoneButton.setTitleColor(standard_Button, for: UIControlState())
        mDoneButton.setTitle("Done", for: UIControlState())
        mDoneButton.contentHorizontalAlignment = UIControlContentHorizontalAlignment.right
        mDoneButton.titleLabel?.font = UIFont(name: helveticaMedium, size: 20)
        
        
        
        
        let  mBackButton = UIButton(frame: CGRect(x: 10,  y: 0, width: 200 ,height: mTopbarImageView.frame.size.height))
        mTopbarImageView.addSubview(mBackButton)
        mBackButton.addTarget(self, action: #selector(QuestionsView.onBackButton), for: UIControlEvents.touchUpInside)
        mBackButton.setTitleColor(standard_Button, for: UIControlState())
        mBackButton.setTitle("Back", for: UIControlState())
        mBackButton.contentHorizontalAlignment = UIControlContentHorizontalAlignment.left
        mBackButton.titleLabel?.font = UIFont(name: helveticaMedium, size: 20)
        
        
        mSubTopicName.frame = CGRect(x: (mTopbarImageView.frame.size.width - 400)/2, y: 0 , width: 400, height: mTopbarImageView.frame.size.height)
        mSubTopicName.font = UIFont(name:helveticaMedium, size: 20)
        mTopbarImageView.addSubview(mSubTopicName)
        mSubTopicName.textColor = UIColor.black
        mSubTopicName.text = "Questions"
        mSubTopicName.textAlignment = .center
        mSubTopicName.lineBreakMode = .byTruncatingMiddle
        
        mActivityIndicator.frame = CGRect(x: 100, y: 0, width: mTopbarImageView.frame.size.height,height: mTopbarImageView.frame.size.height)
        mTopbarImageView.addSubview(mActivityIndicator)
        mActivityIndicator.hidesWhenStopped = true
        mActivityIndicator.isHidden = true
        
        
        
        questionButtonsView.frame = CGRect(x: 0, y: mTopicsContainerView.frame.size.height + mTopicsContainerView.frame.origin.y, width: mTopicsContainerView.frame.size.width, height: 44)
       self.addSubview(questionButtonsView)
        questionButtonsView.backgroundColor = UIColor.white
        
        
        
        let seperatorView1 = UIView(frame: CGRect(x: 0 ,y: 0 , width: questionButtonsView.frame.size.width,height: 1))
        seperatorView1.backgroundColor = LineGrayColor;
        questionButtonsView.addSubview(seperatorView1)
        
        
        let  mScribbleButton = UIButton(frame: CGRect(x: 0,  y: 0, width: questionButtonsView.frame.size.width / 2  ,height: mTopbarImageView.frame.size.height))
        questionButtonsView.addSubview(mScribbleButton)
        mScribbleButton.addTarget(self, action: #selector(QuestionsView.onScribbleButton), for: UIControlEvents.touchUpInside)
        mScribbleButton.setTitleColor(standard_Button, for: UIControlState())
        mScribbleButton.setTitle("Scribble", for: UIControlState())
        mScribbleButton.contentHorizontalAlignment = UIControlContentHorizontalAlignment.center
        mScribbleButton.titleLabel?.font = UIFont(name: helveticaMedium, size: 20)
        
        
//        let  mMatchColumn = UIButton(frame: CGRectMake(mScribbleButton.frame.origin.x + mScribbleButton.frame.size.width,  0, questionButtonsView.frame.size.width / 3  ,mTopbarImageView.frame.size.height))
//        questionButtonsView.addSubview(mMatchColumn)
//        mMatchColumn.addTarget(self, action: #selector(QuestionsView.onMTCButton), forControlEvents: UIControlEvents.TouchUpInside)
//        mMatchColumn.setTitleColor(standard_Button, forState: .Normal)
//        mMatchColumn.setTitle("MTC", forState: .Normal)
//        mMatchColumn.contentHorizontalAlignment = UIControlContentHorizontalAlignment.Center
//        mMatchColumn.titleLabel?.font = UIFont(name: helveticaMedium, size: 20)
        
        
        let  mMRQ = UIButton(frame: CGRect(x: mScribbleButton.frame.origin.x + mScribbleButton.frame.size.width ,  y: 0, width: questionButtonsView.frame.size.width / 2  ,height: mTopbarImageView.frame.size.height))
        questionButtonsView.addSubview(mMRQ)
        mMRQ.addTarget(self, action: #selector(QuestionsView.onMRQButton), for: UIControlEvents.touchUpInside)
        mMRQ.setTitleColor(standard_Button, for: UIControlState())
        mMRQ.setTitle("MRQ", for: UIControlState())
        mMRQ.contentHorizontalAlignment = UIControlContentHorizontalAlignment.center
        mMRQ.titleLabel?.font = UIFont(name: helveticaMedium, size: 20)
        

    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setSessionDetails(_ details:AnyObject)
    {
         currentSessionDetails = details
    }
    
    func setPreferredSize(_ size:CGSize, withSessionDetails details:AnyObject)
    {
        
        
        
        currentSessionDetails = details
        
        
        
    }
    
    
    
    func clearQuestionTopicId(_ subTopicId:String)
    {
        if (questionsDetailsDictonary[subTopicId] != nil)
        {
            questionsDetailsDictonary.removeValue(forKey: subTopicId)
        }
    }
    
    
    
    func getQuestionsDetailsWithsubTopicId(_ subTopicId:String, withSubTopicName subTopicName:String, withMainTopicId mainTopicId:String, withMainTopicName mainTopicName:String, withSubtopicStarted isStarted:Bool)
    {
        
        let subViews = mTopicsContainerView.subviews.flatMap{ $0 as? QuestionCell }
        
        for subview in subViews
        {
            if subview.isKind(of: QuestionCell.self)
            {
                subview.removeFromSuperview()
            }
        }
        
        
        
        
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
                if let ClassId = currentSessionDetails.object(forKey: "ClassId") as? String
                {
                    
                    if let SubjectId = currentSessionDetails.object(forKey: "SubjectId") as? String
                    {
                        
                        let subViews = mTopicsContainerView.subviews.flatMap{ $0 as? SubTopicCell }
                        
                        for subview in subViews
                        {
                            if subview.isKind(of: SubTopicCell.self)
                            {
                                subview.removeFromSuperview()
                            }
                        }
                        mActivityIndicator.isHidden = false
                        mActivityIndicator.startAnimating()
                        
                        SSTeacherDataSource.sharedDataSource.getAllNodesWithClassId(ClassId, withSubjectId: SubjectId, withTopicId: currentSubTopicId, withType: onlyQuestions, withDelegate: self)
                    }
                    
                    
                }
            }
        }
        else
        {
            if let ClassId = currentSessionDetails.object(forKey: "ClassId") as? String
            {
                
                if let SubjectId = currentSessionDetails.object(forKey: "SubjectId") as? String
                {
                    
                    let subViews = mTopicsContainerView.subviews.flatMap{ $0 as? SubTopicCell }
                    
                    for subview in subViews
                    {
                        if subview.isKind(of: SubTopicCell.self)
                        {
                            subview.removeFromSuperview()
                        }
                    }
                    mActivityIndicator.isHidden = false
                    mActivityIndicator.startAnimating()
                    
                    SSTeacherDataSource.sharedDataSource.getAllNodesWithClassId(ClassId, withSubjectId: SubjectId, withTopicId: currentSubTopicId, withType: onlyQuestions, withDelegate: self)
                }
                
                
            }
        }
    }
    
    
    // MARK: - datasource delegate functions
    
    func didGetAllNodesWithDetails(_ details: AnyObject) {
        
        
        if let statusString = details.object(forKey: "Status") as? String
        {
            if statusString == kSuccessString
            {
                var mMaintopicsDetails = NSMutableArray()
               if let classCheckingVariable = (details.object(forKey: "Questions")! as AnyObject).object(forKey: "Question") as? NSMutableArray
               {
                     mMaintopicsDetails = classCheckingVariable
                }
                else
                {
                    mMaintopicsDetails.add((details.object(forKey: "Questions")! as AnyObject).object(forKey: "Question")!)
                    
                }
                
                
                questionsDetailsDictonary[currentSubTopicId] = mMaintopicsDetails
                
                
                
                addTopicsWithDetailsArray(mMaintopicsDetails)
            }
        }
    }
    
    
    func addTopicsWithDetailsArray(_ mMaintopicsDetails:NSMutableArray)
    {
        
        
        
        if mMaintopicsDetails.count <= 0
        {
            mTopicsContainerView.isHidden = true
        }
        else
        {
            mTopicsContainerView.isHidden = false
        }
        
        
        var height :CGFloat = 44
        
        var positionY :CGFloat = 0
        
        for index in 0 ..< mMaintopicsDetails.count
        {
            let currentTopicDetails = mMaintopicsDetails.object(at: index)
            
            print(currentTopicDetails)
            
            let topicCell = QuestionCell(frame: CGRect(x: 0  , y: positionY, width: mTopicsContainerView.frame.size.width, height: 60))
            topicCell.setdelegate(self)
            
            topicCell.frame =   CGRect(x: 0  , y: positionY, width: mTopicsContainerView.frame.size.width, height: topicCell.getCurrentCellHeightWithDetails(currentTopicDetails as AnyObject, WIthCountValue: index + 1))
            
            
            if isCurrentSubtopicStarted == true
            {
                topicCell.mSendButton.isHidden = false
            }
            else
            {
                topicCell.mSendButton.isHidden = true
            }
            
            
            mTopicsContainerView.addSubview(topicCell)
            height = height + (topicCell.frame.size.height*2)
            
            positionY = positionY + topicCell.frame.size.height
        }
        
        
        
        
        if height > UIScreen.main.bounds.height - 100
        {
            height = UIScreen.main.bounds.height - 100
        }
        
        UIView.animate(withDuration: 0.5, animations:
            {
                self.frame =  CGRect(x: self.frame.origin.x, y: self.frame.origin.y, width: 600, height: height)
        })
       
        currentMainTopicsViewHeight = height
        
        
        mTopicsContainerView.frame = CGRect(x: 0, y: 44, width: mTopicsContainerView.frame.size.width, height: height - 88)
        
        mTopicsContainerView.contentSize = CGSize(width: 0, height: positionY)
        
        questionButtonsView.frame = CGRect(x: 0, y: mTopicsContainerView.frame.size.height + mTopicsContainerView.frame.origin.y, width: mTopicsContainerView.frame.size.width, height: 44)
        
        mTopicsContainerView.scrollToTop()
        
        mActivityIndicator.stopAnimating()
        
        
        if delegate().responds(to: #selector(QuestionsViewDelegate.delegateTopicsSizeChangedWithHeight(_:)))
        {
            delegate().delegateTopicsSizeChangedWithHeight!(height)
        }
    }
    
    
    
    func onDoneButton()
    {
        if delegate().responds(to: #selector(SubTopicsViewDelegate.delegateDoneButtonPressed))
        {
            delegate().delegateDoneButtonPressed!()
        }
        
    }
    
   
    
    func onBackButton()
    {
        if delegate().responds(to: #selector(QuestionsViewDelegate.delegateQuestionBackButtonPressed(_:withMainTopicName:)))
        {
            delegate().delegateQuestionBackButtonPressed!(currentMainTopicID, withMainTopicName: currentMainTopicName)
        }
    }
    
    
    
    func onScribbleButton()
    {
        
        if isCurrentSubtopicStarted == true
        {
            
            
            
            if delegate().responds(to: #selector(QuestionsViewDelegate.delegateScribbleQuestionWithSubtopicId(_:)))
            {
                delegate().delegateScribbleQuestionWithSubtopicId!(currentSubTopicId)
                
            }
            
            
            
        }
        else
        {
            
        }
        
        
    }
    
    func onQuizmode()
    {
        if isCurrentSubtopicStarted == true
        {
            
              if let currentMainTopicDetails = questionsDetailsDictonary[currentSubTopicId]
              {
                if delegate().responds(to: #selector(QuestionsViewDelegate.delegateQuizmodePressedwithQuestions(_:)))
                {
                    delegate().delegateQuizmodePressedwithQuestions!(currentMainTopicDetails)
                    
                }
            }
        }
    }
    
    
    func onMTCButton()
    {
        if isCurrentSubtopicStarted == true
        {
            
            
            
            if delegate().responds(to: #selector(QuestionsViewDelegate.delegateMtcQuestionWithSubtopicId(_:)))
            {
                delegate().delegateMtcQuestionWithSubtopicId!(currentSubTopicId)
                
            }
        }
    }
    
    func onMRQButton()
    {
        if isCurrentSubtopicStarted == true
        {
            
            
            
            if delegate().responds(to: #selector(QuestionsViewDelegate.delegateMRQQuestionWithSubtopicId(_:)))
            {
                delegate().delegateMRQQuestionWithSubtopicId!(currentSubTopicId)
                
            }
        }
    }
    
    
    
    // MARK: - Question delegate functions
    
    
    func delegateSendQuestionDetails(_ questionDetails: AnyObject)
    {
        
        
        if delegate().responds(to: #selector(QuestionsViewDelegate.delegateQuestionSentWithQuestionDetails(_:)))
        {
            delegate().delegateQuestionSentWithQuestionDetails!(questionDetails)
            
        }
    }
    
    func delegateOnInfoButtonWithDetails(_ questionDetails: AnyObject, withButton infoButton: UIButton) {
        
        
        
        let buttonPosition :CGPoint = infoButton.convert(CGPoint.zero, to: self)
        
        
        if let questionType = questionDetails.object(forKey: kQuestionType) as? String
        {
            if questionType == kOverlayScribble
            {
                let questionInfoController = ScribbleQuestionInfoScreen()
                questionInfoController.setdelegate(self)
                
                questionInfoController.setScribbleInfoDetails(questionDetails)
                
                
                questionInfoController.preferredContentSize = CGSize(width: 400,height: 317)
                
                let   classViewPopOverController = UIPopoverController(contentViewController: questionInfoController)
                questionInfoController.setPopover(classViewPopOverController)
                classViewPopOverController.contentSize = CGSize(width: 400,height: 317);
                classViewPopOverController.delegate = self;
                
                classViewPopOverController.present(from: CGRect(
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
                
                let   classViewPopOverController = UIPopoverController(contentViewController: questionInfoController)
                questionInfoController.setPopover(classViewPopOverController)
                classViewPopOverController.contentSize = CGSize(width: 400,height: 317);
                classViewPopOverController.delegate = self;
                
                classViewPopOverController.present(from: CGRect(
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
                
                let   classViewPopOverController = UIPopoverController(contentViewController: questionInfoController)
                questionInfoController.setPopover(classViewPopOverController)
                classViewPopOverController.contentSize = CGSize(width: 400,height: 317);
                classViewPopOverController.delegate = self;
                
                classViewPopOverController.present(from: CGRect(
                    x:buttonPosition.x ,
                    y:buttonPosition.y + infoButton.frame.size.height / 2,
                    width: 1,
                    height: 1), in: self, permittedArrowDirections: .right, animated: true)
            }
        }
    }
    
}

extension UIScrollView
{
    func scrollToTop()
    {
        let desiredOffset = CGPoint(x: 0, y: -contentInset.top)
        setContentOffset(desiredOffset, animated: true)
    }
}

