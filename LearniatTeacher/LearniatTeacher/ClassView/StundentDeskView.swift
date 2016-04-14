//
//  StundentDeskView.swift
//  LearniatTeacher
//
//  Created by Deepak MK on 26/03/16.
//  Copyright © 2016 Mindshift. All rights reserved.
//

import Foundation



let StudentLive                 =  "Live"
let StudentLiveBackground       =  "LiveBackground"
let StudentOccupied             =  "Occupied"
let StudentFree                 =  "Free"
let StudentSignedout            = "Signedout"
let StudentPreAllocated         = "PreAllocated"


enum StudentAnswerState
{
    case AnswerRecieved
    case AnswerEvaluated
    case AnswerDontKnow
    case AnswerCleared
}


@objc protocol StundentDeskViewDelegate
{
    
    
    optional func delegateStudentCellPressedWithViewAnswerOptions(answerOptions:NSMutableArray, withStudentId studentId:String)
    
    
    optional func delegateStudentCellPressedWithViewSubjectiveAnswerDetails(details:AnyObject, withStudentId studentId:String)
    
    
    optional func delegateStudentAnswerDownloadedWithDetails(details:AnyObject, withStudentDict studentDict:AnyObject)
    
   
    optional func delegateStudentQueryWithDetails(details:AnyObject, withStudentDict studentDict:AnyObject)
    
    
    optional func delegateStudentCellPressedWithEvaluationDetails(details:AnyObject, withStudentId studentId:String)
    
    
}

class StundentDeskView: UIView,SSTeacherDataSourceDelegate
{
    
    
    
   
    var cellWith : CGFloat = 0
    
    var cellHeight : CGFloat = 0
    
    var currentStudentsDict:AnyObject!
    
    var refrenceDeskImageView = UIImageView()
    
    var answerDeskImageView  = LBorderView()
    
    var mStudentImage  = UIImageView()
    
    var mParticipationLessImageView  = UIImageView()
    
    var mDeskFrame :CGRect!
    
    
    var mStudentName  = FXLabel()
    
    var mMiddleStudentName = UILabel()
    
    var mProgressView = UIProgressView()
 
    var StudentState = StudentSignedout
    
    var mQuestionStateImage = UIImageView()
    
    var mDoubtImageview = UIImageView()
    
    var _currentQuestionDetials :AnyObject!
    
    var studentFinalAnswerOptions = NSMutableArray()
    
    var answerContainerView = StudentAnswerOptionsView()
    
    var currentAnswerState :StudentAnswerState = .AnswerCleared
    
    var mQueryTextLable              = UILabel()
    
    var _currentAnswerDetails :AnyObject!
    
    var _currentEvaluationDetail:AnyObject!
    
    var isQueryPresent              = false
    
    var currentQueryDetails     :AnyObject!
    
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
        super.init(frame:frame)
        
        
        var deskSize:CGFloat = self.frame.size.width
        
        
        
        if (self.frame.size.height > self.frame.size.width)
        {
            deskSize = self.frame.size.width;
        }
        else if (self.frame.size.width>self.frame.size.height)
        {
            deskSize=self.frame.size.height;
        }
        else if(self.frame.size.width==self.frame.size.height)
        {
            deskSize=self.frame.size.width;
        }

    
        
        refrenceDeskImageView.frame = CGRectMake((self.frame.size.width-(deskSize/1.1))/2, (self.frame.size.height-deskSize)/2,deskSize/1.1,deskSize )
        self.addSubview(refrenceDeskImageView)
        refrenceDeskImageView.backgroundColor = UIColor.clearColor()
        cellWith = refrenceDeskImageView.frame.size.width
        cellHeight = cellWith / 2
        refrenceDeskImageView.userInteractionEnabled = true
        
        
        
        
        mStudentImage.frame = CGRectMake((refrenceDeskImageView.frame.size.width - refrenceDeskImageView.frame.size.width / 1.1)/2, (refrenceDeskImageView.frame.size.width / 3.5) / 8, refrenceDeskImageView.frame.size.width / 3.5, refrenceDeskImageView.frame.size.width / 3.5)
        refrenceDeskImageView.addSubview(mStudentImage)
        mStudentImage.backgroundColor = UIColor.clearColor()
        mStudentImage.layer.cornerRadius = mStudentImage.frame.size.width/16;
        mStudentImage.layer.masksToBounds = true

        
        
