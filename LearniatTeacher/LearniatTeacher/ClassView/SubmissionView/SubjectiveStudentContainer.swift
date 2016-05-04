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
    
    optional func delegateCheckmarkPressedWithState(state:Bool, withStudentDetails studentDetails:AnyObject, withAnswerDetails answerDetails:AnyObject)
    
    
    
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
        
                
                
       let mRoundedContainerView = UIImageView(frame:CGRectMake(5,5, self.frame.size.width - 10 , self.frame.size.height - 10 ));
        mRoundedContainerView.backgroundColor = UIColor.clearColor()
        self.addSubview(mRoundedContainerView);
        mRoundedContainerView.userInteractionEnabled = true
       
        
        
        mStudentImageView.frame = CGRectMake(0 , 0, 40, 40)
        mRoundedContainerView.addSubview(mStudentImageView);

        
        
        
        let overlayBackground = LBorderView(frame:CGRectMake(0, mStudentImageView.frame.size.height + 5 , mRoundedContainerView.frame.size.width, mRoundedContainerView.frame.size.width / kAspectRation))
        
        overlayBackground.borderType = BorderTypeDashed;
        overlayBackground.dashPattern = 4;
        overlayBackground.spacePattern = 4;
        overlayBackground.borderWidth = 1;
        overlayBackground.borderColor = LineGrayColor;
        mRoundedContainerView.addSubview(overlayBackground);
        overlayBackground.backgroundColor = UIColor.whiteColor()
        
        
        mOverlayImageView.frame = overlayBackground.frame;
        mOverlayImageView.image = nil;
        mOverlayImageView.hidden = false;
        mRoundedContainerView.addSubview(mOverlayImageView);
        mOverlayImageView.hidden = true
        mOverlayImageView.backgroundColor = UIColor.clearColor()
    
    
    
         mSubmissionImageView.frame =  overlayBackground.frame
        mSubmissionImageView.image = nil;
        mSubmissionImageView.hidden = false;
        mRoundedContainerView.addSubview(mSubmissionImageView);
        mSubmissionImageView.hidden = true
    
        
        
        

      
        

        
        
         mProgressView.frame = CGRectMake(mStudentImageView.frame.origin.x  + mStudentImageView.frame.size.width + 10 ,mStudentImageView.frame.origin.y  + mStudentImageView.frame.size.height - 4 , mRoundedContainerView.frame.size.width - (mStudentImageView.frame.origin.x  + mStudentImageView.frame.size.width + 10) ,4)
        mRoundedContainerView.addSubview(mProgressView);
        mProgressView.progressTintColor = standard_Red
        mProgressView.hidden            = false
        mProgressView.type              = .Flat;
        mProgressView.stripesAnimated   = false;
        mProgressView.hideStripes       = true;
        mProgressView.trackTintColor    = progressviewBackground
        
        
        
        
        
        
        
        mStudentNameLabel.frame = CGRectMake(mProgressView.frame.origin.x ,mProgressView.frame.origin.y - 22 ,mProgressView.frame.size.width - 20 ,20)
        mStudentNameLabel.text = ""
        mStudentNameLabel.font = UIFont(name: helveticaMedium, size: 14);
        mStudentNameLabel.textAlignment = .Left;
        mStudentNameLabel.textColor = UIColor.whiteColor()
        mRoundedContainerView.addSubview(mStudentNameLabel);
        
        
        studentSubmissionLabel.frame =  overlayBackground.frame
        studentSubmissionLabel.text = ""
        studentSubmissionLabel.font = UIFont(name: helveticaRegular, size: 14);
        studentSubmissionLabel.textAlignment = .Center
        studentSubmissionLabel.textColor = blackTextColor
        self.addSubview(studentSubmissionLabel)
        studentSubmissionLabel.numberOfLines = 10;
        studentSubmissionLabel.hidden = true
        
       
        let m_checkBoxButton = UIButton(frame:CGRectMake(0, 0, mRoundedContainerView.frame.size.width,mRoundedContainerView.frame.size.height));
        mRoundedContainerView.addSubview(m_checkBoxButton);
        
        checkBoxImage.frame = CGRectMake(mRoundedContainerView.frame.size .width - 20 , 0,20,20)
        
        checkBoxImage.image = UIImage(named:"Unchecked.png");
        
        mRoundedContainerView.addSubview(checkBoxImage);
        m_checkBoxButton.addTarget(self, action: #selector(SubjectiveStudentContainer.checkMarkPressedWith), forControlEvents: UIControlEvents.TouchUpInside)
                
                // Initialization code
        
        
    }
    
    
    required init?(coder aDecoder: NSCoder)
    {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    func setStudentAnswerDetails(answerDetails:AnyObject, withStudentDetails studentDict:AnyObject, withOverlay overlay:String)
    {
        
               
        mOverlayImageView.hidden = true
        mSubmissionImageView.hidden = true
        studentSubmissionLabel.hidden = true

        _currentStudentAnswerDetails = answerDetails
        
        _currentStudentDetails = studentDict
        
        
        if let StudentName = studentDict.objectForKey("Name") as? String
        {
            mStudentNameLabel.text = StudentName
        }
        
        if let StudentId = studentDict.objectForKey("StudentId") as? String
        {
            let urlString = NSUserDefaults.standardUserDefaults().objectForKey(k_INI_UserProfileImageURL) as! String
            
            if let checkedUrl = NSURL(string: "\(urlString)/\(StudentId)_79px.jpg")
            {
                mStudentImageView.contentMode = .ScaleAspectFit
                mStudentImageView.downloadImage(checkedUrl, withFolderType: folderType.ProFilePics, withResizeValue:mStudentImageView.frame.size)
            }
        }
        
        
       if let grasp = studentDict.objectForKey("GraspIndex") as? NSString
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
        
        
        
        if let Scribble = answerDetails.objectForKey("Scribble") as? String
        {
            let urlString = NSUserDefaults.standardUserDefaults().objectForKey(k_INI_SCRIBBLE_IMAGE_URL) as! String
            
            if let checkedUrl = NSURL(string: "\(urlString)/\(Scribble)")
            {
                mSubmissionImageView.contentMode = .ScaleAspectFit
                mSubmissionImageView.downloadImage(checkedUrl, withFolderType: folderType.StudentAnswer,withResizeValue: mSubmissionImageView.frame.size)
            }
            mSubmissionImageView.hidden = false
        }
        
        
        if overlay != ""
        {
            let urlString = NSUserDefaults.standardUserDefaults().objectForKey(k_INI_SCRIBBLE_IMAGE_URL) as! String
            
            if let checkedUrl = NSURL(string: "\(urlString)/\(overlay)")
            {
                mOverlayImageView.contentMode = .ScaleAspectFit
                mOverlayImageView.downloadImage(checkedUrl, withFolderType: folderType.questionImage,withResizeValue: mOverlayImageView.frame.size)
            }
            mOverlayImageView.hidden = false
        }
        
        
        if let TextAnswer = answerDetails.objectForKey("TextAnswer") as? String
        {
            
            
            studentSubmissionLabel.text = TextAnswer
            studentSubmissionLabel.hidden = false
            
            
        }
    }
    
    
    
    func checkMarkPressedWith()
    {
        if currentSelectionState == kUnSelected
        {
            
            
            currentSelectionState = kSelected
            
            checkBoxImage.image = UIImage(named:"Checked.png");
            
            
            
            if delegate().respondsToSelector(#selector(SubjectiveStudentContainerDelegate.delegateCheckmarkPressedWithState(_:withStudentDetails:withAnswerDetails:)))
            {
                delegate().delegateCheckmarkPressedWithState!(true, withStudentDetails: _currentStudentDetails, withAnswerDetails: _currentStudentAnswerDetails)
            }
            
            
            
            
        }
        else
        {
            currentSelectionState = kUnSelected
            checkBoxImage.image = UIImage(named:"Unchecked.png");
            
            if delegate().respondsToSelector(#selector(SubjectiveStudentContainerDelegate.delegateCheckmarkPressedWithState(_:withStudentDetails:withAnswerDetails:)))
            {
                delegate().delegateCheckmarkPressedWithState!(false, withStudentDetails: _currentStudentDetails, withAnswerDetails: _currentStudentAnswerDetails)
            }
            
        }
        
        
    }
    
    
    
    
    
}