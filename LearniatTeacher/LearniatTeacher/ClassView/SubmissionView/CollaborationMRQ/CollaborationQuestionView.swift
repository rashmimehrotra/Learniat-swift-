//
//  CollaborationQuestionView.swift
//  LearniatTeacher
//
//  Created by Deepak MK on 14/02/17.
//  Copyright © 2017 Mindshift. All rights reserved.
//

import Foundation

@objc protocol CollaborationQuestionViewDelegate
{
    
    
    
    @objc optional func delegateQuestionUpdatedAndSaved()
    
    @objc optional func delegateCollaborationDismissed()
    
    @objc optional func delegateCollaborationQuestionSentWithDetails(details:AnyObject)
    
    
}

class CollaborationQuestionView: UIView,SSTeacherDataSourceDelegate
{
    
    var mProgressView = UIProgressView()
    
    var mFirstBubble = UILabel()
    
    var mSeconBubble = UILabel()
    
    var mThirdBubble = UILabel()
    
    var  mAddQuestionButton = UIButton()
    
    var mSaveQuestionButton = UIButton()
    
    var mSelectQuestionLabel = UILabel()
    
    var mQuestionTextView : UITextField!

    var mSeperatorLine = UIImageView()

    var mScrollView         = UIScrollView()
    
    var mCurrentQuestionID  = ""
    
    var isSaveAndSend = false
    
    var _delgate: AnyObject!
    
    func setdelegate(_ delegate:AnyObject)
    {
        _delgate = delegate;
    }
    
    func   getDelegate()->AnyObject
    {
        return _delgate;
    }
    
