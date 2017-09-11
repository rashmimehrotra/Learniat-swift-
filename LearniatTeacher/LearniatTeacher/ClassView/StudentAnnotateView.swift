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
    
    
    @objc optional func delegateSubmissionEvalauatedWithAnswerDetails(_ answerDetails:AnyObject,withEvaluationDetail evaluation:AnyObject, withStudentId studentId:String)
    
    
}



class StudentAnnotateView: UIView,UIPopoverControllerDelegate,SSTeacherDataSourceDelegate, KMZDrawViewDelegate
{
    var _delgate: AnyObject!
    
    var topImageView = UIImageView()
    
    let mStudentImageView = CustomProgressImageView()
    
    let  mProgressView = YLProgressBar()

    let mStudentNameLabel = UILabel()
    
    let containerview = UIView()
    
    // By Ujjval
    // ==========================================
    
//    var mScribbleView : SmoothLineView!
    
    // ==========================================
    
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
    
    var selectedtab    = ""
    
    var currentTeacherImageURl = ""
    
    let mSendButton = UIButton()
    
    let mCancelButton = UIButton()
    
     let imageUploading = ImageUploading()
    
    let _ratingsPopoverController = RatingsPopOverViewController()
    
    var isModelAnswerSelected     = false
    
    let kUplodingServer     = "http://54.251.104.13/Jupiter/upload_photos.php"
    
    
    var sendButtonSpinner : UIActivityIndicatorView!
    
    // By Ujjval
    // Create view for draw
    // ==========================================
    
    var mScribbleView : KMZDrawView!
    let colorSelectContoller = colorpopOverViewController()
    
    // ==========================================
    
    
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
        
        imageUploading.setDelegate(self)
        
