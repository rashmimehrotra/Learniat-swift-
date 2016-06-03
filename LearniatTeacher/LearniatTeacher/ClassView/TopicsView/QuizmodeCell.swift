//
//  QuizmodeCell.swift
//  LearniatTeacher
//
//  Created by Deepak MK on 02/06/16.
//  Copyright © 2016 Mindshift. All rights reserved.
//

import Foundation
import UIKit
class QuizmodeCell: UIView
{
    
    var m_MainTopicLabel    = UILabel()
    let checkBoxImage       = UIImageView()
    var  isSelected             = true
    var m_checkBoxButton :UIButton!
    
    override init(frame: CGRect)
    {
        
        super.init(frame: frame)
        
        
        self.backgroundColor = whiteColor
        
        let button = UIButton(frame:CGRectMake(0, 0, self.frame.size.width ,self.frame.size.height));
        self.addSubview(button)
        button.addTarget(self, action: #selector(QuizmodeCell.checkMarkPressed), forControlEvents: UIControlEvents.TouchUpInside)
        

        
        
        m_checkBoxButton = UIButton(frame:CGRectMake(0, 0, self.frame.size.height ,self.frame.size.height));
        self.addSubview(m_checkBoxButton);
        m_checkBoxButton.backgroundColor = UIColor.whiteColor()
        m_checkBoxButton.addTarget(self, action: #selector(QuizmodeCell.checkMarkPressed), forControlEvents: UIControlEvents.TouchUpInside)
        
        checkBoxImage.frame = CGRectMake(5, 20 ,20,20)
        checkBoxImage.image = UIImage(named:"Checked.png");
        self.addSubview(checkBoxImage);

        
        
        
        m_MainTopicLabel = UILabel(frame: CGRectMake(checkBoxImage.frame.size.width + checkBoxImage.frame.origin.x + 10 , 5  , self.frame.size.width - (checkBoxImage.frame.size.width + checkBoxImage.frame.origin.x + 20), self.frame.size.height - 10    ))
        m_MainTopicLabel.font = UIFont(name:helveticaRegular, size: 16)
        self.addSubview(m_MainTopicLabel)
        m_MainTopicLabel.textColor = blackTextColor
        m_MainTopicLabel.textAlignment = .Left
        m_MainTopicLabel.lineBreakMode = .ByTruncatingMiddle

        
    }
    
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setQuestionDict(details:AnyObject)
    {
        if let questionName = details.objectForKey("Name")as? String
        {
            m_MainTopicLabel.text = "\(questionName)"
        }
    }
    
    func checkMarkPressed()
    {
        if isSelected == true
        {
            
            checkBoxImage.image = UIImage(named:"Unchecked.png");
            isSelected = false
            
            
        }
        else
        {
           
            checkBoxImage.image = UIImage(named:"Checked.png");
            isSelected = true
           
        }
        
    }
    
    
    
}