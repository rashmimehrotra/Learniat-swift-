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
    
    
    optional func delegateVolunteerSessionEndedWithRemainingqueries(queryIdArray:NSMutableArray)
    
    
}


class SSTeacherVolunteerView: UIView,SSTeacherDataSourceDelegate,UIAlertViewDelegate, QueryVolunteerSubViewDelegate,UIPopoverControllerDelegate,VolunteerPopoverControllerDelegate,UIPopoverPresentationControllerDelegate, VolunteerAnsweringPopOverDelegate,VolunteerTopViewDelegate
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
    
    var studentVolunteeringPopoverView : VolunteerAnsweringPopOver!
    
    var metooMaxCount           = 0
    var volunteerMaxCount       = 0
    
    var remianingQueryIdArray       = NSMutableArray()
    
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
        mDoneButton.addTarget(self, action: #selector(SSTeacherVolunteerView.onDoneButton), forControlEvents: .TouchUpInside)
        
        mQueryCountLabel.frame = CGRectMake(10, 0, 120, mTopImageView.frame.size.height)
        self.addSubview(mQueryCountLabel)
        
        
        
        
        
        let mQuerySubView = VolunteerTopView(frame: CGRectMake(10 , mTopImageView.frame.size.height + mTopImageView.frame.origin.y + 10, self.frame.size.width - 20 ,20))
        self.addSubview(mQuerySubView)
        mQuerySubView.setdelegate(self)
        
        
        mScrollView = UIScrollView()
        mScrollView.frame = CGRectMake(0, mQuerySubView.frame.size.height + mQuerySubView.frame.origin.y, self.frame.size.width, self.frame.size.height - (mQuerySubView.frame.size.height + mQuerySubView.frame.origin.y) )
        self.addSubview(mScrollView)
        

        
//        SSTeacherDataSource.sharedDataSource.GetSRQWithSessionId(SSTeacherDataSource.sharedDataSource.currentLiveSessionId, withDelegate: self)
        
        
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
    
    
    
    func didGetSRQWithDetails(details: AnyObject)
    {
        
         currentYPosition  = 10
        
//        let subViews = mScrollView.subviews
//        
//        for mQuerySubView in subViews
//        {
//            if mQuerySubView.isKindOfClass(QueryVolunteerSubView)
//            {
//                mQuerySubView.removeFromSuperview()
//            }
//        }
//        
//        
//        
//        if let allowVolunteerFlagList = details.objectForKey("AllowVolunteerFlag") as? String
//        {
//            if let queryIdList = details.objectForKey("QueryIdList") as? String
//            {
//                if let queryTextList = details.objectForKey("QueryText") as? String
//                {
//                    
//                    if let StudentNameList = details.objectForKey("StudentName") as? String
//                    {
//                        
//                        
//                        let allowVolunteerFlagArray:Array = allowVolunteerFlagList.componentsSeparatedByString(";;;")
//                        let queryIdListArray:Array = queryIdList.componentsSeparatedByString(";;;")
//                        let queryTextListArray:Array = queryTextList.componentsSeparatedByString(";;;")
//                        
//                        for index in 0  ..< allowVolunteerFlagArray.count
//                        {
//                            
//                            let qrvSubView = QueryVolunteerSubView(frame: CGRectMake(10 , currentYPosition, self.frame.size.width - 20 ,80))
//                            
//                           qrvSubView.setQueryText((queryTextListArray[index] as String), withQueryId: (queryIdListArray[index] as String), withStudentId: <#T##String#>)
//                            mScrollView.addSubview(qrvSubView)
//                            qrvSubView.setdelegate(self)
//                            currentYPosition = currentYPosition + qrvSubView.frame.height + 10
//                            
//                        }
//                        mScrollView.contentSize = CGSizeMake(0, currentYPosition)
//                    }
//                }
//            }
//        }
        
    }
    
    
    func addQueriesWithDetails(queryDetails:NSMutableArray)
    {
        currentYPosition  = 10
        
        for index in 0  ..< queryDetails.count 
        {
            let queryDict = queryDetails.objectAtIndex(index)
            
            let mQuerySubView = QueryVolunteerSubView(frame: CGRectMake(10 , currentYPosition, self.frame.size.width - 20 ,80))
            mScrollView.addSubview(mQuerySubView)
            mQuerySubView.setdelegate(self)
            
            mQuerySubView.setQueryWithDetails(queryDict)
            
            
            if let queryText = queryDict.objectForKey("QueryText") as? String
            {
                
               mQuerySubView.mQueryLabel.text = "\(index+1). \(queryText)"
            }
            
            
            if let QueryId = queryDict.objectForKey("QueryId") as? String
            {
                mQuerySubView.tag = Int(QueryId)!
            }
            
            
            currentYPosition = currentYPosition + mQuerySubView.frame.size.height + 10
            
            
            
        }
        
        mScrollView.contentSize = CGSizeMake(0, currentYPosition)
        
        
        if queryDetails.count > 1
        {
            mQueryCountLabel.text = "\(queryDetails.count) Queries"
        }
            
        else
        {
            mQueryCountLabel.text = "\(queryDetails.count) Query"
        }
        
        
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
        
        remianingQueryIdArray.removeAllObjects()
        
        let subViews = mScrollView.subviews.flatMap{ $0 as? QueryVolunteerSubView }
        
        for mQuerySubView in subViews
        {
            if mQuerySubView.isKindOfClass(QueryVolunteerSubView)
            {
               
                
                
                if mQuerySubView.mMetooLabel.text! != "0"
                {
                    if let QueryId = mQuerySubView.currentQueryDetails.objectForKey("QueryId") as? String
                    {
                        mQueryIdList.addObject(QueryId)
                        remianingQueryIdArray.addObject(QueryId)
                    }
                    
                     meTooCountList.addObject(mQuerySubView.mMetooLabel.text!)
                    
                    
                    
                    
                }
                else
                {
                    
                    if let QueryId = mQuerySubView.currentQueryDetails.objectForKey("QueryId") as? String
                    {
                        if let StudentId = mQuerySubView.currentQueryDetails.objectForKey("StudentId") as? String
                        {
                            SSTeacherDataSource.sharedDataSource.dismissQuerySelectedForVolunteerWithQueryId(QueryId, withStudentId: StudentId, WithDelegate: self)
                            
                            
                        }
                        
                    }
                }
            }
        }
        
        
        
        let queryIdString = mQueryIdList.componentsJoinedByString(";;;")
        let meTooCountString = meTooCountList.componentsJoinedByString(";;;")
        
        SSTeacherDataSource.sharedDataSource.EndVolunteeringSessionwithQueryId(queryIdString, withMeTooList: meTooCountString, WithDelegate: self)
        
        
        
    }
    
    func didGetVolunteeringEndedWithDetails(details: AnyObject)
    {
       
        SSTeacherMessageHandler.sharedMessageHandler.sendEndVolunteeringMessagetoStudent(SSTeacherDataSource.sharedDataSource.currentLiveSessionId)
        
        if delegate().respondsToSelector(#selector(SSTeacherVolunteerViewDelegate.delegateVolunteerSessionEndedWithRemainingqueries(_:)))
        {
            
            
            delegate().delegateVolunteerSessionEndedWithRemainingqueries!(remianingQueryIdArray)
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
    
    func didGetQueryRespondedWithDetails(details: AnyObject)
    {
        print(details)
    }
    
     // MARK: - Query Volunteer  functions
    
    func volunteerRaiserWithDetails(details:AnyObject)
    {
        
        if (details.objectForKey("QueryId") != nil)
        {
            if let QueryId = details.objectForKey("QueryId") as? String
            {
                if let studentqueryView  = mScrollView.viewWithTag(Int(QueryId)!) as? QueryVolunteerSubView
                {
                    studentqueryView.setVolunteersDetials(details)
                    
                    if volunteerMaxCount < studentqueryView.mVolunteersDetailsArray.count
                    {
                        volunteerMaxCount = studentqueryView.mVolunteersDetailsArray.count
                    }
                }
            }
            
            
            
        }
        
    }
    
    func metooRaisedWithDetails(details:AnyObject)
    {
        if (details.objectForKey("QueryId") != nil)
        {
            if let QueryId = details.objectForKey("QueryId") as? String
            {
                if let studentqueryView  = mScrollView.viewWithTag(Int(QueryId)!) as? QueryVolunteerSubView
                {
                   
                    if let StudentId = details.objectForKey("StudentId") as? String
                    {
                         studentqueryView.setMeTooSelectedStudents(StudentId)
                        
                        if metooMaxCount < studentqueryView.mmMetooSelectedArray.count
                        {
                            metooMaxCount = studentqueryView.mmMetooSelectedArray.count
                        }
                    }
                }
            }
        }
    }
    
    
    // MARK: - Query Volunteer subView functions
    
    func delegateVolunteerButtonPressedWithVolunteersArray(volunteersArray: NSMutableArray, withVolunteerButton volunteerButton: UIButton) {
        
        let buttonPosition :CGPoint = volunteerButton.convertPoint(CGPointZero, toView: self)
        
        let questionInfoController = VolunteerPopoverController()
        
        
        questionInfoController.addVolunteerWithDetails(volunteersArray)
        
        
        var height :CGFloat = CGFloat((volunteersArray.count * 60))
        
        
        if height > UIScreen.mainScreen().bounds.height - 100
        {
            height = UIScreen.mainScreen().bounds.height - 100
        }
        
        
        
        questionInfoController.preferredContentSize = CGSizeMake(300,height)
        
        questionInfoController.setdelegate(self)
        
        let   classViewPopOverController = UIPopoverController(contentViewController: questionInfoController)
        
        classViewPopOverController.popoverContentSize = CGSizeMake(300,height);
        
        classViewPopOverController.delegate = self;
        
        questionInfoController.setPopover(classViewPopOverController)
        
        classViewPopOverController.presentPopoverFromRect(CGRect(
            x:buttonPosition.x ,
            y:buttonPosition.y + volunteerButton.frame.size.height / 2,
            width: 1,
            height: 1), inView: self, permittedArrowDirections: .Right, animated: true)
    }
    // MARK: - Volunteer popover delegate functions
    
    func delegateGiveAnswerPressedWithVolunteerDetails(volunteerDetails: AnyObject)
    {
        
        if (volunteerDetails.objectForKey("QueryId") != nil)
        {
            if let QueryId = volunteerDetails.objectForKey("QueryId") as? String
            {
                if let studentqueryView  = mScrollView.viewWithTag(Int(QueryId)!) as? QueryVolunteerSubView
                {
                    
                    
                    
                    
                  
                    
                    
                    
                    
                    studentqueryView.backgroundColor = UIColor.whiteColor()
                    studentqueryView.layer.shadowColor = UIColor.blackColor().CGColor
                    studentqueryView.layer.shadowOffset = CGSize(width: 0, height: 3)
                    studentqueryView.layer.shadowOpacity = 0.3
                    studentqueryView.layer.shadowRadius = 2
                    if let VolunteerId = volunteerDetails.objectForKey("VolunteerId") as? String
                    {
                         SSTeacherDataSource.sharedDataSource.sendApporoveVolunteerWithVolunteerId(VolunteerId, withstateFlag: "1", WithDelegate: self)
                        
                    }
                    
                   
//                    let buttonPosition :CGPoint = studentqueryView.convertPoint(CGPointZero, toView: self)
                    
                     studentVolunteeringPopoverView = VolunteerAnsweringPopOver(frame:CGRectMake(self.frame.size.width - 350 , (self.frame.size.height - 260)/2 , 150,260))
                    studentVolunteeringPopoverView.setVolunteerDetails(volunteerDetails)
                    studentVolunteeringPopoverView.setdelegate(self)
                    self.addSubview(studentVolunteeringPopoverView)
                    studentVolunteeringPopoverView.layer.shadowColor = UIColor.blackColor().CGColor
                    studentVolunteeringPopoverView.layer.shadowOffset = CGSize(width: 0, height: 3)
                    studentVolunteeringPopoverView.layer.shadowOpacity = 0.3
                    studentVolunteeringPopoverView.layer.shadowRadius = 2
                    
                    
                    studentqueryView.removeVolunteerWithDetails(volunteerDetails)
                    
                    
                }
            }
        }
        
    }
    
    func delegateStopVolunteeringPressedWithVolunteerDetails(volunteerDetails: AnyObject, withThummbsUp ThummbsUp: String, withThummbsDown ThummbsDown: String, withTotalVotes totalVotes: String) {
        
        
        if (volunteerDetails.objectForKey("QueryId") != nil)
        {
            if let QueryId = volunteerDetails.objectForKey("QueryId") as? String
            {
                if let studentqueryView  = mScrollView.viewWithTag(Int(QueryId)!) as? QueryVolunteerSubView
                {
                    studentqueryView.backgroundColor = UIColor.clearColor()
                    studentqueryView.layer.shadowColor = UIColor.clearColor().CGColor
                    studentqueryView.layer.shadowOffset = CGSize(width: 0, height: 0)
                    studentqueryView.layer.shadowRadius = 0

                    if let VolunteerId = volunteerDetails.objectForKey("VolunteerId") as? String
                    {
                        SSTeacherDataSource.sharedDataSource.StopVolunteeringwithVolunteerId(VolunteerId, withthumbsUp: ThummbsUp, withthumbsDown: ThummbsDown, WithDelegate: self)
                        
                    }
                    
                    
                    
                    var totalPercentage :CGFloat = 0
                    
                    if Int(totalVotes)! >= Int(ThummbsUp)!
                    {
                         totalPercentage = CGFloat(Int(ThummbsUp)!)/CGFloat(Int(totalVotes)!)
                    }
                        
                    else
                    {
                        totalPercentage = 1
                    }
                    
                    
                    
                    
                    
                    
                    if let StudentId = volunteerDetails.objectForKey("StudentId") as? String
                    {
                        SSTeacherMessageHandler.sharedMessageHandler.sendQRVClosedMessageToRoom(SSTeacherDataSource.sharedDataSource.currentLiveSessionId, withstudentId: StudentId, withQueryId: QueryId, withVolunterPercentage: "\(totalPercentage)")
                    }
                    
                    
                    studentqueryView.incrementVolunteeredCountwithPercentage(totalPercentage * 100)
                    
                    

                }
            }
        }
        

    }
    
    
    
    
    func didGetNewVoteFromStudent(studentId:String, withNewVote newVote:String , withTotalStudents totalStudents:Int)
    {
        if studentVolunteeringPopoverView != nil
        {
            studentVolunteeringPopoverView.sendNewVoteWithStudentId(studentId, withVoteValue: newVote,withTotalStudents: totalStudents)
        }
        
    }
    
    
    func queryUnderstoodMessageFromStudentWithQueryId(QueryId:String, withStudentId StudentId:String)
    {
        if let studentqueryView  = mScrollView.viewWithTag(Int(QueryId)!) as? QueryVolunteerSubView
        {
            studentqueryView.removeMeTooWithStudents(StudentId)
        }
    }
    
    
    
     // MARK: - Volunteer Topview delegate functions
    
    
    func delegateQueryButtonPressedWithAscending(Isascending: Bool)
    {
        
        
        var currentY:CGFloat = 10
        
        let subViews = mScrollView.subviews.flatMap{ $0 as? QueryVolunteerSubView }
        
        for mQuerySubView in subViews
        {
            if mQuerySubView.isKindOfClass(QueryVolunteerSubView)
            {
                UIView.animateWithDuration(0.5, animations:
                    {
                        mQuerySubView.frame = CGRectMake(mQuerySubView.frame.origin.x , currentY, mQuerySubView.frame.size.width ,mQuerySubView.frame.size.height)
                })
                
                

                
                    currentY = currentY + mQuerySubView.frame.size.height + 10
                
                
                
            }
        }
    }
    
    func delegateMetooButtonPressedWithAscending(Isascending: Bool) {
        
         var currentY:CGFloat = 10
        
        if Isascending == true
        {
            for index in 0 ..< metooMaxCount+1
            {
                
                let subViews = mScrollView.subviews.flatMap{ $0 as? QueryVolunteerSubView }
                
                for mQuerySubView in subViews
                {
                    if mQuerySubView.isKindOfClass(QueryVolunteerSubView)
                    {
                        if mQuerySubView.mmMetooSelectedArray.count == index
                        {
                            
                            UIView.animateWithDuration(0.5, animations:
                                {
                                    mQuerySubView.frame = CGRectMake(mQuerySubView.frame.origin.x , currentY, mQuerySubView.frame.size.width ,mQuerySubView.frame.size.height)
                            })
                            
                            
                            
                            currentY = currentY + mQuerySubView.frame.size.height + 10
                        }
                        
                        
                    }
                }
            }
        }
        else
        {
            
            
            
            for index in (0 ..< metooMaxCount+1).reverse()
            {
                
                let subViews = mScrollView.subviews.flatMap{ $0 as? QueryVolunteerSubView }
                
                for mQuerySubView in subViews
                {
                    if mQuerySubView.isKindOfClass(QueryVolunteerSubView)
                    {
                        if mQuerySubView.mmMetooSelectedArray.count == index
                        {
                            
                            UIView.animateWithDuration(0.5, animations:
                                {
                                    mQuerySubView.frame = CGRectMake(mQuerySubView.frame.origin.x , currentY, mQuerySubView.frame.size.width ,mQuerySubView.frame.size.height)
                            })
                            
                            
                            
                            currentY = currentY + mQuerySubView.frame.size.height + 10
                        }
                        
                        
                    }
                }
            }
        }
        
        
        
        
    }
    
    func delegateVolunteerButtonPressedWithAscending(Isascending: Bool)
    {
        
        var currentY:CGFloat = 10
        
        if Isascending == true
        {
            for index in 0 ..< volunteerMaxCount+1
            {
                
                let subViews = mScrollView.subviews.flatMap{ $0 as? QueryVolunteerSubView }
                
                for mQuerySubView in subViews
                {
                    if mQuerySubView.isKindOfClass(QueryVolunteerSubView)
                    {
                        if mQuerySubView.mVolunteersDetailsArray.count == index
                        {
                            
                            UIView.animateWithDuration(0.5, animations:
                                {
                                    mQuerySubView.frame = CGRectMake(mQuerySubView.frame.origin.x , currentY, mQuerySubView.frame.size.width ,mQuerySubView.frame.size.height)
                            })
                            
                            
                            
                            currentY = currentY + mQuerySubView.frame.size.height + 10
                        }
                        
                        
                    }
                }
            }
        }
        else{
            
            
            for index in (0 ..< volunteerMaxCount+1).reverse()
            {
                
                let subViews = mScrollView.subviews.flatMap{ $0 as? QueryVolunteerSubView }
                
                for mQuerySubView in subViews
                {
                    if mQuerySubView.isKindOfClass(QueryVolunteerSubView)
                    {
                        if mQuerySubView.mVolunteersDetailsArray.count == index
                        {
                            
                            UIView.animateWithDuration(0.5, animations:
                                {
                                    mQuerySubView.frame = CGRectMake(mQuerySubView.frame.origin.x , currentY, mQuerySubView.frame.size.width ,mQuerySubView.frame.size.height)
                            })
                            
                            
                            
                            currentY = currentY + mQuerySubView.frame.size.height + 10
                        }
                        
                        
                    }
                }
            }
            
        }
        
        
        
    }
}