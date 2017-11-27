//
//  SubmissionSubjectiveView.swift
//  LearniatTeacher
//
//  Created by Deepak MK on 07/04/16.
//  Copyright © 2016 Mindshift. All rights reserved.
//

import Foundation

let kAspectRation:CGFloat = 1.5



@objc protocol SubmissionSubjectiveViewDelegate
{
    
    
    @objc optional func delegateStudentSubmissionEvaluatedWithDetails(_ evaluationDetails:AnyObject, withStudentId studentId:String , withSubmissionCount SubmissionCount:Int)
    
    
    
}



class SubmissionSubjectiveView: UIView,SmoothLineViewdelegate, SubjectiveLeftSideViewDelegate,SSStarRatingViewDelegate,UIPopoverControllerDelegate,SSTeacherDataSourceDelegate,ImageUploadingDelegate,colorpopOverViewControllerDelegate, KMZDrawViewDelegate
{
    

    var _delgate: AnyObject!
    
    var _currentQuestionDetials:AnyObject!
    
    var subjectiveCellContainer :SubjectiveLeftSideView!
    
    let imageUploading = ImageUploading()
    
    func setdelegate(_ delegate:AnyObject)
    {
        _delgate = delegate;
    }
    
    func   delegate()->AnyObject
    {
        return _delgate;
    }
    
    
    
    var mainContainerView = UIView()
    
    let topImageView = UIImageView()
    
    let mCancelButton = UIButton()
    
    let mMarkModelButton = UIButton()
    
    let mStarRatingView = SSStarRatingView()
    
    let mSendButton = UIButton()
    
    let containerview = UIView()
    
    let overlayimageView = CustomProgressImageView()
    
    // By Ujjval
    // ==========================================
    
//    var mScribbleView : SmoothLineView!
    
    // ==========================================
    
    let studentsAswerDictonary      = NSMutableDictionary()
    
    
    let bottomview = UIView()
    
    let m_UndoButton = UIButton()
    
    let bottomtoolSelectedImageView = UIImageView()
    
    let m_BrushButton = UIButton()
    
    let m_EraserButton = UIButton()
    
    let m_RedoButton = UIButton()
    
    var selectedStudentsArray = NSMutableArray()
    
    let _ratingsPopoverController = RatingsPopOverViewController()
    
    var isModelAnswerSelected     = false
    
    let kUplodingServer     = "http://54.251.104.13/Jupiter/upload_photos.php"
    
    var mSelectionCountLabel = UILabel()
    
    var sendButtonSpinner : UIActivityIndicatorView!
    
    var          givenStarRatings       = 0
    var          givenBadgeId  :Int32   = 0
    var           givenTextReply        = ""
    
    let m_textButton = UIButton()
    let m_badgeButton = UIButton()
    
    var PopoverControllerRatings:UIPopoverController!
    
    var selectedtab    = ""
    
    
    var currentTeacherImageURl = ""

    // By Ujjval
    // Create view for draw
    // ==========================================
    
    var mScribbleView : KMZDrawView!
    let colorSelectContoller = colorpopOverViewController()
    
    let studentDetailDictonary      = NSMutableDictionary()
    
    // ==========================================
    
