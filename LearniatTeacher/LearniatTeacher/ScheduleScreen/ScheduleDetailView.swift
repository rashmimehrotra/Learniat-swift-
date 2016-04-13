//
// ScheduleDetailView.swift
//  Learniat Teacher
//
//  Created by Deepak MK on 22/03/16.
//  Copyright © 2016 Mindshift. All rights reserved.
//

import Foundation


@objc protocol ScheduleDetailViewDelegate
{
    
    optional func delegateAllocateSeatPressedWithDetails(details: AnyObject)
    
    optional func delegateEditSeatPressedWithDetails(details: AnyObject)
    
    optional func delegateConfigureGridPressedWithDetails(details: AnyObject)
    
    optional func delegateCancelClassPressedWithDetails(details: AnyObject)
    
    optional func delegateOpenClassPressedWithDetails(details: AnyObject)
    
    optional func delegateBeginClassPressedWithDetails(details: AnyObject)
    
     optional func delegateResetButtonPressedWithDetails(details: AnyObject)
    
}



class ScheduleDetailView: UIView,SSTeacherDataSourceDelegate
{
    
    var _delgate: AnyObject!
    
    var mClassnameLabel = UILabel()
    
    var mTimelabel = UILabel()
    
    var mRoomNameLabel = UILabel()
    
    var loadingView = UIView()
    
    var seatsConfiguredLabel        = UILabel()
    
    var studentsRegistedlabel       = UILabel()
    
    var preallocatedSeatslabel      = UILabel()
    
    var topicsConfiguredLabel       = UILabel()
    
    var questionConfiguredLabel     = UILabel()
    
    var scheduleSummaryDetails      :AnyObject!
    
    var currentSessionDetails       :AnyObject!
    
    var overDueTimer                    = NSTimer()
    
    var nextSessionTimer                = NSTimer()
    
    
    var openClassButton                 = UIButton()
    
    var beginClassButton                = UIButton()
    
    
    var editSeatButton                  = UIButton()
    
    var allocateSeatButton              = UIButton()
    
    var configureGrid                   = UIButton()

    var cancelClassButton               = UIButton()
    
    var resetButton                     = UIButton()
    
    var mJoinStudentProgressBar         = DonutChartView()
    
    var mJoinedPercentageLabel            = UILabel()
    
    var mJoinedStudentsLabel            = UILabel()
    
