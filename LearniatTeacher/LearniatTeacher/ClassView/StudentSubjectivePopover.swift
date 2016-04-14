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
    
    
    optional func delegateSubmissionEvalauatedWithAnswerDetails(answerDetails:AnyObject,withEvaluationDetail evaluation:AnyObject, withStudentId studentId:String)
    
    optional func delegateAnnotateButtonPressedWithAnswerDetails(answerDetails:AnyObject, withStudentDetails studentDict:AnyObject, withQuestionDetails questionDetails:AnyObject)
    
    
    
}


class StudentSubjectivePopover: UIViewController,SSStarRatingViewDelegate,SSTeacherDataSourceDelegate,SmoothLineViewdelegate
{
    var _delgate: AnyObject!

    var _Popover:AnyObject!
    
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
    
    func setdelegate(delegate:AnyObject)
    {
        _delgate = delegate;
    }

    func   delegate()->AnyObject
    {
        return _delgate;
    }
    
    
    
    func setPopover(popover:AnyObject)
    {
        _Popover = popover
    }
    
    func popover()-> AnyObject
    {
        return _Popover
    }

    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        
//        self.view.setNeedsLayout()
//        self.view.layoutIfNeeded()
        
        imageUploading.setDelegate(self)
        
        
        let questionView = UIView(frame: CGRectMake(0, 0, 320, 320))
        self.view.addSubview(questionView)
        
        
        let headerView = UIView(frame: CGRectMake(0, 0, 320, 40))
        headerView.backgroundColor = lightGrayTopBar
        questionView.addSubview(headerView);
        
        
        let seperatorView = UIView(frame: CGRectMake(0, headerView.frame.size.height-1, 320, 1))
        seperatorView.backgroundColor = LineGrayColor
        headerView.addSubview(seperatorView);

        
        
        
        
        
        
        let headerlabel = UILabel(frame: CGRectMake(20, 0, 200, 40))
        headerlabel.text = kOverlayScribble
        headerView.addSubview(headerlabel)
        headerlabel.textAlignment = .Left;
        headerlabel.font = UIFont(name: helveticaRegular, size: 20)
        headerlabel.textColor  = blackTextColor
        
        
        
         mDoneButton.frame = CGRectMake(headerView.frame.size.width - 120, 0, 100, 40)
        mDoneButton.addTarget(self, action: "onDoneButton", forControlEvents: UIControlEvents.TouchUpInside)
        mDoneButton.setTitleColor(standard_Button, forState: .Normal)
        mDoneButton.setTitle("Done", forState: .Normal)
        mDoneButton.contentHorizontalAlignment = UIControlContentHorizontalAlignment.Right
        mDoneButton.titleLabel?.font = UIFont(name: helveticaMedium, size: 20)
        headerView.addSubview(mDoneButton)

        
        
        sendButtonSpinner = UIActivityIndicatorView(activityIndicatorStyle:.Gray);
        sendButtonSpinner.frame = mDoneButton.frame;
        headerView.addSubview(sendButtonSpinner);
        sendButtonSpinner.hidden = true;

        
        
        
        
       
        
        modelAnswerButton.enabled = true
        modelAnswerButton.setTitle("Mark Model", forState:.Normal)
        modelAnswerButton.setTitleColor(standard_Button ,forState:.Normal);
        modelAnswerButton.addTarget(self, action: "onModelAnswer", forControlEvents: UIControlEvents.TouchUpInside)
        modelAnswerButton.frame = CGRectMake(20, 45, 130, 40);
        questionView.addSubview(modelAnswerButton);
        modelAnswerButton.contentHorizontalAlignment = UIControlContentHorizontalAlignment.Left
        
        let anotateButton = UIButton(type:.Custom)
        anotateButton.enabled = true
        anotateButton.setTitle("Annotate", forState:.Normal)
        anotateButton.setTitleColor(standard_Button ,forState:.Normal);
        anotateButton.addTarget(self, action: "onAnnotateButton", forControlEvents: UIControlEvents.TouchUpInside)
        anotateButton.frame = CGRectMake(170, 45, 130, 40);
        questionView.addSubview(anotateButton);
        anotateButton.contentHorizontalAlignment = UIControlContentHorizontalAlignment.Right
    
        
       let lineView = UIImageView(frame:CGRectMake(20, 85, 280, 1))
        lineView.backgroundColor = topicsLineColor
        questionView.addSubview(lineView);
        
        
        
