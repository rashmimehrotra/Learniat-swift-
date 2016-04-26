//
//  LiveQuestionView.swift
//  LearniatTeacher
//
//  Created by Deepak MK on 26/04/16.
//  Copyright © 2016 Mindshift. All rights reserved.
//

import Foundation

@objc protocol LiveQuestionViewDelegate
{
    
    
    optional func delegateQuestionCleared(questionDetails:AnyObject, withCurrentmainTopicId mainTopicId:String, withCurrentMainTopicName mainTopicName:String)
    
    optional func delegateDoneButtonPressed()
    
    optional func delegateTopicsButtonPressed()
    
}


class LiveQuestionView: UIView,UIPopoverControllerDelegate
{
    var _delgate: AnyObject!
    
    
    var currentSessionDetails       :AnyObject!
    
    var currentQuestionDetails       :AnyObject!
    
    var currentMainTopicId           = ""
    
    var currentMainTopicName          = ""
    
    let mIndexValuesLabel = UILabel()
    
    let mQuestionTypeLabel = UILabel()
    
    var questionImageView = UIImageView()
    
    let mQuestionNameLabel = UILabel()
    
    let mInfoButton    :UIButton  = UIButton()
    
    let  mFreezbutton = UIButton()
    
    let mTopicName = UILabel()
    
    var questionsDetailsDictonary:Dictionary<String, NSMutableArray> = Dictionary()
    
    
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
        

        self.backgroundColor = whiteBackgroundColor
        
