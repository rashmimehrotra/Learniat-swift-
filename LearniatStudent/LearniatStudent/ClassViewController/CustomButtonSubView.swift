//
//  CustomButtonSubView.swift
//  LearniatStudent
//
//  Created by Deepak MK on 10/05/16.
//  Copyright © 2016 Mindshift. All rights reserved.
//

import Foundation
class CustomButtonSubView: UIButton
{
    
    var buttonImage = UIImageView()
    
    var buttonLabel = UILabel()
    
    var selectedImage   = UIImage()
    
    var selectedColor   = UIColor()
    
    var unSelectedImage     = UIImage()
    
    var unSelectedColor     = UIColor()
    
    var eventBubble         = UILabel()
    
    var eventValue      = 0
    
    override init(frame: CGRect)
    {
        super.init(frame: frame)
        
        
       
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    func setImage(_ _selectedImageName:String, _unselectedImageName:String, withText text:String)
    {
        
        
        
        
        buttonImage.frame = CGRect(x: (self.frame.size.width - (self.frame.size .height - 40))/2, y: 10, width: self.frame.size .height - 40 , height: self.frame.size .height - 40 )
        self.addSubview(buttonImage)
        buttonImage.contentMode = .scaleAspectFit
        
        
        buttonLabel.frame = CGRect(x: 5, y: buttonImage.frame.size.height + buttonImage.frame.origin.y + 5 , width: self.frame.size.width - 10, height: 20)
        self.addSubview(buttonLabel)
        buttonLabel.textColor = UIColor.white
        buttonLabel.text = text
        
        
        buttonLabel.textAlignment = .center
        
        selectedImage = UIImage(named: _selectedImageName)!
        
        unSelectedImage = UIImage(named: _unselectedImageName)!
        
        
        
        
        eventBubble.frame =  CGRect(x: self.frame.size.width - 25, y: 0, width: 20, height: 20)
        eventBubble.backgroundColor = standard_Red
        self.addSubview(eventBubble)
        eventBubble.layer.cornerRadius = eventBubble.frame.size.width / 2
        eventBubble.textColor = whiteColor
        eventBubble.layer.masksToBounds = true
        eventBubble.textAlignment = .center
        eventBubble.font = UIFont(name:helveticaMedium, size: 16)
        eventBubble.isHidden = true
        
    }
    
    
    func buttonselected()
    {
        buttonImage.image = selectedImage
        buttonLabel.textColor = standard_Yellow
        self.backgroundColor = UIColor(red: 29/255.0, green: 54/255.0, blue: 79/255.0, alpha: 1)
        eventBubble.isHidden = true
        eventValue = 0
    }
    
    
    func buttonUnSelected()
    {
        buttonImage.image = unSelectedImage
        buttonLabel.textColor = UIColor.white
        self.backgroundColor = UIColor.clear
    }
    
    
    func newEventRaised()
    {
        
        
        if buttonImage.image == unSelectedImage
        {
            eventValue = eventValue + 1
             eventBubble.isHidden = false
            eventBubble.text = "\(eventValue)"
        }
        else
        {
            eventValue = 0
             eventBubble.isHidden = true
        }
    }
    
}
