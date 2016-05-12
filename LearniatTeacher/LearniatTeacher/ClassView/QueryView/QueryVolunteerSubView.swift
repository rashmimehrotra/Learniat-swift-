//
//  QueryVolunteerSubView.swift
//  LearniatTeacher
//
//  Created by Deepak MK on 12/04/16.
//  Copyright © 2016 Mindshift. All rights reserved.
//

import Foundation
class QueryVolunteerSubView: UIView
{
    var _delgate: AnyObject!
    
    var currentQueryDetails:AnyObject!
    
    var mQueryLabel         = UILabel()
    
    var mMetooLabel         = UILabel()
    
    var mVolunteerButton     = UIButton()
    
    var currentReplyDetails :AnyObject!
    
    var mVolunteersDetailsArray   = NSMutableArray()
    
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
        
    }
    
    func setVolunteersDetials(details:AnyObject)
    {
        mVolunteersDetailsArray.addObject(details)
        
    }
    
}