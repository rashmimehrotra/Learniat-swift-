//
//  SubmissionSubjectiveView.swift
//  LearniatTeacher
//
//  Created by Deepak MK on 07/04/16.
//  Copyright © 2016 Mindshift. All rights reserved.
//

import Foundation

let kAspectRation:CGFloat = 1.5

class SubmissionSubjectiveView: UIView,SmoothLineViewdelegate, SubjectiveLeftSideViewDelegate
{
    var _delgate: AnyObject!
    
    var _currentQuestionDetials:AnyObject!
    
    var subjectiveCellContainer :SubjectiveLeftSideView!
    
    func setdelegate(delegate:AnyObject)
    {
        _delgate = delegate;
    }
    
    func   delegate()->AnyObject
    {
        return _delgate;
    }
    
    
    
    
    let topImageView = UIImageView()
    
    let mCancelButton = UIButton()
    
    let mMarkModelButton = UIButton()
    
    let mStarRatingView = SSStarRatingView()
    
    let mSendButton = UIButton()
    
    let containerview = UIView()
    
    let overlayimageView = UIImageView()
    
    let mScribbleView = SmoothLineView()
    
    
    
    
    let bottomview = UIView()
    
    let m_UndoButton = UIButton()
    
    let bottomtoolSelectedImageView = UIImageView()
    
    let m_BrushButton = UIButton()
    
    let m_EraserButton = UIButton()
    
    let m_RedoButton = UIButton()
    
