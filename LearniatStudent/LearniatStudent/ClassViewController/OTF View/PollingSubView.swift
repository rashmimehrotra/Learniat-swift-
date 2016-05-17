//
//  PollingSubView.swift
//  LearniatStudent
//
//  Created by Deepak MK on 16/05/16.
//  Copyright © 2016 Mindshift. All rights reserved.
//

import Foundation

@objc protocol PollingSubViewDelegate
{
    
    optional func delegateOptionTouchedWithText(optionText:String, withPollingView pollingView:PollingSubView , withState state:Bool)
    
    
}


class PollingSubView: UIView
{
    
    
    var optionsLabel = UILabel()
    
    var _delgate: AnyObject!
    
    var isSelected :Bool = false
    
    
    override init(frame: CGRect) {
        
        super.init(frame:frame)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(PollingSubView.optionTouchedTapped))
        tap.numberOfTapsRequired = 1
        self.addGestureRecognizer(tap)
        self.backgroundColor = UIColor.clearColor()
    }
    
    
    required init?(coder aDecoder: NSCoder)
    {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func setOptionDetails(details:String)
    {

        
        optionsLabel.frame = CGRectMake(40, 0, self.frame.size.width-80, self.frame.size.height)
        self.addSubview(optionsLabel)
        optionsLabel.numberOfLines = 4
        optionsLabel.lineBreakMode = .ByTruncatingMiddle
        optionsLabel.textAlignment = .Center
        optionsLabel.text = (details)
        optionsLabel.textColor = textColor
        optionsLabel.font = UIFont (name: helveticaRegular, size: 18)
    }
    
    
    func optionTouchedTapped()
    {
        if isSelected == false
        {
            isSelected = true
            self.backgroundColor = textColor
            optionsLabel.textColor = UIColor.whiteColor()
            
            delegate().delegateOptionTouchedWithText!(optionsLabel.text!, withPollingView: self, withState: true)
            
        }
        else
        {
            isSelected = false
            self.backgroundColor = UIColor.clearColor()
            optionsLabel.textColor = textColor
            delegate().delegateOptionTouchedWithText!(optionsLabel.text!, withPollingView: self, withState: false)
        }
      
    }
    
    
    func setdelegate(delegate:AnyObject)
    {
        _delgate = delegate;
    }
    
    func   delegate()->AnyObject
    {
        return _delgate;
    }
    
    func setSelectedState(state:Bool)
    {
        isSelected = state
        
        
        if isSelected == false
        {
            self.backgroundColor = UIColor.clearColor()
            optionsLabel.textColor = textColor
            
            
        }
        else
        {
            self.backgroundColor = textColor
            optionsLabel.textColor = UIColor.whiteColor()
        }
    }
    
    func getselectedState() ->Bool
    {
        return isSelected
    }
    
    
}