//
//  StundentDeskView.swift
//  LearniatTeacher
//
//  Created by Deepak MK on 26/03/16.
//  Copyright © 2016 Mindshift. All rights reserved.
//

import Foundation



let StudentLive                 =  "Live"
let StudentLiveBackground       =  "LiveBackground"
let StudentOccupied             =  "Occupied"
let StudentFree                 =  "Free"
let StudentSignedout            = "Signedout"
let StudentPreAllocated         = "PreAllocated"

class StundentDeskView: UIView
{
    
    
    
   
    var cellWith : CGFloat = 0
    
    var cellHeight : CGFloat = 0
    
    var currentStudentsDict:AnyObject!
    
    var refrenceDeskImageView = UIImageView()
    
    var answerDeskImageView  = LBorderView()
    
    var mStudentImage  = UIImageView()
    
    var mParticipationLessImageView  = UIImageView()
    
    var mDeskFrame :CGRect!
    
    
    var mStudentName  = FXLabel()
    
    var mMiddleStudentName = UILabel()
    
    var mProgressView = UIProgressView()
 
    var StudentState = StudentSignedout
    
    
    override init(frame: CGRect)
    {
        super.init(frame:frame)
        
        
        var deskSize:CGFloat = self.frame.size.width
        
        
        
        if (self.frame.size.height > self.frame.size.width)
        {
            deskSize = self.frame.size.width;
        }
        else if (self.frame.size.width>self.frame.size.height)
        {
            deskSize=self.frame.size.height;
        }
        else if(self.frame.size.width==self.frame.size.height)
        {
            deskSize=self.frame.size.width;
        }

    
        
        refrenceDeskImageView.frame = CGRectMake((self.frame.size.width-deskSize)/2, (self.frame.size.height-deskSize)/2,deskSize/1.1,self.frame.size.height)
        self.addSubview(refrenceDeskImageView)
        refrenceDeskImageView.backgroundColor = UIColor.clearColor()
        cellWith = refrenceDeskImageView.frame.size.width
        cellHeight = cellWith / 2
        
        
        
        
        
        mStudentImage.frame = CGRectMake((refrenceDeskImageView.frame.size.width - refrenceDeskImageView.frame.size.width / 1.1)/2, (refrenceDeskImageView.frame.size.width / 3.5) / 8, refrenceDeskImageView.frame.size.width / 3.5, refrenceDeskImageView.frame.size.width / 3.5)
        refrenceDeskImageView.addSubview(mStudentImage)
        mStudentImage.backgroundColor = UIColor.clearColor()
        mStudentImage.layer.cornerRadius = mStudentImage.frame.size.width/16;
        mStudentImage.layer.masksToBounds = true

        
        
        mParticipationLessImageView.frame = CGRectMake((mStudentImage.frame.origin.x + mStudentImage.frame.size.width)-((mStudentImage.frame.size.width / 3) / 2),0, (mStudentImage.frame.size.width / 3), (mStudentImage.frame.size.width / 3))
        refrenceDeskImageView.addSubview(mParticipationLessImageView)
        mParticipationLessImageView.image = UIImage(named: "lowParticipartion.png")
        mParticipationLessImageView.hidden = true
        
        
        answerDeskImageView.frame = CGRectMake((refrenceDeskImageView.frame.size.width-refrenceDeskImageView.frame.size.width/1.1)/2, (mStudentImage.frame.size.height+cellHeight/8),refrenceDeskImageView.frame.size.width/1.1, refrenceDeskImageView.frame.size.width/1.65)
        refrenceDeskImageView.addSubview(answerDeskImageView)
        answerDeskImageView.borderType = BorderTypeDashed;
        answerDeskImageView.dashPattern = 4;
        answerDeskImageView.spacePattern = 4;
        answerDeskImageView.borderWidth = 1;
        answerDeskImageView.borderColor = LineGrayColor;
        
        
        mDeskFrame = answerDeskImageView.frame
        
        
        mStudentName.frame = CGRectMake(answerDeskImageView.frame.origin.x,answerDeskImageView.frame.size.height+answerDeskImageView.frame.origin.y, answerDeskImageView.frame.size.width, refrenceDeskImageView.frame.size.height-(answerDeskImageView.frame.origin.y+answerDeskImageView.frame.size.height));
        mStudentName.textAlignment = .Center;
        mStudentName.textColor = blackTextColor
        refrenceDeskImageView.addSubview(mStudentName)
        mStudentName.backgroundColor = UIColor.clearColor()
        mStudentName.allowOrphans = true;
        mStudentName.textAlignment = .Center;
        mStudentName.contentMode = .Top;
        mStudentName.hidden = true
        var fontHeight = mStudentName.frame.size.height/1.3;
        if (fontHeight>16)
        {
            fontHeight = 16;
        }
        
        mStudentName.font = UIFont(name: helveticaRegular, size: fontHeight)

        
        mMiddleStudentName.frame = mDeskFrame
        refrenceDeskImageView.addSubview(mMiddleStudentName)
        mMiddleStudentName.backgroundColor = UIColor.clearColor();
        mMiddleStudentName.hidden = false
        mMiddleStudentName.textAlignment = .Center;
        mMiddleStudentName.numberOfLines=10;
        mMiddleStudentName.lineBreakMode = .ByTruncatingMiddle
        mMiddleStudentName.textColor = blackTextColor
        
        
        
        
        mProgressView.frame = CGRectMake((mStudentImage.frame.size.width+mStudentImage.frame.size.width/4),   mStudentImage.frame.size.height-mStudentImage.frame.size.height/8,   refrenceDeskImageView.frame.size.width-mStudentImage.frame.size.width-mStudentImage.frame.size.width/2,mStudentImage.frame.size.width/8);
        refrenceDeskImageView.addSubview(mProgressView);
        mProgressView.progressTintColor  = standard_Red
        mProgressView.trackTintColor = UIColor(red: 213/255.0, green:213/255.0, blue:213/255.0, alpha: 1)
        mProgressView.hidden = true
        let transform = CGAffineTransformMakeScale(1.0, 3.2);
        mProgressView.transform = transform;
        mProgressView.layer.cornerRadius = mProgressView.frame.size.height/2;
        mProgressView.layer.masksToBounds = true;
        
    }
    
