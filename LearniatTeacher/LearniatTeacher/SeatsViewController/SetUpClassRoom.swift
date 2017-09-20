//
//  SetUpClassRoom.swift
//  GridView
//
//  Created by mindshift_Deepak on 15/04/16.
//  Copyright © 2016 mindShiftApps. All rights reserved.
//


/* 
 
 This class is called after the grid is created
 
	1. Fire Api “GetMaxStudentsRegistered” Api when user enter to this viewController.
	
    2. when user taps on add or remove button in each cell then check remaining calculate remaining cell count is greater than maxStudents if is it less then show alert
 */
 
 


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
        mBackButton.addTarget(self, action: #selector(SetUpClassRoom.onBack), for: UIControlEvents.touchUpInside)
        mBackButton.contentHorizontalAlignment = UIControlContentHorizontalAlignment.left
        
        
        let mPreallocateSeats = UILabel(frame: CGRect(x: (mTopbarImageView.frame.size.width - 400)/2, y: 0, width: 400, height: mTopbarImageView.frame.size.height))
        mPreallocateSeats.font = UIFont(name:helveticaRegular, size: 20)
        mPreallocateSeats.text = "Setup classRoom seats "
        mTopbarImageView.addSubview(mPreallocateSeats)
        mPreallocateSeats.textColor = UIColor.white
        mPreallocateSeats.textAlignment = .center
        
        
        
        
        registerdStudentsLable.frame =  CGRect(x: 10,y: mTopbarImageView.frame.size.height + 10 ,width: self.view.frame.size.width - 20 ,height: mTopbarImageView.frame.size.height)
        self.view.addSubview(registerdStudentsLable)
        registerdStudentsLable.font = UIFont (name: helveticaRegular, size: 18)
        registerdStudentsLable.textColor = blackTextColor
        registerdStudentsLable.textAlignment = .center
        registerdStudentsLable.text = "YOU CAN REMOVE SEATS TO MATCH THE REAL LIFE CLASSROOM"
        
        
        
        mDoneButton.frame = CGRect(x: mTopbarImageView.frame.size.width - (mTopbarImageView.frame.size.height + 10), y: 0,width: mTopbarImageView.frame.size.height ,height: mTopbarImageView.frame.size.height )
        mTopbarImageView.addSubview(mDoneButton)
        mDoneButton.setTitle("Done", for: UIControlState())
        mDoneButton.setTitleColor(UIColor.white, for: UIControlState())
        mDoneButton.titleLabel?.font = UIFont(name: helveticaMedium, size: 18)
        mDoneButton.addTarget(self, action: #selector(SetUpClassRoom.onDoneButton), for: UIControlEvents.touchUpInside)
        
        
       
        mGridContainerView.frame = CGRect(x: 10,y: (registerdStudentsLable.frame.origin.y + registerdStudentsLable.frame.size.height + 5) ,width: self.view.frame.size.width - 20 ,height: self.view.frame.size.height - (registerdStudentsLable.frame.origin.y + registerdStudentsLable.frame.size.height + 50))
        self.view.addSubview(mGridContainerView)
        mGridContainerView.backgroundColor = UIColor.clear
        //        mGridContainerView.hidden = true
        
        
        
        let mclassRoomFront = UILabel(frame: CGRect(x: 10,y: self.view.frame.size.height - 40 , width: self.view.frame.size.width,height: 30))
        mclassRoomFront.font = UIFont(name:helveticaMedium, size: 30)
        mclassRoomFront.text = "Classroom front"
        self.view.addSubview(mclassRoomFront)
        mclassRoomFront.textColor = standard_Green
        mclassRoomFront.textAlignment = .center
        
        addSeats()
        
        
        
        mActivityIndicatore = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
        mActivityIndicatore.frame = mDoneButton.frame
        mTopbarImageView.addSubview(mActivityIndicatore)
        mActivityIndicatore.isHidden = true

        
    }
    
    
    
    
    // MARK: - datasource delegate Functions
    
    func SetColumnValue(_ ColumnValue:Int , withRowvalue rowValue:Int, withMiniumSeats minSetas:Int, withCurrentSessionDetails SessionDetails:AnyObject )
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
                let seatView = SetupClassCell(frame: CGRect(x: positionX, y: postionY, width: barWidthvalue, height: barHeight))
                mGridContainerView.addSubview(seatView)
                seatView.backgroundColor = UIColor.clear
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
        self.dismiss(animated: true, completion: nil)
    }
    
    func delegateCellPressedWithSelectedState(_ State: Bool, withCell seatCell: SetupClassCell) {
        
        
        
        if State == true
        {
            currentMiniumSeats = currentMiniumSeats + 1
            seatCell.EndCornerImageView.image = UIImage(named: "Remove.png")
            seatCell.refrenceDeskImageView.borderColor = standard_Red;
            
            if seatIdString.contains(seatCell.currentSeatString)
            {
                seatIdString.remove(seatCell.currentSeatString)
            }
            
            
            
            
        }
        else
        {
            
            if currentMiniumSeats > 0
            {
                currentMiniumSeats = currentMiniumSeats - 1
                seatCell.EndCornerImageView.image = UIImage(named: "Add.png")
                seatCell.refrenceDeskImageView.borderColor = standard_Green;
                
                
                if seatIdString.contains(seatCell.currentSeatString)
                {
                    
                }
                else
                {
                    seatIdString.add(seatCell.currentSeatString)
                }

               
            }
            else
            {
                let alert = UIAlertController(title: "Alert", message: "You cannot delete more seats", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                self.present(alert, animated: true, completion: nil)

            }
            
        }
    }
    
    
    func onDoneButton()
    {
        
        mActivityIndicatore.isHidden = false
        
        mDoneButton.isHidden = true
        
        mActivityIndicatore.startAnimating()
        
        let seatsRemovedString = seatIdString.componentsJoined(by: ",")
        
        
        if let roomId = _currentSessionDetails.object(forKey: "RoomId") as? String
        {
            SSTeacherDataSource.sharedDataSource.ConfigureSeatsWithRoomId(roomId, withRows: "\(currentRowValue)", withColumnValue: "\(currentColumnValue)", withRemovedSeats: seatsRemovedString, WithDelegate: self)
        }
        
        
    }
    
    
    func didGetSeatsConfiguredWithDetails(_ details: AnyObject)
    {
        
        mActivityIndicatore.isHidden = true
        
        mDoneButton.isHidden = false
        
        mActivityIndicatore.stopAnimating()
        
        
            let storyboard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let preallotController : PreallocateSeatViewController = storyboard.instantiateViewController(withIdentifier: "PreallocateSeatViewController") as! PreallocateSeatViewController
    
            preallotController.setCurrentSessionDetails(_currentSessionDetails)
            self.present(preallotController, animated: true, completion: nil)
        

        
        
    }
    
    func didgetErrorMessage(_ message: String, WithServiceName serviceName: String)
    {
        mActivityIndicatore.isHidden = true
        
        mDoneButton.isHidden = true
        
        mActivityIndicatore.stopAnimating()
        
    }
    
}
