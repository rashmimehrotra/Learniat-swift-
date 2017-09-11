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
let kDeskBorderWidth :CGFloat           = 0.5

enum StudentAnswerState
{
    case answerRecieved
    case answerEvaluated
    case answerDontKnow
    case answerCleared
}

enum AnswerMessageState {
    case Recieved
    case Cleared
}


@objc protocol StundentDeskViewDelegate
{
    
    
    @objc optional func delegateStudentCellPressedWithViewAnswerOptions(_ answerOptions:NSMutableArray, withStudentId studentId:String)
    
    
    @objc optional func delegateStudentCellPressedWithViewSubjectiveAnswerDetails(_ details:AnyObject, withStudentId studentId:String)
    
    
    @objc optional func delegateStudentAnswerDownloadedWithDetails(_ details:AnyObject, withStudentDict studentDict:AnyObject)
    
   
    @objc optional func delegateStudentQueryWithDetails(_ details:AnyObject, withStudentDict studentDict:AnyObject)
    
    
    @objc optional func delegateStudentCellPressedWithEvaluationDetails(_ details:AnyObject, withStudentId studentId:String)
    
    
}

class StundentDeskView: UIView,SSTeacherDataSourceDelegate
{
    
    
    
   
    var cellWith : CGFloat = 0
    
    var cellHeight : CGFloat = 0
    
    var currentStudentsDict:AnyObject!
    
    var refrenceDeskImageView = UIImageView()
    
    var answerDeskImageView  = LBorderView()
    
    var mStudentImage  = CustomProgressImageView()
    
    var mParticipationLessImageView  = UIImageView()
    
    var mDeskFrame :CGRect!
    
    
    var mStudentName  = UILabel()
    
    var mMiddleStudentName = UILabel()
    
    var mProgressView = UIProgressView()
 
    var StudentState = StudentSignedout
    
    var mQuestionStateImage = UIImageView()
    
    var mDoubtImageview = UIImageView()
    
    var _currentQuestionDetials :AnyObject!
    
    var studentFinalAnswerOptions = NSMutableArray()
    
    var answerContainerView = StudentAnswerOptionsView()
    
    var currentAnswerState :StudentAnswerState = .answerCleared
    
    var currentAnswerRecievedState: AnswerMessageState = .Cleared
    
    var mQueryTextLable              = UILabel()
    
    var _currentAnswerDetails :AnyObject!
    
    var _currentEvaluationDetail:AnyObject!
    
    var isQueryPresent              = false
    
    var currentQueryDetails     :AnyObject!
    
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

    
        
        refrenceDeskImageView.frame = CGRect(x: (self.frame.size.width-(deskSize))/2, y: (self.frame.size.height-deskSize)/2,width: deskSize,height: deskSize )
        self.addSubview(refrenceDeskImageView)
        refrenceDeskImageView.backgroundColor = UIColor.clear
        cellWith = refrenceDeskImageView.frame.size.width
        cellHeight = cellWith / 2
        refrenceDeskImageView.isUserInteractionEnabled = true
        
        
        
        
        mStudentImage.frame = CGRect(x: (refrenceDeskImageView.frame.size.width - refrenceDeskImageView.frame.size.width / 1.2 )/2, y: (refrenceDeskImageView.frame.size.height / 4) / 8, width: refrenceDeskImageView.frame.size.width / 4, height: refrenceDeskImageView.frame.size.width / 4)
        refrenceDeskImageView.addSubview(mStudentImage)
        mStudentImage.backgroundColor = UIColor.clear
        mStudentImage.layer.cornerRadius = mStudentImage.frame.size.width/16;
        mStudentImage.layer.masksToBounds = true

        
        
