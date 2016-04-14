//
//  StudentAnnotateView.swift
//  LearniatTeacher
//
//  Created by Deepak MK on 14/04/16.
//  Copyright © 2016 Mindshift. All rights reserved.
//

import Foundation



@objc protocol StudentAnnotateViewDelegate
{
    
    
    optional func delegateSubmissionEvalauatedWithAnswerDetails(answerDetails:AnyObject,withEvaluationDetail evaluation:AnyObject, withStudentId studentId:String)
    
    
}



class StudentAnnotateView: UIView,UIPopoverControllerDelegate,SSTeacherDataSourceDelegate
{
    var _delgate: AnyObject!
    
    var topImageView = UIImageView()
    
    let mStudentImageView = UIImageView()
    
    let  mProgressView = YLProgressBar()

    let mStudentNameLabel = UILabel()
    
    let containerview = UIView()
    
    var mScribbleView : SmoothLineView!
    
    var studentsAswerDictonary      :AnyObject!

    var studentdict  :AnyObject!
    
    let m_UndoButton = UIButton()
    
    let bottomtoolSelectedImageView = UIImageView()
    
    let m_BrushButton = UIButton()
    
    let m_EraserButton = UIButton()
    
    let m_RedoButton = UIButton()
    
    
    let mMarkModelButton = UIButton()
    
    let mStarRatingView = SSStarRatingView()
    
    let m_textButton = UIButton()
    
    let m_badgeButton = UIButton()

    var          givenStarRatings       = 0
    
    var          givenBadgeId  :Int32   = 0
    
    var           givenTextReply        = ""
    
    var PopoverControllerRatings:UIPopoverController!
    
    var selectedtab    = ""
    
    var currentTeacherImageURl = ""
    
    let mSendButton = UIButton()
    
    let mCancelButton = UIButton()
    
     let imageUploading = ImageUploading()
    
    let _ratingsPopoverController = RatingsPopOverViewController()
    
    var isModelAnswerSelected     = false
    
    let kUplodingServer     = "http://54.251.104.13/Jupiter/upload_photos.php"
    
    
    var sendButtonSpinner : UIActivityIndicatorView!
    
    
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
        
        imageUploading.setDelegate(self)
        
        let  mTopbarImageView = UIImageView(frame: CGRectMake(0, 0, self.frame.size.width, 70))
        mTopbarImageView.backgroundColor = topbarColor
        self.addSubview(mTopbarImageView)
        mTopbarImageView.userInteractionEnabled = true
        
        
        
