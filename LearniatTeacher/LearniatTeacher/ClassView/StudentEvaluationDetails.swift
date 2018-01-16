//
//  StudentEvaluationDetails.swift
//  LearniatTeacher
//
//  Created by Deepak MK on 13/04/16.
//  Copyright © 2016 Mindshift. All rights reserved.
//

import Foundation
// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}

// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func > <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l > r
  default:
    return rhs < lhs
  }
}




@objc protocol StudentEvaluationDetailsDelegate {
    @objc optional func delegateModelAnswerAdded(studentId:String)
}

class StudentEvaluationDetails: UIViewController,SSStarRatingViewDelegate,SSTeacherDataSourceDelegate
{
    var _delgate: AnyObject!
    
    
    var _studentAnswerDetails:AnyObject!
    
    var _currentStudentDict:AnyObject!
    
    var _currentQuestiondetails:AnyObject!
    
    var _currentEvaluationDetails = NSMutableDictionary()
    
    
    
    func setdelegate(_ delegate:AnyObject)
    {
        _delgate = delegate;
    }
    
    func   delegate()->AnyObject
    {
        return _delgate;
    }
    
    
    
    
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        
        //        self.view.setNeedsLayout()
        //        self.view.layoutIfNeeded()
        
        
        
        
        
        let questionView = UIView(frame: CGRect(x: 0, y: 0, width: 320, height: 320))
        self.view.addSubview(questionView)
        questionView.backgroundColor = whiteBackgroundColor
        
        
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
        
        
        print(_currentEvaluationDetails)
        let  mDoneButton = UIButton(frame: CGRect(x: headerView.frame.size.width - 120, y: 0, width: 100, height: 40))
        mDoneButton.addTarget(self, action: #selector(StudentEvaluationDetails.onDoneButton), for: UIControlEvents.touchUpInside)
        mDoneButton.setTitleColor(standard_Button, for: UIControlState())
        mDoneButton.setTitle("Done", for: UIControlState())
        mDoneButton.contentHorizontalAlignment = UIControlContentHorizontalAlignment.right
        mDoneButton.titleLabel?.font = UIFont(name: helveticaMedium, size: 20)
        headerView.addSubview(mDoneButton)
        
        
        let modelAnswerButton = UIButton()
        if let ModelAnswerFlag = _currentEvaluationDetails.object(forKey: "ModelAnswerFlag") as? String {
            if ModelAnswerFlag == "false" {
                
                modelAnswerButton.isEnabled = true
                modelAnswerButton.setTitle("Mark Model", for:UIControlState())
                modelAnswerButton.setTitleColor(standard_Button ,for:UIControlState());
                modelAnswerButton.addTarget(self, action: #selector(onModelAnswer(sender:)), for: UIControlEvents.touchUpInside)
                modelAnswerButton.frame = CGRect(x: 20, y: 45, width: 130, height: 40);
                questionView.addSubview(modelAnswerButton);
                modelAnswerButton.contentHorizontalAlignment = UIControlContentHorizontalAlignment.left
            }
        }
       
        let mStarRatingView = StudentStarView(frame: CGRect(x: modelAnswerButton.frame.origin.x + modelAnswerButton.frame.size.width + 10, y: headerView.frame.origin.y + headerView.frame.size.height + 5, width: headerView.frame.size.width - (modelAnswerButton.frame.origin.x + modelAnswerButton.frame.size.width + 10) , height: 34.0))
        mStarRatingView.backgroundColor = UIColor.clear;
        if let Rating = _currentEvaluationDetails.object(forKey: "Rating") as? String {
            if Int(Rating) > 0 {
                questionView.addSubview(mStarRatingView);
                mStarRatingView.addStars(withRatings: Int32(Rating)!, withSize: Float(mStarRatingView.frame.size.height))
            }
        }
        
  
        
        if let BadgeId = _currentEvaluationDetails.object(forKey: "BadgeId") as? String
        {
            if Int(BadgeId) > 0
            {
                let imageLoader = ImageUploading()
                
                let BadgeIdImage = UIImageView(frame: CGRect(x: headerView.frame.size.width - 80, y: headerView.frame.origin.y + headerView.frame.size.height + 10 ,width: 40,height: 34.0))
                BadgeIdImage.contentMode = .scaleAspectFit
                BadgeIdImage.image = imageLoader.getImageWithBadgeId(Int32(BadgeId)!)
                questionView.addSubview(BadgeIdImage)
            }
        }
        
        
        
       
        let lineView = UIImageView(frame:CGRect(x: 20, y: mStarRatingView.frame.origin.y + mStarRatingView.frame.size.height + 5 , width: 280, height: 1))
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
        
        
        
        if let teacherScribble = _currentEvaluationDetails.object(forKey: "imageUrl") as? String
        {
            let overLayImage = CustomProgressImageView(frame: CGRect(x: (questionView.frame.size.width - 270)/2,y: lineView.frame.origin.y + lineView.frame.size.height ,width: 270,height: 180))
            questionView.addSubview(overLayImage)
            
            
            let urlString = UserDefaults.standard.object(forKey: k_INI_QuestionsImageUrl) as! String
            
            if let checkedUrl = URL(string: "\(urlString)/\(teacherScribble)")
            {
                overLayImage.contentMode = .scaleAspectFit
                overLayImage.downloadImage(checkedUrl, withFolderType: folderType.questionImage,withResizeValue: questionView.frame.size)
            }
            
        }
        
        
        
        let lineView1 = UIImageView(frame:CGRect(x: 20, y: 270, width: 280, height: 1))
        lineView1.backgroundColor = topicsLineColor
        questionView.addSubview(lineView1);
        
        
        
        let mTextImage = UIImageView(frame: CGRect(x: 10, y: lineView1.frame.origin.y + lineView1.frame.size.height + 10 ,width: 40,height: 34.0))
        mTextImage.contentMode = .scaleAspectFit
        mTextImage.image = UIImage(named: "Text_on_desk.png")
        questionView.addSubview(mTextImage)

        
        if let textRating = _currentEvaluationDetails.object(forKey: "textRating") as? String
        {
            let teacherReplyText = UILabel(frame: CGRect(x: lineView1.frame.origin.x + lineView1.frame.size.width + 10,y: lineView1.frame.origin.y + lineView1.frame.size.height + 10 ,width: 260,height: 34.0))
            questionView.addSubview(teacherReplyText)
            teacherReplyText.font = UIFont(name: helveticaRegular, size: 16)
            teacherReplyText.textColor = blackTextColor
            teacherReplyText.lineBreakMode = .byTruncatingMiddle
            teacherReplyText.numberOfLines = 10
            teacherReplyText.textAlignment = .center
            teacherReplyText.text = textRating

        }
        
        
       
        
    }
    
    func setStudentAnswerDetails(_ details:AnyObject, withStudentDetials StudentDict:AnyObject, withCurrentQuestionDict questionDict:AnyObject, withEvaluationDetails evaluationDetails:AnyObject)
    {
        _studentAnswerDetails = details
        _currentStudentDict = StudentDict
        _currentQuestiondetails = questionDict
        
        _currentEvaluationDetails = evaluationDetails as! NSMutableDictionary
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
        popover().dismiss(animated: true)
        
    }
    
    func starRatingDidChange(){
        
    }
    
    func onModelAnswer(sender:UIButton) {
        if let AssessmentAnswerId = _currentEvaluationDetails.object(forKey: "AssessmentAnswerId") as? String {
            SSTeacherDataSource.sharedDataSource.recordModelAnswerwithAssesmentAnswerId(AssessmentAnswerId, WithDelegate: self)
            sender.removeFromSuperview()
            onDoneButton()
        }
    }
    
    func didGetModelAnswerRecordedWithDetails(_ details: AnyObject) {
        if let StudentId = _currentEvaluationDetails.object(forKey: "StudentId") as? String {
            delegate().delegateModelAnswerAdded!(studentId: StudentId)
             _currentEvaluationDetails.setObject("True", forKey: "ModelAnswerFlag" as NSCopying)
        }
       
    }
}
