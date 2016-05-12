//
//  SSTeacherQuerySelectView.swift
//  LearniatTeacher
//
//  Created by Deepak MK on 12/04/16.
//  Copyright © 2016 Mindshift. All rights reserved.
//

import Foundation


@objc protocol SSTeacherQuerySelectViewDelegate
{
    
    
    optional func delegateQueriesSelectedForVolunteer(queryDetails:NSMutableArray)
    
    
    
}


class SSTeacherQuerySelectView: UIView,SSTeacherDataSourceDelegate
{
    var _delgate: AnyObject!
    
    
    var mTopImageView  = UIImageView()
    
    var currentYPosition: CGFloat = 10
    
    var mDoneButton        = UIButton()
    
    var mCancelButton        = UIButton()
    
    var mScrollView : UIScrollView!
    
    let studentsQueryArray = NSMutableArray()
    
    var totalUploadingCount = 0

    
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
        
        mDoneButton.frame = CGRectMake(self.frame.size.width - 130, 0, 120, mTopImageView.frame.size.height)
        mDoneButton.setTitle("Done", forState: .Normal)
        mTopImageView.addSubview(mDoneButton)
        mDoneButton.setTitleColor(standard_Button, forState: .Normal)
        mDoneButton.contentHorizontalAlignment = UIControlContentHorizontalAlignment.Right
        mDoneButton.addTarget(self, action: #selector(SSTeacherQuerySelectView.onDoneButton), forControlEvents: .TouchUpInside)
        
        mCancelButton.frame = CGRectMake(10, 0, 120, mTopImageView.frame.size.height)
        mCancelButton.setTitle("Cancel", forState: .Normal)
        mTopImageView.addSubview(mCancelButton)
        mCancelButton.setTitleColor(standard_Button, forState: .Normal)
        mCancelButton.contentHorizontalAlignment = UIControlContentHorizontalAlignment.Left
        mCancelButton.addTarget(self, action: #selector(SSTeacherQuerySelectView.oncancelButton), forControlEvents: .TouchUpInside)
        
        
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
    
    
    
    
    func addQueriesWithDetails(queryDetails:NSMutableArray)
    {
        currentYPosition  = 10
        
        for index in 0  ..< queryDetails.count 
        {
            let queryDict = queryDetails.objectAtIndex(index)
            
            let mQuerySubView = QuerySelectSubView(frame: CGRectMake(10 , currentYPosition, self.frame.size.width - 20 ,80))
            mScrollView.addSubview(mQuerySubView)
            mQuerySubView.setdelegate(self)
            
            mQuerySubView.frame = CGRectMake(10 , currentYPosition, self.frame.size.width - 20 ,mQuerySubView.setQueryWithDetails(queryDict))
            
            if let QueryId = queryDict.objectForKey("QueryId") as? String
            {
                mQuerySubView.tag = Int(QueryId)!
            }
            
            
            currentYPosition = currentYPosition + mQuerySubView.frame.size.height + 10
            
            
            
        }
        
         mScrollView.contentSize = CGSizeMake(0, currentYPosition)
        
        
    }
    
    func oncancelButton()
    {
        self.removeFromSuperview()
    }
    
    
    
    func onDoneButton()
    {
        
        studentsQueryArray.removeAllObjects()
        
        totalUploadingCount = 0
        
        
        let subViews = mScrollView.subviews.flatMap{ $0 as? QuerySelectSubView }
        
        for mQuerySubView in subViews
        {
            if mQuerySubView.isKindOfClass(QuerySelectSubView)
            {
                if mQuerySubView.getQueryState().checkMarkState == true
                {
                   
                    
                    if let QueryId = mQuerySubView.getQueryState().QueryDetails.objectForKey("QueryId") as? String
                    {
                        if mQuerySubView.getQueryState().AllowVolunteerState == true
                        {
                             SSTeacherDataSource.sharedDataSource.saveSelectedVolunteers(QueryId, withAllowVolunteerList: "1", WithDelegate: self)
                        }
                        else
                        {
                             SSTeacherDataSource.sharedDataSource.saveSelectedVolunteers(QueryId, withAllowVolunteerList: "0", WithDelegate: self)
                        }
                        
                        studentsQueryArray.addObject(mQuerySubView.getQueryState().QueryDetails)
                    }
                    
                    
                }
                
            }
        }
        
    }
    
    
    func didGetSaveSelectedQueryWithDetails(details: AnyObject)
    {
        
        totalUploadingCount = totalUploadingCount + 1
        
        
        if totalUploadingCount >= studentsQueryArray.count
        {
            if delegate().respondsToSelector(#selector(SSTeacherQuerySelectViewDelegate.delegateQueriesSelectedForVolunteer(_:)))
            {
                delegate().delegateQueriesSelectedForVolunteer!(studentsQueryArray)
                self.removeFromSuperview()
            }
        }
        
        
    }
    
    
    
}