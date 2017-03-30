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
    
    var currentQueryDetails = NSMutableDictionary()
    
    var mStudentImage        = CustomProgressImageView()
    
    var mStudentName         = UILabel()
    
    var mQueryLabel         = UILabel()
    
    let checkBoxImage       = UIImageView()
   
    let AllowVolunteerSwitch    = UISwitch()
    
    var     isSelected          = true
    
    var isAllowVolunteer        = true

    var m_checkBoxButton        = UIButton()
    
    var currentReplyDetails :AnyObject!
    
    override init(frame: CGRect)
    {
        
        super.init(frame:frame)
        
        self.backgroundColor = UIColor.white
        
        
        
        
        
        

        
        
        
        mStudentImage.frame = CGRect(x: 40,y: 10 , width: 40 ,height: 40)
        self.addSubview(mStudentImage)
        mStudentImage.backgroundColor = UIColor.clear
        mStudentImage.layer.cornerRadius = mStudentImage.frame.size.width/16;
        mStudentImage.layer.masksToBounds = true
        
        
         m_checkBoxButton.frame = CGRect(x: 0, y: 10, width: 100,height: 40)
        self.addSubview(m_checkBoxButton);
        
        checkBoxImage.frame = CGRect(x: 10  ,y: 10 + (m_checkBoxButton.frame.size .height - 20) / 2,width: 20,height: 20)
        
        checkBoxImage.image = UIImage(named:"Checked.png");
        
        self.addSubview(checkBoxImage);
        m_checkBoxButton.addTarget(self, action: #selector(QuerySelectSubView.checkMarkPressed), for: UIControlEvents.touchUpInside)

        
        
      
        mStudentName.frame = CGRect(x: mStudentImage.frame.origin.x + mStudentImage.frame.size.width + 10,y: mStudentImage.frame.origin.y,width: 400,height: mStudentImage.frame.size.height / 1.8)
        mStudentName.textAlignment = .center;
        mStudentName.textColor = blackTextColor
        self.addSubview(mStudentName)
        mStudentName.backgroundColor = UIColor.clear
        mStudentName.textAlignment = .left;
        mStudentName.font = UIFont(name: helveticaMedium, size: 18)
        mStudentName.contentMode = .top;

        
        
        mQueryLabel.frame = CGRect(x: mStudentName.frame.origin.x,y: mStudentImage.frame.origin.y + mStudentImage.frame.size.height  ,width: self.frame.size.width - mStudentName.frame.origin.x ,height: mStudentImage.frame.size.height / 2)
        mQueryLabel.textAlignment = .left;
        mQueryLabel.textColor = blackTextColor
        self.addSubview(mQueryLabel)
        mQueryLabel.backgroundColor = UIColor.clear
        mQueryLabel.font = UIFont(name: helveticaRegular, size: 18)
        mQueryLabel.lineBreakMode = .byTruncatingMiddle
        mQueryLabel.numberOfLines = 20
        
        
        AllowVolunteerSwitch.frame =  CGRect(x: self.frame.size.width - 80, y: 10, width: 80, height: 30)
        self.addSubview(AllowVolunteerSwitch)
        AllowVolunteerSwitch.setOn(true, animated: true)
        
        
        
        
        
        let AllowVolunteerlabel = UILabel(frame: CGRect(x: AllowVolunteerSwitch.frame.origin.x - 130, y: 10, width: 120, height: 30))
        AllowVolunteerlabel.text = "Allow volunteer"
        self.addSubview(AllowVolunteerlabel)
        AllowVolunteerlabel.textColor = UIColor.lightGray
       AllowVolunteerlabel.font = UIFont(name: helveticaRegular, size: 12)
        AllowVolunteerlabel.textAlignment = .right
        
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func setdelegate(_ delegate:AnyObject)
    {
        _delgate = delegate;
    }
    
    func   delegate()->AnyObject
    {
        return _delgate;
    }
    
    
    func setQueryWithDetails(_ details:AnyObject) -> CGFloat
    {
        currentQueryDetails = details as! NSMutableDictionary
        var getQueryHeight :CGFloat = 80
        
        
        if let queryText = details.object(forKey: "QueryText") as? String
        {
            getQueryHeight = queryText.heightForView(queryText, font: mQueryLabel.font, width: mQueryLabel.frame.size.width)
            
            mQueryLabel.text = queryText
            mQueryLabel.frame = CGRect(x: mQueryLabel.frame.origin.x ,y: mQueryLabel.frame.origin.y - 5 ,width: mQueryLabel.frame.size.width,height: getQueryHeight)
            getQueryHeight = getQueryHeight + 60
        }
        
        if getQueryHeight < 80
        {
            getQueryHeight = 80
        }
        
        
        
        
        if let StudentName = currentQueryDetails.object(forKey: "StudentName") as? String
        {
            mStudentName.text       = StudentName
        }
        
        
        if let StudentId = currentQueryDetails.object(forKey: "StudentId") as? String
        {
            let urlString = UserDefaults.standard.object(forKey: k_INI_UserProfileImageURL) as! String
            
            if let checkedUrl = URL(string: "\(urlString)/\(StudentId)_79px.jpg")
            {
                mStudentImage.contentMode = .scaleAspectFit
                mStudentImage.downloadImage(checkedUrl, withFolderType: folderType.proFilePics)
            }
        }
        
        
        if let QueryId = details.object(forKey: "QueryId") as? String
        {
            currentQueryDetails.setObject(QueryId, forKey: "QueryId" as NSCopying)
        }
        
        
        if let StudentId = details.object(forKey: "StudentId") as? String
        {
            currentQueryDetails.setObject(StudentId, forKey: "StudentId" as NSCopying)
        }
        
        
         m_checkBoxButton.frame = CGRect(x: 0, y: 00, width: self.frame.size.width,height: getQueryHeight)
        
        return getQueryHeight
        
    }
    
    
    func checkMarkPressed()
    {
        if isSelected == true
        {
            checkBoxImage.image = UIImage(named:"Unchecked.png");
            AllowVolunteerSwitch.setOn(false, animated: true)
            isSelected = false
            self.backgroundColor = UIColor.clear
            
        }
        else
        {
            checkBoxImage.image = UIImage(named:"Checked.png");
            AllowVolunteerSwitch.setOn(true, animated: true)
            isSelected = true
             self.backgroundColor = UIColor.white
        }
    }
    
    
    
    func getQueryState() -> (checkMarkState:Bool, AllowVolunteerState:Bool,  QueryDetails:AnyObject )
    {
        return (isSelected, AllowVolunteerSwitch.isOn, currentQueryDetails)
    }
    
    
    
}