        if let StudentName = _currentStudentDict.objectForKey("StudentName") as? String
        {
            headerlabel.text = StudentName
        }
        
        
      
        if let questionType = _currentQuestiondetails.objectForKey("Type") as? String
        {
            if (questionType  == kOverlayScribble  || questionType == kFreshScribble)
            {
                if let overlayImage = _currentQuestiondetails.objectForKey("Scribble") as? String
                {
                    let overLayImageView = UIImageView(frame: CGRectMake((questionView.frame.size.width - 270)/2,lineView.frame.origin.y + 2 ,270,180))
                    questionView.addSubview(overLayImageView)
                    
                    
                    let urlString = NSUserDefaults.standardUserDefaults().objectForKey(k_INI_QuestionsImageUrl) as! String
                    
                    if let checkedUrl = NSURL(string: "\(urlString)/\(overlayImage)")
                    {
                        overLayImageView.contentMode = .ScaleAspectFit
                        overLayImageView.downloadImage(checkedUrl, withFolderType: folderType.questionImage,withResizeValue: overLayImageView.frame.size)
                    }
                    
                }
                
                
                let studentAnswerImage = UIImageView(frame: CGRectMake((questionView.frame.size.width - 270)/2,lineView.frame.origin.y + lineView.frame.size.height ,270,180))
                questionView.addSubview(studentAnswerImage)
                
                
                if let Scribble = _studentAnswerDetails.objectForKey("Scribble") as? String
                {
                    let urlString = NSUserDefaults.standardUserDefaults().objectForKey(k_INI_SCRIBBLE_IMAGE_URL) as! String
                    
                    if let checkedUrl = NSURL(string: "\(urlString)/\(Scribble)")
                    {
                        studentAnswerImage.contentMode = .ScaleAspectFit
                        studentAnswerImage.downloadImage(checkedUrl, withFolderType: folderType.StudentAnswer,withResizeValue: studentAnswerImage.frame.size)
                    }
                }
                
            }
            else if (questionType == kText)
            {
                let studentAnswertext = UILabel(frame: CGRectMake((questionView.frame.size.width - 270)/2,lineView.frame.origin.y + lineView.frame.size.height ,270,180))
                questionView.addSubview(studentAnswertext)
                
                var fontHeight = studentAnswertext.frame.size.height/1.6;
                
                if (fontHeight > 16)
                {
                    fontHeight = 16;
                }
                
                studentAnswertext.font = UIFont(name: helveticaRegular, size: fontHeight)
                studentAnswertext.textColor = blackTextColor
                studentAnswertext.lineBreakMode = .ByTruncatingMiddle
                studentAnswertext.numberOfLines = 10
                studentAnswertext.textAlignment = .Center
                if let TextAnswer = _studentAnswerDetails.objectForKey("TextAnswer") as? String
                {
                    studentAnswertext.text = TextAnswer
                }
                

            }
        }
        
        
        
        mScribbleView = SmoothLineView(frame: CGRectMake((questionView.frame.size.width - 270)/2,lineView.frame.origin.y + lineView.frame.size.height ,270,180))
        mScribbleView.delegate = self
        self.view.addSubview(mScribbleView);
        mScribbleView.userInteractionEnabled = true
        mScribbleView.setDrawingColor(standard_Red);
        mScribbleView.setBrushWidth(3)
        mScribbleView.setDrawingTool(kBrushTool)
        mScribbleView.hidden = false

        
        
