//
//  StudentSubjectivePopover.swift
//  LearniatTeacher
//
//  Created by Deepak MK on 06/04/16.
//  Copyright © 2016 Mindshift. All rights reserved.
//

import Foundation



@objc protocol StudentSubjectivePopoverDelegate
{
    
    
    @objc optional func delegateSubmissionEvalauatedWithAnswerDetails(_ answerDetails:AnyObject,withEvaluationDetail evaluation:AnyObject, withStudentId studentId:String)
    
    @objc optional func delegateAnnotateButtonPressedWithAnswerDetails(_ answerDetails:AnyObject, withStudentDetails studentDict:AnyObject, withQuestionDetails questionDetails:AnyObject, withStarRatings ratings:Int, withModelAnswer modelAnswer:Bool)
    
    
    
}


class StudentSubjectivePopover: UIViewController,SSStarRatingViewDelegate,SSTeacherDataSourceDelegate,SmoothLineViewdelegate
{
    var _delgate: AnyObject!

    
    
    var _studentAnswerDetails:AnyObject!
    
    var _currentStudentDict:AnyObject!
    
    var _currentQuestiondetails:AnyObject!
    
    let mStarRatingView = SSStarRatingView()
    var isModelAnswer = false
    
    let  mDoneButton = UIButton()
    
    let imageUploading = ImageUploading()
    
    let modelAnswerButton = UIButton()
    
    var sendButtonSpinner : UIActivityIndicatorView!
    
     var mScribbleView : SmoothLineView!
    
    let feedBackDetails = NSMutableDictionary()
    
    func setdelegate(_ delegate:AnyObject)
    {
        _delgate = delegate;
    }