    override init(frame: CGRect) {
        
        super.init(frame:frame)
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
        doneButton.titleLabel?.font = UIFont(name: helveticaMedium, size: 18)
        
        
        
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
        
        loadingView = UIView(frame: CGRectMake(0 ,mRoomNameLabel.frame.origin.y + mRoomNameLabel.frame.size.height, self.frame.size.width,self.frame.size.height - (mRoomNameLabel.frame.origin.y + mRoomNameLabel.frame.size.height)))
        self.addSubview(loadingView)
        loadingView.hidden = true
        
        
        let LineView = UIView(frame: CGRectMake(0 ,10, self.frame.size.width,1 ))
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
        
        
        
        
        resetButton = UIButton(frame: CGRectMake(preallocatedSeatslabel.frame.origin.x - (self.frame.size.width/4), mPreAllocatedSeats.frame.origin.y, self.frame.size.width/4 ,  mPreAllocatedSeats.frame.size.height))
        loadingView.addSubview(resetButton)
        resetButton.setTitle("Reset", forState: .Normal)
        resetButton.setTitleColor(standard_Button, forState: .Normal)
        resetButton.contentHorizontalAlignment = UIControlContentHorizontalAlignment.Right
        resetButton.addTarget(self, action: "onReset", forControlEvents: UIControlEvents.TouchUpInside)
        resetButton.titleLabel?.font = UIFont(name: helveticaMedium, size: 18)
        
        
        
        
        
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
        
        
        
        
        
        
        
        mJoinStudentProgressBar.frame = CGRectMake((loadingView.frame.size.width - (loadingView.frame.size.width / 1.8) ) /  2 , LineView6.frame.origin.y + 20 , (loadingView.frame.size.width / 1.8), (loadingView.frame.size.width / 1.8))
        loadingView.addSubview(mJoinStudentProgressBar)
        mJoinStudentProgressBar.backgroundColor = UIColor.clearColor()
        mJoinStudentProgressBar.progress = 20
        
        mJoinStudentProgressBar.lineWidth = 4
        
        
        
        
        
        mJoinedPercentageLabel.frame = CGRectMake(15, (mJoinStudentProgressBar.frame.size.height-(mJoinStudentProgressBar.frame.size.height / 6) )/2, mJoinStudentProgressBar.frame.size.width - 30 , mJoinStudentProgressBar.frame.size.height / 6)
        mJoinStudentProgressBar.addSubview(mJoinedPercentageLabel)
        mJoinedPercentageLabel.textAlignment = .Center
        mJoinedPercentageLabel.font = UIFont(name: helveticaRegular, size: 40)
        mJoinedPercentageLabel.lineBreakMode = .ByTruncatingMiddle
        mJoinedPercentageLabel.textColor = blackTextColor
        

        
        mJoinedStudentsLabel.frame = CGRectMake(mJoinedPercentageLabel.frame.origin.x ,mJoinedPercentageLabel.frame.origin.y + mJoinedPercentageLabel.frame.size.height , mJoinedPercentageLabel.frame.size.width , 30)
        mJoinStudentProgressBar.addSubview(mJoinedStudentsLabel)
        mJoinedStudentsLabel.textAlignment = .Center
        mJoinedStudentsLabel.font = UIFont(name: helveticaRegular, size: 14)
        mJoinedPercentageLabel.lineBreakMode = .ByTruncatingMiddle
        mJoinedStudentsLabel.textColor = UIColor.lightGrayColor()
        
        
        
        
        
        editSeatButton.frame = CGRectMake(10, loadingView.frame.size.height - 60 , loadingView.frame.size.width/4 ,loadingView.frame.size.width/12)
        editSeatButton.setTitle("Edit seats", forState: .Normal)
        editSeatButton.setTitleColor(standard_Button, forState: .Normal)
        loadingView.addSubview(editSeatButton)
        editSeatButton.titleLabel?.font = UIFont(name: helveticaRegular, size: 18)
        editSeatButton.hidden = true
//        editSeatButton.contentHorizontalAlignment = UIControlContentHorizontalAlignment.Left
        editSeatButton.addTarget(self, action: "onEditSeats", forControlEvents: UIControlEvents.TouchUpInside)
        editSeatButton.layer.cornerRadius = 5
        editSeatButton.layer.borderWidth = 1
        editSeatButton.layer.borderColor = standard_Button.CGColor

        
        
        
        allocateSeatButton.frame = CGRectMake(10, editSeatButton.frame.origin.y , editSeatButton.frame.size.width ,editSeatButton.frame.size.height)
        allocateSeatButton.setTitle("Allocate seats", forState: .Normal)
        allocateSeatButton.layer.cornerRadius = 5
        allocateSeatButton.layer.borderWidth = 1
        allocateSeatButton.layer.borderColor = standard_Red.CGColor
        allocateSeatButton.setTitleColor(standard_Red, forState: .Normal)
        loadingView.addSubview(allocateSeatButton)
        allocateSeatButton.hidden = true
        allocateSeatButton.titleLabel?.font = UIFont(name: helveticaRegular, size: 18)
        allocateSeatButton.addTarget(self, action: "onAllocateSeats", forControlEvents: UIControlEvents.TouchUpInside)
        
        
        
        configureGrid.frame = CGRectMake(10, editSeatButton.frame.origin.y , editSeatButton.frame.size.width ,editSeatButton.frame.size.height)
        configureGrid.setTitle("Configure grid", forState: .Normal)
        configureGrid.setTitleColor(standard_Button, forState: .Normal)
        loadingView.addSubview(configureGrid)
        configureGrid.hidden = true
        configureGrid.titleLabel?.font = UIFont(name: helveticaRegular, size: 18)
        configureGrid.contentHorizontalAlignment = UIControlContentHorizontalAlignment.Left
        configureGrid.addTarget(self, action: "onConfigureGrid", forControlEvents: UIControlEvents.TouchUpInside)
        
        
        
        cancelClassButton.frame = CGRectMake(30 + editSeatButton.frame.size.width, editSeatButton.frame.origin.y , editSeatButton.frame.size.width ,editSeatButton.frame.size.height)
        cancelClassButton.setTitle("Cancel class", forState: .Normal)
        cancelClassButton.setTitleColor(standard_Button, forState: .Normal)
        loadingView.addSubview(cancelClassButton)
        cancelClassButton.titleLabel?.font = UIFont(name: helveticaRegular, size: 18)
        cancelClassButton.contentHorizontalAlignment = UIControlContentHorizontalAlignment.Left
        cancelClassButton.addTarget(self, action: "onCancelClass", forControlEvents: UIControlEvents.TouchUpInside)

        
        
        
        
        openClassButton.frame = CGRectMake(self.frame.size.width - (editSeatButton.frame.size.width + 10), editSeatButton.frame.origin.y , editSeatButton.frame.size.width ,editSeatButton.frame.size.height)
        openClassButton.setTitle("Open class", forState: .Normal)
        openClassButton.layer.cornerRadius = 5
        openClassButton.layer.borderWidth = 1
        openClassButton.layer.borderColor = standard_Button.CGColor
        openClassButton.setTitleColor(standard_Button, forState: .Normal)
        loadingView.addSubview(openClassButton)
        openClassButton.hidden = true
        openClassButton.titleLabel?.font = UIFont(name: helveticaRegular, size: 18)
        openClassButton.addTarget(self, action: "onOpenClass", forControlEvents: UIControlEvents.TouchUpInside)
        
       
        
        
        
        
        beginClassButton.frame = CGRectMake(self.frame.size.width - (editSeatButton.frame.size.width + 10), editSeatButton.frame.origin.y , editSeatButton.frame.size.width ,editSeatButton.frame.size.height)
        beginClassButton.setTitle("Begin class", forState: .Normal)
        beginClassButton.layer.cornerRadius = 5
        beginClassButton.layer.borderWidth = 1
        beginClassButton.layer.borderColor = standard_Button.CGColor
        beginClassButton.setTitleColor(standard_Button, forState: .Normal)
        loadingView.addSubview(beginClassButton)
        beginClassButton.hidden = true
        beginClassButton.titleLabel?.font = UIFont(name: helveticaRegular, size: 18)
        beginClassButton.addTarget(self, action: "onBeginClass", forControlEvents: UIControlEvents.TouchUpInside)
        
    }
    
    
    
    
    func setClassname(classname:String, withSessionDetails details: AnyObject)
    {
        currentSessionDetails = details
        mClassnameLabel.text = classname
        loadingView.hidden = true
        
        overDueTimer.invalidate()
        nextSessionTimer.invalidate()
        
        
        refreshView()
        
    }
    
    
    func refreshView()
    {
        if let sessionId = currentSessionDetails.objectForKey("SessionId") as? String
        {
            SSTeacherDataSource.sharedDataSource.getScheduleSummaryWithSessionId(sessionId, WithDelegate: self)
        }
    }
    
