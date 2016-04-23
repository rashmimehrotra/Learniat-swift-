//
//  PreallocateSeatViewController.swift
//  Learniat Teacher
//
//  Created by Deepak MK on 23/03/16.
//  Copyright © 2016 Mindshift. All rights reserved.
//

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
        mBackButton.addTarget(self, action: #selector(PreallocateSeatViewController.onBack), forControlEvents: UIControlEvents.TouchUpInside)
        mBackButton.contentHorizontalAlignment = UIControlContentHorizontalAlignment.Left
        
        
        let mPreallocateSeats = UILabel(frame: CGRectMake((mTopbarImageView.frame.size.width - 200)/2, 0, 200, mTopbarImageView.frame.size.height))
        mPreallocateSeats.font = UIFont(name:helveticaRegular, size: 20)
        mPreallocateSeats.text = "Preallot seats"
        mTopbarImageView.addSubview(mPreallocateSeats)
        mPreallocateSeats.textColor = UIColor.whiteColor()
        mPreallocateSeats.textAlignment = .Center

        
        
        let  mManually = UIButton(frame: CGRectMake(mTopbarImageView.frame.size.width - (mTopbarImageView.frame.size.height * 2), 0,mTopbarImageView.frame.size.height * 2,mTopbarImageView.frame.size.height ))
        mTopbarImageView.addSubview(mManually)
        mManually.setTitle("Manually", forState: .Normal)
        mManually.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        mManually.titleLabel?.font = UIFont(name: helveticaMedium, size: 18)
        mManually.addTarget(self, action: #selector(PreallocateSeatViewController.onManually), forControlEvents: UIControlEvents.TouchUpInside)
        
        
       let  mAutomatically = UIButton(frame: CGRectMake(mManually.frame.origin.x  - (mTopbarImageView.frame.size.height * 2), 0,mTopbarImageView.frame.size.height * 2,mTopbarImageView.frame.size.height ))
        mTopbarImageView.addSubview(mAutomatically)
        mAutomatically.setTitle("Automatically", forState: .Normal)
        mAutomatically.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        mAutomatically.titleLabel?.font = UIFont(name: helveticaMedium, size: 18)
        mAutomatically.addTarget(self, action: #selector(PreallocateSeatViewController.onAutomatically), forControlEvents: UIControlEvents.TouchUpInside)
        
        
        
        
        mGridContainerView.frame = CGRectMake(10, mTopbarImageView.frame.origin.y + mTopbarImageView.frame.size.height + 10 , self.view.frame.size.width - 20, self.view.frame.size.height - (mTopbarImageView.frame.origin.y + mTopbarImageView.frame.size.height) - 50 )
        self.view.addSubview(mGridContainerView)
        mGridContainerView.backgroundColor = whiteBackgroundColor
//        mGridContainerView.hidden = true
        
        
        
        let mclassRoomFront = UILabel(frame: CGRectMake(10,self.view.frame.size.height - 40 , self.view.frame.size.width,30))
        mclassRoomFront.font = UIFont(name:helveticaRegular, size: 20)
        mclassRoomFront.text = "Classroom front"
        self.view.addSubview(mclassRoomFront)
        mclassRoomFront.textColor = standard_Green
        mclassRoomFront.textAlignment = .Center
        
        
        mActivityIndicatore = UIActivityIndicatorView(activityIndicatorStyle: .Gray)
        mActivityIndicatore.frame = CGRectMake((self.view.frame.size.width - 40)/2, (self.view.frame.size.height - 40)/2, 40, 40)
        self.view.addSubview(mActivityIndicatore)
//        mActivityIndicatore.startAnimating()
        
        if let roomId = sessionDetails.objectForKey("RoomId") as? String
        {
            SSTeacherDataSource.sharedDataSource.getGridDesignDetails(roomId, WithDelegate: self)
        }
        
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
                    let seatView = PrealloatSeatSubView(frame: CGRectMake(positionX, postionY, barWidthvalue, barHeight))
                    mGridContainerView.addSubview(seatView)
                    seatView.backgroundColor = UIColor.clearColor()
                }
                
               positionX = positionX + barWidthvalue + barWidthSpace
               totalSeatvalue = totalSeatvalue - 1
                
            }
            postionY = postionY + barHeight + barHeightSpace
            
        }
        
    }
    
    
    func onBack()
    {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func onAutomatically()
    {
        let storyboard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let preallotController : AutoSeatAllocate = storyboard.instantiateViewControllerWithIdentifier("AutoSeatAllocate") as! AutoSeatAllocate
        
        preallotController.setCurrentSessionDetails(sessionDetails,withGridDetails: currentGridDetails)
        self.presentViewController(preallotController, animated: true, completion: nil)
    }
    
    func onManually()
    {
        
    }
    
}