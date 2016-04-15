//
//  SSTeacherVolunteerView.swift
//  LearniatTeacher
//
//  Created by Deepak MK on 12/04/16.
//  Copyright © 2016 Mindshift. All rights reserved.
//

import Foundation


@objc protocol SSTeacherVolunteerViewDelegate
{
    
    
    optional func delegateVolunteerSessionEnded()
    
    
}


class SSTeacherVolunteerView: UIView,SSTeacherDataSourceDelegate,UIAlertViewDelegate
{
    var _delgate: AnyObject!
    
    
    var mTopImageView  = UIImageView()
    
    var currentYPosition: CGFloat = 10
    
    var mDoneButton        = UIButton()
    
    var mCancelButton        = UIButton()
    
    var mQueryCountLabel            = UILabel()
    
    var mScrollView : UIScrollView!
    
    let studentsQueryArray = NSMutableArray()
    
    var totalUploadingCount = 0
    
    
    override init(frame: CGRect)
    {
        
        super.init(frame:frame)
        
        
        
        self.backgroundColor = whiteBackgroundColor
        
        
        mTopImageView.frame = CGRectMake(0, 0, self.frame.size.width, 50)
        self.addSubview(mTopImageView)
        mTopImageView.backgroundColor = UIColor.whiteColor()
        mTopImageView.userInteractionEnabled = true
        
        mDoneButton.frame = CGRectMake(self.frame.size.width - 130, 0, 120, mTopImageView.frame.size.height)
        mDoneButton.setTitle("Done", forState: .Normal)
        mTopImageView.addSubview(mDoneButton)
        mDoneButton.setTitleColor(standard_Button, forState: .Normal)
        mDoneButton.contentHorizontalAlignment = UIControlContentHorizontalAlignment.Right
        mDoneButton.addTarget(self, action: "onDoneButton", forControlEvents: .TouchUpInside)
        
        mQueryCountLabel.frame = CGRectMake(10, 0, 120, mTopImageView.frame.size.height)
        self.addSubview(mQueryCountLabel)
        
        
        
        
        
        let mQuerySubView = VolunteerTopView(frame: CGRectMake(10 , mTopImageView.frame.size.height + mTopImageView.frame.origin.y + 10, self.frame.size.width - 20 ,20))
        self.addSubview(mQuerySubView)
        
        
        mScrollView = UIScrollView()
        mScrollView.frame = CGRectMake(0, mQuerySubView.frame.size.height + mQuerySubView.frame.origin.y, self.frame.size.width, self.frame.size.height - (mQuerySubView.frame.size.height + mQuerySubView.frame.origin.y) )
        self.addSubview(mScrollView)
        

        
        
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
        
        for var index = 0 ; index < queryDetails.count ; index++
        {
            let queryDict = queryDetails.objectAtIndex(index)
            
            let mQuerySubView = QueryVolunteerSubView(frame: CGRectMake(10 , currentYPosition, self.frame.size.width - 20 ,80))
            mScrollView.addSubview(mQuerySubView)
            mQuerySubView.setdelegate(self)
            
            mQuerySubView.setQueryWithDetails(queryDict)
            
            
            if let queryText = queryDict.objectForKey("QueryText") as? String
            {
                
               mQuerySubView.mQueryLabel.text = "\(index + 1).\(queryText)"
            }
            
            
            if let QueryId = queryDict.objectForKey("QueryId") as? String
            {
                mQuerySubView.tag = Int(QueryId)!
            }
            
            
            currentYPosition = currentYPosition + mQuerySubView.frame.size.height + 10
            
            
            
        }
        
        mScrollView.contentSize = CGSizeMake(0, currentYPosition)
        
          mQueryCountLabel.text = "\(queryDetails.count) Query"
        
        
    }
    
    func oncancelButton()
    {
        self.removeFromSuperview()
    }
    
    
    
    func onDoneButton()
    {
       
        
        let alertView = UIAlertView( title: "End volunteering", message: "do you really want to end Social ranking?", delegate: self, cancelButtonTitle: "Cancel", otherButtonTitles: "End")
        alertView.show()
        
        
    }
    
    
    
    func endVolunteeringSession()
    {
        
        let mQueryIdList = NSMutableArray()
        
        let meTooCountList  = NSMutableArray()
        
        let subViews = mScrollView.subviews.flatMap{ $0 as? QueryVolunteerSubView }
        
        for mQuerySubView in subViews
        {
            if mQuerySubView.isKindOfClass(QueryVolunteerSubView)
            {
                if let QueryId = mQuerySubView.currentQueryDetails.objectForKey("QueryId") as? String
                {
                   mQueryIdList.addObject(QueryId)
                }
                
                meTooCountList.addObject(mQuerySubView.mMetooLabel.text!)
                
            }
        }
        
        
        
        let queryIdString = mQueryIdList.componentsJoinedByString(";;;")
        let meTooCountString = meTooCountList.componentsJoinedByString(";;;")
        
        SSTeacherDataSource.sharedDataSource.EndVolunteeringSessionwithQueryId(queryIdString, withMeTooList: meTooCountString, WithDelegate: self)
        
        
        
        
        
    }
    
    func didGetVolunteeringEndedWithDetails(details: AnyObject)
    {
       
        SSTeacherMessageHandler.sharedMessageHandler.sendEndVolunteeringMessagetoStudent(SSTeacherDataSource.sharedDataSource.currentLiveSessionId)
        
        if delegate().respondsToSelector(Selector("delegateVolunteerSessionEnded"))
        {
            
            
            delegate().delegateVolunteerSessionEnded!()
            self.removeFromSuperview()
        }

        
    }
    
    
    func alertView(alertView: UIAlertView, clickedButtonAtIndex buttonIndex: Int) {
        
        if buttonIndex == 1
        {
            endVolunteeringSession()
        }
        else
        {
            alertView.dismissWithClickedButtonIndex(buttonIndex, animated: true)
        }
    }
    
    
    
}