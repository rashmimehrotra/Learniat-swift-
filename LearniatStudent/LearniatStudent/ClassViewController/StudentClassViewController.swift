//
//  StudentClassViewController.swift
//  LearniatStudent
//
//  Created by Deepak MK on 22/04/16.
//  Copyright © 2016 Mindshift. All rights reserved.
//

import Foundation
class StudentClassViewController: UIViewController,SSStudentDataSourceDelegate,SSStudentMessageHandlerDelegate
{
    
    var sessionDetails               :AnyObject!
    
    var mTopbarImageView             :UIImageView           = UIImageView()
    
    
    var mTeacherImageView: UIImageView!
    
    var mTeacherName: UILabel!
    
    var mNoStudentLabel = UILabel()
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        
        self.view.backgroundColor = darkBackgroundColor
        
        SSStudentMessageHandler.sharedMessageHandler.setdelegate(self)
        
        mTopbarImageView = UIImageView(frame: CGRectMake(0, 0, self.view.frame.size.width, (self.view.frame.size.height)/12))
        mTopbarImageView.backgroundColor = topbarColor
        self.view.addSubview(mTopbarImageView)
        mTopbarImageView.userInteractionEnabled = true
        mTopbarImageView.userInteractionEnabled = true
        
        
        
        mTeacherImageView = UIImageView(frame: CGRectMake(15, 15, mTopbarImageView.frame.size.height - 20 ,mTopbarImageView.frame.size.height - 20))
        mTeacherImageView.backgroundColor = lightGrayColor
        mTopbarImageView.addSubview(mTeacherImageView)
        mTeacherImageView.layer.masksToBounds = true
        mTeacherImageView.layer.cornerRadius = 2
        
        
        let urlString = NSUserDefaults.standardUserDefaults().objectForKey(k_INI_UserProfileImageURL) as! String
        
        if let checkedUrl = NSURL(string: "\(urlString)/\(SSStudentDataSource.sharedDataSource.currentUserId)_79px.jpg")
        {
            mTeacherImageView.contentMode = .ScaleAspectFit
            mTeacherImageView.downloadImage(checkedUrl, withFolderType: folderType.ProFilePics)
        }
        
        
        
        
        
        mTeacherName = UILabel(frame: CGRectMake(mTeacherImageView.frame.origin.x + mTeacherImageView.frame.size.width + 10, mTeacherImageView.frame.origin.y, 200, 20))
        mTeacherName.font = UIFont(name:helveticaMedium, size: 20)
        mTeacherName.text = SSStudentDataSource.sharedDataSource.currentUserName.capitalizedString
        mTopbarImageView.addSubview(mTeacherName)
        mTeacherName.textColor = UIColor.whiteColor()
        
        
        
        
        
        let mPreallocateSeats = UILabel(frame: CGRectMake((mTopbarImageView.frame.size.width - 400)/2, 0, 400, mTopbarImageView.frame.size.height))
        mPreallocateSeats.font = UIFont(name:helveticaRegular, size: 20)
        
        mTopbarImageView.addSubview(mPreallocateSeats)
        mPreallocateSeats.textColor = UIColor.whiteColor()
        mPreallocateSeats.textAlignment = .Center
        
        if let ClassName = sessionDetails.objectForKey("ClassName") as? String
        {
            mPreallocateSeats.text = ClassName
        }
        
        mNoStudentLabel.frame = CGRectMake(10, (self.view.frame.size.height - 40)/2, self.view.frame.size.width - 20,40)
        mNoStudentLabel.font = UIFont(name:helveticaMedium, size: 30)
        mNoStudentLabel.text = "Wait for the teacher to begin :)"
        self.view.addSubview(mNoStudentLabel)
        mNoStudentLabel.textColor = UIColor.whiteColor()
        mNoStudentLabel.textAlignment = .Center
        mNoStudentLabel.hidden = true
    }
    
    
    
    func setCurrentSessionDetails(details: AnyObject)
    {
        sessionDetails = details
        
        
    }
    
    
    
    // MARK: - datasource delegate Functions
    
    
    
    
  
    
    // MARK: - student Message handler
    
    
    
    
    func onBack()
    {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
}