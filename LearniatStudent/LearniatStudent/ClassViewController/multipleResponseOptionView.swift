//
//  multipleResponseOptionView.swift
//  Learniat_Student_Iphone
//
//  Created by mindshift_Deepak on 05/02/16.
//  Copyright © 2016 mindShiftApps. All rights reserved.
//

import Foundation


@objc protocol multipleResponseOptionViewDelegate
{
    
    optional func delegateOptionTouchedWithState(state: Bool, withCurrentOptionDetails Details:AnyObject, withCurrentOption mOptionView:multipleResponseOptionView)
    
    
}


class multipleResponseOptionView: UIView
{
    
    var currentOptionDetails : AnyObject!
   
    var optionsLabel = UILabel()
    
    var _delgate: AnyObject!
    
    var currentOptionId = String()
    
    var isSelected :Bool = false
    
    
    override init(frame: CGRect) {
        
        super.init(frame:frame)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(multipleResponseOptionView.optionTouchedTapped))
        tap.numberOfTapsRequired = 1
        self.addGestureRecognizer(tap)
        self.backgroundColor = UIColor.whiteColor()
            }
    
    
    required init?(coder aDecoder: NSCoder)
    {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func setOptionDetails(details:AnyObject)
    {
        currentOptionDetails = details
        currentOptionId = details.objectForKey("OptionId") as! String
        
        optionsLabel.frame = CGRectMake(40, 0, self.frame.size.width-80, self.frame.size.height)
        self.addSubview(optionsLabel)
        optionsLabel.numberOfLines = 4
        optionsLabel.lineBreakMode = .ByTruncatingMiddle
        optionsLabel.textAlignment = .Center
        optionsLabel.text = (currentOptionDetails.objectForKey("OptionText") as! String)
        optionsLabel.textColor = standard_Button
        optionsLabel.font = UIFont (name: helveticaRegular, size: 18)
//        optionsLabel.backgroundColor = lightGrayColor
    }
    
    
    func optionTouchedTapped()
    {
        if isSelected == false
        {
            isSelected = true
            self.backgroundColor = standard_Button
            optionsLabel.textColor = UIColor.whiteColor()
            
            
            
        }
        else
        {
            isSelected = false
            self.backgroundColor = UIColor.whiteColor()
            optionsLabel.textColor = standard_Button
            
            
            
        }
        
        
       delegate().delegateOptionTouchedWithState!(isSelected, withCurrentOptionDetails: currentOptionDetails, withCurrentOption: self)
    }
    
    
    func setdelegate(delegate:AnyObject)
    {
        _delgate = delegate;
    }
    
    func   delegate()->AnyObject
    {
        return _delgate;
    }

    func setSelectedState(state:Bool)
    {
        isSelected = state
        
        
        if isSelected == false
        {
            self.backgroundColor = UIColor.whiteColor()
            optionsLabel.textColor = standard_Button
            
            
        }
        else
        {
            self.backgroundColor = standard_Button
            optionsLabel.textColor = UIColor.whiteColor()
        }
    }
    
    
    
    func checkOptionAnswerState()
    {
        
        
        self.backgroundColor = UIColor.clearColor()
        optionsLabel.textColor = topbarColor
        self.layer.borderColor = topbarColor.CGColor

        
        
        
        
        if isSelected
        {
            if (currentOptionDetails.objectForKey("IsAnswer") as! String) == "1"
            {
                self.backgroundColor = standard_Green
                optionsLabel.textColor = UIColor.whiteColor()
                self.layer.borderColor = standard_Green.CGColor
                
                let correctImage = UIImageView(frame:CGRectMake(5, 5, 30, self.frame.height - 10))
                correctImage.image = UIImage(named:"correct.png")
                correctImage.contentMode = .ScaleAspectFit
                self.addSubview(correctImage)
                
                
                
            }
            else if (currentOptionDetails.objectForKey("IsAnswer") as! String) == "0"
            {
                self.backgroundColor = standard_Red
                self.layer.borderColor = standard_Red.CGColor
                optionsLabel.textColor = UIColor.whiteColor()
                
                let wrongImage = UIImageView(frame:CGRectMake(5, 5, 30, self.frame.height - 10))
                wrongImage.image = UIImage(named:"wrong.png")
                wrongImage.contentMode = .ScaleAspectFit
                self.addSubview(wrongImage)
            }
        }
       
        else if (currentOptionDetails.objectForKey("IsAnswer") as! String) == "1"
        {
            self.backgroundColor = UIColor.whiteColor()
            optionsLabel.textColor = standard_Green
            self.layer.borderColor = standard_Green.CGColor
        }
    }
    
    func getselectedState() ->Bool
    {
        return isSelected
    }
    
    
}