//
//  TeacherScheduleViewController.swift
//  Learniat Teacher
//
//  Created by Deepak MK on 19/03/16.
//  Copyright © 2016 Mindshift. All rights reserved.
//

import Foundation
import UIKit

let oneHourDiff :CGFloat = 120.0

class TeacherScheduleViewController: UIViewController,SSTeacherDataSourceDelegate
{
    var mTeacherImageView: UIImageView!
   
    var mTopbarImageView: UIImageView!
    
    var mTeacherName: UILabel!
    
    var mRefreshButton: UIButton!
    
    
    var mNoSessionLabel: UILabel!
    
    var mNoSessionSubLabel:UILabel!
    
    var mScrollView:UIScrollView!
    
    var sessionDetailsArray:NSMutableArray = NSMutableArray()
    
    var positionsArray:Dictionary<String,CGFloat> = Dictionary()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.view.backgroundColor = whiteBackgroundColor
        
        
        self.view.setNeedsLayout()
        self.view.layoutIfNeeded()

        
        
        
        mTopbarImageView = UIImageView(frame: CGRectMake(0, 0, self.view.frame.size.width, (self.view.frame.size.height)/12))
        mTopbarImageView.backgroundColor = topbarColor
        self.view.addSubview(mTopbarImageView)
        
        mTeacherImageView = UIImageView(frame: CGRectMake(10, 15, mTopbarImageView.frame.size.height - 20 ,mTopbarImageView.frame.size.height - 20))
        mTeacherImageView.backgroundColor = lightGrayColor
        mTopbarImageView.addSubview(mTeacherImageView)
        mTeacherImageView.layer.masksToBounds = true
        mTeacherImageView.layer.cornerRadius = 3
        
        
        let urlString = NSUserDefaults.standardUserDefaults().objectForKey(k_INI_UserProfileImageURL) as! String
        
        if let checkedUrl = NSURL(string: "\(urlString)/\(SSTeacherDataSource.sharedDataSource.currentUserId)_79px.jpg")
        {
            mTeacherImageView.contentMode = .ScaleAspectFit
            mTeacherImageView.downloadImage(checkedUrl, withFolderType: folderType.ProFilePics)
        }

        
        
        
        
        mTeacherName = UILabel(frame: CGRectMake(mTeacherImageView.frame.origin.x + mTeacherImageView.frame.size.width + 10, 10, 200, 30))
        mTeacherName.font = UIFont(name:"HelveticaNeue-Medium", size: 20)
        mTeacherName.text = SSTeacherDataSource.sharedDataSource.currentUserName.capitalizedString
        mTopbarImageView.addSubview(mTeacherName)
        mTeacherName.textColor = UIColor.whiteColor()
        
        
        
        let mTeacher = UILabel(frame: CGRectMake(mTeacherImageView.frame.origin.x + mTeacherImageView.frame.size.width + 10, 40, 200, 20))
        mTeacher.font = UIFont(name:"HelveticaNeue", size: 16)
        mTeacher.text = "Teacher"
        mTopbarImageView.addSubview(mTeacher)
        mTeacher.textColor = UIColor.whiteColor()
        
        
        
        
        
        
        let mTodaysSchedule = UILabel(frame: CGRectMake((mTopbarImageView.frame.size.width - 200)/2, 15, 200, 20))
        mTodaysSchedule.font = UIFont(name:"HelveticaNeue-Medium", size: 20)
        mTodaysSchedule.text = "Today's schedule"
        mTopbarImageView.addSubview(mTodaysSchedule)
        mTodaysSchedule.textColor = UIColor.whiteColor()
        
        
        
        mRefreshButton = UIButton(frame: CGRectMake(mTopbarImageView.frame.size.width - mTopbarImageView.frame.size.height, 0,mTopbarImageView.frame.size.height,mTopbarImageView.frame.size.height ))
        mRefreshButton.setImage(UIImage(named: "refresh.png"), forState: .Normal)
        mTopbarImageView.addSubview(mRefreshButton)
        mRefreshButton.contentEdgeInsets = UIEdgeInsetsMake(10, 10, 10, 10);
        mRefreshButton.addTarget(self, action: "onRefreshButton:", forControlEvents: UIControlEvents.TouchUpInside)
        
       
        