        let bottomview = UIImageView(frame: CGRectMake(0, self.frame.size.height - 60, self.frame.size.width, 60))
        bottomview.backgroundColor = topbarColor
        self.addSubview(bottomview)
        bottomview.userInteractionEnabled = true
        
        
        mCancelButton.showsTouchWhenHighlighted = true;
        /* Add Cancel button target Cancel button should deselect all the selected submissions *defect 142 */
        mCancelButton.frame = CGRectMake(10 , 0, 100,  mTopbarImageView.frame.size.height);
        mTopbarImageView.addSubview(mCancelButton);
        mCancelButton.setTitle("Cancel", forState:.Normal);
        mCancelButton.setTitleColor(UIColor.whiteColor(), forState:.Normal);
        mCancelButton.titleLabel?.font = UIFont(name: helveticaMedium, size: 20);
        mCancelButton.contentHorizontalAlignment = UIControlContentHorizontalAlignment.Left
        mCancelButton.addTarget(self, action: "onCancelButton", forControlEvents: UIControlEvents.TouchUpInside)
        
        
        mSendButton.frame = CGRectMake(mTopbarImageView.frame.size.width - 100 , 0, 100 , mTopbarImageView.frame.size.height );
        mTopbarImageView.addSubview(mSendButton);
        mSendButton.setTitle("Send", forState:.Normal);
        mSendButton.setTitleColor(UIColor.whiteColor(), forState:.Normal);
        mSendButton.titleLabel?.font = UIFont(name: helveticaMedium, size: 20);
        mSendButton.enabled = false
        mSendButton.highlighted = false;
        mSendButton.contentHorizontalAlignment = UIControlContentHorizontalAlignment.Center
        mSendButton.addTarget(self, action: "onSendButton", forControlEvents: UIControlEvents.TouchUpInside)
        
        
        sendButtonSpinner = UIActivityIndicatorView(activityIndicatorStyle:.WhiteLarge);
        sendButtonSpinner.frame = mSendButton.frame;
        mTopbarImageView.addSubview(sendButtonSpinner);
        sendButtonSpinner.hidden = true;
        


        
        
        
        topImageView.frame = CGRectMake(0,mTopbarImageView.frame.size.height, mTopbarImageView.frame.size.width, 54)
        topImageView.backgroundColor = UIColor.whiteColor()
        self.addSubview (topImageView);
        topImageView.layer.shadowColor = progressviewBackground.CGColor;
        topImageView.layer.shadowOffset = CGSizeMake(1, 1);
        topImageView.layer.shadowOpacity = 1;
        topImageView.layer.shadowRadius = 1.0;
        topImageView.clipsToBounds = false;
        topImageView.userInteractionEnabled = true
        
        
        
        
        m_textButton.frame = CGRectMake(topImageView.frame.size.width - 50, 10, 40, topImageView.frame.size.height - 20);
        //        [m_textButton addTarget:self action:@selector(onTextReplyButton:) forControlEvents:UIControlEventTouchUpInside];
        topImageView.addSubview(m_textButton);
        m_textButton.imageView?.contentMode = .ScaleAspectFit
        m_textButton.setImage(UIImage(named:"Text_Unselected.png"), forState:.Normal);
        m_textButton.addTarget(self, action: "onTextButton", forControlEvents: UIControlEvents.TouchUpInside)
        
        
        
        
        let lineImage1 = UIImageView(frame:CGRectMake(m_textButton.frame.origin.x - 10 , 5, 1, topImageView.frame.size.height - 10));
        lineImage1.backgroundColor = progressviewBackground
        topImageView.addSubview(lineImage1);
        
        
        m_badgeButton.frame = CGRectMake(lineImage1.frame.origin.x - 50, 10, 40, topImageView.frame.size.height - 20);
        //        [m_badgeButton addTarget:self action:@selector(onBadgeButton:) forControlEvents:UIControlEventTouchUpInside];
        topImageView.addSubview(m_badgeButton);
        m_badgeButton.imageView?.contentMode = .ScaleAspectFit
        m_badgeButton.setImage(UIImage(named:"Cb_Like_Disabled.png"), forState:.Normal);
        m_badgeButton.addTarget(self, action: "onBadgeButton", forControlEvents: UIControlEvents.TouchUpInside)
        
        
        let lineImage2 = UIImageView(frame:CGRectMake(m_badgeButton.frame.origin.x - 10, 5, 1, topImageView.frame.size.height - 10));
        lineImage2.backgroundColor = progressviewBackground
        topImageView.addSubview(lineImage2);
        
        
        mStarRatingView.backgroundColor = UIColor.clearColor();
        mStarRatingView.frame = CGRectMake(lineImage2.frame.origin.x - 190, 10, 180, topImageView.frame.size.height - 20);
        mStarRatingView.setDelegate(self);
        topImageView.addSubview(mStarRatingView);
        mStarRatingView.setsizeOfStar(30);
        
        
        let  mMarkModelButtonlineImage = UIImageView(frame: CGRectMake(mStarRatingView.frame.origin.x - 10, 5, 1, topImageView.frame.size.height - 10));
        mMarkModelButtonlineImage.backgroundColor = progressviewBackground
        topImageView.addSubview(mMarkModelButtonlineImage);
        
        
        
        mMarkModelButton.frame = CGRectMake(mMarkModelButtonlineImage.frame.origin.x - 160, 0, 150, topImageView.frame.size.height);
        topImageView.addSubview(mMarkModelButton);
        mMarkModelButton.setImage(UIImage(named:"Mark_Model_Not_Selected.png"), forState:.Normal);
        mMarkModelButton.setTitle("  Mark Model", forState:.Normal);
        mMarkModelButton.setTitleColor(blackTextColor, forState:.Normal)
        mMarkModelButton.titleLabel?.font = UIFont(name: helveticaMedium, size: 20);
        mMarkModelButton.addTarget(self, action: "onModelAnswerButton", forControlEvents: UIControlEvents.TouchUpInside)
        
        
        
        
        mStudentImageView.frame = CGRectMake(10 , 7, 40, 40)
        topImageView.addSubview(mStudentImageView);
        
        
        mStudentNameLabel.frame = CGRectMake(mStudentImageView.frame.origin.x + mStudentImageView.frame.size.width + 10  ,mStudentImageView.frame.origin.y , 200 ,mStudentImageView.frame.size.height)
        mStudentNameLabel.text = ""
        mStudentNameLabel.font = UIFont(name: helveticaMedium, size: 14);
        mStudentNameLabel.textAlignment = .Left;
        mStudentNameLabel.textColor = blackTextColor
        topImageView.addSubview(mStudentNameLabel);
        

        
        
