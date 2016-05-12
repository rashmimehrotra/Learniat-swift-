//
//  MatchColumnCell.swift
//  LearniatStudent
//
//  Created by Deepak MK on 11/05/16.
//  Copyright © 2016 Mindshift. All rights reserved.
//

import Foundation
import UIKit
class MatchColumnCell: UITableViewCell
{
    var optionsLabel : UILabel!
    
    override func awakeFromNib()
    {
        super.awakeFromNib()
       
        
        self.addDashedBorder()
        
        
        
    }
    
    
    
    func setOptionDetails(details:AnyObject)
    {
        
        if optionsLabel == nil
        {
            
            let containerView = UIView(frame:CGRectMake(10, 10, self.contentView.frame.size.width-20, 100))
            self.contentView.addSubview(containerView)
            containerView.layer.borderColor = standard_Button.CGColor
            containerView.layer.cornerRadius = containerView.frame.size.height / 2
            containerView.layer.borderWidth = 1
            containerView.layer.masksToBounds = true
            
            
            optionsLabel  = UILabel(frame:CGRectMake(40, 0, containerView.frame.size.width-80, containerView.frame.size.height))
            containerView.addSubview(optionsLabel)
            optionsLabel.numberOfLines = 4
            optionsLabel.lineBreakMode = .ByTruncatingMiddle
            optionsLabel.textAlignment = .Center
            optionsLabel.textColor = standard_Button
            optionsLabel.font = UIFont (name: helveticaRegular, size: 18)
            if let OptionText = details.objectForKey("OptionText") as? String
            {
                optionsLabel.text = OptionText
            }

            
        }
    }
    
    
    
   

}