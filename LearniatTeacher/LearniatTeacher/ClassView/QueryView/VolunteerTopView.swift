//
//  VolunteerTopView.swift
//  LearniatTeacher
//
//  Created by Deepak MK on 12/04/16.
//  Copyright © 2016 Mindshift. All rights reserved.
//

import Foundation

@objc protocol VolunteerTopViewDelegate
{
    
    
    @objc optional func delegateMetooButtonPressedWithAscending(_ Isascending:Bool)
  
    @objc optional func delegateVolunteerButtonPressedWithAscending(_ Isascending:Bool)
    
    @objc optional func delegateQueryButtonPressedWithAscending(_ Isascending:Bool)
    
    
    
    
    
}
class VolunteerTopView: UIView
{
    var _delgate: AnyObject!
    
    var currentQueryDetails:AnyObject!
    
    var mQueryLabel         = UIButton()
    
    var mMetooLabel         = UIButton()
    
    var mVolunteerButton     = UIButton()
    
    var currentReplyDetails :AnyObject!
    
    override init(frame: CGRect)
    {
        
        super.init(frame:frame)
        
        self.backgroundColor = UIColor.clear
        
        
        
        
        mVolunteerButton.frame = CGRect(x: self.frame.size.width - 100, y: 0, width: 100, height: self.frame.size.height)
        mVolunteerButton.setTitle("I-Volunteer", for: UIControlState())
        self.addSubview(mVolunteerButton)
        mVolunteerButton.setTitleColor( UIColor.lightGray, for: UIControlState())
        mVolunteerButton.contentHorizontalAlignment = UIControlContentHorizontalAlignment.center
        mVolunteerButton.titleLabel?.font = UIFont(name: helveticaRegular, size: 14)
        mVolunteerButton.backgroundColor = UIColor.clear
        mVolunteerButton.addTarget(self, action: #selector(VolunteerTopView.onVolunteerButton), for: .touchUpInside)
        
        let lineImage1 = UIImageView(frame:CGRect(x: mVolunteerButton.frame.origin.x, y: 5, width: 1, height: self.frame.size.height - 10));
        lineImage1.backgroundColor = progressviewBackground
//        self.addSubview(lineImage1);
        
        
        
        mMetooLabel.frame = CGRect(x: (lineImage1.frame.origin.x - lineImage1.frame.size.width)  - mVolunteerButton.frame.size.width , y: 0, width: mVolunteerButton.frame.size.width, height: self.frame.size.height)
        mMetooLabel.setTitle("Me-Too", for: UIControlState())
        mMetooLabel.setTitleColor( UIColor.lightGray, for: UIControlState())
        mMetooLabel.contentHorizontalAlignment = UIControlContentHorizontalAlignment.center
        mMetooLabel.titleLabel?.font = UIFont(name: helveticaRegular, size: 14)
        mMetooLabel.backgroundColor = UIColor.clear
        self.addSubview(mMetooLabel)
        mMetooLabel.addTarget(self, action: #selector(VolunteerTopView.onMetooButton), for: .touchUpInside)
        
        
        let lineImage = UIImageView(frame:CGRect(x: mMetooLabel.frame.origin.x, y: 5, width: 1, height: self.frame.size.height - 10));
        lineImage.backgroundColor = progressviewBackground
//        self.addSubview(lineImage);
        
        
        
        
        mQueryLabel.frame = CGRect(x: 10 ,y: 0,width: lineImage.frame.origin.x - 20  , height: self.frame.size.height)
        self.addSubview(mQueryLabel)
        mQueryLabel.backgroundColor = UIColor.clear
        mQueryLabel.setTitle("Query", for: UIControlState())
        mQueryLabel.contentHorizontalAlignment = UIControlContentHorizontalAlignment.left
        mQueryLabel.titleLabel?.font = UIFont(name: helveticaRegular, size: 14)
        mQueryLabel.setTitleColor( blackTextColor, for: UIControlState())
        mQueryLabel.addTarget(self, action: #selector(VolunteerTopView.onQueryButton), for: .touchUpInside)
        
        
        
        
        
        
        
        
        
        
        
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
    
    
    func onVolunteerButton()
    {
        
        if mVolunteerButton.currentTitleColor == blackTextColor
        {
            delegate().delegateVolunteerButtonPressedWithAscending!(true)
             mVolunteerButton.setTitleColor(lightGrayColor, for: UIControlState())
        }
        else
        {
            delegate().delegateVolunteerButtonPressedWithAscending!(false)
             mVolunteerButton.setTitleColor(blackTextColor, for: UIControlState())
        }
        
        
    }
    
    func onMetooButton()
    {
        if mMetooLabel.currentTitleColor == blackTextColor
        {
            delegate().delegateMetooButtonPressedWithAscending!(true)
            mMetooLabel.setTitleColor(lightGrayColor, for: UIControlState())
            
        }
        else
        {
            delegate().delegateMetooButtonPressedWithAscending!(false)
            mMetooLabel.setTitleColor(blackTextColor, for: UIControlState())
        }
        
    }
    
    func onQueryButton()
    {
        if mQueryLabel.currentTitleColor == blackTextColor
        {
            delegate().delegateQueryButtonPressedWithAscending!(true)
            mQueryLabel.setTitleColor(lightGrayColor, for: UIControlState())
        }
        else
        {
            delegate().delegateQueryButtonPressedWithAscending!(false)
            mQueryLabel.setTitleColor(blackTextColor, for: UIControlState())
        }
        
    }

    
}