    override init(frame: CGRect)
    {
        super.init(frame:frame)
        
        
        
        let mTopbarImageView = UIImageView(frame: CGRect(x: 0, y: 0,width: self.frame.size.width, height: 44))
        mTopbarImageView.backgroundColor = UIColor.white
        self.addSubview(mTopbarImageView)
        mTopbarImageView.isUserInteractionEnabled = true
        
        
        mAddQuestionButton = UIButton(frame: CGRect(x: mTopbarImageView.frame.size.width - 410,  y: 0, width: 400 ,height: mTopbarImageView.frame.size.height))
        mTopbarImageView.addSubview(mAddQuestionButton)
        mAddQuestionButton.addTarget(self, action: #selector(CollaborationQuestionView.onSendQuestion), for: UIControlEvents.touchUpInside)
        mAddQuestionButton.setTitleColor(standard_Button, for: UIControlState())
        mAddQuestionButton.setTitle("Send", for: UIControlState())
        mAddQuestionButton.contentHorizontalAlignment = UIControlContentHorizontalAlignment.right
        mAddQuestionButton.titleLabel?.font = UIFont(name: helveticaMedium, size: 20)
        
        
        
        
        
        
        let  mBackButton = UIButton(frame: CGRect(x: 10,  y: 0, width: 200 ,height: mTopbarImageView.frame.size.height))
        mTopbarImageView.addSubview(mBackButton)
        mBackButton.addTarget(self, action: #selector(CollaborationQuestionView.onDismissQuestion), for: UIControlEvents.touchUpInside)
        mBackButton.setTitleColor(standard_Button, for: UIControlState())
        mBackButton.setTitle("Dismiss", for: UIControlState())
        mBackButton.contentHorizontalAlignment = UIControlContentHorizontalAlignment.left
        mBackButton.titleLabel?.font = UIFont(name: helveticaMedium, size: 20)
        
        
        
        mSaveQuestionButton = UIButton(frame: CGRect(x: mBackButton.frame.origin.x + mBackButton.frame.size.width + 10,  y: 0, width: 300 ,height: mTopbarImageView.frame.size.height))
        mTopbarImageView.addSubview(mSaveQuestionButton)
        mSaveQuestionButton.addTarget(self, action: #selector(CollaborationQuestionView.onSaveAndExitQuestion), for: UIControlEvents.touchUpInside)
        mSaveQuestionButton.setTitleColor(standard_Button, for: UIControlState())
        mSaveQuestionButton.setTitle("Save & Exit", for: UIControlState())
        mSaveQuestionButton.contentHorizontalAlignment = UIControlContentHorizontalAlignment.left
        mSaveQuestionButton.titleLabel?.font = UIFont(name: helveticaMedium, size: 20)
        
        
        
        mProgressView.frame = CGRect(x: 60, y: mTopbarImageView.frame.origin.y + mTopbarImageView.frame.size.height + 30, width: self.frame.size.width - 120, height: 10)
        mProgressView.setProgress(1, animated: true)
        self.addSubview(mProgressView)
        mProgressView.progressTintColor = standard_Green
        mProgressView.trackTintColor = standard_TextGrey
        
        
        mFirstBubble.frame = CGRect(x: mProgressView.frame.origin.x - 10 , y: mProgressView.frame.origin.y - 7, width: 15, height: 15)
        mFirstBubble.backgroundColor = standard_Green
        mFirstBubble.layer.cornerRadius = mFirstBubble.frame.size.width/2
        self.addSubview(mFirstBubble)
        mFirstBubble.font =  UIFont(name: helveticaMedium, size: 20);
        mFirstBubble.layer.masksToBounds = true
        
        
        
        mSeconBubble.frame = CGRect(x:( (mProgressView.frame.origin.x + mProgressView.frame.size.width) - mFirstBubble.frame.size.width)/2  , y: mFirstBubble.frame.origin.y , width: mFirstBubble.frame.size.width, height: mFirstBubble.frame.size.height)
        mSeconBubble.backgroundColor = standard_Green
        mSeconBubble.layer.cornerRadius = mSeconBubble.frame.size.width/2
        self.addSubview(mSeconBubble)
        mSeconBubble.font =  UIFont(name: helveticaMedium, size: 20);
        mSeconBubble.layer.masksToBounds = true
        
        
        mThirdBubble.frame = CGRect(x: (mProgressView.frame.origin.x + mProgressView.frame.size.width) , y: mFirstBubble.frame.origin.y , width: mFirstBubble.frame.size.width, height: mFirstBubble.frame.size.height)
        mThirdBubble.backgroundColor = whiteBackgroundColor
        mThirdBubble.layer.cornerRadius = mFirstBubble.frame.size.width/2
        mThirdBubble.layer.borderWidth = 2
        mThirdBubble.layer.borderColor = standard_TextGrey.cgColor
        self.addSubview(mThirdBubble)
        mThirdBubble.font =  UIFont(name: helveticaMedium, size: 20);
        
        
        mThirdBubble.frame = CGRect(x: (mProgressView.frame.origin.x + mProgressView.frame.size.width) , y: mProgressView.frame.origin.y - 15, width: 30, height: 30)
        mThirdBubble.backgroundColor = standard_Green
        mThirdBubble.layer.borderWidth = 0
        mThirdBubble.layer.cornerRadius = mThirdBubble.frame.size.width/2
        mThirdBubble.layer.masksToBounds = true
        mThirdBubble.text = "3"
        mThirdBubble.textColor = whiteColor
        mThirdBubble.textAlignment = .center

        
        
        
        mQuestionTextView = UITextField(frame:CGRect(x: 50, y: mProgressView.frame.origin.y  + 80 ,width: self.frame.size.width - 100 ,height: 100))
        self.addSubview(mQuestionTextView)
        mQuestionTextView.placeholder = "Please add your question"
        mQuestionTextView.backgroundColor = UIColor.white
        mQuestionTextView.textAlignment = .center
        
        mSeperatorLine.frame = CGRect(x: 10, y: mQuestionTextView.frame.origin.y + mQuestionTextView.frame.size.height + 50, width: self.frame.size.width-20, height: 1)
        mSeperatorLine.backgroundColor = topicsLineColor
        self.addSubview(mSeperatorLine)
        
        
        
        mSelectQuestionLabel.frame = CGRect(x: 10, y: mSeperatorLine.frame.origin.y + mSeperatorLine.frame.size.height + 30, width: self.frame.size.width-20, height: 30)
        self.addSubview(mSelectQuestionLabel)
        mSelectQuestionLabel.text = "Please select correct answers"
        mSelectQuestionLabel.textColor = standard_TextGrey
        mSelectQuestionLabel.textAlignment = .center
        mSelectQuestionLabel.font =  UIFont(name: helveticaMedium, size: 20);

        
        
        mScrollView.frame = CGRect(x: 0, y: mSelectQuestionLabel.frame.origin.y + mSelectQuestionLabel.frame.size.height + 30, width: self.frame.size.width, height: self.frame.size.height - (mSelectQuestionLabel.frame.origin.y + mSelectQuestionLabel.frame.size.height + 30))
        self.addSubview(mScrollView)
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    
    }
    
    
    
    func addSelectedOptions(Options:NSMutableArray, withQuestionID questionId:String)
    {
        mCurrentQuestionID = questionId
        
        var currentXPosition:CGFloat = 10
        
        var optionsSize:CGFloat = (self.frame.size.width - 20) / CGFloat(Options.count)
        
        if optionsSize < 200
        {
            optionsSize = 200
        }
        
        
        for selectedOption in Options
        {
             let frame = CGRect(x:currentXPosition,y:10,width:optionsSize,height:mScrollView.frame.size.height - 20)
            let mQuestionOption = CollaborationQuestionCell(frame:frame)
            mQuestionOption.setdelegate( self)
            mQuestionOption.setOptionDetails(details: selectedOption as AnyObject)
            mScrollView.addSubview(mQuestionOption)
            currentXPosition = currentXPosition + mQuestionOption.frame.size.width + 10
            
            
        }
        
        mScrollView.contentSize = CGSize(width: currentXPosition, height: 0)
        
//        (x: currentXPosition, y: 10, width: mScrollView.frame.size.height - 20, height: mScrollView.frame.size.height - 20)
    }
    
    
    
    func isQuestionCreationCreationCompleted()->Bool
    {
        if mQuestionTextView.text?.isEmpty == false
        {
            let selectedSuggestions = NSMutableArray()
            
            let subViews = mScrollView.subviews.flatMap{ $0 as? CollaborationQuestionCell }
            for mSuggestionsSubView in subViews
            {
                if mSuggestionsSubView.isKind(of: CollaborationQuestionCell.self)
                {
                    if  mSuggestionsSubView.isCorrect == true
                    {
                        selectedSuggestions.add(mSuggestionsSubView.optionDetails.object(forKey:"ElementId") as! String)
                    }
                }
            }
            
            
            if selectedSuggestions.count > 0
            {
                return true
            }
            
        }
        
        return false
        
    }
    
    
    func getQestionName()->(questionName:String, optionsDetails:String, optionsState:String )
    {
        
        let selectedSuggestions = NSMutableArray()
        let selectionState = NSMutableArray()

        
        if mQuestionTextView.text?.isEmpty == false
        {
            
            
            let subViews = mScrollView.subviews.flatMap{ $0 as? CollaborationQuestionCell }
            for mSuggestionsSubView in subViews
            {
                if mSuggestionsSubView.isKind(of: CollaborationQuestionCell.self)
                {
                    
                    selectedSuggestions.add(mSuggestionsSubView.optionDetails.object(forKey: "ElementId") as! String)
                    
                    if  mSuggestionsSubView.isCorrect == true
                    {
                        selectionState.add("1")
                    }
                    else
                    {
                        selectionState.add("0")
                    }
                }
            }

        }
        
        return (mQuestionTextView.text!,selectedSuggestions.componentsJoined(by: ";;;"), selectionState.componentsJoined(by: ";;;"))
        
    }
    
    
    func onSendQuestion() {
        if isQuestionCreationCreationCompleted() == true {
            mSaveQuestionButton.isHidden = true
            mAddQuestionButton.setTitleColor(standard_TextGrey, for: .normal)
            mAddQuestionButton.isEnabled = false
            mQuestionTextView.resignFirstResponder()
            isSaveAndSend = true
            SSTeacherDataSource.sharedDataSource.updateRecorededQuestionWithQuestionLogId(mCurrentQuestionID, withQuestionName: getQestionName().questionName, withQuestionOptions: getQestionName().optionsDetails, withAnswerStates: getQestionName().optionsState, WithDelegate: self)
        } else {
            self.hideToastActivity()
           self.makeToast("Please select atleast one correct answer and type your question", duration: 5.0, position: .top)
        }
    }
    
    
    func onSaveAndExitQuestion(){
        if isQuestionCreationCreationCompleted() == true {
             isSaveAndSend = false
            mAddQuestionButton.isHidden = true
            
            mSaveQuestionButton.setTitleColor(standard_TextGrey, for: .normal)
            mSaveQuestionButton.isEnabled = false
            
            mQuestionTextView.resignFirstResponder()
            SSTeacherDataSource.sharedDataSource.updateRecorededQuestionWithQuestionLogId(mCurrentQuestionID, withQuestionName: getQestionName().questionName, withQuestionOptions: getQestionName().optionsDetails, withAnswerStates: getQestionName().optionsState, WithDelegate: self)
        } else {
            self.hideToastActivity()
             self.makeToast("Please select atleast one correct answer and type your question", duration: 5.0, position: .top)
        }
    }
   
    func didGetQuestionRecordedUpdatedWithDetaisl(_ details: AnyObject)
    {
       
        
        if isSaveAndSend == true
        {
            mQuestionTextView.resignFirstResponder()
            SSTeacherDataSource.sharedDataSource.fetchQuestionWithQuestionLogId(mCurrentQuestionID, WithDelegate: self)
        }
        else
        {
            getDelegate().delegateQuestionUpdatedAndSaved!()
            
            
        }
        
    }
    
    
    func didGetQuestionWithDetails(_ details: AnyObject)
    {
        
        
        
        var questionDetails:NSMutableDictionary = details as! NSMutableDictionary
        if let question = questionDetails.object(forKey: "Question") as? NSMutableDictionary {
            questionDetails = question
        }
        
        
        questionDetails.setObject(mCurrentQuestionID, forKey: "Id" as NSCopying)
        questionDetails.setObject(mQuestionTextView.text!, forKey: "Name" as NSCopying)
        getDelegate().delegateCollaborationQuestionSentWithDetails!(details: questionDetails)
    }
    
    func onDismissQuestion()
    {
        getDelegate().delegateCollaborationDismissed!()
    }
    
    func didOptionSelected() {
//        if isQuestionCreationCreationCompleted() == true {
//            mSaveQuestionButton.setTitleColor(standard_Button, for: UIControlState())
//            mSaveQuestionButton.isUserInteractionEnabled = false
//            mAddQuestionButton.setTitleColor(standard_Button, for: UIControlState())
//            mAddQuestionButton.isUserInteractionEnabled = false
//        } else {
//            mSaveQuestionButton.setTitleColor(standard_Button, for: UIControlState())
//            mSaveQuestionButton.isUserInteractionEnabled = false
//            mAddQuestionButton.setTitleColor(standard_Button, for: UIControlState())
//            mAddQuestionButton.isUserInteractionEnabled = false
//        }
    }
    
}
