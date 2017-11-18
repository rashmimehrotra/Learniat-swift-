//
//  CollaborationCategoryView.swift
//  LearniatTeacher
//
//  Created by Deepak MK on 14/03/17.
//  Copyright © 2017 Mindshift. All rights reserved.
//

import Foundation

@objc protocol CollaborationCategoryViewDelegate
{
    
    
    @objc optional func delegateCategoryCreatedWithName(Category:String)
    
    
    @objc optional func delegateCategorySelectedWithName(Category:String, withElements elements:NSMutableArray)
    
    @objc optional func delegateCollaborationDismissed()
    
    
}


class CollaborationCategoryView: UIView,SSTeacherDataSourceDelegate,UITextFieldDelegate {
    
    
    var mProgressView = UIProgressView()
    
    var mFirstBubble = UILabel()
    
    var mSeconBubble = UILabel()
    
    var mThirdBubble = UILabel()
    
    var  mAddQuestionButton = UIButton()
    
    var mCategoryTextView = CustomTextView()
    
    var mSelectQuestionLabel = UILabel()
    
    var mActivityIndicatore : UIActivityIndicatorView = UIActivityIndicatorView()
    
    var mPreviousCategoryView = CollaborationPreviousCategoryView()
    
    var mSelectedCategoryDetails:AnyObject!
    
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
        
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func loadAllSubView()
    {
        let mTopbarImageView = UIImageView(frame: CGRect(x: 0, y: 0,width: self.frame.size.width, height: 44))
        mTopbarImageView.backgroundColor = UIColor.white
        self.addSubview(mTopbarImageView)
        mTopbarImageView.isUserInteractionEnabled = true
        
        
        mAddQuestionButton = UIButton(frame: CGRect(x: mTopbarImageView.frame.size.width - 410,  y: 0, width: 400 ,height: mTopbarImageView.frame.size.height))
        mTopbarImageView.addSubview(mAddQuestionButton)
        mAddQuestionButton.addTarget(self, action: #selector(CollaborationCategoryView.onAddCollaboration), for: UIControlEvents.touchUpInside)
        mAddQuestionButton.setTitleColor(standard_Button, for: UIControlState())
        mAddQuestionButton.setTitle("Add Category", for: UIControlState())
        mAddQuestionButton.contentHorizontalAlignment = UIControlContentHorizontalAlignment.right
        mAddQuestionButton.titleLabel?.font = UIFont(name: helveticaMedium, size: 20)
        
        
        let  mBackButton = UIButton(frame: CGRect(x: 10,  y: 0, width: 200 ,height: mTopbarImageView.frame.size.height))
        mTopbarImageView.addSubview(mBackButton)
        mBackButton.addTarget(self, action: #selector(CollaborationCategoryView.onDismissQuestion), for: UIControlEvents.touchUpInside)
        mBackButton.setTitleColor(standard_Button, for: UIControlState())
        mBackButton.setTitle("Dismiss", for: UIControlState())
        mBackButton.contentHorizontalAlignment = UIControlContentHorizontalAlignment.left
        mBackButton.titleLabel?.font = UIFont(name: helveticaMedium, size: 20)
        
        
        
        mProgressView.frame = CGRect(x: 60, y: mTopbarImageView.frame.origin.y + mTopbarImageView.frame.size.height + 30, width: self.frame.size.width - 120, height: 10)
        mProgressView.setProgress(0, animated: true)
        self.addSubview(mProgressView)
        mProgressView.progressTintColor = standard_Green
        mProgressView.trackTintColor = standard_TextGrey
        
        
        mFirstBubble.frame = CGRect(x: mProgressView.frame.origin.x - 10 , y: mProgressView.frame.origin.y - 7, width: 15, height: 15)
        mFirstBubble.backgroundColor = whiteBackgroundColor
        mFirstBubble.layer.cornerRadius = mFirstBubble.frame.size.width/2
        mFirstBubble.layer.borderWidth = 2
        mFirstBubble.layer.borderColor = standard_TextGrey.cgColor
        self.addSubview(mFirstBubble)
        mFirstBubble.font =  UIFont(name: helveticaMedium, size: 20);
        
        
        mSeconBubble.frame = CGRect(x:( (mProgressView.frame.origin.x + mProgressView.frame.size.width) - mFirstBubble.frame.size.width)/2  , y: mFirstBubble.frame.origin.y , width: mFirstBubble.frame.size.width, height: mFirstBubble.frame.size.height)
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
        
        
        mFirstBubble.frame = CGRect(x: mProgressView.frame.origin.x - 15 , y: mProgressView.frame.origin.y - 15, width: 30, height: 30)
        mFirstBubble.backgroundColor = standard_Green
        mFirstBubble.layer.borderWidth = 0
        mFirstBubble.layer.cornerRadius = mFirstBubble.frame.size.width/2
        mFirstBubble.layer.masksToBounds = true
        mFirstBubble.text = "1"
        mFirstBubble.textColor = whiteColor
        mFirstBubble.textAlignment = .center
        
        
        mSelectQuestionLabel.frame = CGRect(x: 10, y: 0, width: self.frame.size.width-20, height: mTopbarImageView.frame.size.height)
        self.addSubview(mSelectQuestionLabel)
        mSelectQuestionLabel.text = "Please select or type category name"
        mSelectQuestionLabel.textColor = standard_TextGrey
        mSelectQuestionLabel.textAlignment = .center
        mSelectQuestionLabel.font =  UIFont(name: helveticaMedium, size: 20);
        
        
        mCategoryTextView = CustomTextView(frame:CGRect(x: 80,y: mProgressView.frame.origin.y  + 80 ,width: self.frame.size.width - 160, height: 100))
        self.addSubview(mCategoryTextView)
        mCategoryTextView.setdelegate(self)
        mCategoryTextView.mQuestionTextView.delegate = self
        mCategoryTextView.setPlaceHolder("Please type category name", withStartSting: "Category:-")
        
        
        mActivityIndicatore = UIActivityIndicatorView(activityIndicatorStyle: .gray)
        mActivityIndicatore.frame = CGRect(x: mCategoryTextView.frame.origin.x + mCategoryTextView.frame.size.width - 50, y: mCategoryTextView.frame.origin.y + (mCategoryTextView.frame.size.height / 2) - 20 , width: 40,height: 40)
        self.addSubview(mActivityIndicatore)
        
        mPreviousCategoryView.frame = CGRect(x: mCategoryTextView.frame.origin.x, y: mCategoryTextView.frame.origin.y + mCategoryTextView.frame.size.height, width: mCategoryTextView.frame.size.width, height: self.frame.size.height - (mCategoryTextView.frame.origin.y + mCategoryTextView.frame.size.height + 5))
        mPreviousCategoryView.loadAllSubview()
        mPreviousCategoryView.setdelegate(self)
        self.addSubview(mPreviousCategoryView)
        
        
        
    }
    
    
    func onAddCollaboration()
    {
        if mCategoryTextView.mQuestionTextView.text?.isEmpty == false
        {
            mCategoryTextView.mQuestionTextView.resignFirstResponder()
            
            SSTeacherDataSource.sharedDataSource.sendCategoryWithName(category: mCategoryTextView.mQuestionTextView.text!, withDescrpition: "", withTopicID: SSTeacherDataSource.sharedDataSource.startedSubTopicId,WithDelegate: self)
        }
        
        
        
    }
    
    
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange,
                   replacementString string: String) -> Bool
    {
       
        NSObject.cancelPreviousPerformRequests(
            withTarget: self,
            selector: #selector(CollaborationCategoryView.getHintsFromTextField),
            object: textField)
        self.perform(
            #selector(CollaborationCategoryView.getHintsFromTextField),
            with: textField,
            afterDelay: 0.5)
        
        
        
        
        return true
    }
    
    func getHintsFromTextField(textField: UITextField)
    {
        
        if textField.text?.isEmpty == false
        {
            mActivityIndicatore.startAnimating()
            SSTeacherDataSource.sharedDataSource.FetchCategoryWithName(InputCategoryname: textField.text!, withTopicId: SSTeacherDataSource.sharedDataSource.startedSubTopicId, WithDelegate: self)
        }
        else
        {
             mPreviousCategoryView.addPreviousCategoryWithCategoires(categories:NSMutableArray())
        }
        
        
    }
    
    
    func didGetCategoryFetchedWithDetails(_ details: AnyObject)
    {
        
        mActivityIndicatore.stopAnimating()
        
       if let mCategoryDetails =  details.object(forKey: "CategoryList") as? NSMutableDictionary
        {
            if let mCategory = mCategoryDetails.object(forKey: "Category") as? NSMutableArray
            {
               mPreviousCategoryView.addPreviousCategoryWithCategoires(categories: mCategory)
            }
            else if let mCategory = mCategoryDetails.object(forKey: "Category") as? NSMutableDictionary
            {
                
                let mutableArray = NSMutableArray()
                mutableArray.add(mCategory)
                
                mPreviousCategoryView.addPreviousCategoryWithCategoires(categories:mutableArray)
            }
            
        }
        else
       {
            mPreviousCategoryView.addPreviousCategoryWithCategoires(categories:NSMutableArray())
        }
        
        
        
        
    }
    
    
    func onDismissQuestion()
    {
        delegate().delegateCollaborationDismissed!()
    }
    
    
    
    
    func didGetCategoryCreatedWithDetails(_ details:AnyObject)
    {
     
        if let categroyId = details.object(forKey: "CategoryId") as? String
        {
            SSTeacherMessageHandler.sharedMessageHandler.sendCollaborationQuestionEnabledWithRoomId(SSTeacherDataSource.sharedDataSource.currentLiveSessionId, withType: "MRQ", withCategory: mCategoryTextView.mQuestionTextView.text!, withCategoryID: categroyId)
            
            delegate().delegateCategoryCreatedWithName!(Category: mCategoryTextView.mQuestionTextView.text!)
            
        }
        
        
    }
    
    
    func delegateCategoryIdSelectedWithDetails(details:AnyObject)
    {
        
        
        mSelectedCategoryDetails = details
        
        if let CategoryId = details.object(forKey: "CategoryId") as? String
        {
        
            if let CategoryTitle = details.object(forKey: "CategoryTitle") as? String
            {
                mCategoryTextView.mQuestionTextView.text = CategoryTitle
            }
            
            
                SSTeacherDataSource.sharedDataSource.selectCategoryWithCategoryID(categoryId: CategoryId, WithDelegate: self)
        }
       
    }
    
    func didGetCategorySelectedWithDetails(_ details: AnyObject) {
        if let CategoryId = mSelectedCategoryDetails.object(forKey: "CategoryId") as? String {
            if let CategoryTitle = mSelectedCategoryDetails.object(forKey: "CategoryTitle") as? String {
                SSTeacherMessageHandler.sharedMessageHandler.sendCollaborationQuestionEnabledWithRoomId( SSTeacherDataSource.sharedDataSource.currentLiveSessionId,  withType: "MRQ", withCategory: CategoryTitle, withCategoryID: CategoryId)
            }
            
            
        }
        if let ElementList = details.object(forKey: "ElementContainer") as? NSMutableDictionary
        {
            if let elements = ElementList.object(forKey: "Element") as? NSMutableArray
            {
               delegate().delegateCategorySelectedWithName!(Category: mCategoryTextView.mQuestionTextView.text!, withElements: elements)
            }
            else
            {
                delegate().delegateCategorySelectedWithName!(Category: mCategoryTextView.mQuestionTextView.text!, withElements: NSMutableArray())
            }
        }
        else
        {
            delegate().delegateCategorySelectedWithName!(Category: mCategoryTextView.mQuestionTextView.text!, withElements: NSMutableArray())
        }
        
        
        
        
    }
    
    
}
