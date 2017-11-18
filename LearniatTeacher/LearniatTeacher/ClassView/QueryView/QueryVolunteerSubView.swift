//
//  QueryVolunteerSubView.swift
//  LearniatTeacher
//
//  Created by Deepak MK on 12/04/16.
//  Copyright © 2016 Mindshift. All rights reserved.
//

import Foundation
@objc protocol QueryVolunteerSubViewDelegate
{
    
    
    @objc optional func delegateVolunteerButtonPressedWithVolunteersArray(_ volunteersArray:NSMutableArray, withVolunteerButton volunteerButton:UIButton)
    
    
    
    
}

class QueryVolunteerSubView: UIView
{
    var _delgate: AnyObject!
    
    var currentQueryDetails:AnyObject!
    
    var mQueryLabel         = UILabel()
    
    var mMetooLabel         = UILabel()
    
    var mVolunteerButton     = UIButton()
    
    var currentReplyDetails :AnyObject!
    
    var mVolunteersDetailsArray   = NSMutableArray()
    
    var mmMetooSelectedArray   = NSMutableArray()
    
    var mVolunteeredCountScrollview = UIScrollView()
    
    var currentVolunteerCount  :CGFloat            = 0
    
    override init(frame: CGRect)
    {
        
        super.init(frame:frame)
        
        self.backgroundColor = UIColor.clear
        
        
        
        
        mVolunteerButton.frame = CGRect(x: self.frame.size.width - 100, y: 0, width: 100, height: self.frame.size.height)
        mVolunteerButton.setTitle("0", for: UIControlState())
        self.addSubview(mVolunteerButton)
        mVolunteerButton.setTitleColor(standard_Button, for: UIControlState())
        mVolunteerButton.contentHorizontalAlignment = UIControlContentHorizontalAlignment.center
        mVolunteerButton.titleLabel?.font = UIFont(name: HelveticaNeueThin, size: 50)
        mVolunteerButton.addTarget(self, action: #selector(QueryVolunteerSubView.onVonulteerButton), for: .touchUpInside)
        mVolunteerButton.backgroundColor = UIColor.clear

        
        mVolunteeredCountScrollview.frame = CGRect(x: 10, y: mVolunteerButton.frame.size.height - 10, width: mVolunteerButton.frame.size.width - 20, height: 10)
        mVolunteerButton.addSubview(mVolunteeredCountScrollview)
        
        
        
        
        let lineImage1 = UIImageView(frame:CGRect(x: mVolunteerButton.frame.origin.x, y: 10, width: 1, height: self.frame.size.height - 20));
        lineImage1.backgroundColor = progressviewBackground
        self.addSubview(lineImage1);
        
        
        
        mMetooLabel.frame = CGRect(x: (lineImage1.frame.origin.x - lineImage1.frame.size.width)  - mVolunteerButton.frame.size.width , y: 0, width: mVolunteerButton.frame.size.width, height: self.frame.size.height)
        mMetooLabel.text = "0"
        mMetooLabel.textColor = blackTextColor
        self.addSubview(mMetooLabel)
        mMetooLabel.font = UIFont(name: HelveticaNeueThin, size: 50)
        
        mMetooLabel.textAlignment = .center

        
        
        let lineImage = UIImageView(frame:CGRect(x: mMetooLabel.frame.origin.x, y: 10, width: 1, height: self.frame.size.height - 20));
        lineImage.backgroundColor = progressviewBackground
        self.addSubview(lineImage);

        
        
        
        mQueryLabel.frame = CGRect(x: 10 ,y: 0,width: lineImage.frame.origin.x - 20  , height: self.frame.size.height)
        mQueryLabel.textAlignment = .left;
        mQueryLabel.textColor = blackTextColor
        self.addSubview(mQueryLabel)
        mQueryLabel.backgroundColor = UIColor.clear
        mQueryLabel.font = UIFont(name: helveticaRegular, size: 18)
        mQueryLabel.lineBreakMode = .byTruncatingMiddle
        mQueryLabel.numberOfLines = 1
        mQueryLabel.textAlignment = .left
        
        
        
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
    
    
    func setQueryWithDetails(_ details:AnyObject)
    {
        currentQueryDetails = details
        
        
    }
    
    
    
    func onVonulteerButton()
    {
        if mVolunteersDetailsArray.count > 0
        {
            
            delegate().delegateVolunteerButtonPressedWithVolunteersArray!(mVolunteersDetailsArray, withVolunteerButton: mVolunteerButton)
            
            mVolunteerButton.setTitle("\(mVolunteersDetailsArray.count)", for: UIControlState())
        }
       
    }
    func removeVolunteerWithDetails(_ details:AnyObject)
    {
        if mVolunteersDetailsArray.contains(details)
        {
            mVolunteersDetailsArray.remove(details)
        }
        
        
        mVolunteerButton.setTitle("\(mVolunteersDetailsArray.count)", for: UIControlState())
    }
    
    
    func setMeTooSelectedStudents(_ studentId:String)
    {
        if mmMetooSelectedArray.contains(studentId) == false
        {
            mmMetooSelectedArray.add(studentId)
        }
        
          mMetooLabel.text = "\(mmMetooSelectedArray.count)"
    }
    
    func removeMeTooWithStudents(_ studentId:String)
    {
        if mmMetooSelectedArray.contains(studentId)
        {
            mmMetooSelectedArray.remove(studentId)
        }
        
        
        
        
       mMetooLabel.text = "\(mmMetooSelectedArray.count)"
    }
    
    func setVolunteersDetials(_ details:AnyObject)
    {
        mVolunteersDetailsArray.add(details)
        
        
         mVolunteerButton.setTitle("\(mVolunteersDetailsArray.count)", for: UIControlState())
        
    }
    
    
    func incrementVolunteeredCountwithPercentage(_ percentage:CGFloat)
    {
      
        
       let subViews = VolunteeredDotView(frame:CGRect(x: currentVolunteerCount, y: 0, width: mVolunteeredCountScrollview.frame.size.height,  height: mVolunteeredCountScrollview.frame.size.height))
        mVolunteeredCountScrollview.addSubview(subViews)
        subViews.layer.cornerRadius = subViews.frame.size.width/2
        subViews.layer.masksToBounds = true
        
        
        currentVolunteerCount = currentVolunteerCount +  mVolunteeredCountScrollview.frame.size.height + 2
        
        mVolunteeredCountScrollview.contentSize = CGSize(width: currentVolunteerCount, height: 0)
        
        var dotColor =  UIColor(red: 76.0/255.0, green: 217.0/255.0, blue: 100.0/255.0, alpha: 1)
        if (percentage<=33) {
            dotColor = UIColor(red: 255/255.0, green: 59/255.0, blue: 48/255.0, alpha: 1)
        }  else if (percentage>33 && percentage<=66) {
            dotColor =  UIColor(red: 255/255.0, green: 204.0/255.0, blue: 0.0/255.0, alpha: 1)
        } else {
            dotColor =  UIColor(red: 76.0/255.0, green: 217.0/255.0, blue: 100.0/255.0, alpha: 1)
            
        }
        
        
        subViews.backgroundColor = dotColor        
    }
    
    
    
    
}