        mParticipationLessImageView.frame = CGRectMake((mStudentImage.frame.origin.x + mStudentImage.frame.size.width)-((mStudentImage.frame.size.width / 3) / 2),0, (mStudentImage.frame.size.width / 3), (mStudentImage.frame.size.width / 3))
        refrenceDeskImageView.addSubview(mParticipationLessImageView)
        mParticipationLessImageView.image = UIImage(named: "lowParticipartion.png")
        mParticipationLessImageView.hidden = true
        
        
        answerDeskImageView.frame = CGRectMake((refrenceDeskImageView.frame.size.width-refrenceDeskImageView.frame.size.width/1.1)/2, (mStudentImage.frame.size.height+cellHeight/8),refrenceDeskImageView.frame.size.width/1.1, refrenceDeskImageView.frame.size.width/1.65)
        refrenceDeskImageView.addSubview(answerDeskImageView)
        answerDeskImageView.borderType = BorderTypeDashed;
        answerDeskImageView.dashPattern = 4;
        answerDeskImageView.spacePattern = 4;
        answerDeskImageView.borderWidth = 1;
        answerDeskImageView.borderColor = LineGrayColor;
        
        
        mDeskFrame = answerDeskImageView.frame
        
        
        
        
        answerContainerView.frame = mDeskFrame
        refrenceDeskImageView.addSubview(answerContainerView)
        answerContainerView.backgroundColor = UIColor.clearColor()
        
        
        
        
        
        
        mQueryTextLable = UILabel(frame: mDeskFrame)
        refrenceDeskImageView.addSubview(mQueryTextLable)
        
        var fontHeight = mQueryTextLable.frame.size.height/3;
        
        if (fontHeight > 16)
        {
            fontHeight = 16;
        }
        
        mQueryTextLable.font = UIFont(name: helveticaRegular, size: fontHeight)
        mQueryTextLable.textColor = blackTextColor
        mQueryTextLable.lineBreakMode = .ByTruncatingMiddle
        mQueryTextLable.numberOfLines = 10
        mQueryTextLable.textAlignment = .Center
        mQueryTextLable.hidden = true
        
        
        
        mStudentName.frame = CGRectMake(answerDeskImageView.frame.origin.x,answerDeskImageView.frame.size.height+answerDeskImageView.frame.origin.y, answerDeskImageView.frame.size.width, refrenceDeskImageView.frame.size.height-(answerDeskImageView.frame.origin.y+answerDeskImageView.frame.size.height));
        mStudentName.textAlignment = .Center;
        mStudentName.textColor = blackTextColor
        refrenceDeskImageView.addSubview(mStudentName)
        mStudentName.backgroundColor = UIColor.clearColor()
        mStudentName.allowOrphans = true;
        mStudentName.textAlignment = .Center;
        mStudentName.contentMode = .Top;
        mStudentName.hidden = true
        
        fontHeight = mStudentName.frame.size.height/1.3;
        if (fontHeight>16)
        {
            fontHeight = 16;
        }
        