        let lineView1 = UIImageView(frame:CGRectMake(20, 270, 280, 1))
        lineView1.backgroundColor = topicsLineColor
        questionView.addSubview(lineView1);
        
        
        mStarRatingView.setDelegate(self);
        mStarRatingView.backgroundColor = UIColor.clearColor();
        mStarRatingView.frame = CGRectMake(80, lineView1.frame.origin.y + lineView1.frame.size.height + 10, 210.0, 34.0);
        questionView.addSubview(mStarRatingView);
        mStarRatingView.setsizeOfStar(25)

    }
    
    func setStudentAnswerDetails(details:AnyObject, withStudentDetials StudentDict:AnyObject, withCurrentQuestionDict questionDict:AnyObject)
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
        modelAnswerButton.setTitleColor(UIColor.lightGrayColor() ,forState:.Normal);
        modelAnswerButton.enabled = false
        
    }
    
    
    // MARK: - Smooth line delegate
    
    func lineDrawnChanged()
    {
        
    }
    
    func setUndoButtonEnable(enable: NSNumber!) {
        
    }
    
    func setRedoButtonEnable(enable: NSNumber!) {
        
    }
    
    
    func onAnnotateButton()
    {
        if delegate().respondsToSelector(Selector("delegateAnnotateButtonPressedWithAnswerDetails:withStudentDetails:withQuestionDetails:"))
        {
            
            
            delegate().delegateAnnotateButtonPressedWithAnswerDetails!(_studentAnswerDetails, withStudentDetails: _currentStudentDict, withQuestionDetails: _currentQuestiondetails)
            
            popover().dismissPopoverAnimated(true)
        }
    }
    
    // MARK: - sendFeedBack delegate
    
    func onDoneButton()
    {
        
        if isModelAnswer == true || mStarRatingView.rating() > 0 || mScribbleView.curImage != nil
        {
            sendButtonSpinner.hidden = false
            sendButtonSpinner.startAnimating()
            mDoneButton.hidden = true
            
            let currentDate = NSDate()
            
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = "yyyy-mm-dd HH:mm:ss"
            
            
            
            let currentDateString = dateFormatter.stringFromDate(currentDate)
            
            
            var nameOfImage  = "TT-\(SSTeacherDataSource.sharedDataSource.currentUserId)-\(SSTeacherDataSource.sharedDataSource.currentLiveSessionId)-\(currentDateString)"
            nameOfImage =  nameOfImage.stringByReplacingOccurrencesOfString(" ", withString: "")
            
            if mScribbleView.curImage != nil
            {
                
                imageUploading.uploadImageWithImage(mScribbleView.curImage, withImageName: nameOfImage, withUserId: SSTeacherDataSource.sharedDataSource.currentUserId)
            }
            else
            {
                newImageUploadedWithName(nameOfImage)
            }
            
            
            
        }
        else
        {
            popover().dismissPopoverAnimated(true)
        }
        
        
        
    }
    
    
    func newImageUploadedWithName(imageName:String)
    {
        if let AssessmentAnswerId = _studentAnswerDetails.objectForKey("AssessmentAnswerId") as? String
        {
            
            
            feedBackDetails.setObject(_currentStudentDict.objectForKey("StudentId")!, forKey: "StudentId")
            
            feedBackDetails.setObject(AssessmentAnswerId, forKey: "AssessmentAnswerId")
            
            feedBackDetails.setObject("\(mStarRatingView.rating())", forKey: "Rating")
            
            feedBackDetails.setObject("upload/\(imageName).png", forKey: "imageUrl")
            
            feedBackDetails.setObject("0", forKey: "BadgeId")
            
            feedBackDetails.setObject("", forKey: "textRating")
            
            feedBackDetails.setObject("\(isModelAnswer)", forKey: "ModelAnswerFlag")
            
            SSTeacherDataSource.sharedDataSource.sendFeedbackToStudentWithDetails(feedBackDetails, WithDelegate: self)
            
        }
    }
    
    func didGetFeedbackSentWithDetails(details: AnyObject)
    {
        
        
        if let studentId = details.objectForKey("Students")!.objectForKey("Student")!.objectForKey("StudentId") as? String
        {
            if let AssessmentAnswerId = details.objectForKey("AssessmentAnswerId") as? String
            {
                SSTeacherMessageHandler.sharedMessageHandler.sendFeedbackToStudentWitId(studentId, withassesmentAnswerId: AssessmentAnswerId)
                
                if delegate().respondsToSelector(Selector("delegateSubmissionEvalauatedWithAnswerDetails:withEvaluationDetail:withStudentId:"))
                {
                    
                    delegate().delegateSubmissionEvalauatedWithAnswerDetails!(_studentAnswerDetails, withEvaluationDetail: feedBackDetails, withStudentId: studentId)
                    
                }
                popover().dismissPopoverAnimated(true)
            }
        }
    }
    
    
    
    
    // MARK: - ImageUploading delegate
    
    func ImageUploadedWithName(name: String!)
    {
        newImageUploadedWithName(name)
    }
    
    func ErrorInUploadingWithName(name: String!)
    {
        sendButtonSpinner.hidden = true
        sendButtonSpinner.stopAnimating()
        mDoneButton.hidden = false
        mScribbleView.clearButtonClicked()
    }
    
    
    
    
}