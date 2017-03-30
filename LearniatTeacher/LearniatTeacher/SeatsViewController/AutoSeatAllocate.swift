//
//  AutoSeatAllocate.swift
//  Learniat Teacher
//
//  Created by Deepak MK on 23/03/16.
//  Copyright © 2016 Mindshift. All rights reserved.
//



/*
 
 This class is used to allocate seats alphabetically.
 1. Using grid details create seats by saving all the values of grid to each seat
 2. Fire “GetStudentsSessionInfo” Api to get all students details and assign each students to cell alphabetically
 3. After assigning each student to seats when user press on Done button Fire Api “StudentSeatAssignment” with seat Id with corresponding student Id
 
 */


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
        
        mTopbarImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: (self.view.frame.size.height)/12))
        mTopbarImageView.backgroundColor = topbarColor
        self.view.addSubview(mTopbarImageView)
        mTopbarImageView.isUserInteractionEnabled = true
        mTopbarImageView.isUserInteractionEnabled = true
        
        let  mBackButton = UIButton(frame: CGRect(x: 10, y: 0,width: mTopbarImageView.frame.size.height * 2,height: mTopbarImageView.frame.size.height ))
        mTopbarImageView.addSubview(mBackButton)
        mBackButton.setTitle("Back", for: UIControlState())
        mBackButton.setTitleColor(UIColor.white, for: UIControlState())
        mBackButton.titleLabel?.font = UIFont(name: helveticaMedium, size: 18)
        mBackButton.addTarget(self, action: #selector(AutoSeatAllocate.onBack), for: UIControlEvents.touchUpInside)
        mBackButton.contentHorizontalAlignment = UIControlContentHorizontalAlignment.left
        
        
        let mPreallocateSeats = UILabel(frame: CGRect(x: (mTopbarImageView.frame.size.width - 200)/2, y: 0, width: 200, height: mTopbarImageView.frame.size.height))
        mPreallocateSeats.font = UIFont(name:helveticaRegular, size: 20)
        mPreallocateSeats.text = "Auto allocate seats"
        mTopbarImageView.addSubview(mPreallocateSeats)
        mPreallocateSeats.textColor = UIColor.white
        mPreallocateSeats.textAlignment = .center
        
        
        
        mDonebutton = UIButton(frame: CGRect(x: mTopbarImageView.frame.size.width - (mTopbarImageView.frame.size.height * 2), y: 0,width: mTopbarImageView.frame.size.height * 2,height: mTopbarImageView.frame.size.height ))
        mTopbarImageView.addSubview(mDonebutton)
        mDonebutton.setTitle("Done", for: UIControlState())
        mDonebutton.setTitleColor(UIColor.white, for: UIControlState())
        mDonebutton.titleLabel?.font = UIFont(name: helveticaMedium, size: 18)
        mDonebutton.addTarget(self, action: #selector(AutoSeatAllocate.onDone), for: UIControlEvents.touchUpInside)
        
        
        let  mAutomatically = UIButton(frame: CGRect(x: mDonebutton.frame.origin.x  - (mTopbarImageView.frame.size.height * 2), y: 0,width: mTopbarImageView.frame.size.height * 2,height: mTopbarImageView.frame.size.height ))
        mTopbarImageView.addSubview(mAutomatically)
        mAutomatically.setTitle("Configure grid", for: UIControlState())
        mAutomatically.setTitleColor(whiteColor, for: UIControlState())
        mAutomatically.titleLabel?.font = UIFont(name: helveticaMedium, size: 18)
        mAutomatically.addTarget(self, action: #selector(AutoSeatAllocate.onEditSeat), for: UIControlEvents.touchUpInside)
        
        
        
        
        mGridContainerView.frame = CGRect(x: 10, y: mTopbarImageView.frame.origin.y + mTopbarImageView.frame.size.height + 10 , width: self.view.frame.size.width - 20, height: self.view.frame.size.height - (mTopbarImageView.frame.origin.y + mTopbarImageView.frame.size.height) - 50 )
        self.view.addSubview(mGridContainerView)
        mGridContainerView.backgroundColor = UIColor.clear
        //        mGridContainerView.hidden = true
        
        
        
        let mclassRoomFront = UILabel(frame: CGRect(x: 10,y: self.view.frame.size.height - 40 , width: self.view.frame.size.width,height: 30))
        mclassRoomFront.font = UIFont(name:helveticaRegular, size: 20)
        mclassRoomFront.text = "Classroom front"
        self.view.addSubview(mclassRoomFront)
        mclassRoomFront.textColor = standard_Green
        mclassRoomFront.textAlignment = .center
        
        
        mActivityIndicatore = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
        mActivityIndicatore.frame = CGRect(x: mBackButton.frame.origin.x + mBackButton.frame.size.width + 10, y: 0, width: mTopbarImageView.frame.size.height,height: mTopbarImageView.frame.size.height)
        mTopbarImageView.addSubview(mActivityIndicatore)
        //        mActivityIndicatore.startAnimating()
        
        
        arrangeSeatsWithGridDetails()
        
    }
    
    
    
    func setCurrentSessionDetails(_ sessiondetails: AnyObject, withGridDetails details:AnyObject)
    {
        currentSessionDetails = sessiondetails
        
        currentGridDetails = details
        
        
    }
    
    
    func arrangeSeatsWithGridDetails()
    {
        mActivityIndicatore.stopAnimating()
        mActivityIndicatore.isHidden = true
        
        
        if let Columns = currentGridDetails.object(forKey: "Columns") as? String
        {
            columnValue = Int(Columns)!
        }
        
        if let Rows = currentGridDetails.object(forKey: "Rows") as? String
        {
            rowValue = Int(Rows)!
        }
        
        if let SeatIdList = currentGridDetails.object(forKey: "SeatIdList") as? String
        {
            seatsIdArray =  SeatIdList.components(separatedBy: ",")
        }
        
        if let SeatLabelList = currentGridDetails.object(forKey: "SeatLabelList") as? String
        {
            seatsLableArray =  SeatLabelList.components(separatedBy: ",")
        }
        
        if let SeatsRemoved = currentGridDetails.object(forKey: "SeatsRemoved") as? String
        {
            seatsRemovedArray =  SeatsRemoved.components(separatedBy: ",")
        }
        
        
        var  barWidthvalue  :CGFloat = mGridContainerView.frame.size.width / CGFloat(columnValue)
        
        let barWidthSpace :CGFloat = barWidthvalue * 0.03
        
        barWidthvalue = barWidthvalue * 0.97
        
        var barHeight   :CGFloat = mGridContainerView.frame.size.height / CGFloat(rowValue)
        
        let barHeightSpace:CGFloat = barHeight * 0.03
        
        barHeight = barHeight * 0.97
        
        
        var postionY :CGFloat = barHeightSpace / 2
        
        var totalSeatvalue  = rowValue * columnValue
        
        for _ in 0 ..< rowValue
        {
            var positionX :CGFloat = barWidthSpace / 2
            for _ in 0 ..< columnValue
            {
                if seatsRemovedArray.contains("A\(totalSeatvalue)")
                {
                    
                }
                else
                {
                    let seatView = AutoSeatSubView(frame: CGRect(x: positionX, y: postionY, width: barWidthvalue, height: barHeight))
                    mGridContainerView.addSubview(seatView)
                    seatView.tag  = totalSeatvalue
                    availabletags.append(totalSeatvalue)
                    seatView.backgroundColor = UIColor.clear
                }
                
                positionX = positionX + barWidthvalue + barWidthSpace
                totalSeatvalue = totalSeatvalue - 1
                
            }
            postionY = postionY + barHeight + barHeightSpace
            
        }

        availabletags = availabletags.reversed()
        
        if let sessionid = currentSessionDetails.object(forKey: kSessionId) as? String
        {
            SSTeacherDataSource.sharedDataSource.getStudentsInfoWithSessionId(sessionid, withDelegate: self)
        }
        
        
    }
    
    
    
    // MARK: - datasource delegate Functions
    
    func didGetStudentsInfoWithDetails(_ details: AnyObject)
    {
        if let Status = details.object(forKey: "Status") as? String
        {
            if Status == kSuccessString
            {
                if let _studentsArray = (details.object(forKey: "Students") as AnyObject).object(forKey: "Student") as? NSMutableArray
                {
                    StudentsArray.removeAllObjects()
                    
                    StudentsArray = _studentsArray
                }
            }
        }
       
        for index in 0  ..< StudentsArray.count
        {
            let studentsDict = StudentsArray.object(at: index)
            
            
            if availabletags.count > index
            {
                if let studentImageView  = mGridContainerView.viewWithTag(availabletags[index]) as? AutoSeatSubView
                {
                    if let StudentId = (studentsDict as AnyObject).object(forKey: "StudentId") as? String
                    {
                        if let Name = (studentsDict as AnyObject).object(forKey: "Name") as? String
                        {
                            
                            studentImageView.setSeatIdValue(seatsIdArray[index])
                            studentImageView.setStudentImageWithID(StudentId, WithStudentname: Name)
                        }
                    }
                }
            }
        }
    }
    
    func didGetSeatAssignmentSavedWithDetails(_ details: AnyObject)
    {
        
        
        if let sessionid = currentSessionDetails.object(forKey: kSessionId) as? String
        {
            
            if let RoomName = currentSessionDetails.object(forKey: "RoomName") as? String
            {
                 SSTeacherMessageHandler.sharedMessageHandler.sendSeatingChangedtoRoom(sessionid, withSeatName: "A2", withRoomName: RoomName)
            }
            else
            {
                 SSTeacherMessageHandler.sharedMessageHandler.sendSeatingChangedtoRoom(sessionid, withSeatName: "A2", withRoomName: "")
            }
            
           
        }
        
        
        
        
        performSegue(withIdentifier: "AutoAllocateToSchedule", sender: nil)
    }
    
    func didgetErrorMessage(_ message: String, WithServiceName serviceName: String) {
        
        mDonebutton.isHidden = false
        
    }
    
    // MARK: - Buttons Functions
    
    func onBack()
    {
        self.dismiss(animated: true, completion: nil)
    }
    
    func onEditSeat()
    {
        let gridView = SetupGridview()
        gridView.setCurrentSessionDetails(currentSessionDetails)
        present(gridView, animated: true, completion: nil)

    }
    
    func onDone()
    {
        
        let studentIdArray = NSMutableArray()
        
        let seatsIdArray   = NSMutableArray()
        
        let subViews = mGridContainerView.subviews.flatMap{ $0 as? AutoSeatSubView }
        
        for subview in subViews 
        {
            if subview.isKind(of: AutoSeatSubView.self)
            {
                if subview.getSeatIdAndStudentId().StudentId != "0"
                {
                    seatsIdArray.add(subview.getSeatIdAndStudentId().seatId)
                    studentIdArray.add(subview.getSeatIdAndStudentId().StudentId)
                }
            }
        }
        
        if let sessionid = currentSessionDetails.object(forKey: kSessionId) as? String
        {
            mDonebutton.isHidden = true
             SSTeacherDataSource.sharedDataSource.SaveSeatAssignmentWithStudentsList(studentIdArray.componentsJoined(by: ","), withSeatsIdList: seatsIdArray.componentsJoined(by: ","), withSessionId: sessionid, withDelegate: self)
        }
    }
    
    
    
    
}
