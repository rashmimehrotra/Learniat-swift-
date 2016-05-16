//
//  SSTeacherQueryView.swift
//  LearniatTeacher
//
//  Created by Deepak MK on 02/04/16.
//  Copyright © 2016 Mindshift. All rights reserved.
//

import Foundation


@objc protocol SSTeacherQueryViewDelegate
{
    
    
    optional func delegateQueryDownloadedWithDetails(queryDetails:AnyObject)
    
    
    optional func delegateQueryDeletedWithDetails(queryDetails:AnyObject)
    
    
}



class SSTeacherQueryView: UIView, SSTeacherDataSourceDelegate,QuerySubviewDelegate,SSTeacherQuerySelectViewDelegate,SSTeacherVolunteerViewDelegate
{
    var _delgate: AnyObject!
    
    var mTopImageView  = UIImageView()
    
    var currentYPosition: CGFloat = 10
    
    var mSocialRankingButton        = UIButton()
    
    var mQueryCountLabel            = UILabel()
    
    var mScrollView : UIScrollView!
    
    var noSubmissionLabel = UILabel()
    
    var  queryVolunteerView :SSTeacherVolunteerView!
    
    override init(frame: CGRect)
    {
        
        super.init(frame:frame)
        
        mScrollView = UIScrollView()
        mScrollView.frame = CGRectMake(0, 50, self.frame.size.width, self.frame.size.height - 50 )
        self.addSubview(mScrollView)
        mScrollView.backgroundColor = whiteBackgroundColor
        
        
        mTopImageView.frame = CGRectMake(0, 0, self.frame.size.width, 50)
        self.addSubview(mTopImageView)
        mTopImageView.backgroundColor = UIColor.whiteColor()
        mTopImageView.userInteractionEnabled = true
        
        
        mSocialRankingButton.frame = CGRectMake(self.frame.size.width - 130, 0, 120, mTopImageView.frame.size.height)
        mSocialRankingButton.setTitle("Social ranking", forState: .Normal)
        mTopImageView.addSubview(mSocialRankingButton)
        mSocialRankingButton.setTitleColor(standard_Button, forState: .Normal)
        mSocialRankingButton.contentHorizontalAlignment = UIControlContentHorizontalAlignment.Right
        mSocialRankingButton.addTarget(self, action: #selector(SSTeacherQueryView.onSocialRankingButton), forControlEvents: .TouchUpInside)
        mQueryCountLabel.frame = CGRectMake(10, 0, 120, mTopImageView.frame.size.height)
        self.addSubview(mQueryCountLabel)
        
        noSubmissionLabel.frame = CGRectMake(0, (self.frame.size.height - 300)/2, self.frame.size.width, 300)
        self.addSubview(noSubmissionLabel)
        noSubmissionLabel.text = "There are no student queries pending"
        noSubmissionLabel.textColor = blackTextColor
        noSubmissionLabel.hidden = false
        noSubmissionLabel.textAlignment = .Center
        noSubmissionLabel.font =  UIFont(name: helveticaMedium, size: 35);

       
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func setdelegate(delegate:AnyObject)
    {
        _delgate = delegate;
    }
    
    func   delegate()->AnyObject
    {
        return _delgate;
    }
    
    
    func addQueryWithDetails(QueryId:String)
    {
        
        SSTeacherDataSource.sharedDataSource.getQueryWithQueryId(QueryId, WithDelegate: self)
    }
    
    
    func didGetQueryWithDetails(details: AnyObject)
    {
        
        
        
        if let queryDetails = details.objectForKey("Query") 
        {
            
            
            if delegate().respondsToSelector(#selector(SSTeacherQueryViewDelegate.delegateQueryDownloadedWithDetails(_:)))
            {
                delegate().delegateQueryDownloadedWithDetails!(queryDetails)
            }
            
            let mQuerySubView = QuerySubview(frame: CGRectMake(10 , currentYPosition, self.frame.size.width - 20 ,80))
            mScrollView.addSubview(mQuerySubView)
            mQuerySubView.setdelegate(self)
            
            mQuerySubView.frame = CGRectMake(10 , currentYPosition, self.frame.size.width - 20 ,mQuerySubView.setQueryWithDetails(queryDetails))
            
            if let QueryId = queryDetails.objectForKey("QueryId") as? String
            {
                mQuerySubView.tag = Int(QueryId)!
            }
            
            
            currentYPosition = currentYPosition + mQuerySubView.frame.size.height + 10
            
            
            refreshScrollView()
        }
        
        
        
    }
    
    func refreshScrollView()
    {
        
        
        currentYPosition = 10
        var queryCount = 0
        let subViews = mScrollView.subviews
        for mQuerySubView in subViews
        {
            if mQuerySubView.isKindOfClass(QuerySubview)
            {
                UIView.animateWithDuration(0.2, animations:
                    {
                        mQuerySubView.frame = CGRectMake(mQuerySubView.frame.origin.x ,self.currentYPosition,mQuerySubView.frame.size.width,mQuerySubView.frame.size.height)
                })
                
               
                
                currentYPosition = currentYPosition + mQuerySubView.frame.size.height + 10
                queryCount = queryCount + 1
            }
        }
        
        if queryCount > 1
        {
            mQueryCountLabel.text = "\(queryCount) Queries"
        }
        
        else
        {
            mQueryCountLabel.text = "\(queryCount) Query"
        }
        
        
        if queryCount > 0
        {
            mSocialRankingButton.setTitleColor(standard_Button, forState: .Normal)
            mSocialRankingButton.enabled = true
            noSubmissionLabel.hidden = true
        }
        else
        {
            mSocialRankingButton.setTitleColor(UIColor.lightGrayColor(), forState: .Normal)
            mSocialRankingButton.enabled = false
            noSubmissionLabel.hidden = false
        }
        
        mScrollView.contentSize = CGSizeMake(0, currentYPosition)
        
    }
    
    
    func delegateTextReplyButtonPressedWithDetails(queryDetails: AnyObject) {
        
    }
    
    
    func delegateDismissButtonPressedWithDetails(queryDetails: AnyObject) {
        
        
        if let QueryId = queryDetails.objectForKey("QueryId") as? String
        {
            if let studentqueryView  = mScrollView.viewWithTag(Int(QueryId)!) as? QuerySubview
            {
                
                
                
               studentqueryView.removeFromSuperview()
                
                if delegate().respondsToSelector(#selector(SSTeacherQueryViewDelegate.delegateQueryDeletedWithDetails(_:)))
                {
                    delegate().delegateQueryDeletedWithDetails!(queryDetails)
                }
                
            }
        }
       
        refreshScrollView()
    }
    
    
    func onSocialRankingButton()
    {
       
        let studentsQueryArray = NSMutableArray()
        let subViews = mScrollView.subviews.flatMap{ $0 as? QuerySubview }
        
        for mQuerySubView in subViews
        {
            if mQuerySubView.isKindOfClass(QuerySubview)
            {
              studentsQueryArray.addObject(mQuerySubView.currentQueryDetails)
            }
        }
        
        if studentsQueryArray.count > 0
        {
            let querySelectView = SSTeacherQuerySelectView(frame: CGRectMake(0 , 0 , self.frame.size.width, self.frame.size.height))
            self.addSubview(querySelectView)
            querySelectView.setdelegate(self)
            querySelectView.addQueriesWithDetails(studentsQueryArray)
        }
       
    }
    
    
    func delegateQueriesSelectedForVolunteer(queryDetails: NSMutableArray)
    {
        SSTeacherMessageHandler.sharedMessageHandler.sendVolunteerVoteStartedMessgeToStudents(SSTeacherDataSource.sharedDataSource.currentLiveSessionId)
        
         queryVolunteerView = SSTeacherVolunteerView(frame: CGRectMake(0 , 0 , self.frame.size.width, self.frame.size.height))
        self.addSubview(queryVolunteerView)
        queryVolunteerView.setdelegate(self)
        queryVolunteerView.addQueriesWithDetails(queryDetails)
        
    }
    
    
    func delegateVolunteerSessionEnded()
    {
        
        let subViews = mScrollView.subviews.flatMap{ $0 as? QuerySubview }
        for studentqueryView in subViews
        {
            if studentqueryView.isKindOfClass(QuerySubview)
            {
                if delegate().respondsToSelector(#selector(SSTeacherQueryViewDelegate.delegateQueryDeletedWithDetails(_:)))
                {
                    delegate().delegateQueryDeletedWithDetails!(studentqueryView.currentQueryDetails)
                     studentqueryView.removeFromSuperview()
                }
                
            }
        }
        
        refreshScrollView()
    }
    
    
    // MARK: - Query Volunteer  functions
    
    func studentRaisedMeeToWithDetial(details:AnyObject)
    {
        if queryVolunteerView != nil
        {
            queryVolunteerView.metooRaisedWithDetails(details)
        }
       
    }
    
    func studentVolunteerRaisedWithDetails(details:AnyObject)
    {
        if queryVolunteerView != nil
        {
            queryVolunteerView.volunteerRaiserWithDetails(details)
        }
        
    }
    
    
    func studentNewVoteRaised(studentId:String, withVote vote:String, withTotalStudents totalStudents:Int)
    {
        if queryVolunteerView != nil
        {
            queryVolunteerView.didGetNewVoteFromStudent(studentId, withNewVote: vote, withTotalStudents: totalStudents)
        }
    }
    
    
    func studentUnderstoodQueryWithId(queryId:String, withStudentId StudentId:String)
    {
        if queryVolunteerView != nil
        {
            queryVolunteerView.queryUnderstoodMessageFromStudentWithQueryId(queryId,withStudentId: StudentId)
        }
    }
    
}