        let  mTopbarImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: self.frame.size.width, height: 70))
        mTopbarImageView.backgroundColor = topbarColor
        self.addSubview(mTopbarImageView)
        mTopbarImageView.isUserInteractionEnabled = true
        
        
        
        let bottomview = UIImageView(frame: CGRect(x: 0, y: self.frame.size.height - 60, width: self.frame.size.width, height: 60))
        bottomview.backgroundColor = topbarColor
        self.addSubview(bottomview)
        bottomview.isUserInteractionEnabled = true
        
        
        mCancelButton.showsTouchWhenHighlighted = true;
        /* Add Cancel button target Cancel button should deselect all the selected submissions *defect 142 */
        mCancelButton.frame = CGRect(x: 10 , y: 0, width: 100,  height: mTopbarImageView.frame.size.height);
        mTopbarImageView.addSubview(mCancelButton);
        mCancelButton.setTitle("Cancel", for:UIControlState());
        mCancelButton.setTitleColor(UIColor.white, for:UIControlState());
        mCancelButton.titleLabel?.font = UIFont(name: helveticaMedium, size: 20);
        mCancelButton.contentHorizontalAlignment = UIControlContentHorizontalAlignment.left
        mCancelButton.addTarget(self, action: #selector(StudentAnnotateView.onCancelButton), for: UIControlEvents.touchUpInside)
        
        
        mSendButton.frame = CGRect(x: mTopbarImageView.frame.size.width - 100 , y: 0, width: 100 , height: mTopbarImageView.frame.size.height );
        mTopbarImageView.addSubview(mSendButton);
        mSendButton.setTitle("Send", for:UIControlState());
        mSendButton.setTitleColor(UIColor.lightGray, for:UIControlState());
        mSendButton.titleLabel?.font = UIFont(name: helveticaMedium, size: 20);
        mSendButton.isEnabled = false
        mSendButton.isHighlighted = false;
        mSendButton.contentHorizontalAlignment = UIControlContentHorizontalAlignment.center
        mSendButton.addTarget(self, action: #selector(StudentAnnotateView.onSendButton), for: UIControlEvents.touchUpInside)
        
        
        sendButtonSpinner = UIActivityIndicatorView(activityIndicatorStyle:.whiteLarge);
        sendButtonSpinner.frame = mSendButton.frame;
        mTopbarImageView.addSubview(sendButtonSpinner);
        sendButtonSpinner.isHidden = true;
        


        
        
        
        topImageView.frame = CGRect(x: 0,y: mTopbarImageView.frame.size.height, width: mTopbarImageView.frame.size.width, height: 54)
        topImageView.backgroundColor = UIColor.white
        self.addSubview (topImageView);
        topImageView.layer.shadowColor = progressviewBackground.cgColor;
        topImageView.layer.shadowOffset = CGSize(width: 1, height: 1);
        topImageView.layer.shadowOpacity = 1;
        topImageView.layer.shadowRadius = 1.0;
        topImageView.clipsToBounds = false;
        topImageView.isUserInteractionEnabled = true
        
        
        
        
        m_textButton.frame = CGRect(x: topImageView.frame.size.width - 50, y: 10, width: 40, height: topImageView.frame.size.height - 20);
        //        [m_textButton addTarget:self action:@selector(onTextReplyButton:) forControlEvents:UIControlEventTouchUpInside];
        topImageView.addSubview(m_textButton);
        m_textButton.imageView?.contentMode = .scaleAspectFit
        m_textButton.setImage(UIImage(named:"Text_Unselected.png"), for:UIControlState());
        m_textButton.addTarget(self, action: #selector(StudentAnnotateView.onTextButton), for: UIControlEvents.touchUpInside)
        
        
        
        
        let lineImage1 = UIImageView(frame:CGRect(x: m_textButton.frame.origin.x - 10 , y: 5, width: 1, height: topImageView.frame.size.height - 10));
        lineImage1.backgroundColor = progressviewBackground
        topImageView.addSubview(lineImage1);
        
        
        m_badgeButton.frame = CGRect(x: lineImage1.frame.origin.x - 50, y: 10, width: 40, height: topImageView.frame.size.height - 20);
        //        [m_badgeButton addTarget:self action:@selector(onBadgeButton:) forControlEvents:UIControlEventTouchUpInside];
        topImageView.addSubview(m_badgeButton);
        m_badgeButton.imageView?.contentMode = .scaleAspectFit
        m_badgeButton.setImage(UIImage(named:"Cb_Like_Disabled.png"), for:UIControlState());
        m_badgeButton.addTarget(self, action: #selector(StudentAnnotateView.onBadgeButton), for: UIControlEvents.touchUpInside)
        
        
        let lineImage2 = UIImageView(frame:CGRect(x: m_badgeButton.frame.origin.x - 10, y: 5, width: 1, height: topImageView.frame.size.height - 10));
        lineImage2.backgroundColor = progressviewBackground
        topImageView.addSubview(lineImage2);
        
        
        mStarRatingView.backgroundColor = UIColor.clear;
        mStarRatingView.frame = CGRect(x: lineImage2.frame.origin.x - 190, y: 10, width: 180, height: topImageView.frame.size.height - 20);
        mStarRatingView.setDelegate(self);
        topImageView.addSubview(mStarRatingView);
        mStarRatingView.setsize(ofStar: 30);
        
        
        let  mMarkModelButtonlineImage = UIImageView(frame: CGRect(x: mStarRatingView.frame.origin.x - 10, y: 5, width: 1, height: topImageView.frame.size.height - 10));
        mMarkModelButtonlineImage.backgroundColor = progressviewBackground
        topImageView.addSubview(mMarkModelButtonlineImage);
        
        
        
        mMarkModelButton.frame = CGRect(x: mMarkModelButtonlineImage.frame.origin.x - 160, y: 0, width: 150, height: topImageView.frame.size.height);
        topImageView.addSubview(mMarkModelButton);
        mMarkModelButton.setImage(UIImage(named:"Mark_Model_Not_Selected.png"), for:UIControlState());
        mMarkModelButton.setTitle("  Mark Model", for:UIControlState());
        mMarkModelButton.setTitleColor(blackTextColor, for:UIControlState())
        mMarkModelButton.titleLabel?.font = UIFont(name: helveticaMedium, size: 20);
        mMarkModelButton.addTarget(self, action: #selector(StudentAnnotateView.onModelAnswerButton), for: UIControlEvents.touchUpInside)
        
        
        
        
        mStudentImageView.frame = CGRect(x: 10 , y: 7, width: 40, height: 40)
        topImageView.addSubview(mStudentImageView);
        
        
        mStudentNameLabel.frame = CGRect(x: mStudentImageView.frame.origin.x + mStudentImageView.frame.size.width + 10  ,y: mStudentImageView.frame.origin.y , width: 200 ,height: mStudentImageView.frame.size.height)
        mStudentNameLabel.text = ""
        mStudentNameLabel.font = UIFont(name: helveticaMedium, size: 14);
        mStudentNameLabel.textAlignment = .left;
        mStudentNameLabel.textColor = blackTextColor
        topImageView.addSubview(mStudentNameLabel);
        

        
        
        var contanerHeight  = topImageView.frame.origin.y + topImageView.frame.size.height + bottomview.frame.size.height + 20
        contanerHeight = self.frame.size.height - contanerHeight
        
        containerview.frame = CGRect(x: (self.frame.size.width - (contanerHeight * kAspectRation)) / 2 , y: topImageView.frame.origin.y + topImageView.frame.size.height + 10 ,  width: contanerHeight * kAspectRation ,height: contanerHeight)
        containerview.backgroundColor = UIColor.white
        self.addSubview(containerview);
        containerview.layer.shadowColor = progressviewBackground.cgColor;
        containerview.layer.shadowOffset = CGSize(width: 0,height: 0);
        containerview.layer.shadowOpacity = 1;
        containerview.layer.shadowRadius = 1.0;
        containerview.clipsToBounds = false;
        

        // By Ujjval
        // Assign frame and set other properties to draw view
        // ==========================================
        
        //        mScribbleView = SmoothLineView(frame: containerview.frame)
        //        mScribbleView.delegate = self
        //        self.addSubview(mScribbleView);
        //        mScribbleView.isUserInteractionEnabled = true
        //        mScribbleView.setDrawing(standard_Red);
        //        mScribbleView.setBrushWidth(5)
        //        mScribbleView.setDrawing(kBrushTool)
        //        var brushSize = UserDefaults.standard.float(forKey: "selectedBrushsize")
        //        if brushSize < 5
        //        {
        //            brushSize = 5
        //        }
        //        mScribbleView.setBrushWidth(Int32(brushSize))
        //        mScribbleView.isHidden = false
        
        
        mScribbleView = KMZDrawView(frame: containerview.frame)
        self.addSubview(mScribbleView)
        mScribbleView.isUserInteractionEnabled = true
        mScribbleView.delegate = self
        if let colorIndex = UserDefaults.standard.value(forKey: "selectedBrushColor") as? Int {
            mScribbleView.penColor = colorSelectContoller.colorArray.object(at: colorIndex - 1) as! UIColor
        }
        else {
            mScribbleView.penColor = blackTextColor
        }
        mScribbleView.penMode = .pencil
        var brushSize = UserDefaults.standard.float(forKey: "selectedBrushsize")
        if brushSize < 5
        {
            brushSize = 5
        }
        mScribbleView.penWidth = UInt(brushSize)
        mScribbleView.isHidden = false
        
        // ==========================================
        

        
        m_UndoButton.frame = CGRect(x: 0, y: 0, width: bottomview.frame.size.height, height: bottomview.frame.size.height)
        m_UndoButton.setImage(UIImage(named:"Undo_Disabled.png"),for:UIControlState());
        bottomview.addSubview(m_UndoButton);
        m_UndoButton.imageView?.contentMode = .scaleAspectFit
        m_UndoButton.addTarget(self, action: #selector(StudentAnnotateView.onUndoButton), for: UIControlEvents.touchUpInside)
        m_UndoButton.isEnabled = false
        
        bottomtoolSelectedImageView.backgroundColor = UIColor.white;
        bottomview.addSubview(bottomtoolSelectedImageView);
        bottomtoolSelectedImageView.layer.cornerRadius = 10.0;
        
        
        m_BrushButton.frame = CGRect(x: (bottomview.frame.size.width/2) - (bottomview.frame.size.height + 10) ,y: 5, width: bottomview.frame.size.height ,height: bottomview.frame.size.height - 10)
        m_BrushButton.setImage(UIImage(named:"Marker_Selected.png"), for:UIControlState())
        bottomview.addSubview(m_BrushButton);
        m_BrushButton.imageView?.contentMode = .scaleAspectFit
        m_BrushButton.addTarget(self, action: #selector(StudentAnnotateView.onBrushButton), for: UIControlEvents.touchUpInside)
        bottomtoolSelectedImageView.frame = m_BrushButton.frame
        
        
        
        
        m_EraserButton.frame = CGRect(x: (bottomview.frame.size.width/2) + 10  ,y: 5, width: bottomview.frame.size.height ,height: bottomview.frame.size.height - 10)
        m_EraserButton.setImage(UIImage(named:"Eraser_Unselected.png"), for:UIControlState());
        bottomview.addSubview(m_EraserButton);
        m_EraserButton.imageView?.contentMode = .scaleAspectFit
        m_EraserButton.addTarget(self, action: #selector(StudentAnnotateView.onEraserButton), for: UIControlEvents.touchUpInside)
        
        
        m_RedoButton.frame = CGRect(x: bottomview.frame.size.width - bottomview.frame.size.height ,y: 0, width: bottomview.frame.size.height ,height: bottomview.frame.size.height)
        m_RedoButton.setImage(UIImage(named:"Redo_Disabled.png"), for:UIControlState());
        bottomview.addSubview(m_RedoButton);
        m_RedoButton.imageView?.contentMode = .scaleAspectFit
        m_RedoButton.addTarget(self, action: #selector(StudentAnnotateView.onRedoButton), for: UIControlEvents.touchUpInside)
        m_RedoButton.isEnabled = false
        

        
        
        
        
        
    }
    
    
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
        
        
    }
    
    
    
    
    func setStudentDetails(_ studentDetails:AnyObject, withAnswerDetails answerDetails:AnyObject, withQuestionDetails _currentQuestionDetials:AnyObject ,withStarRatings ratings:Int, withModelAnswer modelAnswer:Bool)
    {
        
        
        
        
        studentsAswerDictonary = answerDetails
        studentdict = studentDetails
        
        let subViews = containerview.subviews
        
        for subview in subViews
        {
            subview.removeFromSuperview()
        }
        
        
        if let overlayImage = _currentQuestionDetials.object(forKey: "Scribble") as? String
        {
            let overlayimageView = CustomProgressImageView()
            overlayimageView.frame = CGRect(x: 0, y: 0, width: containerview.frame.size.width, height: containerview.frame.size.height)
            containerview.addSubview(overlayimageView);

            if overlayImage != ""
            {
                let urlString = UserDefaults.standard.object(forKey: k_INI_SCRIBBLE_IMAGE_URL) as! String
                
                if let checkedUrl = URL(string: "\(urlString)/\(overlayImage)")
                {
                    overlayimageView.contentMode = .scaleAspectFit
                    overlayimageView.downloadImage(checkedUrl, withFolderType: folderType.questionImage,withResizeValue: overlayimageView.frame.size)
                }
                overlayimageView.isHidden = false
            }
        }
        
        
        if let studentId = studentDetails.object(forKey: "StudentId") as? String
        {
            let urlString = UserDefaults.standard.object(forKey: k_INI_UserProfileImageURL) as! String
            
            if let checkedUrl = URL(string: "\(urlString)/\(studentId)_79px.jpg")
            {
                mStudentImageView.contentMode = .scaleAspectFit
                mStudentImageView.downloadImage(checkedUrl, withFolderType: folderType.proFilePics, withResizeValue:mStudentImageView.frame.size)
            }
            
            if let Scribble = answerDetails.object(forKey: "Scribble") as? String
            {
                let studentAnswerImage = CustomProgressImageView(frame: CGRect(x: 0, y: 0, width: containerview.frame.size.width, height: containerview.frame.size.height))
                studentAnswerImage.tag  = Int(studentId)!
                containerview.addSubview(studentAnswerImage)
                
                
                
                let urlString = UserDefaults.standard.object(forKey: k_INI_SCRIBBLE_IMAGE_URL) as! String
                
                if let checkedUrl = URL(string: "\(urlString)/\(Scribble)")
                {
                    studentAnswerImage.contentMode = .scaleAspectFit
                    studentAnswerImage.downloadImage(checkedUrl, withFolderType: folderType.studentAnswer,withResizeValue: studentAnswerImage.frame.size)
                }
            }
            else if let TextAnswer = answerDetails.object(forKey: "TextAnswer") as? String
            {
                
                let studentAnswertext = UILabel(frame: CGRect(x: 0,y: 0,width: containerview.frame.size.width,height: containerview.frame.size.height))
                containerview.addSubview(studentAnswertext)
                studentAnswertext.font = UIFont(name: helveticaRegular, size: 18)
                studentAnswertext.textColor = blackTextColor
                studentAnswertext.lineBreakMode = .byTruncatingMiddle
                studentAnswertext.numberOfLines = 10
                studentAnswertext.textAlignment = .center
                studentAnswertext.text = TextAnswer
                studentAnswertext.tag  = Int(studentId)!
                
                
            }
            
            
            mStarRatingView.setStarRating(ratings)
            
            isModelAnswerSelected = modelAnswer
            
            
            if isModelAnswerSelected == false
            {
                
                mMarkModelButton.setImage(UIImage(named:"Mark_Model_Not_Selected.png"), for:UIControlState());
            }
            else
            {
                mMarkModelButton.setImage(UIImage(named:"Mark_Model_Selected.png"), for:UIControlState());
                
            }
            

        }
        
        if let StudentName = studentDetails.object(forKey: "Name") as? String
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
        
        
        
        let currentDate = Date()
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-mm-dd HH:mm:ss"
        
        
        
        let currentDateString = dateFormatter.string(from: currentDate)
       
        let imagePathString = SSTeacherDataSource.sharedDataSource.currentUserId.appending("-").appending(SSTeacherDataSource.sharedDataSource.currentLiveSessionId).appending("-").appending(currentDateString)
        
        var nameOfImage  = "TT-".appending(imagePathString)
        nameOfImage =  nameOfImage.replacingOccurrences(of: " ", with: "")
        
        sendButtonSpinner.isHidden = false
        sendButtonSpinner.startAnimating()
        mSendButton.isHidden = true
        
        // By Ujjval
        // Check image available or not to post on server
        // ==========================================
        
//        if (mScribbleView.curImage != nil)
        if (mScribbleView.image != nil)
        {
//            imageUploading.uploadImage(with: mScribbleView.curImage, withImageName: nameOfImage, withUserId: SSTeacherDataSource.sharedDataSource.currentUserId)
            
            imageUploading.uploadImage(with: mScribbleView.image!, withImageName: nameOfImage, withUserId: SSTeacherDataSource.sharedDataSource.currentUserId)
            
            // ==========================================
        }
        else
        {
            newImageUploadedWithName(nameOfImage)
        }
        
    }

    
    func onTextButton()
    {
        
        selectedtab = kText
        
        _ratingsPopoverController.addTextviewwithtext(givenTextReply, withtopviewText:"Rate with Text")
        let navController = UINavigationController(rootViewController: _ratingsPopoverController)
        
        
        
        SSTeacherDataSource.sharedDataSource.mPopOverController = UIPopoverController(contentViewController: navController)
        SSTeacherDataSource.sharedDataSource.mPopOverController.contentSize = CGSize(width: 200,height: 100);
        SSTeacherDataSource.sharedDataSource.mPopOverController.delegate = self;
        navController.isNavigationBarHidden = true;
        
        
        let buttonPosition :CGPoint = m_textButton.convert(CGPoint.zero, to: self)
        
        SSTeacherDataSource.sharedDataSource.mPopOverController.present(from: CGRect(x: buttonPosition.x + m_textButton.frame.size.width / 2 , y: topImageView.frame.origin.y + topImageView.frame.size.height , width: 1, height: 1), in: self, permittedArrowDirections: .up, animated: true)
    }
    
    func onBadgeButton()
    {
        
        selectedtab = "Badge"
        _ratingsPopoverController.addBadges(withValueValue: givenBadgeId, withtext:"Rate with badge");
        let navController = UINavigationController(rootViewController: _ratingsPopoverController)
        
        
        let buttonPosition :CGPoint = m_badgeButton.convert(CGPoint.zero, to: self)
        SSTeacherDataSource.sharedDataSource.mPopOverController = UIPopoverController(contentViewController: navController)
        SSTeacherDataSource.sharedDataSource.mPopOverController.contentSize = CGSize(width: 200,height: 150);
        SSTeacherDataSource.sharedDataSource.mPopOverController.delegate = self;
        navController.isNavigationBarHidden = true;
        
        SSTeacherDataSource.sharedDataSource.mPopOverController.present(from: CGRect(x: buttonPosition.x + m_badgeButton.frame.size.width / 2 , y: topImageView.frame.origin.y + topImageView.frame.size.height , width: 1, height: 1), in: self, permittedArrowDirections: .up, animated: true)
        
    }
    
    func onModelAnswerButton()
    {
        if isModelAnswerSelected == false
        {
            isModelAnswerSelected = true
            
            
            mMarkModelButton.setImage(UIImage(named:"Mark_Model_Selected.png"), for:UIControlState());
        }
        else
        {
            isModelAnswerSelected = false
            mMarkModelButton.setImage(UIImage(named:"Mark_Model_Not_Selected.png"), for:UIControlState());
        }
    }
    
    
    func onUndoButton()
    {
        // By Ujjval
        // Undo drawn image
        // ==========================================
        
//        mScribbleView.undoButtonClicked()
        mScribbleView.undo()
        
        // ==========================================
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
        
        
        // By Ujjval
        // Assign updated brush size
        // ==========================================
        
//        mScribbleView.setDrawing(kBrushTool)
        var brushSize = UserDefaults.standard.float(forKey: "selectedBrushsize")
        if brushSize < 5
        {
            brushSize = 5
        }
//        mScribbleView.setBrushWidth(Int32(brushSize))
        
        
        mScribbleView.penMode = .pencil
        mScribbleView.penWidth = UInt(brushSize)
        
        // ==========================================
        
        
        
        
        
        
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
        
        
        // By Ujjval
        // Assign updated eraser size
        // ==========================================
        
//        mScribbleView.setDrawing(kEraserTool)
        let eraserSize = UserDefaults.standard.float(forKey: "selectedEraserSize")
//        mScribbleView.setBrushWidth(Int32(eraserSize))
        
        mScribbleView.penMode = .eraser
        mScribbleView.penWidth = UInt(eraserSize)
        
        // ==========================================
        
        
        
        
    }
    
    func onRedoButton()
    {
        // By Ujjval
        // Redo drawn image
        // ==========================================
        
//        mScribbleView.redoButtonClicked()
        mScribbleView.redo()
        
        // ==========================================
    }
    
    
    
    
    
    
    
    
    // MARK: - popover delegate
    
    func popoverControllerDidDismissPopover(_ popoverController: UIPopoverController)
    {
        
        if SSTeacherDataSource.sharedDataSource.mPopOverController != nil
        {
            if popoverController == SSTeacherDataSource.sharedDataSource.mPopOverController
            {
                if selectedtab == "Badge"
                {
                    givenBadgeId = _ratingsPopoverController.badgeId()
                    
                    if givenBadgeId > 0
                    {
                        m_badgeButton.setImage(_ratingsPopoverController.getbadgeImage(withId: givenBadgeId), for:UIControlState());
                    }
                    else
                    {
                        m_badgeButton.setImage(UIImage(named:"Cb_Like_Disabled.png"), for:UIControlState());
                    }
                    
                }
                else
                {
                    givenTextReply = _ratingsPopoverController.textViewtext()
                    
                    
                    if (givenTextReply == "")
                    {
                        m_textButton.setImage(UIImage(named:"Text_Unselected.png"), for:UIControlState());
                        
                        
                    }
                    else
                    {
                        m_textButton.setImage(UIImage(named:"Text_Selected.png"), for:UIControlState());
                    }
                    
                    
                }
            }
            if ((givenStarRatings > 0 ) || (givenBadgeId > 0) || givenTextReply != "")
            {
                mSendButton.isEnabled = true;
                mSendButton.setTitleColor(whiteColor, for:UIControlState());
            }
            else
            {
                mSendButton.isEnabled = false;
                mSendButton.setTitleColor(UIColor.lightGray, for:UIControlState());
            }
        }
        
        
        
        
        
        
    }
    
    
    // By Ujjval
    // Enable or disable Undo & Redo buttons
    // ==========================================
    
    // MARK: - KMZDrawViewDelegate
    
    func drawView(_ drawView: KMZDrawView!, finishDraw line: KMZLine!) {
        
        if mScribbleView.isUndoable() {
            m_UndoButton.setImage(UIImage(named:"Undo_Active.png"),for:UIControlState());
            m_UndoButton.isEnabled = true
            lineDrawnChanged()
        }
        else {
            m_UndoButton.setImage(UIImage(named:"Undo_Disabled.png"),for:UIControlState());
            m_UndoButton.isEnabled = false
        }
        
        if mScribbleView.isRedoable() {
            m_RedoButton.setImage(UIImage(named:"Redo_Active.png"),for:UIControlState());
            m_RedoButton.isEnabled = true
            lineDrawnChanged()
        }
        else {
            m_RedoButton.setImage(UIImage(named:"Redo_Disabled.png"),for:UIControlState());
            m_RedoButton.isEnabled = false
        }
    }
    
    // ==========================================
    
    
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
        mSendButton.isEnabled = true;
        mSendButton.setTitleColor(whiteColor, for:UIControlState());
    }
    
    // MARK: - Star view delegate
    
    func starRatingDidChange()
    {
        givenStarRatings = mStarRatingView.rating()
        if givenStarRatings > 0
        {
            mSendButton.isEnabled = true;
            mSendButton.setTitleColor(whiteColor, for:UIControlState());
        }
        
        
    }
    
    
    // MARK: - image Uploadeding delegate
    
    func newImageUploadedWithName(_ imageName:String)
    {
        if let studentId = studentdict.object(forKey: "StudentId") as? String
        {
            
            if let AssessmentAnswerId = studentsAswerDictonary.object(forKey: "AssessmentAnswerId") as? String
            {
                
                let feedBackDetails  = NSMutableDictionary()
                feedBackDetails.setObject(studentId, forKey: "StudentId" as NSCopying)
                
                feedBackDetails.setObject(AssessmentAnswerId, forKey: "AssessmentAnswerId" as NSCopying)
                
                feedBackDetails.setObject("\(givenStarRatings)", forKey: "Rating" as NSCopying)
                
                feedBackDetails.setObject("upload/".appending(imageName), forKey: "imageUrl" as NSCopying)
                
                feedBackDetails.setObject("\(givenBadgeId)", forKey: "BadgeId" as NSCopying)
                
                feedBackDetails.setObject("\(givenTextReply)", forKey: "textRating" as NSCopying)
                
                feedBackDetails.setObject("\(isModelAnswerSelected)", forKey: "ModelAnswerFlag" as NSCopying)
                
                SSTeacherDataSource.sharedDataSource.sendFeedbackToStudentWithDetails(feedBackDetails, WithDelegate: self)
                
            }
            
        }
        
    }
    
    func didGetFeedbackSentWithDetails(_ details: AnyObject)
    {
        
        
        
        
        if let studentId = ((details.object(forKey: "Students")! as AnyObject).object(forKey: "Student")! as AnyObject).object(forKey: "StudentId") as? String
        {
            if let AssessmentAnswerId = details.object(forKey: "AssessmentAnswerId") as? String
            {
                SSTeacherMessageHandler.sharedMessageHandler.sendFeedbackToStudentWitId(studentId, withassesmentAnswerId: AssessmentAnswerId)
                
                
                
                let feedBackDetails = NSMutableDictionary()
                
                feedBackDetails.setObject(studentId, forKey: "StudentId" as NSCopying)
                
                feedBackDetails.setObject(AssessmentAnswerId, forKey: "AssessmentAnswerId" as NSCopying)
                
                feedBackDetails.setObject("\(givenStarRatings)", forKey: "Rating" as NSCopying)
                
                feedBackDetails.setObject("upload/".appending(currentTeacherImageURl).appending(".png"), forKey: "imageUrl" as NSCopying)
                
                feedBackDetails.setObject("\(givenBadgeId)", forKey: "BadgeId" as NSCopying)
                
                feedBackDetails.setObject("\(givenTextReply)", forKey: "textRating" as NSCopying)
                
                feedBackDetails.setObject("\(isModelAnswerSelected)", forKey: "ModelAnswerFlag" as NSCopying)

                
                
                if delegate().responds(to: #selector(StudentAnnotateViewDelegate.delegateSubmissionEvalauatedWithAnswerDetails(_:withEvaluationDetail:withStudentId:)))
                {
                     delegate().delegateSubmissionEvalauatedWithAnswerDetails!(studentsAswerDictonary, withEvaluationDetail: feedBackDetails, withStudentId: studentId)
                }
 
            }
        }
        
        
        
        
        
        sendButtonSpinner.isHidden = true
        sendButtonSpinner.stopAnimating()
        mSendButton.isHidden = false
        
        // By Ujjval
        // Clear image
        // ==========================================
        
//        mScribbleView.clearButtonClicked()
        self.mScribbleView.clear()
        
        // ==========================================
        
        self.removeFromSuperview()
    }
    
    
    
    // MARK: - ImageUploading delegate
    
    func ImageUploadedWithName(_ name: String!)
    {
        SSTeacherDataSource.sharedDataSource.InsertScribbleFileName(Scribblename: name, withSuccessHandle: { (details) in
            self.newImageUploadedWithName(name)
             self.currentTeacherImageURl = name
        }) { (error) in
            
            self.sendButtonSpinner.isHidden = true
            self.sendButtonSpinner.stopAnimating()
            self.mSendButton.isHidden = false
            
            // By Ujjval
            // Clear image
            // ==========================================
            
//            self.mScribbleView.clearButtonClicked()
            self.mScribbleView.clear()
            
            // ==========================================
            
            self.currentTeacherImageURl = ""
        }
        
        
        
       
    }
    
    func ErrorInUploadingWithName(_ name: String!)
    {
        sendButtonSpinner.isHidden = true
        sendButtonSpinner.stopAnimating()
        mSendButton.isHidden = false
        
        // By Ujjval
        // Clear image
        // ==========================================
        
//        self.mScribbleView.clearButtonClicked()
        self.mScribbleView.clear()
        
        // ==========================================
        
        currentTeacherImageURl = ""
    }

    
    
    // MARK: - Color popover delegate
    
    func selectedbrushSize(_ sender: AnyObject!, withSelectedTab tabTag: Int32)
    {
        
        if let progressView = sender as? UISlider
        {
            // By Ujjval
            // Assign updated Brush size
            // ==========================================
            
//            mScribbleView.setBrushWidth(Int32(progressView.value));
            mScribbleView.penWidth = UInt(progressView.value)
            
            // ==========================================
        }
        
        
    }
    
    func selectedColor(_ sender: AnyObject!, withSelectedTab tabTag: Int32)
    {
        if let progressColor = sender as? UIColor
        {
            // By Ujjval
            // Assign updated Brush color
            // ==========================================
            
//            mScribbleView.setDrawing(progressColor);
            mScribbleView.penColor = progressColor
            
            // ==========================================
        }
    }

    
}
