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
        
        
        
        _OptionsLabel.frame = CGRect(x: 50, y: 0, width: 330, height: self.frame.size.height);
        _OptionsLabel.textAlignment = .left;
        _OptionsLabel.text = "mainTopics"
        self.addSubview(_OptionsLabel)
        _OptionsLabel.lineBreakMode = .byTruncatingMiddle
        
        _OptionsLabel.font = UIFont(name: helveticaRegular, size: 20)
       
        _OptionsLabel.numberOfLines = 10;
        _OptionsLabel.textColor  = blackTextColor
       
        
        
        
        _optionValueImageView.frame = CGRect(x: 20, y: (self.frame.size.height-25)/2, width: 20, height: 20);
        self.addSubview(_optionValueImageView);
        _optionValueImageView.contentMode = .scaleAspectFit
        
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func getHeightWithDetails(_ details:AnyObject)->CGFloat
    {
        if let OptionText = details.object(forKey: "OptionText") as? String
        {
            _OptionsLabel.text = OptionText
        }
        else
        {
            _OptionsLabel.text = ""
        }
        
        
        if let IsAnswer = details.object(forKey: "IsAnswer") as? String
        {
            if IsAnswer == "1" || IsAnswer == KCorretValue
            {
                _optionValueImageView.image = UIImage(named: "Check.png")
                _optionValueImageView.backgroundColor = UIColor.clear
            }
            else if IsAnswer == "0" || IsAnswer == kWrongvalue
            {
                 _optionValueImageView.image = UIImage(named: "X.png")
                _optionValueImageView.backgroundColor = UIColor.clear
            }
            else
            {
                _optionValueImageView.backgroundColor = topicsLineColor
            }
        }
        
        
        
        let  height = heightForView(_OptionsLabel.text!, font: _OptionsLabel.font, width: _OptionsLabel.frame.size.width)
       
        return height + 40
    }
    
    func changeFrameWithSize()
    {
         _OptionsLabel.frame = CGRect(x: 50, y: 20, width: 330, height: self.frame.size.height - 40);
        _optionValueImageView.frame = CGRect(x: 20, y: (self.frame.size.height - 20)/2, width: 20, height: 20);
    }
    
    
    
    
    
    func checkValueOfOPtion(_ questiondetails:AnyObject, withanswerOptionsArray mAnswerOptions:NSMutableArray)
    {
        
        if mAnswerOptions.count > 0
        {
            _optionValueImageView.backgroundColor = topicsLineColor
            _optionValueImageView.image =  nil
            
            if let questionOptionText = questiondetails.object(forKey: "OptionText") as? String
            {
                for answerIndex in 0 ..< mAnswerOptions.count
                {
                    if let answerOptionText = mAnswerOptions.object(at: answerIndex) as? String
                    {
                        if answerOptionText == questionOptionText
                        {
                            if let IsAnswer = questiondetails.object(forKey: "IsAnswer") as? String
                            {
                                
                                if IsAnswer == "1"
                                {
                                    _optionValueImageView.image = UIImage(named: "Check.png")
                                    _optionValueImageView.backgroundColor = UIColor.clear
                                }
                                else if IsAnswer == "0"
                                {
                                    _optionValueImageView.image = UIImage(named: "X.png")
                                    _optionValueImageView.backgroundColor = UIColor.clear
                                }
                            }
                        }
                        
                    }
                }
            }
        }
       
       
    }
    
    func heightForView(_ text:String, font:UIFont, width:CGFloat) -> CGFloat
    {
        let label:UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: width, height: CGFloat.greatestFiniteMagnitude))
        label.numberOfLines = 0
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.font = font
        label.text = text
        
        label.sizeToFit()
        return label.frame.height
    }
    
}
