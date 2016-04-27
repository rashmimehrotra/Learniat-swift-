//
//  StudentEvaluationDetails.swift
//  LearniatTeacher
//
//  Created by Deepak MK on 13/04/16.
//  Copyright © 2016 Mindshift. All rights reserved.
//

import Foundation
class StudentEvaluationDetails: UIViewController,SSStarRatingViewDelegate
{
    var _delgate: AnyObject!
    
    
    var _studentAnswerDetails:AnyObject!
    
    var _currentStudentDict:AnyObject!
    
    var _currentQuestiondetails:AnyObject!
    
    var _currentEvaluationDetails:AnyObject!
    
    var _Popover:AnyObject!
    
    
    func setdelegate(delegate:AnyObject)
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
        
        
        
        
        
        let questionView = UIView(frame: CGRectMake(0, 0, 320, 320))
        self.view.addSubview(questionView)
        questionView.backgroundColor = whiteBackgroundColor
        
        
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
        
        
        
        let  mDoneButton = UIButton(frame: CGRectMake(headerView.frame.size.width - 120, 0, 100, 40))
        mDoneButton.addTarget(self, action: #selector(StudentEvaluationDetails.onDoneButton), forControlEvents: UIControlEvents.TouchUpInside)
        mDoneButton.setTitleColor(standard_Button, forState: .Normal)
        mDoneButton.setTitle("Done", forState: .Normal)
        mDoneButton.contentHorizontalAlignment = UIControlContentHorizontalAlignment.Right
        mDoneButton.titleLabel?.font = UIFont(name: helveticaMedium, size: 20)
        headerView.addSubview(mDoneButton)
        
        
        
        
       
        let mStarRatingView = StudentStarView(frame: CGRectMake(20, headerView.frame.origin.y + headerView.frame.size.height + 5, headerView.frame.size.width - 90 , 34.0))
        mStarRatingView.backgroundColor = UIColor.clearColor();
        
        if let Rating = _currentEvaluationDetails.objectForKey("Rating") as? String
        {
            if Int(Rating) > 0
            {
                
                questionView.addSubview(mStarRatingView);
                mStarRatingView.addStarsWithRatings(Int32(Rating)!, withSize: Float(mStarRatingView.frame.size.height))

            }
            
        }
        
  
        
        if let BadgeId = _currentEvaluationDetails.objectForKey("BadgeId") as? String
        {
            if Int(BadgeId) > 0
            {
                let imageLoader = ImageUploading()
                
                let BadgeIdImage = UIImageView(frame: CGRectMake(headerView.frame.size.width - 80, headerView.frame.origin.y + headerView.frame.size.height + 10 ,40,34.0))
                BadgeIdImage.contentMode = .ScaleAspectFit
                BadgeIdImage.image = imageLoader.getImageWithBadgeId(Int32(BadgeId)!)
                questionView.addSubview(BadgeIdImage)
            }
        }
        
        
        
       
        let lineView = UIImageView(frame:CGRectMake(20, mStarRatingView.frame.origin.y + mStarRatingView.frame.size.height + 5 , 280, 1))
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
                    let overLayImageView = CustomProgressImageView(frame: CGRectMake((questionView.frame.size.width - 270)/2,lineView.frame.origin.y + 2 ,270,180))
                    questionView.addSubview(overLayImageView)
                    
                    
                    let urlString = NSUserDefaults.standardUserDefaults().objectForKey(k_INI_QuestionsImageUrl) as! String
                    
                    if let checkedUrl = NSURL(string: "\(urlString)/\(overlayImage)")
                    {
                        overLayImageView.contentMode = .ScaleAspectFit
                        overLayImageView.downloadImage(checkedUrl, withFolderType: folderType.questionImage,withResizeValue: overLayImageView.frame.size)
                    }
                    
                }
                
                
                let studentAnswerImage = CustomProgressImageView(frame: CGRectMake((questionView.frame.size.width - 270)/2,lineView.frame.origin.y + lineView.frame.size.height ,270,180))
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
        
        
        
        if let teacherScribble = _currentEvaluationDetails.objectForKey("imageUrl") as? String
        {
            let overLayImage = CustomProgressImageView(frame: CGRectMake((questionView.frame.size.width - 270)/2,lineView.frame.origin.y + lineView.frame.size.height ,270,180))
            questionView.addSubview(overLayImage)
            
            
            let urlString = NSUserDefaults.standardUserDefaults().objectForKey(k_INI_QuestionsImageUrl) as! String
            
            if let checkedUrl = NSURL(string: "\(urlString)/\(teacherScribble)")
            {
                overLayImage.contentMode = .ScaleAspectFit
                overLayImage.downloadImage(checkedUrl, withFolderType: folderType.questionImage,withResizeValue: questionView.frame.size)
            }
            
        }
        
        
        
        let lineView1 = UIImageView(frame:CGRectMake(20, 270, 280, 1))
        lineView1.backgroundColor = topicsLineColor
        questionView.addSubview(lineView1);
        
        
        
        let mTextImage = UIImageView(frame: CGRectMake(10, lineView1.frame.origin.y + lineView1.frame.size.height + 10 ,40,34.0))
        mTextImage.contentMode = .ScaleAspectFit
        mTextImage.image = UIImage(named: "Text_on_desk.png")
        questionView.addSubview(mTextImage)

        
        if let textRating = _currentEvaluationDetails.objectForKey("textRating") as? String
        {
            let teacherReplyText = UILabel(frame: CGRectMake(lineView1.frame.origin.x + lineView1.frame.size.width + 10,lineView1.frame.origin.y + lineView1.frame.size.height + 10 ,260,34.0))
            questionView.addSubview(teacherReplyText)
            teacherReplyText.font = UIFont(name: helveticaRegular, size: 16)
            teacherReplyText.textColor = blackTextColor
            teacherReplyText.lineBreakMode = .ByTruncatingMiddle
            teacherReplyText.numberOfLines = 10
            teacherReplyText.textAlignment = .Center
            teacherReplyText.text = textRating

        }
        
        
       
        
    }
    
    func setStudentAnswerDetails(details:AnyObject, withStudentDetials StudentDict:AnyObject, withCurrentQuestionDict questionDict:AnyObject, withEvaluationDetails evaluationDetails:AnyObject)
    {
        _studentAnswerDetails = details
        _currentStudentDict = StudentDict
        _currentQuestiondetails = questionDict
        
        _currentEvaluationDetails = evaluationDetails
    }
    
    
    
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
        popover().dismissPopoverAnimated(true)
        
    }
    
    func starRatingDidChange()
    {
        
    }
    
}