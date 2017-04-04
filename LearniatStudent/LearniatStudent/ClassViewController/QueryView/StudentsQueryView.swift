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
        
        
        mTopbarImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: self.frame.size.width, height: 40))
        mTopbarImageView.backgroundColor = UIColor.white
        self.addSubview(mTopbarImageView)
        mTopbarImageView.isUserInteractionEnabled = true
        mTopbarImageView.isUserInteractionEnabled = true
        
        
        mSendButton.frame = CGRect(x: mTopbarImageView.frame.size.width - 210, y: 0,width: 200,height: mTopbarImageView.frame.size.height )
        mTopbarImageView.addSubview(mSendButton)
        mSendButton.addTarget(self, action: #selector(StudentsQueryView.onSendButton), for: UIControlEvents.touchUpInside)
        mSendButton.setTitle("Send", for: UIControlState())
        mSendButton.contentHorizontalAlignment = UIControlContentHorizontalAlignment.right
        mSendButton.titleLabel?.font = UIFont (name: helveticaMedium, size: 20)
        mSendButton.setTitleColor(UIColor.lightGray, for: UIControlState())
        mSendButton.isEnabled = false
        
        
        mQueryTextView = CustomTextView(frame:CGRect(x: 10, y: mTopbarImageView.frame.size.height + 10 ,width: self.frame.size.width - 20 ,height: 100))
        self.addSubview(mQueryTextView)
        mQueryTextView.setdelegate(self)
        mQueryTextView.setPlaceHolder("Write your query", withStartSting: "Query")
        
        
        mQueryScrollView.frame = CGRect(x: 0, y: mQueryTextView.frame.size.height + mQueryTextView.frame.origin.y + 10, width: self.frame.size.width, height: self.frame.size.height - (mQueryTextView.frame.size.height + mQueryTextView.frame.origin.y + 10))
        mQueryScrollView.backgroundColor = UIColor.clear
        self.addSubview(mQueryScrollView)
        
        
       
        
        
        mQRVScrollView.frame = CGRect(x: 0, y: 0 , width: self.frame.size.width, height: self.frame.size.height)
        self.addSubview(mQRVScrollView)
        mQRVScrollView.backgroundColor = whiteBackgroundColor
        mQRVScrollView.isHidden = true
        
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func delegateTextViewTextChanged(_ chnagedText: String) {
       
        if chnagedText != ""
        {
            mSendButton.isEnabled = true
            mSendButton.setTitleColor(standard_Button, for: UIControlState())
        }
        else
        {
            mSendButton.setTitleColor(UIColor.lightGray, for: UIControlState())
            mSendButton.isEnabled = false
        }
    }
    
    
    func onSendButton()
    {
        
        
        mTopbarImageView.isHidden = true
        mQueryTextView.mQuestionTextView.resignFirstResponder()
        
        if isQuerySent == false
        {
            
            SSStudentDataSource.sharedDataSource.sendQueryWithQueryText(mQueryTextView.mQuestionTextView.text!, withAnonymous: "0", withDelegate: self)
        }
      
    }
    
    
    func queryPresentState(_ state:Bool)
    {
        if state == true
        {
            if isQuerySent == false
            {
                ShowHideQueryTextView(isHidden: false)
            }
            
        }
        else
        {
            ShowHideQueryTextView(isHidden: true)
           
        }
         refreshScrollView()
    }
    
    func refreshScrollView()
    {
        var positionY :CGFloat = 10
        var subViews = mQueryScrollView.subviews
        
        subViews = subViews.reversed()
        
        
        for subview in subViews
        {
            if subview.isKind(of: StudentQuerySubView.self)
            {
                
                UIView.animate(withDuration: 0.2, animations: {
                    subview.frame = CGRect(x: subview.frame.origin.x, y: positionY, width: subview.frame.size.width,  height: subview.frame.size.height)
                })
                
                
                positionY = positionY + subview.frame.size.height + 10
            }
        }
        mQueryScrollView.contentSize = CGSize(width: 0,  height: positionY )
        
    }
    
    
    func feedBackSentFromTeacherWithDetiails(_ details:AnyObject)
    {
        print(details)
        
        
        if (details.object(forKey: "QueryId") != nil)
        {
             if let QueryId = details.object(forKey: "QueryId") as? String
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
            if mOptions.isKind(of: StudentQuerySubView.self)
            {
                mOptions.mWithdrawButton.isHidden = true
            }
        }

    }
    
    // MARK: - datasource delegate Functions
    
    func didGetQuerySentWithDetails(_ detail: AnyObject)
    {
        print(detail)
        
        if let Status = detail.object(forKey: "Status") as? String
        {
            if Status == kSuccessString
            {
                
              
                
                
                
                let querySubView = StudentQuerySubView(frame:  CGRect(x: 10,  y: 10 ,width: self.frame.size.width-20,height: 80))
                querySubView.backgroundColor = UIColor.white
                querySubView.layer.shadowColor = UIColor.black.cgColor
                querySubView.layer.shadowOffset = CGSize(width: 0, height: 3)
                querySubView.layer.shadowOpacity = 0.3
                querySubView.layer.shadowRadius = 2
                querySubView.setdelegate(self)
                let size = querySubView.getQueryTextSizeWithText(mQueryTextView.mQuestionTextView.text!)
                querySubView.layer.cornerRadius = 2
                querySubView.frame = CGRect(x: 10,  y: 10 ,width: self.frame.size.width-20,height: size)
                mQueryScrollView.addSubview(querySubView)
                
                
                
                
                
                
                
                if let QueryId = detail.object(forKey: "QueryId") as? String
                {
                    querySubView.tag = Int(QueryId)!
                    
                    SSStudentMessageHandler.sharedMessageHandler.sendDoubtMessageToTeacherWithQueryId(QueryId)
                }
                
                
                currentYPosition = currentYPosition + querySubView.frame.size.height + 5
                mQueryScrollView.contentSize = CGSize(width: 0 , height: currentYPosition)
                
                ShowHideQueryTextView(isHidden: true)
                isQuerySent = true
                
            }
            else
            {
//                mSendButton.enabled = true
//                mSendButton.setTitleColor(standard_Button, forState: .Normal)
                self.makeToast("Error in sending query.", duration: 3.0, position: .bottom)
                
                ShowHideQueryTextView(isHidden: false)
                
            }
        }
        else
        {
            self.makeToast("Error in sending query.", duration: 3.0, position: .bottom)
            
            
            ShowHideQueryTextView(isHidden: false)
            
            
        }
        
        refreshScrollView()
        
        
    }
    
    func didGetResponseToQueryWithDetails(_ details: AnyObject)
    {
        print(details)
        
        
        
        if let querySubView = mQueryScrollView.viewWithTag(Int(currentQueryId)!) as? StudentQuerySubView
        {
            querySubView.mWithdrawButton.isHidden = true
            var teacherTextReply = ""
            
           if  let _teacherTextReply =  ( details.object(forKey: "TeacherReplyText") as? String)
           {
                teacherTextReply = _teacherTextReply
            }
            if teacherTextReply.isEmpty
            {
                teacherTextReply = ""
            }
            
            
            
            var badge = "0"
            
            if let badgeId = details.object(forKey: "BadgeId") as? String
            {
                badge = badgeId
            }
            
            
            let dismissFlag = ( details.object(forKey: "DismissFlag") as! String)
            
            
            
            
            
            if dismissFlag == "1"
            {
                if querySubView.isQueryEvaluated() == false
                {
                    querySubView.queryState.text = "Cancelled"
                    querySubView.queryState.isHidden = false
                    querySubView.backgroundColor = UIColor(red: 255/255.0, green: 239/255.0, blue: 238/255.0, alpha: 1)
                    
                    
                }
                
                isQuerySent = false
                
                
                
                ShowHideQueryTextView(isHidden: false)
                self.mQueryTextView.mQuestionTextView.text = ""
                
                    currentQueryId = ""
            }
            else
            {
                UIView.animate(withDuration: 0.2, animations: {
                    querySubView.frame = CGRect(x: querySubView.frame.origin.x, y: querySubView.frame.origin.y, width: querySubView.frame.size.width, height: querySubView.teacherReplayWithBadgeId(badge, withText: teacherTextReply) )
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
    
    func delegateQueryWithDrawnwithQueryId(_ queryId: Int)
    {
         SSStudentDataSource.sharedDataSource.withDrawQueryWithQueryId(String(queryId), withDelegate: self)
        SSStudentMessageHandler.sharedMessageHandler.sendDoubtWithdrwanFromStudentWithQueryId(String(queryId))
        ShowHideQueryTextView(isHidden: false)
        
         isQuerySent = false
         refreshScrollView()
    }
    
    
    func ShowHideQueryTextView(isHidden:Bool)
    {
        if isHidden == true
        {
            self.mQueryTextView.isHidden = true
            self.mTopbarImageView.isHidden = true
            self.mQueryScrollView.frame = CGRect(x: 0, y: (self.mTopbarImageView.frame.size.height + self.mTopbarImageView.frame.origin.y), width: self.frame.size.width, height: self.frame.size.height - (self.mTopbarImageView.frame.size.height + self.mTopbarImageView.frame.origin.y))
        }
        else
        {
            UIView.animate(withDuration: 0.2, animations:
                {
                    
                    self.mQueryTextView.isHidden = false
                    self.mTopbarImageView.isHidden = false
                    self.mQueryScrollView.frame = CGRect(x: 0, y: self.mQueryTextView.frame.size.height + self.mQueryTextView.frame.origin.y + 10, width: self.frame.size.width, height: self.frame.size.height - (self.mQueryTextView.frame.size.height + self.mQueryTextView.frame.origin.y + 10))
            })
        }
    }
    
    
    
    func VolunteerPresentState(_ state:Bool)
    {
        if state == true
        {
            
            
            let subViews = mQRVScrollView.subviews
            
            for mQuerySubView in subViews
            {
                if mQuerySubView.isKind(of: QRVSubView.self)
                {
                    mQuerySubView.removeFromSuperview()
                }
            }

            
            SSStudentDataSource.sharedDataSource.GetSRQWithSessionId(SSStudentDataSource.sharedDataSource.currentLiveSessionId, withDelegate: self)
            self.bringSubview(toFront: mQRVScrollView)
            
        }
        else
        {
            
            isQuerySent = false
            
            
            ShowHideQueryTextView(isHidden: false)
            
            refreshScrollView()

            
            mQRVScrollView.isHidden = true
            
        }
        
    }
    
    func didGetSRQWithDetails(_ details: AnyObject)
    {
        
        let subViews = mQRVScrollView.subviews
        
        for mQuerySubView in subViews
        {
            if mQuerySubView.isKind(of: QRVSubView.self)
            {
                mQuerySubView.removeFromSuperview()
            }
        }

        
        print(details)
        
        if let allowVolunteerFlagList = details.object(forKey: "AllowVolunteerFlag") as? String
        {
            if let queryIdList = details.object(forKey: "QueryIdList") as? String
            {
                if let queryTextList = details.object(forKey: "QueryText") as? String
                {
                    
                    if let StudentNameList = details.object(forKey: "StudentName") as? String
                    {
                       
                        
                        let allowVolunteerFlagArray:Array = allowVolunteerFlagList.components(separatedBy: ";;;")
                        let queryIdListArray:Array = queryIdList.components(separatedBy: ";;;")
                        let queryTextListArray:Array = queryTextList.components(separatedBy: ";;;")
                        let studentNameListArray:Array = StudentNameList.components(separatedBy: ";;;")
                        
                        var qrvPositionY :CGFloat = 10
                        for index in 0  ..< allowVolunteerFlagArray.count
                        {
                            
                            let qrvSubView = QRVSubView(frame:  CGRect(x: 10,  y: qrvPositionY ,width: self.frame.size.width-20,height: 60))
                            
                            SSStudentDataSource.sharedDataSource.QRVQueryDictonary.setObject((queryTextListArray[index] as String), forKey: (queryIdListArray[index] as String as NSCopying))
                            
                            let height =  qrvSubView.getQueryTextSizeWithText(queryTextListArray[index] as String)
                            qrvSubView.tag = Int((queryIdListArray[index]) )!
                            qrvSubView.frame = CGRect(x: 10,  y: qrvPositionY ,width: self.frame.size.width-20,height: height)
                            
                            
                            if let studentName = studentNameListArray[index] as? String
                            {
                                if studentName.capitalized == SSStudentDataSource.sharedDataSource.currentUserName.capitalized
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
                            qrvSubView.backgroundColor = UIColor.white
                            qrvSubView.layer.shadowColor = UIColor.black.cgColor
                            qrvSubView.layer.shadowOffset = CGSize(width: 0, height: 3)
                            qrvSubView.layer.shadowOpacity = 0.3
                            qrvSubView.layer.shadowRadius = 2
                            qrvSubView.layer.cornerRadius = 2
                            
                            qrvPositionY = qrvPositionY + qrvSubView.frame.height + 10
                            
                        }
                        mQRVScrollView.contentSize = CGSize(width: 0, height: qrvPositionY)
                    }
                    
                  
                    
                }
            }
        }
        mQRVScrollView.isHidden = false
        
    }
    
    
    
    func volunteerClosedWithQueryId(_ queryId:String, withStudentdID studentId:String, withTotalVotes percentage:CGFloat)
    {
        
        if  queryId != ""
        {
            
            
            
            
            if let qrvSubView = mQRVScrollView.viewWithTag(Int(queryId)!) as? QRVSubView
            {
                
                
                if qrvSubView.numberOfVolunteerResponse <= 0
                {
                    qrvSubView.frame = CGRect(x: qrvSubView.frame.origin.x, y: qrvSubView.frame.origin.y, width: qrvSubView.frame.size.width, height: qrvSubView.frame.size.height + 70 )
                    
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
            if subview.isKind(of: QRVSubView.self)
            {
                
                UIView.animate(withDuration: 0.5, animations: {
                    subview.frame = CGRect(x: subview.frame.origin.x, y: positionY, width: subview.frame.size.width,  height: subview.frame.size.height)
                })
                
                
                positionY = positionY + subview.frame.size.height + 10
            }
        }
        mQRVScrollView.contentSize = CGSize(width: 0,  height: positionY )
        
    }
    
}
