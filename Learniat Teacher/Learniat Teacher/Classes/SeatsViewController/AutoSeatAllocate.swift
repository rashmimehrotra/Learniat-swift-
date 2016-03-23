//
//  AutoSeatAllocate.swift
//  Learniat Teacher
//
//  Created by Deepak MK on 23/03/16.
//  Copyright © 2016 Mindshift. All rights reserved.
//

import Foundation
class AutoSeatAllocate: UIViewController,SSTeacherDataSourceDelegate
{
    
    var currentSessionDetails               :AnyObject!
    
    var currentGridDetails                  :AnyObject!
    
    var mTopbarImageView             :UIImageView           = UIImageView()
    
    var mGridContainerView           :UIView                = UIView()
    
    var mActivityIndicatore          :UIActivityIndicatorView = UIActivityIndicatorView()
    
    var mDonebutton                 = UIButton()
    
    
    var columnValue         = 1
    var rowValue            = 1
    var seatsIdArray        = [String]()
    var seatsLableArray     = [String]()
    var seatsRemovedArray   = [String]()
    
    var availabletags       = [Int]()
    var StudentsArray       = NSMutableArray()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        
        self.view.backgroundColor = whiteBackgroundColor
        
        mTopbarImageView = UIImageView(frame: CGRectMake(0, 0, self.view.frame.size.width, (self.view.frame.size.height)/12))
        mTopbarImageView.backgroundColor = topbarColor
        self.view.addSubview(mTopbarImageView)
        mTopbarImageView.userInteractionEnabled = true
        mTopbarImageView.userInteractionEnabled = true
        
        let  mBackButton = UIButton(frame: CGRectMake(10, 0,mTopbarImageView.frame.size.height * 2,mTopbarImageView.frame.size.height ))
        mTopbarImageView.addSubview(mBackButton)
        mBackButton.setTitle("Back", forState: .Normal)
        mBackButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        mBackButton.titleLabel?.font = UIFont(name: helveticaMedium, size: 18)
        mBackButton.addTarget(self, action: "onBack", forControlEvents: UIControlEvents.TouchUpInside)
        mBackButton.contentHorizontalAlignment = UIControlContentHorizontalAlignment.Left
        
        
        let mPreallocateSeats = UILabel(frame: CGRectMake((mTopbarImageView.frame.size.width - 200)/2, 0, 200, mTopbarImageView.frame.size.height))
        mPreallocateSeats.font = UIFont(name:helveticaRegular, size: 20)
        mPreallocateSeats.text = "Auto allocate seats"
        mTopbarImageView.addSubview(mPreallocateSeats)
        mPreallocateSeats.textColor = UIColor.whiteColor()
        mPreallocateSeats.textAlignment = .Center
        
        
        
        mDonebutton = UIButton(frame: CGRectMake(mTopbarImageView.frame.size.width - (mTopbarImageView.frame.size.height * 2), 0,mTopbarImageView.frame.size.height * 2,mTopbarImageView.frame.size.height ))
        mTopbarImageView.addSubview(mDonebutton)
        mDonebutton.setTitle("Done", forState: .Normal)
        mDonebutton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        mDonebutton.titleLabel?.font = UIFont(name: helveticaMedium, size: 18)
        mDonebutton.addTarget(self, action: "onDone", forControlEvents: UIControlEvents.TouchUpInside)
        
        
        let  mAutomatically = UIButton(frame: CGRectMake(mDonebutton.frame.origin.x  - (mTopbarImageView.frame.size.height * 2), 0,mTopbarImageView.frame.size.height * 2,mTopbarImageView.frame.size.height ))
        mTopbarImageView.addSubview(mAutomatically)
        mAutomatically.setTitle("Edit seats", forState: .Normal)
        mAutomatically.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        mAutomatically.titleLabel?.font = UIFont(name: helveticaMedium, size: 18)
        mAutomatically.addTarget(self, action: "onEditSeat", forControlEvents: UIControlEvents.TouchUpInside)
        
        
        
        
        mGridContainerView.frame = CGRectMake(10, mTopbarImageView.frame.origin.y + mTopbarImageView.frame.size.height + 10 , self.view.frame.size.width - 20, self.view.frame.size.height - (mTopbarImageView.frame.origin.y + mTopbarImageView.frame.size.height) - 50 )
        self.view.addSubview(mGridContainerView)
        mGridContainerView.backgroundColor = UIColor.clearColor()
        //        mGridContainerView.hidden = true
        
        
        
