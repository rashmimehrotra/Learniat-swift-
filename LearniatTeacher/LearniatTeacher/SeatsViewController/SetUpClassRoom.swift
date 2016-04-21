//
//  SetUpClassRoom.swift
//  GridView
//
//  Created by mindshift_Deepak on 15/04/16.
//  Copyright © 2016 mindShiftApps. All rights reserved.
//

import Foundation
import UIKit
class SetUpClassRoom: UIViewController,SetupClassCellDelegate,SSTeacherDataSourceDelegate
{
    

    
    var mTopbarImageView             :UIImageView           = UIImageView()
    
    var mGridContainerView           :UIView                = UIView()
    
    var mActivityIndicatore          :UIActivityIndicatorView = UIActivityIndicatorView()
    
    let  registerdStudentsLable     = UILabel()
    
    var currentColumnValue         = 1
    
    var currentRowValue            = 1
    
    var currentMiniumSeats         = 1
    
    var totalSelectedCells          = 1
    
    var seatIdString                = NSMutableArray()
    
    var _currentSessionDetails :AnyObject!
    
    let  mDoneButton = UIButton()
    
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
        mBackButton.addTarget(self, action: #selector(SetUpClassRoom.onBack), forControlEvents: UIControlEvents.TouchUpInside)
        mBackButton.contentHorizontalAlignment = UIControlContentHorizontalAlignment.Left
        
        
        let mPreallocateSeats = UILabel(frame: CGRectMake((mTopbarImageView.frame.size.width - 400)/2, 0, 400, mTopbarImageView.frame.size.height))
        mPreallocateSeats.font = UIFont(name:helveticaRegular, size: 20)
        mPreallocateSeats.text = "Setup classRoom seats "
        mTopbarImageView.addSubview(mPreallocateSeats)
        mPreallocateSeats.textColor = UIColor.whiteColor()
        mPreallocateSeats.textAlignment = .Center
        
        
        
        
        registerdStudentsLable.frame =  CGRectMake(10,mTopbarImageView.frame.size.height + 10 ,self.view.frame.size.width - 20 ,mTopbarImageView.frame.size.height)
        self.view.addSubview(registerdStudentsLable)
        registerdStudentsLable.font = UIFont (name: helveticaRegular, size: 18)
        registerdStudentsLable.textColor = blackTextColor
        registerdStudentsLable.textAlignment = .Center
        registerdStudentsLable.text = "YOU CAN REMOVE SEATS TO MATCH THE REAL LIFE CLASSROOM"
        
        
        
        mDoneButton.frame = CGRectMake(mTopbarImageView.frame.size.width - (mTopbarImageView.frame.size.height + 10), 0,mTopbarImageView.frame.size.height ,mTopbarImageView.frame.size.height )
        mTopbarImageView.addSubview(mDoneButton)
        mDoneButton.setTitle("Done", forState: .Normal)
        mDoneButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        mDoneButton.titleLabel?.font = UIFont(name: helveticaMedium, size: 18)
        mDoneButton.addTarget(self, action: #selector(SetUpClassRoom.onDoneButton), forControlEvents: UIControlEvents.TouchUpInside)
        
        
       
        mGridContainerView.frame = CGRectMake(10,(registerdStudentsLable.frame.origin.y + registerdStudentsLable.frame.size.height + 5) ,self.view.frame.size.width - 20 ,self.view.frame.size.height - (registerdStudentsLable.frame.origin.y + registerdStudentsLable.frame.size.height + 50))
        self.view.addSubview(mGridContainerView)
        mGridContainerView.backgroundColor = UIColor.clearColor()
        //        mGridContainerView.hidden = true
        
        
        
        let mclassRoomFront = UILabel(frame: CGRectMake(10,self.view.frame.size.height - 40 , self.view.frame.size.width,30))
        mclassRoomFront.font = UIFont(name:helveticaMedium, size: 30)
        mclassRoomFront.text = "Classroom front"
        self.view.addSubview(mclassRoomFront)
        mclassRoomFront.textColor = standard_Green
        mclassRoomFront.textAlignment = .Center
        
        addSeats()
        
        
        
        mActivityIndicatore = UIActivityIndicatorView(activityIndicatorStyle: .WhiteLarge)
        mActivityIndicatore.frame = mDoneButton.frame
        mTopbarImageView.addSubview(mActivityIndicatore)
        mActivityIndicatore.hidden = true

        
    }
    
    
    
    
    // MARK: - datasource delegate Functions
    
    func SetColumnValue(ColumnValue:Int , withRowvalue rowValue:Int, withMiniumSeats minSetas:Int, withCurrentSessionDetails SessionDetails:AnyObject )
    {
        
        currentColumnValue = ColumnValue
        
        currentRowValue = rowValue
        
        currentMiniumSeats = (currentColumnValue * currentRowValue) - minSetas
        
        _currentSessionDetails = SessionDetails
        
        
        
    }
    
    
    
    func addSeats()
    {
        
        
        var  barWidthvalue  :CGFloat = mGridContainerView.frame.size.width / CGFloat(currentColumnValue)
        
        let barWidthSpace :CGFloat = barWidthvalue * 0.2
        
        barWidthvalue = barWidthvalue * 0.8
        
        var barHeight   :CGFloat = mGridContainerView.frame.size.height / CGFloat(currentRowValue)
        
        let barHeightSpace:CGFloat = barHeight * 0.2
        
        barHeight = barHeight * 0.8
        
        
        var postionY :CGFloat = barHeightSpace / 2
        
        var totalSeatvalue  = currentRowValue * currentColumnValue
        
        for _ in 0 ..< currentRowValue 
        {
            
            var positionX :CGFloat = barWidthSpace / 2
            for _ in 0 ..< currentColumnValue 
            {
                let seatView = SetupClassCell(frame: CGRectMake(positionX, postionY, barWidthvalue, barHeight))
                mGridContainerView.addSubview(seatView)
                seatView.backgroundColor = UIColor.clearColor()
                seatView.setdelegate(self)
                positionX = positionX + barWidthvalue + barWidthSpace
                seatView.currentSeatString = "A\(totalSeatvalue)"
                
                
                
                totalSeatvalue = totalSeatvalue - 1
                
            }
            postionY = postionY + barHeight + barHeightSpace
            
        }

    }
    
    
    func onBack()
    {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func delegateCellPressedWithSelectedState(State: Bool, withCell seatCell: SetupClassCell) {
        
        
        
        if State == true
        {
            currentMiniumSeats = currentMiniumSeats + 1
            seatCell.EndCornerImageView.image = UIImage(named: "Remove.png")
            seatCell.refrenceDeskImageView.borderColor = standard_Red;
            
            if seatIdString.containsObject(seatCell.currentSeatString)
            {
                seatIdString.removeObject(seatCell.currentSeatString)
            }
            
            
            
            
        }
        else
        {
            
            if currentMiniumSeats > 0
            {
                currentMiniumSeats = currentMiniumSeats - 1
                seatCell.EndCornerImageView.image = UIImage(named: "Add.png")
                seatCell.refrenceDeskImageView.borderColor = standard_Green;
                
                
                if seatIdString.containsObject(seatCell.currentSeatString)
                {
                    
                }
                else
                {
                    seatIdString.addObject(seatCell.currentSeatString)
                }

               
            }
            else
            {
                let alert = UIAlertController(title: "Alert", message: "You can not delete more seats", preferredStyle: UIAlertControllerStyle.Alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
                self.presentViewController(alert, animated: true, completion: nil)

            }
            
        }
    }
    
    
    func onDoneButton()
    {
        
        mActivityIndicatore.hidden = false
        
        mDoneButton.hidden = true
        
        mActivityIndicatore.startAnimating()
        
        let seatsRemovedString = seatIdString.componentsJoinedByString(",")
        
        
        if let roomId = _currentSessionDetails.objectForKey("RoomId") as? String
        {
            SSTeacherDataSource.sharedDataSource.ConfigureSeatsWithRoomId(roomId, withRows: "\(currentRowValue)", withColumnValue: "\(currentColumnValue)", withRemovedSeats: seatsRemovedString, WithDelegate: self)
        }
        
        
    }
    
    
    func didGetSeatsConfiguredWithDetails(details: AnyObject)
    {
        
        mActivityIndicatore.hidden = true
        
        mDoneButton.hidden = false
        
        mActivityIndicatore.stopAnimating()
        
        
            let storyboard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let preallotController : PreallocateSeatViewController = storyboard.instantiateViewControllerWithIdentifier("PreallocateSeatViewController") as! PreallocateSeatViewController
    
            preallotController.setCurrentSessionDetails(_currentSessionDetails)
            self.presentViewController(preallotController, animated: true, completion: nil)
        

        
        
    }
    
    func didgetErrorMessage(message: String, WithServiceName serviceName: String)
    {
        mActivityIndicatore.hidden = true
        
        mDoneButton.hidden = true
        
        mActivityIndicatore.stopAnimating()
        
    }
    
}