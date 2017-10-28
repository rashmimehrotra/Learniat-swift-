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
    
    @objc optional func delegateOptionTouchedWithText(_ optionText:String, withPollingView pollingView:PollingSubView , withState state:Bool)
    
    
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
        self.backgroundColor = UIColor.clear
    }
    
    
    required init?(coder aDecoder: NSCoder)
    {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func setOptionDetails(_ details:String)
    {

        
        optionsLabel.frame = CGRect(x: 40, y: 0, width: self.frame.size.width-80, height: self.frame.size.height)
        self.addSubview(optionsLabel)
        optionsLabel.numberOfLines = 4
        optionsLabel.lineBreakMode = .byTruncatingMiddle
        optionsLabel.textAlignment = .center
        optionsLabel.text = (details)
        optionsLabel.textColor = textColor
        optionsLabel.font = UIFont (name: helveticaRegular, size: 18)
    }
    
    
    @objc func optionTouchedTapped()
    {
        if isSelected == false
        {
            isSelected = true
            self.backgroundColor = textColor
            optionsLabel.textColor = UIColor.white
            
            delegate().delegateOptionTouchedWithText!(optionsLabel.text!, withPollingView: self, withState: true)
            
        }
        else
        {
            isSelected = false
            self.backgroundColor = UIColor.clear
            optionsLabel.textColor = textColor
            delegate().delegateOptionTouchedWithText!(optionsLabel.text!, withPollingView: self, withState: false)
        }
      
    }
    
    
    func setdelegate(_ delegate:AnyObject)
    {
        _delgate = delegate;
    }
    
    func   delegate()->AnyObject
    {
        return _delgate;
    }
    
    func setSelectedState(_ state:Bool)
    {
        isSelected = state
        
        
        if isSelected == false
        {
            self.backgroundColor = UIColor.clear
            optionsLabel.textColor = textColor
            
            
        }
        else
        {
            self.backgroundColor = textColor
            optionsLabel.textColor = UIColor.white
        }
    }
    
    func getselectedState() ->Bool
    {
        return isSelected
    }
    
    
}