    required init?(coder aDecoder: NSCoder)
    {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func setStudentsDetails(details:AnyObject)
    {
        currentStudentsDict = details
        
        if let StudentName = currentStudentsDict.objectForKey("StudentName") as? String
        {
            mMiddleStudentName.text = StudentName
            mStudentName.text       = StudentName
        }
        
        
        if let StudentId = currentStudentsDict.objectForKey("StudentId") as? String
        {
            let urlString = NSUserDefaults.standardUserDefaults().objectForKey(k_INI_UserProfileImageURL) as! String
            
            if let checkedUrl = NSURL(string: "\(urlString)/\(StudentId)_79px.jpg")
            {
                mStudentImage.contentMode = .ScaleAspectFit
                mStudentImage.downloadImage(checkedUrl, withFolderType: folderType.ProFilePics)
            }
        }
        
        
        if let _StudentState = currentStudentsDict.objectForKey("StudentState") as? String
        {
           setStudentCurrentState(_StudentState)
        }
        
        
        
        
    
    }
    
    func setStudentCurrentState(state:String)
    {
        
        StudentState = state;
        
        
        switch (state)
        {
           
            case StudentSignedout:
                
                answerDeskImageView.borderType = BorderTypeDashed;
                answerDeskImageView.borderWidth = 1;
                answerDeskImageView.borderColor = standard_Red
                
                break;
         
            case StudentFree:
                answerDeskImageView.borderType = BorderTypeDashed;
                answerDeskImageView.borderWidth = 1;
                answerDeskImageView.borderColor = LineGrayColor;
                
                break;
            
            case StudentLive:
                
                    
                    answerDeskImageView.borderType = BorderTypeSolid;
                    answerDeskImageView.borderWidth = 1;
                   answerDeskImageView.borderColor = standard_Green
                    
                    break;
           
            case StudentLiveBackground:
                
                answerDeskImageView.borderType = BorderTypeSolid;
                answerDeskImageView.borderWidth = 1;
                answerDeskImageView.borderColor = standard_Red
                
                break;
                
            case StudentOccupied:
               
                answerDeskImageView.borderType = BorderTypeDashed;
                answerDeskImageView.borderWidth = 1;
                answerDeskImageView.borderColor = LineGrayColor
                
                break;

            case StudentPreAllocated:
               
                answerDeskImageView.borderType = BorderTypeDashed;
                answerDeskImageView.borderWidth = 1;
                answerDeskImageView.borderColor = LineGrayColor
                
                break
                
            default:
                answerDeskImageView.borderType = BorderTypeSolid;
                answerDeskImageView.borderWidth = 1;

                break
        }
    }
}