    func   delegate()->AnyObject
    {
        return _delgate;
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

    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        
//        self.view.setNeedsLayout()
//        self.view.layoutIfNeeded()
        
        imageUploading.setDelegate(self)
        
        
        let questionView = UIView(frame: CGRect(x: 0, y: 0, width: 320, height: 320))
        self.view.addSubview(questionView)
        
        
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: 320, height: 40))
        headerView.backgroundColor = lightGrayTopBar
        questionView.addSubview(headerView);
        
        
        let seperatorView = UIView(frame: CGRect(x: 0, y: headerView.frame.size.height-1, width: 320, height: 1))
        seperatorView.backgroundColor = LineGrayColor
        headerView.addSubview(seperatorView);

        
        
        
        
        
        
        let headerlabel = UILabel(frame: CGRect(x: 20, y: 0, width: 200, height: 40))
        headerlabel.text = kOverlayScribble
        headerView.addSubview(headerlabel)
        headerlabel.textAlignment = .left;
        headerlabel.font = UIFont(name: helveticaRegular, size: 20)
        headerlabel.textColor  = blackTextColor
        
        
        
         mDoneButton.frame = CGRect(x: headerView.frame.size.width - 120, y: 0, width: 100, height: 40)
        mDoneButton.addTarget(self, action: #selector(StudentSubjectivePopover.onDoneButton), for: UIControlEvents.touchUpInside)
        mDoneButton.setTitleColor(standard_Button, for: UIControlState())
        mDoneButton.setTitle("Done", for: UIControlState())
        mDoneButton.contentHorizontalAlignment = UIControlContentHorizontalAlignment.right
        mDoneButton.titleLabel?.font = UIFont(name: helveticaMedium, size: 20)
        headerView.addSubview(mDoneButton)

        
        
        sendButtonSpinner = UIActivityIndicatorView(activityIndicatorStyle:.gray);
        sendButtonSpinner.frame = mDoneButton.frame;
        headerView.addSubview(sendButtonSpinner);
        sendButtonSpinner.isHidden = true;

        
        
        
        
       
        
        modelAnswerButton.isEnabled = true
        modelAnswerButton.setTitle("Mark Model", for:UIControlState())
        modelAnswerButton.setTitleColor(standard_Button ,for:UIControlState());
        modelAnswerButton.addTarget(self, action: #selector(StudentSubjectivePopover.onModelAnswer), for: UIControlEvents.touchUpInside)
        modelAnswerButton.frame = CGRect(x: 20, y: 45, width: 130, height: 40);
        questionView.addSubview(modelAnswerButton);
        modelAnswerButton.contentHorizontalAlignment = UIControlContentHorizontalAlignment.left
        
        let anotateButton = UIButton(type:.custom)
        anotateButton.isEnabled = true
        anotateButton.setTitle("Annotate", for:UIControlState())
        anotateButton.setTitleColor(standard_Button ,for:UIControlState());
        anotateButton.addTarget(self, action: #selector(StudentSubjectivePopover.onAnnotateButton), for: UIControlEvents.touchUpInside)
        anotateButton.frame = CGRect(x: 170, y: 45, width: 130, height: 40);
        questionView.addSubview(anotateButton);
        anotateButton.contentHorizontalAlignment = UIControlContentHorizontalAlignment.right
    
        
       let lineView = UIImageView(frame:CGRect(x: 20, y: 85, width: 280, height: 1))
        lineView.backgroundColor = topicsLineColor
        questionView.addSubview(lineView);
        
        
        
        if let StudentName = _currentStudentDict.object(forKey: "StudentName") as? String
        {
            headerlabel.text = StudentName
        }
        
        
      
        if let questionType = _currentQuestiondetails.object(forKey: kQuestionType) as? String
        {
            if (questionType  == kOverlayScribble  || questionType == kFreshScribble)
            {
                if let overlayImage = _currentQuestiondetails.object(forKey: "Scribble") as? String
                {
                    let overLayImageView = CustomProgressImageView(frame: CGRect(x: (questionView.frame.size.width - 270)/2,y: lineView.frame.origin.y + 2 ,width: 270,height: 180))
                    questionView.addSubview(overLayImageView)
                    
                    
                    let urlString = UserDefaults.standard.object(forKey: k_INI_QuestionsImageUrl) as! String
                    
                    if let checkedUrl = URL(string: "\(urlString)/\(overlayImage)")
                    {
                        overLayImageView.contentMode = .scaleAspectFit
                        overLayImageView.downloadImage(checkedUrl, withFolderType: folderType.questionImage,withResizeValue: overLayImageView.frame.size)
                    }
                    
                }
                
                
                let studentAnswerImage = CustomProgressImageView(frame: CGRect(x: (questionView.frame.size.width - 270)/2,y: lineView.frame.origin.y + lineView.frame.size.height ,width: 270,height: 180))
                questionView.addSubview(studentAnswerImage)
                
                
                if let Scribble = _studentAnswerDetails.object(forKey: "Scribble") as? String
                {
                    let urlString = UserDefaults.standard.object(forKey: k_INI_SCRIBBLE_IMAGE_URL) as! String
                    
                    if let checkedUrl = URL(string: "\(urlString)/\(Scribble)")
                    {
                        studentAnswerImage.contentMode = .scaleAspectFit
                        studentAnswerImage.downloadImage(checkedUrl, withFolderType: folderType.studentAnswer,withResizeValue: studentAnswerImage.frame.size)
                    }
                }
                
            }
            else if (questionType == kText)
            {
                let studentAnswertext = UILabel(frame: CGRect(x: (questionView.frame.size.width - 270)/2,y: lineView.frame.origin.y + lineView.frame.size.height ,width: 270,height: 180))
                questionView.addSubview(studentAnswertext)
                
                var fontHeight = studentAnswertext.frame.size.height/1.6;
                
                if (fontHeight > 16)
                {
                    fontHeight = 16;
                }
                
                studentAnswertext.font = UIFont(name: helveticaRegular, size: fontHeight)
                studentAnswertext.textColor = blackTextColor
                studentAnswertext.lineBreakMode = .byTruncatingMiddle
                studentAnswertext.numberOfLines = 10
                studentAnswertext.textAlignment = .center
                if let TextAnswer = _studentAnswerDetails.object(forKey: "TextAnswer") as? String
                {
                    studentAnswertext.text = TextAnswer
                }
                

            }
        }
        
        
        
        mScribbleView = SmoothLineView(frame: CGRect(x: (questionView.frame.size.width - 270)/2,y: lineView.frame.origin.y + lineView.frame.size.height ,width: 270,height: 180))
        mScribbleView.delegate = self
//        self.view.addSubview(mScribbleView);
        mScribbleView.isUserInteractionEnabled = true
        mScribbleView.setDrawing(standard_Red);
        mScribbleView.setBrushWidth(3)
        mScribbleView.setDrawing(kBrushTool)
        var brushSize = UserDefaults.standard.float(forKey: "selectedBrushsize")
        if brushSize < 5
        {
            brushSize = 5
        }
        mScribbleView.setBrushWidth(Int32(brushSize))
        mScribbleView.isHidden = false

        
        
        let lineView1 = UIImageView(frame:CGRect(x: 20, y: 270, width: 280, height: 1))
        lineView1.backgroundColor = topicsLineColor
        questionView.addSubview(lineView1);
        
        
        mStarRatingView.setDelegate(self);
        mStarRatingView.backgroundColor = UIColor.clear;
        mStarRatingView.frame = CGRect(x: 80, y: lineView1.frame.origin.y + lineView1.frame.size.height + 10, width: 210.0, height: 34.0);
        questionView.addSubview(mStarRatingView);
        mStarRatingView.setsize(ofStar: 25)

    }
    
    func setStudentAnswerDetails(_ details:AnyObject, withStudentDetials StudentDict:AnyObject, withCurrentQuestionDict questionDict:AnyObject)
    {
        _studentAnswerDetails = details
        _currentStudentDict = StudentDict
        _currentQuestiondetails = questionDict
    }
    
    
    
    func starRatingDidChange()
    {
        
    }
    
    
    
    func onModelAnswer()
    {
        
        
        isModelAnswer = true
        modelAnswerButton.setTitleColor(UIColor.lightGray ,for:UIControlState());
        modelAnswerButton.isEnabled = false
        
    }
    
    
    // MARK: - Smooth line delegate
    
    func lineDrawnChanged()
    {
        
    }
    
    func setUndoButtonEnable(_ enable: NSNumber!) {
        
    }
    
    func setRedoButtonEnable(_ enable: NSNumber!) {
        
    }
    
    
    func onAnnotateButton()
    {
        if delegate().responds(to: #selector(StudentSubjectivePopoverDelegate.delegateAnnotateButtonPressedWithAnswerDetails(_:withStudentDetails:withQuestionDetails:withStarRatings:withModelAnswer:)))
        {
            delegate().delegateAnnotateButtonPressedWithAnswerDetails!(_studentAnswerDetails, withStudentDetails: _currentStudentDict, withQuestionDetails: _currentQuestiondetails, withStarRatings: mStarRatingView.rating(), withModelAnswer: isModelAnswer)
            
            
            popover().dismiss(animated: true)
            
        }
    }
    
    // MARK: - sendFeedBack delegate
    
    func onDoneButton()
    {
        
        if isModelAnswer == true || mStarRatingView.rating() > 0 || mScribbleView.curImage != nil
        {
            sendButtonSpinner.isHidden = false
            sendButtonSpinner.startAnimating()
            mDoneButton.isHidden = true
            
            let currentDate = Date()
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-mm-dd HH:mm:ss"
            
            
            
            let currentDateString = dateFormatter.string(from: currentDate)
            
            let imagePathString = SSTeacherDataSource.sharedDataSource.currentUserId.appending("-").appending(SSTeacherDataSource.sharedDataSource.currentLiveSessionId).appending("-").appending(currentDateString)
            
            var nameOfImage  = "TT-".appending(imagePathString)
            nameOfImage =  nameOfImage.replacingOccurrences(of: " ", with: "")
            
            if mScribbleView.curImage != nil
            {
                
                imageUploading.uploadImage(with: mScribbleView.curImage, withImageName: nameOfImage, withUserId: SSTeacherDataSource.sharedDataSource.currentUserId)
            }
            else
            {
                newImageUploadedWithName(nameOfImage)
            }
            
            
            
        }
        else
        {
            popover().dismiss(animated: true)
        }
        
        
        
    }
    
    
    func newImageUploadedWithName(_ imageName:String)
    {
        if let AssessmentAnswerId = _studentAnswerDetails.object(forKey: "AssessmentAnswerId") as? String
        {
            
            
            feedBackDetails.setObject(_currentStudentDict.object(forKey: "StudentId")!, forKey: "StudentId" as NSCopying)
            
            feedBackDetails.setObject(AssessmentAnswerId, forKey: "AssessmentAnswerId" as NSCopying)
            
            feedBackDetails.setObject("\(mStarRatingView.rating())", forKey: "Rating" as NSCopying)
            
            feedBackDetails.setObject("upload/".appending(imageName).appending(".png"), forKey: "imageUrl" as NSCopying)
            
            feedBackDetails.setObject("0", forKey: "BadgeId" as NSCopying)
            
            feedBackDetails.setObject("", forKey: "textRating" as NSCopying)
            
            feedBackDetails.setObject("\(isModelAnswer)", forKey: "ModelAnswerFlag" as NSCopying)
            
            SSTeacherDataSource.sharedDataSource.sendFeedbackToStudentWithDetails(feedBackDetails, WithDelegate: self)
            
        }
    }
    
    func didGetFeedbackSentWithDetails(_ details: AnyObject)
    {
        
        
        if let studentId = ((details.object(forKey: "Students")! as AnyObject).object(forKey: "Student")! as AnyObject).object(forKey: "StudentId") as? String
        {
            if let AssessmentAnswerId = details.object(forKey: "AssessmentAnswerId") as? String
            {
                SSTeacherMessageHandler.sharedMessageHandler.sendFeedbackToStudentWitId(studentId, withassesmentAnswerId: AssessmentAnswerId)
                
                if delegate().responds(to: #selector(StudentSubjectivePopoverDelegate.delegateSubmissionEvalauatedWithAnswerDetails(_:withEvaluationDetail:withStudentId:)))
                {
                    
                    delegate().delegateSubmissionEvalauatedWithAnswerDetails!(_studentAnswerDetails, withEvaluationDetail: feedBackDetails, withStudentId: studentId)
                    
                }
                
                popover().dismiss(animated: true)
                
                
            }
        }
    }
    
    
    
    
    // MARK: - ImageUploading delegate
    
    func ImageUploadedWithName(_ name: String!)
    {
        SSTeacherDataSource.sharedDataSource.InsertScribbleFileName(Scribblename: name, withSuccessHandle: { (details) in
            self.newImageUploadedWithName(name)
        }) { (error) in
            self.sendButtonSpinner.isHidden = true
            self.sendButtonSpinner.stopAnimating()
            self.mDoneButton.isHidden = false
            self.mScribbleView.clearButtonClicked()
        }
        
        
    }
    
    func ErrorInUploadingWithName(_ name: String!)
    {
        sendButtonSpinner.isHidden = true
        sendButtonSpinner.stopAnimating()
        mDoneButton.isHidden = false
        mScribbleView.clearButtonClicked()
    }
    
    
    
    
}
