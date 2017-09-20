//
//  SetupGridview.swift
//  grdiView
//
//  Created by mindshift_Deepak on 14/04/16.
//  Copyright © 2016 mindShiftApps. All rights reserved.
//


/* 
    This class is called when user taps on configure grid button
 
	1. Fire Api “GetMaxStudentsRegistered” Api when user enter to this viewController.
	
	2. “GetMaxStudentsRegistered” Api returns number of max students, Using this calculate grid size required and automatically increase the size of the grid 	expander.
	
	3. If user taps on Done button then check if the grid configured is greater than total number of students returned in Api then fire Api “ConfigureGrid” 	with number of rows and columns
 
 */
 




import Foundation
import UIKit
import Darwin



class SetupGridview: UIViewController,SSTeacherDataSourceDelegate,UIAlertViewDelegate
{
     var mTopbarImageView             :UIImageView           = UIImageView()
    
    let  registerdStudentsLable     = UILabel()
    
    var containerView = UIView()
    
    var draggingView  = UIView()
    
    var cellSize = CGSize()
    
    let EndCornerImageView = UIImageView()
    
    let starCornerImage = UIImageView()
    
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
        
        mTopbarImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 60))
        mTopbarImageView.backgroundColor = topbarColor
        self.view.addSubview(mTopbarImageView)
        mTopbarImageView.isUserInteractionEnabled = true
        mTopbarImageView.isUserInteractionEnabled = true
        
        
        
        let  mBackButton = UIButton(frame: CGRect(x: 10, y: 0,width: mTopbarImageView.frame.size.height * 2,height: mTopbarImageView.frame.size.height ))
        mTopbarImageView.addSubview(mBackButton)
        mBackButton.setTitle("Back", for: UIControlState())
        mBackButton.setTitleColor(UIColor.white, for: UIControlState())
        mBackButton.titleLabel?.font = UIFont(name: helveticaMedium, size: 18)
        mBackButton.addTarget(self, action: #selector(SetupGridview.onBack), for: UIControlEvents.touchUpInside)
        mBackButton.contentHorizontalAlignment = UIControlContentHorizontalAlignment.left
        
        
        mDoneButton.frame = CGRect(x: mTopbarImageView.frame.size.width - ((mTopbarImageView.frame.size.height * 2) + 10), y: 0,width: mTopbarImageView.frame.size.height * 2,height: mTopbarImageView.frame.size.height )
        mTopbarImageView.addSubview(mDoneButton)
        mDoneButton.setTitle("Done", for: UIControlState())
        mDoneButton.setTitleColor(UIColor.white, for: UIControlState())
        mDoneButton.titleLabel?.font = UIFont(name: helveticaMedium, size: 18)
        mDoneButton.addTarget(self, action: #selector(SetupGridview.onDone), for: UIControlEvents.touchUpInside)
        mDoneButton.contentHorizontalAlignment = UIControlContentHorizontalAlignment.right
        mDoneButton.isHidden = true
        
        
        registerdStudentsLable.frame =  CGRect(x: 10,y: mTopbarImageView.frame.size.height + 10 ,width: self.view.frame.size.width - 20 ,height: mTopbarImageView.frame.size.height)
        self.view.addSubview(registerdStudentsLable)
        registerdStudentsLable.font = UIFont (name: helveticaRegular, size: 18)
        registerdStudentsLable.textColor = blackTextColor
        registerdStudentsLable.textAlignment = .center
        registerdStudentsLable.text = "YOU HAVE 0 STUDENTS REGISTERED FOR THIS CLASS. PLEASE SELECT A GRID WITH AT LEAST 0 SEATS"
        
        
        containerView.frame = CGRect(x: 20,y: (registerdStudentsLable.frame.origin.y + registerdStudentsLable.frame.size.height + 5) ,width: self.view.frame.size.width - 40 ,height: self.view.frame.size.height - (registerdStudentsLable.frame.origin.y + registerdStudentsLable.frame.size.height + 40))
        self.view.addSubview(containerView)
        
        
        
        containerView.addSubview(draggingView)
        draggingView.layer.borderColor = standard_Red.cgColor
        draggingView.layer.borderWidth = 2
        
        let edgePan = UIPanGestureRecognizer(target: self, action: #selector(SetupGridview.OnDragView(_:)))
        
        containerView.addGestureRecognizer(edgePan)
        
        
        
        
        containerView.addSubview(cellDraggedCountValue)
        cellDraggedCountValue.font = UIFont (name: helveticaRegular, size: 18)
        cellDraggedCountValue.textColor = UIColor.white
        cellDraggedCountValue.backgroundColor = standard_Red
        cellDraggedCountValue.textAlignment = .center
        cellDraggedCountValue.layer.cornerRadius = 13
        cellDraggedCountValue.layer.masksToBounds = true
        cellDraggedCountValue.text = "1"
       
        
        starCornerImage.image = UIImage(named: "Circle_Red.png")
        containerView.addSubview(starCornerImage)
        
        
        EndCornerImageView.image = UIImage(named: "Circle_Red.png")
        containerView.addSubview(EndCornerImageView)
        
        
        addGridView()
        
        mActivityIndicatore = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
        mActivityIndicatore.frame = mDoneButton.frame
        mTopbarImageView.addSubview(mActivityIndicatore)
        mActivityIndicatore.startAnimating()

        
        if let roomId = _currentSessionDetails.object(forKey: "RoomId") as? String
        {
            SSTeacherDataSource.sharedDataSource.getMaxStudentRegisterdwiRoomId(roomId, WithDelegate: self)
        }
        
        
        
    }
    
    
    func setCurrentSessionDetails(_ sessionDetails:AnyObject)
    {
        _currentSessionDetails = sessionDetails
    }
    
    
    func didGetMaxStudentsRegistedWithDetails(_ details: AnyObject) {
        
        if let maxRegStudents = details.object(forKey: "StudentsRegistered" ) as? NSString
        {
            miniumSeats = maxRegStudents.integerValue
            mActivityIndicatore.stopAnimating()
            mActivityIndicatore.isHidden = true
            mDoneButton.isHidden = false
            registerdStudentsLable.text = "YOU HAVE \(maxRegStudents) STUDENTS REGISTERED FOR THIS CLASS. PLEASE SELECT A GRID WITH AT LEAST \(maxRegStudents) SEATS"
            let  squrtFun = sqrt(maxRegStudents.floatValue)
           
            
            
            UIView.animate(withDuration: 0.2, animations:
                {
                    
                    if (squrtFun - floor(squrtFun) < 0.5)
                    {
                         self.draggingView.frame =  CGRect(x: 0, y: 0, width: self.cellSize.width * CGFloat((squrtFun + 1)) , height: self.cellSize.height * CGFloat(squrtFun))
                    }
                    else
                    {
                         self.draggingView.frame =  CGRect(x: 0, y: 0, width: self.cellSize.width * CGFloat(squrtFun) , height: self.cellSize.height * CGFloat(squrtFun))
                    }
                    
              
            })
            
            let cellColumnValue = draggingView.frame.size.width / cellSize.width
            
            let cellRowValue = draggingView.frame.size.height / cellSize.height
            
            
            
            let totalSeats = round(cellRowValue) * round(cellColumnValue)
            
            cellDraggedCountValue.text = "\(Float(totalSeats).cleanValue)"
            
            if Int(totalSeats) >= miniumSeats
            {
                draggingView.layer.borderColor = standard_Green.cgColor
                cellDraggedCountValue.backgroundColor = standard_Green
                EndCornerImageView.image = UIImage(named: "Circle_Green.png")
                 starCornerImage.image = UIImage(named: "Circle_Green.png")
            }
            else
            {
                draggingView.layer.borderColor = standard_Red.cgColor
                cellDraggedCountValue.backgroundColor = standard_Red
                EndCornerImageView.image = UIImage(named: "Circle_Red.png")
                starCornerImage.image = UIImage(named: "Circle_Red.png")
            }
            
            
            roundOffDragView()
            
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
            present(_setupGrid, animated: true, completion: nil)
        }
        else
        {
            
            let alert = UIAlertController(title: "Alert", message: "Select at least a grid with \(miniumSeats) boxes", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            
        }
        
    }
    
    func onBack()
    {
        dismiss(animated: true, completion: nil)
    }

    
    func addGridView()
    {
        let  barWidthvalue  :CGFloat = containerView.frame.size.width / CGFloat(columnValue)
        
        
        let barHeight   :CGFloat = containerView.frame.size.height / CGFloat(rowValue)
        
        
        var postionY :CGFloat = 0
        
        var totalSeatvalue  = rowValue * columnValue
        
        
        
        
        for _ in 0 ..< rowValue 
        {
            
            var positionX :CGFloat = 0
            for _ in 0 ..< columnValue 
            {
                
                    let seatView = UIImageView(frame: CGRect(x: positionX, y: postionY, width: barWidthvalue, height: barHeight))
                    cellSize = seatView.frame.size
                    containerView.addSubview(seatView)
                    seatView.layer.borderColor = LineGrayColor.cgColor
                    seatView.layer.borderWidth = 1
                
                positionX = positionX + barWidthvalue
                totalSeatvalue = totalSeatvalue - 1
                
            }
            postionY = postionY + barHeight
            
        }
        
        draggingView.frame = CGRect(x: 0, y: 0, width: cellSize.width, height: cellSize.height)
        EndCornerImageView.frame = CGRect(x: draggingView.frame.size.width - 22, y: draggingView.frame.size.height - 22, width: 40, height: 40)
        starCornerImage.frame = CGRect(x: -18,y: -18, width: 40, height: 40)
        cellDraggedCountValue.frame =  CGRect(x: draggingView.frame.size.width - 20 , y: -10 ,width: 40 ,height: 25)
        containerView.bringSubview(toFront: draggingView)
        containerView.bringSubview(toFront: cellDraggedCountValue)
        containerView.bringSubview(toFront: EndCornerImageView)
        containerView.bringSubview(toFront: starCornerImage)
        
        

    }
    
    func OnDragView(_ recognizer: UIPanGestureRecognizer)
    {
        if recognizer.state == UIGestureRecognizerState.changed
        {
            let translation = recognizer.location(in: containerView)
            chnagedFrameWithPoint(translation)
        }
        else if recognizer.state == UIGestureRecognizerState.changed
        {
            let translation = recognizer.location(in: containerView)
            chnagedFrameWithPoint(translation)
        }
        else if recognizer.state == UIGestureRecognizerState.ended
        {
            roundOffDragView()
        }
        
    }
    
    
    
    func chnagedFrameWithPoint(_ _translation:CGPoint)
    {
        var translation = _translation
        
        if translation.x < cellSize.width
        {
            translation.x = cellSize.width
        }
        if translation.y < cellSize.height
        {
            translation.y = cellSize.height
        }
        
        
        draggingView.frame = CGRect(x: 0, y: 0, width: translation.x,height: translation.y)
        
        EndCornerImageView.frame = CGRect(x: draggingView.frame.size.width - 22, y: draggingView.frame.size.height - 22, width: 40, height: 40)
        starCornerImage.frame = CGRect(x: -18,y: -18, width: 40, height: 40)
        cellDraggedCountValue.frame =  CGRect(x: draggingView.frame.size.width - 20 , y: -10 ,width: 40 ,height: 25)
        
        let cellColumnValue = draggingView.frame.size.width / cellSize.width
        
        let cellRowValue = draggingView.frame.size.height / cellSize.height
        
        
        
        let totalSeats = round(cellRowValue) * round(cellColumnValue)
        
        cellDraggedCountValue.text = "\(Float(totalSeats).cleanValue)"
        
        
        if Int(totalSeats) >= miniumSeats
        {
            draggingView.layer.borderColor = standard_Green.cgColor
            cellDraggedCountValue.backgroundColor = standard_Green
            EndCornerImageView.image = UIImage(named: "Circle_Green.png")
            starCornerImage.image = UIImage(named: "Circle_Green.png")
            
        }
        else
        {
            draggingView.layer.borderColor = standard_Red.cgColor
            cellDraggedCountValue.backgroundColor = standard_Red
            EndCornerImageView.image = UIImage(named: "Circle_Red.png")
            starCornerImage.image = UIImage(named: "Circle_Red.png")
        }
        
        
        
        
        
        
    }
    
    func roundOffDragView()
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
        
        
        UIView.animate(withDuration: 0.2, animations:
            {
           self.draggingView.frame = CGRect(x: 0, y: 0, width: CGFloat(cellColumnValue) * self.cellSize.width ,height: CGFloat(cellRowValue) * self.cellSize.height)
            self.EndCornerImageView.frame = CGRect(x: self.draggingView.frame.size.width - 22, y: self.draggingView.frame.size.height - 22, width: 40, height: 40)
            
            self.starCornerImage.frame = CGRect(x: -18,y: -18, width: 40, height: 40)
            
            self.cellDraggedCountValue.frame =  CGRect(x: self.draggingView.frame.size.width - 20 , y: -10 ,width: 40 ,height: 25)
        })

        
        
        
       
        
        let totalSeats = round(cellRowValue) * round(cellColumnValue)
        
        if Int(totalSeats) >= miniumSeats
        {
            draggingView.layer.borderColor = standard_Green.cgColor
            cellDraggedCountValue.backgroundColor = standard_Green
            EndCornerImageView.image = UIImage(named: "Circle_Green.png")
            starCornerImage.image = UIImage(named: "Circle_Green.png")
        }
        else
        {
            draggingView.layer.borderColor = standard_Red.cgColor
            cellDraggedCountValue.backgroundColor = standard_Red
            EndCornerImageView.image = UIImage(named: "Circle_Red.png")
            starCornerImage.image = UIImage(named: "Circle_Red.png")
        }
        
        
        numberOfColumns = Int(cellColumnValue)
        
        numberOfRows = Int(cellRowValue)
        
    }
    
    
    
    
}





extension Float {
    var cleanValue: String {
        return self.truncatingRemainder(dividingBy: 1) == 0 ? String(format: "%.0f", self) : String(self)
    }
}