        mParticipationLessImageView.frame = CGRect(x: (mStudentImage.frame.origin.x + mStudentImage.frame.size.width)-((mStudentImage.frame.size.width / 3) / 2),y: 0, width: (mStudentImage.frame.size.width / 3), height: (mStudentImage.frame.size.width / 3))
        refrenceDeskImageView.addSubview(mParticipationLessImageView)
        mParticipationLessImageView.image = UIImage(named: "lowParticipartion.png")
        mParticipationLessImageView.isHidden = true
        
        
        answerDeskImageView.frame = CGRect(x: (refrenceDeskImageView.frame.size.width-refrenceDeskImageView.frame.size.width/1.2)/2, y: (mStudentImage.frame.size.height + cellHeight/6),width: refrenceDeskImageView.frame.size.width/1.2, height: refrenceDeskImageView.frame.size.width/1.8)
        refrenceDeskImageView.addSubview(answerDeskImageView)
        answerDeskImageView.borderType = BorderTypeDashed;
        answerDeskImageView.dashPattern = 4;
        answerDeskImageView.spacePattern = 4;
        answerDeskImageView.borderWidth = kDeskBorderWidth;
        answerDeskImageView.borderColor = LineGrayColor;
        answerDeskImageView.cornerRadius = 3
        
        mDeskFrame = answerDeskImageView.frame
        
        
        
        
        answerContainerView.frame = mDeskFrame
        refrenceDeskImageView.addSubview(answerContainerView)
        answerContainerView.backgroundColor = UIColor.clear
        
        
        
        
        
        
        mQueryTextLable = UILabel(frame: mDeskFrame)
        refrenceDeskImageView.addSubview(mQueryTextLable)
        
        var fontHeight = mQueryTextLable.frame.size.height/3;
        
        if (fontHeight > 14)
        {
            fontHeight = 14;
        }
        
        mQueryTextLable.font = UIFont(name: RobotItalic, size: fontHeight)
        mQueryTextLable.textColor = blackTextColor
        mQueryTextLable.lineBreakMode = .byTruncatingMiddle
        mQueryTextLable.numberOfLines = 10
        mQueryTextLable.textAlignment = .center
        mQueryTextLable.isHidden = true
        
        
        
        mStudentName.frame = CGRect(x: answerDeskImageView.frame.origin.x,y: answerDeskImageView.frame.size.height+answerDeskImageView.frame.origin.y, width: answerDeskImageView.frame.size.width, height: refrenceDeskImageView.frame.size.height-(answerDeskImageView.frame.origin.y+answerDeskImageView.frame.size.height));
        mStudentName.textAlignment = .center;
        mStudentName.textColor = blackTextColor
        refrenceDeskImageView.addSubview(mStudentName)
        mStudentName.backgroundColor = UIColor.clear
//        mStudentName.allowOrphans = true;
        mStudentName.textAlignment = .center;
        mStudentName.contentMode = .center;
        mStudentName.isHidden = false
        
        fontHeight = mStudentName.frame.size.height/1.3;
        if (fontHeight>14)
        {
            fontHeight = 14;
        }
        
        mStudentName.font = UIFont(name: RobotRegular, size: fontHeight)
        mMiddleStudentName.font = UIFont(name: RobotRegular, size: fontHeight)
        
        mMiddleStudentName.frame = mDeskFrame
//        refrenceDeskImageView.addSubview(mMiddleStudentName)
        mMiddleStudentName.backgroundColor = UIColor.clear;
        mMiddleStudentName.isHidden = true
        mMiddleStudentName.textAlignment = .center;
        mMiddleStudentName.numberOfLines=10;
        mMiddleStudentName.lineBreakMode = .byTruncatingMiddle
        mMiddleStudentName.textColor = blackTextColor
        
        
        
        
        
        
        
        
        let questionStateView = UIView(frame:CGRect(x: answerDeskImageView.frame.size.width-(mStudentImage.frame.size.height/2), y: mStudentImage.frame.origin.y, width: mStudentImage.frame.size.height/2,height: mStudentImage.frame.size.height/2));
        refrenceDeskImageView.addSubview(questionStateView)
        questionStateView.backgroundColor = UIColor.clear
        
        
        mQuestionStateImage.frame = CGRect(x: 0, y: 0, width: questionStateView.frame.size.height,height: questionStateView.frame.size.height)
        questionStateView.addSubview(mQuestionStateImage);
        mQuestionStateImage.backgroundColor = UIColor.white
        mQuestionStateImage.isHidden = true
        
        
        mDoubtImageview.frame =  CGRect(x: 0, y: 0, width: questionStateView.frame.size.height,height: questionStateView.frame.size.height);
        questionStateView.addSubview(mDoubtImageview)
        mDoubtImageview.backgroundColor = UIColor.clear
       mDoubtImageview.isHidden = true
        mDoubtImageview.image  = UIImage(named:"Query.png");
        
        
        
