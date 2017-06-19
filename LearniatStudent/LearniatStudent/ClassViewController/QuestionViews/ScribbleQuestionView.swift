//
//  ScribbleQuestionView.swift
//  LearniatStudent
//
//  Created by Deepak MK on 16/05/16.
//  Copyright © 2016 Mindshift. All rights reserved.
//

import Foundation


@objc protocol ScribbleQuestionViewDelegate
{
    
    @objc optional func delegateEditButtonPressedWithOverlayImage(_ overlay:UIImage)
    
    
}



class ScribbleQuestionView: UIView,SSStudentDataSourceDelegate,ImageUploadingDelegate,UIPopoverControllerDelegate
{
   
    var currentQuestionDetails:AnyObject!
    
    var mTopbarImageView = UIImageView()
    
    var mQuestionLabel = UILabel()
    
    var mSendButton = UIButton()
    
    var mDontKnow = UIButton()

    var sessionDetails:AnyObject!
    
    var questionLogId = ""
    
    let imageUploading = ImageUploading()
    
    var currentQuestionType :String!
    
    var mReplyStatusLabelView           = UILabel()
    
    
    var mContainerView = UIView()
    
    var mOverlayImageView        = CustomProgressImageView()
    
    
    
   var mEditButton         = UIButton()
    
    var mBottomToolBarImageView :UIImageView!
    
    
    var mWithDrawButton     = UIButton()

    var sendButtonSpinner : UIActivityIndicatorView!
    
    var _delgate: AnyObject!
    
     var modelAnswerScrollView = UIScrollView()
    
    let m_BrushButton = UIButton()
    
    let m_EraserButton = UIButton()
    
    let m_RedoButton = UIButton()
    
    let m_UndoButton = UIButton()
    
    let bottomtoolSelectedImageView = UIImageView()
    
    var mScribbleView : SmoothLineView!
    
    
    var isModelAnswerRecieved = false
    
    var modelAnswerArray = NSMutableArray()
    
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
        super.init(frame: frame)
        
        
        self.backgroundColor = whiteBackgroundColor
        
        imageUploading.setDelegate(self)
        
        mTopbarImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: self.frame.size.width, height: 60))
        mTopbarImageView.backgroundColor = lightGrayTopBar
        self.addSubview(mTopbarImageView)
        mTopbarImageView.isUserInteractionEnabled = true
        mTopbarImageView.isUserInteractionEnabled = true
        
        
        mSendButton.frame = CGRect(x: mTopbarImageView.frame.size.width - 210, y: 0,width: 200,height: mTopbarImageView.frame.size.height )
        mTopbarImageView.addSubview(mSendButton)
        mSendButton.addTarget(self, action: #selector(ScribbleQuestionView.onSendButton), for: UIControlEvents.touchUpInside)
        mSendButton.setTitle("Send", for: UIControlState())
        mSendButton.contentHorizontalAlignment = UIControlContentHorizontalAlignment.right
        mSendButton.titleLabel?.font = UIFont (name: helveticaMedium, size: 20)
        mSendButton.setTitleColor(standard_Button, for: UIControlState())
        
        
        
        sendButtonSpinner = UIActivityIndicatorView(activityIndicatorStyle:.whiteLarge);
        sendButtonSpinner.frame = mSendButton.frame;
        mTopbarImageView.addSubview(sendButtonSpinner);
        sendButtonSpinner.isHidden = true;
        
        
        
        mDontKnow.frame = CGRect(x: 10, y: 0,width: 200,height: mTopbarImageView.frame.size.height )
        mTopbarImageView.addSubview(mDontKnow)
        mDontKnow.addTarget(self, action: #selector(ScribbleQuestionView.onDontKnowButton), for: UIControlEvents.touchUpInside)
        mDontKnow.setTitle("Don't know", for: UIControlState())
        mDontKnow.contentHorizontalAlignment = UIControlContentHorizontalAlignment.left
        mDontKnow.setTitleColor(standard_Button, for: UIControlState())
        mDontKnow.titleLabel?.font = UIFont (name: helveticaMedium, size: 20)
        
        mQuestionLabel.frame = CGRect(x: 10, y: mTopbarImageView.frame.size.height + mTopbarImageView.frame.origin.y, width: self.frame.size.width-20, height: 80)
        mQuestionLabel.numberOfLines = 20;
        mQuestionLabel.textAlignment = .center
        self.addSubview(mQuestionLabel)
        mQuestionLabel.textColor = topbarColor
        mQuestionLabel.font = UIFont (name: helveticaRegular, size: 20)
        mQuestionLabel.lineBreakMode = .byTruncatingMiddle
        self.addSubview(mReplyStatusLabelView)
        mReplyStatusLabelView.textColor = UIColor.white
        mReplyStatusLabelView.backgroundColor = dark_Yellow
        mReplyStatusLabelView.font = UIFont (name: helveticaBold, size: 16)
        mReplyStatusLabelView.textAlignment = .center
        
        
        
        
        var remainingHeight = self.frame.size.height  - (mQuestionLabel.frame.size.height + mQuestionLabel.frame.origin.y)
        
        remainingHeight = remainingHeight / 1.2
        
        
        mContainerView.frame = CGRect(x: (self.frame.size.width - (remainingHeight * 1.5))/2 ,y: mQuestionLabel.frame.size.height + mQuestionLabel.frame.origin.y , width: remainingHeight * 1.5 , height: remainingHeight)
        self.addSubview(mContainerView)
        mContainerView.backgroundColor = UIColor.white
        mContainerView.layer.shadowColor = progressviewBackground.cgColor;
        mContainerView.layer.shadowOffset = CGSize(width: 0,height: 0);
        mContainerView.layer.shadowOpacity = 1;
        mContainerView.layer.shadowRadius = 1.0;
        mContainerView.clipsToBounds = false;
        mContainerView.layer.borderColor = topicsLineColor.cgColor
        mContainerView.layer.borderWidth = 1
        
//        mEditButton.frame = CGRect(x: mContainerView.frame.origin.x, y: mContainerView.frame.size.height + mContainerView.frame.origin.y, width: mContainerView.frame.size.width, height: 40)
//        self.addSubview(mEditButton)
//        mEditButton.setTitle("Edit", for: UIControlState())
//        mEditButton.setTitleColor(standard_Button, for: UIControlState())
//         mEditButton.addTarget(self, action: #selector(ScribbleQuestionView.onEditButton), for: UIControlEvents.touchUpInside)
//        mEditButton.layer.borderColor = topicsLineColor.cgColor
//        mEditButton.layer.borderWidth = 1
//        mEditButton.backgroundColor = whiteColor
        
        
        
        mWithDrawButton.frame = CGRect(x: mContainerView.frame.origin.x, y: mContainerView.frame.size.height + mContainerView.frame.origin.y, width: mContainerView.frame.size.width, height: 40)
        self.addSubview(mWithDrawButton)
        mWithDrawButton.setTitle("Withdraw", for: UIControlState())
        mWithDrawButton.setTitleColor(standard_Button, for: UIControlState())
        mWithDrawButton.addTarget(self, action: #selector(ScribbleQuestionView.onWithDrawButton), for: UIControlEvents.touchUpInside)
        mWithDrawButton.layer.borderColor = topicsLineColor.cgColor
        mWithDrawButton.layer.borderWidth = 1
        mWithDrawButton.backgroundColor = whiteColor
        mWithDrawButton.isHidden = true

        
        
        
        mOverlayImageView.frame = CGRect(x: 0 ,y: 0 , width: mContainerView.frame.size.width ,height: mContainerView.frame.size.height)
        mContainerView.addSubview(mOverlayImageView)
        
        
        
        mScribbleView = SmoothLineView(frame: CGRect(x: 0,y: 0,width: mContainerView.frame.size.width, height: mContainerView.frame.size.height))
        mScribbleView.delegate = self
        mContainerView.addSubview(mScribbleView);
        mScribbleView.isUserInteractionEnabled = true
        mScribbleView.setDrawing(blackTextColor);
        mScribbleView.setBrushWidth(5)
        mScribbleView.setDrawing(kBrushTool)
        var brushSize = UserDefaults.standard.float(forKey: "selectedBrushsize")
        if brushSize < 5
        {
            brushSize = 5
        }
        mScribbleView.setBrushWidth(Int32(brushSize))
        mScribbleView.isHidden = false

        
        
        
        
        
        
        
        modelAnswerScrollView.frame = CGRect(x: self.frame.size.width - 110, y: mTopbarImageView.frame.origin.y + mTopbarImageView.frame.size.height, width: 110, height: self.frame.size.height - (mTopbarImageView.frame.origin.y + mTopbarImageView.frame.size.height));
        self.addSubview(modelAnswerScrollView)
        modelAnswerScrollView.isHidden = true
        modelAnswerScrollView.isUserInteractionEnabled = true
        
        
        
        
        
        let longGesture = UITapGestureRecognizer(target: self, action: #selector(ScribbleQuestionView.Long)) //Long function will call when user long press on button.
        modelAnswerScrollView.addGestureRecognizer(longGesture)
        longGesture.numberOfTapsRequired = 1

        
        mBottomToolBarImageView = UIImageView(frame: CGRect(x: mContainerView.frame.origin.x, y: mContainerView.frame.origin.y + mContainerView.frame.size.height, width: mContainerView.frame.size.width, height: 60))
        mBottomToolBarImageView.backgroundColor = whiteColor
        self.addSubview(mBottomToolBarImageView)
        mBottomToolBarImageView.isUserInteractionEnabled = true
        
        
        
        
        m_UndoButton.frame = CGRect(x: 0, y: 0, width: mBottomToolBarImageView.frame.size.height, height: mBottomToolBarImageView.frame.size.height)
        m_UndoButton.setImage(UIImage(named:"Undo_Disabled.png"),for:UIControlState());
        mBottomToolBarImageView.addSubview(m_UndoButton);
        m_UndoButton.imageView?.contentMode = .scaleAspectFit
        m_UndoButton.addTarget(self, action: #selector(ScribbleQuestionView.onUndoButton), for: UIControlEvents.touchUpInside)
        m_UndoButton.isEnabled = false
        
        bottomtoolSelectedImageView.backgroundColor = UIColor.white;
        mBottomToolBarImageView.addSubview(bottomtoolSelectedImageView);
        
        
        m_BrushButton.frame = CGRect(x: (mBottomToolBarImageView.frame.size.width/2) - (mBottomToolBarImageView.frame.size.height + 10) ,y: 5, width: mBottomToolBarImageView.frame.size.height ,height: mBottomToolBarImageView.frame.size.height - 10)
        m_BrushButton.setImage(UIImage(named:"Marker_Selected.png"), for:UIControlState())
        mBottomToolBarImageView.addSubview(m_BrushButton);
        m_BrushButton.imageView?.contentMode = .scaleAspectFit
        m_BrushButton.addTarget(self, action: #selector(ScribbleQuestionView.onBrushButton), for: UIControlEvents.touchUpInside)
        bottomtoolSelectedImageView.frame = m_BrushButton.frame
        
        
        
        
        m_EraserButton.frame = CGRect(x: (mBottomToolBarImageView.frame.size.width/2) + 10  ,y: 5, width: mBottomToolBarImageView.frame.size.height ,height: mBottomToolBarImageView.frame.size.height - 10)
        m_EraserButton.setImage(UIImage(named:"Eraser_Unselected.png"), for:UIControlState());
        mBottomToolBarImageView.addSubview(m_EraserButton);
        m_EraserButton.imageView?.contentMode = .scaleAspectFit
        m_EraserButton.addTarget(self, action: #selector(ScribbleQuestionView.onEraserButton), for: UIControlEvents.touchUpInside)
        
        
        m_RedoButton.frame = CGRect(x: mBottomToolBarImageView.frame.size.width - mBottomToolBarImageView.frame.size.height ,y: 0, width: mBottomToolBarImageView.frame.size.height ,height: mBottomToolBarImageView.frame.size.height)
        m_RedoButton.setImage(UIImage(named:"Redo_Disabled.png"), for:UIControlState());
        mBottomToolBarImageView.addSubview(m_RedoButton);
        m_RedoButton.imageView?.contentMode = .scaleAspectFit
        m_RedoButton.addTarget(self, action: #selector(ScribbleQuestionView.onRedoButton), for: UIControlEvents.touchUpInside)
        m_RedoButton.isEnabled = false
        

        
        

        
    }
    
    func Long()
    {
        
        let modelAnswerFullView = ModelAnswerFullView(frame:CGRect(x: 10,y: 10,width: self.frame.size.width - 20, height: self.frame.size.height - 20 ))
        self.addSubview(modelAnswerFullView)
        
        if mOverlayImageView.image != nil
        {
           modelAnswerFullView.setModelAnswerDetailsArray(modelAnswerArray, withQuestionName: mQuestionLabel.text!, withOverlayImage: mOverlayImageView.image!)
        }
        else
        {
            modelAnswerFullView.setModelAnswerDetailsArray(modelAnswerArray, withQuestionName: mQuestionLabel.text!,withOverlayImage: UIImage())
        }
        
        
        modelAnswerFullView.layer.shadowRadius = 1.0;
        
        modelAnswerFullView.layer.shadowColor = UIColor.black.cgColor
        modelAnswerFullView.layer.shadowOpacity = 0.3
        modelAnswerFullView.layer.shadowOffset = CGSize.zero
        modelAnswerFullView.layer.shadowRadius = 10

        
        
//        modelAnswerFullView.layer.shadowColor = progressviewBackground.CGColor;
//        modelAnswerFullView.layer.shadowOffset = CGSizeMake(0,0);
//        modelAnswerFullView.layer.shadowOpacity = 1;
//        modelAnswerFullView.layer.shadowRadius = 1.0;

    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - Buttons  delegate
    
    func onUndoButton()
    {
        mScribbleView.undoButtonClicked()
    }
    
    func onBrushButton()
    {
        
        
        
        if bottomtoolSelectedImageView.frame == m_BrushButton.frame
        {
            
            let buttonPosition :CGPoint = m_BrushButton.convert(CGPoint.zero, to: self)
            
            
            let colorSelectContoller = colorpopOverViewController()
            colorSelectContoller.setSelectTab(1);
            colorSelectContoller.setDelegate(self);
            colorSelectContoller.setRect(CGRect(x: 0,y: 0,width: 400,height: 400));
            
            
            colorSelectContoller.title = "Brush Size & Colour";
            
            let navController = UINavigationController(rootViewController:colorSelectContoller)
            
            let colorPopoverController = UIPopoverController(contentViewController:navController);
            colorPopoverController.contentSize = CGSize(width: 400, height: 400);
            colorPopoverController.delegate = self;
            colorSelectContoller.setPopOver(colorPopoverController);
            
            colorPopoverController.present(from: CGRect(x: buttonPosition.x  + (m_BrushButton.frame.size.width/2),y: buttonPosition.y,width: 1,height: 1), in: self, permittedArrowDirections: .down, animated: true)
            
        }
        
        bottomtoolSelectedImageView.frame = m_BrushButton.frame
        m_BrushButton.setImage(UIImage(named:"Marker_Selected.png"), for:UIControlState())
        m_EraserButton.setImage(UIImage(named:"Eraser_Unselected.png"), for:UIControlState())
        mScribbleView.setDrawing(kBrushTool)
        var brushSize = UserDefaults.standard.float(forKey: "selectedBrushsize")
        if brushSize < 5
        {
            brushSize = 5
        }
        mScribbleView.setBrushWidth(Int32(brushSize))
        
        
        
        
        
        
    }
    
    func onEraserButton()
    {
        
        
        if bottomtoolSelectedImageView.frame == m_EraserButton.frame
        {
            
            let buttonPosition :CGPoint = m_EraserButton.convert(CGPoint.zero, to: self)
            
            
            let colorSelectContoller = colorpopOverViewController()
            colorSelectContoller.setSelectTab(2);
            colorSelectContoller.setDelegate(self);
            colorSelectContoller.setRect(CGRect(x: 0,y: 0,width: 200,height: 200));
            
            
            colorSelectContoller.title = "Eraser Size & Colour";
            
            let navController = UINavigationController(rootViewController:colorSelectContoller)
            
            let colorPopoverController = UIPopoverController(contentViewController:navController);
            colorPopoverController.contentSize = CGSize(width: 200, height: 150);
            colorPopoverController.delegate = self;
            colorSelectContoller.setPopOver(colorPopoverController);
            
            colorPopoverController.present(from: CGRect(x: buttonPosition.x  + (m_EraserButton.frame.size.width/2),y: buttonPosition.y,width: 1,height: 1), in: self, permittedArrowDirections: .down, animated: true)
            
        }
        
        
        
        
        bottomtoolSelectedImageView.frame = m_EraserButton.frame
        m_BrushButton.setImage(UIImage(named:"Marker_Unselected.png"), for:UIControlState())
        m_EraserButton.setImage(UIImage(named:"Eraser_Selected.png"), for:UIControlState())
        mScribbleView.setDrawing(kEraserTool)
        let eraserSize = UserDefaults.standard.float(forKey: "selectedEraserSize")
        mScribbleView.setBrushWidth(Int32(eraserSize))
        
        
        
        
        
        
        
        
        
    }
    
    func onRedoButton()
    {
        mScribbleView.redoButtonClicked()
    }
    
    
    func onEditButton()
    {
        if mOverlayImageView.image != nil
        {
            delegate().delegateEditButtonPressedWithOverlayImage!(mOverlayImageView.image!)
        }
        else
        {
            delegate().delegateEditButtonPressedWithOverlayImage!(UIImage())
        }
    }
    
    func onWithDrawButton()
    {
        mContainerView.isHidden = false
        mEditButton.isHidden = false
        mReplyStatusLabelView.isHidden = true
        mTopbarImageView.isHidden = false
        SSStudentDataSource.sharedDataSource.answerSent = false
        mWithDrawButton.isHidden = true
        sendButtonSpinner.isHidden = true
        sendButtonSpinner.stopAnimating()
        mSendButton.isHidden = false
        mScribbleView.isUserInteractionEnabled = true
        mBottomToolBarImageView.isHidden = false
        SSStudentMessageHandler.sharedMessageHandler.sendWithDrawMessageToTeacher()
    }
    
    func onSendButton()
    {
        if mScribbleView.curImage != nil
        {
            mScribbleView.isUserInteractionEnabled = false
            mBottomToolBarImageView.isHidden = true
            let currentDate = Date()
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-mm-dd HH:mm:ss"
            
            sendButtonSpinner.isHidden = false
            sendButtonSpinner.startAnimating()
            mSendButton.isHidden = true
            mEditButton.isHidden = true
            mWithDrawButton.isHidden = true
            
            let currentDateString = dateFormatter.string(from: currentDate)
            
            let imagePathString = SSStudentDataSource.sharedDataSource.currentUserId.appending("-").appending(SSStudentDataSource.sharedDataSource.currentLiveSessionId).appending("-").appending(currentDateString)
            
            
            
            var nameOfImage  = "SS-".appending(imagePathString)
            nameOfImage =  nameOfImage.replacingOccurrences(of: " ", with: "")
            
            
            imageUploading.uploadImage(with: mScribbleView.curImage, withImageName: nameOfImage, withUserId: SSStudentDataSource.sharedDataSource.currentUserId)
        }
        
        
    }
    
    func onDontKnowButton()
    {
        SSStudentMessageHandler.sharedMessageHandler.sendDontKnowMessageToTeacher()
        
        mReplyStatusLabelView.frame = CGRect(x: (self.frame.size.width - (mTopbarImageView.frame.size.height * 2)) / 2, y: 0, width: mTopbarImageView.frame.size.height * 2, height: mTopbarImageView.frame.size.height / 1.5)
        mReplyStatusLabelView.isHidden = false
        mReplyStatusLabelView.text = "Don't Know"
        mTopbarImageView.isHidden = true
        
       mEditButton.isHidden = true
        mWithDrawButton.isHidden = true
        SSStudentDataSource.sharedDataSource.answerSent = true
        
        mScribbleView.isUserInteractionEnabled = false
        mBottomToolBarImageView.isHidden = true
    }
    
    
    func setQuestionDetails(_ details:AnyObject, withsessionDetails _sessionDetails:AnyObject, withQuestionLogId _logId:String)
    {
        currentQuestionDetails = details
        questionLogId = _logId
        sessionDetails = _sessionDetails
        
        currentQuestionType = (details.object(forKey: kQuestionType) as? String)
        
        
        if (details.object(forKey: kQuestionName) as? String) != ""
        {
            mQuestionLabel.text = (details.object(forKey: kQuestionName) as? String)
        }
        
        
        
        
        if (details.object(forKey: "Scribble") != nil)
        {
        
            
            if let Scribble = details.object(forKey: "Scribble") as? String
            {
                let urlString = UserDefaults.standard.object(forKey: k_INI_QuestionsImageUrl) as! String
                
                if let checkedUrl = URL(string: "\(urlString)/\(Scribble)")
                {
                    mOverlayImageView.contentMode = .scaleAspectFit
                    mOverlayImageView.downloadImage(checkedUrl, withFolderType: folderType.questionImage)
                }
            }
        }
       
        

        
        print(details)
        

    }
    
    
    
    func setDrawnImage(_ image:UIImage)
    {
        
    }
    
    
    // MARK: - ImageUploading delegate
    
    func imageUploaded(withName name: String!)
    {
        var nameOfImage = name
        if name.range(of: ".png") == nil
        {
           nameOfImage = "upload/".appending(name).appending(".png")
        }
        
        
        
        
       SSStudentDataSource.sharedDataSource.sendScribbleAnswer(nameOfImage!, withQuestionType: currentQuestionType, withQuestionLogId: questionLogId, withsessionId: (sessionDetails.object(forKey: "SessionId") as! String), withDelegate: self)
       
    }
    
    func errorInUploading(withName name: String!) {
        
        sendButtonSpinner.isHidden = true
        sendButtonSpinner.stopAnimating()
        mSendButton.isHidden = false
        mEditButton.isHidden = false
        mWithDrawButton.isHidden = true
        
        mScribbleView.isUserInteractionEnabled = true
        mBottomToolBarImageView.isHidden = false
    }
    
    
    func didGetAnswerSentWithDetails(_ details: AnyObject)
    {
        SSStudentMessageHandler.sharedMessageHandler.sendAnswerToQuestionMessageToTeacherWithAnswerString(details.object(forKey: "AssessmentAnswerId") as! String)
        
        
        mReplyStatusLabelView.frame = CGRect(x: (self.frame.size.width - (mTopbarImageView.frame.size.height * 2)) / 2, y: 0, width: mTopbarImageView.frame.size.height * 2, height: mTopbarImageView.frame.size.height / 1.5)
        
        mReplyStatusLabelView.isHidden = false
        
        mReplyStatusLabelView.text = "Reply sent"
        
        mTopbarImageView.isHidden = true
        
        mEditButton.isHidden = true
        
        mWithDrawButton.isHidden = false
        
        SSStudentDataSource.sharedDataSource.answerSent = true
        mWithDrawButton.isHidden = false
        
        
        if isModelAnswerRecieved  == true
        {
            SSStudentDataSource.sharedDataSource.getModelAnswerFromTeacherForQuestionLogId(questionLogId, withDelegate: self)
        }
        

        
    }
    
    
    func didGetAllModelAnswerWithDetails(_ details: AnyObject)
    {
        
        
        modelAnswerArray.removeAllObjects()
        
        
        let subViews = modelAnswerScrollView.subviews
        
        for subview in subViews
        {
            if subview.isKind(of: ModelAnswerView.self)
            {
                subview.removeFromSuperview()
            }
        }
        
        if let _modelAnswerArray = (details.object(forKey: "AssessmentAnswerIdList") as AnyObject).object(forKey: "AssessmentAnswerId") as? NSMutableArray
        {
            showModelAnswerWithDetailsArray(_modelAnswerArray)
            modelAnswerArray = _modelAnswerArray
            
        }
        else
        {
            let testVariable :NSMutableArray = NSMutableArray()
            testVariable.add((details.object(forKey: "AssessmentAnswerIdList")! as AnyObject).object(forKey: "AssessmentAnswerId")!)
            showModelAnswerWithDetailsArray(testVariable)
            
            modelAnswerArray = testVariable
            
        }
        
        
        
        
    }
    
    func showModelAnswerWithDetailsArray(_ modelAnswersArray:NSMutableArray)
    {
        print(modelAnswersArray)
        
        
        let subViews = modelAnswerScrollView.subviews
        
        for subview in subViews
        {
            if subview.isKind(of: ModelAnswerView.self)
            {
                subview.removeFromSuperview()
            }
        }
        
        
        modelAnswerScrollView.isHidden = false
        
        
        var positionY:CGFloat = 10
        
        for index in 0  ..< modelAnswersArray.count 
        {
            
            let dict = modelAnswersArray.object(at: index)
            
            print(dict)
            let modelAnswer  = ModelAnswerView(frame: CGRect(x: 5, y: positionY, width: 100, height: 100))
            modelAnswerScrollView.addSubview(modelAnswer)
            if (dict as AnyObject).object(forKey: "Image") != nil
            {
                if let ScribbleName = (dict as AnyObject).object(forKey: "Image") as? String
                {
                    if mOverlayImageView.image != nil
                    {
                        modelAnswer.setScribbleImageName(ScribbleName, withOverlayImage: mOverlayImageView.image!)
                    }
                    else
                        {
                            modelAnswer.setScribbleImageName(ScribbleName, withOverlayImage: UIImage())
                    }
                    
                }
            }
            
            
            
            
            if (dict as AnyObject).object(forKey: "StudentId") as! String == SSStudentDataSource.sharedDataSource.currentUserId
            {
                modelAnswer.backgroundColor = standard_Green
                modelAnswer.modelAnswerLabel.text = "Your answer selected"
                
            }
            else
            {
                modelAnswer.backgroundColor =  UIColor(red: 0.0/255.0, green: 174.0/255.0, blue: 239.0/255.0, alpha: 1)
                
                modelAnswer.modelAnswerLabel.text = "Model Answer"
            }
            positionY = positionY + modelAnswer.frame.size.height + 10
            
        }
        
        modelAnswerScrollView.contentSize = CGSize(width: 0,height: positionY)
         mEditButton.isHidden = true
        mWithDrawButton.isHidden = true
        mTopbarImageView.isHidden = true
        
        
    }
    
    
    func didgetErrorMessage(_ message: String, WithServiceName serviceName: String)
    {
        sendButtonSpinner.isHidden = true
        sendButtonSpinner.stopAnimating()
        mSendButton.isHidden = false
        mEditButton.isHidden = false
        
    }
    
    func didGetEvaluatingMessage()
    {
        mWithDrawButton.isHidden = true
         mReplyStatusLabelView.text = "Evaluating..."
    }
    
    func getFeedBackDetails(_ details:AnyObject)
    {
        
        
        mReplyStatusLabelView.text = "Evaluated"
        
        let teacherReplyStatusView = UIImageView(frame:CGRect(x: mWithDrawButton.frame.origin.x, y: mWithDrawButton.frame.origin.y, width: mWithDrawButton.frame.size.width, height: 0))
        teacherReplyStatusView.backgroundColor = topbarColor
        self.addSubview(teacherReplyStatusView)
        
        
        
        var badgeValue    = 0
        var starCount   = 0
        
        if (details.object(forKey: "BadgeId") != nil)
        {
            if let badgeId = details.object(forKey: "BadgeId") as? String
            {
                 badgeValue = Int(badgeId)!
            }
        }
        
        
        if (details.object(forKey: "Rating") != nil)
        {
            if let Rating = details.object(forKey: "Rating") as? String
            {
                starCount = Int(Rating)!
            }
        }
        
        
        if starCount > 0
        {
            
            
            teacherReplyStatusView.frame = CGRect(x: mWithDrawButton.frame.origin.x, y: mWithDrawButton.frame.origin.y, width: mWithDrawButton.frame.size.width, height: mWithDrawButton.frame.size.height)
            
            
            var width = (teacherReplyStatusView.frame.size.width -  (teacherReplyStatusView.frame.size.height*CGFloat(starCount) ))/2
            
            if badgeValue > 0
            {
                width = 10
            }
            
            
            let starBackGround = UIImageView(frame: CGRect(x: width, y: 0, width: teacherReplyStatusView.frame.size.height*CGFloat(starCount) , height: teacherReplyStatusView.frame.size.height))
            teacherReplyStatusView.addSubview(starBackGround)
            starBackGround.backgroundColor = UIColor.clear
            
            
            
            
            
            
            
            var starWidth = starBackGround.frame.size.height
            let starSpace = starWidth * 0.2
            
            starWidth = starWidth * 0.8
            
            var positionX:CGFloat = 0
            for _ in 0  ..< starCount
            {
                let starImage = UIImageView(frame: CGRect(x: positionX,y: 0, width: starWidth ,height: starBackGround.frame.size.height))
                starBackGround.addSubview(starImage)
                starImage.image = UIImage(named: "Star_Selected.png")
                starImage.contentMode = .scaleAspectFit
                positionX = positionX + starImage.frame.size.width + starSpace
            }
            
            
            
            
            
            
            if badgeValue > 0
            {
                
                let badgeImage = CustomProgressImageView(frame: CGRect(x: teacherReplyStatusView.frame.size.width - (starWidth + 10) ,y: 0, width: starWidth ,height: starBackGround.frame.size.height))
                teacherReplyStatusView.addSubview(badgeImage)
                badgeImage.image = UIImage(named: "ic_thumb_up_green_48dp.png")

                
                
                let urlString = UserDefaults.standard.object(forKey: k_INI_Badges) as! String
               
                if let checkedUrl = URL(string: ("\(urlString)/\(badgeValue).png"))
                {
                    badgeImage.contentMode = .scaleAspectFit
                    badgeImage.downloadImage(checkedUrl, withFolderType: folderType.badgesImages)
                }
            }
        }
        else
        {
            if badgeValue > 0
            {
                
                
                 teacherReplyStatusView.frame = CGRect(x: mWithDrawButton.frame.origin.x, y: mWithDrawButton.frame.origin.y, width: mWithDrawButton.frame.size.width, height: mWithDrawButton.frame.size.height)
                
                
                let badgeImage = CustomProgressImageView(frame: CGRect(x: (teacherReplyStatusView.frame.size.width - teacherReplyStatusView.frame.size.height)/2 ,y: 0, width: teacherReplyStatusView.frame.size.height ,height: teacherReplyStatusView.frame.size.height))
                teacherReplyStatusView.addSubview(badgeImage)
                badgeImage.image = UIImage(named: "ic_thumb_up_green_48dp.png")
                
                
                
                let urlString = UserDefaults.standard.object(forKey: k_INI_Badges) as! String
                
                if let checkedUrl = URL(string: ("\(urlString)/\(badgeValue).png"))
                {
                    badgeImage.contentMode = .scaleAspectFit
                    badgeImage.downloadImage(checkedUrl, withFolderType: folderType.badgesImages)
                }
            }
        }
        
        
        
        
        if   let mTextValue = details.object(forKey: "TextRating")  as? String
        {
            
            
            
            
            let height = mTextValue.heightForView(mTextValue, font: UIFont (name: helveticaMedium, size: 20)!, width: teacherReplyStatusView.frame.size.width)
            
           let mTextReplyLabel = UILabel(frame: CGRect(x: 0, y: teacherReplyStatusView.frame.size.height, width: teacherReplyStatusView.frame.size.width, height: height))
            teacherReplyStatusView.addSubview(mTextReplyLabel)
            mTextReplyLabel.numberOfLines = 4
            mTextReplyLabel.lineBreakMode = .byTruncatingMiddle
            mTextReplyLabel.textAlignment = .center
            mTextReplyLabel.text = mTextValue
            mTextReplyLabel.textColor = UIColor.white
            
            
             teacherReplyStatusView.frame = CGRect(x: mWithDrawButton.frame.origin.x, y: mWithDrawButton.frame.origin.y, width: mWithDrawButton.frame.size.width, height: teacherReplyStatusView.frame.size.height + height)
            
        }
        
        
        if (details.object(forKey: "ImagePath") != nil)
        {
            if let Scribble = details.object(forKey: "ImagePath") as? String
            {
                var urlString = UserDefaults.standard.object(forKey: k_INI_QuestionsImageUrl) as! String
                urlString = urlString.appending("/").appending(Scribble)
                
                if urlString.contains(".png") == false
                {
                    urlString = urlString.appending(".png")
                }
                
                if let checkedUrl = URL(string: urlString)
                {
                    let teacherImage = CustomProgressImageView(frame:mOverlayImageView.frame)
                    mContainerView.addSubview(teacherImage)
                    teacherImage.contentMode = .scaleAspectFit
                    teacherImage.downloadImage(checkedUrl, withFolderType: folderType.questionImage)
                    mContainerView.bringSubview(toFront: teacherImage)
                }
            }
        }
    }
    
    
    func FreezMessageFromTeacher()
    {
        if SSStudentDataSource.sharedDataSource.answerSent == false
        {
            onSendButton()
            
        }
        
        mReplyStatusLabelView.isHidden = false
        mReplyStatusLabelView.text = "Frozen"
    }
    
    func getPeakViewMessageFromTeacher()
    {
        if mScribbleView.curImage != nil
        {
            //Now use image to create into NSData format
            let imageData:Data = UIImagePNGRepresentation(mScribbleView.curImage!)!
            let strBase64:String = imageData.base64EncodedString(options: .lineLength64Characters)
            SSStudentMessageHandler.sharedMessageHandler.sendPeakViewMessageToTeacherWithImageData(strBase64)

        }
        else{
            
            SSStudentMessageHandler.sharedMessageHandler.sendPeakViewMessageToTeacherWithImageData(" ")

        }
    }
    
    
    func showModelAnswerWithDetails()
    {
        if SSStudentDataSource.sharedDataSource.answerSent == true
        {
            isModelAnswerRecieved = true
            SSStudentDataSource.sharedDataSource.getModelAnswerFromTeacherForQuestionLogId(questionLogId, withDelegate: self)
        }
        else
        {
            isModelAnswerRecieved = true
        }
    }
    
    
    
    // MARK: - Smooth line delegate
    
    func setUndoButtonEnable(_ enable: NSNumber!)
    {
        if enable == 1
        {
            m_UndoButton.setImage(UIImage(named:"Undo_Active.png"),for:UIControlState());
            m_UndoButton.isEnabled = true
        }
        else
        {
            m_UndoButton.setImage(UIImage(named:"Undo_Disabled.png"),for:UIControlState());
            m_UndoButton.isEnabled = false
        }
        
    }
    
    func setRedoButtonEnable(_ enable: NSNumber!)
    {
        if enable == 1
        {
            m_RedoButton.setImage(UIImage(named:"Redo_Active.png"),for:UIControlState());
            m_RedoButton.isEnabled = true
        }
        else
        {
            m_RedoButton.setImage(UIImage(named:"Redo_Disabled.png"),for:UIControlState());
            m_RedoButton.isEnabled = false
        }
        
        
    }
    
    func lineDrawnChanged()
    {
        
    }
    
    
    
   
    
    // MARK: - Color popover delegate
    
    func selectedbrushSize(_ sender: AnyObject!, withSelectedTab tabTag: Int32)
    {
        
        if let progressView = sender as? UISlider
        {
            mScribbleView.setBrushWidth(Int32(progressView.value));
        }
        
        
    }
    
    func selectedColor(_ sender: AnyObject!, withSelectedTab tabTag: Int32)
    {
        if let progressColor = sender as? UIColor
        {
            mScribbleView.setDrawing(progressColor);
        }
    }
    

    
}
