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
    
    
    optional func delegateMetooButtonPressed()
  
    optional func delegateVolunteerButtonPressed()
    
    optional func delegateQueryButtonPressed()
    
    
    
    
    
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
        
        self.backgroundColor = UIColor.clearColor()
        
        
        
        
        mVolunteerButton.frame = CGRectMake(self.frame.size.width - 100, 0, 100, self.frame.size.height)
        mVolunteerButton.setTitle("I-Volunteer", forState: .Normal)
        self.addSubview(mVolunteerButton)
        mVolunteerButton.setTitleColor( UIColor.lightGrayColor(), forState: .Normal)
        mVolunteerButton.contentHorizontalAlignment = UIControlContentHorizontalAlignment.Center
        mVolunteerButton.titleLabel?.font = UIFont(name: helveticaRegular, size: 14)
        mVolunteerButton.backgroundColor = UIColor.clearColor()
        mVolunteerButton.addTarget(self, action: #selector(VolunteerTopView.onVolunteerButton), forControlEvents: .TouchUpInside)
        
        let lineImage1 = UIImageView(frame:CGRectMake(mVolunteerButton.frame.origin.x, 5, 1, self.frame.size.height - 10));
        lineImage1.backgroundColor = progressviewBackground
//        self.addSubview(lineImage1);
        
        
        
        mMetooLabel.frame = CGRectMake((lineImage1.frame.origin.x - lineImage1.frame.size.width)  - mVolunteerButton.frame.size.width , 0, mVolunteerButton.frame.size.width, self.frame.size.height)
        mMetooLabel.setTitle("Me-Too", forState: .Normal)
        mMetooLabel.setTitleColor( UIColor.lightGrayColor(), forState: .Normal)
        mMetooLabel.contentHorizontalAlignment = UIControlContentHorizontalAlignment.Center
        mMetooLabel.titleLabel?.font = UIFont(name: helveticaRegular, size: 14)
        mMetooLabel.backgroundColor = UIColor.clearColor()
        self.addSubview(mMetooLabel)
        mVolunteerButton.addTarget(self, action: #selector(VolunteerTopView.onMetooButton), forControlEvents: .TouchUpInside)
        
        
        let lineImage = UIImageView(frame:CGRectMake(mMetooLabel.frame.origin.x, 5, 1, self.frame.size.height - 10));
        lineImage.backgroundColor = progressviewBackground
//        self.addSubview(lineImage);
        
        
        
        
        mQueryLabel.frame = CGRectMake(10 ,0,lineImage.frame.origin.x - 20  , self.frame.size.height)
        self.addSubview(mQueryLabel)
        mQueryLabel.backgroundColor = UIColor.clearColor()
        mQueryLabel.setTitle("Query", forState: .Normal)
        mQueryLabel.contentHorizontalAlignment = UIControlContentHorizontalAlignment.Left
        mQueryLabel.titleLabel?.font = UIFont(name: helveticaRegular, size: 14)
        mQueryLabel.setTitleColor( UIColor.lightGrayColor(), forState: .Normal)
        mQueryLabel.addTarget(self, action: #selector(VolunteerTopView.onQueryButton), forControlEvents: .TouchUpInside)
        
        
        
        
        
        
        
        
        
        
        
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
    
    
    func onVolunteerButton()
    {
        delegate().delegateVolunteerButtonPressed!()
    }
    
    func onMetooButton()
    {
        delegate().delegateMetooButtonPressed!()
    }
    
    func onQueryButton()
    {
        delegate().delegateQueryButtonPressed!()
    }

    
}