        mProgressView.frame = CGRect(x: (mStudentImage.frame.size.width + mStudentImage.frame.origin.x + 5),
                                         y: mStudentImage.frame.size.height - mStudentImage.frame.size.height/8,
                                         width: answerDeskImageView.frame.size.width - (mStudentImage.frame.size.width + mStudentImage.frame.origin.x),
                                         height: mStudentImage.frame.size.width/8);
        
        refrenceDeskImageView.addSubview(mProgressView);
        mProgressView.progressTintColor  = standard_Red
        mProgressView.trackTintColor = UIColor(red: 213/255.0, green:213/255.0, blue:213/255.0, alpha: 1)
        mProgressView.isHidden = true
        let transform = CGAffineTransform(scaleX: 1.0, y: 3.2);
        mProgressView.transform = transform;
        
//        mProgressView.frame = CGRect(x: mProgressView.frame.origin.x,
//                                     y: mProgressView.frame.origin.y,
//                                     width: mProgressView.frame.size.width,
//                                     height: mProgressView.frame.size.height);
        
        mProgressView.layer.cornerRadius = mProgressView.frame.size.height/2;
        mProgressView.layer.masksToBounds = true;

        
        
        
        let  mDoneButton = UIButton()
        mDoneButton.frame = mDeskFrame
        refrenceDeskImageView.addSubview(mDoneButton)
        mDoneButton.addTarget(self, action: #selector(StundentDeskView.onDeskPressed), for: UIControlEvents.touchUpInside)
        
        let longGesture = UITapGestureRecognizer(target: self, action: #selector(StundentDeskView.Long)) //Long function will call when user long press on button.
        mDoneButton.addGestureRecognizer(longGesture)
        longGesture.numberOfTapsRequired = 2
        
      
        
        
    }
    
   
    
    func Long()
    {
        
        if mQuestionStateImage.isHidden == false
        {
            if let questionType = _currentQuestionDetials.object(forKey: kQuestionType) as? String
            {
                
                if (questionType  == kOverlayScribble  || questionType == kFreshScribble || questionType == kText)
                {
                    
                    if let StudentId = currentStudentsDict.object(forKey: "StudentId") as? String
                    {
                        SSTeacherMessageHandler.sharedMessageHandler.sendPeakViewMessageToStudentWithId(StudentId)
                    }
                }
            }
        }
    }
    
    
    
    required init?(coder aDecoder: NSCoder)
    {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func setStudentsDetails(_ details:AnyObject)
    {
        currentStudentsDict = details
        
        if let StudentName = currentStudentsDict.object(forKey: "Name") as? String
        {
            mMiddleStudentName.text = StudentName
            mStudentName.text       = StudentName
        }
        
        
        if let StudentId = currentStudentsDict.object(forKey: "StudentId") as? String
        {
            let urlString = UserDefaults.standard.object(forKey: k_INI_UserProfileImageURL) as! String
            
            if let checkedUrl = URL(string: "\(urlString)/\(StudentId)_79px.jpg")
            {
                mStudentImage.contentMode = .scaleAspectFit
                mStudentImage.downloadImage(checkedUrl, withFolderType: folderType.proFilePics)
            }
        }
        
        
        if let _StudentState = currentStudentsDict.object(forKey: "StudentState") as? String
        {
           setStudentCurrentState(_StudentState)
        }
        
        
        
        
    
    }
    
    func setStudentCurrentState(_ state:String)
    {
        
        StudentState = state;
        mStudentImage.isHidden = false
       mStudentImage.alpha = 0.5
        self.answerDeskImageView.removeInnerShadow()
        answerDeskImageView.backgroundColor = UIColor.clear
        UIView.animate(withDuration: 0.5, animations:
            {
                switch (state)
                {
                    
                case StudentSignedout:
                    
                    self.answerDeskImageView.borderType = BorderTypeDashed;
                    self.answerDeskImageView.borderWidth = kDeskBorderWidth;
                    self.answerDeskImageView.borderColor = LineGrayColor
                    
                    break;
                    
                case StudentFree:
                    self.answerDeskImageView.borderType = BorderTypeDashed;
                    self.answerDeskImageView.borderWidth = kDeskBorderWidth;
                    self.answerDeskImageView.borderColor = standard_Red;
                    
                    break;
                    
                case StudentLive:
                    
                    
                    self.answerDeskImageView.borderType = BorderTypeSolid;
                    self.answerDeskImageView.borderWidth = kDeskBorderWidth;
                    self.answerDeskImageView.borderColor = LineGrayColor
                    self.mStudentImage.alpha = 1
                    self.answerDeskImageView.addInnerShadow(withRadius: 3, andAlpha: 0.25)
                    self.answerDeskImageView.backgroundColor = UIColor.white
                    
                    break;
                    
                case StudentLiveBackground:
                    
                    self.answerDeskImageView.borderType = BorderTypeSolid;
                    self.answerDeskImageView.borderWidth = kDeskBorderWidth;
                    self.answerDeskImageView.borderColor = standard_Red
                    
                    break;
                    
                case StudentOccupied:
                    
                    self.answerDeskImageView.borderType = BorderTypeDashed;
                    self.answerDeskImageView.borderWidth = kDeskBorderWidth;
                    self.answerDeskImageView.borderColor = standard_Red
                    
                    break;
                    
                case StudentPreAllocated:
                    
                    self.answerDeskImageView.borderType = BorderTypeDashed;
                    self.answerDeskImageView.borderWidth = kDeskBorderWidth;
                    self.answerDeskImageView.borderColor = standard_Red
                    
                    break
                    
                default:
                    self.answerDeskImageView.borderType = BorderTypeSolid;
                    self.answerDeskImageView.borderWidth = kDeskBorderWidth;
                    
                    break
                }  
        })
        
        
    }
    
    // MARK: - Student Answers functions
    func setNewSubTopicStarted(_ isStarted:Bool)
    {
        
        
        
        if isStarted == true
        {
            
            if StudentState == StudentLive || StudentState == StudentLiveBackground
             {
                     mProgressView.isHidden = false
            }
           
        }
        else
        {
            mProgressView.isHidden =  true
        }
        
        
    }
    
    
    func setProgressValue(_ progressValue :Float)
    {
        
        if progressValue < 33
        {
            mProgressView.progressTintColor = standard_Red
        }
        else if progressValue >= 33 && progressValue < 66
        {
            mProgressView.progressTintColor = standard_Yellow
        }
        else
        {
            mProgressView.progressTintColor = standard_Green
        }
        
        
        
        
        mProgressView.progress = Float(progressValue) / 100
    }
    
    
    func setCurrentQuestionDetails(_ questionDetails:AnyObject)
    {
         _currentQuestionDetials = questionDetails
    }
    
    func studentSentAnswerWithAnswerString(_ answerString:String, withQuestionDetails details:AnyObject) {
        currentAnswerRecievedState = .Recieved
        _currentQuestionDetials = details
        SSTeacherDataSource.sharedDataSource.getStudentsAswerWithAnswerId(answerString, withDelegate: self)
    }
    
    
    func studentAnswerWithdrawn()
    {
         teacherClearedQuestion()
        
        mQuestionStateImage.isHidden = false
    }
    
    
    
    func setDontKnowMessageFromStudent()
    {
        answerContainerView.addDontKnowImage()
        currentAnswerState = .answerDontKnow
        currentAnswerRecievedState = .Recieved
        
        mQuestionStateImage.isHidden = true
//        mMiddleStudentName.hidden = true
//        mStudentName.hidden = false
        mQueryTextLable.isHidden = true
        
        answerContainerView.isHidden = false
        
        if isQueryPresent == true
        {
            mDoubtImageview.isHidden = false
            mQueryTextLable.isHidden = true
            
        }
    }
    
    func didGetStudentsAnswerWithDetails(_ details: AnyObject)
    {
        mQuestionStateImage.isHidden = true
//        mMiddleStudentName.hidden = true
//        mStudentName.hidden = false
        _currentAnswerDetails = details
        mQueryTextLable.isHidden = true
        setStudentCurrentState(StudentLive)
        answerContainerView.isHidden = false
        
        if isQueryPresent == true
        {
            mDoubtImageview.isHidden = false
            mQueryTextLable.isHidden = true
            
        }
        
        if let questionType = _currentQuestionDetials.object(forKey: kQuestionType) as? String
        {
            
            if (questionType  == kOverlayScribble  || questionType == kFreshScribble)
            {
                
                
                if let ScribbleId = _currentQuestionDetials.object(forKey: "Scribble") as? String{
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
        
        
        currentAnswerState = .answerRecieved
        
        if delegate().responds(to: #selector(StundentDeskViewDelegate.delegateStudentAnswerDownloadedWithDetails(_:withStudentDict:)))
        {
            delegate().delegateStudentAnswerDownloadedWithDetails!(details, withStudentDict:currentStudentsDict)
            
        }
        
    }
    
    
    func setOneStringAnswerWithText(_ answer:String)
    {
        
        mQuestionStateImage.isHidden = true
//        mMiddleStudentName.hidden = true
//        mStudentName.hidden = false
        
        mQueryTextLable.isHidden = true
        setStudentCurrentState(StudentLive)
        answerContainerView.isHidden = false
        
        if isQueryPresent == true
        {
            mDoubtImageview.isHidden = false
            mQueryTextLable.isHidden = true
            
        }

        
        currentAnswerState = .answerRecieved
        answerContainerView.addOneStringAnswerWithString(answer)
    }
    
    
    
    func onDeskPressed()
    {
        
        if currentAnswerState == .answerRecieved
        {
                if let questionType = _currentQuestionDetials.object(forKey: kQuestionType) as? String
                {
                    
                    if (questionType  == kOverlayScribble  || questionType == kFreshScribble)
                    {
                        if delegate().responds(to: #selector(StundentDeskViewDelegate.delegateStudentCellPressedWithViewSubjectiveAnswerDetails(_:withStudentId:)))
                        {
                            
                            delegate().delegateStudentCellPressedWithViewSubjectiveAnswerDetails!(_currentAnswerDetails,  withStudentId:(currentStudentsDict.object(forKey: "StudentId") as? String)!)
                            
                        }
                        
                    }
                    else if (questionType == kText)
                    {
                        
                        if delegate().responds(to: #selector(StundentDeskViewDelegate.delegateStudentCellPressedWithViewSubjectiveAnswerDetails(_:withStudentId:)))
                        {
                            
                             delegate().delegateStudentCellPressedWithViewSubjectiveAnswerDetails!(_currentAnswerDetails,  withStudentId:(currentStudentsDict.object(forKey: "StudentId") as? String)!)
                            
                        }
                        
                        
                      
                    }
                    else if (questionType == kMatchColumn)
                    {
                        if delegate().responds(to: #selector(StundentDeskViewDelegate.delegateStudentCellPressedWithViewAnswerOptions(_:withStudentId:)))
                        {
                            
                            delegate().delegateStudentCellPressedWithViewAnswerOptions!(answerContainerView._studentFinalAnswerOptions,  withStudentId:(currentStudentsDict.object(forKey: "StudentId") as? String)!)
                            
                        }
                        
                    }
                    else if (questionType == kMCQ) || (questionType == kMRQ)
                    {
                        if delegate().responds(to: #selector(StundentDeskViewDelegate.delegateStudentCellPressedWithViewAnswerOptions(_:withStudentId:)))
                        {
                            
                             delegate().delegateStudentCellPressedWithViewAnswerOptions!(answerContainerView._studentFinalAnswerOptions,  withStudentId:(currentStudentsDict.object(forKey: "StudentId") as? String)!)

                        }
                        
                        
                    }
                
                
               
                
            }
        }
        else if currentAnswerState == .answerEvaluated
        {
            if delegate().responds(to: #selector(StundentDeskViewDelegate.delegateStudentCellPressedWithEvaluationDetails(_:withStudentId:)))
            {
                
                delegate().delegateStudentCellPressedWithEvaluationDetails!(_currentEvaluationDetail,  withStudentId:(currentStudentsDict.object(forKey: "StudentId") as? String)!)
                
            }
        }
        else if isQueryPresent == true
        {
            if delegate().responds(to: #selector(StundentDeskViewDelegate.delegateStudentQueryWithDetails(_:withStudentDict:)))
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
        
        currentAnswerState = .answerCleared
        currentAnswerRecievedState = .Cleared
        
        if isQueryPresent == true
        {
            mDoubtImageview.isHidden = true
            mQueryTextLable.isHidden = false
            
//            mStudentName.hidden = false
//            mMiddleStudentName.hidden = true

        }
        else
        {
//            mStudentName.hidden = true
//            mMiddleStudentName.hidden = false

        }
        
        mQuestionStateImage.isHidden = true
        answerContainerView.isHidden = true
               
    }
    
    
    
    
    
    func setQueryDetails(_ queryDetails:AnyObject)
    {
        
        let annonymus =  queryDetails.object(forKey: "Anonymous") as! String
        
        if annonymus == "1"{
            return
        }
        isQueryPresent = true
        setStudentCurrentState(StudentLive)
        currentQueryDetails = queryDetails
        if currentAnswerState == .answerRecieved || currentAnswerState == .answerEvaluated || currentAnswerState == .answerDontKnow
        {
            mDoubtImageview.isHidden = false
            mQueryTextLable.isHidden = true
           
        }
        else
        {
            mDoubtImageview.isHidden = true
            mQueryTextLable.isHidden = false
            
//            mStudentName.hidden = false
//            mMiddleStudentName.hidden = true


            
        }
        
        if let QueryText = queryDetails.object(forKey: "QueryText") as? String
        {
            mQueryTextLable.text = QueryText
           
        }
        
    }
    
    func queryDismissed()
    {
        mDoubtImageview.isHidden = true
        mQueryTextLable.isHidden = true
        isQueryPresent = false
        
        if currentAnswerState == .answerCleared
        {
//            mStudentName.hidden = true
//            mMiddleStudentName.hidden = false
        }
        
    }
    
    
    func setReplayEvaluatedWithDetails(_ details:AnyObject)
    {
        _currentEvaluationDetail = details
        answerContainerView.setStudentEvaluationStatusWithDetails(details)
        currentAnswerState = .answerEvaluated
    }
    
    func getSeatIdAndStudentId() ->(seatId:String , StudentId :String)
    {
        
        var StudentIdValue = "0"
        
        var seatIdvalue = "0"
        
        if currentStudentsDict != nil
        {
            if let StudentId = currentStudentsDict.object(forKey: "StudentId") as? String
            {
                StudentIdValue = StudentId
            }
            
            
            if let seatId = currentStudentsDict.object(forKey: "SeatId") as? String
            {
                seatIdvalue = seatId
            }
            

        }
        
        
        
        return (seatIdvalue , StudentIdValue)
    }
    

}


