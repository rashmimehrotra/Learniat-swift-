//
//  StudentsQueryView.swift
//  LearniatStudent
//
//  Created by Deepak MK on 10/05/16.
//  Copyright © 2016 Mindshift. All rights reserved.
//

import Foundation
class StudentsQueryView: UIView,CustomTextViewDelegate,SSStudentDataSourceDelegate,QuerySubviewDelegate
{
    var mTopbarImageView = UIImageView()
    var mSendButton = UIButton()
    var mQueryTextView : CustomTextView!
    var mQueryScrollView    = UIScrollView()
    var currentYPosition: CGFloat = 5
    var currentQueryId      = ""
    var mQRVScrollView      = UIScrollView()
    
    override init(frame: CGRect)
    {
        super.init(frame: frame)
        
        
        self.backgroundColor = whiteBackgroundColor
        
        
        mTopbarImageView = UIImageView(frame: CGRectMake(0, 0, self.frame.size.width, 40))
        mTopbarImageView.backgroundColor = UIColor.whiteColor()
        self.addSubview(mTopbarImageView)
        mTopbarImageView.userInteractionEnabled = true
        mTopbarImageView.userInteractionEnabled = true
        
        
        mSendButton.frame = CGRectMake(mTopbarImageView.frame.size.width - 210, 0,200,mTopbarImageView.frame.size.height )
        mTopbarImageView.addSubview(mSendButton)
        mSendButton.addTarget(self, action: #selector(StudentsQueryView.onSendButton), forControlEvents: UIControlEvents.TouchUpInside)
        mSendButton.setTitle("Send", forState: .Normal)
        mSendButton.contentHorizontalAlignment = UIControlContentHorizontalAlignment.Right
        mSendButton.titleLabel?.font = UIFont (name: helveticaMedium, size: 20)
        mSendButton.setTitleColor(UIColor.lightGrayColor(), forState: .Normal)
        mSendButton.enabled = false
        
        
        mQueryTextView = CustomTextView(frame:CGRectMake(10, mTopbarImageView.frame.size.height + 10 ,self.frame.size.width - 20 ,100))
        self.addSubview(mQueryTextView)
        mQueryTextView.setdelegate(self)
        mQueryTextView.setPlaceHolder("Write your query", withStartSting: "Query")
        
        
        mQueryScrollView.frame = CGRectMake(0, mQueryTextView.frame.size.height + mQueryTextView.frame.origin.y + 10, self.frame.size.width, self.frame.size.height - (mQueryTextView.frame.size.height + mQueryTextView.frame.origin.y + 10))
        mQueryScrollView.backgroundColor = UIColor.clearColor()
        self.addSubview(mQueryScrollView)
        
        
        self.mQueryTextView.hidden = true
        self.mQueryScrollView.frame = CGRectMake(0, (self.mTopbarImageView.frame.size.height + self.mTopbarImageView.frame.origin.y), self.frame.size.width, self.frame.size.height - (self.mTopbarImageView.frame.size.height + self.mTopbarImageView.frame.origin.y))
        
        
        mQRVScrollView.frame = CGRectMake(0, 0 , self.frame.size.width, self.frame.size.height)
        self.addSubview(mQRVScrollView)
        mQRVScrollView.backgroundColor = whiteBackgroundColor
        mQRVScrollView.hidden = true
        
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func delegateTextViewTextChanged(chnagedText: String) {
       
        if chnagedText != ""
        {
            mSendButton.enabled = true
            mSendButton.setTitleColor(standard_Button, forState: .Normal)
        }
        else
        {
            mSendButton.setTitleColor(UIColor.lightGrayColor(), forState: .Normal)
            mSendButton.enabled = false
        }
    }
    
    
    func onSendButton()
    {
        mSendButton.setTitleColor(UIColor.lightGrayColor(), forState: .Normal)
        mSendButton.enabled = false
        mQueryTextView.mQuestionTextView.resignFirstResponder()
        SSStudentDataSource.sharedDataSource.sendQueryWithQueryText(mQueryTextView.mQuestionTextView.text, withAnonymous: "0", withDelegate: self)
    }
    
    
    func queryPresentState(state:Bool)
    {
        if state == true
        {
            UIView.animateWithDuration(0.2, animations:
                {
                    
                    self.mQueryTextView.hidden = false
                    self.mQueryScrollView.frame = CGRectMake(5, self.mQueryTextView.frame.size.height + self.mQueryTextView.frame.origin.y , self.frame.size.width - 10 , self.frame.size.height - (self.mQueryTextView.frame.size.height + self.mQueryTextView.frame.origin.y + 10))
            })
        }
        else
        {
            UIView.animateWithDuration(0.2, animations:
                {
                    
                    self.mQueryTextView.hidden = true
                    self.mQueryScrollView.frame = CGRectMake(0, (self.mTopbarImageView.frame.size.height + self.mTopbarImageView.frame.origin.y), self.frame.size.width, self.frame.size.height - (self.mTopbarImageView.frame.size.height + self.mTopbarImageView.frame.origin.y))
            })
           
        }
         refreshScrollView()
    }
    
    func refreshScrollView()
    {
        
        
        currentYPosition = 5
        var subViews = mQueryScrollView.subviews
        subViews = subViews.reverse()
        
        for mQuerySubView in subViews
        {
            if mQuerySubView.isKindOfClass(QuerySubview)
            {
                UIView.animateWithDuration(0.2, animations:
                    {
                        mQuerySubView.frame = CGRectMake(mQuerySubView.frame.origin.x ,self.currentYPosition,mQuerySubView.frame.size.width,mQuerySubView.frame.size.height)
                })
                
                
                
                currentYPosition = currentYPosition + mQuerySubView.frame.size.height + 5
            }
        }
        
        
        mQueryScrollView.contentSize = CGSizeMake(0, currentYPosition)
        
    }
    
    
    func feedBackSentFromTeacherWithDetiails(details:AnyObject)
    {
        print(details)
        
        
        if (details.objectForKey("QueryId") != nil)
        {
             if let QueryId = details.objectForKey("QueryId") as? String
             {
                currentQueryId = QueryId
                
                SSStudentDataSource.sharedDataSource.getDoubtReplyForDoutId(QueryId, withDelegate: self)
            }
        }
       
    }
    
    
    
    
    func teacherReviewQuery()
    {
        let subViews = mQueryScrollView.subviews.flatMap{ $0 as? QuerySubview }
        
        for mOptions in subViews
        {
            if mOptions.isKindOfClass(QuerySubview)
            {
                mOptions.mWithDrawButton.hidden = true
            }
        }

    }
    
    // MARK: - datasource delegate Functions
    
    func didGetQuerySentWithDetails(detail: AnyObject)
    {
        print(detail)
        
        if let Status = detail.objectForKey("Status") as? String
        {
            if Status == kSuccessString
            {
                
                
                
                
                let mQuerySubView = QuerySubview(frame: CGRectMake(10 , 10, self.frame.size.width - 20 ,80))
                mQueryScrollView.addSubview(mQuerySubView)
                mQuerySubView.setdelegate(self)
                
                
                
                if let QueryId = detail.objectForKey("QueryId") as? String
                {
                    mQuerySubView.tag = Int(QueryId)!
                    mQuerySubView.frame = CGRectMake(0 , 10, self.frame.size.width ,mQuerySubView.setQueryWithDetails(mQueryTextView.mQuestionTextView.text, withQueryId: QueryId))
                    SSStudentMessageHandler.sharedMessageHandler.sendDoubtMessageToTeacherWithQueryId(QueryId)
                }
                
                
                currentYPosition = currentYPosition + mQuerySubView.frame.size.height + 5
                mQueryScrollView.contentSize = CGSizeMake(0 , currentYPosition)
                
                
                UIView.animateWithDuration(0.2, animations:
                    {
                        
                        self.mQueryTextView.hidden = true
                        self.mQueryScrollView.frame = CGRectMake(0, (self.mTopbarImageView.frame.size.height + self.mTopbarImageView.frame.origin.y), self.frame.size.width, self.frame.size.height - (self.mTopbarImageView.frame.size.height + self.mTopbarImageView.frame.origin.y))
                })
            }
            else
            {
                mSendButton.enabled = true
                mSendButton.setTitleColor(standard_Button, forState: .Normal)
                self.makeToast("Error in sending query.", duration: 3.0, position: .Bottom)
            }
        }
        else
        {
            self.makeToast("Error in sending query.", duration: 3.0, position: .Bottom)
        }
        
        refreshScrollView()
        
        
    }
    
    func didGetResponseToQueryWithDetails(details: AnyObject)
    {
        print(details)
        
        if let querySubView = mQueryScrollView.viewWithTag(Int(currentQueryId)!) as? QuerySubview
        {
            querySubView.mWithDrawButton.hidden = true
            querySubView.setQueryReplyWithDetiails(details)
            
            let dismissFlag = ( details.objectForKey("DismissFlag") as! String)
            
            if dismissFlag == "1"
            {
                UIView.animateWithDuration(0.2, animations:
                    {
                        
                        self.mQueryTextView.hidden = false
                        self.mQueryTextView.mQuestionTextView.text = ""
                        self.mQueryScrollView.frame = CGRectMake(0, self.mQueryTextView.frame.size.height + self.mQueryTextView.frame.origin.y + 10, self.frame.size.width, self.frame.size.height - (self.mQueryTextView.frame.size.height + self.mQueryTextView.frame.origin.y + 10))
                })
                
            }
            else
            {
                
                
            }
        }
    }
    
    func delegateWithDrawButtonPressed()
    {
        
        SSStudentMessageHandler.sharedMessageHandler.sendWithDrawMessageToTeacher()
        
        UIView.animateWithDuration(0.2, animations:
            {
                
                self.mQueryTextView.hidden = false
                self.mQueryScrollView.frame = CGRectMake(0, self.mQueryTextView.frame.size.height + self.mQueryTextView.frame.origin.y + 10, self.frame.size.width, self.frame.size.height - (self.mQueryTextView.frame.size.height + self.mQueryTextView.frame.origin.y + 10))
        })
         refreshScrollView()
    }
    
    
    
    func VolunteerPresentState(state:Bool)
    {
        if state == true
        {
            
            let subViews = mQRVScrollView.subviews
            
            for mQuerySubView in subViews
            {
                if mQuerySubView.isKindOfClass(QRVSubView)
                {
                    mQuerySubView.removeFromSuperview()
                }
            }

            
            SSStudentDataSource.sharedDataSource.GetSRQWithSessionId(SSStudentDataSource.sharedDataSource.currentLiveSessionId, withDelegate: self)
            self.bringSubviewToFront(mQRVScrollView)
            
        }
        else
        {
            UIView.animateWithDuration(0.2, animations:
                {
                    
                    self.mQueryTextView.hidden = false
                    self.mQueryScrollView.frame = CGRectMake(0, self.mQueryTextView.frame.size.height + self.mQueryTextView.frame.origin.y + 10, self.frame.size.width, self.frame.size.height - (self.mQueryTextView.frame.size.height + self.mQueryTextView.frame.origin.y + 10))
            })
            refreshScrollView()

            
            mQRVScrollView.hidden = true
            
        }
    }
    
    func didGetSRQWithDetails(details: AnyObject)
    {
        
        let subViews = mQRVScrollView.subviews
        
        for mQuerySubView in subViews
        {
            if mQuerySubView.isKindOfClass(QRVSubView)
            {
                mQuerySubView.removeFromSuperview()
            }
        }

        
        if let allowVolunteerFlagList = details.objectForKey("AllowVolunteerFlag") as? String
        {
            if let queryIdList = details.objectForKey("QueryIdList") as? String
            {
                if let queryTextList = details.objectForKey("QueryText") as? String
                {
                    
                    let allowVolunteerFlagArray:Array = allowVolunteerFlagList.componentsSeparatedByString(";;;")
                    let queryIdListArray:Array = queryIdList.componentsSeparatedByString(";;;")
                    let queryTextListArray:Array = queryTextList.componentsSeparatedByString(";;;")
                    
                    var qrvPositionY :CGFloat = 10
                    for index in 0  ..< allowVolunteerFlagArray.count
                    {
                        
                        let qrvSubView = QRVSubView(frame:  CGRectMake(10,  qrvPositionY ,self.frame.size.width-20,60))
                        
                        
                        
                        let height =  qrvSubView.getQueryTextSizeWithText(queryTextListArray[index] as String)
                        qrvSubView.tag = Int((queryIdListArray[index]) )!
                        qrvSubView.frame = CGRectMake(10,  qrvPositionY ,self.frame.size.width-20,height)
                        
                        qrvSubView.addAllSUbQuerySubViewWithDetails(allowVolunteerFlagArray[index], withQueryId: (queryIdListArray[index]), withQueryText: (queryTextListArray[index] as String), withQuerySize: height - 50,withCount: String(index+1))
                        
                        //                        if currentQueryId == (queryIdListArray[index])
                        //                        {
                        //                            qrvSubView.VolunteerButton.hidden   = true
                        //                            qrvSubView.meeTooButton.hidden      = true
                        //                            qrvSubView.myQuerylabel.hidden   = false
                        //
                        //                            queryDetailsDictonary.setObject(meeToPressed, forKey: (queryIdListArray[index]))
                        //                        }
                        //                        else
                        //                        {
                        //                            qrvSubView.myQuerylabel.hidden   = true
                        //                            queryDetailsDictonary.setObject(noOptionsSelected, forKey: (queryIdListArray[index]))
                        //                        }
                        //
                        //                        queryTextDetails.setObject((queryTextListArray[index] as String), forKey: (queryIdListArray[index]))
                        
                        mQRVScrollView.addSubview(qrvSubView)
                        qrvSubView.setdelegate(self)
                        qrvSubView.backgroundColor = UIColor.whiteColor()
                        qrvSubView.layer.shadowColor = UIColor.blackColor().CGColor
                        qrvSubView.layer.shadowOffset = CGSize(width: 0, height: 3)
                        qrvSubView.layer.shadowOpacity = 0.3
                        qrvSubView.layer.shadowRadius = 2
                        qrvSubView.layer.cornerRadius = 2
                        
                        qrvPositionY = qrvPositionY + qrvSubView.frame.height + 10
                        
                    }
                    mQRVScrollView.contentSize = CGSizeMake(0, qrvPositionY)
                    
                }
            }
        }
        mQRVScrollView.hidden = false
        
    }
    
    func delegateVonteerPressedWithQueryId(queryId:String)
    {
        
    }
    func delegateMeeTooPressedWithQueryId(queryId:String)
    {
        
    }
    
}