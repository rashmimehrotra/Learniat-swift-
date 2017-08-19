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
    
    var mTeacherImageView: CustomProgressImageView!
    
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
        
        mTopbarImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: (self.view.frame.size.height)/12))
        mTopbarImageView.backgroundColor = topbarColor
        self.view.addSubview(mTopbarImageView)
        mTopbarImageView.isUserInteractionEnabled = true
        mTopbarImageView.isUserInteractionEnabled = true
        
        
        
        mTeacherImageView = CustomProgressImageView(frame: CGRect(x: 15, y: 15, width: mTopbarImageView.frame.size.height - 20 ,height: mTopbarImageView.frame.size.height - 20))
        mTeacherImageView.backgroundColor = lightGrayColor
        mTopbarImageView.addSubview(mTeacherImageView)
        mTeacherImageView.layer.masksToBounds = true
        mTeacherImageView.layer.cornerRadius = 2
        
        
        let urlString = UserDefaults.standard.object(forKey: k_INI_UserProfileImageURL) as! String
        
        let userID = urlString.appending("/").appending(SSStudentDataSource.sharedDataSource.currentUserId)
        
        
        if let checkedUrl = URL(string: "\(userID)_79px.jpg")

        {
            mTeacherImageView.contentMode = .scaleAspectFit
            mTeacherImageView.downloadImage(checkedUrl, withFolderType: folderType.proFilePics)
        }
        
        
        
        
        
        mTeacherName = UILabel(frame: CGRect(x: mTeacherImageView.frame.origin.x + mTeacherImageView.frame.size.width + 10, y: mTeacherImageView.frame.origin.y, width: 200, height: 20))
        mTeacherName.font = UIFont(name:helveticaMedium, size: 20)
        mTeacherName.text = SSStudentDataSource.sharedDataSource.currentUserName.capitalized
        mTopbarImageView.addSubview(mTeacherName)
        mTeacherName.textColor = UIColor.white
        
        

        
        
        let mPreallocateSeats = UILabel(frame: CGRect(x: (mTopbarImageView.frame.size.width - 400)/2, y: 0, width: 400, height: mTopbarImageView.frame.size.height))
        mPreallocateSeats.font = UIFont(name:helveticaRegular, size: 20)
       
        mTopbarImageView.addSubview(mPreallocateSeats)
        mPreallocateSeats.textColor = UIColor.white
        mPreallocateSeats.textAlignment = .center
        
        if let ClassName = sessionDetails.object(forKey: RAPIConstants.RoomName.rawValue) as? String
        {
             mPreallocateSeats.text = ClassName
        }
        else
        {
             mPreallocateSeats.text = "Preallot seats"
        }
        
        
        
        let remainingHeight = mTopbarImageView.frame.origin.y + mTopbarImageView.frame.size.height + 20
        
        
        mNoStudentLabel.frame = CGRect(x: 10, y: (self.view.frame.size.height - 40)/2, width: self.view.frame.size.width - 20,height: 40)
        mNoStudentLabel.font = UIFont(name:helveticaMedium, size: 30)
        mNoStudentLabel.text = "Please wait for teacher to ressign seats "
        self.view.addSubview(mNoStudentLabel)
        mNoStudentLabel.textColor = UIColor.white
        mNoStudentLabel.textAlignment = .center
        mNoStudentLabel.isHidden = true
        
        
        mGridContainerView.frame = CGRect(x: 10, y: mTopbarImageView.frame.origin.y + mTopbarImageView.frame.size.height + 10  , width: self.view.frame.size.width - 20, height: self.view.frame.size.height - remainingHeight )
        self.view.addSubview(mGridContainerView)
        mGridContainerView.backgroundColor = darkBackgroundColor
        //        mGridContainerView.hidden = true
        
        mActivityIndicatore = UIActivityIndicatorView(activityIndicatorStyle: .gray)
        mActivityIndicatore.frame = CGRect(x: (self.view.frame.size.width - 40)/2, y: (self.view.frame.size.height - 40)/2, width: 40, height: 40)
        self.view.addSubview(mActivityIndicatore)
        //        mActivityIndicatore.startAnimating()
        
        if let roomId = sessionDetails.object(forKey: RAPIConstants.RoomId.rawValue) as? Int
        {
            SSStudentDataSource.sharedDataSource.getGridDesignDetails(String(roomId), WithDelegate: self)
        }
        
        mClassNameButton.frame = CGRect(x: (mTopbarImageView.frame.size.width - mPreallocateSeats.frame.size.width)/2 , y: 0, width: mPreallocateSeats.frame.size.width, height: mTopbarImageView.frame.size.height )
        mTopbarImageView.addSubview(mClassNameButton)
        mClassNameButton.addTarget(self, action: #selector(StudentSeatViewController.onClassButton), for: UIControlEvents.touchUpInside)
        mClassNameButton.backgroundColor = UIColor.clear

        RealmDatasourceManager.saveScreenStateOfUser(screenState: .JoinScreen, withUserId: SSStudentDataSource.sharedDataSource.currentUserId)
    }
    
    
    func onClassButton() {
        let buttonPosition :CGPoint = mClassNameButton.convert(CGPoint.zero, to: self.view)
        let remainingHeight = self.view.frame.size.height - (buttonPosition.y  + mClassNameButton.frame.size.height + mClassNameButton.frame.size.height)
        let questionInfoController = SSStudentSchedulePopoverController()
        questionInfoController.setCurrentScreenSize(CGSize(width: 400, height: remainingHeight))
        questionInfoController.setdelegate(self)
        let   classViewPopOverController = UIPopoverController(contentViewController: questionInfoController)
        classViewPopOverController.contentSize = CGSize(width: 400,height: remainingHeight);
        classViewPopOverController.delegate = self;
        questionInfoController.setPopover(classViewPopOverController)
        classViewPopOverController.present(from: CGRect(
            x:buttonPosition.x + mClassNameButton.frame.size.width / 2,
            y:buttonPosition.y  + mClassNameButton.frame.size.height,
            width: 1,
            height: 1), in: self.view, permittedArrowDirections: .up, animated: true)
    }
    
    
    func setCurrentSessionDetails(_ details: AnyObject) {
        sessionDetails = details
    }
    
    
    
    // MARK: - datasource delegate Functions
    
    func didGetGridDesignWithDetails(_ details: AnyObject) {
        currentGridDetails = details
        mActivityIndicatore.stopAnimating()
        mActivityIndicatore.isHidden = true
        
        if let Columns = details.object(forKey: "Columns") as? String {
            columnValue = Int(Columns)!
        }
        
        if let Rows = details.object(forKey: "Rows") as? String {
            rowValue = Int(Rows)!
        }
        
        if let SeatIdList = details.object(forKey: "SeatIdList") as? String
        {
            seatsIdArray =  SeatIdList.components(separatedBy: ",")
        }
        
        if let SeatLabelList = details.object(forKey: "SeatLabelList") as? String
        {
            seatsLableArray =  SeatLabelList.components(separatedBy: ",")
        }
        
        if let SeatsRemoved = details.object(forKey: "SeatsRemoved") as? String
        {
            seatsRemovedArray =  SeatsRemoved.components(separatedBy: ",")
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
            
            
            let backGroundImageView = UIImageView(frame:  CGRect(x: 0, y: postionY - barHeightSpace, width: mGridContainerView.frame.size.width, height: barHeight + barHeightSpace) )
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
                    let seatView = StudentSeatSubView(frame: CGRect(x: positionX, y: postionY, width: barWidthvalue, height: barHeight))
                    mGridContainerView.addSubview(seatView)
                    seatView.setdelegate(self)
                    seatView.tag = totalSeatvalue
                    seatView.backgroundColor = UIColor.clear
                }
                
                positionX = positionX + barWidthvalue + barWidthSpace
                totalSeatvalue = totalSeatvalue + 1
                
            }
            postionY = postionY + barHeight + barHeightSpace
            
        }
        
        
        
        if let sessionid = sessionDetails.object(forKey: RAPIConstants.SessionID.rawValue) as? Int
        {
            SSStudentDataSource.sharedDataSource.getSeatAssignmentofSession(String(sessionid), withDelegate: self)
        }
    }
    
    
    
    func didGetSeatAssignmentWithDetails(_ details: AnyObject) {
        
        if let  Status = details.object(forKey: "Status") as? String
        {
            if Status == "Success"
            {
                var studentsDetailsArray = NSMutableArray()
                
               if let classCheckingVariable = (details.object(forKey: "Students")! as AnyObject).object(forKey: "Student") as? NSMutableArray
               {
                     studentsDetailsArray = classCheckingVariable
                }
                else
                {
                    studentsDetailsArray.add((details.object(forKey: "Students")! as AnyObject).object(forKey: "Student")!)
                    
                }
                
                for index in 0 ..< studentsDetailsArray.count
                {
                    let studentsDetails = studentsDetailsArray.object(at: index)
                    
                    
                    if var SeatLabel = (studentsDetails as AnyObject).object(forKey: "SeatLabel") as? String
                    {
                        SeatLabel =  SeatLabel.replacingOccurrences(of: "A", with: "")
                        
                        if let studentDeskView  = mGridContainerView.viewWithTag(Int(SeatLabel)!) as? StudentSeatSubView {
                            studentDeskView.setStudentDetails(studentsDetails as AnyObject)
                        }
                    }
                }
                mGridContainerView.isHidden = false
                mNoStudentLabel.isHidden = true

            }
            else
            {
                mGridContainerView.isHidden = true
                mNoStudentLabel.isHidden = false
            }
        }
        
        
        
        
    }
    
    // MARK: - student Message handler 
    
    func smhDidGetSeatingChangedWithDetails(_ details: AnyObject)
    {
        for view:AnyObject in mGridContainerView.subviews.flatMap({ $0 as? StudentSeatSubView }){
            view.removeFromSuperview()
        }
        
        if let roomId = sessionDetails.object(forKey: RAPIConstants.RoomId.rawValue) as? Int {
            SSStudentDataSource.sharedDataSource.getGridDesignDetails(String(roomId), WithDelegate: self)
        }
    }
    
    
    // MARK: - seat view delegate handler
    
    func delegateStudentTileTouched() {
        let ClassViewController = StudentClassViewController()
        ClassViewController.setCurrentSessionDetails(sessionDetails)
        self.present(ClassViewController, animated: true, completion: nil)
    }
    
    
    func onBack() {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    func smhDidGetSessionEndMessageWithDetails(_ details: AnyObject) {
        let storyboard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let preallotController : SSStudentScheduleViewController = storyboard.instantiateViewController(withIdentifier: "TeacherScheduleViewController") as! SSStudentScheduleViewController
        self.present(preallotController, animated: true, completion: nil)
    }
   
    // MARK: - Leave class delegate handler
    
    func delegateSessionEnded() {
        let storyboard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let preallotController : SSStudentScheduleViewController = storyboard.instantiateViewController(withIdentifier: "TeacherScheduleViewController") as! SSStudentScheduleViewController
        self.present(preallotController, animated: true, completion: nil)
    }
    
    deinit {
        SSStudentDataSource.sharedDataSource.isBackgroundSignal.cancelAllSubscriptions()
    }
    
}
