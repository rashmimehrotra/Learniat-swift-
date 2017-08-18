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
    
    
    @objc optional func delegateVolunteerSessionEndedWithRemainingqueries(_ queryIdArray:NSMutableArray)
    
    
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
        
        
        mTopImageView.frame = CGRect(x: 0, y: 0, width: self.frame.size.width, height: 50)
        self.addSubview(mTopImageView)
        mTopImageView.backgroundColor = UIColor.white
        mTopImageView.isUserInteractionEnabled = true
        
        mDoneButton.frame = CGRect(x: self.frame.size.width - 130, y: 0, width: 120, height: mTopImageView.frame.size.height)
        mDoneButton.setTitle("Done", for: UIControlState())
        mTopImageView.addSubview(mDoneButton)
        mDoneButton.setTitleColor(standard_Button, for: UIControlState())
        mDoneButton.contentHorizontalAlignment = UIControlContentHorizontalAlignment.right
        mDoneButton.addTarget(self, action: #selector(SSTeacherVolunteerView.onDoneButton), for: .touchUpInside)
        
        mQueryCountLabel.frame = CGRect(x: 10, y: 0, width: 120, height: mTopImageView.frame.size.height)
        self.addSubview(mQueryCountLabel)
        
        
        
        
        
        let mQuerySubView = VolunteerTopView(frame: CGRect(x: 10 , y: mTopImageView.frame.size.height + mTopImageView.frame.origin.y + 10, width: self.frame.size.width - 20 ,height: 20))
        self.addSubview(mQuerySubView)
        mQuerySubView.setdelegate(self)
        
        
        mScrollView = UIScrollView()
        mScrollView.frame = CGRect(x: 0, y: mQuerySubView.frame.size.height + mQuerySubView.frame.origin.y, width: self.frame.size.width, height: self.frame.size.height - (mQuerySubView.frame.size.height + mQuerySubView.frame.origin.y) )
        self.addSubview(mScrollView)
        

        
//        SSTeacherDataSource.sharedDataSource.GetSRQWithSessionId(SSTeacherDataSource.sharedDataSource.currentLiveSessionId, withDelegate: self)
        
        
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
    
    
    
    func didGetSRQWithDetails(_ details: AnyObject)
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
//              	      }
//                }
//            }
//        }
        
        
        
        
        
        
        
        
    }
    
    
    func addQueriesWithDetails(_ queryDetails:NSMutableArray)
    {
        currentYPosition  = 10
        
        for index in 0  ..< queryDetails.count 
        {
            let queryDict = queryDetails.object(at: index)
            
            let mQuerySubView = QueryVolunteerSubView(frame: CGRect(x: 10 , y: currentYPosition, width: self.frame.size.width - 20 ,height: 80))
            mScrollView.addSubview(mQuerySubView)
            mQuerySubView.setdelegate(self)
           
             mQuerySubView.setQueryWithDetails(queryDict as AnyObject)
            
            if let StudentId = (queryDict as AnyObject).object(forKey: "StudentId") as? String
            {
                 mQuerySubView.setMeTooSelectedStudents(StudentId)
            }

           
            
            
            if let queryText = (queryDict as AnyObject).object(forKey: "QueryText") as? String
            {
                
               mQuerySubView.mQueryLabel.text = "\(index+1). \(queryText)"
            }
            
            
            if let QueryId = (queryDict as AnyObject).object(forKey: "QueryId") as? String
            {
                mQuerySubView.tag = Int(QueryId)!
            }
            
            
            currentYPosition = currentYPosition + mQuerySubView.frame.size.height + 10
            
            
            
        }
        
        mScrollView.contentSize = CGSize(width: 0, height: currentYPosition)
        
        
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
            if mQuerySubView.isKind(of: QueryVolunteerSubView.self)
            {
               
                
                
                if mQuerySubView.mMetooLabel.text! != "0"
                {
                    if let QueryId = mQuerySubView.currentQueryDetails.object(forKey: "QueryId") as? String
                    {
                        mQueryIdList.add(QueryId)
                        remianingQueryIdArray.add(QueryId)
                    }
                    
                     meTooCountList.add(mQuerySubView.mMetooLabel.text!)
                    
                    
                    
                    
                }
                else
                {
                    
                    if let QueryId = mQuerySubView.currentQueryDetails.object(forKey: "QueryId") as? String
                    {
                        if let StudentId = mQuerySubView.currentQueryDetails.object(forKey: "StudentId") as? String
                        {
                            SSTeacherDataSource.sharedDataSource.dismissQuerySelectedForVolunteerWithQueryId(QueryId, withStudentId: StudentId, WithDelegate: self)
                            
                            
                        }
                        
                    }
                }
            }
        }
        
        
        
        let queryIdString = mQueryIdList.componentsJoined(by: ";;;")
        let meTooCountString = meTooCountList.componentsJoined(by: ";;;")
        
        SSTeacherDataSource.sharedDataSource.EndVolunteeringSessionwithQueryId(queryIdString, withMeTooList: meTooCountString, WithDelegate: self)
        
        
        
    }
    
    func didGetVolunteeringEndedWithDetails(_ details: AnyObject)
    {
       
        SSTeacherMessageHandler.sharedMessageHandler.sendEndVolunteeringMessagetoStudent(SSTeacherDataSource.sharedDataSource.currentLiveSessionId)
        
        if delegate().responds(to: #selector(SSTeacherVolunteerViewDelegate.delegateVolunteerSessionEndedWithRemainingqueries(_:)))
        {
            
            
            delegate().delegateVolunteerSessionEndedWithRemainingqueries!(remianingQueryIdArray)
            self.removeFromSuperview()
        }

        
    }
    
    
    func alertView(_ alertView: UIAlertView, clickedButtonAt buttonIndex: Int) {
        
        if buttonIndex == 1
        {
            endVolunteeringSession()
        }
        else
        {
            alertView.dismiss(withClickedButtonIndex: buttonIndex, animated: true)
        }
    }
    
    func didGetQueryRespondedWithDetails(_ details: AnyObject)
    {
        print(details)
    }
    
     // MARK: - Query Volunteer  functions
    
    func volunteerRaiserWithDetails(_ details:AnyObject)
    {
        
        if (details.object(forKey: "QueryId") != nil)
        {
            if let QueryId = details.object(forKey: "QueryId") as? String
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
    
    func metooRaisedWithDetails(_ details:AnyObject)
    {
        if (details.object(forKey: "QueryId") != nil)
        {
            if let QueryId = details.object(forKey: "QueryId") as? String
            {
                if let studentqueryView  = mScrollView.viewWithTag(Int(QueryId)!) as? QueryVolunteerSubView
                {
                   
                    if let StudentId = details.object(forKey: "StudentId") as? String
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
    
    func delegateVolunteerButtonPressedWithVolunteersArray(_ volunteersArray: NSMutableArray, withVolunteerButton volunteerButton: UIButton) {
        
        let buttonPosition :CGPoint = volunteerButton.convert(CGPoint.zero, to: self)
        
        let questionInfoController = VolunteerPopoverController()
        
        
        questionInfoController.addVolunteerWithDetails(volunteersArray)
        
        
        var height :CGFloat = CGFloat((volunteersArray.count * 60))
        
        
        if height > UIScreen.main.bounds.height - 100
        {
            height = UIScreen.main.bounds.height - 100
        }
        
        
        
        questionInfoController.preferredContentSize = CGSize(width: 300,height: height)
        
        questionInfoController.setdelegate(self)
        
        let   classViewPopOverController = UIPopoverController(contentViewController: questionInfoController)
        
        classViewPopOverController.contentSize = CGSize(width: 300,height: height);
        
        classViewPopOverController.delegate = self;
        
        questionInfoController.setPopover(classViewPopOverController)
        
        classViewPopOverController.present(from: CGRect(
            x:buttonPosition.x ,
            y:buttonPosition.y + volunteerButton.frame.size.height / 2,
            width: 1,
            height: 1), in: self, permittedArrowDirections: .right, animated: true)
    }
    // MARK: - Volunteer popover delegate functions
    
    func delegateGiveAnswerPressedWithVolunteerDetails(_ volunteerDetails: AnyObject)
    {
        
        if (volunteerDetails.object(forKey: "QueryId") != nil)
        {
            if let QueryId = volunteerDetails.object(forKey: "QueryId") as? String
            {
                if let studentqueryView  = mScrollView.viewWithTag(Int(QueryId)!) as? QueryVolunteerSubView
                {
                    
                    
                    
                    
                  
                    
                    
                    
                    
                    studentqueryView.backgroundColor = UIColor.white
                    studentqueryView.layer.shadowColor = UIColor.black.cgColor
                    studentqueryView.layer.shadowOffset = CGSize(width: 0, height: 3)
                    studentqueryView.layer.shadowOpacity = 0.3
                    studentqueryView.layer.shadowRadius = 2
                    if let VolunteerId = volunteerDetails.object(forKey: "VolunteerId") as? String
                    {
                         SSTeacherDataSource.sharedDataSource.sendApporoveVolunteerWithVolunteerId(VolunteerId, withstateFlag: "1", WithDelegate: self)
                        
                    }
                    
                   
//                    let buttonPosition :CGPoint = studentqueryView.convertPoint(CGPointZero, toView: self)
                    
                     studentVolunteeringPopoverView = VolunteerAnsweringPopOver(frame:CGRect(x: self.frame.size.width - 350 , y: (self.frame.size.height - 260)/2 , width: 150,height: 260))
                    studentVolunteeringPopoverView.setVolunteerDetails(volunteerDetails)
                    studentVolunteeringPopoverView.setdelegate(self)
                    self.addSubview(studentVolunteeringPopoverView)
                    studentVolunteeringPopoverView.layer.shadowColor = UIColor.black.cgColor
                    studentVolunteeringPopoverView.layer.shadowOffset = CGSize(width: 0, height: 3)
                    studentVolunteeringPopoverView.layer.shadowOpacity = 0.3
                    studentVolunteeringPopoverView.layer.shadowRadius = 2
                    
                    
                    studentqueryView.removeVolunteerWithDetails(volunteerDetails)
                    
                    
                }
            }
        }
        
    }
    
    func delegateStopVolunteeringPressedWithVolunteerDetails(_ volunteerDetails: AnyObject, withThummbsUp ThummbsUp: String, withThummbsDown ThummbsDown: String, withTotalVotes totalVotes: String) {
        
        
        if (volunteerDetails.object(forKey: "QueryId") != nil)
        {
            if let QueryId = volunteerDetails.object(forKey: "QueryId") as? String
            {
                if let studentqueryView  = mScrollView.viewWithTag(Int(QueryId)!) as? QueryVolunteerSubView
                {
                    studentqueryView.backgroundColor = UIColor.clear
                    studentqueryView.layer.shadowColor = UIColor.clear.cgColor
                    studentqueryView.layer.shadowOffset = CGSize(width: 0, height: 0)
                    studentqueryView.layer.shadowRadius = 0

                    if let VolunteerId = volunteerDetails.object(forKey: "VolunteerId") as? String
                    {
                        SSTeacherDataSource.sharedDataSource.StopVolunteeringwithVolunteerId(VolunteerId, withthumbsUp: ThummbsUp, withthumbsDown: ThummbsDown, WithDelegate: self)
                        
                    }
                    
                    
                    
                    var totalPercentage :CGFloat = 0
                    
                    if Int(totalVotes)! >= Int(ThummbsUp)!{
                         totalPercentage = CGFloat(Int(ThummbsUp)!)/CGFloat(Int(totalVotes)!)
                    }
                    else {
                        totalPercentage = 1
                    }
                    
                    if let StudentId = volunteerDetails.object(forKey: "StudentId") as? String {
                        SSTeacherMessageHandler.sharedMessageHandler.sendQRVClosedMessageToRoom(SSTeacherDataSource.sharedDataSource.currentLiveSessionId, withstudentId: StudentId as NSString, withQueryId: QueryId, withVolunterPercentage: "\(totalPercentage)")
                    }
                    studentqueryView.incrementVolunteeredCountwithPercentage(totalPercentage * 100)
                    
                }
            }
        }
        

    }
    
    
    
    
    func didGetNewVoteFromStudent(_ studentId:String, withNewVote newVote:String , withTotalStudents totalStudents:Int)
    {
        if studentVolunteeringPopoverView != nil
        {
            studentVolunteeringPopoverView.sendNewVoteWithStudentId(studentId, withVoteValue: newVote,withTotalStudents: totalStudents)
        }
        
    }
    
    
    func queryUnderstoodMessageFromStudentWithQueryId(_ QueryId:String, withStudentId StudentId:String)
    {
        if let studentqueryView  = mScrollView.viewWithTag(Int(QueryId)!) as? QueryVolunteerSubView
        {
            studentqueryView.removeMeTooWithStudents(StudentId)
        }
    }
    
    
    
     // MARK: - Volunteer Topview delegate functions
    
    
    func delegateQueryButtonPressedWithAscending(_ Isascending: Bool)
    {
        
        
        var currentY:CGFloat = 10
        
        let subViews = mScrollView.subviews.flatMap{ $0 as? QueryVolunteerSubView }
        
        for mQuerySubView in subViews
        {
            if mQuerySubView.isKind(of: QueryVolunteerSubView.self)
            {
                UIView.animate(withDuration: 0.5, animations:
                    {
                        mQuerySubView.frame = CGRect(x: mQuerySubView.frame.origin.x , y: currentY, width: mQuerySubView.frame.size.width ,height: mQuerySubView.frame.size.height)
                })
                
                

                
                    currentY = currentY + mQuerySubView.frame.size.height + 10
                
                
                
            }
        }
    }
    
    func delegateMetooButtonPressedWithAscending(_ Isascending: Bool) {
        
         var currentY:CGFloat = 10
        
        if Isascending == true
        {
            for index in 0 ..< metooMaxCount+1
            {
                
                let subViews = mScrollView.subviews.flatMap{ $0 as? QueryVolunteerSubView }
                
                for mQuerySubView in subViews
                {
                    if mQuerySubView.isKind(of: QueryVolunteerSubView.self)
                    {
                        if mQuerySubView.mmMetooSelectedArray.count == index
                        {
                            
                            UIView.animate(withDuration: 0.5, animations:
                                {
                                    mQuerySubView.frame = CGRect(x: mQuerySubView.frame.origin.x , y: currentY, width: mQuerySubView.frame.size.width ,height: mQuerySubView.frame.size.height)
                            })
                            
                            
                            
                            currentY = currentY + mQuerySubView.frame.size.height + 10
                        }
                        
                        
                    }
                }
            }
        }
        else
        {
            
            
            
            for index in (0 ..< metooMaxCount+1).reversed()
            {
                
                let subViews = mScrollView.subviews.flatMap{ $0 as? QueryVolunteerSubView }
                
                for mQuerySubView in subViews
                {
                    if mQuerySubView.isKind(of: QueryVolunteerSubView.self)
                    {
                        if mQuerySubView.mmMetooSelectedArray.count == index
                        {
                            
                            UIView.animate(withDuration: 0.5, animations:
                                {
                                    mQuerySubView.frame = CGRect(x: mQuerySubView.frame.origin.x , y: currentY, width: mQuerySubView.frame.size.width ,height: mQuerySubView.frame.size.height)
                            })
                            
                            
                            
                            currentY = currentY + mQuerySubView.frame.size.height + 10
                        }
                        
                        
                    }
                }
            }
        }
        
        
        
        
    }
    
    func delegateVolunteerButtonPressedWithAscending(_ Isascending: Bool)
    {
        
        var currentY:CGFloat = 10
        
        if Isascending == true
        {
            for index in 0 ..< volunteerMaxCount+1
            {
                
                let subViews = mScrollView.subviews.flatMap{ $0 as? QueryVolunteerSubView }
                
                for mQuerySubView in subViews
                {
                    if mQuerySubView.isKind(of: QueryVolunteerSubView.self)
                    {
                        if mQuerySubView.mVolunteersDetailsArray.count == index
                        {
                            
                            UIView.animate(withDuration: 0.5, animations:
                                {
                                    mQuerySubView.frame = CGRect(x: mQuerySubView.frame.origin.x , y: currentY, width: mQuerySubView.frame.size.width ,height: mQuerySubView.frame.size.height)
                            })
                            
                            
                            
                            currentY = currentY + mQuerySubView.frame.size.height + 10
                        }
                        
                        
                    }
                }
            }
        }
        else{
            
            
            for index in (0 ..< volunteerMaxCount+1).reversed()
            {
                
                let subViews = mScrollView.subviews.flatMap{ $0 as? QueryVolunteerSubView }
                
                for mQuerySubView in subViews
                {
                    if mQuerySubView.isKind(of: QueryVolunteerSubView.self)
                    {
                        if mQuerySubView.mVolunteersDetailsArray.count == index
                        {
                            
                            UIView.animate(withDuration: 0.5, animations:
                                {
                                    mQuerySubView.frame = CGRect(x: mQuerySubView.frame.origin.x , y: currentY, width: mQuerySubView.frame.size.width ,height: mQuerySubView.frame.size.height)
                            })
                            
                            
                            
                            currentY = currentY + mQuerySubView.frame.size.height + 10
                        }
                        
                        
                    }
                }
            }
            
        }
        
        
        
    }
}
