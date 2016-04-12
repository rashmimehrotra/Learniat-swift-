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



class SSTeacherQueryView: UIView, SSTeacherDataSourceDelegate,QuerySubviewDelegate
{
    var _delgate: AnyObject!
    
    var mTopImageView  = UIImageView()
    
    var currentYPosition: CGFloat = 10
    
    var mSocialRankingButton        = UIButton()
    
    var mQueryCountLabel            = UILabel()
    
    var mScrollView : UIScrollView!
    
    override init(frame: CGRect)
    {
        
        super.init(frame:frame)
        
        
       
        
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
        
        if mScrollView == nil
        {
            mScrollView = UIScrollView()
            mScrollView.frame = CGRectMake(0, 50, self.frame.size.width, self.frame.size.height - 50 )
            self.addSubview(mScrollView)
            mScrollView.backgroundColor = whiteBackgroundColor
            
            
            mTopImageView.frame = CGRectMake(0, 0, self.frame.size.width, 50)
            self.addSubview(mTopImageView)
            mTopImageView.backgroundColor = UIColor.whiteColor()
            
            mSocialRankingButton.frame = CGRectMake(self.frame.size.width - 130, 0, 120, mTopImageView.frame.size.height)
            mSocialRankingButton.setTitle("Social ranking", forState: .Normal)
            mTopImageView.addSubview(mSocialRankingButton)
            mSocialRankingButton.setTitleColor(standard_Button, forState: .Normal)
            mSocialRankingButton.contentHorizontalAlignment = UIControlContentHorizontalAlignment.Right
            
            mQueryCountLabel.frame = CGRectMake(10, 0, 120, mTopImageView.frame.size.height)
            self.addSubview(mQueryCountLabel)
            
            
            
        }
        
        SSTeacherDataSource.sharedDataSource.getQueryWithQueryId(QueryId, WithDelegate: self)
    }
    
    
    func didGetQueryWithDetails(details: AnyObject)
    {
        
        
        
        if let queryDetails = details.objectForKey("Query") 
        {
            
            
            if delegate().respondsToSelector(Selector("delegateQueryDownloadedWithDetails:"))
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
                mQuerySubView.frame = CGRectMake(mQuerySubView.frame.origin.x ,currentYPosition,mQuerySubView.frame.size.width,mQuerySubView.frame.size.height)
                
                currentYPosition = currentYPosition + mQuerySubView.frame.size.height + 10
                queryCount = queryCount + 1
            }
        }
        
        mQueryCountLabel.text = "\(queryCount) Query"
        
        if queryCount > 0
        {
            mSocialRankingButton.setTitleColor(standard_Button, forState: .Normal)
            mSocialRankingButton.enabled = true
        }
        else
        {
            mSocialRankingButton.setTitleColor(UIColor.lightGrayColor(), forState: .Normal)
            mSocialRankingButton.enabled = false
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
                
                if delegate().respondsToSelector(Selector("delegateDismissButtonPressedWithDetails:"))
                {
                    delegate().delegateQueryDeletedWithDetails!(queryDetails)
                }
                
            }
        }
       
        refreshScrollView()
        
        
    }
    
    
    
}