    var selectedStudentsArray = NSMutableArray()
    
    
    override init(frame: CGRect)
    {
        super.init(frame:frame)
        
        
        
         self.backgroundColor = whiteBackgroundColor
        
        
        subjectiveCellContainer  = SubjectiveLeftSideView(frame: CGRectMake(0, 0 , self.frame.size.width / 7, self.frame.size.height))
        subjectiveCellContainer.setdelegate(self)
        self.addSubview(subjectiveCellContainer)
        
        
        
        
        topImageView.frame = CGRectMake(180,5, 780, 54)
        topImageView.backgroundColor = UIColor.whiteColor()
        self.addSubview (topImageView);
        topImageView.layer.shadowColor = progressviewBackground.CGColor;
        topImageView.layer.shadowOffset = CGSizeMake(1, 1);
        topImageView.layer.shadowOpacity = 1;
        topImageView.layer.shadowRadius = 1.0;
        topImageView.clipsToBounds = false;
        
        
        
        mCancelButton.showsTouchWhenHighlighted = true;
        /* Add Cancel button target Cancel button should deselect all the selected submissions *defect 142 */
        mCancelButton.frame = CGRectMake(10 , 0, 139.0, 60.0);
        topImageView.addSubview(mCancelButton);
        mCancelButton.setTitle("Cancel", forState:.Normal);
        mCancelButton.setTitleColor(standard_Button, forState:.Normal);
        mCancelButton.titleLabel?.font = UIFont(name: helveticaMedium, size: 20);
        mCancelButton.contentHorizontalAlignment = UIControlContentHorizontalAlignment.Left
        
        
        
        mSendButton.frame = CGRectMake(topImageView.frame.size.width - 100 , 0, 100 , topImageView.frame.size.height );
        topImageView.addSubview(mSendButton);
        mSendButton.setTitle("Send", forState:.Normal);
        mSendButton.setTitleColor(lightGrayColor, forState:.Normal);
        mSendButton.titleLabel?.font = UIFont(name: helveticaMedium, size: 20);
        mSendButton.enabled = false
        mSendButton.highlighted = false;
        mSendButton.contentHorizontalAlignment = UIControlContentHorizontalAlignment.Center
        

        
        let lineImage = UIImageView(frame:CGRectMake(mSendButton.frame.origin.x, 5, 1, topImageView.frame.size.height - 10));
        lineImage.backgroundColor = progressviewBackground
        topImageView.addSubview(lineImage);
        
        
        
        mStarRatingView.backgroundColor = UIColor.clearColor();
        mStarRatingView.frame = CGRectMake(lineImage.frame.origin.x - 190, 10, 180, topImageView.frame.size.height - 20);
        mStarRatingView.setDelegate(self);
        topImageView.addSubview(mStarRatingView);
        mStarRatingView.setsizeOfStar(30);

        
        let button = UIButton(type: .Custom)
        button.frame = CGRectMake(mStarRatingView.frame.origin.x - 40 , 13, 30, 25);
        button.setImage(UIImage(named:"Rate_Type_Arrow_Icon.png"), forState:.Normal);
        topImageView.addSubview(button);

        
        
        
        let  mMarkModelButtonlineImage = UIImageView(frame: CGRectMake(button.frame.origin.x - 10, 5, 1, topImageView.frame.size.height - 10));
        mMarkModelButtonlineImage.backgroundColor = progressviewBackground
        topImageView.addSubview(mMarkModelButtonlineImage);

        
       
        mMarkModelButton.frame = CGRectMake(mMarkModelButtonlineImage.frame.origin.x - 160, 0, 150, topImageView.frame.size.height);
        topImageView.addSubview(mMarkModelButton);
        mMarkModelButton.setImage(UIImage(named:"Mark_Model_Not_Selected.png"), forState:.Normal);
        mMarkModelButton.setTitle("  Mark Model", forState:.Normal);
        mMarkModelButton.setTitleColor(blackTextColor, forState:.Normal)
        mMarkModelButton.titleLabel?.font = UIFont(name: helveticaMedium, size: 20);
        
        
        containerview.frame = CGRectMake(topImageView.frame.origin.x,topImageView.frame.origin.y + topImageView.frame.size.height + 1 ,  topImageView.frame.size.width,topImageView.frame.size.width / kAspectRation)
        containerview.backgroundColor = UIColor.whiteColor()
        self.addSubview(containerview);
        containerview.layer.shadowColor = progressviewBackground.CGColor;
        containerview.layer.shadowOffset = CGSizeMake(0,0);
        containerview.layer.shadowOpacity = 1;
        containerview.layer.shadowRadius = 1.0;
        containerview.clipsToBounds = false;
        
        
        
        
        
        
        overlayimageView.frame = containerview.frame
        self.addSubview(overlayimageView);

        
        mScribbleView.frame = containerview.frame
        mScribbleView.delegate = self
        self.addSubview(mScribbleView);
        mScribbleView.userInteractionEnabled = true
        mScribbleView.setDrawingColor(standard_Red);
        mScribbleView.setBrushWidth(100)
        mScribbleView.setDrawingTool(kBrushTool)
        mScribbleView.hidden = false
        
        
        
        bottomview.frame = CGRectMake(topImageView.frame.origin.x, containerview.frame.origin.y + containerview.frame.size.height , topImageView.frame.size.width,topImageView.frame.size.height)
        bottomview.backgroundColor = lightGrayTopBar
        self.addSubview(bottomview);
        
        
        
       
        
        

        
        m_UndoButton.frame = CGRectMake(0, 0, bottomview.frame.size.height, bottomview.frame.size.height)
        m_UndoButton.setImage(UIImage(named:"Undo_Disabled.png"),forState:.Normal);
        bottomview.addSubview(m_UndoButton);
        m_UndoButton.imageView?.contentMode = .ScaleAspectFit
        
        
       
        bottomtoolSelectedImageView.backgroundColor = UIColor.whiteColor();
        bottomview.addSubview(bottomtoolSelectedImageView);
        bottomtoolSelectedImageView.layer.cornerRadius = 10.0;
        
        
        m_BrushButton.frame = CGRectMake((bottomview.frame.size.width/2) - (bottomview.frame.size.height + 10) ,5, bottomview.frame.size.height ,bottomview.frame.size.height - 10)
        m_BrushButton.setImage(UIImage(named:"Marker_Selected.png"), forState:.Normal)
        bottomview.addSubview(m_BrushButton);
        m_BrushButton.imageView?.contentMode = .ScaleAspectFit

        bottomtoolSelectedImageView.frame = m_BrushButton.frame
        
        
        
       
        m_EraserButton.frame = CGRectMake((bottomview.frame.size.width/2) + 10  ,5, bottomview.frame.size.height ,bottomview.frame.size.height - 10)
        m_EraserButton.setImage(UIImage(named:"Eraser_Unselected.png"), forState:.Normal);
        bottomview.addSubview(m_EraserButton);
        m_EraserButton.imageView?.contentMode = .ScaleAspectFit
        
        
        
        m_RedoButton.frame = CGRectMake(bottomview.frame.size.width - bottomview.frame.size.height ,0, bottomview.frame.size.height ,bottomview.frame.size.height)
        m_RedoButton.setImage(UIImage(named:"Redo_Disabled.png"), forState:.Normal);
        bottomview.addSubview(m_RedoButton);
        m_RedoButton.imageView?.contentMode = .ScaleAspectFit
        
        
        
        
        
//
//        NOsubmissionLabel = [[UILabel alloc] initWithFrame:CGRectMake((self.frame.size.width-600)/2, (self.frame.size.height/2)-30, 600, 60)];
//        [NOsubmissionLabel setText:@"There are no submission Yet"];
//        [NOsubmissionLabel setBackgroundColor:[UIColor clearColor]];
//        [NOsubmissionLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:40]];
//        [NOsubmissionLabel setTextAlignment:NSTextAlignmentCenter];
//        [NOsubmissionLabel setTextColor:[UIColor grayColor]];
//        [self addSubview:NOsubmissionLabel];
//        [NOsubmissionLabel setHidden:YES];
        
        
        self.bringSubviewToFront(mScribbleView)
        
        
        
    }
    