        var contanerHeight  = topImageView.frame.origin.y + topImageView.frame.size.height + bottomview.frame.size.height + 20
        contanerHeight = self.frame.size.height - contanerHeight
        
        containerview.frame = CGRectMake((self.frame.size.width - (contanerHeight * kAspectRation)) / 2 , topImageView.frame.origin.y + topImageView.frame.size.height + 10 ,  contanerHeight * kAspectRation ,contanerHeight)
        containerview.backgroundColor = UIColor.whiteColor()
        self.addSubview(containerview);
        containerview.layer.shadowColor = progressviewBackground.CGColor;
        containerview.layer.shadowOffset = CGSizeMake(0,0);
        containerview.layer.shadowOpacity = 1;
        containerview.layer.shadowRadius = 1.0;
        containerview.clipsToBounds = false;
        

        mScribbleView = SmoothLineView(frame: containerview.frame)
        mScribbleView.delegate = self
        self.addSubview(mScribbleView);
        mScribbleView.userInteractionEnabled = true
        mScribbleView.setDrawingColor(standard_Red);
        mScribbleView.setBrushWidth(5)
        mScribbleView.setDrawingTool(kBrushTool)
        mScribbleView.hidden = false
        

        
        m_UndoButton.frame = CGRectMake(0, 0, bottomview.frame.size.height, bottomview.frame.size.height)
        m_UndoButton.setImage(UIImage(named:"Undo_Disabled.png"),forState:.Normal);
        bottomview.addSubview(m_UndoButton);
        m_UndoButton.imageView?.contentMode = .ScaleAspectFit
        m_UndoButton.addTarget(self, action: "onUndoButton", forControlEvents: UIControlEvents.TouchUpInside)
        m_UndoButton.enabled = false
        
