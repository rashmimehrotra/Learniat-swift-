//
//  SingleResponceOptionCell.swift
//  LearniatTeacher
//
//  Created by Deepak MK on 28/03/16.
//  Copyright © 2016 Mindshift. All rights reserved.
//

import Foundation
class SingleResponceOptionCell: UIView
{
   
    var _OptionsLabel = UILabel()
    
    var _optionValueImageView = UIImageView()
    
    
    override init(frame: CGRect)
    {
        super.init(frame:frame)
        
        
        self.backgroundColor = whiteBackgroundColor
        
        
        
        _OptionsLabel.frame = CGRectMake(50, 0, 330, self.frame.size.height);
        _OptionsLabel.textAlignment = .Left;
        _OptionsLabel.text = "mainTopics"
        self.addSubview(_OptionsLabel)
        _OptionsLabel.lineBreakMode = .ByTruncatingMiddle
        
        _OptionsLabel.font = UIFont(name: helveticaRegular, size: 17)
       
        _OptionsLabel.numberOfLines = 10;
        _OptionsLabel.textColor  = blackTextColor
        
        
        
        _optionValueImageView.frame = CGRectMake(20, (self.frame.size.height-25)/2, 20, 20);
        self.addSubview(_optionValueImageView);
        
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func getHeightWithDetails(details:AnyObject)->CGFloat
    {
        if let OptionText = details.objectForKey("OptionText") as? String
        {
            _OptionsLabel.text = OptionText
        }
        else
        {
            _OptionsLabel.text = ""
        }
        
        
        if let IsAnswer = details.objectForKey("IsAnswer") as? String
        {
            if IsAnswer == "1"
            {
                
            }
        }
        
        
        
        let  height = heightForView(_OptionsLabel.text!, font: _OptionsLabel.font, width: _OptionsLabel.frame.size.width)
       
        return height
    }
    
    
    func heightForView(text:String, font:UIFont, width:CGFloat) -> CGFloat
    {
        let label:UILabel = UILabel(frame: CGRectMake(0, 0, width, CGFloat.max))
        label.numberOfLines = 0
        label.lineBreakMode = NSLineBreakMode.ByWordWrapping
        label.font = font
        label.text = text
        
        label.sizeToFit()
        return label.frame.height
    }
    
}