    required init?(coder aDecoder: NSCoder)
    {
        fatalError("init(coder:) has not been implemented")
        
        
        
    }
    
    
    func setStudentAnswerWithAnswer(studentAnswer:AnyObject, withStudentDict studentdict:AnyObject, withQuestionDict QuestionDetails:AnyObject )
    {
        
        _currentQuestionDetials = QuestionDetails
        
        
        
        if let overlayImage = _currentQuestionDetials.objectForKey("Scribble") as? String
        {
            
            
            if overlayImage != ""
            {
                let urlString = NSUserDefaults.standardUserDefaults().objectForKey(k_INI_SCRIBBLE_IMAGE_URL) as! String
                
                if let checkedUrl = NSURL(string: "\(urlString)/\(overlayImage)")
                {
                    overlayimageView.contentMode = .ScaleAspectFit
                    overlayimageView.downloadImage(checkedUrl, withFolderType: folderType.questionImage,withResizeValue: overlayimageView.frame.size)
                }
                overlayimageView.hidden = false
            }

            
            
              subjectiveCellContainer.addStudentSubmissionWithStudentAnswer(studentAnswer, withStudentDetails: studentdict, withOverlay:overlayImage)
            
        }
        else
        {
              subjectiveCellContainer.addStudentSubmissionWithStudentAnswer(studentAnswer, withStudentDetails: studentdict, withOverlay:"")
        }
      
    }
    // MARK: - Subjective LeftSide View Delegate
    
    func delegateStudentSelectedWithState(state: Bool, withStudentDetails studentDetails: AnyObject, withAnswerDetails answerDetails: AnyObject)
    {
        if state == true
        {
            
            if let studentId = studentDetails.objectForKey("StudentId") as? String
            {
                if !selectedStudentsArray.containsObject(studentId)
                {
                    selectedStudentsArray.addObject(studentId)
                    
                    
                    let studentAnswerImage = UIImageView(frame: CGRectMake(0, 0, containerview.frame.size.width, containerview.frame.size.height))
                    studentAnswerImage.tag  = Int(studentId)!
                    containerview.addSubview(studentAnswerImage)
                    
                    if let Scribble = answerDetails.objectForKey("Scribble") as? String
                    {
                        let urlString = NSUserDefaults.standardUserDefaults().objectForKey(k_INI_SCRIBBLE_IMAGE_URL) as! String
                        
                        if let checkedUrl = NSURL(string: "\(urlString)/\(Scribble)")
                        {
                            studentAnswerImage.contentMode = .ScaleAspectFit
                            studentAnswerImage.downloadImage(checkedUrl, withFolderType: folderType.StudentAnswer,withResizeValue: studentAnswerImage.frame.size)
                        }
                    }
                }
            }
            
            
        }
        else
        {
            if let studentId = studentDetails.objectForKey("StudentId") as? String
            {
                if selectedStudentsArray.containsObject(studentId)
                {
                    selectedStudentsArray.removeObject(studentId)
                }
                
                
                
                if let studentDeskView  = containerview.viewWithTag(Int(studentId)!) as? UIImageView
                {
                    studentDeskView.removeFromSuperview()
                }
                
            }
            
        }
        
    }
    
    
    // MARK: - Smooth line delegate
    
    func setUndoButtonEnable(enable: NSNumber!) {
        
    }
    
    func setRedoButtonEnable(enable: NSNumber!) {
        
    }
    
    func lineDrawnChanged()
    {
        
    }
    
    

}