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
    
    var _optionValueImageView : UIImageView!
    
    
    override init(frame: CGRect)
    {
        super.init(frame:frame)
        
        
        self.backgroundColor = whiteBackgroundColor
        
        
        
        leftOptionsLabel.frame = CGRect(x: 10, y: 0, width: 220, height: self.frame.size.height);
        leftOptionsLabel.textAlignment = .center;
        leftOptionsLabel.text = "leftOption"
        self.addSubview(leftOptionsLabel)
        leftOptionsLabel.lineBreakMode = .byTruncatingMiddle
        
        leftOptionsLabel.font = UIFont(name: helveticaRegular, size: 20)
        leftOptionsLabel.numberOfLines = 10;
        leftOptionsLabel.textColor  = blackTextColor
        
        
        rightOptionsLabel.frame = CGRect(x: self.frame.size.width - 10, y: 20, width: 220, height: self.frame.size.height -  40 );
        rightOptionsLabel.textAlignment = .center;
        rightOptionsLabel.text = "leftOption"
        self.addSubview(rightOptionsLabel)
        rightOptionsLabel.lineBreakMode = .byTruncatingMiddle
        rightOptionsLabel.font = UIFont(name: helveticaRegular, size: 20)
        
        rightOptionsLabel.numberOfLines = 10;
        rightOptionsLabel.textColor  = blackTextColor
        

        
        _optionValueImageView = UIImageView()
        _optionValueImageView.frame = CGRect(x: 240, y: (self.frame.size.height-25)/2, width: 20, height: 20);
        self.addSubview(_optionValueImageView);
        _optionValueImageView.contentMode = .scaleAspectFit
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func getHeightWithDetails(_ leftOptiondetails:AnyObject, withRightOptionDetails rightOptionsDetails:AnyObject)->CGFloat
    {
        if let OptionText = leftOptiondetails.object(forKey: "OptionText") as? String
        {
            leftOptionsLabel.text = OptionText
        }
        else
        {
            leftOptionsLabel.text = ""
        }
        
        if let OptionText = rightOptionsDetails.object(forKey: "OptionText") as? String
        {
            rightOptionsLabel.text = OptionText
        }
        else
        {
            rightOptionsLabel.text = ""
        }

        
        _optionValueImageView.image = UIImage(named: "Check.png")
        
        
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
        leftOptionsLabel.frame = CGRect(x: 10, y: 20, width: 220, height: self.frame.size.height -  40 );
        _optionValueImageView.frame = CGRect(x: 240, y: (self.frame.size.height-25)/2, width: 20, height: 20);
        rightOptionsLabel.frame = CGRect(x: self.frame.size.width - 230, y: 20, width: 220, height: self.frame.size.height -  40 );
    }
    
    func checkCorretAnswer(_ isAnswer:Bool)
    {
       
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
