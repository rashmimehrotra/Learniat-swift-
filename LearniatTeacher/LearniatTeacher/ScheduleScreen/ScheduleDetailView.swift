//
// ScheduleDetailView.swift
//  Learniat Teacher
//
//  Created by Deepak MK on 22/03/16.
//  Copyright © 2016 Mindshift. All rights reserved.
//


/*
    When user press on any session  in TeacherScheduleViewController then show session details with half screen using “ScheduleDetailView” using "ClassSessionSummary" API return value.
 */
 



import Foundation
// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}

// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func > <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l > r
  default:
    return rhs < lhs
  }
}



@objc protocol ScheduleDetailViewDelegate
{
    
    @objc optional func delegateAllocateSeatPressedWithDetails(_ details: AnyObject)
    
    @objc optional func delegateEditSeatPressedWithDetails(_ details: AnyObject)
    
    @objc optional func delegateConfigureGridPressedWithDetails(_ details: AnyObject)
    
    @objc optional func delegateCancelClassPressedWithDetails(_ details: AnyObject)
    
    @objc optional func delegateOpenClassPressedWithDetails(_ details: AnyObject)
    
    @objc optional func delegateBeginClassPressedWithDetails(_ details: AnyObject)
    
     @objc optional func delegateResetButtonPressedWithDetails(_ details: AnyObject)
    
    @objc optional func delegateViewStudentsPressed(_ details: AnyObject)
    
    @objc optional func delegateViewLessonPlanPressed(_ details: AnyObject)
    
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
    
    var overDueTimer                    = Timer()
    
    var nextSessionTimer                = Timer()
    
    
    var openClassButton                 = UIButton()
    
    var beginClassButton                = UIButton()
    
    
    var editSeatButton                  = UIButton()
    
    var allocateSeatButton              = UIButton()
    
    var configureGrid                   = UIButton()

    var cancelClassButton               = UIButton()
    
    
    var mJoinStudentProgressBar         = DonutChartView()
    
    var mJoinedPercentageLabel            = UILabel()
    
    var mJoinedStudentsLabel            = UILabel()
    
    var teacherScheduleViewController:TeacherScheduleViewController? = nil
    
    var mProgressContainerView = UIImageView()
    
