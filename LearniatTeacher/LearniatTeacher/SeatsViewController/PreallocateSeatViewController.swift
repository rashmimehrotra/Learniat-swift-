//
//  PreallocateSeatViewController.swift
//  Learniat Teacher
//
//  Created by Deepak MK on 23/03/16.
//  Copyright © 2016 Mindshift. All rights reserved.
//


/*
    This class is used to display the grid selected by teacher with selected and deleted seats.
 */



import Foundation

class PreallocateSeatViewController: UIViewController,SSTeacherDataSourceDelegate
{
   
    var sessionDetails               :AnyObject!
    
    var currentGridDetails            :AnyObject!
    
    var mTopbarImageView             :UIImageView           = UIImageView()
    
    var mGridContainerView           :UIView                = UIView()
    
    var mActivityIndicatore          :UIActivityIndicatorView = UIActivityIndicatorView()
    
    
    var columnValue         = 1
    var rowValue            = 1
    var seatsIdArray        = [String]()
    var seatsLableArray     = [String]()
    var seatsRemovedArray   = [String]()
    
    var  mAutomatically = UIButton()
    
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
        mBackButton.addTarget(self, action: #selector(PreallocateSeatViewController.onBack), for: UIControlEvents.touchUpInside)
        mBackButton.contentHorizontalAlignment = UIControlContentHorizontalAlignment.left
        
        
        let mPreallocateSeats = UILabel(frame: CGRect(x: (mTopbarImageView.frame.size.width - 200)/2, y: 0, width: 200, height: mTopbarImageView.frame.size.height))
        mPreallocateSeats.font = UIFont(name:helveticaRegular, size: 20)
        mPreallocateSeats.text = "Preallot seats"
        mTopbarImageView.addSubview(mPreallocateSeats)
        mPreallocateSeats.textColor = UIColor.white
        mPreallocateSeats.textAlignment = .center

        
        
        let  mManually = UIButton(frame: CGRect(x: mTopbarImageView.frame.size.width - (mTopbarImageView.frame.size.height * 2), y: 0,width: mTopbarImageView.frame.size.height * 2,height: mTopbarImageView.frame.size.height ))
        mTopbarImageView.addSubview(mManually)
        mManually.setTitle("Manually", for: UIControlState())
        mManually.setTitleColor(lightGrayColor, for: UIControlState())
        mManually.titleLabel?.font = UIFont(name: helveticaMedium, size: 18)
        mManually.addTarget(self, action: #selector(PreallocateSeatViewController.onManually), for: UIControlEvents.touchUpInside)
        
        
        mAutomatically.frame = CGRect(x: mManually.frame.origin.x  - (mTopbarImageView.frame.size.height * 2), y: 0,width: mTopbarImageView.frame.size.height * 2,height: mTopbarImageView.frame.size.height )
        mTopbarImageView.addSubview(mAutomatically)
        mAutomatically.setTitle("Automatically", for: UIControlState())
        mAutomatically.setTitleColor(UIColor.white, for: UIControlState())
        mAutomatically.titleLabel?.font = UIFont(name: helveticaMedium, size: 18)
        mAutomatically.addTarget(self, action: #selector(PreallocateSeatViewController.onAutomatically), for: UIControlEvents.touchUpInside)
        mAutomatically.isEnabled = false
        
        
        
        mGridContainerView.frame = CGRect(x: 10, y: mTopbarImageView.frame.origin.y + mTopbarImageView.frame.size.height + 10 , width: self.view.frame.size.width - 20, height: self.view.frame.size.height - (mTopbarImageView.frame.origin.y + mTopbarImageView.frame.size.height) - 50 )
        self.view.addSubview(mGridContainerView)
        mGridContainerView.backgroundColor = whiteBackgroundColor
        
        
        
        let mclassRoomFront = UILabel(frame: CGRect(x: 10,y: self.view.frame.size.height - 40 , width: self.view.frame.size.width,height: 30))
        mclassRoomFront.font = UIFont(name:helveticaRegular, size: 20)
        mclassRoomFront.text = "Classroom front"
        self.view.addSubview(mclassRoomFront)
        mclassRoomFront.textColor = standard_Green
        mclassRoomFront.textAlignment = .center
        
        
        mActivityIndicatore = UIActivityIndicatorView(activityIndicatorStyle: .gray)
        mActivityIndicatore.frame = CGRect(x: (self.view.frame.size.width - 40)/2, y: (self.view.frame.size.height - 40)/2, width: 40, height: 40)
        self.view.addSubview(mActivityIndicatore)
//        mActivityIndicatore.startAnimating()
        
        if let roomId = sessionDetails.object(forKey: "RoomId") as? String
        {
            SSTeacherDataSource.sharedDataSource.getGridDesignDetails(roomId, WithDelegate: self)
        }
        
    }
    
    
    
    func setCurrentSessionDetails(_ details: AnyObject)
    {
        sessionDetails = details
        
        
    }
    
    
    
     // MARK: - datasource delegate Functions
    
    func didGetGridDesignWithDetails(_ details: AnyObject) {
        
        
        currentGridDetails = details
        
        mActivityIndicatore.stopAnimating()
        mActivityIndicatore.isHidden = true
        
       
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
                    let seatView = PrealloatSeatSubView(frame: CGRect(x: positionX, y: postionY, width: barWidthvalue, height: barHeight))
                    mGridContainerView.addSubview(seatView)
                    seatView.backgroundColor = UIColor.clear
                }
                
               positionX = positionX + barWidthvalue + barWidthSpace
               totalSeatvalue = totalSeatvalue - 1
                
            }
            postionY = postionY + barHeight + barHeightSpace
            
        }
        
        mAutomatically.isEnabled = true
        
    }
    
    
    func onBack()
    {
        self.dismiss(animated: true, completion: nil)
    }
    
    func onAutomatically()
    {
        let storyboard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let preallotController : AutoSeatAllocate = storyboard.instantiateViewController(withIdentifier: "AutoSeatAllocate") as! AutoSeatAllocate
        
        preallotController.setCurrentSessionDetails(sessionDetails,withGridDetails: currentGridDetails)
        self.present(preallotController, animated: true, completion: nil)
    }
    
    func onManually()
    {
        
    }
    
}
