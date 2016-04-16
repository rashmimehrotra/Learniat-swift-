//
//  SSTeacherLessonPlanView.swift
//  LearniatTeacher
//
//  Created by mindshift_Deepak on 16/04/16.
//  Copyright © 2016 Mindshift. All rights reserved.
//

import Foundation
class SSTeacherLessonPlanView: UIView,SSTeacherDataSourceDelegate
{
    
    let mSendButton = UIButton()
    
    let mCancelButton = UIButton()
    
    var sendButtonSpinner : UIActivityIndicatorView!
    
    let  mTopbarImageView = UIImageView()
    
    var _currentSessionDetails:AnyObject!
    
    var MainTopicsView : LessonPlanMainView!
    
    
    override init(frame: CGRect)
    {
        
        super.init(frame:frame)
        
        
        self.backgroundColor = whiteBackgroundColor
        
        
        
         mTopbarImageView.frame = CGRectMake(0, 0, self.frame.size.width, 70)
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
        mCancelButton.addTarget(self, action: "onCancelButton", forControlEvents: UIControlEvents.TouchUpInside)
        
        
        mSendButton.frame = CGRectMake(mTopbarImageView.frame.size.width - 100 , 0, 100 , mTopbarImageView.frame.size.height );
        mTopbarImageView.addSubview(mSendButton);
        mSendButton.setTitle("Send", forState:.Normal);
        mSendButton.setTitleColor(UIColor.whiteColor(), forState:.Normal);
        mSendButton.titleLabel?.font = UIFont(name: helveticaMedium, size: 20);
        mSendButton.enabled = false
        mSendButton.highlighted = false;
        mSendButton.contentHorizontalAlignment = UIControlContentHorizontalAlignment.Center
        mSendButton.addTarget(self, action: "onSendButton", forControlEvents: UIControlEvents.TouchUpInside)
        mSendButton.hidden = true
        
        sendButtonSpinner = UIActivityIndicatorView(activityIndicatorStyle:.WhiteLarge);
        sendButtonSpinner.frame = mSendButton.frame;
        mTopbarImageView.addSubview(sendButtonSpinner);
        sendButtonSpinner.hidden = false;
        sendButtonSpinner.startAnimating()
        
        
        MainTopicsView = LessonPlanMainView(frame: CGRectMake(0,mTopbarImageView.frame.size.height,self.frame.size.width,self.frame.size.height - mTopbarImageView.frame.size.height ))
        
        self.addSubview(MainTopicsView)
        
        
        
        
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
        self.removeFromSuperview()
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
        
        MainTopicsView.setCurrentSessionDetails(_currentSessionDetails, withFullLessonPlanDetails: details)
        
        
        
        
    }
    
    
    // MARK: - datasource delegate functions
    
    

}