    override init(frame: CGRect) {
        
        super.init(frame:frame)
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
    
    
    
    func addAllSubView ()
    {
        let topBar = UIView(frame: CGRect(x: 0,y: 0,width: self.frame.size.width,height: 40))
        topBar.backgroundColor = lightGrayTopBar
        self.addSubview(topBar)
        
        
        let classDetailsLabel = UILabel(frame: CGRect(x: (self.frame.size.width - 200)/2, y: 0 , width: 200 , height: 40))
        classDetailsLabel.text = "Class details"
        topBar.addSubview(classDetailsLabel)
        classDetailsLabel.textAlignment = .center
        
        
        let doneButton = UIButton(frame: CGRect(x: self.frame.size.width - (self.frame.size.width/2 - 10), y: 0, width: self.frame.size.width/2 - 20, height: 40))
        topBar.addSubview(doneButton)
        doneButton.setTitle("Done", for: UIControlState())
        doneButton.setTitleColor(standard_Button, for: UIControlState())
        doneButton.contentHorizontalAlignment = UIControlContentHorizontalAlignment.right
        doneButton.addTarget(self, action: #selector(ScheduleDetailView.onDoneButton), for: UIControlEvents.touchUpInside)
        doneButton.titleLabel?.font = UIFont(name: helveticaMedium, size: 18)
        
        
        
        mClassnameLabel.frame = CGRect(x: 10, y: topBar.frame.origin.y + topBar.frame.size.height + 10, width: self.frame.size.width/2 - 20, height: 30)
        self.addSubview(mClassnameLabel)
        mClassnameLabel.textAlignment = .left
        mClassnameLabel.font = UIFont(name: helveticaMedium, size: 18)
        mClassnameLabel.text = "B - ||| - Biology"
        mClassnameLabel.lineBreakMode = .byTruncatingMiddle
        
        
        mRoomNameLabel.frame = CGRect(x: 10, y: mClassnameLabel.frame.origin.y + mClassnameLabel.frame.size.height + 10, width: self.frame.size.width/2 - 20, height: 20)
        self.addSubview(mRoomNameLabel)
        mRoomNameLabel.textAlignment = .left
        mRoomNameLabel.font = UIFont(name: helveticaRegular, size: 12)
        mRoomNameLabel.text = "Room: 14"
        mRoomNameLabel.lineBreakMode = .byTruncatingMiddle
        mRoomNameLabel.textColor = standard_TextGrey
        
        mTimelabel.frame = CGRect(x: self.frame.size.width - (self.frame.size.width/2 - 10), y: topBar.frame.origin.y + topBar.frame.size.height + 10, width: self.frame.size.width/2 - 20, height: 30)
        self.addSubview(mTimelabel)
        mTimelabel.textAlignment = .right
        mTimelabel.font = UIFont(name: helveticaMedium, size: 18)
        mTimelabel.text = "Starts: 00:00:45"
        
        loadingView = UIView(frame: CGRect(x: 0 ,y: mRoomNameLabel.frame.origin.y + mRoomNameLabel.frame.size.height, width: self.frame.size.width,height: self.frame.size.height - (mRoomNameLabel.frame.origin.y + mRoomNameLabel.frame.size.height)))
        self.addSubview(loadingView)
        loadingView.isHidden = true
        
        
        let LineView = UIView(frame: CGRect(x: 0 ,y: 10, width: self.frame.size.width,height: 1 ))
        LineView.backgroundColor = LineGrayColor
        loadingView.addSubview(LineView)
        
//       let mSeatsConfigured = UILabel(frame: CGRect(x: 10, y: LineView.frame.origin.y + LineView.frame.size.height , width: self.frame.size.width/2 - 20, height: 40))
////        loadingView.addSubview(mSeatsConfigured)
//        mSeatsConfigured.textAlignment = .left
//        mSeatsConfigured.font = UIFont(name: helveticaRegular, size: 18)
//        mSeatsConfigured.text = "Seats configured"
//        mSeatsConfigured.lineBreakMode = .byTruncatingMiddle
//        
//        
//        
//        
//        seatsConfiguredLabel.frame = CGRect(x: self.frame.size.width - (self.frame.size.width/2 - 10), y: mSeatsConfigured.frame.origin.y , width: self.frame.size.width/2 - 20, height: mSeatsConfigured.frame.size.height)
////        loadingView.addSubview(seatsConfiguredLabel)
//        seatsConfiguredLabel.textAlignment = .right
//        seatsConfiguredLabel.font = UIFont(name: helveticaRegular, size: 18)
//        seatsConfiguredLabel.text = "32"
//        
//        
//        
//        
//        
//        
//        let LineView2 = UIView(frame: CGRect(x: 0 ,y: mSeatsConfigured.frame.origin.y + mSeatsConfigured.frame.size.height, width: self.frame.size.width,height: 1 ))
//        LineView2.backgroundColor = LineGrayColor
        
//        loadingView.addSubview(LineView2)
        
        
        
        let mStudentsRegistered = UILabel(frame: CGRect(x: 10, y: LineView.frame.origin.y + LineView.frame.size.height, width: self.frame.size.width/2 - 20, height: 40))
        loadingView.addSubview(mStudentsRegistered)
        mStudentsRegistered.textAlignment = .left
        mStudentsRegistered.font = UIFont(name: helveticaRegular, size: 18)
        mStudentsRegistered.text = "Students registered"
        mStudentsRegistered.lineBreakMode = .byTruncatingMiddle
        
        
        studentsRegistedlabel.frame = CGRect(x: self.frame.size.width - (self.frame.size.width/4 - 10), y: mStudentsRegistered.frame.origin.y , width: self.frame.size.width/4 - 20, height: mStudentsRegistered.frame.size.height)
        loadingView.addSubview(studentsRegistedlabel)
        studentsRegistedlabel.textAlignment = .right
        studentsRegistedlabel.font = UIFont(name: helveticaRegular, size: 18)
        studentsRegistedlabel.text = "24"
        
        
       let mStudentsViewButton = UIButton(frame: CGRect(x: studentsRegistedlabel.frame.origin.x - (self.frame.size.width/4), y:
            studentsRegistedlabel.frame.origin.y, width: self.frame.size.width/4 ,  height: studentsRegistedlabel.frame.size.height))
        loadingView.addSubview(mStudentsViewButton)
        mStudentsViewButton.setTitle("View", for: UIControlState())
        mStudentsViewButton.setTitleColor(standard_Button, for: UIControlState())
        mStudentsViewButton.contentHorizontalAlignment = UIControlContentHorizontalAlignment.right
        mStudentsViewButton.addTarget(self, action: #selector(ScheduleDetailView.onViewStudentsButton), for: UIControlEvents.touchUpInside)
        mStudentsViewButton.titleLabel?.font = UIFont(name: helveticaMedium, size: 18)
        
        
//        let LineView3 = UIView(frame: CGRect(x: 0 ,y: mStudentsRegistered.frame.origin.y + mStudentsRegistered.frame.size.height, width: self.frame.size.width,height: 1 ))
//        LineView3.backgroundColor = LineGrayColor
//        
//        loadingView.addSubview(LineView3)
//        
//
//        let mPreAllocatedSeats = UILabel(frame: CGRect(x: 10, y: LineView3.frame.origin.y + LineView3.frame.size.height, width: self.frame.size.width/2 - 20, height: 40))
//        loadingView.addSubview(mPreAllocatedSeats)
//        mPreAllocatedSeats.textAlignment = .left
//        mPreAllocatedSeats.font = UIFont(name: helveticaRegular, size: 18)
//        mPreAllocatedSeats.text = "Preallocated seats"
//        mPreAllocatedSeats.lineBreakMode = .byTruncatingMiddle
//        
//        
//        
//        preallocatedSeatslabel.frame = CGRect(x: self.frame.size.width - (self.frame.size.width/4 - 10), y: mPreAllocatedSeats.frame.origin.y , width: self.frame.size.width/4 - 20, height: mPreAllocatedSeats.frame.size.height)
//        loadingView.addSubview(preallocatedSeatslabel)
//        preallocatedSeatslabel.textAlignment = .right
//        preallocatedSeatslabel.font = UIFont(name: helveticaRegular, size: 18)
//        preallocatedSeatslabel.text = "16 of 24"
//        
//        
//        
//        
//        resetButton = UIButton(frame: CGRect(x: preallocatedSeatslabel.frame.origin.x - (self.frame.size.width/4), y: mPreAllocatedSeats.frame.origin.y, width: self.frame.size.width/4 ,  height: mPreAllocatedSeats.frame.size.height))
//        loadingView.addSubview(resetButton)
//        resetButton.setTitle("Reset", for: UIControlState())
//        resetButton.setTitleColor(standard_Button, for: UIControlState())
//        resetButton.contentHorizontalAlignment = UIControlContentHorizontalAlignment.right
//        resetButton.addTarget(self, action: #selector(ScheduleDetailView.onReset), for: UIControlEvents.touchUpInside)
//        resetButton.titleLabel?.font = UIFont(name: helveticaMedium, size: 18)
        
        
        
        
        
        let LineView4 = UIView(frame: CGRect(x: 0 ,y: studentsRegistedlabel.frame.origin.y + studentsRegistedlabel.frame.size.height, width: self.frame.size.width,height: 1 ))
        LineView4.backgroundColor = LineGrayColor
        
        loadingView.addSubview(LineView4)
        
        
        let mTopicsConfigured = UILabel(frame: CGRect(x: 10, y: LineView4.frame.origin.y + LineView4.frame.size.height, width: self.frame.size.width/2 - 20, height: 40))
        loadingView.addSubview(mTopicsConfigured)
        mTopicsConfigured.textAlignment = .left
        mTopicsConfigured.font = UIFont(name: helveticaRegular, size: 18)
        mTopicsConfigured.text = "Topics completed"
        mTopicsConfigured.lineBreakMode = .byTruncatingMiddle
        
        
        topicsConfiguredLabel.frame = CGRect(x: self.frame.size.width - (self.frame.size.width/4 - 10), y: mTopicsConfigured.frame.origin.y , width: self.frame.size.width/4 - 20, height: mTopicsConfigured.frame.size.height)
        loadingView.addSubview(topicsConfiguredLabel)
        topicsConfiguredLabel.textAlignment = .right
        topicsConfiguredLabel.font = UIFont(name: helveticaRegular, size: 18)
        topicsConfiguredLabel.text = "5 of 200"
        
        
        let mTopicsViewButton = UIButton(frame: CGRect(x: topicsConfiguredLabel.frame.origin.x - (self.frame.size.width/4), y:
            topicsConfiguredLabel.frame.origin.y, width: self.frame.size.width/4 ,  height: studentsRegistedlabel.frame.size.height))
        loadingView.addSubview(mTopicsViewButton)
        mTopicsViewButton.setTitle("View", for: UIControlState())
        mTopicsViewButton.setTitleColor(standard_Button, for: UIControlState())
        mTopicsViewButton.contentHorizontalAlignment = UIControlContentHorizontalAlignment.right
        mTopicsViewButton.addTarget(self, action: #selector(ScheduleDetailView.onViewTopicsButton), for: UIControlEvents.touchUpInside)
        mTopicsViewButton.titleLabel?.font = UIFont(name: helveticaMedium, size: 18)
        
        
        let LineView5 = UIView(frame: CGRect(x: 0 ,y: mTopicsConfigured.frame.origin.y + mTopicsConfigured.frame.size.height, width: self.frame.size.width,height: 1 ))
        LineView5.backgroundColor = LineGrayColor
        
        loadingView.addSubview(LineView5)
        
        
        let mQuestionConfigured = UILabel(frame: CGRect(x: 10, y: LineView5.frame.origin.y + LineView5.frame.size.height, width: self.frame.size.width/2 - 20, height: 40))
        loadingView.addSubview(mQuestionConfigured)
        mQuestionConfigured.textAlignment = .left
        mQuestionConfigured.font = UIFont(name: helveticaRegular, size: 18)
        mQuestionConfigured.text = "Questions completed"
        mQuestionConfigured.lineBreakMode = .byTruncatingMiddle
        
        
        
        questionConfiguredLabel.frame = CGRect(x: self.frame.size.width - (self.frame.size.width/2 - 10), y: mQuestionConfigured.frame.origin.y , width: self.frame.size.width/2 - 20, height: mQuestionConfigured.frame.size.height)
        loadingView.addSubview(questionConfiguredLabel)
        questionConfiguredLabel.textAlignment = .right
        questionConfiguredLabel.font = UIFont(name: helveticaRegular, size: 18)
        questionConfiguredLabel.text = "16 of 24"
        
        
        let LineView6 = UIView(frame: CGRect(x: 0 ,y: mQuestionConfigured.frame.origin.y + mQuestionConfigured.frame.size.height, width: self.frame.size.width,height: 1 ))
        LineView6.backgroundColor = LineGrayColor
        loadingView.addSubview(LineView6)
        
        
        
        
        mProgressContainerView  = UIImageView(frame: CGRect(x: 0, y: LineView6.frame.origin.y + 10, width: loadingView.frame.size.width, height: loadingView.frame.size.height - (LineView6.frame.origin.y + 20 + loadingView.frame.size.width/12)))
        mProgressContainerView.backgroundColor = UIColor.clear
        loadingView.addSubview(mProgressContainerView)
        mProgressContainerView.isUserInteractionEnabled = true
        
        
        mJoinStudentProgressBar.frame = CGRect(x: (mProgressContainerView.frame.size.width - (mProgressContainerView.frame.size.width / 1.6) ) /  2 , y: (mProgressContainerView.frame.size.height - (mProgressContainerView.frame.size.width / 1.6) ) /  2 , width: (mProgressContainerView.frame.size.width / 1.6), height: (mProgressContainerView.frame.size.width / 1.6))
        mProgressContainerView.addSubview(mJoinStudentProgressBar)
        mJoinStudentProgressBar.backgroundColor = UIColor.clear
        mJoinStudentProgressBar.progress = 20
        
        mJoinStudentProgressBar.lineWidth = 6
        
        
        
        
        
        mJoinedPercentageLabel.frame = CGRect(x: 0, y: (mJoinStudentProgressBar.frame.size.height-((mJoinStudentProgressBar.frame.size.height / 6) + 30) )/2, width: mJoinStudentProgressBar.frame.size.width , height: mJoinStudentProgressBar.frame.size.height / 6)
        mJoinStudentProgressBar.addSubview(mJoinedPercentageLabel)
        mJoinedPercentageLabel.textAlignment = .center
        mJoinedPercentageLabel.font = UIFont(name: HelveticaNeueThin, size: 50)
        mJoinedPercentageLabel.lineBreakMode = .byTruncatingMiddle
        mJoinedPercentageLabel.textColor = blackTextColor
        mJoinedPercentageLabel.backgroundColor = UIColor.clear
        

        
        mJoinedStudentsLabel.frame = CGRect(x: mJoinedPercentageLabel.frame.origin.x ,y: mJoinedPercentageLabel.frame.origin.y + mJoinedPercentageLabel.frame.size.height , width: mJoinedPercentageLabel.frame.size.width , height: 30)
        mJoinStudentProgressBar.addSubview(mJoinedStudentsLabel)
        mJoinedStudentsLabel.textAlignment = .center
        mJoinedStudentsLabel.font = UIFont(name: helveticaRegular, size: 14)
        mJoinedPercentageLabel.lineBreakMode = .byTruncatingMiddle
        mJoinedStudentsLabel.textColor = UIColor.lightGray
        
        
        
        
        let mJoinedStudentsButton = UIButton(frame: CGRect(x: mJoinedPercentageLabel.frame.origin.x , y:
            mJoinedStudentsLabel.frame.origin.y + mJoinedStudentsLabel.frame.size.height, width: mJoinedPercentageLabel.frame.size.width ,  height: 30))
        mJoinStudentProgressBar.addSubview(mJoinedStudentsButton)
        mJoinedStudentsButton.setTitle("View", for: UIControlState())
        mJoinedStudentsButton.setTitleColor(standard_Button, for: UIControlState())
        mJoinedStudentsButton.contentHorizontalAlignment = UIControlContentHorizontalAlignment.center
        mJoinedStudentsButton.addTarget(self, action: #selector(ScheduleDetailView.onViewStudentsButton), for: UIControlEvents.touchUpInside)
        mJoinedStudentsButton.titleLabel?.font = UIFont(name: helveticaMedium, size: 18)
        
        
        
        
        editSeatButton.frame = CGRect(x: 10, y: loadingView.frame.size.height - 60 , width: loadingView.frame.size.width/4 ,height: loadingView.frame.size.width/12)
        editSeatButton.setTitle("Edit seats", for: UIControlState())
        editSeatButton.setTitleColor(standard_Button, for: UIControlState())
//        loadingView.addSubview(editSeatButton)
        editSeatButton.titleLabel?.font = UIFont(name: helveticaRegular, size: 18)
        editSeatButton.isHidden = true
//        editSeatButton.contentHorizontalAlignment = UIControlContentHorizontalAlignment.Left
        editSeatButton.addTarget(self, action: #selector(ScheduleDetailView.onEditSeats), for: UIControlEvents.touchUpInside)
        editSeatButton.layer.cornerRadius = 5
        editSeatButton.layer.borderWidth = 1
        editSeatButton.layer.borderColor = standard_Button.cgColor

        
        
        
        allocateSeatButton.frame = CGRect(x: 10, y: editSeatButton.frame.origin.y , width: editSeatButton.frame.size.width ,height: editSeatButton.frame.size.height)
        allocateSeatButton.setTitle("Allocate seats", for: UIControlState())
        allocateSeatButton.layer.cornerRadius = 5
        allocateSeatButton.layer.borderWidth = 1
        allocateSeatButton.layer.borderColor = standard_Red.cgColor
        allocateSeatButton.setTitleColor(standard_Red, for: UIControlState())
       loadingView.addSubview(allocateSeatButton)
        allocateSeatButton.isHidden = true
        allocateSeatButton.titleLabel?.font = UIFont(name: helveticaRegular, size: 18)
        allocateSeatButton.addTarget(self, action: #selector(ScheduleDetailView.onAllocateSeats), for: UIControlEvents.touchUpInside)
        
        
        
        configureGrid.frame = CGRect(x: 10, y: editSeatButton.frame.origin.y , width: editSeatButton.frame.size.width ,height: editSeatButton.frame.size.height)
        configureGrid.setTitle("Configure grid", for: UIControlState())
        configureGrid.setTitleColor(standard_Button, for: UIControlState())
        loadingView.addSubview(configureGrid)
        configureGrid.isHidden = true
        configureGrid.titleLabel?.font = UIFont(name: helveticaRegular, size: 18)
        configureGrid.contentHorizontalAlignment = UIControlContentHorizontalAlignment.left
        configureGrid.addTarget(self, action: #selector(ScheduleDetailView.onConfigureGrid), for: UIControlEvents.touchUpInside)
        
        
        configureGrid.layer.cornerRadius = 5
        configureGrid.layer.borderWidth = 1
        configureGrid.layer.borderColor = standard_Red.cgColor
        configureGrid.setTitleColor(standard_Red, for: UIControlState())

        
        
        
        cancelClassButton.frame = CGRect(x: 10, y: editSeatButton.frame.origin.y , width: editSeatButton.frame.size.width ,height: editSeatButton.frame.size.height)
        cancelClassButton.setTitle("Cancel class", for: UIControlState())
        cancelClassButton.setTitleColor(standard_Red, for: UIControlState())
        loadingView.addSubview(cancelClassButton)
        cancelClassButton.titleLabel?.font = UIFont(name: helveticaRegular, size: 18)
        cancelClassButton.contentHorizontalAlignment = UIControlContentHorizontalAlignment.center
        cancelClassButton.addTarget(self, action: #selector(ScheduleDetailView.onCancelClass), for: UIControlEvents.touchUpInside)
        cancelClassButton.layer.cornerRadius = 5
        cancelClassButton.layer.borderWidth = 1
        cancelClassButton.layer.borderColor = standard_Red.cgColor
        

        
        
        
        
        openClassButton.frame = CGRect(x: self.frame.size.width - (editSeatButton.frame.size.width + 10), y: editSeatButton.frame.origin.y , width: editSeatButton.frame.size.width ,height: editSeatButton.frame.size.height)
        openClassButton.setTitle("Open class", for: UIControlState())
        openClassButton.layer.cornerRadius = 5
        openClassButton.layer.borderWidth = 1
        openClassButton.layer.borderColor = standard_Button.cgColor
        openClassButton.setTitleColor(standard_Button, for: UIControlState())
        loadingView.addSubview(openClassButton)
        openClassButton.isHidden = true
        openClassButton.titleLabel?.font = UIFont(name: helveticaRegular, size: 18)
        openClassButton.addTarget(self, action: #selector(ScheduleDetailView.onOpenClass), for: UIControlEvents.touchUpInside)
        
       
        
        
        
        
        beginClassButton.frame = CGRect(x: self.frame.size.width - (editSeatButton.frame.size.width + 10), y: editSeatButton.frame.origin.y , width: editSeatButton.frame.size.width ,height: editSeatButton.frame.size.height)
        beginClassButton.setTitle("Begin class", for: UIControlState())
        beginClassButton.layer.cornerRadius = 5
        beginClassButton.layer.borderWidth = 1
        beginClassButton.layer.borderColor = standard_Button.cgColor
        beginClassButton.setTitleColor(standard_Button, for: UIControlState())
        loadingView.addSubview(beginClassButton)
        beginClassButton.isHidden = true
        beginClassButton.titleLabel?.font = UIFont(name: helveticaRegular, size: 18)
        beginClassButton.addTarget(self, action: #selector(ScheduleDetailView.onBeginClass), for: UIControlEvents.touchUpInside)
        
    }
    
    
    
    
    func setClassname(_ classname:String, withSessionDetails details: AnyObject)
    {
        currentSessionDetails = details
        mClassnameLabel.text = classname
        loadingView.isHidden = true
        
        overDueTimer.invalidate()
        nextSessionTimer.invalidate()
        
        
        refreshView()
        
    }
    
    
    func refreshView()
    {
        if let sessionId = currentSessionDetails.object(forKey: "SessionId") as? String
        {
            SSTeacherDataSource.sharedDataSource.getScheduleSummaryWithSessionId(sessionId, WithDelegate: self)
        }
    }
    
    func refreshJoinedStateBar() {
        if let sessionId = currentSessionDetails.object(forKey: "SessionId") as? String
        {
            SSTeacherDataSource.sharedDataSource.getJoinedStudentsCount(sessionID: sessionId, success: { (result) in
                if let registered = result.object(forKey: kRegistered) as? Int {
                    if let joined = result.object(forKey: kJoined) as? Int {
                        let percenatgeValue = (CGFloat(joined) /  CGFloat(registered)) * 100   
                        self.mJoinedPercentageLabel.text =  NSString(format:"%.1f%%",percenatgeValue) as String;
                        self.mJoinStudentProgressBar.progress = CGFloat(percenatgeValue) / 100;
                        self.joinedLabelWithJoinedCount(OccupiedSeats: joined, StudentsRegistered: registered)
                    }
                }
            }, withfailurehandler: { (error) in
                
            })
        }
    }
    
    
    private func joinedLabelWithJoinedCount(OccupiedSeats:Int, StudentsRegistered:Int) {
        let string = "\(OccupiedSeats) of \(StudentsRegistered) joined" as NSString
        let attributedString = NSMutableAttributedString(string: string as String )
        attributedString.addAttributes([NSForegroundColorAttributeName: blackTextColor], range: string.range(of: "\(OccupiedSeats)"))
        attributedString.addAttributes([NSForegroundColorAttributeName: UIColor.lightGray], range: string.range(of: " of "))
        attributedString.addAttributes([NSForegroundColorAttributeName: blackTextColor], range: string.range(of: "\(StudentsRegistered)"))
        attributedString.addAttributes([NSForegroundColorAttributeName: UIColor.lightGray], range: string.range(of: " joined"))
        mJoinedStudentsLabel.attributedText = attributedString
    }
    
    
    
    // MARK: - Teacher datasource delegate functions
    func didGetSessionSummaryDetials(_ details: AnyObject)
    {
       print(details)
        setcurrentViewDetails(details)
        refreshJoinedStateBar()
    }

    func didGetSeatsRestWithDetials(_ details: AnyObject) {
        
        if let sessionId = currentSessionDetails.object(forKey: "SessionId") as? String
        {
            SSTeacherDataSource.sharedDataSource.getScheduleSummaryWithSessionId(sessionId, WithDelegate: self)
        }
    }
    
    
    // MARK: - data setting functions
    
    func setcurrentViewDetails(_ details:AnyObject)
    {
        
        
        scheduleSummaryDetails = details
        
        
        loadingView.isHidden = false
        self.mJoinStudentProgressBar.progress = 0;
        
        
        if let StudentsRegistered = details.object(forKey: "StudentsRegistered") as? String
        {
            studentsRegistedlabel.text = StudentsRegistered
            
          
            
            
            if let PreAllocatedSeats = details.object(forKey: "PreAllocatedSeats") as? String
            {
                
                
                
                
                
                
                
                
                if Int(PreAllocatedSeats)! > 0
                {
//                    resetButton.isEnabled = true
//                    resetButton.setTitleColor(standard_Button, for: UIControlState())

                }
                else
                {
//                    resetButton.isEnabled = false
//                    resetButton.setTitleColor(standard_TextGrey, for: UIControlState())
                }
                
                
                
                if let OccupiedSeats = details.object(forKey: "OccupiedSeats") as? String
                {
                    
                    let totalSesats = Int(PreAllocatedSeats)! + Int(OccupiedSeats)!
                    
                    preallocatedSeatslabel.text = "\(totalSesats) of \(StudentsRegistered)"
                    
                    if let SeatsConfigured = details.object(forKey: "SeatsConfigured") as? String
                    {
                        if Int(StudentsRegistered) > Int(SeatsConfigured)!
                        {
                            allocateSeatButton.isHidden = true
                            
                             cancelClassButton.frame = CGRect(x: editSeatButton.frame.origin.x + editSeatButton.frame.size.width + 10, y: editSeatButton.frame.origin.y , width: editSeatButton.frame.size.width ,height: editSeatButton.frame.size.height)
                            
                            editSeatButton.isHidden = true
                            configureGrid.isHidden = false
                        }
                        else  if Int(StudentsRegistered) > Int(PreAllocatedSeats)! + Int(OccupiedSeats)!
                        {
                            allocateSeatButton.isHidden = false
                            
                             cancelClassButton.frame = CGRect(x: editSeatButton.frame.origin.x + editSeatButton.frame.size.width + 10, y: editSeatButton.frame.origin.y , width: editSeatButton.frame.size.width ,height: editSeatButton.frame.size.height)
                            
                            editSeatButton.isHidden = true
                            configureGrid.isHidden = true
                            
                            if let SessionState = details.object(forKey: "SessionState") as? String
                            {
                                if SessionState == kScheduled
                                {
                                    openClassButton.isHidden = false
                                    openClassButton.isEnabled = false
                                    openClassButton.setTitleColor(standard_TextGrey, for: UIControlState())
                                    openClassButton.layer.borderColor = standard_TextGrey.cgColor
                                    
                                    beginClassButton.isHidden = true
                                }
                                else
                                {
                                    openClassButton.isHidden = true
                                    beginClassButton.isHidden = false
                                    beginClassButton.isEnabled = false
                                    beginClassButton.setTitleColor(standard_TextGrey, for: UIControlState())
                                    beginClassButton.layer.borderColor = standard_TextGrey.cgColor

                                }
                            }
                        }
                        else
                        {
                            allocateSeatButton.isHidden = true
                            editSeatButton.isHidden = false
                            configureGrid.isHidden = true
                            
                            
                            if let sessionId = currentSessionDetails.object(forKey: "SessionId") as? String{
                            
                            if let SessionState = details.object(forKey: "SessionState") as? String
                            {
                                if SessionState == kScheduled && (Int(sessionId) == TeacherScheduleViewController.currentSessionId || Int(sessionId) == TeacherScheduleViewController.nextSessionId)
                                {
                                    
                                    openClassButton.isHidden = false
                                    openClassButton.isEnabled = true
                                    openClassButton.setTitleColor(standard_Button, for: UIControlState())
                                    openClassButton.layer.borderColor = standard_Button.cgColor

                                    
                                    beginClassButton.isHidden = true
                                    
                                }
                                else if SessionState == kopened
                                {
                                    openClassButton.isHidden = true
                                    beginClassButton.isHidden = false
                                    beginClassButton.isEnabled = true
                                    beginClassButton.setTitleColor(standard_Button, for: UIControlState())
                                    beginClassButton.layer.borderColor = standard_Button.cgColor
                                }
                                else{
                                    openClassButton.isHidden = true
                                    beginClassButton.isHidden = true
                                }
                            }
                        }

                        }
                    }
                    
                }
            }
        }
        
        if let TopicsConfigured = details.object(forKey: "TotalSubtopicsConfigured") as? String
        {
            
            topicsConfiguredLabel.text = TopicsConfigured
            
            
            if let TotalSubTopicsCompleted = details.object(forKey: "TotalSubTopicsCompleted") as? String
            {
                topicsConfiguredLabel.text = TotalSubTopicsCompleted.appending(" of ").appending(TopicsConfigured)
            }
        }
        
        
        if let RoomName = details.object(forKey: "RoomName") as? String
        {
            mRoomNameLabel.text = RoomName
        }
        
        if let QuestionsConfigured = details.object(forKey: "QuestionsConfigured") as? String
        {
            questionConfiguredLabel.text = QuestionsConfigured
            
            if let TotalQuestionsCompleted =  details.object(forKey: "TotalQuestionsCompleted") as? String
            {
                questionConfiguredLabel.text = TotalQuestionsCompleted.appending(" of ").appending(QuestionsConfigured)
            }
            
        }
        
        
        
        if let SessionState = details.object(forKey:"SessionState") as? String
        {
            if SessionState == "2"
            {
                mProgressContainerView.isHidden = false
            }
            else
            {
                mProgressContainerView.isHidden = true
            }
            
        }
        
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let currentDate = Date()
        let isgreatervalue :Bool ;
        
        isgreatervalue = currentDate.isGreaterThanDate(dateFormatter.date(from: details.object(forKey: "StartTime") as! String)!)
        
        let  isEqualValue = currentDate == dateFormatter.date(from: details.object(forKey: "StartTime") as! String)!
        
        if isgreatervalue == true || isEqualValue == true
        {
            
            
            var _string :String = ""
            let currentDate = Date()
            _string = _string.stringFromTimeInterval(currentDate.timeIntervalSince(dateFormatter.date(from: (details.object(forKey: "StartTime") as! String))!)).fullString
            
            mTimelabel.text = "Overdue: \(_string)"
            overDueTimer.invalidate()
            nextSessionTimer.invalidate()
            
            overDueTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(ScheduleDetailView.updateOverdueSession), userInfo: nil, repeats: true)

           

        }
        else
        {
            var _string :String = ""
            let currentDate = Date()
            _string = _string.stringFromTimeInterval(dateFormatter.date(from: (details.object(forKey: "StartTime") as! String))!.timeIntervalSince(currentDate)).fullString
            
            mTimelabel.text = "Starts: \(_string)"
            
            nextSessionTimer.invalidate()
            nextSessionTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(ScheduleDetailView.updateNextSession), userInfo: nil, repeats: true)

        }
        
    }
    
    
    
    
    
    // MARK: - current view updating functions
    func updateOverdueSession()
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        var _string :String = ""
        let currentDate = Date()
        _string = _string.stringFromTimeInterval(currentDate.timeIntervalSince(dateFormatter.date(from: (scheduleSummaryDetails.object(forKey: "StartTime") as! String))!)).fullString
        
        mTimelabel.text = "Overdue: \(_string)"
    }
    
    
    func updateNextSession()
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        var _string :String = ""
        let currentDate = Date()
        _string = _string.stringFromTimeInterval(dateFormatter.date(from: (scheduleSummaryDetails.object(forKey: "StartTime") as! String))!.timeIntervalSince(currentDate)).fullString
        
        mTimelabel.text = "Starts: \(_string)"
        
    }
    
    // MARK: - buttons functions
    func onDoneButton()
    {
        UIView.animate(withDuration: 0.5, animations: {
            self.frame = CGRect(x: self.frame.size.width + self.frame.size.width, y: self.frame.origin.y, width: self.frame.size.width, height: self.frame.size.height)
            }, completion: { finished in
                self.isHidden = true
        })
        
        overDueTimer.invalidate()
        nextSessionTimer.invalidate()
    }
    
    func onEditSeats()
    {
        if delegate().responds(to: #selector(ScheduleDetailViewDelegate.delegateEditSeatPressedWithDetails(_:)))
        {
            delegate().delegateEditSeatPressedWithDetails!(currentSessionDetails)
        }
    }
    
    
    func onAllocateSeats()
    {
        if delegate().responds(to: #selector(ScheduleDetailViewDelegate.delegateAllocateSeatPressedWithDetails(_:)))
        {
            delegate().delegateAllocateSeatPressedWithDetails!(currentSessionDetails)
        }

    }
    
    
    func onConfigureGrid()
    {
        if delegate().responds(to: #selector(ScheduleDetailViewDelegate.delegateConfigureGridPressedWithDetails(_:)))
        {
            delegate().delegateConfigureGridPressedWithDetails!(currentSessionDetails)
        }
    }
    
    func onCancelClass()
    {
        if delegate().responds(to: #selector(ScheduleDetailViewDelegate.delegateCancelClassPressedWithDetails(_:)))
        {
            delegate().delegateCancelClassPressedWithDetails!(currentSessionDetails)
        }
    }
    
    func onOpenClass()
    {
        if delegate().responds(to: #selector(ScheduleDetailViewDelegate.delegateOpenClassPressedWithDetails(_:)))
        {
            delegate().delegateOpenClassPressedWithDetails!(currentSessionDetails)
        }
    }
    
    func onBeginClass()
    {
        if delegate().responds(to: #selector(ScheduleDetailViewDelegate.delegateBeginClassPressedWithDetails(_:)))
        {
            delegate().delegateBeginClassPressedWithDetails!(currentSessionDetails)
        }
    }
    
    
    func onReset()
    {
        
        if let sessionId = currentSessionDetails.object(forKey: "SessionId") as? String
        {
//            resetButton.isEnabled = false
//            resetButton.setTitleColor(standard_TextGrey, for: UIControlState())
            
             SSTeacherDataSource.sharedDataSource.resetPreallocatedSeatsOfSession(sessionId, WithDelegate: self)
            
            
            
            
            if let RoomName = currentSessionDetails.object(forKey: "RoomName") as? String
            {
                SSTeacherMessageHandler.sharedMessageHandler.sendSeatingChangedtoRoom(sessionId, withSeatName: "0", withRoomName: RoomName)
            }
            else
            {
                SSTeacherMessageHandler.sharedMessageHandler.sendSeatingChangedtoRoom(sessionId, withSeatName: "0", withRoomName: "")
            }
            
            
        }
        
       
        
        if delegate().responds(to: #selector(ScheduleDetailViewDelegate.delegateResetButtonPressedWithDetails(_:)))
        {
            delegate().delegateResetButtonPressedWithDetails!(currentSessionDetails)
        }
    }
    
    
    func onViewStudentsButton()
    {
        if delegate().responds(to: #selector(ScheduleDetailViewDelegate.delegateViewStudentsPressed(_:)))
        {
            delegate().delegateViewStudentsPressed!(currentSessionDetails)
        }
    }
    
    func onViewTopicsButton()
    {
        if delegate().responds(to: #selector(ScheduleDetailViewDelegate.delegateViewLessonPlanPressed(_:)))
        {
            delegate().delegateViewLessonPlanPressed!(currentSessionDetails)
        }
    }
    
}
