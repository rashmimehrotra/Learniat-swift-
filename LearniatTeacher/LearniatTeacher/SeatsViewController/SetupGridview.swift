//
//  SetupGridview.swift
//  grdiView
//
//  Created by mindshift_Deepak on 14/04/16.
//  Copyright © 2016 mindShiftApps. All rights reserved.
//

import Foundation
import UIKit





class SetupGridview: UIViewController,SSTeacherDataSourceDelegate,UIAlertViewDelegate
{
     var mTopbarImageView             :UIImageView           = UIImageView()
    
    let  registerdStudentsLable     = UILabel()
    
    var containerView = UIView()
    
    var draggingView  = UIView()
    
    var cellSize = CGSize()
    
    let EndCornerImageView = UIImageView()
    
    
    let cellDraggedCountValue  = UILabel()
    
    var _currentSessionDetails  :AnyObject!
    
    let columnValue  = 9
    
    let rowValue     = 9
    
    let  mDoneButton = UIButton()
    
    var numberOfRows = 1
    
    var numberOfColumns = 1
    
    var miniumSeats = 0
    
    var mActivityIndicatore          :UIActivityIndicatorView = UIActivityIndicatorView()
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.view.backgroundColor = whiteBackgroundColor
        
        mTopbarImageView = UIImageView(frame: CGRectMake(0, 0, self.view.frame.size.width, 60))
        mTopbarImageView.backgroundColor = topbarColor
        self.view.addSubview(mTopbarImageView)
        mTopbarImageView.userInteractionEnabled = true
        mTopbarImageView.userInteractionEnabled = true
        
        
        
        let  mBackButton = UIButton(frame: CGRectMake(10, 0,mTopbarImageView.frame.size.height * 2,mTopbarImageView.frame.size.height ))
        mTopbarImageView.addSubview(mBackButton)
        mBackButton.setTitle("Back", forState: .Normal)
        mBackButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        mBackButton.titleLabel?.font = UIFont(name: helveticaMedium, size: 18)
        mBackButton.addTarget(self, action: "onBack", forControlEvents: UIControlEvents.TouchUpInside)
        mBackButton.contentHorizontalAlignment = UIControlContentHorizontalAlignment.Left
        
        
        mDoneButton.frame = CGRectMake(mTopbarImageView.frame.size.width - ((mTopbarImageView.frame.size.height * 2) + 10), 0,mTopbarImageView.frame.size.height * 2,mTopbarImageView.frame.size.height )
        mTopbarImageView.addSubview(mDoneButton)
        mDoneButton.setTitle("Done", forState: .Normal)
        mDoneButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        mDoneButton.titleLabel?.font = UIFont(name: helveticaMedium, size: 18)
        mDoneButton.addTarget(self, action: "onDone", forControlEvents: UIControlEvents.TouchUpInside)
        mDoneButton.contentHorizontalAlignment = UIControlContentHorizontalAlignment.Right
        mDoneButton.hidden = true
        
        
        registerdStudentsLable.frame =  CGRectMake(10,mTopbarImageView.frame.size.height + 10 ,self.view.frame.size.width - 20 ,mTopbarImageView.frame.size.height)
        self.view.addSubview(registerdStudentsLable)
        registerdStudentsLable.font = UIFont (name: helveticaRegular, size: 18)
        registerdStudentsLable.textColor = blackTextColor
        registerdStudentsLable.textAlignment = .Center
        registerdStudentsLable.text = "YOU HAVE 0 STUDENTS REGISTERED FOR THIS CLASS. PLEASE SELECT A GRID WITH AT LEAST 0 SEATS"
        
        
        containerView.frame = CGRectMake(10,(registerdStudentsLable.frame.origin.y + registerdStudentsLable.frame.size.height + 5) ,self.view.frame.size.width - 20 ,self.view.frame.size.height - (registerdStudentsLable.frame.origin.y + registerdStudentsLable.frame.size.height + 40))
        self.view.addSubview(containerView)
        
        
        
