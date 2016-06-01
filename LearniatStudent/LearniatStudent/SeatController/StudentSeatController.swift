//
//  StudentSeatController.swift
//  LearniatStudent
//
//  Created by Deepak MK on 22/04/16.
//  Copyright © 2016 Mindshift. All rights reserved.
//

import Foundation
class StudentSeatViewController: UIViewController,SSStudentDataSourceDelegate,SSStudentMessageHandlerDelegate,StudentSeatSubViewDelegate,UIPopoverControllerDelegate,SSStudentSchedulePopoverControllerDelegate
{
    
    var sessionDetails               :AnyObject!
    
    var currentGridDetails            :AnyObject!
    
    var mTopbarImageView             :UIImageView           = UIImageView()
    
    var mGridContainerView           :UIView                = UIView()
    
    var mActivityIndicatore          :UIActivityIndicatorView = UIActivityIndicatorView()
    
    var mTeacherImageView: UIImageView!
    
    var mTeacherName: UILabel!
    
    var mNoStudentLabel = UILabel()
    
    var columnValue         = 1
    var rowValue            = 1
    var seatsIdArray        = [String]()
    var seatsLableArray     = [String]()
    var seatsRemovedArray   = [String]()
    
    
    let mClassNameButton  = UIButton()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        
        self.view.backgroundColor = darkBackgroundColor
        
        SSStudentMessageHandler.sharedMessageHandler.setdelegate(self)
        
        mTopbarImageView = UIImageView(frame: CGRectMake(0, 0, self.view.frame.size.width, (self.view.frame.size.height)/12))
        mTopbarImageView.backgroundColor = topbarColor
        self.view.addSubview(mTopbarImageView)
        mTopbarImageView.userInteractionEnabled = true
        mTopbarImageView.userInteractionEnabled = true
        
        
        
        mTeacherImageView = UIImageView(frame: CGRectMake(15, 15, mTopbarImageView.frame.size.height - 20 ,mTopbarImageView.frame.size.height - 20))
        mTeacherImageView.backgroundColor = lightGrayColor
        mTopbarImageView.addSubview(mTeacherImageView)
        mTeacherImageView.layer.masksToBounds = true
        mTeacherImageView.layer.cornerRadius = 2
        
        
        let urlString = NSUserDefaults.standardUserDefaults().objectForKey(k_INI_UserProfileImageURL) as! String
        
        if let checkedUrl = NSURL(string: "\(urlString)/\(SSStudentDataSource.sharedDataSource.currentUserId)_79px.jpg")
        {
            mTeacherImageView.contentMode = .ScaleAspectFit
            mTeacherImageView.downloadImage(checkedUrl, withFolderType: folderType.ProFilePics)
        }
        
        
        
        
        
        mTeacherName = UILabel(frame: CGRectMake(mTeacherImageView.frame.origin.x + mTeacherImageView.frame.size.width + 10, mTeacherImageView.frame.origin.y, 200, 20))
        mTeacherName.font = UIFont(name:helveticaMedium, size: 20)
        mTeacherName.text = SSStudentDataSource.sharedDataSource.currentUserName.capitalizedString
        mTopbarImageView.addSubview(mTeacherName)
        mTeacherName.textColor = UIColor.whiteColor()
        
        

        
        
        let mPreallocateSeats = UILabel(frame: CGRectMake((mTopbarImageView.frame.size.width - 400)/2, 0, 400, mTopbarImageView.frame.size.height))
        mPreallocateSeats.font = UIFont(name:helveticaRegular, size: 20)
       
        mTopbarImageView.addSubview(mPreallocateSeats)
        mPreallocateSeats.textColor = UIColor.whiteColor()
        mPreallocateSeats.textAlignment = .Center
        
        if let ClassName = sessionDetails.objectForKey("ClassName") as? String
        {
             mPreallocateSeats.text = ClassName
        }
        else
        {
             mPreallocateSeats.text = "Preallot seats"
        }
        
        
        