        bottomtoolSelectedImageView.backgroundColor = UIColor.whiteColor();
        bottomview.addSubview(bottomtoolSelectedImageView);
        bottomtoolSelectedImageView.layer.cornerRadius = 10.0;
        
        
        m_BrushButton.frame = CGRectMake((bottomview.frame.size.width/2) - (bottomview.frame.size.height + 10) ,5, bottomview.frame.size.height ,bottomview.frame.size.height - 10)
        m_BrushButton.setImage(UIImage(named:"Marker_Selected.png"), forState:.Normal)
        bottomview.addSubview(m_BrushButton);
        m_BrushButton.imageView?.contentMode = .ScaleAspectFit
        m_BrushButton.addTarget(self, action: "onBrushButton", forControlEvents: UIControlEvents.TouchUpInside)
        bottomtoolSelectedImageView.frame = m_BrushButton.frame
        
        
        
        
        m_EraserButton.frame = CGRectMake((bottomview.frame.size.width/2) + 10  ,5, bottomview.frame.size.height ,bottomview.frame.size.height - 10)
        m_EraserButton.setImage(UIImage(named:"Eraser_Unselected.png"), forState:.Normal);
        bottomview.addSubview(m_EraserButton);
        m_EraserButton.imageView?.contentMode = .ScaleAspectFit
        m_EraserButton.addTarget(self, action: "onEraserButton", forControlEvents: UIControlEvents.TouchUpInside)
        
        
        m_RedoButton.frame = CGRectMake(bottomview.frame.size.width - bottomview.frame.size.height ,0, bottomview.frame.size.height ,bottomview.frame.size.height)
        m_RedoButton.setImage(UIImage(named:"Redo_Disabled.png"), forState:.Normal);
        bottomview.addSubview(m_RedoButton);
        m_RedoButton.imageView?.contentMode = .ScaleAspectFit
        m_RedoButton.addTarget(self, action: "onRedoButton", forControlEvents: UIControlEvents.TouchUpInside)
        m_RedoButton.enabled = false
        

        
        
        
        
        
    }
    
    
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
        
        
    }
    
    
    
    
    func setStudentDetails(studentDetails:AnyObject, withAnswerDetails answerDetails:AnyObject, withQuestionDetails _currentQuestionDetials:AnyObject )
    {
        
        
        
        
        studentsAswerDictonary = answerDetails
        studentdict = studentDetails
        
        let subViews = containerview.subviews
        
        for subview in subViews
        {
            subview.removeFromSuperview()
        }
        
        
        if let overlayImage = _currentQuestionDetials.objectForKey("Scribble") as? String
        {
            let overlayimageView = UIImageView()
            overlayimageView.frame = containerview.frame
            containerview.addSubview(overlayimageView);

            if overlayImage != ""
            {
                let urlString = NSUserDefaults.standardUserDefaults().objectForKey(k_INI_SCRIBBLE_IMAGE_URL) as! String
                
                if let checkedUrl = NSURL(string: "\(urlString)/\(overlayImage)")
                {
                    overlayimageView.contentMode = .ScaleAspectFit
                    overlayimageView.downloadImage(checkedUrl, withFolderType: folderType.questionImage,withResizeValue: overlayimageView.frame.size)
                }
                overlayimageView.hidden = false
            }
        }
        
        
        if let studentId = studentDetails.objectForKey("StudentId") as? String
        {
            let urlString = NSUserDefaults.standardUserDefaults().objectForKey(k_INI_UserProfileImageURL) as! String
            
            if let checkedUrl = NSURL(string: "\(urlString)/\(studentId)_79px.jpg")
            {
                mStudentImageView.contentMode = .ScaleAspectFit
                mStudentImageView.downloadImage(checkedUrl, withFolderType: folderType.ProFilePics, withResizeValue:mStudentImageView.frame.size)
            }
            
            if let Scribble = answerDetails.objectForKey("Scribble") as? String
            {
                let studentAnswerImage = UIImageView(frame: CGRectMake(0, 0, containerview.frame.size.width, containerview.frame.size.height))
                studentAnswerImage.tag  = Int(studentId)!
                containerview.addSubview(studentAnswerImage)
                
                
                
                let urlString = NSUserDefaults.standardUserDefaults().objectForKey(k_INI_SCRIBBLE_IMAGE_URL) as! String
                
                if let checkedUrl = NSURL(string: "\(urlString)/\(Scribble)")
                {
                    studentAnswerImage.contentMode = .ScaleAspectFit
                    studentAnswerImage.downloadImage(checkedUrl, withFolderType: folderType.StudentAnswer,withResizeValue: studentAnswerImage.frame.size)
                }
            }
            else if let TextAnswer = answerDetails.objectForKey("TextAnswer") as? String
            {
                
                let studentAnswertext = UILabel(frame: CGRectMake(0,0,containerview.frame.size.width,containerview.frame.size.height))
                containerview.addSubview(studentAnswertext)
                studentAnswertext.font = UIFont(name: helveticaRegular, size: 18)
                studentAnswertext.textColor = blackTextColor
                studentAnswertext.lineBreakMode = .ByTruncatingMiddle
                studentAnswertext.numberOfLines = 10
                studentAnswertext.textAlignment = .Center
                studentAnswertext.text = TextAnswer
                studentAnswertext.tag  = Int(studentId)!
                
                
            }

        }
        
        if let StudentName = studentDetails.objectForKey("Name") as? String
        {
            mStudentNameLabel.text = StudentName
        }
        
        
    }
    
    
    
    // MARK: - Buttons function
    
    
    func onCancelButton()
    {
        self.removeFromSuperview()
    }
    
    func onSendButton()
    {
        
        
        
        let currentDate = NSDate()
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-mm-dd HH:mm:ss"
        
        
        
        let currentDateString = dateFormatter.stringFromDate(currentDate)
        
        
        var nameOfImage  = "TT-\(SSTeacherDataSource.sharedDataSource.currentUserId)-\(SSTeacherDataSource.sharedDataSource.currentLiveSessionId)-\(currentDateString)"
        nameOfImage =  nameOfImage.stringByReplacingOccurrencesOfString(" ", withString: "")
        
        sendButtonSpinner.hidden = false
        sendButtonSpinner.startAnimating()
        mSendButton.hidden = true
        
        if (mScribbleView.curImage != nil)
        {
            imageUploading.uploadImageWithImage(mScribbleView.curImage, withImageName: nameOfImage, withUserId: SSTeacherDataSource.sharedDataSource.currentUserId)
        }
        else
        {
            newImageUploadedWithName(nameOfImage)
        }
        
    }

    
    func onTextButton()
    {
        
        selectedtab = "Text"
        
        _ratingsPopoverController.addTextviewwithtext(givenTextReply, withtopviewText:"Rate with Text")
        let navController = UINavigationController(rootViewController: _ratingsPopoverController)
        
        
        
        PopoverControllerRatings = UIPopoverController(contentViewController: navController)
        PopoverControllerRatings.popoverContentSize = CGSizeMake(200,100);
        PopoverControllerRatings.delegate = self;
        navController.navigationBarHidden = true;
        
        
        let buttonPosition :CGPoint = m_textButton.convertPoint(CGPointZero, toView: self)
        
        PopoverControllerRatings.presentPopoverFromRect(CGRectMake(buttonPosition.x + m_textButton.frame.size.width / 2 , topImageView.frame.origin.y + topImageView.frame.size.height , 1, 1), inView: self, permittedArrowDirections: .Up, animated: true)
    }
    
    func onBadgeButton()
    {
        
        selectedtab = "Badge"
        _ratingsPopoverController.addBadgesWithValueValue(givenBadgeId, withtext:"Rate with badge");
        let navController = UINavigationController(rootViewController: _ratingsPopoverController)
        
        
        let buttonPosition :CGPoint = m_badgeButton.convertPoint(CGPointZero, toView: self)
        PopoverControllerRatings = UIPopoverController(contentViewController: navController)
        PopoverControllerRatings.popoverContentSize = CGSizeMake(200,150);
        PopoverControllerRatings.delegate = self;
        navController.navigationBarHidden = true;
        
        PopoverControllerRatings.presentPopoverFromRect(CGRectMake(buttonPosition.x + m_badgeButton.frame.size.width / 2 , topImageView.frame.origin.y + topImageView.frame.size.height , 1, 1), inView: self, permittedArrowDirections: .Up, animated: true)
        
    }
    
    func onModelAnswerButton()
    {
        if isModelAnswerSelected == false
        {
            isModelAnswerSelected = true
            
            
            mMarkModelButton.setImage(UIImage(named:"Mark_Model_Selected.png"), forState:.Normal);
        }
        else
        {
            isModelAnswerSelected = false
            mMarkModelButton.setImage(UIImage(named:"Mark_Model_Not_Selected.png"), forState:.Normal);
        }
    }
    
    
    func onUndoButton()
    {
        mScribbleView.undoButtonClicked()
    }
    
    func onBrushButton()
    {
        
        
        
        if bottomtoolSelectedImageView.frame == m_BrushButton.frame
        {
            
            let buttonPosition :CGPoint = m_BrushButton.convertPoint(CGPointZero, toView: self)
            
            
            let colorSelectContoller = colorpopOverViewController()
            colorSelectContoller.setSelectTab(1);
            colorSelectContoller.setDelegate(self);
            colorSelectContoller.setRect(CGRectMake(0,0,400,400));
            
            
            colorSelectContoller.title = "Brush Size & Colour";
            
            let navController = UINavigationController(rootViewController:colorSelectContoller)
            
            let colorPopoverController = UIPopoverController(contentViewController:navController);
            colorPopoverController.popoverContentSize = CGSizeMake(400, 400);
            colorPopoverController.delegate = self;
            colorSelectContoller.setPopOverController(colorPopoverController);
            
            colorPopoverController.presentPopoverFromRect(CGRectMake(buttonPosition.x  + (m_BrushButton.frame.size.width/2),buttonPosition.y,1,1), inView: self, permittedArrowDirections: .Down, animated: true)
            
        }
        
        bottomtoolSelectedImageView.frame = m_BrushButton.frame
        m_BrushButton.setImage(UIImage(named:"Marker_Selected.png"), forState:.Normal)
        m_EraserButton.setImage(UIImage(named:"Eraser_Unselected.png"), forState:.Normal)
        mScribbleView.setDrawingTool(kBrushTool)
        
        
        
        
        
        
    }
    
    func onEraserButton()
    {
        
        
        if bottomtoolSelectedImageView.frame == m_EraserButton.frame
        {
            
            let buttonPosition :CGPoint = m_EraserButton.convertPoint(CGPointZero, toView: self)
            
            
            let colorSelectContoller = colorpopOverViewController()
            colorSelectContoller.setSelectTab(2);
            colorSelectContoller.setDelegate(self);
            colorSelectContoller.setRect(CGRectMake(0,0,200,200));
            
            
            colorSelectContoller.title = "Eraser Size & Colour";
            
            let navController = UINavigationController(rootViewController:colorSelectContoller)
            
            let colorPopoverController = UIPopoverController(contentViewController:navController);
            colorPopoverController.popoverContentSize = CGSizeMake(200, 150);
            colorPopoverController.delegate = self;
            colorSelectContoller.setPopOverController(colorPopoverController);
            
            colorPopoverController.presentPopoverFromRect(CGRectMake(buttonPosition.x  + (m_EraserButton.frame.size.width/2),buttonPosition.y,1,1), inView: self, permittedArrowDirections: .Down, animated: true)
            
        }
        
        
        
        
        bottomtoolSelectedImageView.frame = m_EraserButton.frame
        m_BrushButton.setImage(UIImage(named:"Marker_Unselected.png"), forState:.Normal)
        m_EraserButton.setImage(UIImage(named:"Eraser_Selected.png"), forState:.Normal)
        
        mScribbleView.setDrawingTool(kEraserTool)
        
        
        
        
        
        
    }
    
    func onRedoButton()
    {
        mScribbleView.redoButtonClicked()
    }
    
    
    
    
    
    
    
    
    // MARK: - popover delegate
    
    func popoverControllerDidDismissPopover(popoverController: UIPopoverController)
    {
        
        if PopoverControllerRatings != nil
        {
            if popoverController == PopoverControllerRatings
            {
                if selectedtab == "Badge"
                {
                    givenBadgeId = _ratingsPopoverController.badgeId()
                    
                    if givenBadgeId > 0
                    {
                        m_badgeButton.setImage(_ratingsPopoverController.getbadgeImageWithId(givenBadgeId), forState:.Normal);
                    }
                    else
                    {
                        m_badgeButton.setImage(UIImage(named:"Cb_Like_Disabled.png"), forState:.Normal);
                    }
                    
                }
                else
                {
                    givenTextReply = _ratingsPopoverController.textViewtext()
                    
                    
                    if (givenTextReply == "")
                    {
                        m_textButton.setImage(UIImage(named:"Text_Unselected.png"), forState:.Normal);
                        
                        
                    }
                    else
                    {
                        m_textButton.setImage(UIImage(named:"Text_Selected.png"), forState:.Normal);
                    }
                    
                    
                }
            }
            if ((givenStarRatings > 0 ) || (givenBadgeId > 0) || givenTextReply != "")
            {
                mSendButton.enabled = true;
                mSendButton.setTitleColor(standard_Button, forState:.Normal);
            }
            else
            {
                mSendButton.enabled = false;
                mSendButton.setTitleColor(UIColor.lightGrayColor(), forState:.Normal);
            }
        }
        
        
        
        
        
        
    }
    
    
    
    
    // MARK: - Smooth line delegate
    
    func setUndoButtonEnable(enable: NSNumber!)
    {
        if enable == 1
        {
            m_UndoButton.setImage(UIImage(named:"Undo_Active.png"),forState:.Normal);
            m_UndoButton.enabled = true
        }
        else
        {
            m_UndoButton.setImage(UIImage(named:"Undo_Disabled.png"),forState:.Normal);
            m_UndoButton.enabled = false
        }
        
    }
    
    func setRedoButtonEnable(enable: NSNumber!)
    {
        if enable == 1
        {
            m_RedoButton.setImage(UIImage(named:"Redo_Active.png"),forState:.Normal);
            m_RedoButton.enabled = true
        }
        else
        {
            m_RedoButton.setImage(UIImage(named:"Redo_Disabled.png"),forState:.Normal);
            m_RedoButton.enabled = false
        }
        
        
    }
    
    func lineDrawnChanged()
    {
        mSendButton.enabled = true;
        mSendButton.setTitleColor(standard_Button, forState:.Normal);
    }
    
    // MARK: - Star view delegate
    
    func starRatingDidChange()
    {
        givenStarRatings = mStarRatingView.rating()
        if givenStarRatings > 0
        {
            mSendButton.enabled = true;
            mSendButton.setTitleColor(standard_Button, forState:.Normal);
        }
        
        
    }
    
    
    // MARK: - image Uploadeding delegate
    
    func newImageUploadedWithName(imageName:String)
    {
        if let studentId = studentdict.objectForKey("StudentId") as? String
        {
            
            if let AssessmentAnswerId = studentsAswerDictonary.objectForKey("AssessmentAnswerId") as? String
            {
                
                let feedBackDetails  = NSMutableDictionary()
                feedBackDetails.setObject(studentId, forKey: "StudentId")
                
                feedBackDetails.setObject(AssessmentAnswerId, forKey: "AssessmentAnswerId")
                
                feedBackDetails.setObject("\(givenStarRatings)", forKey: "Rating")
                
                feedBackDetails.setObject("upload/\(imageName)", forKey: "imageUrl")
                
                feedBackDetails.setObject("\(givenBadgeId)", forKey: "BadgeId")
                
                feedBackDetails.setObject("\(givenTextReply)", forKey: "textRating")
                
                feedBackDetails.setObject("\(isModelAnswerSelected)", forKey: "ModelAnswerFlag")
                
                SSTeacherDataSource.sharedDataSource.sendFeedbackToStudentWithDetails(feedBackDetails, WithDelegate: self)
                
            }
            
        }
        
    }
    
    func didGetFeedbackSentWithDetails(details: AnyObject)
    {
        
        
        
        
        if let studentId = details.objectForKey("Students")!.objectForKey("Student")!.objectForKey("StudentId") as? String
        {
            if let AssessmentAnswerId = details.objectForKey("AssessmentAnswerId") as? String
            {
                SSTeacherMessageHandler.sharedMessageHandler.sendFeedbackToStudentWitId(studentId, withassesmentAnswerId: AssessmentAnswerId)
                
                
                
                let feedBackDetails = NSMutableDictionary()
                
                feedBackDetails.setObject(studentId, forKey: "StudentId")
                
                feedBackDetails.setObject(AssessmentAnswerId, forKey: "AssessmentAnswerId")
                
                feedBackDetails.setObject("\(givenStarRatings)", forKey: "Rating")
                
                feedBackDetails.setObject("upload/\(currentTeacherImageURl).png", forKey: "imageUrl")
                
                feedBackDetails.setObject("\(givenBadgeId)", forKey: "BadgeId")
                
                feedBackDetails.setObject("\(givenTextReply)", forKey: "textRating")
                
                feedBackDetails.setObject("\(isModelAnswerSelected)", forKey: "ModelAnswerFlag")

                
                
                if delegate().respondsToSelector(Selector("delegateSubmissionEvalauatedWithAnswerDetails:withEvaluationDetail:withStudentId:"))
                {
                     delegate().delegateSubmissionEvalauatedWithAnswerDetails!(studentsAswerDictonary, withEvaluationDetail: feedBackDetails, withStudentId: studentId)
                }
 
            }
        }
        
        
        
        
        
        sendButtonSpinner.hidden = true
        sendButtonSpinner.stopAnimating()
        mSendButton.hidden = false
        mScribbleView.clearButtonClicked()
        self.removeFromSuperview()
    }
    
    
    
    // MARK: - ImageUploading delegate
    
    func ImageUploadedWithName(name: String!)
    {
        newImageUploadedWithName(name)
        currentTeacherImageURl = name
    }
    
    func ErrorInUploadingWithName(name: String!)
    {
        sendButtonSpinner.hidden = true
        sendButtonSpinner.stopAnimating()
        mSendButton.hidden = false
        mScribbleView.clearButtonClicked()
        currentTeacherImageURl = ""
    }

    
    
    // MARK: - Color popover delegate
    
    func selectedbrushSize(sender: AnyObject!, withSelectedTab tabTag: Int32)
    {
        
        if let progressView = sender as? UISlider
        {
            mScribbleView.setBrushWidth(Int32(progressView.value));
        }
        
        
    }
    
    func selectedColor(sender: AnyObject!, withSelectedTab tabTag: Int32)
    {
        if let progressColor = sender as? UIColor
        {
            mScribbleView.setDrawingColor(progressColor);
        }
    }

    
}