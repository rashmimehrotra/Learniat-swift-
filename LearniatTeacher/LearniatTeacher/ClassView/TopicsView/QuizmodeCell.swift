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
    var currentQuestionDetails  :AnyObject!
    override init(frame: CGRect)
    {
        
        super.init(frame: frame)
        
        
        self.backgroundColor = whiteColor
        
        let button = UIButton(frame:CGRect(x: 0, y: 0, width: self.frame.size.width ,height: self.frame.size.height));
        self.addSubview(button)
        button.addTarget(self, action: #selector(QuizmodeCell.checkMarkPressed), for: UIControlEvents.touchUpInside)
        

        
        
        m_checkBoxButton = UIButton(frame:CGRect(x: 0, y: 0, width: self.frame.size.height ,height: self.frame.size.height));
        self.addSubview(m_checkBoxButton);
        m_checkBoxButton.backgroundColor = UIColor.white
        m_checkBoxButton.addTarget(self, action: #selector(QuizmodeCell.checkMarkPressed), for: UIControlEvents.touchUpInside)
        
        checkBoxImage.frame = CGRect(x: 5, y: 20 ,width: 20,height: 20)
        checkBoxImage.image = UIImage(named:"Checked.png");
        self.addSubview(checkBoxImage);

        
        
        
        m_MainTopicLabel = UILabel(frame: CGRect(x: checkBoxImage.frame.size.width + checkBoxImage.frame.origin.x + 10 , y: 5  , width: self.frame.size.width - (checkBoxImage.frame.size.width + checkBoxImage.frame.origin.x + 20), height: self.frame.size.height - 10    ))
        m_MainTopicLabel.font = UIFont(name:helveticaRegular, size: 16)
        self.addSubview(m_MainTopicLabel)
        m_MainTopicLabel.textColor = blackTextColor
        m_MainTopicLabel.textAlignment = .left
        m_MainTopicLabel.lineBreakMode = .byTruncatingMiddle

        
    }
    
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setQuestionDict(_ details:AnyObject)
    {
        
        currentQuestionDetails = details
        
        
        if let questionName = details.object(forKey: "Name")as? String
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
