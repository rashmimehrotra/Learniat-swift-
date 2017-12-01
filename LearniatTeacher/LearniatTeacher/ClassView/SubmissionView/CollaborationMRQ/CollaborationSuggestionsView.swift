//
//  CollaborationSuggestionsView.swift
//  LearniatTeacher
//
//  Created by Deepak MK on 01/02/17.
//  Copyright © 2017 Mindshift. All rights reserved.
//

import Foundation

@objc protocol CollaborationSuggestionsViewDelegate
{
    
    
    @objc optional func delegateNewQuestionAddedWithSuggestions(selectedSuggestion:NSMutableArray, withQuestionID questionId:String)
    
    @objc optional func delegateCollaborationDismissed()
    
    
}

class CollaborationSuggestionsView: UIView,SSTeacherDataSourceDelegate
{
    var mProgressView = UIProgressView()
    
    var mFirstBubble = UILabel()
    
    var mSeconBubble = UILabel()
    
    var mThirdBubble = UILabel()
    
    var  mAddQuestionButton = UIButton()

    var mSelectQuestionLabel = UILabel()
    
    var mScrollView         = UIScrollView()
    
    var isSaveAndExit = false
    
    var mSaveQuestionButton = UIButton()
    
    var currentYPosition:CGFloat = 10
    
    var currentX:CGFloat  = 10
    
    var mSavedSuggestionsDetails:AnyObject!
    
