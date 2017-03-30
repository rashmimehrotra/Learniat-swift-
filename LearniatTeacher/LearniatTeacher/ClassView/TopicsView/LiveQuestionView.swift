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
    
    
    @objc optional func delegateQuestionCleared(_ questionDetails:AnyObject, withCurrentmainTopicId mainTopicId:String, withCurrentMainTopicName mainTopicName:String)
    
    @objc optional func delegateDoneButtonPressed()
    
    @objc optional func delegateTopicsButtonPressed()
    
    @objc optional func delegateFreezQuestion()
    
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
        

        self.backgroundColor = whiteBackgroundColor
        
        questionImageView.frame  = CGRect(x: 0, y: 0, width: 450,height: 350)
        self.addSubview(questionImageView)
        questionImageView.isUserInteractionEnabled = true
        
        
        
        
        let mTopbarImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: questionImageView.frame.size.width, height: 44))
        mTopbarImageView.backgroundColor = UIColor.white
        questionImageView.addSubview(mTopbarImageView)
        mTopbarImageView.isUserInteractionEnabled = true
        
        
        let  mTopicsButton = UIButton(frame: CGRect(x: 10,  y: 0, width: 200 ,height: mTopbarImageView.frame.size.height))
        mTopbarImageView.addSubview(mTopicsButton)
        mTopicsButton.addTarget(self, action: #selector(LiveQuestionView.onTopicsButtonPressed), for: UIControlEvents.touchUpInside)
        mTopicsButton.setTitleColor(standard_Button, for: UIControlState())
        mTopicsButton.setTitle("Topics", for: UIControlState())
        mTopicsButton.contentHorizontalAlignment = UIControlContentHorizontalAlignment.left
        mTopicsButton.titleLabel?.font = UIFont(name: helveticaMedium, size: 20)
        
        
        
        
        let  mDoneButton = UIButton(frame: CGRect(x: mTopbarImageView.frame.size.width - 210,  y: 0, width: 200 ,height: mTopbarImageView.frame.size.height))
        mTopbarImageView.addSubview(mDoneButton)
        mDoneButton.addTarget(self, action: #selector(LiveQuestionView.onDoneButton), for: UIControlEvents.touchUpInside)
        mDoneButton.setTitleColor(standard_Button, for: UIControlState())
        mDoneButton.setTitle("Done", for: UIControlState())
        mDoneButton.contentHorizontalAlignment = UIControlContentHorizontalAlignment.right
        mDoneButton.titleLabel?.font = UIFont(name: helveticaMedium, size: 20)
        
        
        let seperatorView = UIView(frame: CGRect(x: 0 ,y: mTopbarImageView.frame.size.height - 1 , width: mTopbarImageView.frame.size.width,height: 1))
        seperatorView.backgroundColor = LineGrayColor;
        mTopbarImageView.addSubview(seperatorView)
        
        
        
        mIndexValuesLabel.font = UIFont(name:helveticaRegular, size: 16)
        questionImageView.addSubview(mIndexValuesLabel)
        mIndexValuesLabel.textColor = blackTextColor
        mIndexValuesLabel.textAlignment = .left
        mIndexValuesLabel.lineBreakMode = .byTruncatingMiddle
        mIndexValuesLabel.frame = CGRect(x: 10 , y: seperatorView.frame.size.height + seperatorView.frame.origin.y , width: 100 ,height: mTopbarImageView.frame.size.height)
        
        
        
        
        
        
        mQuestionTypeLabel.frame = CGRect(x: mIndexValuesLabel.frame.origin.x + mIndexValuesLabel.frame.size.width + 10   ,                                                    y: seperatorView.frame.size.height + seperatorView.frame.origin.y ,
                                              width: mTopbarImageView.frame.size.width - (mIndexValuesLabel.frame.origin.x + (mIndexValuesLabel.frame.size.width * 2) + 20 )  ,
                                              height: mTopbarImageView.frame.size.height)
        mQuestionTypeLabel.font = UIFont(name:helveticaBold, size: 16)
        questionImageView.addSubview(mQuestionTypeLabel)
        mQuestionTypeLabel.textColor = UIColor.lightGray
        mQuestionTypeLabel.textAlignment = .center
        mQuestionTypeLabel.lineBreakMode = .byTruncatingMiddle
        
        
        
        
        mInfoButton.frame = CGRect(x: questionImageView.frame.size.width - (mTopbarImageView.frame.size.height + 10) , y: seperatorView.frame.size.height + seperatorView.frame.origin.y , width: mTopbarImageView.frame.size.height ,height: mTopbarImageView.frame.size.height)
        questionImageView.addSubview(mInfoButton)
        mInfoButton.addTarget(self, action: #selector(LiveQuestionView.onInfoButton), for: UIControlEvents.touchUpInside)
        mInfoButton.setImage(UIImage(named: "infoButton.png"), for: UIControlState())
        mInfoButton.contentHorizontalAlignment = UIControlContentHorizontalAlignment.right
        
        
        
        
        
        let seperatorView2 = UIView(frame: CGRect(x: 10,  y: mQuestionTypeLabel.frame.size.height + mQuestionTypeLabel.frame.origin.y , width: questionImageView.frame.size.width - 20  ,height: 1))
        seperatorView2.backgroundColor = LineGrayColor;
        questionImageView.addSubview(seperatorView2)
        
        
        
        
        
        
        
        mQuestionNameLabel.frame = CGRect(x: 10 , y: seperatorView2.frame.size.height + seperatorView2.frame.origin.y + 20  , width: questionImageView.frame.size.width - 20 ,height: mTopbarImageView.frame.size.height)
        mQuestionNameLabel.font = UIFont(name:helveticaMedium, size: 18)
        questionImageView.addSubview(mQuestionNameLabel)
        mQuestionNameLabel.textColor = blackTextColor
        mQuestionNameLabel.textAlignment = .center
        mQuestionNameLabel.lineBreakMode = .byTruncatingMiddle
        mQuestionNameLabel.numberOfLines  = 20
        
        
        
        mFreezbutton.frame =   CGRect(x: (questionImageView.frame.size.width - 200) / 2,  y: mQuestionNameLabel.frame.size.height + mQuestionNameLabel.frame.origin.y + 20, width: 200 ,height: mTopbarImageView.frame.size.height)
        questionImageView.addSubview(mFreezbutton)
        mFreezbutton.addTarget(self, action: #selector(LiveQuestionView.onFreezButton), for: UIControlEvents.touchUpInside)
        mFreezbutton.setTitleColor(standard_Red, for: UIControlState())
        mFreezbutton.setTitle("Freeze response", for: UIControlState())
        mFreezbutton.contentHorizontalAlignment = UIControlContentHorizontalAlignment.center
        mFreezbutton.titleLabel?.font = UIFont(name: helveticaRegular, size: 20)
        mFreezbutton.layer.borderColor = standard_Red.cgColor
        mFreezbutton.layer.borderWidth = 1
        mFreezbutton.layer.cornerRadius = 5
        
        
        
        
        
        
        
        mTopicName.frame = CGRect(x: 10 , y: mFreezbutton.frame.size.height + mFreezbutton.frame.origin.y + 20  , width: questionImageView.frame.size.width - 20 ,height: mTopbarImageView.frame.size.height)
        mTopicName.font = UIFont(name:helveticaRegular, size: 18)
        questionImageView.addSubview(mTopicName)
        mTopicName.textColor = UIColor.lightGray
        mTopicName.textAlignment = .center
        mTopicName.lineBreakMode = .byTruncatingMiddle
        mTopicName.numberOfLines  = 20
        
        
        let seperatorView1 = UIView(frame: CGRect(x: 10,  y: questionImageView.frame.size.height - mTopbarImageView.frame.size.height , width: questionImageView.frame.size.width - 20  ,height: 1))
        seperatorView1.backgroundColor = LineGrayColor;
        questionImageView.addSubview(seperatorView1)
        
        let  clearQuestion = UIButton(frame: CGRect(x: 10,  y: questionImageView.frame.size.height - mTopbarImageView.frame.size.height , width: questionImageView.frame.size.width - 20  ,height: mTopbarImageView.frame.size.height))
        questionImageView.addSubview(clearQuestion)
        clearQuestion.addTarget(self, action: #selector(LiveQuestionView.onClearQuestion), for: UIControlEvents.touchUpInside)
        clearQuestion.setTitleColor(standard_Button, for: UIControlState())
        clearQuestion.setTitle("Close question", for: UIControlState())
        clearQuestion.contentHorizontalAlignment = UIControlContentHorizontalAlignment.center
        clearQuestion.titleLabel?.font = UIFont(name: helveticaRegular, size: 20)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    func setSessionDetails( _ details:AnyObject)
    {
        currentSessionDetails = details
        
    }
    
    
    
    
    
    
    // MARK: - datasource delegate functions
    
    func setQuestionDetails(_ details:AnyObject, withMainTopciName mainTopicName:String, withMainTopicId mainTopicId:String)
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
        
        
        
        
        
        if let QuestonAvgScore = currentQuestionDetails.object(forKey: "QuestonAvgScore")as? NSString
        {
            
            let questionAverage = QuestonAvgScore.floatValue * 100.0
            
            if let NumberOfResponses = currentQuestionDetails.object(forKey: "NumberOfResponses")as? NSString
            {
                if NumberOfResponses.intValue > 0
                {
                    mIndexValuesLabel.isHidden = false
                    
                    
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
                    mIndexValuesLabel.isHidden = true
                }
            }
            else
            {
                mIndexValuesLabel.isHidden = true
            }
        }
        
        
        
        
        
        
        if let questionType = currentQuestionDetails.object(forKey: "Type")as? NSString
        {
            if(questionType.isEqual(to: kText))
            {
                
                mQuestionTypeLabel.text = "\(questionType)";
                mInfoButton.isHidden = true
                
            }
            else if(questionType.isEqual(to: kOverlayScribble))
            {
                
                mQuestionTypeLabel.text = "\(questionType)";
                mInfoButton.isHidden = false
                
                
            }
            else if(questionType.isEqual(to: kFreshScribble))
            {
                
                mQuestionTypeLabel.text = "\(questionType)";
                mInfoButton.isHidden = true
                
                
            }
                
            else if(questionType.isEqual(to: kMRQ))
            {
                
                mQuestionTypeLabel.text = "\(questionType)";
                mInfoButton.isHidden = false
                
                
            }
            else if(questionType.isEqual(to: kMCQ))
            {
                
                mQuestionTypeLabel.text = "\(questionType)";
                mInfoButton.isHidden = false
                
                
            }
            else
            {
                
                mQuestionTypeLabel.text = "\(questionType)";
                mInfoButton.isHidden = false
                
            }
            
        }
        
        
        
        
        if let questionName = currentQuestionDetails.object(forKey: "Name")as? String
        {
            mQuestionNameLabel.text = "\(questionName)"
            
        }
        
        
        
        
        mTopicName.text = "\(SSTeacherDataSource.sharedDataSource.startedMainTopicName) / \(SSTeacherDataSource.sharedDataSource.startedSubTopicName)"
        
        
    }
    
    
    
    var _Popover:UIPopoverController!
    
    func setPopover(_ popover:UIPopoverController)
    {
        _Popover = popover
    }
    
    func popover()-> UIPopoverController
    {
        return _Popover
    }
    
    
    func onDoneButton()
    {
        if delegate().responds(to: #selector(LiveQuestionViewDelegate.delegateDoneButtonPressed))
        {
            delegate().delegateDoneButtonPressed!()
        }
    }
    
    func onTopicsButtonPressed()
    {
        if delegate().responds(to: #selector(LiveQuestionViewDelegate.delegateTopicsButtonPressed))
        {
            delegate().delegateTopicsButtonPressed!()
        }
    }
    
    func onClearQuestion()
    {
        
        mFreezbutton.isEnabled = true
        mFreezbutton.setTitleColor(standard_Red, for: UIControlState())
        
        if delegate().responds(to: #selector(LiveQuestionViewDelegate.delegateQuestionCleared(_:withCurrentmainTopicId:withCurrentMainTopicName:)))
        {
            delegate().delegateQuestionCleared!(currentQuestionDetails, withCurrentmainTopicId: currentMainTopicId, withCurrentMainTopicName: currentMainTopicName)
        }
    }
    
    func onFreezButton()
    {
        
        var QuestonAvgScore = currentQuestionDetails.object(forKey: "QuestonAvgScore")as? NSString
        
        QuestonAvgScore = String(format: "%02d", QuestonAvgScore!.floatValue) as NSString?
        
        let NumberOfResponses = currentQuestionDetails.object(forKey: "NumberOfResponses")as? String
        
        
        
        
        SSTeacherMessageHandler.sharedMessageHandler.freezeQnAMessageToRoom("question_\(SSTeacherDataSource.sharedDataSource.currentLiveSessionId)", withAverageScore: QuestonAvgScore! as String, withTotalResponses: NumberOfResponses!)
        
        mFreezbutton.isEnabled = false
        mFreezbutton.setTitleColor(UIColor.lightGray, for: UIControlState())
        
        
        if delegate().responds(to: #selector(LiveQuestionViewDelegate.delegateFreezQuestion))
        {
            delegate().delegateFreezQuestion!()
        }

        
        
    }
    
    func onInfoButton()
    {
        
        if let questionType = currentQuestionDetails.object(forKey: "Type") as? String
        {
            if questionType == kOverlayScribble
            {
                let questionInfoController = ScribbleQuestionInfoScreen()
                questionInfoController.setdelegate(self)
                
                questionInfoController.setScribbleInfoDetails(currentQuestionDetails)
                
                
                questionInfoController.preferredContentSize = CGSize(width: 400,height: 317)
                
                let   classViewPopOverController = UIPopoverController(contentViewController: questionInfoController)
                questionInfoController.setPopover(classViewPopOverController)
                classViewPopOverController.contentSize = CGSize(width: 400,height: 317);
                classViewPopOverController.delegate = self;
                
                classViewPopOverController.present(from: CGRect(
                    x:mInfoButton.frame.origin.x ,
                    y:mInfoButton.frame.origin.y + mInfoButton.frame.size.height / 2,
                    width: 1,
                    height: 1), in: self, permittedArrowDirections: .right, animated: true)
            }
            else if questionType == kMRQ || questionType == kMCQ
            {
                let questionInfoController = SingleResponceOption()
                
                
                questionInfoController.setQuestionDetails(currentQuestionDetails)
                
                
                questionInfoController.preferredContentSize = CGSize(width: 400,height: 317)
                
                let   classViewPopOverController = UIPopoverController(contentViewController: questionInfoController)
                questionInfoController.setPopover(classViewPopOverController)
                classViewPopOverController.contentSize = CGSize(width: 400,height: 317);
                classViewPopOverController.delegate = self;
                
                classViewPopOverController.present(from: CGRect(
                    x:mInfoButton.frame.origin.x ,
                    y:mInfoButton.frame.origin.y + mInfoButton.frame.size.height / 2,
                    width: 1,
                    height: 1), in: self, permittedArrowDirections: .right, animated: true)
            }
            else if questionType == kMatchColumn
            {
                let questionInfoController = MatchColumnOption()
                questionInfoController.setdelegate(self)
                
                questionInfoController.setQuestionDetails(currentQuestionDetails)
                
                
                questionInfoController.preferredContentSize = CGSize(width: 400,height: 317)
                
                let   classViewPopOverController = UIPopoverController(contentViewController: questionInfoController)
                questionInfoController.setPopover(classViewPopOverController)
                classViewPopOverController.contentSize = CGSize(width: 400,height: 317);
                classViewPopOverController.delegate = self;
                
                classViewPopOverController.present(from: CGRect(
                    x:mInfoButton.frame.origin.x ,
                    y:mInfoButton.frame.origin.y + mInfoButton.frame.size.height / 2,
                    width: 1,
                    height: 1), in: self, permittedArrowDirections: .right, animated: true)
            }
        }
    }
    
}