        let remainingHeight = mTopbarImageView.frame.origin.y + mTopbarImageView.frame.size.height + 20
        
        
        mNoStudentLabel.frame = CGRectMake(10, (self.view.frame.size.height - 40)/2, self.view.frame.size.width - 20,40)
        mNoStudentLabel.font = UIFont(name:helveticaMedium, size: 30)
        mNoStudentLabel.text = "Please wait for teacher to ressign seats "
        self.view.addSubview(mNoStudentLabel)
        mNoStudentLabel.textColor = UIColor.whiteColor()
        mNoStudentLabel.textAlignment = .Center
        mNoStudentLabel.hidden = true
        
        
        mGridContainerView.frame = CGRectMake(10, mTopbarImageView.frame.origin.y + mTopbarImageView.frame.size.height + 10  , self.view.frame.size.width - 20, self.view.frame.size.height - remainingHeight )
        self.view.addSubview(mGridContainerView)
        mGridContainerView.backgroundColor = darkBackgroundColor
        //        mGridContainerView.hidden = true
        
        
        
        
        mActivityIndicatore = UIActivityIndicatorView(activityIndicatorStyle: .Gray)
        mActivityIndicatore.frame = CGRectMake((self.view.frame.size.width - 40)/2, (self.view.frame.size.height - 40)/2, 40, 40)
        self.view.addSubview(mActivityIndicatore)
        //        mActivityIndicatore.startAnimating()
        
        if let roomId = sessionDetails.objectForKey("RoomId") as? String
        {
            SSStudentDataSource.sharedDataSource.getGridDesignDetails(roomId, WithDelegate: self)
        }
        
        mClassNameButton.frame = CGRectMake((mTopbarImageView.frame.size.width - mPreallocateSeats.frame.size.width)/2 , 0, mPreallocateSeats.frame.size.width, mTopbarImageView.frame.size.height )
        mTopbarImageView.addSubview(mClassNameButton)
        mClassNameButton.addTarget(self, action: #selector(StudentSeatViewController.onClassButton), forControlEvents: UIControlEvents.TouchUpInside)
        mClassNameButton.backgroundColor = UIColor.clearColor()

        
    }
    
    
    func onClassButton()
    {
        
        
        
        let buttonPosition :CGPoint = mClassNameButton.convertPoint(CGPointZero, toView: self.view)
        
        let remainingHeight = self.view.frame.size.height - (buttonPosition.y  + mClassNameButton.frame.size.height + mClassNameButton.frame.size.height)
        
        
        let questionInfoController = SSStudentSchedulePopoverController()
        
        questionInfoController.setCurrentScreenSize(CGSizeMake(400, remainingHeight))
        questionInfoController.setdelegate(self)
        let   classViewPopOverController = UIPopoverController(contentViewController: questionInfoController)
        
        classViewPopOverController.popoverContentSize = CGSizeMake(400,remainingHeight);
        classViewPopOverController.delegate = self;
        questionInfoController.setPopover(classViewPopOverController)
        classViewPopOverController.presentPopoverFromRect(CGRect(
            x:buttonPosition.x + mClassNameButton.frame.size.width / 2,
            y:buttonPosition.y  + mClassNameButton.frame.size.height,
            width: 1,
            height: 1), inView: self.view, permittedArrowDirections: .Up, animated: true)
        
    }
    
    
    func setCurrentSessionDetails(details: AnyObject)
    {
        sessionDetails = details
        
        
    }
    
    
    
    // MARK: - datasource delegate Functions
    
    func didGetGridDesignWithDetails(details: AnyObject) {
        
        
        currentGridDetails = details
        
        mActivityIndicatore.stopAnimating()
        mActivityIndicatore.hidden = true
        
        
        
        if let Columns = details.objectForKey("Columns") as? String
        {
            columnValue = Int(Columns)!
        }
        
        if let Rows = details.objectForKey("Rows") as? String
        {
            rowValue = Int(Rows)!
        }
        
        if let SeatIdList = details.objectForKey("SeatIdList") as? String
        {
            seatsIdArray =  SeatIdList.componentsSeparatedByString(",")
        }
        
        if let SeatLabelList = details.objectForKey("SeatLabelList") as? String
        {
            seatsLableArray =  SeatLabelList.componentsSeparatedByString(",")
        }
        
        if let SeatsRemoved = details.objectForKey("SeatsRemoved") as? String
        {
            seatsRemovedArray =  SeatsRemoved.componentsSeparatedByString(",")
        }
        
        
        var  barWidthvalue  :CGFloat = mGridContainerView.frame.size.width / CGFloat(columnValue)
        
        let barWidthSpace :CGFloat = barWidthvalue * 0.05
        
        barWidthvalue = barWidthvalue * 0.95
        
        var barHeight   :CGFloat = mGridContainerView.frame.size.height / CGFloat(rowValue)
        
        let barHeightSpace:CGFloat = barHeight * 0.05
        
        barHeight = barHeight * 0.95
        
        
        var postionY :CGFloat = barHeightSpace / 2
        
        var totalSeatvalue  = 1
        
        for columnIndex in 0 ..< rowValue
        {
            
            
            let backGroundImageView = UIImageView(frame:  CGRectMake(0, postionY - barHeightSpace, mGridContainerView.frame.size.width, barHeight + barHeightSpace) )
            if (columnIndex%2==0)
            {
                backGroundImageView.backgroundColor = darkBackgroundColor
                
            }
            else
            {
                backGroundImageView.backgroundColor = lightBackgroundColor
            }
            
            mGridContainerView.addSubview(backGroundImageView)
            
            
            var positionX :CGFloat = barWidthSpace / 2
            for _ in 0 ..< columnValue
            {
                if seatsRemovedArray.contains("A\(totalSeatvalue)")
                {
                    
                }
                else
                {
                    let seatView = StudentSeatSubView(frame: CGRectMake(positionX, postionY, barWidthvalue, barHeight))
                    mGridContainerView.addSubview(seatView)
                    seatView.setdelegate(self)
                    seatView.tag = totalSeatvalue
                    seatView.backgroundColor = UIColor.clearColor()
                }
                
                positionX = positionX + barWidthvalue + barWidthSpace
                totalSeatvalue = totalSeatvalue + 1
                
            }
            postionY = postionY + barHeight + barHeightSpace
            
        }
        
        
        
        if let sessionid = sessionDetails.objectForKey("SessionId") as? String
        {
            SSStudentDataSource.sharedDataSource.getSeatAssignmentofSession(sessionid, withDelegate: self)
        }
    }
    
    
    
