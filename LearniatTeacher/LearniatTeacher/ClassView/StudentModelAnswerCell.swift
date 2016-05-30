//
//  StudentModelAnswerCell.swift
//  LearniatTeacher
//
//  Created by Deepak MK on 04/05/16.
//  Copyright © 2016 Mindshift. All rights reserved.
//

import Foundation

@objc protocol StudentModelAnswerCellDelegate
{
    
    
    optional func delegateModelAnswerRemovedWithAssesmentAnswerId(assesmentAnswerID:String)
    
    
}

class StudentModelAnswerCell: UIView,SSTeacherDataSourceDelegate
{
    
    var studentImage    = CustomProgressImageView()
    
    var StudentName     = UILabel()
    
    var RemoveButton        = UIButton()
    
    var currentCellDetails  :AnyObject!
    
    var answerContainerView     = UIView()
    
    
    var _delgate: AnyObject!
    
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
        super.init(frame: frame)
        
        studentImage.frame = CGRectMake(10, 5, 40, 40)
        self.addSubview(studentImage)
        
        
        StudentName.frame = CGRectMake(55, 5, 120, 40)
        StudentName.backgroundColor = UIColor.clearColor();
        StudentName.hidden = false
        StudentName.textAlignment = .Left;
        StudentName.numberOfLines=10;
        StudentName.lineBreakMode = .ByTruncatingMiddle
        StudentName.textColor = blackTextColor
        
        
        RemoveButton.frame = CGRectMake(self.frame.size.width  -   110  , 5, 100 ,40)
        RemoveButton.backgroundColor = UIColor.clearColor()
        self.addSubview(RemoveButton)
        RemoveButton.setTitle("Remove", forState: .Normal)
        RemoveButton.setTitleColor(standard_Button, forState: .Normal)
        RemoveButton.contentHorizontalAlignment = UIControlContentHorizontalAlignment.Right
        RemoveButton.titleLabel!.font = UIFont(name:helveticaMedium, size: 18)
         RemoveButton.addTarget(self, action: #selector(StudentModelAnswerCell.onRemoveButton), forControlEvents: UIControlEvents.TouchUpInside)
       
        let lineView = UIImageView(frame:CGRectMake(0, 50, self.frame.size.width, 1))
        lineView.backgroundColor = LineGrayColor
        self.addSubview(lineView)
        
        answerContainerView.frame = CGRectMake(0, 50, self.frame.size.width, self.frame.size.width / 1.5)
        self.addSubview(answerContainerView)

        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setModelAnswerWithDetails(details:AnyObject)
    {
        currentCellDetails = details
        
        
        print(details)
        
        if let StudentId = details.objectForKey("StudentId") as? String
        {
            let urlString = NSUserDefaults.standardUserDefaults().objectForKey(k_INI_UserProfileImageURL) as! String
            
            if let checkedUrl = NSURL(string: "\(urlString)/\(StudentId)_79px.jpg")
            {
                studentImage.contentMode = .ScaleAspectFit
                studentImage.downloadImage(checkedUrl, withFolderType: folderType.ProFilePics)
            }
        }
        
        studentImage.layer.cornerRadius = 4
        
        studentImage.layer.masksToBounds = true
        
        if let _StudentName = details.objectForKey("StudentName") as? String
        {
            StudentName.text = _StudentName
        }

        
        
        if let TeacherScribble = details.objectForKey("TeacherScribble") as? String
        {
            let overLayImage = CustomProgressImageView(frame: CGRectMake(0,0,answerContainerView.frame.size.width,answerContainerView.frame.size.height))
            answerContainerView.addSubview(overLayImage)
            
            
            let urlString = NSUserDefaults.standardUserDefaults().objectForKey(k_INI_QuestionsImageUrl) as! String
            
            if let checkedUrl = NSURL(string: "\(urlString)/\(TeacherScribble)")
            {
                overLayImage.contentMode = .ScaleAspectFit
                overLayImage.downloadImage(checkedUrl, withFolderType: folderType.questionImage,withResizeValue: answerContainerView.frame.size)
            }
            
        }
        
        
        if SSTeacherDataSource.sharedDataSource.mOverlayImageName != ""
        {
            
            let studentAnswerImage = CustomProgressImageView(frame: CGRectMake(0,0,answerContainerView.frame.size.width,answerContainerView.frame.size.height))
            answerContainerView.addSubview(studentAnswerImage)
            
            
            let urlString = NSUserDefaults.standardUserDefaults().objectForKey(k_INI_SCRIBBLE_IMAGE_URL) as! String
            
            if let checkedUrl = NSURL(string: "\(urlString)/\(SSTeacherDataSource.sharedDataSource.mOverlayImageName)")
            {
                studentAnswerImage.contentMode = .ScaleAspectFit
                studentAnswerImage.downloadImage(checkedUrl, withFolderType: folderType.questionImage,withResizeValue: answerContainerView.frame.size)
            }
        }
        
        
        
        if let Scribble = details.objectForKey("Image") as? String
        {
            
            let studentAnswerImage = CustomProgressImageView(frame: CGRectMake(0,0,answerContainerView.frame.size.width,answerContainerView.frame.size.height))
            answerContainerView.addSubview(studentAnswerImage)

            
            let urlString = NSUserDefaults.standardUserDefaults().objectForKey(k_INI_SCRIBBLE_IMAGE_URL) as! String
            
            if let checkedUrl = NSURL(string: "\(urlString)/\(Scribble)")
            {
                studentAnswerImage.contentMode = .ScaleAspectFit
                studentAnswerImage.downloadImage(checkedUrl, withFolderType: folderType.StudentAnswer,withResizeValue: answerContainerView.frame.size)
            }
        }
        else if let TextAnswer = details.objectForKey("TextAnswer") as? String
        {
            let studentAnswertext = UILabel(frame: CGRectMake((self.frame.size.width - (self.frame.size.width - 5))/2  ,(self.frame.size.height-(self.frame.size.height - 5 ))/2,self.frame.size.width - 5,self.frame.size.height - 5 ))
            self.addSubview(studentAnswertext)
            
            var fontHeight = studentAnswertext.frame.size.height/3;
            
            if (fontHeight > 16)
            {
                fontHeight = 16;
            }
            
            studentAnswertext.font = UIFont(name: helveticaRegular, size: fontHeight)
            studentAnswertext.textColor = blackTextColor
            studentAnswertext.lineBreakMode = .ByTruncatingMiddle
            studentAnswertext.numberOfLines = 10
            studentAnswertext.textAlignment = .Center
            studentAnswertext.text = TextAnswer
            

        }
    }
    
    func onRemoveButton()
    {
        self.removeFromSuperview()
        
        if let  AssessmentAnswerId = currentCellDetails.objectForKey("AssessmentAnswerId") as? String
        {
            delegate().delegateModelAnswerRemovedWithAssesmentAnswerId!(AssessmentAnswerId)
            
            SSTeacherDataSource.sharedDataSource.recordModelAnswerwithAssesmentAnswerId(AssessmentAnswerId, WithDelegate: self)
        }
    }
    
}