    var selectedCount = 0
    
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
        
        
        
    }
    
    
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func loadAllsubViewWithCategoryName(categoryName:String)
    {
        
        
        
        
        let mTopbarImageView = UIImageView(frame: CGRect(x: 0, y: 0,width: self.frame.size.width, height: 44))
        mTopbarImageView.backgroundColor = UIColor.white
        self.addSubview(mTopbarImageView)
        mTopbarImageView.isUserInteractionEnabled = true
        
        
        mAddQuestionButton = UIButton(frame: CGRect(x: mTopbarImageView.frame.size.width - 410,  y: 0, width: 400 ,height: mTopbarImageView.frame.size.height))
        mTopbarImageView.addSubview(mAddQuestionButton)
        mAddQuestionButton.addTarget(self, action: #selector(CollaborationSuggestionsView.onAddQuestion), for: UIControlEvents.touchUpInside)
        mAddQuestionButton.setTitleColor(lightGrayColor, for: UIControlState())
        mAddQuestionButton.setTitle("Add Question", for: UIControlState())
        mAddQuestionButton.contentHorizontalAlignment = UIControlContentHorizontalAlignment.right
        mAddQuestionButton.titleLabel?.font = UIFont(name: helveticaMedium, size: 20)
        
        
        let  mBackButton = UIButton(frame: CGRect(x: 10,  y: 0, width: 120 ,height: mTopbarImageView.frame.size.height))
        mTopbarImageView.addSubview(mBackButton)
        mBackButton.addTarget(self, action: #selector(CollaborationSuggestionsView.onDismissQuestion), for: UIControlEvents.touchUpInside)
        mBackButton.setTitleColor(standard_Button, for: UIControlState())
        mBackButton.setTitle("Dismiss", for: UIControlState())
        mBackButton.contentHorizontalAlignment = UIControlContentHorizontalAlignment.left
        mBackButton.titleLabel?.font = UIFont(name: helveticaMedium, size: 20)
        
        
        mSaveQuestionButton = UIButton(frame: CGRect(x: mBackButton.frame.origin.x + mBackButton.frame.size.width + 10,  y: 0, width: 200 ,height: mTopbarImageView.frame.size.height))
       mTopbarImageView.addSubview(mSaveQuestionButton)
        mSaveQuestionButton.addTarget(self, action: #selector(CollaborationSuggestionsView.onSaveAndExitQuestion), for: UIControlEvents.touchUpInside)
        mSaveQuestionButton.setTitleColor(standard_Button_Disabled, for: UIControlState())
        mSaveQuestionButton.setTitle("Save & Exit", for: UIControlState())
        mSaveQuestionButton.contentHorizontalAlignment = UIControlContentHorizontalAlignment.left
        mSaveQuestionButton.titleLabel?.font = UIFont(name: helveticaMedium, size: 20)

        
        
        mProgressView.frame = CGRect(x: 60, y: mTopbarImageView.frame.origin.y + mTopbarImageView.frame.size.height + 30, width: self.frame.size.width - 120, height: 10)
        mProgressView.setProgress(0.5, animated: true)
        self.addSubview(mProgressView)
        mProgressView.progressTintColor = standard_Green
        mProgressView.trackTintColor = standard_TextGrey
        
        
        mFirstBubble.frame = CGRect(x: mProgressView.frame.origin.x - 10 , y: mProgressView.frame.origin.y - 7, width: 15, height: 15)
        mFirstBubble.backgroundColor = standard_Green
        mFirstBubble.layer.cornerRadius = mFirstBubble.frame.size.width/2
        self.addSubview(mFirstBubble)
        mFirstBubble.font =  UIFont(name: helveticaMedium, size: 20);
        mFirstBubble.layer.masksToBounds = true


        
        mSeconBubble.frame = CGRect(x:(( (mProgressView.frame.origin.x + mProgressView.frame.size.width) - mFirstBubble.frame.size.width)/2)   , y: mFirstBubble.frame.origin.y , width: mFirstBubble.frame.size.width, height: mFirstBubble.frame.size.height)
        mSeconBubble.backgroundColor = whiteBackgroundColor
        mSeconBubble.layer.cornerRadius = mFirstBubble.frame.size.width/2
        mSeconBubble.layer.borderWidth = 2
        mSeconBubble.layer.borderColor = standard_TextGrey.cgColor
        self.addSubview(mSeconBubble)
        mSeconBubble.font =  UIFont(name: helveticaMedium, size: 20);
        
        
        mThirdBubble.frame = CGRect(x: (mProgressView.frame.origin.x + mProgressView.frame.size.width) , y: mFirstBubble.frame.origin.y , width: mFirstBubble.frame.size.width, height: mFirstBubble.frame.size.height)
        mThirdBubble.backgroundColor = whiteBackgroundColor
        mThirdBubble.layer.cornerRadius = mFirstBubble.frame.size.width/2
        mThirdBubble.layer.borderWidth = 2
        mThirdBubble.layer.borderColor = standard_TextGrey.cgColor
        self.addSubview(mThirdBubble)
        mThirdBubble.font =  UIFont(name: helveticaMedium, size: 20);
        
        
        mSeconBubble.frame = CGRect(x: (((mProgressView.frame.origin.x + mProgressView.frame.size.width) - 30)/2 )  , y: mProgressView.frame.origin.y - 15, width: 30, height: 30)
        mSeconBubble.backgroundColor = standard_Green
        mSeconBubble.layer.borderWidth = 0
        mSeconBubble.layer.cornerRadius = mSeconBubble.frame.size.width/2
        mSeconBubble.layer.masksToBounds = true
        mSeconBubble.text = "2"
        mSeconBubble.textColor = whiteColor
        mSeconBubble.textAlignment = .center
        
        
        mSelectQuestionLabel.frame = CGRect(x: mSaveQuestionButton.frame.origin.x + mSaveQuestionButton.frame.size.width, y: 0, width: self.frame.size.width-(mSaveQuestionButton.frame.origin.x + mSaveQuestionButton.frame.size.width + mAddQuestionButton.frame.size.width), height: mTopbarImageView.frame.size.height)
        self.addSubview(mSelectQuestionLabel)
        mSelectQuestionLabel.text = "Please select at least two options for category : ".appending(categoryName)
        mSelectQuestionLabel.textColor = standard_TextGrey
        mSelectQuestionLabel.textAlignment = .center
        mSelectQuestionLabel.font =  UIFont(name: helveticaMedium, size: 16);
        mSelectQuestionLabel.numberOfLines = 2
        
        mScrollView.frame = CGRect(x: 0, y: mProgressView.frame.origin.y  + 80 , width: self.frame.size.width, height: self.frame.size.height - (mSelectQuestionLabel.frame.origin.y + mSelectQuestionLabel.frame.size.height))
        self.addSubview(mScrollView)

    }
    
    func addElementsWithElementsArray(ElementsDetails:NSMutableArray) {
        for mElement in ElementsDetails {
            let msuggestionCell = CollaborationElementCell(frame: CGRect(x: 10, y: currentYPosition, width: 0, height: 50))
            if currentX + msuggestionCell.SetSuggestionDetails(mElement as AnyObject).width > self.frame.size.width {
                currentYPosition = currentYPosition + msuggestionCell.frame.height + 10
                currentX = 10
            }
            msuggestionCell.frame = CGRect(x: currentX, y: currentYPosition, width: msuggestionCell.SetSuggestionDetails(mElement as AnyObject).width, height: 50)
            mScrollView.addSubview(msuggestionCell)
            msuggestionCell.layer.cornerRadius = 5
            currentX = currentX + msuggestionCell.frame.size.width + 10
            mScrollView.contentSize = CGSize(width: 0, height: currentYPosition)
        }
    }
    
    func addSuggestionWithDetails(_ details:AnyObject)
    {
       
        let msuggestionCell = CollaborationSuggestionCell(frame: CGRect(x: 10, y: currentYPosition, width: 0, height: 50))
        msuggestionCell.setdelegate(self)
        
        if currentX + msuggestionCell.SetSuggestionDetails(details).width > self.frame.size.width
        {
            currentYPosition = currentYPosition + msuggestionCell.frame.height + 10
            currentX = 10
        }
        
        
        msuggestionCell.frame = CGRect(x: currentX, y: currentYPosition, width: msuggestionCell.SetSuggestionDetails(details).width, height: 50)
        mScrollView.addSubview(msuggestionCell)
        msuggestionCell.layer.cornerRadius = 5
        
        
       currentX = currentX + msuggestionCell.frame.size.width + 10
        
        
        
        
        mScrollView.contentSize = CGSize(width: 0, height: currentYPosition)
        
    }
    
    
    
   
    
    func getSelectedSuggestions()->(selected:NSMutableArray, SuggestionIDList:String, mSugeestionStateLIst:String, suggestionTextDictonary:NSMutableDictionary, studentsIdArrya:NSMutableArray)
    {
        let selectedSuggestions = NSMutableArray()
        let suggestionsId = NSMutableArray()
        let suggestionsStates = NSMutableArray()
        let suggestionsDictonary = NSMutableDictionary()
        let StudentsIDArray = NSMutableArray()
        
        
        let SuggestionCellSubViews = mScrollView.subviews.flatMap{ $0 as? CollaborationSuggestionCell }
        for mSuggestionsSubView in SuggestionCellSubViews
        {
            if mSuggestionsSubView.isKind(of: CollaborationSuggestionCell.self)
            {
                
                
                
                if let studentId = mSuggestionsSubView.mSuggestionDetails.object(forKey:"studentID") as? String
                {
                    StudentsIDArray.add(studentId)
                }
                
                
                if  mSuggestionsSubView.mCurrentSelectedState == .selected
                {
                    
                    let suggestionId = mSuggestionsSubView.mSuggestionDetails.object(forKey: "SuggestionId") as! String
                    
                    selectedSuggestions.add(mSuggestionsSubView.mSuggestionDetails)
                    
                    suggestionsDictonary.setObject(mSuggestionsSubView.mSuggestionDetails.object(forKey: "suggestion") as! String, forKey: suggestionId as NSCopying )
                    
                    suggestionsId.add(suggestionId)
                    
                    suggestionsStates.add("29")
                    
                }
                else if mSuggestionsSubView.mCurrentSelectedState == .rejected
                {
                    suggestionsId.add(mSuggestionsSubView.mSuggestionDetails.object(forKey: "SuggestionId") as! String)
                    suggestionsStates.add("28")
                }
                else
                {
                    suggestionsId.add(mSuggestionsSubView.mSuggestionDetails.object(forKey: "SuggestionId") as! String)
                    suggestionsStates.add("27")
                }
            }
        }
        
        
        let ElementCellSubViews = mScrollView.subviews.flatMap{ $0 as? CollaborationElementCell }
        
        for mSuggestionsSubView in ElementCellSubViews
        {
            if mSuggestionsSubView.isKind(of: CollaborationElementCell.self)
            {
                if  mSuggestionsSubView.mCurrentSelectedState == .selected
                {
                    
                    let suggestionId = mSuggestionsSubView.mSuggestionDetails.object(forKey: "SuggestionId") as! String
                    
                    selectedSuggestions.add(mSuggestionsSubView.mSuggestionDetails)
                    
                    suggestionsDictonary.setObject(mSuggestionsSubView.mSuggestionDetails.object(forKey: "ElementText") as! String, forKey: suggestionId as NSCopying )
                    
                    suggestionsId.add(suggestionId)
                    
                    suggestionsStates.add("29")
                    
                }
                else if mSuggestionsSubView.mCurrentSelectedState == .rejected
                {
                    suggestionsId.add(mSuggestionsSubView.mSuggestionDetails.object(forKey: "SuggestionId") as! String)
                    suggestionsStates.add("28")
                }
                
            }
        }
        
        
        return (selectedSuggestions,suggestionsId.componentsJoined(by: ";;;"),suggestionsStates.componentsJoined(by: ";;;"),suggestionsDictonary,StudentsIDArray)
        
    }
    
    
    func onAddQuestion()
    {
        isSaveAndExit = false
        SSTeacherDataSource.sharedDataSource.SaveSuggestionStateWithSuggestions(Sugguestion: getSelectedSuggestions().SuggestionIDList, withState: getSelectedSuggestions().mSugeestionStateLIst, WithDelegate: self)
        
//        if getSelectedSuggestions().selected.count >= 2
//        {
//
//        }
    }
    
   
    func onSaveAndExitQuestion() {
        if getSelectedSuggestions().selected.count >= 2{
            isSaveAndExit = true
            SSTeacherDataSource.sharedDataSource.SaveSuggestionStateWithSuggestions(Sugguestion: getSelectedSuggestions().SuggestionIDList, withState: getSelectedSuggestions().mSugeestionStateLIst, WithDelegate: self)
        }
    }
    
    
    func didGetSaveSuggestionStateWithDetails(_ details: AnyObject) {
        mSavedSuggestionsDetails = details
        let mSuggestionStateArray = getSelectedSuggestions().mSugeestionStateLIst.components(separatedBy: ";;;")
        let mStudentsIdsArray = getSelectedSuggestions().studentsIdArrya
        for indexValue in 0 ..< mStudentsIdsArray.count {
         SSTeacherMessageHandler.sharedMessageHandler.sendCollaborationQuestionStatus(
            mStudentsIdsArray.object(at: indexValue) as! String ,
            withStatus: mSuggestionStateArray[indexValue] )
        }
        if isSaveAndExit == true {
            onDismissQuestion()
        } else {
            SSTeacherDataSource.sharedDataSource.recordQuestionWithScribbleId("", withQuestionName: "t", WithType: "2", withTopicId: SSTeacherDataSource.sharedDataSource.startedSubTopicId, WithDelegate: self)
        }
    }
    
    func didGetQuestionRecordedWithDetaisl(_ details: AnyObject)
    {
        
        
      
        print(details)
        
        let mElementsList = NSMutableArray()
        
        if let mSuggestionsList =  mSavedSuggestionsDetails.object(forKey: "SuggestionContainer") as? NSMutableDictionary
        {
            if let mSuggestionsList =  mSuggestionsList.object(forKey: "SuggestionArray") as? NSMutableArray
            {
                for mElements in mSuggestionsList
                {
                    if let ElementFlag =  (mElements as AnyObject).object(forKey: "ElementFlag") as? String
                    {
                        if ElementFlag == "1"
                        {
                            mElementsList.add(mElements)
                        }
                    }
                }
                
                
                 getDelegate().delegateNewQuestionAddedWithSuggestions!(selectedSuggestion: mElementsList, withQuestionID:details.object(forKey: "QuestionId") as! String)
            }
        }
       
    }
    
    func onDismissQuestion()
    {
        getDelegate().delegateCollaborationDismissed!()
    }
    
    func delegateOptionTouched()
    {
        if getSelectedSuggestions().selected.count >= 2
        {
            mAddQuestionButton.setTitleColor(standard_Button, for: UIControlState())
            mSaveQuestionButton.setTitleColor(standard_Button, for: UIControlState())
        }
        else
        {
            mAddQuestionButton.setTitleColor(lightGrayColor, for: UIControlState())
            mSaveQuestionButton.setTitleColor(lightGrayColor, for: UIControlState())
        }
    }
    
}
