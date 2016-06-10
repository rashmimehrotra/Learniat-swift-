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
    
    
    optional func delegateVolunteerButtonPressedWithVolunteersArray(volunteersArray:NSMutableArray, withVolunteerButton volunteerButton:UIButton)
    
    
    
    
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
        
        self.backgroundColor = UIColor.clearColor()
        
        
        
        
        mVolunteerButton.frame = CGRectMake(self.frame.size.width - 100, 0, 100, self.frame.size.height)
        mVolunteerButton.setTitle("0", forState: .Normal)
        self.addSubview(mVolunteerButton)
        mVolunteerButton.setTitleColor(standard_Button, forState: .Normal)
        mVolunteerButton.contentHorizontalAlignment = UIControlContentHorizontalAlignment.Center
        mVolunteerButton.titleLabel?.font = UIFont(name: HelveticaNeueThin, size: 50)
        mVolunteerButton.addTarget(self, action: #selector(QueryVolunteerSubView.onVonulteerButton), forControlEvents: .TouchUpInside)
        mVolunteerButton.backgroundColor = UIColor.clearColor()

        
        mVolunteeredCountScrollview.frame = CGRectMake(10, mVolunteerButton.frame.size.height - 10, mVolunteerButton.frame.size.width - 20, 10)
        mVolunteerButton.addSubview(mVolunteeredCountScrollview)
        
        
        
        
        let lineImage1 = UIImageView(frame:CGRectMake(mVolunteerButton.frame.origin.x, 10, 1, self.frame.size.height - 20));
        lineImage1.backgroundColor = progressviewBackground
        self.addSubview(lineImage1);
        
        
        
        mMetooLabel.frame = CGRectMake((lineImage1.frame.origin.x - lineImage1.frame.size.width)  - mVolunteerButton.frame.size.width , 0, mVolunteerButton.frame.size.width, self.frame.size.height)
        mMetooLabel.text = "0"
        mMetooLabel.textColor = blackTextColor
        self.addSubview(mMetooLabel)
        mMetooLabel.font = UIFont(name: HelveticaNeueThin, size: 50)
        
        mMetooLabel.textAlignment = .Center

        
        
        let lineImage = UIImageView(frame:CGRectMake(mMetooLabel.frame.origin.x, 10, 1, self.frame.size.height - 20));
        lineImage.backgroundColor = progressviewBackground
        self.addSubview(lineImage);

        
        
        
        mQueryLabel.frame = CGRectMake(10 ,0,lineImage.frame.origin.x - 20  , self.frame.size.height)
        mQueryLabel.textAlignment = .Left;
        mQueryLabel.textColor = blackTextColor
        self.addSubview(mQueryLabel)
        mQueryLabel.backgroundColor = UIColor.clearColor()
        mQueryLabel.font = UIFont(name: helveticaRegular, size: 18)
        mQueryLabel.lineBreakMode = .ByTruncatingMiddle
        mQueryLabel.numberOfLines = 1
        mQueryLabel.textAlignment = .Left
        
        
        
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
    
    
    func setQueryWithDetails(details:AnyObject)
    {
        currentQueryDetails = details
        
        
    }
    
    
    
    func onVonulteerButton()
    {
        if mVolunteersDetailsArray.count > 0
        {
            
            delegate().delegateVolunteerButtonPressedWithVolunteersArray!(mVolunteersDetailsArray, withVolunteerButton: mVolunteerButton)
            
            mVolunteerButton.setTitle("\(mVolunteersDetailsArray.count)", forState: .Normal)
        }
       
    }
    func removeVolunteerWithDetails(details:AnyObject)
    {
        if mVolunteersDetailsArray.containsObject(details)
        {
            mVolunteersDetailsArray.removeObject(details)
        }
        
        
        mVolunteerButton.setTitle("\(mVolunteersDetailsArray.count)", forState: .Normal)
    }
    
    
    func setMeTooSelectedStudents(studentId:String)
    {
        if mmMetooSelectedArray.containsObject(studentId) == false
        {
            mmMetooSelectedArray.addObject(studentId)
        }
        
          mMetooLabel.text = "\(mmMetooSelectedArray.count)"
    }
    
    func removeMeTooWithStudents(studentId:String)
    {
        if mmMetooSelectedArray.containsObject(studentId)
        {
            mmMetooSelectedArray.removeObject(studentId)
        }
        
        
        
        
       mMetooLabel.text = "\(mmMetooSelectedArray.count)"
    }
    
    func setVolunteersDetials(details:AnyObject)
    {
        mVolunteersDetailsArray.addObject(details)
        
        
         mVolunteerButton.setTitle("\(mVolunteersDetailsArray.count)", forState: .Normal)
        
    }
    
    
    func incrementVolunteeredCountwithPercentage(percentage:CGFloat)
    {
      
        
       let subViews = VolunteeredDotView(frame:CGRectMake(currentVolunteerCount, 0, mVolunteeredCountScrollview.frame.size.height,  mVolunteeredCountScrollview.frame.size.height))
        mVolunteeredCountScrollview.addSubview(subViews)
        subViews.layer.cornerRadius = subViews.frame.size.width/2
        subViews.layer.masksToBounds = true
        
        
        currentVolunteerCount = currentVolunteerCount +  mVolunteeredCountScrollview.frame.size.height + 2
        
        mVolunteeredCountScrollview.contentSize = CGSizeMake(currentVolunteerCount, 0)
        
        
        var dotColor =  UIColor(red: 76.0/255.0, green: 217.0/255.0, blue: 100.0/255.0, alpha: 1)
        
        if (percentage<=33)
        {
            dotColor = UIColor(red: 255/255.0, green: 59/255.0, blue: 48/255.0, alpha: 1)
            
            
            
        }
        else if (percentage>33 && percentage<=66)
        {
            
            dotColor =  UIColor(red: 255/255.0, green: 204.0/255.0, blue: 0.0/255.0, alpha: 1)
            
            
        }
        else
        {
            dotColor =  UIColor(red: 76.0/255.0, green: 217.0/255.0, blue: 100.0/255.0, alpha: 1)
            
        }
        
        
        subViews.backgroundColor = dotColor
        
        
//        let subViews = mVolunteeredCountScrollview.subviews.flatMap{ $0 as? VolunteeredDotView }
//        
//        for studentqueryView in subViews
//        {
//            if studentqueryView.isKindOfClass(VolunteeredDotView)
//            {
//                studentqueryView.removeFromSuperview()
//            }
//        }
//        
//    
        
        
//        var circleWi = mVolunteeredCountScrollview.frame.size.width / ( 10*currentVolunteerCount)
        
        
        
        
        
        
    }
    
    
    
    
}