        mStudentName.font = UIFont(name: helveticaRegular, size: fontHeight)

        
        mMiddleStudentName.frame = mDeskFrame
        refrenceDeskImageView.addSubview(mMiddleStudentName)
        mMiddleStudentName.backgroundColor = UIColor.clearColor();
        mMiddleStudentName.hidden = false
        mMiddleStudentName.textAlignment = .Center;
        mMiddleStudentName.numberOfLines=10;
        mMiddleStudentName.lineBreakMode = .ByTruncatingMiddle
        mMiddleStudentName.textColor = blackTextColor
        
        
        
        
        mProgressView.frame = CGRectMake((mStudentImage.frame.size.width+mStudentImage.frame.size.width/4),   mStudentImage.frame.size.height-mStudentImage.frame.size.height/8,   refrenceDeskImageView.frame.size.width-mStudentImage.frame.size.width-mStudentImage.frame.size.width/2,mStudentImage.frame.size.width/8);
        refrenceDeskImageView.addSubview(mProgressView);
        mProgressView.progressTintColor  = standard_Red
        mProgressView.trackTintColor = UIColor(red: 213/255.0, green:213/255.0, blue:213/255.0, alpha: 1)
        mProgressView.hidden = true
        let transform = CGAffineTransformMakeScale(1.0, 3.2);
        mProgressView.transform = transform;
        mProgressView.layer.cornerRadius = mProgressView.frame.size.height/2;
        mProgressView.layer.masksToBounds = true;
        
        
        
        
        let questionStateView = UIView(frame:CGRectMake(refrenceDeskImageView.frame.size.width-cellHeight/1.9, (refrenceDeskImageView.frame.size.width/3.5)/8, cellHeight/3,cellHeight/3));
        refrenceDeskImageView.addSubview(questionStateView)
        questionStateView.backgroundColor = UIColor.clearColor()
        
        
        mQuestionStateImage.frame = CGRectMake(0, 0, questionStateView.frame.size.height,questionStateView.frame.size.height)
        questionStateView.addSubview(mQuestionStateImage);
        mQuestionStateImage.backgroundColor = UIColor.whiteColor()
        mQuestionStateImage.hidden = true
        
        
        mDoubtImageview.frame =  CGRectMake(0, 0, questionStateView.frame.size.height,questionStateView.frame.size.height);
        questionStateView.addSubview(mDoubtImageview)
        mDoubtImageview.backgroundColor = UIColor.clearColor()
       mDoubtImageview.hidden = true
        mDoubtImageview.image  = UIImage(named:"Query.png");
        
        
        
