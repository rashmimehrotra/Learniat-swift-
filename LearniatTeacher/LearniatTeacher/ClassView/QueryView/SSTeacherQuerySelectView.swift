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
    
    
    @objc optional func delegateQueriesSelectedForVolunteer(_ queryDetails:NSMutableArray)
    
    
    
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
        mScrollView.frame = CGRect(x: 0, y: 50, width: self.frame.size.width, height: self.frame.size.height - 50 )
        self.addSubview(mScrollView)
        mScrollView.backgroundColor = whiteBackgroundColor
        
        
        mTopImageView.frame = CGRect(x: 0, y: 0, width: self.frame.size.width, height: 50)
        self.addSubview(mTopImageView)
        mTopImageView.backgroundColor = UIColor.white
        mTopImageView.isUserInteractionEnabled = true
        
        mDoneButton.frame = CGRect(x: self.frame.size.width - 130, y: 0, width: 120, height: mTopImageView.frame.size.height)
        mDoneButton.setTitle("Done", for: UIControlState())
        mTopImageView.addSubview(mDoneButton)
        mDoneButton.setTitleColor(standard_Button, for: UIControlState())
        mDoneButton.contentHorizontalAlignment = UIControlContentHorizontalAlignment.right
        mDoneButton.addTarget(self, action: #selector(SSTeacherQuerySelectView.onDoneButton), for: .touchUpInside)
        
        mCancelButton.frame = CGRect(x: 10, y: 0, width: 120, height: mTopImageView.frame.size.height)
        mCancelButton.setTitle("Cancel", for: UIControlState())
        mTopImageView.addSubview(mCancelButton)
        mCancelButton.setTitleColor(standard_Button, for: UIControlState())
        mCancelButton.contentHorizontalAlignment = UIControlContentHorizontalAlignment.left
        mCancelButton.addTarget(self, action: #selector(SSTeacherQuerySelectView.oncancelButton), for: .touchUpInside)
        
        
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
    
    
    
    
    func addQueriesWithDetails(_ queryDetails:NSMutableArray)
    {
        currentYPosition  = 10
        
        for index in 0  ..< queryDetails.count 
        {
            let queryDict = queryDetails.object(at: index)
            
            let mQuerySubView = QuerySelectSubView(frame: CGRect(x: 10 , y: currentYPosition, width: self.frame.size.width - 20 ,height: 80))
            mScrollView.addSubview(mQuerySubView)
            mQuerySubView.setdelegate(self)
            
            mQuerySubView.frame = CGRect(x: 10 , y: currentYPosition, width: self.frame.size.width - 20 ,height: mQuerySubView.setQueryWithDetails(queryDict as AnyObject))
            
            if let QueryId = (queryDict as AnyObject).object(forKey: "QueryId") as? String
            {
                mQuerySubView.tag = Int(QueryId)!
            }
            
            
            currentYPosition = currentYPosition + mQuerySubView.frame.size.height + 10
            
            
            
        }
        
         mScrollView.contentSize = CGSize(width: 0, height: currentYPosition)
        
        
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
            if mQuerySubView.isKind(of: QuerySelectSubView.self)
            {
                if mQuerySubView.getQueryState().checkMarkState == true
                {
                   
                    
                    if let QueryId = mQuerySubView.getQueryState().QueryDetails.object(forKey: "QueryId") as? String
                    {
                        if mQuerySubView.getQueryState().AllowVolunteerState == true
                        {
                             SSTeacherDataSource.sharedDataSource.saveSelectedVolunteers(QueryId, withAllowVolunteerList: "1", WithDelegate: self)
                        }
                        else
                        {
                             SSTeacherDataSource.sharedDataSource.saveSelectedVolunteers(QueryId, withAllowVolunteerList: "0", WithDelegate: self)
                        }
                        
                        studentsQueryArray.add(mQuerySubView.getQueryState().QueryDetails)
                    }
                    
                    
                }
                
            }
        }
        
    }
    
    
    func didGetSaveSelectedQueryWithDetails(_ details: AnyObject)
    {
        
        totalUploadingCount = totalUploadingCount + 1
        
        
        if totalUploadingCount >= studentsQueryArray.count
        {
            if delegate().responds(to: #selector(SSTeacherQuerySelectViewDelegate.delegateQueriesSelectedForVolunteer(_:)))
            {
                delegate().delegateQueriesSelectedForVolunteer!(studentsQueryArray)
                self.removeFromSuperview()
            }
        }
        
        
    }
    
    
    
}
