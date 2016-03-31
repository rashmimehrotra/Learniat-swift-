//
//  MatchColumnCell.swift
//  LearniatTeacher
//
//  Created by Deepak MK on 30/03/16.
//  Copyright © 2016 Mindshift. All rights reserved.
//

import Foundation
class MatchColumnCell: UIView
{
    
    var leftOptionsLabel = UILabel()
    
    var rightOptionsLabel = UILabel()
    
    var _optionValueImageView = UIImageView()
    
    
    override init(frame: CGRect)
    {
        super.init(frame:frame)
        
        
        self.backgroundColor = whiteBackgroundColor
        
        
        
        leftOptionsLabel.frame = CGRectMake(10, 0, 220, self.frame.size.height);
        leftOptionsLabel.textAlignment = .Center;
        leftOptionsLabel.text = "leftOption"
        self.addSubview(leftOptionsLabel)
        leftOptionsLabel.lineBreakMode = .ByTruncatingMiddle
        
        leftOptionsLabel.font = UIFont(name: helveticaRegular, size: 20)
        leftOptionsLabel.numberOfLines = 10;
        leftOptionsLabel.textColor  = blackTextColor
        
        
        rightOptionsLabel.frame = CGRectMake(self.frame.size.width - 10, 20, 220, self.frame.size.height -  40 );
        rightOptionsLabel.textAlignment = .Center;
        rightOptionsLabel.text = "leftOption"
        self.addSubview(rightOptionsLabel)
        rightOptionsLabel.lineBreakMode = .ByTruncatingMiddle
        rightOptionsLabel.font = UIFont(name: helveticaRegular, size: 20)
        
        rightOptionsLabel.numberOfLines = 10;
        rightOptionsLabel.textColor  = blackTextColor
        

        
        
        _optionValueImageView.frame = CGRectMake(240, (self.frame.size.height-25)/2, 20, 20);
        self.addSubview(_optionValueImageView);
        _optionValueImageView.contentMode = .ScaleAspectFit
        _optionValueImageView.image = UIImage(named: "Check.png")
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func getHeightWithDetails(leftOptiondetails:AnyObject, withRightOptionDetails rightOptionsDetails:AnyObject)->CGFloat
    {
        if let OptionText = leftOptiondetails.objectForKey("OptionText") as? String
        {
            leftOptionsLabel.text = OptionText
        }
        else
        {
            leftOptionsLabel.text = ""
        }
        
        if let OptionText = rightOptionsDetails.objectForKey("OptionText") as? String
        {
            rightOptionsLabel.text = OptionText
        }
        else
        {
            rightOptionsLabel.text = ""
        }

        
        
        var height :CGFloat = 20
        
        let  leftOptionheight = heightForView(leftOptionsLabel.text!, font: leftOptionsLabel.font, width: leftOptionsLabel.frame.size.width)
        
         let  rightOptionheight = heightForView(rightOptionsLabel.text!, font: rightOptionsLabel.font, width: rightOptionsLabel.frame.size.width)
        
        if leftOptionheight >  rightOptionheight
        {
            height = leftOptionheight
        }
        else
        {
            height = rightOptionheight
        }
        
        
        return height + 40
    }
    
    func changeFrameWithSize()
    {
        leftOptionsLabel.frame = CGRectMake(10, 20, 220, self.frame.size.height -  40 );
        _optionValueImageView.frame = CGRectMake(240, (self.frame.size.height-25)/2, 20, 20);
        rightOptionsLabel.frame = CGRectMake(self.frame.size.width - 230, 20, 220, self.frame.size.height -  40 );
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