        let mclassRoomFront = UILabel(frame: CGRectMake(10,self.view.frame.size.height - 40 , self.view.frame.size.width,30))
        mclassRoomFront.font = UIFont(name:helveticaRegular, size: 20)
        mclassRoomFront.text = "Classroom front"
        self.view.addSubview(mclassRoomFront)
        mclassRoomFront.textColor = standard_Green
        mclassRoomFront.textAlignment = .Center
        
        
        mActivityIndicatore = UIActivityIndicatorView(activityIndicatorStyle: .WhiteLarge)
        mActivityIndicatore.frame = CGRectMake(mBackButton.frame.origin.x + mBackButton.frame.size.width + 10, 0, mTopbarImageView.frame.size.height,mTopbarImageView.frame.size.height)
        mTopbarImageView.addSubview(mActivityIndicatore)
        //        mActivityIndicatore.startAnimating()
        
        
        arrangeSeatsWithGridDetails()
        
    }
    
    
    
    func setCurrentSessionDetails(sessiondetails: AnyObject, withGridDetails details:AnyObject)
    {
        currentSessionDetails = sessiondetails
        
        currentGridDetails = details
        
        
    }
    
    
    func arrangeSeatsWithGridDetails()
    {
        mActivityIndicatore.stopAnimating()
        mActivityIndicatore.hidden = true
        
        
        if let Columns = currentGridDetails.objectForKey("Columns") as? String
        {
            columnValue = Int(Columns)!
        }
        
        if let Rows = currentGridDetails.objectForKey("Rows") as? String
        {
            rowValue = Int(Rows)!
        }
        
        if let SeatIdList = currentGridDetails.objectForKey("SeatIdList") as? String
        {
            seatsIdArray =  SeatIdList.componentsSeparatedByString(",")
        }
        
        if let SeatLabelList = currentGridDetails.objectForKey("SeatLabelList") as? String
        {
            seatsLableArray =  SeatLabelList.componentsSeparatedByString(",")
        }
        
        if let SeatsRemoved = currentGridDetails.objectForKey("SeatsRemoved") as? String
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
        
        var totalSeatvalue  = rowValue * columnValue
        
        
        var indexValue = 0
        
        for var columnIndex = 0; columnIndex < rowValue ; columnIndex++
        {
            
            var positionX :CGFloat = barWidthSpace / 2
            for var rowIndex = 0; rowIndex < columnValue ; rowIndex++
            {
                if seatsRemovedArray.contains("A\(totalSeatvalue)")
                {
                    
                }
                else
                {
                    let seatView = AutoSeatSubView(frame: CGRectMake(positionX, postionY, barWidthvalue, barHeight))
                    mGridContainerView.addSubview(seatView)
                    seatView.tag = totalSeatvalue
                    availabletags.append(totalSeatvalue)
                    seatView.backgroundColor = UIColor.clearColor()
                    seatView.setSeatIdValue(seatsIdArray[indexValue])
                    indexValue = indexValue + 1
                }
                
                positionX = positionX + barWidthvalue + barWidthSpace
                totalSeatvalue = totalSeatvalue - 1
                
            }
            postionY = postionY + barHeight + barHeightSpace
            
        }
        
        availabletags = availabletags.reverse()
        
        if let sessionid = currentSessionDetails.objectForKey(kSessionId) as? String
        {
            SSTeacherDataSource.sharedDataSource.getStudentsInfoWithSessionId(sessionid, withDelegate: self)
        }
        
        
    }
    
    
    
    // MARK: - datasource delegate Functions
    
    func didGetStudentsInfoWithDetails(details: AnyObject)
    {
        if let Status = details.objectForKey("Status") as? String
        {
            if Status == kSuccessString
            {
                if let _studentsArray = details.objectForKey("Students")?.objectForKey("Student") as? NSMutableArray
                {
                    StudentsArray.removeAllObjects()
                    
                    StudentsArray = _studentsArray
                }
            }
        }
        
        
        
        
        for var index = 0 ; index < StudentsArray.count ; index++
        {
            let studentsDict = StudentsArray.objectAtIndex(index)
            
            
            if availabletags.count > index
            {
                if let studentImageView  = mGridContainerView.viewWithTag(availabletags[index]) as? AutoSeatSubView
                {
                    if let StudentId = studentsDict.objectForKey("StudentId") as? String
                    {
                        if let Name = studentsDict.objectForKey("Name") as? String
                        {
                            studentImageView.setStudentImageWithID(StudentId, WithStudentname: Name)
                        }
                    }
                }
            }
        }
    }
    
    func didGetSeatAssignmentSavedWithDetails(details: AnyObject)
    {
        performSegueWithIdentifier("AutoAllocateToSchedule", sender: nil)
    }
    
    func didgetErrorMessage(message: String, WithServiceName serviceName: String) {
        
        mDonebutton.hidden = false
        
    }
    
    // MARK: - Buttons Functions
    
    func onBack()
    {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func onEditSeat()
    {
        
    }
    
    func onDone()
    {
        
        let studentIdArray = NSMutableArray()
        
        let seatsIdArray   = NSMutableArray()
        
        let subViews = mGridContainerView.subviews.flatMap{ $0 as? AutoSeatSubView }
        
        for subview in subViews 
        {
            if subview.isKindOfClass(AutoSeatSubView)
            {
                if subview.getSeatIdAndStudentId().StudentId != "0"
                {
                    seatsIdArray.addObject(subview.getSeatIdAndStudentId().seatId)
                    studentIdArray.addObject(subview.getSeatIdAndStudentId().StudentId)
                }
            }
        }
        
        if let sessionid = currentSessionDetails.objectForKey(kSessionId) as? String
        {
            mDonebutton.hidden = true
             SSTeacherDataSource.sharedDataSource.SaveSeatAssignmentWithStudentsList(studentIdArray.componentsJoinedByString(","), withSeatsIdList: seatsIdArray.componentsJoinedByString(","), withSessionId: sessionid, withDelegate: self)
        }
    }
    
    
    
    
}