        containerView.addSubview(draggingView)
        draggingView.layer.borderColor = standard_Red.CGColor
        draggingView.layer.borderWidth = 2
        
        let edgePan = UIPanGestureRecognizer(target: self, action: "OnDragView:")
        
        draggingView.addGestureRecognizer(edgePan)
        
        
        
        
        containerView.addSubview(cellDraggedCountValue)
        cellDraggedCountValue.font = UIFont (name: helveticaRegular, size: 18)
        cellDraggedCountValue.textColor = UIColor.whiteColor()
        cellDraggedCountValue.backgroundColor = standard_Red
        cellDraggedCountValue.textAlignment = .Center
        cellDraggedCountValue.layer.cornerRadius = 13
        cellDraggedCountValue.layer.masksToBounds = true
        cellDraggedCountValue.text = "1"
        
        EndCornerImageView.image = UIImage(named: "Circle_Red.png")
        containerView.addSubview(EndCornerImageView)
        
        
        addGridView()
        
        mActivityIndicatore = UIActivityIndicatorView(activityIndicatorStyle: .WhiteLarge)
        mActivityIndicatore.frame = mDoneButton.frame
        mTopbarImageView.addSubview(mActivityIndicatore)
        mActivityIndicatore.startAnimating()

        
        if let roomId = _currentSessionDetails.objectForKey("RoomId") as? String
        {
            SSTeacherDataSource.sharedDataSource.getMaxStudentRegisterdwiRoomId(roomId, WithDelegate: self)
        }
        
        
        
    }
    
    
    func setCurrentSessionDetails(sessionDetails:AnyObject)
    {
        _currentSessionDetails = sessionDetails
    }
    
    
    func didGetMaxStudentsRegistedWithDetails(details: AnyObject) {
        
        if let maxRegStudents = details.objectForKey("StudentsRegistered" ) as? NSString
        {
            miniumSeats = maxRegStudents.integerValue
            mActivityIndicatore.stopAnimating()
            mActivityIndicatore.hidden = true
            mDoneButton.hidden = false
            registerdStudentsLable.text = "YOU HAVE \(maxRegStudents) STUDENTS REGISTERED FOR THIS CLASS. PLEASE SELECT A GRID WITH AT LEAST \(maxRegStudents) SEATS"
            
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func onDone()
    {
        
        let totalSeats = numberOfColumns * numberOfRows
        
        if Int(totalSeats) >= miniumSeats
        {
            let _setupGrid = SetUpClassRoom()
            _setupGrid.SetColumnValue(numberOfColumns, withRowvalue:numberOfRows,withMiniumSeats: miniumSeats,withCurrentSessionDetails:_currentSessionDetails)
            presentViewController(_setupGrid, animated: true, completion: nil)
        }
        else
        {
            
            let alert = UIAlertController(title: "Alert", message: "Select at least a grid with \(miniumSeats) boxes", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
            
        }
        
    }
    
    func onBack()
    {
        dismissViewControllerAnimated(true, completion: nil)
    }

    
    func addGridView()
    {
        let  barWidthvalue  :CGFloat = containerView.frame.size.width / CGFloat(columnValue)
        
        
        let barHeight   :CGFloat = containerView.frame.size.height / CGFloat(rowValue)
        
        
        var postionY :CGFloat = 0
        
        var totalSeatvalue  = rowValue * columnValue
        
        
        
        
        for var columnIndex = 0; columnIndex < rowValue ; columnIndex++
        {
            
            var positionX :CGFloat = 0
            for var rowIndex = 0; rowIndex < columnValue ; rowIndex++
            {
                
                    let seatView = UIImageView(frame: CGRectMake(positionX, postionY, barWidthvalue, barHeight))
                    cellSize = seatView.frame.size
                    containerView.addSubview(seatView)
                    seatView.layer.borderColor = LineGrayColor.CGColor
                    seatView.layer.borderWidth = 1
                
                positionX = positionX + barWidthvalue
                totalSeatvalue = totalSeatvalue - 1
                
            }
            postionY = postionY + barHeight
            
        }
        
        draggingView.frame = CGRectMake(0, 0, cellSize.width, cellSize.height)
        EndCornerImageView.frame = CGRectMake(draggingView.frame.size.width - 22, draggingView.frame.size.height - 22, 40, 40)
        cellDraggedCountValue.frame =  CGRectMake(draggingView.frame.size.width - 20 , -10 ,40 ,25)
        containerView.bringSubviewToFront(draggingView)
        containerView.bringSubviewToFront(cellDraggedCountValue)
        

    }
    
    func OnDragView(recognizer: UIPanGestureRecognizer)
    {
        
    
        
        if recognizer.state == UIGestureRecognizerState.Changed
        {
            
            var translation = recognizer.locationInView(containerView)
           
            if translation.x < cellSize.width
            {
                translation.x = cellSize.width
            }
            if translation.y < cellSize.height
            {
                translation.y = cellSize.height
            }
            
            
             draggingView.frame = CGRectMake(0, 0, translation.x,translation.y)
            
             EndCornerImageView.frame = CGRectMake(draggingView.frame.size.width - 22, draggingView.frame.size.height - 22, 40, 40)
            cellDraggedCountValue.frame =  CGRectMake(draggingView.frame.size.width - 20 , -10 ,40 ,25)
            
            let cellColumnValue = draggingView.frame.size.width / cellSize.width
            
            let cellRowValue = draggingView.frame.size.height / cellSize.height

            
            
            let totalSeats = round(cellRowValue) * round(cellColumnValue)
            
            cellDraggedCountValue.text = "\(Float(totalSeats).cleanValue)"
            
            
            if Int(totalSeats) >= miniumSeats
            {
                draggingView.layer.borderColor = standard_Green.CGColor
              cellDraggedCountValue.backgroundColor = standard_Green
                EndCornerImageView.image = UIImage(named: "Circle_Green.png")
            }
            else
            {
                draggingView.layer.borderColor = standard_Red.CGColor
                 cellDraggedCountValue.backgroundColor = standard_Red
                  EndCornerImageView.image = UIImage(named: "Circle_Red.png")
            }
            
            
            
            
            
        
        }
        else if recognizer.state == UIGestureRecognizerState.Ended
        {
            
            
            var cellColumnValue = round(draggingView.frame.size.width / cellSize.width)
            
            var cellRowValue = round(draggingView.frame.size.height / cellSize.height)
            
            
            if cellColumnValue <= 0
            {
                cellColumnValue = 1
            }
            if cellRowValue <= 0
            {
                cellRowValue = 1
            }
            
            draggingView.frame = CGRectMake(0, 0, CGFloat(cellColumnValue) * cellSize.width ,CGFloat(cellRowValue) * cellSize.height)
            
            EndCornerImageView.frame = CGRectMake(draggingView.frame.size.width - 22, draggingView.frame.size.height - 22, 40, 40)
            cellDraggedCountValue.frame =  CGRectMake(draggingView.frame.size.width - 20 , -10 ,40 ,25)
            
             let totalSeats = round(cellRowValue) * round(cellColumnValue)
            
            if Int(totalSeats) >= miniumSeats
            {
                draggingView.layer.borderColor = standard_Green.CGColor
                cellDraggedCountValue.backgroundColor = standard_Green
                EndCornerImageView.image = UIImage(named: "Circle_Green.png")
            }
            else
            {
                draggingView.layer.borderColor = standard_Red.CGColor
                cellDraggedCountValue.backgroundColor = standard_Red
                EndCornerImageView.image = UIImage(named: "Circle_Red.png")
            }

            
            numberOfColumns = Int(cellColumnValue)
            
            numberOfRows = Int(cellRowValue)

        }
        
    }
    
    
    
    
    
    
    
}


extension Float {
    var cleanValue: String {
        return self % 1 == 0 ? String(format: "%.0f", self) : String(self)
    }
}