    // MARK: - Teacher datasource delegate functions
    func didGetSessionSummaryDetials(details: AnyObject)
    {
        setcurrentViewDetails(details)
    }

    func didGetSeatsRestWithDetials(details: AnyObject) {
        
        if let sessionId = currentSessionDetails.objectForKey("SessionId") as? String
        {
            SSTeacherDataSource.sharedDataSource.getScheduleSummaryWithSessionId(sessionId, WithDelegate: self)
        }
    }
    
    
    // MARK: - data setting functions
    
    func setcurrentViewDetails(details:AnyObject)
    {
        
        
        scheduleSummaryDetails = details
        
        
        loadingView.hidden = false
        
        
        
        if let StudentsRegistered = details.objectForKey("StudentsRegistered") as? String
        {
            studentsRegistedlabel.text = StudentsRegistered
            
          
            
            
            if let PreAllocatedSeats = details.objectForKey("PreAllocatedSeats") as? String
            {
                
                
                
                
                
                
                
                
                if Int(PreAllocatedSeats)! > 0
                {
                    resetButton.enabled = true
                    resetButton.setTitleColor(standard_Button, forState: .Normal)

                }
                else
                {
                    resetButton.enabled = false
                    resetButton.setTitleColor(standard_TextGrey, forState: .Normal)
                }
                
                
                
                if let OccupiedSeats = details.objectForKey("OccupiedSeats") as? String
                {
                    
                    let totalSesats = Int(PreAllocatedSeats)! + Int(OccupiedSeats)!
                    
                    preallocatedSeatslabel.text = "\(totalSesats) of \(StudentsRegistered)"
                    
                    
                    
                    var percenatgeValue = (NSString(format: "%@", OccupiedSeats).floatValue) / (NSString(format: "%@", StudentsRegistered).floatValue) * 100;
                    
                    
                    if(isnan(percenatgeValue))
                    {
                        percenatgeValue = 0;
                    }
                    
                    
                    
                    
                    
                    mJoinedPercentageLabel.text =  NSString(format:"%.1f%%",percenatgeValue) as String;
                  
                    mJoinStudentProgressBar.progress = CGFloat(percenatgeValue) / 100;
                    
                    let string = "\(OccupiedSeats) of \(StudentsRegistered) joined" as NSString
                    let attributedString = NSMutableAttributedString(string: string as String )
                    attributedString.addAttributes([NSForegroundColorAttributeName: blackTextColor], range: string.rangeOfString("\(OccupiedSeats)"))
                    attributedString.addAttributes([NSForegroundColorAttributeName: UIColor.lightGrayColor()], range: string.rangeOfString(" of "))
                    attributedString.addAttributes([NSForegroundColorAttributeName: blackTextColor], range: string.rangeOfString("\(StudentsRegistered)"))
                    attributedString.addAttributes([NSForegroundColorAttributeName: UIColor.lightGrayColor()], range: string.rangeOfString(" joined"))
                    mJoinedStudentsLabel.attributedText = attributedString
                    
                    
                    if let SeatsConfigured = details.objectForKey("SeatsConfigured") as? String
                    {
                        seatsConfiguredLabel.text = SeatsConfigured
                        
                        
                        if Int(StudentsRegistered) > Int(SeatsConfigured)!
                        {
                            allocateSeatButton.hidden = true
                            editSeatButton.hidden = true
                            configureGrid.hidden = false
                        }
                        else  if Int(StudentsRegistered) > Int(PreAllocatedSeats)! + Int(OccupiedSeats)!
                        {
                            allocateSeatButton.hidden = false
                            editSeatButton.hidden = true
                            configureGrid.hidden = true
                            
                            if let SessionState = details.objectForKey("SessionState") as? String
                            {
                                if SessionState == kScheduled
                                {
                                    openClassButton.hidden = false
                                    openClassButton.enabled = false
                                    openClassButton.setTitleColor(standard_TextGrey, forState: .Normal)
                                    openClassButton.layer.borderColor = standard_TextGrey.CGColor
                                    
                                    beginClassButton.hidden = true
                                }
                                else
                                {
                                    openClassButton.hidden = true
                                    beginClassButton.hidden = false
                                    beginClassButton.enabled = false
                                    beginClassButton.setTitleColor(standard_TextGrey, forState: .Normal)
                                    beginClassButton.layer.borderColor = standard_TextGrey.CGColor

                                }
                            }
                        }
                        else
                        {
                            allocateSeatButton.hidden = true
                            editSeatButton.hidden = false
                            configureGrid.hidden = true
                            
                            if let SessionState = details.objectForKey("SessionState") as? String
                            {
                                if SessionState == kScheduled
                                {
                                    openClassButton.hidden = false
                                    openClassButton.enabled = true
                                    openClassButton.setTitleColor(standard_Button, forState: .Normal)
                                    openClassButton.layer.borderColor = standard_Button.CGColor

                                    
                                    beginClassButton.hidden = true
                                    
                                }
                                else
                                {
                                    openClassButton.hidden = true
                                    beginClassButton.hidden = false
                                    beginClassButton.enabled = true
                                    beginClassButton.setTitleColor(standard_Button, forState: .Normal)
                                    beginClassButton.layer.borderColor = standard_Button.CGColor
                                }
                            }

                        }
                    }
                    
                }
            }
        }
        
        if let TopicsConfigured = details.objectForKey("TopicsConfigured") as? String
        {
            topicsConfiguredLabel.text = TopicsConfigured
        }
        
        
        if let RoomName = details.objectForKey("RoomName") as? String
        {
            mRoomNameLabel.text = RoomName
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
    
    
    
    // MARK: - current view updating functions
    func updateOverdueSession()
    {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        var _string :String = ""
        let currentDate = NSDate()
        _string = _string.stringFromTimeInterval(currentDate.timeIntervalSinceDate(dateFormatter.dateFromString((scheduleSummaryDetails.objectForKey("StartTime") as! String))!)).fullString
        
        mTimelabel.text = "Overdue: \(_string)"
    }
    
    
    func updateNextSession()
    {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        var _string :String = ""
        let currentDate = NSDate()
        _string = _string.stringFromTimeInterval(dateFormatter.dateFromString((scheduleSummaryDetails.objectForKey("StartTime") as! String))!.timeIntervalSinceDate(currentDate)).fullString
        
        mTimelabel.text = "Starts: \(_string)"
        
    }
    
    // MARK: - buttons functions
    func onDoneButton()
    {
        UIView.animateWithDuration(0.5, animations: {
            self.frame = CGRectMake(self.frame.size.width + self.frame.size.width, self.frame.origin.y, self.frame.size.width, self.frame.size.height)
            }, completion: { finished in
                self.hidden = true
        })
        
        overDueTimer.invalidate()
        nextSessionTimer.invalidate()
    }
    
    func onEditSeats()
    {
        if delegate().respondsToSelector(Selector("delegateEditSeatPressedWithDetails:"))
        {
            delegate().delegateEditSeatPressedWithDetails!(currentSessionDetails)
        }
    }
    
    
    func onAllocateSeats()
    {
        if delegate().respondsToSelector(Selector("delegateAllocateSeatPressedWithDetails:"))
        {
            delegate().delegateAllocateSeatPressedWithDetails!(currentSessionDetails)
        }

    }
    
    
    func onConfigureGrid()
    {
        if delegate().respondsToSelector(Selector("delegateConfigureGridPressedWithDetails:"))
        {
            delegate().delegateConfigureGridPressedWithDetails!(currentSessionDetails)
        }
    }
    
    func onCancelClass()
    {
        if delegate().respondsToSelector(Selector("delegateCancelClassPressedWithDetails:"))
        {
            delegate().delegateCancelClassPressedWithDetails!(currentSessionDetails)
        }
    }
    
    func onOpenClass()
    {
        if delegate().respondsToSelector(Selector("delegateOpenClassPressedWithDetails:"))
        {
            delegate().delegateOpenClassPressedWithDetails!(currentSessionDetails)
        }
    }
    
    func onBeginClass()
    {
        if delegate().respondsToSelector(Selector("delegateBeginClassPressedWithDetails:"))
        {
            delegate().delegateBeginClassPressedWithDetails!(currentSessionDetails)
        }
    }
    
    
    func onReset()
    {
        
        if let sessionId = currentSessionDetails.objectForKey("SessionId") as? String
        {
            resetButton.enabled = false
            resetButton.setTitleColor(standard_TextGrey, forState: .Normal)
            
             SSTeacherDataSource.sharedDataSource.resetPreallocatedSeatsOfSession(sessionId, WithDelegate: self)
            
            
            
            
            if let RoomName = currentSessionDetails.objectForKey("RoomName") as? String
            {
                SSTeacherMessageHandler.sharedMessageHandler.sendSeatingChangedtoRoom(sessionId, withSeatName: "0", withRoomName: RoomName)
            }
            else
            {
                SSTeacherMessageHandler.sharedMessageHandler.sendSeatingChangedtoRoom(sessionId, withSeatName: "0", withRoomName: "")
            }
            
            
        }
        
       
        
        if delegate().respondsToSelector(Selector("delegateResetButtonPressedWithDetails:"))
        {
            delegate().delegateResetButtonPressedWithDetails!(currentSessionDetails)
        }
    }
}