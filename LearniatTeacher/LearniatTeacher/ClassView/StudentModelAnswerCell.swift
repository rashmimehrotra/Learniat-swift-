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
    
    
    @objc optional func delegateModelAnswerRemovedWithAssesmentAnswerId(_ assesmentAnswerID:String)
    
    
}

class StudentModelAnswerCell: UIView,SSTeacherDataSourceDelegate
{
    
    var studentImage    = CustomProgressImageView()
    
    var StudentName     = UILabel()
    
    var RemoveButton        = UIButton()
    
    var currentCellDetails  :AnyObject!
    
    var answerContainerView     = UIView()
    
    
    var _delgate: AnyObject!
    
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
        
        studentImage.frame = CGRect(x: 10, y: 5, width: 40, height: 40)
        self.addSubview(studentImage)
        
        
        StudentName.frame = CGRect(x: 55, y: 5, width: 120, height: 40)
        StudentName.backgroundColor = UIColor.clear;
        StudentName.isHidden = false
        StudentName.textAlignment = .left;
        StudentName.numberOfLines=10;
        StudentName.lineBreakMode = .byTruncatingMiddle
        StudentName.textColor = blackTextColor
        
        
        RemoveButton.frame = CGRect(x: self.frame.size.width  -   110  , y: 5, width: 100 ,height: 40)
        RemoveButton.backgroundColor = UIColor.clear
        self.addSubview(RemoveButton)
        RemoveButton.setTitle("Remove", for: UIControlState())
        RemoveButton.setTitleColor(standard_Button, for: UIControlState())
        RemoveButton.contentHorizontalAlignment = UIControlContentHorizontalAlignment.right
        RemoveButton.titleLabel!.font = UIFont(name:helveticaMedium, size: 18)
         RemoveButton.addTarget(self, action: #selector(StudentModelAnswerCell.onRemoveButton), for: UIControlEvents.touchUpInside)
       
        let lineView = UIImageView(frame:CGRect(x: 0, y: 50, width: self.frame.size.width, height: 1))
        lineView.backgroundColor = LineGrayColor
        self.addSubview(lineView)
        
        answerContainerView.frame = CGRect(x: 0, y: 50, width: self.frame.size.width, height: self.frame.size.width / 1.5)
        self.addSubview(answerContainerView)

        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setModelAnswerWithDetails(_ details:AnyObject)
    {
        currentCellDetails = details
        
        
        print(details)
        
        if let StudentId = details.object(forKey: "StudentId") as? String
        {
            let urlString = UserDefaults.standard.object(forKey: k_INI_UserProfileImageURL) as! String
            
            if let checkedUrl = URL(string: "\(urlString)/\(StudentId)_79px.jpg")
            {
                studentImage.contentMode = .scaleAspectFit
                studentImage.downloadImage(checkedUrl, withFolderType: folderType.proFilePics)
            }
        }
        
        studentImage.layer.cornerRadius = 4
        
        studentImage.layer.masksToBounds = true
        
        if let _StudentName = details.object(forKey: "StudentName") as? String
        {
            StudentName.text = _StudentName
        }

        
        
        if let TeacherScribble = details.object(forKey: "TeacherScribble") as? String
        {
            let overLayImage = CustomProgressImageView(frame: CGRect(x: 0,y: 0,width: answerContainerView.frame.size.width,height: answerContainerView.frame.size.height))
            answerContainerView.addSubview(overLayImage)
            
            
            let urlString = UserDefaults.standard.object(forKey: k_INI_QuestionsImageUrl) as! String
            
            if let checkedUrl = URL(string: "\(urlString)/\(TeacherScribble)")
            {
                overLayImage.contentMode = .scaleAspectFit
                overLayImage.downloadImage(checkedUrl, withFolderType: folderType.questionImage,withResizeValue: answerContainerView.frame.size)
            }
            
        }
        
        
        if SSTeacherDataSource.sharedDataSource.mOverlayImageName != ""
        {
            
            let studentAnswerImage = CustomProgressImageView(frame: CGRect(x: 0,y: 0,width: answerContainerView.frame.size.width,height: answerContainerView.frame.size.height))
            answerContainerView.addSubview(studentAnswerImage)
            
            
            let urlString = UserDefaults.standard.object(forKey: k_INI_SCRIBBLE_IMAGE_URL) as! String
            
            if let checkedUrl = URL(string: "\(urlString)/\(SSTeacherDataSource.sharedDataSource.mOverlayImageName)")
            {
                studentAnswerImage.contentMode = .scaleAspectFit
                studentAnswerImage.downloadImage(checkedUrl, withFolderType: folderType.questionImage,withResizeValue: answerContainerView.frame.size)
            }
        }
        
        
        
        if let Scribble = details.object(forKey: "Image") as? String
        {
            
            let studentAnswerImage = CustomProgressImageView(frame: CGRect(x: 0,y: 0,width: answerContainerView.frame.size.width,height: answerContainerView.frame.size.height))
            answerContainerView.addSubview(studentAnswerImage)

            
            let urlString = UserDefaults.standard.object(forKey: k_INI_SCRIBBLE_IMAGE_URL) as! String
            
            if let checkedUrl = URL(string: "\(urlString)/\(Scribble)")
            {
                studentAnswerImage.contentMode = .scaleAspectFit
                studentAnswerImage.downloadImage(checkedUrl, withFolderType: folderType.studentAnswer,withResizeValue: answerContainerView.frame.size)
            }
        }
        else if let TextAnswer = details.object(forKey: "TextAnswer") as? String
        {
            let studentAnswertext = UILabel(frame: CGRect(x: (self.frame.size.width - (self.frame.size.width - 5))/2  ,y: (self.frame.size.height-(self.frame.size.height - 5 ))/2,width: self.frame.size.width - 5,height: self.frame.size.height - 5 ))
            self.addSubview(studentAnswertext)
            
            var fontHeight = studentAnswertext.frame.size.height/3;
            
            if (fontHeight > 16)
            {
                fontHeight = 16;
            }
            
            studentAnswertext.font = UIFont(name: helveticaRegular, size: fontHeight)
            studentAnswertext.textColor = blackTextColor
            studentAnswertext.lineBreakMode = .byTruncatingMiddle
            studentAnswertext.numberOfLines = 10
            studentAnswertext.textAlignment = .center
            studentAnswertext.text = TextAnswer
            

        }
    }
    
    func onRemoveButton()
    {
        self.removeFromSuperview()
        
        if let  AssessmentAnswerId = currentCellDetails.object(forKey: "AssessmentAnswerId") as? String
        {
            delegate().delegateModelAnswerRemovedWithAssesmentAnswerId!(AssessmentAnswerId)
            
            SSTeacherDataSource.sharedDataSource.recordModelAnswerwithAssesmentAnswerId(AssessmentAnswerId, WithDelegate: self)
        }
    }
    
}
