//
//  CollaborationMRQView.swift
//  LearniatTeacher
//
//  Created by Deepak MK on 01/02/17.
//  Copyright © 2017 Mindshift. All rights reserved.
//

import Foundation

@objc protocol CollaborationMRQViewDelegate
{
    
    
    
    @objc optional func delegateQuestionCreationDismissed()
    
    
    @objc optional func delegateQuestionSentWithDetails(details:AnyObject)
    
    
}

class CollaborationMRQView: UIView,SSTeacherDataSourceDelegate,CollaborationCategoryViewDelegate,CollaborationSuggestionsViewDelegate
{
   
    
    
    var currentQuestionDetails : AnyObject!
    
    var mCategoryView   = CollaborationCategoryView()
    
    var mSuggestionView = CollaborationSuggestionsView()
    
    var mQuestionView   : CollaborationQuestionView!
    
//    var  mSaveQuestionButton = UIButton()
    
    var isSaveAndSend = false
    
    
//    var  mSendQuestionButton = UIButton()
    
    
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
    
    
    func loadAllSubView()
    {
        mCategoryView.frame = CGRect(x: 0, y: 0 , width: self.frame.size.width , height: self.frame.size.height)
        self.addSubview(mCategoryView)
        mCategoryView.loadAllSubView()
        mCategoryView.setdelegate(self)
        mCategoryView.backgroundColor = UIColor.clear
    }
    
    
    func delegateCategoryCreatedWithName(Category:String)
    {
        
            mCategoryView.isHidden = true
    
        mSuggestionView.frame = CGRect(x: 0, y: 0 , width: self.frame.size.width , height: self.frame.size.height)
        self.addSubview(mSuggestionView)
        self.bringSubview(toFront: mSuggestionView)
        mSuggestionView.loadAllsubViewWithCategoryName(categoryName: Category)
        mSuggestionView.setdelegate(self)
        mSuggestionView.backgroundColor = UIColor.clear
        
    }
    
    func delegateCategorySelectedWithName(Category:String, withElements elements:NSMutableArray)
    {
        mCategoryView.isHidden = true
        
        mSuggestionView.frame = CGRect(x: 0, y: 0 , width: self.frame.size.width , height: self.frame.size.height)
        self.addSubview(mSuggestionView)
        self.bringSubview(toFront: mSuggestionView)
        mSuggestionView.loadAllsubViewWithCategoryName(categoryName: Category)
        mSuggestionView.addElementsWithElementsArray(ElementsDetails: elements)
        mSuggestionView.setdelegate(self)
        mSuggestionView.backgroundColor = UIColor.clear
        
    }
    
    func delegateNewQuestionAddedWithSuggestions(selectedSuggestion:NSMutableArray, withQuestionID questionId:String)
    {
        mSuggestionView.isHidden = true
        
        if mQuestionView == nil
        {
            mQuestionView = CollaborationQuestionView(frame:CGRect(x: 0, y: 0 , width: self.frame.size.width , height: self.frame.size.height))
            mQuestionView.setdelegate(self)
            self.addSubview(mQuestionView)
        }
        mQuestionView.isHidden = false
        mQuestionView.addSelectedOptions(Options: selectedSuggestion, withQuestionID: questionId)

    }
    
    func addCollaborationSuggestionWithDetails(_ details:AnyObject)
    {
        mSuggestionView.addSuggestionWithDetails(details)
    }
    
   func delegateCollaborationQuestionSentWithDetails(details:AnyObject)
   {
     getDelegate().delegateQuestionSentWithDetails!(details: details)
    }
   func delegateQuestionUpdatedAndSaved()
   {
        getDelegate().delegateQuestionCreationDismissed!()
    
    }
   func delegateCollaborationDismissed()
   {
        getDelegate().delegateQuestionCreationDismissed!()
    }
 

}
