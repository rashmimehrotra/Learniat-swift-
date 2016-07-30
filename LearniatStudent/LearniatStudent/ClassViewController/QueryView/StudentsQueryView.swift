//
//  StudentsQueryView.swift
//  LearniatStudent
//
//  Created by Deepak MK on 10/05/16.
//  Copyright © 2016 Mindshift. All rights reserved.
//

import Foundation
class StudentsQueryView: UIView,CustomTextViewDelegate,SSStudentDataSourceDelegate,StudentQuerySubViewDelegate
{
    var mTopbarImageView = UIImageView()
    var mSendButton = UIButton()
    var mQueryTextView : CustomTextView!
    var mQueryScrollView    = UIScrollView()
    var currentYPosition: CGFloat = 5
    var currentQueryId      = ""
    var mQRVScrollView      = UIScrollView()
    
    var isQuerySent           = false
    
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
        self.mTopbarImageView.hidden = true
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
        
        
        mTopbarImageView.hidden = true
        mQueryTextView.mQuestionTextView.resignFirstResponder()
        
        if isQuerySent == false
        {
            
            SSStudentDataSource.sharedDataSource.sendQueryWithQueryText(mQueryTextView.mQuestionTextView.text, withAnonymous: "0", withDelegate: self)
        }
      
    }
    
    
    func queryPresentState(state:Bool)
    {
        if state == true
        {
            if isQuerySent == false
            {
                UIView.animateWithDuration(0.2, animations:
                    {
                        
                        self.mQueryTextView.hidden = false
                        self.mTopbarImageView.hidden = false
                        self.mQueryScrollView.frame = CGRectMake(5, self.mQueryTextView.frame.size.height + self.mQueryTextView.frame.origin.y , self.frame.size.width - 10 , self.frame.size.height - (self.mQueryTextView.frame.size.height + self.mQueryTextView.frame.origin.y + 10))
                })
            }
            
        }
        else
        {
            UIView.animateWithDuration(0.2, animations:
                {
                    
                    self.mQueryTextView.hidden = true
                    self.mTopbarImageView.hidden = true
                    self.mQueryScrollView.frame = CGRectMake(0, (self.mTopbarImageView.frame.size.height + self.mTopbarImageView.frame.origin.y), self.frame.size.width, self.frame.size.height - (self.mTopbarImageView.frame.size.height + self.mTopbarImageView.frame.origin.y))
            })
           
        }
         refreshScrollView()
    }
    
    func refreshScrollView()
    {
        var positionY :CGFloat = 10
        var subViews = mQueryScrollView.subviews
        
        subViews = subViews.reverse()
        
        
        for subview in subViews
        {
            if subview.isKindOfClass(StudentQuerySubView)
            {
                
                UIView.animateWithDuration(0.2, animations: {
                    subview.frame = CGRectMake(subview.frame.origin.x, positionY, subview.frame.size.width,  subview.frame.size.height)
                })
                
                
                positionY = positionY + subview.frame.size.height + 10
            }
        }
        mQueryScrollView.contentSize = CGSizeMake(0,  positionY )
        
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
        let subViews = mQueryScrollView.subviews.flatMap{ $0 as? StudentQuerySubView }
        
        for mOptions in subViews
        {
            if mOptions.isKindOfClass(StudentQuerySubView)
            {
                mOptions.mWithdrawButton.hidden = true
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
                
              
                
                
                
                let querySubView = StudentQuerySubView(frame:  CGRectMake(10,  10 ,self.frame.size.width-20,80))
                querySubView.backgroundColor = UIColor.whiteColor()
                querySubView.layer.shadowColor = UIColor.blackColor().CGColor
                querySubView.layer.shadowOffset = CGSize(width: 0, height: 3)
                querySubView.layer.shadowOpacity = 0.3
                querySubView.layer.shadowRadius = 2
                querySubView.setdelegate(self)
                let size = querySubView.getQueryTextSizeWithText(mQueryTextView.mQuestionTextView.text)
                querySubView.layer.cornerRadius = 2
                querySubView.frame = CGRectMake(10,  10 ,self.frame.size.width-20,size)
                mQueryScrollView.addSubview(querySubView)
                
                
                
                
                
                
                
                if let QueryId = detail.objectForKey("QueryId") as? String
                {
                    querySubView.tag = Int(QueryId)!
                    
                    SSStudentMessageHandler.sharedMessageHandler.sendDoubtMessageToTeacherWithQueryId(QueryId)
                }
                
                
                currentYPosition = currentYPosition + querySubView.frame.size.height + 5
                mQueryScrollView.contentSize = CGSizeMake(0 , currentYPosition)
                
                
                UIView.animateWithDuration(0.2, animations:
                    {
                        
                        self.mQueryTextView.hidden = true
                        self.mTopbarImageView.hidden = true
                        self.mQueryScrollView.frame = CGRectMake(0, (self.mTopbarImageView.frame.size.height + self.mTopbarImageView.frame.origin.y), self.frame.size.width, self.frame.size.height - (self.mTopbarImageView.frame.size.height + self.mTopbarImageView.frame.origin.y))
                })
                
                isQuerySent = true
                
            }
            else
            {
//                mSendButton.enabled = true
//                mSendButton.setTitleColor(standard_Button, forState: .Normal)
                self.makeToast("Error in sending query.", duration: 3.0, position: .Bottom)
                
                UIView.animateWithDuration(0.2, animations:
                    {
                        
                        self.mQueryTextView.hidden = false
                        self.mTopbarImageView.hidden = false
                        self.mQueryScrollView.frame = CGRectMake(5, self.mQueryTextView.frame.size.height + self.mQueryTextView.frame.origin.y , self.frame.size.width - 10 , self.frame.size.height - (self.mQueryTextView.frame.size.height + self.mQueryTextView.frame.origin.y + 10))
                })
                
            }
        }
        else
        {
            self.makeToast("Error in sending query.", duration: 3.0, position: .Bottom)
            
            
            UIView.animateWithDuration(0.2, animations:
                {
                    
                    self.mQueryTextView.hidden = false
                    self.mTopbarImageView.hidden = false
                    self.mQueryScrollView.frame = CGRectMake(5, self.mQueryTextView.frame.size.height + self.mQueryTextView.frame.origin.y , self.frame.size.width - 10 , self.frame.size.height - (self.mQueryTextView.frame.size.height + self.mQueryTextView.frame.origin.y + 10))
            })
            
            
        }
        
        refreshScrollView()
        
        
    }
    
    func didGetResponseToQueryWithDetails(details: AnyObject)
    {
        print(details)
        
        
        
        if let querySubView = mQueryScrollView.viewWithTag(Int(currentQueryId)!) as? StudentQuerySubView
        {
            querySubView.mWithdrawButton.hidden = true
            var teacherTextReply = ""
            
           if  let _teacherTextReply =  ( details.objectForKey("TeacherReplyText") as? String)
           {
                teacherTextReply = _teacherTextReply
            }
            if teacherTextReply.isEmpty
            {
                teacherTextReply = ""
            }
            
            
            
            var badge = "0"
            
            if let badgeId = details.objectForKey("BadgeId") as? String
            {
                badge = badgeId
            }
            
            
            let dismissFlag = ( details.objectForKey("DismissFlag") as! String)
            
            
            
            
            
            if dismissFlag == "1"
            {
                if querySubView.isQueryEvaluated() == false
                {
                    querySubView.queryState.text = "Cancelled"
                    querySubView.queryState.hidden = false
                    querySubView.backgroundColor = UIColor(red: 255/255.0, green: 239/255.0, blue: 238/255.0, alpha: 1)
                    
                    
                }
                
                isQuerySent = false
                
                UIView.animateWithDuration(0.2, animations:
                    {
                        
                        self.mQueryTextView.hidden = false
                        self.mTopbarImageView.hidden = false
                        self.mQueryTextView.mQuestionTextView.text = ""
                        self.mQueryScrollView.frame = CGRectMake(0, self.mQueryTextView.frame.size.height + self.mQueryTextView.frame.origin.y + 10, self.frame.size.width, self.frame.size.height - (self.mQueryTextView.frame.size.height + self.mQueryTextView.frame.origin.y + 10))
                })

                
                    currentQueryId = ""
            }
            else
            {
                UIView.animateWithDuration(0.2, animations: {
                    querySubView.frame = CGRectMake(querySubView.frame.origin.x, querySubView.frame.origin.y, querySubView.frame.size.width, querySubView.teacherReplayWithBadgeId(badge, withText: teacherTextReply) )
                })
 
            }
        }
        
//        if let querySubView = mQueryScrollView.viewWithTag(Int(currentQueryId)!) as? StudentQuerySubView
//        {
//            querySubView.mWithdrawButton.hidden = true
//            querySubView.setQueryReplyWithDetiails(details)
//            
//            let dismissFlag = ( details.objectForKey("DismissFlag") as! String)
//            
//            if dismissFlag == "1"
//            {
//                
//                
//            }
//            else
//            {
//                
//                
//            }
//        }
        
        
        refreshScrollView()
    }
    
    func delegateQueryWithDrawnwithQueryId(queryId: Int)
    {
         SSStudentDataSource.sharedDataSource.withDrawQueryWithQueryId(String(queryId), withDelegate: self)
        SSStudentMessageHandler.sharedMessageHandler.sendDoubtWithdrwanFromStudentWithQueryId(String(queryId))
        
        UIView.animateWithDuration(0.2, animations:
            {
                
                self.mQueryTextView.hidden = false
                self.mTopbarImageView.hidden = false
                self.mQueryScrollView.frame = CGRectMake(0, self.mQueryTextView.frame.size.height + self.mQueryTextView.frame.origin.y + 10, self.frame.size.width, self.frame.size.height - (self.mQueryTextView.frame.size.height + self.mQueryTextView.frame.origin.y + 10))
        })
         isQuerySent = false
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
            
            isQuerySent = false
            
//            UIView.animateWithDuration(0.2, animations:
//                {
//                    
//                    self.mQueryTextView.hidden = false
//                    self.mQueryTextView.mQuestionTextView.text = ""
//                    self.mQueryScrollView.frame = CGRectMake(0, self.mQueryTextView.frame.size.height + self.mQueryTextView.frame.origin.y + 10, self.frame.size.width, self.frame.size.height - (self.mQueryTextView.frame.size.height + self.mQueryTextView.frame.origin.y + 10))
//            })
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

        
        print(details)
        
        if let allowVolunteerFlagList = details.objectForKey("AllowVolunteerFlag") as? String
        {
            if let queryIdList = details.objectForKey("QueryIdList") as? String
            {
                if let queryTextList = details.objectForKey("QueryText") as? String
                {
                    
                    if let StudentNameList = details.objectForKey("StudentName") as? String
                    {
                       
                        
                        let allowVolunteerFlagArray:Array = allowVolunteerFlagList.componentsSeparatedByString(";;;")
                        let queryIdListArray:Array = queryIdList.componentsSeparatedByString(";;;")
                        let queryTextListArray:Array = queryTextList.componentsSeparatedByString(";;;")
                        let studentNameListArray:Array = StudentNameList.componentsSeparatedByString(";;;")
                        
                        var qrvPositionY :CGFloat = 10
                        for index in 0  ..< allowVolunteerFlagArray.count
                        {
                            
                            let qrvSubView = QRVSubView(frame:  CGRectMake(10,  qrvPositionY ,self.frame.size.width-20,60))
                            
                            SSStudentDataSource.sharedDataSource.QRVQueryDictonary.setObject((queryTextListArray[index] as String), forKey: (queryIdListArray[index] as String))
                            
                            let height =  qrvSubView.getQueryTextSizeWithText(queryTextListArray[index] as String)
                            qrvSubView.tag = Int((queryIdListArray[index]) )!
                            qrvSubView.frame = CGRectMake(10,  qrvPositionY ,self.frame.size.width-20,height)
                            
                            
                            if let studentName = studentNameListArray[index] as? String
                            {
                                if studentName.capitalizedString == SSStudentDataSource.sharedDataSource.currentUserName.capitalizedString
                                {
                                    qrvSubView.addAllSUbQuerySubViewWithDetails(allowVolunteerFlagArray[index], withQueryId: (queryIdListArray[index]), withQueryText: (queryTextListArray[index] as String), withQuerySize: height - 50,withCount: String(index+1), withMyQuery:true)
                                }
                                else
                                {
                                    qrvSubView.addAllSUbQuerySubViewWithDetails(allowVolunteerFlagArray[index], withQueryId: (queryIdListArray[index]), withQueryText: (queryTextListArray[index] as String), withQuerySize: height - 50,withCount: String(index+1), withMyQuery:false)
                                }
                            }
                            

                            
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
        }
        mQRVScrollView.hidden = false
        
    }
    
    
    
    func volunteerClosedWithQueryId(queryId:String, withStudentdID studentId:String, withTotalVotes percentage:CGFloat)
    {
        
        if  queryId != ""
        {
            
            
            
            
            if let qrvSubView = mQRVScrollView.viewWithTag(Int(queryId)!) as? QRVSubView
            {
                
                
                if qrvSubView.numberOfVolunteerResponse <= 0
                {
                    qrvSubView.frame = CGRectMake(qrvSubView.frame.origin.x, qrvSubView.frame.origin.y, qrvSubView.frame.size.width, qrvSubView.frame.size.height + 70 )
                    
                    changeQRVPositionOfSubView()
                }
                
                
                
                
                
                
                
                
                qrvSubView.addVolunteerDetailsDotWithStudentid(studentId, WithDecreasingValue: percentage * 100.00)
                
            }
            
            
            
            
//            if let studentqueryView  = mQRVScrollView.viewWithTag(Int(queryId)!) as? QRVSubView
//            {
//                
//                
//                studentqueryView.addVolunteerDetailsDotWithStudentid(studentId, WithDecreasingValue: 66)
//            }
        }
    }
    func changeQRVPositionOfSubView()
    {
        var positionY :CGFloat = 10
        let subViews = mQRVScrollView.subviews
        
        for subview in subViews
        {
            if subview.isKindOfClass(QRVSubView)
            {
                
                UIView.animateWithDuration(0.5, animations: {
                    subview.frame = CGRectMake(subview.frame.origin.x, positionY, subview.frame.size.width,  subview.frame.size.height)
                })
                
                
                positionY = positionY + subview.frame.size.height + 10
            }
        }
        mQRVScrollView.contentSize = CGSizeMake(0,  positionY )
        
    }
    
}