        mNoSessionLabel = UILabel(frame: CGRectMake(10, (self.view.frame.size.height - 40)/2, self.view.frame.size.width - 20,40))
        mNoSessionLabel.font = UIFont(name:"HelveticaNeue-Medium", size: 30)
        mNoSessionLabel.text = "You do not have any sessions today!"
        self.view.addSubview(mNoSessionLabel)
        mNoSessionLabel.textColor = UIColor.blackColor()
        mNoSessionLabel.textAlignment = .Center
        
        
        mNoSessionSubLabel = UILabel(frame: CGRectMake(10, mNoSessionLabel.frame.origin.y + mNoSessionLabel.frame.size.height + 0, self.view.frame.size.width - 20,40))
        mNoSessionSubLabel.font = UIFont(name:"HelveticaNeue", size: 20)
        mNoSessionSubLabel.text = "Enjoy your day :)"
        self.view.addSubview(mNoSessionSubLabel)
        mNoSessionSubLabel.textColor = UIColor.blackColor()
        mNoSessionSubLabel.alpha = 0.5
        mNoSessionSubLabel.textAlignment = .Center
        
        
        
        
        mScrollView = UIScrollView(frame: CGRectMake(0,mTopbarImageView.frame.size.height,self.view.frame.size.width,self.view.frame.size.height - mTopbarImageView.frame.size.height))
        mScrollView.backgroundColor = whiteBackgroundColor
        self.view.addSubview(mScrollView)
        mScrollView.hidden = true
        
        SSTeacherDataSource.sharedDataSource.getScheduleOfTeacher(self)
        
        
        
        
        addNumberOfLinesToScrollView()
    }
    
    
    
    func addNumberOfLinesToScrollView()
    {
        var index: Int
        var positionY: CGFloat = 30
        var hourValue = 1
        for index = 0; index <= 24; ++index
        {
            let hourLineView = ScheduleScreenLineView()
            hourLineView.frame = CGRectMake(40, positionY, self.view.frame.size.width-40, 1)
            positionsArray[String("\(index)")] = positionY
            mScrollView.addSubview(hourLineView)
            
            let hourlabel = UILabel(frame: CGRectMake(5, positionY-10,30,20))
            
            mScrollView.addSubview(hourlabel)
            hourlabel.textColor = standard_TextGrey
            
            if index == 0
            {
                hourlabel.text = "\(12) AM"
            }
            else if index == 12
            {
                hourlabel.text = "Noon"
            }
            else if index < 12
            {
                hourlabel.text = "\(index) AM"
            }
            else if index > 12
            {
                hourlabel.text = "\(hourValue) PM"
                hourValue = hourValue+1
            }
            
            
            hourlabel.font = UIFont (name: "Roboto-Regular", size: 9)
            hourlabel.textAlignment = NSTextAlignment.Right
            
            
            if index != 24
            {
                let halfHourLineView =  DottedLine()
                halfHourLineView.frame = CGRectMake(45, positionY + (oneHourDiff/2), self.view.frame.size.width-50, 2)
                
                mScrollView.addSubview(halfHourLineView)
                halfHourLineView.drawDashedBorderAroundViewWithColor(UIColor(red: 153/255.0, green: 153/255.0, blue: 153/255.0, alpha: 1))
            }
            
            positionY = positionY + oneHourDiff
        }
        
        mScrollView.contentSize = CGSizeMake(0, positionY + oneHourDiff / 2 )
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func onRefreshButton(sender: AnyObject) {
    }
    
    
    // MARK: - Teacher datasource Error

    func didgetErrorMessage(message: String, WithServiceName serviceName: String)
    {
         self.view.makeToast(message, duration: 2.0, position: .Bottom)
    }
    
    // MARK: - Teacher datasource Delegate
    
    func didGetSchedulesWithDetials(details: AnyObject)
    {

        sessionDetailsArray.removeAllObjects()
        
        
        
        if let statusString = details.objectForKey("Status") as? String
        {
            if statusString == kSuccessString
            {
                mNoSessionLabel.hidden = true
                mNoSessionSubLabel.hidden = true
                mScrollView.hidden = false
                
                let classCheckingVariable = details.objectForKey(kSessions)!.objectForKey(kSubSession)!
                
                if classCheckingVariable.isKindOfClass(NSMutableArray)
                {
                    sessionDetailsArray = classCheckingVariable as! NSMutableArray
                }
                else
                {
                    sessionDetailsArray.addObject(details.objectForKey(kSessions)!.objectForKey(kSubSession)!)
                    
                }
            }
            else
            {
                mNoSessionLabel.hidden = false
                mNoSessionSubLabel.hidden = false
                mScrollView.hidden = true
            }
        }
    }
    

    
}