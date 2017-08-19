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
    
    
    @objc optional func delegateQueryDownloadedWithDetails(_ queryDetails:AnyObject)
    
    
    @objc optional func delegateQueryDeletedWithDetails(_ queryDetails:AnyObject)
    
    
}



class SSTeacherQueryView: UIView, SSTeacherDataSourceDelegate,QuerySubviewDelegate,SSTeacherQuerySelectViewDelegate,SSTeacherVolunteerViewDelegate,UIPopoverControllerDelegate,RatingsPopOverViewControllerDelegate
{
    var _delgate: AnyObject!
    
    var mTopImageView  = UIImageView()
    
    var currentYPosition: CGFloat = 10
    
    var mSocialRankingButton        = UIButton()
    
    var mQueryCountLabel            = UILabel()
    
    var mScrollView : UIScrollView!
    
    var noSubmissionLabel = UILabel()
    
    var  queryVolunteerView :SSTeacherVolunteerView!
    
    // By Ujjval
    // ==========================================
    
    var mShadowView  = UIView()
    
    // ==========================================
    
    override init(frame: CGRect)
    {
        
        super.init(frame:frame)
        
        mScrollView = UIScrollView()
        mScrollView.frame = CGRect(x: 0, y: 50, width: self.frame.size.width, height: self.frame.size.height - 50 )
        self.addSubview(mScrollView)
        mScrollView.backgroundColor = whiteBackgroundColor
        
        
        mTopImageView.frame = CGRect(x: 0, y: 0, width: self.frame.size.width, height: 50)
        self.addSubview(mTopImageView)
        mTopImageView.backgroundColor = UIColor.white
        mTopImageView.isUserInteractionEnabled = true
        
        
        mSocialRankingButton.frame = CGRect(x: self.frame.size.width - 130, y: 0, width: 120, height: mTopImageView.frame.size.height)
        mSocialRankingButton.setTitle("Social ranking", for: UIControlState())
        mTopImageView.addSubview(mSocialRankingButton)
        mSocialRankingButton.setTitleColor(standard_Button, for: UIControlState())
        mSocialRankingButton.contentHorizontalAlignment = UIControlContentHorizontalAlignment.right
        mSocialRankingButton.addTarget(self, action: #selector(SSTeacherQueryView.onSocialRankingButton), for: .touchUpInside)
        mQueryCountLabel.frame = CGRect(x: 10, y: 0, width: 120, height: mTopImageView.frame.size.height)
        self.addSubview(mQueryCountLabel)
        
        noSubmissionLabel.frame = CGRect(x: 0, y: (self.frame.size.height - 300)/2, width: self.frame.size.width, height: 300)
        self.addSubview(noSubmissionLabel)
        noSubmissionLabel.text = "There are no student queries pending"
        noSubmissionLabel.textColor = blackTextColor
        noSubmissionLabel.isHidden = false
        noSubmissionLabel.textAlignment = .center
        noSubmissionLabel.font =  UIFont(name: helveticaMedium, size: 35);

       
        // By Ujjval
        // ==========================================
        
        mShadowView.frame = CGRect(x: 0, y: 0, width: self.frame.size.width, height: self.frame.size.height)
        mShadowView.backgroundColor = UIColor.black
        mShadowView.alpha = 0.35
        self.addSubview(mShadowView)
        mShadowView.isHidden = true
        
        // ==========================================
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func setdelegate(_ delegate:AnyObject)
    {
        _delgate = delegate;
    }
    
    func   delegate()->AnyObject
    {
        return _delgate;
    }
    
    func queryWithDrawnWithQueryId(_ queryId:String)
    {
        if let studentqueryView  = mScrollView.viewWithTag(Int(queryId)!) as? QuerySubview
        {
            studentqueryView.removeFromSuperview()
        }
        refreshScrollView()
    }
    
    func addQueryWithDetails(_ QueryId:String)
    {
        
        SSTeacherDataSource.sharedDataSource.getQueryWithQueryId(QueryId, WithDelegate: self)
    }
    
    
    func didGetQueryWithDetails(_ details: AnyObject)
    {
        
        
        
        if let queryDetails = details.object(forKey: "Query") 
        {
            
            
            if delegate().responds(to: #selector(SSTeacherQueryViewDelegate.delegateQueryDownloadedWithDetails(_:)))
            {
                delegate().delegateQueryDownloadedWithDetails!(queryDetails as AnyObject)
            }
            
            let mQuerySubView = QuerySubview(frame: CGRect(x: 10 , y: currentYPosition, width: self.frame.size.width - 20 ,height: 80))
            mScrollView.addSubview(mQuerySubView)
            mQuerySubView.setdelegate(self)
            
            mQuerySubView.frame = CGRect(x: 10 , y: currentYPosition, width: self.frame.size.width - 20 ,height: mQuerySubView.setQueryWithDetails(queryDetails as AnyObject))
            
            if let QueryId = (queryDetails as AnyObject).object(forKey: "QueryId") as? String
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
            if mQuerySubView.isKind(of: QuerySubview.self)
            {
                UIView.animate(withDuration: 0.2, animations:
                    {
                        mQuerySubView.frame = CGRect(x: mQuerySubView.frame.origin.x ,y: self.currentYPosition,width: mQuerySubView.frame.size.width,height: mQuerySubView.frame.size.height)
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
            mSocialRankingButton.setTitleColor(standard_Button, for: UIControlState())
            mSocialRankingButton.isEnabled = true
            noSubmissionLabel.isHidden = true
        }
        else
        {
            mSocialRankingButton.setTitleColor(UIColor.lightGray, for: UIControlState())
            mSocialRankingButton.isEnabled = false
            noSubmissionLabel.isHidden = false
        }
        
        mScrollView.contentSize = CGSize(width: 0, height: currentYPosition)
        
    }
    
    
    func delegateTextReplyButtonPressedWithDetails(_ queryDetails: AnyObject, withButton textButton: UIButton) {
        
        
        
         
        let _ratingsPopoverController = RatingsPopOverViewController()
        if let QueryId = queryDetails.object(forKey: "QueryId") as? String
        {
             _ratingsPopoverController.addTextViewWithDoneButton(withQueryId: QueryId)
        }
       
        let navController = UINavigationController(rootViewController: _ratingsPopoverController)
        
        _ratingsPopoverController.setDelegate(self)
        
        let PopoverControllerRatings = UIPopoverController(contentViewController: navController)
        
        // By Ujjval
        // ==========================================
        
//        PopoverControllerRatings.contentSize = CGSize(width: 300,height: 100);
        PopoverControllerRatings.contentSize = CGSize(width: 300,height: 160);
        mShadowView.isHidden = false
        
        // ==========================================
        
        PopoverControllerRatings.delegate = self;
        navController.isNavigationBarHidden = true;
        _ratingsPopoverController.setPopOver(PopoverControllerRatings)
        
        let buttonPosition :CGPoint = textButton.convert(CGPoint.zero, to: self)
        
        PopoverControllerRatings.present(from: CGRect(x: buttonPosition.x + (textButton.frame.size.width / 2) ,y: buttonPosition.y + textButton.frame.size.height  , width: 1, height: 1), in: self, permittedArrowDirections: .up, animated: true)
        
        
    }
    
    
    // By Ujjval
    // ==========================================
    
    func dismissPopoverForQuery() {
        mShadowView.isHidden = true
    }
    
    
    func popoverControllerShouldDismissPopover(_ popoverController: UIPopoverController) -> Bool {
        dismissPopoverForQuery()
        return true
    }
    
    // ==========================================
    
    
    func delegateDismissButtonPressedWithDetails(_ queryDetails: AnyObject) {
        
        
        if let QueryId = queryDetails.object(forKey: "QueryId") as? String
        {
            if let studentqueryView  = mScrollView.viewWithTag(Int(QueryId)!) as? QuerySubview
            {
                
                
                
               studentqueryView.removeFromSuperview()
                
                if delegate().responds(to: #selector(SSTeacherQueryViewDelegate.delegateQueryDeletedWithDetails(_:)))
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
            if mQuerySubView.isKind(of: QuerySubview.self)
            {
              studentsQueryArray.add(mQuerySubView.currentQueryDetails)
            }
        }
        
        if studentsQueryArray.count > 0
        {
            let querySelectView = SSTeacherQuerySelectView(frame: CGRect(x: 0 , y: 0 , width: self.frame.size.width, height: self.frame.size.height))
            self.addSubview(querySelectView)
            querySelectView.setdelegate(self)
            querySelectView.addQueriesWithDetails(studentsQueryArray)
        }
       
    }
    
    
    func delegateQueriesSelectedForVolunteer(_ queryDetails: NSMutableArray)
    {
        SSTeacherMessageHandler.sharedMessageHandler.sendVolunteerVoteStartedMessgeToStudents(SSTeacherDataSource.sharedDataSource.currentLiveSessionId)
        
         queryVolunteerView = SSTeacherVolunteerView(frame: CGRect(x: 0 , y: 0 , width: self.frame.size.width, height: self.frame.size.height))
        self.addSubview(queryVolunteerView)
        queryVolunteerView.setdelegate(self)
        queryVolunteerView.addQueriesWithDetails(queryDetails)
        
    }
    
    
    func delegateVolunteerSessionEndedWithRemainingqueries(_ queryIdArray: NSMutableArray) {
        
        
        let subViews = mScrollView.subviews.flatMap{ $0 as? QuerySubview }
        for studentqueryView in subViews
        {
            if studentqueryView.isKind(of: QuerySubview.self)
            {
                if queryIdArray.contains("\(studentqueryView.tag)")
                {
                    
                }
                else
                {
                    if delegate().responds(to: #selector(SSTeacherQueryViewDelegate.delegateQueryDeletedWithDetails(_:)))
                    {
                        delegate().delegateQueryDeletedWithDetails!(studentqueryView.currentQueryDetails)
                        studentqueryView.removeFromSuperview()
                    }
                }
                
                
                
            }
        }
        
        refreshScrollView()
    }
    
    
    // MARK: - Query Volunteer  functions
    
    func studentRaisedMeeToWithDetial(_ details:AnyObject)
    {
        if queryVolunteerView != nil
        {
            queryVolunteerView.metooRaisedWithDetails(details)
        }
       
    }
    
    func studentVolunteerRaisedWithDetails(_ details:AnyObject)
    {
        if queryVolunteerView != nil
        {
            queryVolunteerView.volunteerRaiserWithDetails(details)
        }
        
    }
    
    
    func studentNewVoteRaised(_ studentId:String, withVote vote:String, withTotalStudents totalStudents:Int)
    {
        if queryVolunteerView != nil
        {
            queryVolunteerView.didGetNewVoteFromStudent(studentId, withNewVote: vote, withTotalStudents: totalStudents)
        }
    }
    
    
    func studentUnderstoodQueryWithId(_ queryId:String, withStudentId StudentId:String)
    {
        if queryVolunteerView != nil
        {
            queryVolunteerView.queryUnderstoodMessageFromStudentWithQueryId(queryId,withStudentId: StudentId)
        }
    }
    
    // MARK: - Query Volunteer  functions
    
    func delegatePopoverDoneButtonPressed(withText text: String!, withQueryID queryId: String!)
    {
        if let studentqueryView  = mScrollView.viewWithTag(Int(queryId)!) as? QuerySubview
        {
            studentqueryView.textReplySentWithText(text)
        }
    }
    
}