    func didGetSeatAssignmentWithDetails(details: AnyObject) {
        
        if let  Status = details.objectForKey("Status") as? String
        {
            if Status == "Success"
            {
                var studentsDetailsArray = NSMutableArray()
                
                let classCheckingVariable = details.objectForKey("Students")!.objectForKey("Student")!
                
                if classCheckingVariable.isKindOfClass(NSMutableArray)
                {
                    studentsDetailsArray = classCheckingVariable as! NSMutableArray
                }
                else
                {
                    studentsDetailsArray.addObject(details.objectForKey("Students")!.objectForKey("Student")!)
                    
                }
                
                for index in 0 ..< studentsDetailsArray.count
                {
                    let studentsDetails = studentsDetailsArray.objectAtIndex(index)
                    
                    
                    if var SeatLabel = studentsDetails.objectForKey("SeatLabel") as? String
                    {
                        SeatLabel =  SeatLabel.stringByReplacingOccurrencesOfString("A", withString: "")
                        
                        if let studentDeskView  = mGridContainerView.viewWithTag(Int(SeatLabel)!) as? StudentSeatSubView
                        {
                            
                            
                            studentDeskView.setStudentDetails(studentsDetails)
                            
                        }
                        
                    }
                    
                    
                    
                }
                mGridContainerView.hidden = false
                mNoStudentLabel.hidden = true

            }
            else
            {
                mGridContainerView.hidden = true
                mNoStudentLabel.hidden = false
            }
        }
        
        
        
        
    }
    
    // MARK: - student Message handler 
    
    func smhDidGetSeatingChangedWithDetails(details: AnyObject)
    {
        
        
        for view:AnyObject in mGridContainerView.subviews
        {
            if view.isKindOfClass(StudentSeatSubView)
            {
                view.removeFromSuperview()
            }
        }
        
        if let roomId = sessionDetails.objectForKey("RoomId") as? String
        {
            SSStudentDataSource.sharedDataSource.getGridDesignDetails(roomId, WithDelegate: self)
        }

        
    }
    
    
    // MARK: - seat view delegate handler
    
    func delegateStudentTileTouched()
    {
        let ClassViewController = StudentClassViewController()
        ClassViewController.setCurrentSessionDetails(sessionDetails)
        self.presentViewController(ClassViewController, animated: true, completion: nil)
    }
    
    
    func onBack()
    {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    func smhDidGetSessionEndMessageWithDetails(details: AnyObject)
    {
        let storyboard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let preallotController : SSStudentScheduleViewController = storyboard.instantiateViewControllerWithIdentifier("TeacherScheduleViewController") as! SSStudentScheduleViewController
        self.presentViewController(preallotController, animated: true, completion: nil)
    }
   
    // MARK: - Leave class delegate handler
    
    func delegateSessionEnded()
    {
        let storyboard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let preallotController : SSStudentScheduleViewController = storyboard.instantiateViewControllerWithIdentifier("TeacherScheduleViewController") as! SSStudentScheduleViewController
        self.presentViewController(preallotController, animated: true, completion: nil)
        
    }
    
}