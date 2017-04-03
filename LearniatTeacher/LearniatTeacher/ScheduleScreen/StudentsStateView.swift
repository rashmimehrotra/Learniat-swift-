//
//  StudentsStateView.swift
//  LearniatTeacher
//
//  Created by Deepak MK on 27/03/17.
//  Copyright © 2017 Mindshift. All rights reserved.
//

import UIKit

@objc protocol StudentsStateViewDelegate
{
    
    @objc optional func delegateEditSeatPressedWithDetails(_ details: AnyObject)
    
    @objc optional func delegateAllocateSeatPressedWithDetails(_ details: AnyObject)

}
class StudentsStateView: UIView,  SSTeacherDataSourceDelegate
{

    
    var mCurrentSessionDetails :AnyObject!
    
    var mClassView  = UIView()
    
    var seatsIdArray                       = [String]()
    
    var StudentsDetailsArray                = NSMutableArray()
    
    var editSeatButton                 = UIButton()
    
    var allocateSeatButton              = UIButton()
    
    
    
    var _delgate: AnyObject!
    
    func setdelegate(_ delegate:AnyObject)
    {
        _delgate = delegate;
    }
    
    func   delegate()->AnyObject
    {
        return _delgate;
    }
    
    
    override init(frame: CGRect) {
        
        super.init(frame:frame)
        
        self.backgroundColor = UIColor.white
        
        
        
        
        let mTopicsViewButton = UIButton(frame: CGRect(x: self.frame.size.width - 120 , y:
            10, width: 100 ,  height: 40))
        self.addSubview(mTopicsViewButton)
        mTopicsViewButton.setTitle("Dismiss", for: UIControlState())
        mTopicsViewButton.setTitleColor(standard_Button, for: UIControlState())
        mTopicsViewButton.contentHorizontalAlignment = UIControlContentHorizontalAlignment.center
        mTopicsViewButton.addTarget(self, action: #selector(StudentsStateView.onDoneButton), for: UIControlEvents.touchUpInside)
        mTopicsViewButton.titleLabel?.font = UIFont(name: helveticaMedium, size: 18)
        mTopicsViewButton.layer.cornerRadius = 5
        mTopicsViewButton.layer.borderWidth = 1
        mTopicsViewButton.layer.borderColor = standard_Button.cgColor
        
        
        
        
        
        
       let  mRefreshButton = UIButton(frame: CGRect(x: mTopicsViewButton.frame.origin.x - (mTopicsViewButton.frame.size.width + 5), y: 10,width: 50,height: 50 ))
        mRefreshButton.setImage(UIImage(named: "refresh.png"), for: UIControlState())
        self.addSubview(mRefreshButton)
        mRefreshButton.contentEdgeInsets = UIEdgeInsetsMake(10, 10, 10, 10);
        mRefreshButton.addTarget(self, action: #selector(StudentsStateView.onRefreshButton), for: UIControlEvents.touchUpInside)

        
        editSeatButton.frame = CGRect(x: 10 , y: 10, width: 100 ,  height: 40)
        editSeatButton.setTitle("Edit seats", for: UIControlState())
        editSeatButton.setTitleColor(standard_Button, for: UIControlState())
        self.addSubview(editSeatButton)
        editSeatButton.titleLabel?.font = UIFont(name: helveticaRegular, size: 18)
        editSeatButton.addTarget(self, action: #selector(StudentsStateView.onEditButton), for: UIControlEvents.touchUpInside)
        editSeatButton.layer.cornerRadius = 5
        editSeatButton.layer.borderWidth = 1
        editSeatButton.layer.borderColor = standard_Button.cgColor
        editSeatButton.isHidden = true
        
        allocateSeatButton.frame = CGRect(x: 10 , y: 10, width: 140 ,  height: 40)
        allocateSeatButton.setTitle("Allocate seats", for: UIControlState())
        allocateSeatButton.layer.cornerRadius = 5
        allocateSeatButton.layer.borderWidth = 1
        allocateSeatButton.layer.borderColor = standard_Red.cgColor
        allocateSeatButton.setTitleColor(standard_Red, for: UIControlState())
        self.addSubview(allocateSeatButton)
        allocateSeatButton.isHidden = true
        allocateSeatButton.titleLabel?.font = UIFont(name: helveticaRegular, size: 18)
        allocateSeatButton.addTarget(self, action: #selector(StudentsStateView.onAllocateButton), for: UIControlEvents.touchUpInside)
        
        
        
        mClassView.frame = CGRect(x: 10, y: mTopicsViewButton.frame.origin.y + mTopicsViewButton.frame.size.height + 5 , width: self.frame.size.width - 20 , height: self.frame.size.height - (mTopicsViewButton.frame.origin.y + mTopicsViewButton.frame.size.height + 20))
        self.addSubview(mClassView)
        mClassView.backgroundColor = UIColor.clear
        mClassView.isUserInteractionEnabled = true
        
        
    }
    
    required init?(coder aDecoder: NSCoder)
    {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func addStudentsWithRoomId(RoomId:String, withDetails details:AnyObject)
    {
        mCurrentSessionDetails = details
       
        let subViews = mClassView.subviews.flatMap{ $0 as? StudentStateViewCell }
        
        for subview in subViews
        {
            if subview.isKind(of: StudentStateViewCell.self)
            {
                subview.removeFromSuperview()
            }
        }
        
        if let StudentsRegistered = details.object(forKey: "StudentsRegistered") as? String
        {
           
            if let PreAllocatedSeats = details.object(forKey: "PreAllocatedSeats") as? String
            {
                
                if let OccupiedSeats = details.object(forKey: "OccupiedSeats") as? String
                {
                    if let SeatsConfigured = details.object(forKey: "SeatsConfigured") as? String
                    {
                        //                        seatsConfiguredLabel.text = SeatsConfigured
                        
                        
                        if Int(StudentsRegistered)! > Int(SeatsConfigured)!
                        {
                            allocateSeatButton.isHidden = true
                            editSeatButton.isHidden = true
                            
                        }
                        else  if Int(StudentsRegistered)! > Int(PreAllocatedSeats)! + Int(OccupiedSeats)!
                        {
                            allocateSeatButton.isHidden = false
                            editSeatButton.isHidden = true
                            
                        }
                        else
                        {
                            allocateSeatButton.isHidden = true
                            editSeatButton.isHidden = false
                            
                        }
                    }
                }
                
            }
            
        
        }
        
        
        SSTeacherDataSource.sharedDataSource.getGridDesignDetails(RoomId, WithDelegate: self)
        
    }
    
    
    func didGetGridDesignWithDetails(_ details: AnyObject)
    {
        
        arrangegridWithDetails(details)
    }
    
    
    func arrangegridWithDetails(_ details:AnyObject)
    {
        var columnValue         = 1
        var rowValue            = 1
        
        //        var seatsLableArray     = [String]()
        var seatsRemovedArray   = [String]()
        
        
        if let Columns = details.object(forKey: "Columns") as? String
        {
            columnValue = Int(Columns)!
        }
        
        if let Rows = details.object(forKey: "Rows") as? String
        {
            rowValue = Int(Rows)!
        }
        
        if let SeatIdList = details.object(forKey: "SeatIdList") as? String
        {
            seatsIdArray =  SeatIdList.components(separatedBy: ",")
        }
        
        //        if let SeatLabelList = details.objectForKey("SeatLabelList") as? String
        //        {
        //            seatsLableArray =  SeatLabelList.componentsSeparatedByString(",")
        //        }
        
        if let SeatsRemoved = details.object(forKey: "SeatsRemoved") as? String
        {
            seatsRemovedArray =  SeatsRemoved.components(separatedBy: ",")
        }
        
        
        var  barWidthvalue  :CGFloat = mClassView.frame.size.width / CGFloat(columnValue)
        
        let barWidthSpace :CGFloat = barWidthvalue * 0.03
        
        barWidthvalue = barWidthvalue * 0.97
        
        var barHeight   :CGFloat = mClassView.frame.size.height / CGFloat(rowValue)
        
        let barHeightSpace:CGFloat = barHeight * 0.03
        
        barHeight = barHeight * 0.97
        
        
        var postionY :CGFloat = barHeightSpace / 2
        
        var totalSeatvalue  = rowValue * columnValue
        
        for columnIndex in 0 ..< rowValue
        {
            
            let backGroundImageView = UIImageView(frame:  CGRect(x: 0, y: postionY - barHeightSpace, width: mClassView.frame.size.width, height: barHeight + barHeightSpace) )
            if (columnIndex%2==0)
            {
                backGroundImageView.backgroundColor = UIColor.white
                
            }
            else
            {
                backGroundImageView.backgroundColor = whiteBackgroundColor
            }
            
            mClassView.addSubview(backGroundImageView)
            
            var positionX :CGFloat = barWidthSpace / 2
            for _ in 0 ..< columnValue
            {
                if seatsRemovedArray.contains("A\(totalSeatvalue)")
                {
                    
                }
                else
                {
                    let seatView = StudentStateViewCell(frame: CGRect(x: positionX, y: postionY, width: barWidthvalue, height: barHeight))
                    seatView.setdelegate(self)
                    mClassView.addSubview(seatView)
                    seatView.tag  = totalSeatvalue
                    
                }
                
                positionX = positionX + barWidthvalue + barWidthSpace
                totalSeatvalue = totalSeatvalue - 1
                
            }
            postionY = postionY + barHeight + barHeightSpace
            
        }
        
        if let sessionId = mCurrentSessionDetails.object(forKey: "SessionId") as? String
        {
            SSTeacherDataSource.sharedDataSource.getStudentsInfoWithSessionId(sessionId, withDelegate: self)
        }
        
        
        
    }
    
    
    
    func didGetStudentsStateWithDetails(_ details: AnyObject) {
        
        print(details)
        
    }
    
    func didGetStudentsInfoWithDetails(_ details: AnyObject) {
        
        print(details)
        arranageSeatsWithDetails(details)
        
        
    }
    
    func arranageSeatsWithDetails(_ details:AnyObject)
    {
        
        
        if let statusString = details.object(forKey: "Status") as? String
        {
            if statusString == kSuccessString
            {
                if let classCheckingVariable = details.object(forKey: "Students") as? NSMutableDictionary
                {
                    if let StudentValue = classCheckingVariable.object(forKey: "Student") as? NSMutableArray
                    {
                        StudentsDetailsArray = StudentValue
                    }
                    else
                    {
                        StudentsDetailsArray.add(classCheckingVariable.object(forKey: "Student"))
                    }
                }
            }
        }
        
        print(StudentsDetailsArray)
        
        
        for indexValue in 0  ..< StudentsDetailsArray.count
        {
            let studentsDict = StudentsDetailsArray.object(at: indexValue)
            
            if var seatlabel = (studentsDict as AnyObject).object(forKey: "SeatLabel") as? String
            {
                seatlabel = seatlabel.replacingOccurrences(of: "A", with: "")
                
                if let studentDeskView  = mClassView.viewWithTag(Int(seatlabel)!) as? StudentStateViewCell
                {
                    studentDeskView.setStudentDetails(details: studentsDict as AnyObject)
                    if let StudentId = (studentsDict as AnyObject).object(forKey: "StudentId") as? String
                    {
                        studentDeskView.tag = Int(StudentId)!
                    }
                }
                
                
            }
        }
        mClassView.isHidden = false
        
    }
    
    
    
    func onDoneButton()
    {
        self.isHidden = true
    }
    
    func onEditButton()
    {
        self.isHidden = true
        
        if delegate().responds(to: #selector(ScheduleDetailViewDelegate.delegateEditSeatPressedWithDetails(_:)))
        {
            delegate().delegateEditSeatPressedWithDetails!(mCurrentSessionDetails)
        }
    }
    
    func onAllocateButton()
    {
        
        self.isHidden = true
        
        if delegate().responds(to: #selector(ScheduleDetailViewDelegate.delegateEditSeatPressedWithDetails(_:)))
        {
            delegate().delegateEditSeatPressedWithDetails!(mCurrentSessionDetails)
        }
        
        
    }
    
    func StudentsStateRefreshedWithStudentId(studentId:String, WithState State:String)
    {
        if let studentDeskView  = mClassView.viewWithTag(Int(studentId)!) as? StudentStateViewCell
        {
            studentDeskView.setStudentState(_StudentState: State)
        }
    }
    

    
    
    func onRefreshButton()
    {
        if let sessionId = mCurrentSessionDetails.object(forKey: "RoomId") as? String
        {
            
            addStudentsWithRoomId(RoomId: sessionId, withDetails: mCurrentSessionDetails)
        }

        
        
    }
    
}