    override init(frame: CGRect)
    {
        super.init(frame:frame)
        
        
        imageUploading.setDelegate(self)
        
      
        
        subjectiveCellContainer  = SubjectiveLeftSideView(frame: CGRect(x: 0, y: 0 , width: self.frame.size.width / 7, height: self.frame.size.height))
        subjectiveCellContainer.setdelegate(self)
        self.addSubview(subjectiveCellContainer)
        
        
        mainContainerView.frame = CGRect(x: subjectiveCellContainer.frame.size.width , y: 0, width: self.frame.size.width - subjectiveCellContainer.frame.size.width, height: self.frame.size.height)
        mainContainerView.backgroundColor = whiteBackgroundColor
        self.addSubview(mainContainerView)
        
        var heightRemaining:CGFloat = 130
        
        heightRemaining = mainContainerView.frame.size.height - heightRemaining
        
        
        overlayimageView.frame = CGRect(x: (mainContainerView.frame.size.width - (heightRemaining *  kAspectRation)) / 2 ,y: (mainContainerView.frame.size.height - heightRemaining) / 2 ,  width: heightRemaining *  kAspectRation ,height: heightRemaining)
        mainContainerView.addSubview(overlayimageView);
        
        
        containerview.frame = CGRect(x: (mainContainerView.frame.size.width - (heightRemaining *  kAspectRation)) / 2 ,y: (mainContainerView.frame.size.height - heightRemaining) / 2 ,  width: heightRemaining *  kAspectRation ,height: heightRemaining)
        containerview.backgroundColor = UIColor.clear
        mainContainerView.addSubview(containerview);
        containerview.layer.shadowColor = progressviewBackground.cgColor;
        containerview.layer.shadowOffset = CGSize(width: 0,height: 0);
        containerview.layer.shadowOpacity = 1;
        containerview.layer.shadowRadius = 1.0;
        containerview.clipsToBounds = false;

        
        
       
        
        
        
        topImageView.frame = CGRect(x: containerview.frame.origin.x ,y: containerview.frame.origin.y - 61, width: containerview.frame.size.width,height: 60)
        topImageView.backgroundColor = UIColor.white
        mainContainerView.addSubview (topImageView);
        topImageView.layer.shadowColor = progressviewBackground.cgColor;
        topImageView.layer.shadowOffset = CGSize(width: 1, height: 1);
        topImageView.layer.shadowOpacity = 1;
        topImageView.layer.shadowRadius = 1.0;
        topImageView.clipsToBounds = false;
        topImageView.isUserInteractionEnabled = true
        
        
        
        mSelectionCountLabel.frame = CGRect(x: containerview.frame.origin.x, y: topImageView.frame.origin.y + topImageView.frame.size.height, width: topImageView.frame.size.width, height: topImageView.frame.size.height/2)
        mainContainerView.addSubview(mSelectionCountLabel)
        mSelectionCountLabel.text = "No submission selected"
        mSelectionCountLabel.textColor = blackTextColor
        mSelectionCountLabel.isHidden = true
        mSelectionCountLabel.textAlignment = .center
        mSelectionCountLabel.font =  UIFont(name: helveticaMedium, size: 14);
        mSelectionCountLabel.backgroundColor = standard_Green
        mSelectionCountLabel.alpha = 1
        
        
        
        mCancelButton.showsTouchWhenHighlighted = true;
        mCancelButton.frame = CGRect(x: 10 , y: 0, width: 139.0, height: 60.0);
        topImageView.addSubview(mCancelButton);
        mCancelButton.setTitle("Cancel", for:UIControlState());
        mCancelButton.setTitleColor(standard_Button, for:UIControlState());
        mCancelButton.titleLabel?.font = UIFont(name: helveticaMedium, size: 20);
        mCancelButton.contentHorizontalAlignment = UIControlContentHorizontalAlignment.left
        mCancelButton.addTarget(self, action: #selector(SubmissionSubjectiveView.onCancelButton), for: UIControlEvents.touchUpInside)
        
        
        mSendButton.frame = CGRect(x: topImageView.frame.size.width - 100 , y: 0, width: 100 , height: topImageView.frame.size.height );
        topImageView.addSubview(mSendButton);
        mSendButton.setTitle("Send", for:UIControlState());
        mSendButton.setTitleColor(lightGrayColor, for:UIControlState());
        mSendButton.titleLabel?.font = UIFont(name: helveticaMedium, size: 20);
        mSendButton.isEnabled = false
        mSendButton.isHighlighted = false;
        mSendButton.contentHorizontalAlignment = UIControlContentHorizontalAlignment.center
        mSendButton.addTarget(self, action: #selector(SubmissionSubjectiveView.onSendButton), for: UIControlEvents.touchUpInside)

        
        
        
        
        sendButtonSpinner = UIActivityIndicatorView(activityIndicatorStyle:.gray);
        sendButtonSpinner.frame = mSendButton.frame;
        topImageView.addSubview(sendButtonSpinner);
        sendButtonSpinner.isHidden = true;
        
        
        
        let lineImage = UIImageView(frame:CGRect(x: mSendButton.frame.origin.x, y: 5, width: 1, height: topImageView.frame.size.height - 10));
        lineImage.backgroundColor = progressviewBackground
        topImageView.addSubview(lineImage);
        
        
       
        
        m_textButton.frame = CGRect(x: lineImage.frame.origin.x - 50, y: 10, width: 40, height: topImageView.frame.size.height - 20);
        topImageView.addSubview(m_textButton);
        m_textButton.imageView?.contentMode = .scaleAspectFit
        m_textButton.setImage(UIImage(named:"Text_Unselected.png"), for:UIControlState());
        m_textButton.addTarget(self, action: #selector(SubmissionSubjectiveView.onTextButton), for: UIControlEvents.touchUpInside)
        
        
        
        
        let lineImage1 = UIImageView(frame:CGRect(x: m_textButton.frame.origin.x - 10 , y: 5, width: 1, height: topImageView.frame.size.height - 10));
        lineImage1.backgroundColor = progressviewBackground
        topImageView.addSubview(lineImage1);
        
        
        m_badgeButton.frame = CGRect(x: lineImage1.frame.origin.x - 50, y: 10, width: 40, height: topImageView.frame.size.height - 20);
        topImageView.addSubview(m_badgeButton);
        m_badgeButton.imageView?.contentMode = .scaleAspectFit
        m_badgeButton.setImage(UIImage(named:"Cb_Like_Disabled.png"), for:UIControlState());
        m_badgeButton.addTarget(self, action: #selector(SubmissionSubjectiveView.onBadgeButton), for: UIControlEvents.touchUpInside)
        
        
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
        mMarkModelButton.addTarget(self, action: #selector(SubmissionSubjectiveView.onModelAnswerButton), for: UIControlEvents.touchUpInside)
        
      

        // By Ujjval
        // Assign frame and set other properties to draw view
        // ==========================================
        
//        mScribbleView = SmoothLineView(frame: containerview.frame)
//        mScribbleView.delegate = self
//        mainContainerView.addSubview(mScribbleView);
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
        mainContainerView.addSubview(mScribbleView)
        mScribbleView.isUserInteractionEnabled = true
        mScribbleView.delegate = self
        mScribbleView.penMode = .pencil
        self.changeBrushValues()
        mScribbleView.isHidden = false
        
        // ==========================================
        
        bottomview.frame = CGRect(x: topImageView.frame.origin.x, y: containerview.frame.origin.y + containerview.frame.size.height , width: topImageView.frame.size.width,height: topImageView.frame.size.height)
        bottomview.backgroundColor = lightGrayTopBar
        mainContainerView.addSubview(bottomview);
        
         m_UndoButton.frame = CGRect(x: 0, y: 0, width: bottomview.frame.size.height, height: bottomview.frame.size.height)
        m_UndoButton.setImage(UIImage(named:"Undo_Disabled.png"),for:UIControlState());
        bottomview.addSubview(m_UndoButton);
        m_UndoButton.imageView?.contentMode = .scaleAspectFit
        m_UndoButton.addTarget(self, action: #selector(SubmissionSubjectiveView.onUndoButton), for: UIControlEvents.touchUpInside)
        m_UndoButton.isEnabled = false
       
        bottomtoolSelectedImageView.backgroundColor = UIColor.white;
        bottomview.addSubview(bottomtoolSelectedImageView);
        bottomtoolSelectedImageView.layer.cornerRadius = 10.0;
        
        
        m_BrushButton.frame = CGRect(x: (bottomview.frame.size.width/2) - (bottomview.frame.size.height + 10) ,y: 5, width: bottomview.frame.size.height ,height: bottomview.frame.size.height - 10)
        m_BrushButton.setImage(UIImage(named:"Marker_Selected.png"), for:UIControlState())
        bottomview.addSubview(m_BrushButton);
        m_BrushButton.imageView?.contentMode = .scaleAspectFit
        m_BrushButton.addTarget(self, action: #selector(SubmissionSubjectiveView.onBrushButton), for: UIControlEvents.touchUpInside)
        bottomtoolSelectedImageView.frame = m_BrushButton.frame
        
        
        
       
        m_EraserButton.frame = CGRect(x: (bottomview.frame.size.width/2) + 10  ,y: 5, width: bottomview.frame.size.height ,height: bottomview.frame.size.height - 10)
        m_EraserButton.setImage(UIImage(named:"Eraser_Unselected.png"), for:UIControlState());
        bottomview.addSubview(m_EraserButton);
        m_EraserButton.imageView?.contentMode = .scaleAspectFit
        m_EraserButton.addTarget(self, action: #selector(SubmissionSubjectiveView.onEraserButton), for: UIControlEvents.touchUpInside)
        
        
        m_RedoButton.frame = CGRect(x: bottomview.frame.size.width - bottomview.frame.size.height ,y: 0, width: bottomview.frame.size.height ,height: bottomview.frame.size.height)
        m_RedoButton.setImage(UIImage(named:"Redo_Disabled.png"), for:UIControlState());
        bottomview.addSubview(m_RedoButton);
        m_RedoButton.imageView?.contentMode = .scaleAspectFit
        m_RedoButton.addTarget(self, action: #selector(SubmissionSubjectiveView.onRedoButton), for: UIControlEvents.touchUpInside)
        m_RedoButton.isEnabled = false
        
        // By Ujjval
        // ==========================================
        
        self.bringSubview(toFront: mScribbleView)
        
        NotificationCenter.default.addObserver(self, selector: #selector(SubmissionSubjectiveView.changeBrushValues), name: NSNotification.Name(rawValue: "ChangeBrushValues"), object: nil)
        
        // ==========================================
        
        
    }
    
    required init?(coder aDecoder: NSCoder)
    {
        fatalError("init(coder:) has not been implemented")
        
        
        
    }
    
    // By Ujjval
    // ==========================================
    
    func changeBrushValues() {
        
        if let colorIndex = UserDefaults.standard.value(forKey: "selectedBrushColor") as? Int {
            mScribbleView.penColor = colorSelectContoller.colorArray.object(at: colorIndex - 1) as! UIColor
        }
        else {
            mScribbleView.penColor = blackTextColor
        }
        
        let brushSize = UserDefaults.standard.float(forKey: "selectedBrushsize")
//        if brushSize < 5
//        {
//            brushSize = 5
//        }
        mScribbleView.penWidth = UInt(brushSize)
    }
   
    // ==========================================
    
    
    func setStudentAnswerWithAnswer(_ studentAnswer:AnyObject, withStudentDict studentdict:AnyObject, withQuestionDict QuestionDetails:AnyObject )
    {

        _currentQuestionDetials = QuestionDetails
        
        
        
        if let studentId = studentdict.object(forKey: "StudentId") as? String
        {
            studentsAswerDictonary.setObject(studentAnswer, forKey: studentId as NSCopying)
            studentDetailDictonary.setObject(studentdict, forKey: studentId as NSCopying)
        }
       
        
        if let overlayImage = _currentQuestionDetials.object(forKey: "Scribble") as? String
        {
            
            
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

            
            
              subjectiveCellContainer.addStudentSubmissionWithStudentAnswer(studentAnswer, withStudentDetails: studentdict, withOverlay:overlayImage)
            
        }
        else
        {
              subjectiveCellContainer.addStudentSubmissionWithStudentAnswer(studentAnswer, withStudentDetails: studentdict, withOverlay:"")
        }
        
        if selectedStudentsArray.count == 1
        {
            mSelectionCountLabel.text = "1 submission selected"
            mSelectionCountLabel.isHidden = false
        }
        else if selectedStudentsArray.count > 1
        {
            mSelectionCountLabel.text = "\(selectedStudentsArray.count) submissions selected "
            
            mSelectionCountLabel.isHidden = false
        }
        else
        {
            mSelectionCountLabel.text = "No submission selected"
            mSelectionCountLabel.isHidden = true
        }
        
        mainContainerView.bringSubview(toFront: mSelectionCountLabel)
        
      
    }
    // MARK: - Subjective LeftSide View Delegate
    
    func delegateStudentSelectedWithState(_ state: Bool, withStudentDetails studentDetails: AnyObject, withAnswerDetails answerDetails: AnyObject)
    {
        if state == true
        {
            
            if let studentId = studentDetails.object(forKey: "StudentId") as? String
            {
                if !selectedStudentsArray.contains(answerDetails)
                {
                    selectedStudentsArray.add(answerDetails)
                    
                    if let Scribble = answerDetails.object(forKey: "Scribble") as? String
                    {
                        let studentAnswerImage = CustomProgressImageView(frame: CGRect(x: 0, y: 0, width: containerview.frame.size.width, height: containerview.frame.size.height))
                        studentAnswerImage.tag  = Int(studentId)!
                        containerview.addSubview(studentAnswerImage)
                        containerview.bringSubview(toFront: studentAnswerImage)
//                        mainContainerView.bringSubview(toFront: containerview)
                        
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
                }
            }
            
            
        }
        else
        {
            if let studentId = studentDetails.object(forKey: "StudentId") as? String
            {
                if selectedStudentsArray.contains(answerDetails)
                {
                    selectedStudentsArray.remove(answerDetails)
                }
                
                if let studentDeskView  = containerview.viewWithTag(Int(studentId)!) as? UIImageView
                {
                    studentDeskView.removeFromSuperview()
                }
                
                if let studentDeskView  = containerview.viewWithTag(Int(studentId)!) as? UILabel
                {
                    studentDeskView.removeFromSuperview()
                }
                
            }
            
        }
        
        
        if selectedStudentsArray.count == 1
        {
            mSelectionCountLabel.text = "1 submission selected"
            mSelectionCountLabel.isHidden = false
        }
        else if selectedStudentsArray.count > 1
        {
            mSelectionCountLabel.text = "\(selectedStudentsArray.count) submissions selected "
            
            mSelectionCountLabel.isHidden = false
        }
        else
        {
            mSelectionCountLabel.text = "No submission selected"
            mSelectionCountLabel.isHidden = true
        }
        
        mainContainerView.bringSubview(toFront: mSelectionCountLabel)
        
        
    }
    
    
    func questionCleared()
    {
         subjectiveCellContainer.clearedQuestion()
        overlayimageView.image = nil
        selectedStudentsArray.removeAllObjects()
        let subViews = containerview.subviews
        
        for subview in subViews
        {
            subview.removeFromSuperview()
        }
        
        // By Ujjval
        // Clear image
        // ==========================================
        
//        mScribbleView.clearButtonClicked()
        mScribbleView.clear()
        
        // ==========================================
        
        givenBadgeId = 0
        givenStarRatings = 0
        givenTextReply = ""
        
        // By Ujjval
        // Clear image
        // ==========================================
        
//        mScribbleView.clearButtonClicked()
        mScribbleView.clear()
        
        // ==========================================
        
        mStarRatingView.setStarRating(0)
        m_badgeButton.setImage(UIImage(named:"Cb_Like_Disabled.png"), for:UIControlState());
        m_textButton.setImage(UIImage(named:"Text_Unselected.png"), for:UIControlState());

        
        mSendButton.setTitleColor(lightGrayColor, for:UIControlState());
        mSendButton.isEnabled = false
        
        if selectedStudentsArray.count == 1
        {
            mSelectionCountLabel.text = "1 submission selected"
            mSelectionCountLabel.isHidden = false
        }
        else if selectedStudentsArray.count > 1
        {
            mSelectionCountLabel.text = "\(selectedStudentsArray.count) submissions selected "
            
            mSelectionCountLabel.isHidden = false
        }
        else
        {
            mSelectionCountLabel.text = "No submission selected"
            mSelectionCountLabel.isHidden = true
        }
        
        mainContainerView.bringSubview(toFront: mSelectionCountLabel)
        
    }
   
    // MARK: - Buttons function 
    
    
    func onCancelButton()
    {
        
    }
    
    func onSendButton()
    {
        
        if selectedStudentsArray.count > 0
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
            
            if self.isModelAnswerSelected {
                
                for index in 0 ..< selectedStudentsArray.count
                {
                    let studentdict = selectedStudentsArray.object(at: index)
                    
                    if let studentId = (studentdict as AnyObject).object(forKey: "StudentId") as? String {
                        
                        let studentDetail = studentDetailDictonary.object(forKey: studentId)
                        
                        if let studentAnswerDict = studentsAswerDictonary.object(forKey: studentId) {
                            if let AssessmentAnswerId = (studentAnswerDict as AnyObject).object(forKey: "AssessmentAnswerId") as? String {
                                
                                if let type = (studentAnswerDict as AnyObject).object(forKey: kQuestionType) as? String {
                                    
                                    let dict : NSMutableDictionary = ["AssessmentAnswerId" : AssessmentAnswerId, kQuestionType : (studentAnswerDict as AnyObject).object(forKey: kQuestionType)!, "StudentId" : (studentAnswerDict as AnyObject).object(forKey: "StudentId")!, "StudentName" : (studentDetail as AnyObject).object(forKey: "Name")!]
                                    
                                    if type == kText {
                                        dict.addEntries(from: ["TextAnswer" : (studentAnswerDict as AnyObject).object(forKey: "TextAnswer")!])
                                    }
                                    else {
                                        dict.addEntries(from: ["TeacherScribble" : _currentQuestionDetials.object(forKey: "Scribble")!, "Image" : (studentAnswerDict as AnyObject).object(forKey: "Scribble")!])
                                    }
                                    
                                    SSTeacherDataSource.sharedDataSource.mModelAnswersArray.add(dict)
                                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "setModelAnswerList"), object: nil)
                                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "setModelAnswer"), object: (studentAnswerDict as AnyObject).object(forKey: "StudentId")!)
                                }
                            }
                        }
                    }
                }
            }
            
            // By Ujjval
            // Check image available or not to post on server
            // ==========================================
            
//            if (mScribbleView.curImage != nil)
            if (mScribbleView.image != nil)
            {
//                imageUploading.uploadImage(with: mScribbleView.curImage, withImageName: nameOfImage, withUserId: SSTeacherDataSource.sharedDataSource.currentUserId)
                
                imageUploading.uploadImage(with: mScribbleView.image, withImageName: nameOfImage, withUserId: SSTeacherDataSource.sharedDataSource.currentUserId)
                
                // ==========================================
            }
            else
            {
                newImageUploadedWithName(nameOfImage)
            }
            
        }
        else
        {
            self.makeToast("please select at least one student to give feed back ", duration: 3.0, position: .bottom)
        }
        
        
        
    }
    
    func onTextButton()
    {
        
        selectedtab = kText
        
        _ratingsPopoverController.addTextviewwithtext(givenTextReply, withtopviewText:"Rate with Text")
        let navController = UINavigationController(rootViewController: _ratingsPopoverController)
        
        
        
        PopoverControllerRatings = UIPopoverController(contentViewController: navController)
        PopoverControllerRatings.contentSize = CGSize(width: 200,height: 100);
        PopoverControllerRatings.delegate = self;
        navController.isNavigationBarHidden = true;
        
        
        let buttonPosition :CGPoint = m_textButton.convert(CGPoint.zero, to: self)
        
        PopoverControllerRatings.present(from: CGRect(x: buttonPosition.x + m_textButton.frame.size.width / 2 , y: topImageView.frame.origin.y + topImageView.frame.size.height , width: 1, height: 1), in: self, permittedArrowDirections: .up, animated: true)
    }
    
    func onBadgeButton()
    {
        
        selectedtab = "Badge"
        _ratingsPopoverController.addBadges(withValueValue: givenBadgeId, withtext:"Rate with badge");
        let navController = UINavigationController(rootViewController: _ratingsPopoverController)
        
        
        let buttonPosition :CGPoint = m_badgeButton.convert(CGPoint.zero, to: self)
        PopoverControllerRatings = UIPopoverController(contentViewController: navController)
        PopoverControllerRatings.contentSize = CGSize(width: 200,height: 150);
        PopoverControllerRatings.delegate = self;
        navController.isNavigationBarHidden = true;
        
        PopoverControllerRatings.present(from: CGRect(x: buttonPosition.x + m_badgeButton.frame.size.width / 2 , y: topImageView.frame.origin.y + topImageView.frame.size.height , width: 1, height: 1), in: self, permittedArrowDirections: .up, animated: true)
        
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
        let brushSize = UserDefaults.standard.float(forKey: "selectedBrushsize")
//        if brushSize < 5
//        {
//            brushSize = 5
//        }
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
        
        if PopoverControllerRatings != nil
        {
            if popoverController == PopoverControllerRatings
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
                mSendButton.setTitleColor(standard_Button, for:UIControlState());
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
        mSendButton.setTitleColor(standard_Button, for:UIControlState());
    }
    
    // MARK: - Star view delegate
    
    func starRatingDidChange()
    {
        givenStarRatings = mStarRatingView.rating()
        if givenStarRatings > 0
        {
            mSendButton.isEnabled = true;
            mSendButton.setTitleColor(standard_Button, for:UIControlState());
        }
    }
    

     // MARK: - image Uploadeding delegate
    
    func newImageUploadedWithName(_ imageName:String)
    {
        let feedBackDetails  = NSMutableDictionary()
        
        let StudentIdArray = NSMutableArray()
        
        let AssessmentAnswerIdArray = NSMutableArray()
        
        for index in 0 ..< selectedStudentsArray.count 
        {
            
            
            let studentdict = selectedStudentsArray.object(at: index)
            
            if let studentId = (studentdict as AnyObject).object(forKey: "StudentId") as? String
            {
                
                if let studentAnswerDict = studentsAswerDictonary.object(forKey: studentId)
                {
                    
                    if let AssessmentAnswerId = (studentAnswerDict as AnyObject).object(forKey: "AssessmentAnswerId") as? String
                    {
                        
                        StudentIdArray.add(studentId)
                        AssessmentAnswerIdArray.add(AssessmentAnswerId)
                        
                        
                    }
                    
                }
                
                
            }
            
        }
        
        feedBackDetails.setObject(StudentIdArray.componentsJoined(by: ","), forKey: "StudentId" as NSCopying)
        
        feedBackDetails.setObject(AssessmentAnswerIdArray.componentsJoined(by: ","), forKey: "AssessmentAnswerId" as NSCopying)
        
        feedBackDetails.setObject("\(givenStarRatings)", forKey: "Rating" as NSCopying)
        
        feedBackDetails.setObject("upload/".appending(imageName), forKey: "imageUrl" as NSCopying)
        
        feedBackDetails.setObject("\(givenBadgeId)", forKey: "BadgeId" as NSCopying)
        
        feedBackDetails.setObject("\(givenTextReply)", forKey: "textRating" as NSCopying)
        
       feedBackDetails.setObject("\(isModelAnswerSelected)", forKey: "ModelAnswerFlag" as NSCopying)
//        feedBackDetails.setObject("0", forKey: "ModelAnswerFlag" as NSCopying)
        
        SSTeacherDataSource.sharedDataSource.sendFeedbackToStudentWithDetails(feedBackDetails, WithDelegate: self)
        
        
    }
    
    func didGetFeedbackSentWithDetails(_ details: AnyObject)
    {
        if details.object(forKey: "Status") as? String == "Success" {
           
            if let _studentId = ((details.object(forKey: "Students")! as AnyObject).object(forKey: "Student")! as AnyObject).object(forKey: "StudentId") as? String  {
              
                if let _AssessmentAnswerId = details.object(forKey: "AssessmentAnswerId") as? String {
                    var StudentIdArray = [String]()
                    var AssessmentAnswerIdArray = [String]()
                    StudentIdArray = _studentId.components(separatedBy: ",")
                    AssessmentAnswerIdArray = _AssessmentAnswerId.components(separatedBy: ",")
                    for index in 0..<StudentIdArray.count {
                        let studentIdValue = StudentIdArray[index]
                        let AssessmentAnswervalue = AssessmentAnswerIdArray[index]
                        SSTeacherMessageHandler.sharedMessageHandler.sendFeedbackToStudentWitId(studentIdValue, withassesmentAnswerId: AssessmentAnswervalue)
                        subjectiveCellContainer.removeStudentsWithStudentsId(studentIdValue)
                        if let answerDetails = studentsAswerDictonary.object(forKey: studentIdValue) {
                            if selectedStudentsArray.contains(answerDetails) {
                                let feedBackDetails = NSMutableDictionary()
                                feedBackDetails.setObject(studentIdValue, forKey: "StudentId" as NSCopying)
                                feedBackDetails.setObject(AssessmentAnswervalue, forKey: "AssessmentAnswerId" as NSCopying)
                                feedBackDetails.setObject("\(givenStarRatings)", forKey: "Rating" as NSCopying)
                                feedBackDetails.setObject("upload/".appending(currentTeacherImageURl).appending(".png"),  forKey: "imageUrl" as NSCopying)
                                feedBackDetails.setObject("\(givenBadgeId)", forKey: "BadgeId" as NSCopying)
                                feedBackDetails.setObject("\(givenTextReply)", forKey: "textRating" as NSCopying)
                                feedBackDetails.setObject("\(isModelAnswerSelected)", forKey: "ModelAnswerFlag" as NSCopying)
//                                feedBackDetails.setObject("0", forKey: "ModelAnswerFlag" as NSCopying)
                                selectedStudentsArray.remove(answerDetails)
                               
                                if delegate().responds(to: #selector(SubmissionSubjectiveViewDelegate.delegateStudentSubmissionEvaluatedWithDetails(_:withStudentId:withSubmissionCount:))) {
                                    delegate().delegateStudentSubmissionEvaluatedWithDetails!(feedBackDetails, withStudentId: studentIdValue, withSubmissionCount:subjectiveCellContainer.totlStudentsCount)
                                }
                            }
                        }
                        if let studentDeskView  = containerview.viewWithTag(Int(studentIdValue)!) as? UIImageView {
                            studentDeskView.removeFromSuperview()
                        }
                    }
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
        mScribbleView.clear()
        
        // ==========================================
    }
    
    
    
    func removeStudentAnswerWithStudentId(_ studentId:String) -> Int
    {
        
        if let studentDeskView  = containerview.viewWithTag(Int(studentId)!) as? UIImageView
        {
            studentDeskView.removeFromSuperview()
        }
        
        subjectiveCellContainer.removeStudentsWithStudentsId(studentId)
        
        
        if let answerDetails = studentsAswerDictonary.object(forKey: studentId)
        {
            if selectedStudentsArray.contains(answerDetails)
            {
                selectedStudentsArray.remove(answerDetails)
            }
            
        }
        
        return selectedStudentsArray.count

    }
    
    func submissionEvaluatedWithDetails(_ evaluationDetails:AnyObject,withStudentId studentId:String)
    {
        if let studentDeskView  = containerview.viewWithTag(Int(studentId)!) as? UIImageView
        {
            studentDeskView.removeFromSuperview()
        }
        
        
        subjectiveCellContainer.removeStudentsWithStudentsId(studentId)
        
        
        if let answerDetails = studentsAswerDictonary.object(forKey: studentId)
        {
            if selectedStudentsArray.contains(answerDetails)
            {
                selectedStudentsArray.remove(answerDetails)
            }
            
            if delegate().responds(to: #selector(SubmissionSubjectiveViewDelegate.delegateStudentSubmissionEvaluatedWithDetails(_:withStudentId:withSubmissionCount:)))
            {
                delegate().delegateStudentSubmissionEvaluatedWithDetails!(evaluationDetails, withStudentId: studentId, withSubmissionCount:subjectiveCellContainer.totlStudentsCount)
            }

        }
        

        
        
    }
    
    
    func didgetErrorMessage(_ message: String, WithServiceName serviceName: String)
    {
        sendButtonSpinner.isHidden = true
        sendButtonSpinner.stopAnimating()
        mSendButton.isHidden = false
        
        
        self.makeToast(message, duration: 5.0, position: .bottom)
        
    }
    
    
    // MARK: - ImageUploading delegate
    
    func imageUploaded(withName name: String!)
    {
        SSTeacherDataSource.sharedDataSource.InsertScribbleFileName(Scribblename: "upload/".appending(name).appending(".png"), withSuccessHandle: { (details) in
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
    
    
    
    func errorInUploading(withName name: String!) {
        
        sendButtonSpinner.isHidden = true
        sendButtonSpinner.stopAnimating()
        mSendButton.isHidden = false
        
        // By Ujjval
        // Clear image
        // ==========================================
        
//        mScribbleView.clearButtonClicked()
        mScribbleView.clear()
        
        // ==========================================
        
        currentTeacherImageURl = ""
    }
    
    // MARK: - Color popover delegate
    
    
    public func selectedbrushSize(_ sender: Any!, withSelectedTab tabTag: Int32)
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
    
    public func selectedColor(_ sender: Any!, withSelectedTab tabTag: Int32)
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
    
    
    func resetAllButtonState()
    {
        
        // By Ujjval
        // Clear image
        // ==========================================
        
//        mScribbleView.clearButtonClicked()
        mScribbleView.clear()
        
        // ==========================================
        
        givenBadgeId = 0
        givenStarRatings = 0
        givenTextReply = ""
        
        // By Ujjval
        // Clear image
        // ==========================================
        
//        mScribbleView.clearButtonClicked()
        mScribbleView.clear()
        
        // ==========================================
        mStarRatingView.setStarRating(0)
        m_badgeButton.setImage(UIImage(named:"Cb_Like_Disabled.png"), for:UIControlState());
        m_textButton.setImage(UIImage(named:"Text_Unselected.png"), for:UIControlState());
        mMarkModelButton.setImage(UIImage(named:"Mark_Model_Not_Selected.png"), for:UIControlState())
        isModelAnswerSelected = false

        
        mSendButton.setTitleColor(lightGrayColor, for:UIControlState());
        mSendButton.isEnabled = false
        
        
    }
    
}
