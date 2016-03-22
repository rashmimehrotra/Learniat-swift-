//
// ScheduleDetailView.swift
//  Learniat Teacher
//
//  Created by Deepak MK on 22/03/16.
//  Copyright © 2016 Mindshift. All rights reserved.
//

import Foundation
class ScheduleDetailView: UIView
{
    
    
    
    var mClassnameLabel = UILabel()
    
    
    var mTimelabel = UILabel()
    
    var mRoomNameLabel = UILabel()
    
    
    var loadingView = UIView()
    
    var seatsConfiguredLabel        = UILabel()
    
    var studentsRegistedlabel       = UILabel()
    
    var preallocatedSeatslabel      = UILabel()
    
    var topicsConfiguredLabel       = UILabel()
    
    var questionConfiguredLabel     = UILabel()
    
    var sessionDetails    :AnyObject!
    
    var overDueTimer                    = NSTimer()
    
    var nextSessionTimer                = NSTimer()
    
    
    override init(frame: CGRect) {
        
        super.init(frame:frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    
    func addAllSubView ()
    {
        let topBar = UIView(frame: CGRectMake(0,0,self.frame.size.width,40))
        topBar.backgroundColor = lightGrayTopBar
        self.addSubview(topBar)
        
        
        let classDetailsLabel = UILabel(frame: CGRectMake((self.frame.size.width - 200)/2, 0 , 200 , 40))
        classDetailsLabel.text = "Class details"
        topBar.addSubview(classDetailsLabel)
        classDetailsLabel.textAlignment = .Center
        
        
        let doneButton = UIButton(frame: CGRectMake(self.frame.size.width - (self.frame.size.width/2 - 10), 0, self.frame.size.width/2 - 20, 40))
        topBar.addSubview(doneButton)
        doneButton.setTitle("Done", forState: .Normal)
        doneButton.setTitleColor(standard_Button, forState: .Normal)
        doneButton.contentHorizontalAlignment = UIControlContentHorizontalAlignment.Right
         doneButton.addTarget(self, action: "onDoneButton", forControlEvents: UIControlEvents.TouchUpInside)
        
        mClassnameLabel.frame = CGRectMake(10, topBar.frame.origin.y + topBar.frame.size.height + 10, self.frame.size.width/2 - 20, 30)
        self.addSubview(mClassnameLabel)
        mClassnameLabel.textAlignment = .Left
        mClassnameLabel.font = UIFont(name: helveticaMedium, size: 18)
        mClassnameLabel.text = "B - ||| - Biology"
        mClassnameLabel.lineBreakMode = .ByTruncatingMiddle
        
        
        mRoomNameLabel.frame = CGRectMake(10, mClassnameLabel.frame.origin.y + mClassnameLabel.frame.size.height + 10, self.frame.size.width/2 - 20, 20)
        self.addSubview(mRoomNameLabel)
        mRoomNameLabel.textAlignment = .Left
        mRoomNameLabel.font = UIFont(name: helveticaRegular, size: 12)
        mRoomNameLabel.text = "Room: 14"
        mRoomNameLabel.lineBreakMode = .ByTruncatingMiddle
        mRoomNameLabel.textColor = standard_TextGrey
        
        
        mTimelabel.frame = CGRectMake(self.frame.size.width - (self.frame.size.width/2 - 10), topBar.frame.origin.y + topBar.frame.size.height + 10, self.frame.size.width/2 - 20, 30)
        self.addSubview(mTimelabel)
        mTimelabel.textAlignment = .Right
        mTimelabel.font = UIFont(name: helveticaMedium, size: 18)
        mTimelabel.text = "Starts: 00:00:45"
        
        loadingView = UIView(frame: CGRectMake(0 ,topBar.frame.origin.y + topBar.frame.size.height, self.frame.size.width,self.frame.size.height - topBar.frame.origin.y + topBar.frame.size.height ))
        self.addSubview(loadingView)
        loadingView.hidden = true
        
        
        let LineView = UIView(frame: CGRectMake(0 ,mRoomNameLabel.frame.origin.y + mRoomNameLabel.frame.size.height + 10, self.frame.size.width,1 ))
        LineView.backgroundColor = LineGrayColor
        
        loadingView.addSubview(LineView)
        
       let mSeatsConfigured = UILabel(frame: CGRectMake(10, LineView.frame.origin.y + LineView.frame.size.height , self.frame.size.width/2 - 20, 40))
        loadingView.addSubview(mSeatsConfigured)
        mSeatsConfigured.textAlignment = .Left
        mSeatsConfigured.font = UIFont(name: helveticaRegular, size: 18)
        mSeatsConfigured.text = "Seats configured"
        mSeatsConfigured.lineBreakMode = .ByTruncatingMiddle
        
        
        
        
        seatsConfiguredLabel.frame = CGRectMake(self.frame.size.width - (self.frame.size.width/2 - 10), mSeatsConfigured.frame.origin.y , self.frame.size.width/2 - 20, mSeatsConfigured.frame.size.height)
        loadingView.addSubview(seatsConfiguredLabel)
        seatsConfiguredLabel.textAlignment = .Right
        seatsConfiguredLabel.font = UIFont(name: helveticaRegular, size: 18)
        seatsConfiguredLabel.text = "32"
        
        
        
        
        
        
        let LineView2 = UIView(frame: CGRectMake(0 ,mSeatsConfigured.frame.origin.y + mSeatsConfigured.frame.size.height, self.frame.size.width,1 ))
        LineView2.backgroundColor = LineGrayColor
        
        loadingView.addSubview(LineView2)
        
        
        
        let mStudentsRegistered = UILabel(frame: CGRectMake(10, LineView2.frame.origin.y + LineView2.frame.size.height, self.frame.size.width/2 - 20, 40))
        loadingView.addSubview(mStudentsRegistered)
        mStudentsRegistered.textAlignment = .Left
        mStudentsRegistered.font = UIFont(name: helveticaRegular, size: 18)
        mStudentsRegistered.text = "Students registered"
        mStudentsRegistered.lineBreakMode = .ByTruncatingMiddle
        
        
        studentsRegistedlabel.frame = CGRectMake(self.frame.size.width - (self.frame.size.width/2 - 10), mStudentsRegistered.frame.origin.y , self.frame.size.width/2 - 20, mStudentsRegistered.frame.size.height)
        loadingView.addSubview(studentsRegistedlabel)
        studentsRegistedlabel.textAlignment = .Right
        studentsRegistedlabel.font = UIFont(name: helveticaRegular, size: 18)
        studentsRegistedlabel.text = "24"
        
        
        
        let LineView3 = UIView(frame: CGRectMake(0 ,mStudentsRegistered.frame.origin.y + mStudentsRegistered.frame.size.height, self.frame.size.width,1 ))
        LineView3.backgroundColor = LineGrayColor
        
        loadingView.addSubview(LineView3)
        

        let mPreAllocatedSeats = UILabel(frame: CGRectMake(10, LineView3.frame.origin.y + LineView3.frame.size.height, self.frame.size.width/2 - 20, 40))
        loadingView.addSubview(mPreAllocatedSeats)
        mPreAllocatedSeats.textAlignment = .Left
        mPreAllocatedSeats.font = UIFont(name: helveticaRegular, size: 18)
        mPreAllocatedSeats.text = "Preallocated seats"
        mPreAllocatedSeats.lineBreakMode = .ByTruncatingMiddle
        
        
        
        preallocatedSeatslabel.frame = CGRectMake(self.frame.size.width - (self.frame.size.width/4 - 10), mPreAllocatedSeats.frame.origin.y , self.frame.size.width/4 - 20, mPreAllocatedSeats.frame.size.height)
        loadingView.addSubview(preallocatedSeatslabel)
        preallocatedSeatslabel.textAlignment = .Right
        preallocatedSeatslabel.font = UIFont(name: helveticaRegular, size: 18)
        preallocatedSeatslabel.text = "16 of 24"
        
        
        let LineView4 = UIView(frame: CGRectMake(0 ,mPreAllocatedSeats.frame.origin.y + mPreAllocatedSeats.frame.size.height, self.frame.size.width,1 ))
        LineView4.backgroundColor = LineGrayColor
        
        loadingView.addSubview(LineView4)
        
        
        let mTopicsConfigured = UILabel(frame: CGRectMake(10, LineView4.frame.origin.y + LineView4.frame.size.height, self.frame.size.width/2 - 20, 40))
        loadingView.addSubview(mTopicsConfigured)
        mTopicsConfigured.textAlignment = .Left
        mTopicsConfigured.font = UIFont(name: helveticaRegular, size: 18)
        mTopicsConfigured.text = "Topics configured"
        mTopicsConfigured.lineBreakMode = .ByTruncatingMiddle
        
        
        topicsConfiguredLabel.frame = CGRectMake(self.frame.size.width - (self.frame.size.width/2 - 10), mTopicsConfigured.frame.origin.y , self.frame.size.width/2 - 20, mTopicsConfigured.frame.size.height)
        loadingView.addSubview(topicsConfiguredLabel)
        topicsConfiguredLabel.textAlignment = .Right
        topicsConfiguredLabel.font = UIFont(name: helveticaRegular, size: 18)
        topicsConfiguredLabel.text = "5 of 200"
        
        
        let LineView5 = UIView(frame: CGRectMake(0 ,mTopicsConfigured.frame.origin.y + mTopicsConfigured.frame.size.height, self.frame.size.width,1 ))
        LineView5.backgroundColor = LineGrayColor
        
        loadingView.addSubview(LineView5)
        
        
        let mQuestionConfigured = UILabel(frame: CGRectMake(10, LineView5.frame.origin.y + LineView5.frame.size.height, self.frame.size.width/2 - 20, 40))
        loadingView.addSubview(mQuestionConfigured)
        mQuestionConfigured.textAlignment = .Left
        mQuestionConfigured.font = UIFont(name: helveticaRegular, size: 18)
        mQuestionConfigured.text = "Questions configured"
        mQuestionConfigured.lineBreakMode = .ByTruncatingMiddle
        
        
        
        questionConfiguredLabel.frame = CGRectMake(self.frame.size.width - (self.frame.size.width/2 - 10), mQuestionConfigured.frame.origin.y , self.frame.size.width/2 - 20, mQuestionConfigured.frame.size.height)
        loadingView.addSubview(questionConfiguredLabel)
        questionConfiguredLabel.textAlignment = .Right
        questionConfiguredLabel.font = UIFont(name: helveticaRegular, size: 18)
        questionConfiguredLabel.text = "16 of 24"
        
        
        let LineView6 = UIView(frame: CGRectMake(0 ,mQuestionConfigured.frame.origin.y + mQuestionConfigured.frame.size.height, self.frame.size.width,1 ))
        LineView6.backgroundColor = LineGrayColor
        
        loadingView.addSubview(LineView6)
    }
    
    
    
    
    func setClassname(classname:String)
    {
        mClassnameLabel.text = classname
        loadingView.hidden = true
        
        overDueTimer.invalidate()
        
        nextSessionTimer.invalidate()
    }
    
    func setcurrentViewDetails(details:AnyObject)
    {
        print(details)
        
        
         sessionDetails = details
        
        
        loadingView.hidden = false
        
        if let SeatsConfigured = details.objectForKey("SeatsConfigured") as? String
        {
            seatsConfiguredLabel.text = SeatsConfigured
        }
        
        if let StudentsRegistered = details.objectForKey("StudentsRegistered") as? String
        {
            studentsRegistedlabel.text = StudentsRegistered
            
            
            if let PreAllocatedSeats = details.objectForKey("PreAllocatedSeats") as? String
            {
                if let OccupiedSeats = details.objectForKey("OccupiedSeats") as? String
                {
                    let totalSesats = Int(PreAllocatedSeats)! + Int(OccupiedSeats)!
                    
                    preallocatedSeatslabel.text = "\(totalSesats) of \(StudentsRegistered)"
                }
            }
        }
        
        if let TopicsConfigured = details.objectForKey("TopicsConfigured") as? String
        {
            topicsConfiguredLabel.text = TopicsConfigured
        }
        
        if let QuestionsConfigured = details.objectForKey("QuestionsConfigured") as? String
        {
            questionConfiguredLabel.text = QuestionsConfigured
        }

        
        
        
        
        
        
        
        
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let currentDate = NSDate()
        let isgreatervalue :Bool ;
        
        isgreatervalue = currentDate.isGreaterThanDate(dateFormatter.dateFromString(details.objectForKey("StartTime") as! String)!)
        
        let  isEqualValue = currentDate.isEqualToDate(dateFormatter.dateFromString(details.objectForKey("StartTime") as! String)!)
        
        if isgreatervalue == true || isEqualValue == true
        {
            
            
            var _string :String = ""
            let currentDate = NSDate()
            _string = _string.stringFromTimeInterval(currentDate.timeIntervalSinceDate(dateFormatter.dateFromString((details.objectForKey("StartTime") as! String))!)).fullString
            
            mTimelabel.text = "Overdue: \(_string)"
            overDueTimer.invalidate()
            nextSessionTimer.invalidate()
            
            overDueTimer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: "updateOverdueSession", userInfo: nil, repeats: true)

           

        }
        else
        {
            var _string :String = ""
            let currentDate = NSDate()
            _string = _string.stringFromTimeInterval(dateFormatter.dateFromString((details.objectForKey("StartTime") as! String))!.timeIntervalSinceDate(currentDate)).fullString
            
            mTimelabel.text = "Starts: \(_string)"
            
            nextSessionTimer.invalidate()
            nextSessionTimer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: "updateNextSession", userInfo: nil, repeats: true)

        }
        
    }
    
    func onDoneButton()
    {
        self.hidden = true
        
        overDueTimer.invalidate()
        nextSessionTimer.invalidate()
    }
    
    
    func updateOverdueSession()
    {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        var _string :String = ""
        let currentDate = NSDate()
        _string = _string.stringFromTimeInterval(currentDate.timeIntervalSinceDate(dateFormatter.dateFromString((sessionDetails.objectForKey("StartTime") as! String))!)).fullString
        
        mTimelabel.text = "Overdue: \(_string)"
    }
    
    
    func updateNextSession()
    {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        var _string :String = ""
        let currentDate = NSDate()
        _string = _string.stringFromTimeInterval(dateFormatter.dateFromString((sessionDetails.objectForKey("StartTime") as! String))!.timeIntervalSinceDate(currentDate)).fullString
        
        mTimelabel.text = "Starts in about: \(_string)"
        
    }
    
}