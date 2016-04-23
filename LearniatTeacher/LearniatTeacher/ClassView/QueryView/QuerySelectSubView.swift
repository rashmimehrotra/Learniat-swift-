//
//  QuerySelectSubView.swift
//  LearniatTeacher
//
//  Created by Deepak MK on 12/04/16.
//  Copyright © 2016 Mindshift. All rights reserved.
//

import Foundation

class QuerySelectSubView: UIView
{
    var _delgate: AnyObject!
    
    var currentQueryDetails:AnyObject!
    
    var mStudentImage        = UIImageView()
    
    var mStudentName         = UILabel()
    
    var mQueryLabel         = UILabel()
    
    let checkBoxImage       = UIImageView()
   
    let AllowVolunteerSwitch    = UISwitch()
    
    var     isSelected          = true
    
    var isAllowVolunteer        = true

    
    
    var currentReplyDetails :AnyObject!
    
    override init(frame: CGRect)
    {
        
        super.init(frame:frame)
        
        self.backgroundColor = UIColor.whiteColor()
        
        
        
        
        
        

        
        
        
        mStudentImage.frame = CGRectMake(40,10 , 40 ,40)
        self.addSubview(mStudentImage)
        mStudentImage.backgroundColor = UIColor.clearColor()
        mStudentImage.layer.cornerRadius = mStudentImage.frame.size.width/16;
        mStudentImage.layer.masksToBounds = true
        
        
        let m_checkBoxButton = UIButton(frame:CGRectMake(0, 10, 100,40));
        self.addSubview(m_checkBoxButton);
        
        checkBoxImage.frame = CGRectMake(10  ,10 + (m_checkBoxButton.frame.size .height - 20) / 2,20,20)
        
        checkBoxImage.image = UIImage(named:"Checked.png");
        
        self.addSubview(checkBoxImage);
        m_checkBoxButton.addTarget(self, action: #selector(QuerySelectSubView.checkMarkPressed), forControlEvents: UIControlEvents.TouchUpInside)

        
        
      
        mStudentName.frame = CGRectMake(mStudentImage.frame.origin.x + mStudentImage.frame.size.width + 10,mStudentImage.frame.origin.y,400,mStudentImage.frame.size.height / 1.8)
        mStudentName.textAlignment = .Center;
        mStudentName.textColor = blackTextColor
        self.addSubview(mStudentName)
        mStudentName.backgroundColor = UIColor.clearColor()
        mStudentName.textAlignment = .Left;
        mStudentName.font = UIFont(name: helveticaMedium, size: 18)
        mStudentName.contentMode = .Top;

        
        
        mQueryLabel.frame = CGRectMake(mStudentName.frame.origin.x,mStudentImage.frame.origin.y + mStudentImage.frame.size.height  ,self.frame.size.width - mStudentName.frame.origin.x ,mStudentImage.frame.size.height / 2)
        mQueryLabel.textAlignment = .Left;
        mQueryLabel.textColor = blackTextColor
        self.addSubview(mQueryLabel)
        mQueryLabel.backgroundColor = UIColor.clearColor()
        mQueryLabel.font = UIFont(name: helveticaRegular, size: 18)
        mQueryLabel.lineBreakMode = .ByTruncatingMiddle
        mQueryLabel.numberOfLines = 20
        
        
        AllowVolunteerSwitch.frame =  CGRectMake(self.frame.size.width - 80, 10, 80, 30)
        self.addSubview(AllowVolunteerSwitch)
        AllowVolunteerSwitch.setOn(true, animated: true)
        
        
        
        
        
        let AllowVolunteerlabel = UILabel(frame: CGRectMake(AllowVolunteerSwitch.frame.origin.x - 130, 10, 120, 30))
        AllowVolunteerlabel.text = "Allow volunteer"
        self.addSubview(AllowVolunteerlabel)
        AllowVolunteerlabel.textColor = UIColor.lightGrayColor()
       AllowVolunteerlabel.font = UIFont(name: helveticaRegular, size: 12)
        AllowVolunteerlabel.textAlignment = .Right
        
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func setdelegate(delegate:AnyObject)
    {
        _delgate = delegate;
    }
    
    func   delegate()->AnyObject
    {
        return _delgate;
    }
    
    
    func setQueryWithDetails(details:AnyObject) -> CGFloat
    {
        currentQueryDetails = details
        var getQueryHeight :CGFloat = 80
        
        
        if let queryText = details.objectForKey("QueryText") as? String
        {
            getQueryHeight = queryText.heightForView(queryText, font: mQueryLabel.font, width: mQueryLabel.frame.size.width)
            
            mQueryLabel.text = queryText
            mQueryLabel.frame = CGRectMake(mQueryLabel.frame.origin.x ,mQueryLabel.frame.origin.y - 5 ,mQueryLabel.frame.size.width,getQueryHeight)
            getQueryHeight = getQueryHeight + 60
        }
        
        if getQueryHeight < 80
        {
            getQueryHeight = 80
        }
        
        
        
        
        if let StudentName = currentQueryDetails.objectForKey("StudentName") as? String
        {
            mStudentName.text       = StudentName
        }
        
        
        if let StudentId = currentQueryDetails.objectForKey("StudentId") as? String
        {
            let urlString = NSUserDefaults.standardUserDefaults().objectForKey(k_INI_UserProfileImageURL) as! String
            
            if let checkedUrl = NSURL(string: "\(urlString)/\(StudentId)_79px.jpg")
            {
                mStudentImage.contentMode = .ScaleAspectFit
                mStudentImage.downloadImage(checkedUrl, withFolderType: folderType.ProFilePics)
            }
        }
        
        
        if let QueryId = details.objectForKey("QueryId") as? String
        {
            currentQueryDetails.setObject(QueryId, forKey: "QueryId")
        }
        
        
        if let StudentId = details.objectForKey("StudentId") as? String
        {
            currentQueryDetails.setObject(StudentId, forKey: "StudentId")
        }
        return getQueryHeight
        
    }
    
    
    func checkMarkPressed()
    {
        if isSelected == true
        {
            checkBoxImage.image = UIImage(named:"Unchecked.png");
            AllowVolunteerSwitch.setOn(false, animated: true)
            isSelected = false
            
        }
        else
        {
            checkBoxImage.image = UIImage(named:"Checked.png");
            AllowVolunteerSwitch.setOn(true, animated: true)
            isSelected = true
        }
    }
    
    
    
    func getQueryState() -> (checkMarkState:Bool, AllowVolunteerState:Bool,  QueryDetails:AnyObject )
    {
        return (isSelected, AllowVolunteerSwitch.on, currentQueryDetails)
    }
    
    
    
}