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
    
    
    
    func setImage(_selectedImageName:String, _unselectedImageName:String, withText text:String)
    {
        
        
        
        
        buttonImage.frame = CGRectMake((self.frame.size.width - (self.frame.size .height - 40))/2, 10, self.frame.size .height - 40 , self.frame.size .height - 40 )
        self.addSubview(buttonImage)
        buttonImage.contentMode = .ScaleAspectFit
        
        
        buttonLabel.frame = CGRectMake(5, buttonImage.frame.size.height + buttonImage.frame.origin.y + 5 , self.frame.size.width - 10, 20)
        self.addSubview(buttonLabel)
        buttonLabel.textColor = UIColor.whiteColor()
        buttonLabel.text = text
        
        
        buttonLabel.textAlignment = .Center
        
        selectedImage = UIImage(named: _selectedImageName)!
        
        unSelectedImage = UIImage(named: _unselectedImageName)!
        
        
        
        
        eventBubble.frame =  CGRectMake(self.frame.size.width - 25, 0, 20, 20)
        eventBubble.backgroundColor = standard_Red
        self.addSubview(eventBubble)
        eventBubble.layer.cornerRadius = eventBubble.frame.size.width / 2
        eventBubble.textColor = whiteColor
        eventBubble.layer.masksToBounds = true
        eventBubble.textAlignment = .Center
        eventBubble.font = UIFont(name:helveticaMedium, size: 16)
        eventBubble.hidden = true
        
    }
    
    
    func buttonselected()
    {
        buttonImage.image = selectedImage
        buttonLabel.textColor = standard_Yellow
        self.backgroundColor = UIColor(red: 29/255.0, green: 54/255.0, blue: 79/255.0, alpha: 1)
        eventBubble.hidden = true
        eventValue = 0
    }
    
    
    func buttonUnSelected()
    {
        buttonImage.image = unSelectedImage
        buttonLabel.textColor = UIColor.whiteColor()
        self.backgroundColor = UIColor.clearColor()
    }
    
    
    func newEventRaised()
    {
        
        
        if buttonImage.image == unSelectedImage
        {
            eventValue = eventValue + 1
             eventBubble.hidden = false
            eventBubble.text = "\(eventValue)"
        }
        else
        {
            eventValue = 0
             eventBubble.hidden = true
        }
    }
    
}