        questionImageView.frame  = CGRectMake(0, 0, 450,350)
        self.addSubview(questionImageView)
        questionImageView.userInteractionEnabled = true
        
        
        
        
        let mTopbarImageView = UIImageView(frame: CGRectMake(0, 0, questionImageView.frame.size.width, 44))
        mTopbarImageView.backgroundColor = UIColor.whiteColor()
        questionImageView.addSubview(mTopbarImageView)
        mTopbarImageView.userInteractionEnabled = true
        
        
        let  mTopicsButton = UIButton(frame: CGRectMake(10,  0, 200 ,mTopbarImageView.frame.size.height))
        mTopbarImageView.addSubview(mTopicsButton)
        mTopicsButton.addTarget(self, action: #selector(LiveQuestionView.onTopicsButtonPressed), forControlEvents: UIControlEvents.TouchUpInside)
        mTopicsButton.setTitleColor(standard_Button, forState: .Normal)
        mTopicsButton.setTitle("Topics", forState: .Normal)
        mTopicsButton.contentHorizontalAlignment = UIControlContentHorizontalAlignment.Left
        mTopicsButton.titleLabel?.font = UIFont(name: helveticaMedium, size: 20)
        
        
        
        
        let  mDoneButton = UIButton(frame: CGRectMake(mTopbarImageView.frame.size.width - 210,  0, 200 ,mTopbarImageView.frame.size.height))
        mTopbarImageView.addSubview(mDoneButton)
        mDoneButton.addTarget(self, action: #selector(LiveQuestionView.onDoneButton), forControlEvents: UIControlEvents.TouchUpInside)
        mDoneButton.setTitleColor(standard_Button, forState: .Normal)
        mDoneButton.setTitle("Done", forState: .Normal)
        mDoneButton.contentHorizontalAlignment = UIControlContentHorizontalAlignment.Right
        mDoneButton.titleLabel?.font = UIFont(name: helveticaMedium, size: 20)
        
        
        let seperatorView = UIView(frame: CGRectMake(0 ,mTopbarImageView.frame.size.height - 1 , mTopbarImageView.frame.size.width,1))
        seperatorView.backgroundColor = LineGrayColor;
        mTopbarImageView.addSubview(seperatorView)
        
        
        
        mIndexValuesLabel.font = UIFont(name:helveticaRegular, size: 16)
        questionImageView.addSubview(mIndexValuesLabel)
        mIndexValuesLabel.textColor = blackTextColor
        mIndexValuesLabel.textAlignment = .Left
        mIndexValuesLabel.lineBreakMode = .ByTruncatingMiddle
        mIndexValuesLabel.frame = CGRectMake(10 , seperatorView.frame.size.height + seperatorView.frame.origin.y , 100 ,mTopbarImageView.frame.size.height)
        
        
        
        
        
        
        mQuestionTypeLabel.frame = CGRectMake(mIndexValuesLabel.frame.origin.x + mIndexValuesLabel.frame.size.width + 10   ,                                                    seperatorView.frame.size.height + seperatorView.frame.origin.y ,
                                              mTopbarImageView.frame.size.width - (mIndexValuesLabel.frame.origin.x + (mIndexValuesLabel.frame.size.width * 2) + 20 )  ,
                                              mTopbarImageView.frame.size.height)
        mQuestionTypeLabel.font = UIFont(name:helveticaBold, size: 16)
        questionImageView.addSubview(mQuestionTypeLabel)
        mQuestionTypeLabel.textColor = UIColor.lightGrayColor()
        mQuestionTypeLabel.textAlignment = .Center
        mQuestionTypeLabel.lineBreakMode = .ByTruncatingMiddle
        
        
        
        
        mInfoButton.frame = CGRectMake(questionImageView.frame.size.width - (mTopbarImageView.frame.size.height + 10) , seperatorView.frame.size.height + seperatorView.frame.origin.y , mTopbarImageView.frame.size.height ,mTopbarImageView.frame.size.height)
        questionImageView.addSubview(mInfoButton)
        mInfoButton.addTarget(self, action: #selector(LiveQuestionView.onInfoButton), forControlEvents: UIControlEvents.TouchUpInside)
        mInfoButton.setImage(UIImage(named: "infoButton.png"), forState: .Normal)
        mInfoButton.contentHorizontalAlignment = UIControlContentHorizontalAlignment.Right
        
        
        
        
        
        let seperatorView2 = UIView(frame: CGRectMake(10,  mQuestionTypeLabel.frame.size.height + mQuestionTypeLabel.frame.origin.y , questionImageView.frame.size.width - 20  ,1))
        seperatorView2.backgroundColor = LineGrayColor;
        questionImageView.addSubview(seperatorView2)
        
        
        
        
        
        
        
        mQuestionNameLabel.frame = CGRectMake(10 , seperatorView2.frame.size.height + seperatorView2.frame.origin.y + 20  , questionImageView.frame.size.width - 20 ,mTopbarImageView.frame.size.height)
        mQuestionNameLabel.font = UIFont(name:helveticaMedium, size: 18)
        questionImageView.addSubview(mQuestionNameLabel)
        mQuestionNameLabel.textColor = blackTextColor
        mQuestionNameLabel.textAlignment = .Center
        mQuestionNameLabel.lineBreakMode = .ByTruncatingMiddle
        mQuestionNameLabel.numberOfLines  = 20
        
        
        
        mFreezbutton.frame =   CGRectMake((questionImageView.frame.size.width - 200) / 2,  mQuestionNameLabel.frame.size.height + mQuestionNameLabel.frame.origin.y + 20, 200 ,mTopbarImageView.frame.size.height)
        questionImageView.addSubview(mFreezbutton)
        mFreezbutton.addTarget(self, action: #selector(LiveQuestionView.onFreezButton), forControlEvents: UIControlEvents.TouchUpInside)
        mFreezbutton.setTitleColor(standard_Red, forState: .Normal)
        mFreezbutton.setTitle("Freeze response", forState: .Normal)
        mFreezbutton.contentHorizontalAlignment = UIControlContentHorizontalAlignment.Center
        mFreezbutton.titleLabel?.font = UIFont(name: helveticaRegular, size: 20)
        mFreezbutton.layer.borderColor = standard_Red.CGColor
        mFreezbutton.layer.borderWidth = 1
        mFreezbutton.layer.cornerRadius = 5
        
        
        
        
        
        
        
        mTopicName.frame = CGRectMake(10 , mFreezbutton.frame.size.height + mFreezbutton.frame.origin.y + 20  , questionImageView.frame.size.width - 20 ,mTopbarImageView.frame.size.height)
        mTopicName.font = UIFont(name:helveticaRegular, size: 18)
        questionImageView.addSubview(mTopicName)
        mTopicName.textColor = UIColor.lightGrayColor()
        mTopicName.textAlignment = .Center
        mTopicName.lineBreakMode = .ByTruncatingMiddle
        mTopicName.numberOfLines  = 20
        
        
        let seperatorView1 = UIView(frame: CGRectMake(10,  questionImageView.frame.size.height - mTopbarImageView.frame.size.height , questionImageView.frame.size.width - 20  ,1))
        seperatorView1.backgroundColor = LineGrayColor;
        questionImageView.addSubview(seperatorView1)
        
        let  clearQuestion = UIButton(frame: CGRectMake(10,  questionImageView.frame.size.height - mTopbarImageView.frame.size.height , questionImageView.frame.size.width - 20  ,mTopbarImageView.frame.size.height))
        questionImageView.addSubview(clearQuestion)
        clearQuestion.addTarget(self, action: #selector(LiveQuestionView.onClearQuestion), forControlEvents: UIControlEvents.TouchUpInside)
        clearQuestion.setTitleColor(standard_Button, forState: .Normal)
        clearQuestion.setTitle("Close question", forState: .Normal)
        clearQuestion.contentHorizontalAlignment = UIControlContentHorizontalAlignment.Center
        clearQuestion.titleLabel?.font = UIFont(name: helveticaRegular, size: 20)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    func setSessionDetails( details:AnyObject)
    {
        currentSessionDetails = details
        
    }
    
    
    
    
    
    
    // MARK: - datasource delegate functions
    
    func setQuestionDetails(details:AnyObject, withMainTopciName mainTopicName:String, withMainTopicId mainTopicId:String)
    {
        
        
        let subViews = self.subviews
        
        for subview in subViews
        {
            if subview != questionImageView
            {
                subview.removeFromSuperview()
            }
            
            
        }
        
        
        
        currentQuestionDetails = details
        currentMainTopicId = mainTopicId
        currentMainTopicName = mainTopicName
        
        
        
        
        
        if let QuestonAvgScore = currentQuestionDetails.objectForKey("QuestonAvgScore")as? NSString
        {
            
            let questionAverage = QuestonAvgScore.floatValue * 100.0
            
            if let NumberOfResponses = currentQuestionDetails.objectForKey("NumberOfResponses")as? NSString
            {
                if NumberOfResponses.intValue > 0
                {
                    mIndexValuesLabel.hidden = false
                    
                    
                    let  _string =  NSMutableAttributedString(string:"\(String(format: "%02d", Int(questionAverage)))% (\(NumberOfResponses))")
                    
                    
                    
                    
                    var  tintColor  = standard_Red
                    if (questionAverage<=33)
                    {
                        tintColor = standard_Red;
                    }
                    else if (questionAverage>33 && questionAverage<=66)
                    {
                        tintColor = standard_Yellow
                    }
                    else
                    {
                        tintColor = standard_Green
                    }
                    
                    _string.addAttribute(NSForegroundColorAttributeName, value: tintColor, range: NSRange(location: 0, length: 4) )
                    
                    mIndexValuesLabel.attributedText = _string
                }
                else
                {
                    mIndexValuesLabel.hidden = true
                }
            }
            else
            {
                mIndexValuesLabel.hidden = true
            }
        }
        
        
        
        
        
        
        if let questionType = currentQuestionDetails.objectForKey("Type")as? NSString
        {
            if(questionType.isEqualToString(kText))
            {
                
                mQuestionTypeLabel.text = "TEXT";
                mInfoButton.hidden = true
                
            }
            else if(questionType.isEqualToString(kOverlayScribble))
            {
                
                mQuestionTypeLabel.text = "SCRIBBLE";
                mInfoButton.hidden = false
                
                
            }
            else if(questionType.isEqualToString(kFreshScribble))
            {
                
                mQuestionTypeLabel.text = "FRESH SCRIBBLE";
                mInfoButton.hidden = true
                
                
            }
                
            else if(questionType.isEqualToString(kMRQ))
            {
                
                mQuestionTypeLabel.text = "MULTIPLE RESPONSE";
                mInfoButton.hidden = false
                
                
            }
            else if(questionType.isEqualToString(kMCQ))
            {
                
                mQuestionTypeLabel.text = "SINGLE RESPONSE";
                mInfoButton.hidden = false
                
                
            }
            else
            {
                
                mQuestionTypeLabel.text = "MATCH COLOUMN";
                mInfoButton.hidden = false
                
            }
            
        }
        
        
        
        
        if let questionName = currentQuestionDetails.objectForKey("Name")as? String
        {
            mQuestionNameLabel.text = "\(questionName)"
            
        }
        
        
        
        
        mTopicName.text = "\(SSTeacherDataSource.sharedDataSource.startedMainTopicName) / \(SSTeacherDataSource.sharedDataSource.startedSubTopicName)"
        
        
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
        if delegate().respondsToSelector(#selector(LiveQuestionViewDelegate.delegateDoneButtonPressed))
        {
            delegate().delegateDoneButtonPressed!()
        }
    }
    
    func onTopicsButtonPressed()
    {
        if delegate().respondsToSelector(#selector(LiveQuestionViewDelegate.delegateTopicsButtonPressed))
        {
            delegate().delegateTopicsButtonPressed!()
        }
    }
    
    func onClearQuestion()
    {
        
        mFreezbutton.enabled = true
        mFreezbutton.setTitleColor(standard_Red, forState: .Normal)
        
        if delegate().respondsToSelector(#selector(LiveQuestionViewDelegate.delegateQuestionCleared(_:withCurrentmainTopicId:withCurrentMainTopicName:)))
        {
            delegate().delegateQuestionCleared!(currentQuestionDetails, withCurrentmainTopicId: currentMainTopicId, withCurrentMainTopicName: currentMainTopicName)
        }
    }
    
    func onFreezButton()
    {
        
        var QuestonAvgScore = currentQuestionDetails.objectForKey("QuestonAvgScore")as? NSString
        
        QuestonAvgScore = String(format: "%02d", QuestonAvgScore!.intValue)
        
        let NumberOfResponses = currentQuestionDetails.objectForKey("NumberOfResponses")as? String
        
        
        
        
        SSTeacherMessageHandler.sharedMessageHandler.freezeQnAMessageToRoom("question_\(SSTeacherDataSource.sharedDataSource.currentLiveSessionId)", withAverageScore: QuestonAvgScore! as String, withTotalResponses: NumberOfResponses!)
        
        mFreezbutton.enabled = false
        mFreezbutton.setTitleColor(UIColor.lightGrayColor(), forState: .Normal)
        
    }
    
    func onInfoButton()
    {
        
        if let questionType = currentQuestionDetails.objectForKey("Type") as? String
        {
            if questionType == "Overlay Scribble"
            {
                let questionInfoController = ScribbleQuestionInfoScreen()
                questionInfoController.setdelegate(self)
                
                questionInfoController.setScribbleInfoDetails(currentQuestionDetails)
                
                
                questionInfoController.preferredContentSize = CGSizeMake(400,317)
                
                let   classViewPopOverController = UIPopoverController(contentViewController: questionInfoController)
                questionInfoController.setPopover(classViewPopOverController)
                classViewPopOverController.popoverContentSize = CGSizeMake(400,317);
                classViewPopOverController.delegate = self;
                
                classViewPopOverController.presentPopoverFromRect(CGRect(
                    x:mInfoButton.frame.origin.x ,
                    y:mInfoButton.frame.origin.y + mInfoButton.frame.size.height / 2,
                    width: 1,
                    height: 1), inView: self, permittedArrowDirections: .Right, animated: true)
            }
            else if questionType == "Multiple Response" || questionType == "Multiple Choice"
            {
                let questionInfoController = SingleResponceOption()
                
                
                questionInfoController.setQuestionDetails(currentQuestionDetails)
                
                
                questionInfoController.preferredContentSize = CGSizeMake(400,317)
                
                let   classViewPopOverController = UIPopoverController(contentViewController: questionInfoController)
                questionInfoController.setPopover(classViewPopOverController)
                classViewPopOverController.popoverContentSize = CGSizeMake(400,317);
                classViewPopOverController.delegate = self;
                
                classViewPopOverController.presentPopoverFromRect(CGRect(
                    x:mInfoButton.frame.origin.x ,
                    y:mInfoButton.frame.origin.y + mInfoButton.frame.size.height / 2,
                    width: 1,
                    height: 1), inView: self, permittedArrowDirections: .Right, animated: true)
            }
            else if questionType == "Match Columns"
            {
                let questionInfoController = MatchColumnOption()
                questionInfoController.setdelegate(self)
                
                questionInfoController.setQuestionDetails(currentQuestionDetails)
                
                
                questionInfoController.preferredContentSize = CGSizeMake(400,317)
                
                let   classViewPopOverController = UIPopoverController(contentViewController: questionInfoController)
                questionInfoController.setPopover(classViewPopOverController)
                classViewPopOverController.popoverContentSize = CGSizeMake(400,317);
                classViewPopOverController.delegate = self;
                
                classViewPopOverController.presentPopoverFromRect(CGRect(
                    x:mInfoButton.frame.origin.x ,
                    y:mInfoButton.frame.origin.y + mInfoButton.frame.size.height / 2,
                    width: 1,
                    height: 1), inView: self, permittedArrowDirections: .Right, animated: true)
            }
        }
    }
    
}