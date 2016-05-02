//
//  SSTeacherLessonPlanView.swift
//  LearniatTeacher
//
//  Created by mindshift_Deepak on 16/04/16.
//  Copyright © 2016 Mindshift. All rights reserved.
//

import Foundation
class SSTeacherLessonPlanView: UIView,SSTeacherDataSourceDelegate, UISearchBarDelegate,UIPopoverControllerDelegate
{
    
    let mSendButton = UIButton()
    
    let mCancelButton = UIButton()
    
    var sendButtonSpinner : UIActivityIndicatorView!
    
    let  mTopbarImageView = UIImageView()
    
    var _currentSessionDetails:AnyObject!
    
    var MainTopicsView : LessonPlanMainView!
    
    var fullLessonPlanDetails    : AnyObject!
    
    let lessonPlanSearchBar = UISearchBar()
    
    
    
    override init(frame: CGRect)
    {
        
        super.init(frame:frame)
        
        
        self.backgroundColor = whiteBackgroundColor
        
        
        
         mTopbarImageView.frame = CGRectMake(0, 0, self.frame.size.width, 60)
        mTopbarImageView.backgroundColor = topbarColor
        self.addSubview(mTopbarImageView)
        mTopbarImageView.userInteractionEnabled = true
        
        
        
        mCancelButton.showsTouchWhenHighlighted = true;
        mCancelButton.frame = CGRectMake(10 , 0, 100,  mTopbarImageView.frame.size.height);
        mTopbarImageView.addSubview(mCancelButton);
        mCancelButton.setTitle("Cancel", forState:.Normal);
        mCancelButton.setTitleColor(UIColor.whiteColor(), forState:.Normal);
        mCancelButton.titleLabel?.font = UIFont(name: helveticaMedium, size: 20);
        mCancelButton.contentHorizontalAlignment = UIControlContentHorizontalAlignment.Left
        mCancelButton.addTarget(self, action: #selector(SSTeacherLessonPlanView.onCancelButton), forControlEvents: UIControlEvents.TouchUpInside)
        
        
        mSendButton.frame = CGRectMake(mTopbarImageView.frame.size.width - 100 , 0, 100 , mTopbarImageView.frame.size.height );
        mTopbarImageView.addSubview(mSendButton);
        mSendButton.setTitle("Done", forState:.Normal);
        mSendButton.setTitleColor(UIColor.whiteColor(), forState:.Normal);
        mSendButton.titleLabel?.font = UIFont(name: helveticaMedium, size: 20);
        mSendButton.highlighted = false;
        mSendButton.contentHorizontalAlignment = UIControlContentHorizontalAlignment.Center
        mSendButton.addTarget(self, action: #selector(SSTeacherLessonPlanView.onSendButton), forControlEvents: UIControlEvents.TouchUpInside)
        mSendButton.hidden = true
        
        sendButtonSpinner = UIActivityIndicatorView(activityIndicatorStyle:.WhiteLarge);
        sendButtonSpinner.frame = mSendButton.frame;
        mTopbarImageView.addSubview(sendButtonSpinner);
        sendButtonSpinner.hidden = false;
        sendButtonSpinner.startAnimating()
        
        
        MainTopicsView = LessonPlanMainView(frame: CGRectMake(0,mTopbarImageView.frame.size.height,self.frame.size.width,self.frame.size.height - mTopbarImageView.frame.size.height ))
        
        self.addSubview(MainTopicsView)
        
          lessonPlanSearchBar.frame = CGRectMake((mTopbarImageView.frame.size.width - 400)/2 , 20, 400, 40)
        lessonPlanSearchBar.placeholder = "Search"
        mTopbarImageView.addSubview(lessonPlanSearchBar)
        lessonPlanSearchBar.backgroundColor = UIColor.clearColor()
        lessonPlanSearchBar.barTintColor = topbarColor
        lessonPlanSearchBar.delegate = self
        lessonPlanSearchBar.barStyle = UIBarStyle.Default
        lessonPlanSearchBar.translucent = true
        lessonPlanSearchBar.tintColor = UIColor.whiteColor()
        let image = UIImage()
        lessonPlanSearchBar.backgroundImage = image
        lessonPlanSearchBar.setImage(UIImage(named: "LessonPLanDismissed.png"), forSearchBarIcon: .Clear, state: .Normal)
        
        
    }
    
    
    required init?(coder aDecoder: NSCoder)
    {
        fatalError("init(coder:) has not been implemented")
        
        
    }
    
    
    func onCancelButton()
    {
        self.removeFromSuperview()
    }
    
    func onSendButton()
    {
        
        if let ClassId = _currentSessionDetails.objectForKey("ClassId") as? String
        {
             SSTeacherDataSource.sharedDataSource.saveLessonPlan(ClassId, withTopicIdList: MainTopicsView.getAllSelectedtopicId(), withDelegate: self)
            sendButtonSpinner.hidden = false
            sendButtonSpinner.startAnimating()
            mSendButton.hidden = true
            
        }
        
    }
    
    
    func setCurrentSessionDetails(details:AnyObject)
    {
        
        _currentSessionDetails = details
        
        if let ClassId = details.objectForKey("ClassId") as? String
        {
            
            if let SubjectId = details.objectForKey("SubjectId") as? String
            {
                SSTeacherDataSource.sharedDataSource.getAllNodesWithClassId(ClassId, withSubjectId: SubjectId, withTopicId: "", withType: "", withDelegate: self)
            }
        }
    }
    
    
    
     // MARK: - datasource delegate functions
    
    func didGetAllNodesWithDetails(details: AnyObject)
    {
        
        sendButtonSpinner.hidden = true
        sendButtonSpinner.stopAnimating()
        mSendButton.hidden = false
        
        print(details)
        fullLessonPlanDetails = details
        MainTopicsView.setCurrentSessionDetails(_currentSessionDetails, withFullLessonPlanDetails: details)
        
        
        
        
    }
    
    func didGetLessonPlanSavedWithdetails(details: AnyObject)
    {
        sendButtonSpinner.hidden = true
        sendButtonSpinner.stopAnimating()
        mSendButton.hidden = false
        self.removeFromSuperview()
    }
    
    func didgetErrorMessage(message: String, WithServiceName serviceName: String)
    {
        sendButtonSpinner.hidden = true
        sendButtonSpinner.stopAnimating()
        mSendButton.hidden = false
    }
    
    
    // MARK: - search bar delegate functions
    
    func searchBarTextDidBeginEditing(searchBar: UISearchBar)
    {
        searchBar.showsCancelButton = true
        
    }
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar)
    {
        searchBar.resignFirstResponder()
        searchBar.showsCancelButton = false
    }
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String)
    {
        
        var mMaintopicsDetails = NSMutableArray()
        
        
        let searchedTopics = NSMutableArray()
        
        let classCheckingVariable = fullLessonPlanDetails.objectForKey("MainTopics")!.objectForKey("MainTopic")!
        
        if classCheckingVariable.isKindOfClass(NSMutableArray)
        {
            mMaintopicsDetails = classCheckingVariable as! NSMutableArray
        }
        else
        {
            mMaintopicsDetails.addObject(fullLessonPlanDetails.objectForKey("MainTopics")!.objectForKey("MainTopic")!)
            
        }
        
        
        for mainIndex in 0 ..< mMaintopicsDetails.count
        {
            let mainTopicDict = mMaintopicsDetails.objectAtIndex(mainIndex)
             if var topicName = mainTopicDict.objectForKey("Name")as? String
             {
                 topicName = topicName.lowercaseString
                
                if topicName.containsString(searchText.lowercaseString)
                {
                    searchedTopics.addObject(mainTopicDict)
                }
                else
                {
                   
                    var subTopicsArrray = NSMutableArray()
                   
                    if  let classCheckingVariable = mainTopicDict.objectForKey("SubTopics")?.objectForKey("SubTopic")
                    {
                        if classCheckingVariable.isKindOfClass(NSMutableArray)
                        {
                            subTopicsArrray = classCheckingVariable as! NSMutableArray
                        }
                        else
                        {
                            subTopicsArrray.addObject(mainTopicDict.objectForKey("SubTopics")!.objectForKey("SubTopic")!)
                            
                        }
                        
                        for subIndex in 0 ..< subTopicsArrray.count
                        {
                            let subTopicTopicDict = subTopicsArrray.objectAtIndex(subIndex)
                            if var subTopictopicName = subTopicTopicDict.objectForKey("Name")as? String
                            {
                                subTopictopicName = subTopictopicName.lowercaseString
                                
                                if subTopictopicName.containsString(searchText.lowercaseString)
                                {
                                    searchedTopics.addObject(mainTopicDict)
                                    
                                    break
                                }
                            }
                            
                        }
                    }
                }
            }
        }
        
        
        if MainTopicsView != nil
        {
            MainTopicsView.searchingTextWithSearchText(searchText.lowercaseString, withSearchedTopics: searchedTopics)
        }
    }
    
    
    

}