        let  mDoneButton = UIButton()
        mDoneButton.frame = mDeskFrame
        refrenceDeskImageView.addSubview(mDoneButton)
        mDoneButton.addTarget(self, action: "onDeskPressed", forControlEvents: UIControlEvents.TouchUpInside)
        
        
    }
    
    required init?(coder aDecoder: NSCoder)
    {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func setStudentsDetails(details:AnyObject)
    {
        currentStudentsDict = details
        
        if let StudentName = currentStudentsDict.objectForKey("Name") as? String
        {
            mMiddleStudentName.text = StudentName
            mStudentName.text       = StudentName
        }
        
        
        if let StudentId = currentStudentsDict.objectForKey("StudentId") as? String
        {
            let urlString = NSUserDefaults.standardUserDefaults().objectForKey(k_INI_UserProfileImageURL) as! String
            
            if let checkedUrl = NSURL(string: "\(urlString)/\(StudentId)_79px.jpg")
            {
                mStudentImage.contentMode = .ScaleAspectFit
                mStudentImage.downloadImage(checkedUrl, withFolderType: folderType.ProFilePics)
            }
        }
        
        
        if let _StudentState = currentStudentsDict.objectForKey("StudentState") as? String
        {
           setStudentCurrentState(_StudentState)
        }
        
        
        
        
    
    }
    
    func setStudentCurrentState(state:String)
    {
        
        StudentState = state;
        mStudentImage.hidden = false
        
        switch (state)
        {
           
            case StudentSignedout:
                
                answerDeskImageView.borderType = BorderTypeDashed;
                answerDeskImageView.borderWidth = 1;
                answerDeskImageView.borderColor = standard_Red
                mStudentImage.hidden = true
                
                break;
         
            case StudentFree:
                answerDeskImageView.borderType = BorderTypeDashed;
                answerDeskImageView.borderWidth = 1;
                answerDeskImageView.borderColor = LineGrayColor;
                
                break;
            
            case StudentLive:
                
                    
                    answerDeskImageView.borderType = BorderTypeSolid;
                    answerDeskImageView.borderWidth = 1;
                   answerDeskImageView.borderColor = standard_Green
                    
                    break;
           
            case StudentLiveBackground:
                
                answerDeskImageView.borderType = BorderTypeSolid;
                answerDeskImageView.borderWidth = 1;
                answerDeskImageView.borderColor = standard_Red
                
                break;
                
            case StudentOccupied:
               
                answerDeskImageView.borderType = BorderTypeDashed;
                answerDeskImageView.borderWidth = 1;
                answerDeskImageView.borderColor = LineGrayColor
                
                break;

            case StudentPreAllocated:
               
                answerDeskImageView.borderType = BorderTypeDashed;
                answerDeskImageView.borderWidth = 1;
                answerDeskImageView.borderColor = LineGrayColor
                
                break
                
            default:
                answerDeskImageView.borderType = BorderTypeSolid;
                answerDeskImageView.borderWidth = 1;

                break
        }
    }
    
    // MARK: - Student Answers functions
    
    func studentSentAnswerWithAnswerString(answerString:String, withQuestionDetails details:AnyObject)
    {
        _currentQuestionDetials = details
        SSTeacherDataSource.sharedDataSource.getStudentsAswerWithAnswerId(answerString, withDelegate: self)
    }
    
    
    func studentAnswerWithdrawn()
    {
         teacherClearedQuestion()
    }
    
    
    
    func setDontKnowMessageFromStudent()
    {
        answerContainerView.addDontKnowImage()
        currentAnswerState = .AnswerDontKnow
        
        mQuestionStateImage.hidden = true
        mMiddleStudentName.hidden = true
        mStudentName.hidden = false
        mQueryTextLable.hidden = true
        
        answerContainerView.hidden = false
        
        if isQueryPresent == true
        {
            mDoubtImageview.hidden = false
            mQueryTextLable.hidden = true
            
        }
    }
    
    func didGetStudentsAnswerWithDetails(details: AnyObject)
    {
        mQuestionStateImage.hidden = true
        mMiddleStudentName.hidden = true
        mStudentName.hidden = false
        _currentAnswerDetails = details
        mQueryTextLable.hidden = true
        
        answerContainerView.hidden = false
        
        if isQueryPresent == true
        {
            mDoubtImageview.hidden = false
            mQueryTextLable.hidden = true
            
        }
        
        if let questionType = _currentQuestionDetials.objectForKey("Type") as? String
        {
            
            if (questionType  == kOverlayScribble  || questionType == kFreshScribble)
            {
                
                
                if let ScribbleId = _currentQuestionDetials.objectForKey("Scribble") as? String{
                    answerContainerView.addScribbleWithDetiails(details, withOverlayImage:ScribbleId)
                }
                else
                {
                    answerContainerView.addScribbleWithDetiails(details, withOverlayImage:"")
                }
                
            }
            else if (questionType == kText)
            {
                answerContainerView.addTextWithDetiails(details)
            }
            else if (questionType == kMatchColumn)
            {
                answerContainerView.addOptionsWithAnswerDetails(details, withQuestionDetails: _currentQuestionDetials)
            }
            else
            {
                answerContainerView.addOptionsWithAnswerDetails(details, withQuestionDetails: _currentQuestionDetials)
                
            }
        }
        
        
        currentAnswerState = .AnswerRecieved
        
        if delegate().respondsToSelector(Selector("delegateStudentAnswerDownloadedWithDetails:withStudentDict:"))
        {
            delegate().delegateStudentAnswerDownloadedWithDetails!(details, withStudentDict:currentStudentsDict)
            
        }
        
    }
    
    
    
    
    func onDeskPressed()
    {
        
        if currentAnswerState == .AnswerRecieved
        {
                            if let questionType = _currentQuestionDetials.objectForKey("Type") as? String
                {
                    
                    if (questionType  == kOverlayScribble  || questionType == kFreshScribble)
                    {
                        if delegate().respondsToSelector(Selector("delegateStudentCellPressedWithViewSubjectiveAnswerDetails:withStudentId:"))
                        {
                            
                            delegate().delegateStudentCellPressedWithViewSubjectiveAnswerDetails!(_currentAnswerDetails,  withStudentId:(currentStudentsDict.objectForKey("StudentId") as? String)!)
                            
                        }
                        
                    }
                    else if (questionType == kText)
                    {
                        
                        if delegate().respondsToSelector(Selector("delegateStudentCellPressedWithViewSubjectiveAnswerDetails:withStudentId:"))
                        {
                            
                             delegate().delegateStudentCellPressedWithViewSubjectiveAnswerDetails!(_currentAnswerDetails,  withStudentId:(currentStudentsDict.objectForKey("StudentId") as? String)!)
                            
                        }
                        
                        
                      
                    }
                    else if (questionType == kMatchColumn)
                    {
                        if delegate().respondsToSelector(Selector("delegateStudentCellPressedWithViewAnswerOptions:withStudentId:"))
                        {
                            
                            delegate().delegateStudentCellPressedWithViewAnswerOptions!(answerContainerView._studentFinalAnswerOptions,  withStudentId:(currentStudentsDict.objectForKey("StudentId") as? String)!)
                            
                        }
                        
                    }
                    else
                    {
                        if delegate().respondsToSelector(Selector("delegateStudentCellPressedWithViewAnswerOptions:withStudentId:"))
                        {
                            
                             delegate().delegateStudentCellPressedWithViewAnswerOptions!(answerContainerView._studentFinalAnswerOptions,  withStudentId:(currentStudentsDict.objectForKey("StudentId") as? String)!)

                        }
                        
                        
                    }
                
                
               
                
            }
        }
        else if currentAnswerState == .AnswerEvaluated
        {
            if delegate().respondsToSelector(Selector("delegateStudentCellPressedWithEvaluationDetails:withStudentId:"))
            {
                
                delegate().delegateStudentCellPressedWithEvaluationDetails!(_currentEvaluationDetail,  withStudentId:(currentStudentsDict.objectForKey("StudentId") as? String)!)
                
            }
        }
        else if isQueryPresent == true
        {
            if delegate().respondsToSelector(Selector("delegateStudentQueryWithDetails:withStudentDict:"))
            {
                
                delegate().delegateStudentQueryWithDetails!(currentQueryDetails, withStudentDict: currentStudentsDict!)
                
            }
        }
        
    }
    
    func teacherClearedQuestion()
    {
        let subViews = answerContainerView.subviews
        
        for subview in subViews
        {
            subview.removeFromSuperview()
        }
        
        currentAnswerState = .AnswerCleared
        
        if isQueryPresent == true
        {
            mDoubtImageview.hidden = true
            mQueryTextLable.hidden = false
            
            mStudentName.hidden = false
            mMiddleStudentName.hidden = true

        }
        else
        {
            mStudentName.hidden = true
            mMiddleStudentName.hidden = false

        }
        
        mQuestionStateImage.hidden = true
        answerContainerView.hidden = true
               
    }
    
    
    
    
    
    func setQueryDetails(queryDetails:AnyObject)
    {
         isQueryPresent = true
        
        currentQueryDetails = queryDetails
        if currentAnswerState == .AnswerRecieved || currentAnswerState == .AnswerEvaluated || currentAnswerState == .AnswerDontKnow
        {
            mDoubtImageview.hidden = false
            mQueryTextLable.hidden = true
           
        }
        else
        {
            mDoubtImageview.hidden = true
            mQueryTextLable.hidden = false
            
            mStudentName.hidden = false
            mMiddleStudentName.hidden = true


            
        }
        
        if let QueryText = queryDetails.objectForKey("QueryText") as? String
        {
            mQueryTextLable.text = QueryText
           
        }
        
    }
    
    func queryDismissed()
    {
        mDoubtImageview.hidden = true
        mQueryTextLable.hidden = true
        isQueryPresent = false
        
        if currentAnswerState == .AnswerCleared
        {
            mStudentName.hidden = true
            mMiddleStudentName.hidden = false
        }
        
    }
    
    
    func setReplayEvaluatedWithDetails(details:AnyObject)
    {
        _currentEvaluationDetail = details
        answerContainerView.setStudentEvaluationStatusWithDetails(details)
        currentAnswerState = .AnswerEvaluated
    }
    

}


