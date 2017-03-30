//
//  SubjectiveStudentContainer.swift
//  LearniatTeacher
//
//  Created by Deepak MK on 07/04/16.
//  Copyright © 2016 Mindshift. All rights reserved.
//

import Foundation


let kSelected           = "Selected"
let kUnSelected         = "Un-Selected"



@objc protocol SubjectiveStudentContainerDelegate
{
    
    @objc optional func delegateCheckmarkPressedWithState(_ state:Bool, withStudentDetails studentDetails:AnyObject, withAnswerDetails answerDetails:AnyObject)
    
    
    
}


class SubjectiveStudentContainer: UIView
{
    var _delgate: AnyObject!
    
    var _currentStudentAnswerDetails:AnyObject!
    
    var _currentStudentDetails :AnyObject!
    
    var mScrollView = UIScrollView()
    
    var selectAllImageview = UIImageView()
    
    let mOverlayImageView = CustomProgressImageView()
    
    let mSubmissionImageView = CustomProgressImageView()
    
    let  mProgressView = YLProgressBar()
    
    let mStudentImageView = CustomProgressImageView()
    
    let mStudentNameLabel = UILabel()
    
    let studentSubmissionLabel = UILabel()
    
    let checkBoxImage = UIImageView()
    
    var currentSelectionState = kUnSelected
    
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
        
                
                
       let mRoundedContainerView = UIImageView(frame:CGRect(x: 5,y: 5, width: self.frame.size.width - 10 , height: self.frame.size.height - 10 ));
        mRoundedContainerView.backgroundColor = UIColor.clear
        self.addSubview(mRoundedContainerView);
        mRoundedContainerView.isUserInteractionEnabled = true
       
        
        
        mStudentImageView.frame = CGRect(x: 0 , y: 0, width: 40, height: 40)
        mRoundedContainerView.addSubview(mStudentImageView);

        
        
        
        let overlayBackground = LBorderView(frame:CGRect(x: 0, y: mStudentImageView.frame.size.height + 5 , width: mRoundedContainerView.frame.size.width, height: mRoundedContainerView.frame.size.width / kAspectRation))
        
        overlayBackground.borderType = BorderTypeDashed;
        overlayBackground.dashPattern = 4;
        overlayBackground.spacePattern = 4;
        overlayBackground.borderWidth = 1;
        overlayBackground.borderColor = LineGrayColor;
        mRoundedContainerView.addSubview(overlayBackground);
        overlayBackground.backgroundColor = UIColor.white
        
        
        mOverlayImageView.frame = overlayBackground.frame;
        mOverlayImageView.image = nil;
        mOverlayImageView.isHidden = false;
        mRoundedContainerView.addSubview(mOverlayImageView);
        mOverlayImageView.isHidden = true
        mOverlayImageView.backgroundColor = UIColor.clear
    
    
    
         mSubmissionImageView.frame =  overlayBackground.frame
        mSubmissionImageView.image = nil;
        mSubmissionImageView.isHidden = false;
        mRoundedContainerView.addSubview(mSubmissionImageView);
        mSubmissionImageView.isHidden = true
    
        
        
        

      
        

        
        
         mProgressView.frame = CGRect(x: mStudentImageView.frame.origin.x  + mStudentImageView.frame.size.width + 10 ,y: mStudentImageView.frame.origin.y  + mStudentImageView.frame.size.height - 4 , width: mRoundedContainerView.frame.size.width - (mStudentImageView.frame.origin.x  + mStudentImageView.frame.size.width + 10) ,height: 4)
        mRoundedContainerView.addSubview(mProgressView);
        mProgressView.progressTintColor = standard_Red
        mProgressView.isHidden            = false
        mProgressView.type              = .flat;
        mProgressView.isStripesAnimated   = false;
        mProgressView.hideStripes       = true;
        mProgressView.trackTintColor    = progressviewBackground
        
        
        
        
        
        
        
        mStudentNameLabel.frame = CGRect(x: mProgressView.frame.origin.x ,y: mProgressView.frame.origin.y - 22 ,width: mProgressView.frame.size.width - 20 ,height: 20)
        mStudentNameLabel.text = ""
        mStudentNameLabel.font = UIFont(name: helveticaMedium, size: 14);
        mStudentNameLabel.textAlignment = .left;
        mStudentNameLabel.textColor = UIColor.white
        mRoundedContainerView.addSubview(mStudentNameLabel);
        
        
        studentSubmissionLabel.frame =  overlayBackground.frame
        studentSubmissionLabel.text = ""
        studentSubmissionLabel.font = UIFont(name: helveticaRegular, size: 14);
        studentSubmissionLabel.textAlignment = .center
        studentSubmissionLabel.textColor = blackTextColor
        self.addSubview(studentSubmissionLabel)
        studentSubmissionLabel.numberOfLines = 10;
        studentSubmissionLabel.isHidden = true
        
       
        let m_checkBoxButton = UIButton(frame:CGRect(x: 0, y: 0, width: mRoundedContainerView.frame.size.width,height: mRoundedContainerView.frame.size.height));
        mRoundedContainerView.addSubview(m_checkBoxButton);
        
        checkBoxImage.frame = CGRect(x: mRoundedContainerView.frame.size .width - 20 , y: 0,width: 20,height: 20)
        
        checkBoxImage.image = UIImage(named:"Unchecked.png");
        
        mRoundedContainerView.addSubview(checkBoxImage);
        m_checkBoxButton.addTarget(self, action: #selector(SubjectiveStudentContainer.checkMarkPressedWith), for: UIControlEvents.touchUpInside)
                
                // Initialization code
        
        
    }
    
    
    required init?(coder aDecoder: NSCoder)
    {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    func setStudentAnswerDetails(_ answerDetails:AnyObject, withStudentDetails studentDict:AnyObject, withOverlay overlay:String)
    {
        
               
        mOverlayImageView.isHidden = true
        mSubmissionImageView.isHidden = true
        studentSubmissionLabel.isHidden = true

        _currentStudentAnswerDetails = answerDetails
        
        _currentStudentDetails = studentDict
        
        
        if let StudentName = studentDict.object(forKey: "Name") as? String
        {
            mStudentNameLabel.text = StudentName
        }
        
        if let StudentId = studentDict.object(forKey: "StudentId") as? String
        {
            let urlString = UserDefaults.standard.object(forKey: k_INI_UserProfileImageURL) as! String
            
            if let checkedUrl = URL(string: "\(urlString)/\(StudentId)_79px.jpg")
            {
                mStudentImageView.contentMode = .scaleAspectFit
                mStudentImageView.downloadImage(checkedUrl, withFolderType: folderType.proFilePics, withResizeValue:mStudentImageView.frame.size)
            }
        }
        
        
       if let grasp = studentDict.object(forKey: "GraspIndex") as? NSString
       {
        
            var graspIndexValue = grasp.floatValue
            
            var  tintColor  = standard_Red
            
            if (graspIndexValue<=33)
            {
                tintColor = standard_Red;
            }
            else if (graspIndexValue>33 && graspIndexValue<=66)
            {
                tintColor = standard_Yellow
            }
            else
            {
                tintColor = standard_Green
            }
            
            if (graspIndexValue>0)
            {
                graspIndexValue = graspIndexValue / 100;
            }
            
            mProgressView.progressTintColor  = tintColor;
            
            mProgressView.setProgress(CGFloat(graspIndexValue), animated: true)
        }
        
        
        
        if let Scribble = answerDetails.object(forKey: "Scribble") as? String
        {
            let urlString = UserDefaults.standard.object(forKey: k_INI_SCRIBBLE_IMAGE_URL) as! String
            
            if let checkedUrl = URL(string: "\(urlString)/\(Scribble)")
            {
                mSubmissionImageView.contentMode = .scaleAspectFit
                mSubmissionImageView.downloadImage(checkedUrl, withFolderType: folderType.studentAnswer,withResizeValue: mSubmissionImageView.frame.size)
            }
            mSubmissionImageView.isHidden = false
        }
        
        
        if overlay != ""
        {
            let urlString = UserDefaults.standard.object(forKey: k_INI_SCRIBBLE_IMAGE_URL) as! String
            
            if let checkedUrl = URL(string: "\(urlString)/\(overlay)")
            {
                mOverlayImageView.contentMode = .scaleAspectFit
                mOverlayImageView.downloadImage(checkedUrl, withFolderType: folderType.questionImage,withResizeValue: mOverlayImageView.frame.size)
            }
            mOverlayImageView.isHidden = false
        }
        
        
        if let TextAnswer = answerDetails.object(forKey: "TextAnswer") as? String
        {
            
            
            studentSubmissionLabel.text = " \(TextAnswer)"
            studentSubmissionLabel.isHidden = false
            
            
        }
    }
    
    
    
    func checkMarkPressedWith()
    {
        if currentSelectionState == kUnSelected
        {
            
            
            currentSelectionState = kSelected
            
            checkBoxImage.image = UIImage(named:"Checked.png");
            
            
            
            if delegate().responds(to: #selector(SubjectiveStudentContainerDelegate.delegateCheckmarkPressedWithState(_:withStudentDetails:withAnswerDetails:)))
            {
                delegate().delegateCheckmarkPressedWithState!(true, withStudentDetails: _currentStudentDetails, withAnswerDetails: _currentStudentAnswerDetails)
            }
            
            
            
            
        }
        else
        {
            currentSelectionState = kUnSelected
            checkBoxImage.image = UIImage(named:"Unchecked.png");
            
            if delegate().responds(to: #selector(SubjectiveStudentContainerDelegate.delegateCheckmarkPressedWithState(_:withStudentDetails:withAnswerDetails:)))
            {
                delegate().delegateCheckmarkPressedWithState!(false, withStudentDetails: _currentStudentDetails, withAnswerDetails: _currentStudentAnswerDetails)
            }
            
        }
        
        
    }
    
    
    
    
    
}
