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
    
    @objc optional func delegateOptionTouchedWithState(_ state: Bool, withCurrentOptionDetails Details:AnyObject, withCurrentOption mOptionView:multipleResponseOptionView)
    
    
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
        self.backgroundColor = UIColor.white
            }
    
    
    required init?(coder aDecoder: NSCoder)
    {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func setOptionDetails(_ details:AnyObject)
    {
        currentOptionDetails = details
        currentOptionId = details.object(forKey: "OptionId") as! String
        
        optionsLabel.frame = CGRect(x: 40, y: 0, width: self.frame.size.width-80, height: self.frame.size.height)
        self.addSubview(optionsLabel)
        optionsLabel.numberOfLines = 4
        optionsLabel.lineBreakMode = .byTruncatingMiddle
        optionsLabel.textAlignment = .center
        optionsLabel.text = (currentOptionDetails.object(forKey: "OptionText") as! String)
        optionsLabel.textColor = standard_Button
        optionsLabel.font = UIFont (name: helveticaRegular, size: 18)
//        optionsLabel.backgroundColor = lightGrayColor
    }
    
    
    @objc func optionTouchedTapped()
    {
        if isSelected == false
        {
            isSelected = true
            self.backgroundColor = standard_Button
            optionsLabel.textColor = UIColor.white
            
            
            
        }
        else
        {
            isSelected = false
            self.backgroundColor = UIColor.white
            optionsLabel.textColor = standard_Button
            
            
            
        }
        
        
       delegate().delegateOptionTouchedWithState!(isSelected, withCurrentOptionDetails: currentOptionDetails, withCurrentOption: self)
    }
    
    
    func setdelegate(_ delegate:AnyObject)
    {
        _delgate = delegate;
    }
    
    func   delegate()->AnyObject
    {
        return _delgate;
    }

    func setSelectedState(_ state:Bool)
    {
        isSelected = state
        
        
        if isSelected == false
        {
            self.backgroundColor = UIColor.white
            optionsLabel.textColor = standard_Button
            
            
        }
        else
        {
            self.backgroundColor = standard_Button
            optionsLabel.textColor = UIColor.white
        }
    }
    
    
    
    func checkOptionAnswerState()
    {
        
        
        self.backgroundColor = UIColor.clear
        optionsLabel.textColor = topbarColor
        self.layer.borderColor = topbarColor.cgColor

        
        
        
        
        if isSelected
        {
            if (currentOptionDetails.object(forKey: "IsAnswer") as! String) == "1"
            {
                self.backgroundColor = standard_Green
                optionsLabel.textColor = UIColor.white
                self.layer.borderColor = standard_Green.cgColor
                
                let correctImage = UIImageView(frame:CGRect(x: 5, y: 5, width: 30, height: self.frame.height - 10))
                correctImage.image = UIImage(named:"correct.png")
                correctImage.contentMode = .scaleAspectFit
                self.addSubview(correctImage)
                
                
                
            }
            else if (currentOptionDetails.object(forKey: "IsAnswer") as! String) == "0"
            {
                self.backgroundColor = standard_Red
                self.layer.borderColor = standard_Red.cgColor
                optionsLabel.textColor = UIColor.white
                
                let wrongImage = UIImageView(frame:CGRect(x: 5, y: 5, width: 30, height: self.frame.height - 10))
                wrongImage.image = UIImage(named:"wrong.png")
                wrongImage.contentMode = .scaleAspectFit
                self.addSubview(wrongImage)
            }
        }
       
        else if (currentOptionDetails.object(forKey: "IsAnswer") as! String) == "1"
        {
            self.backgroundColor = UIColor.white
            optionsLabel.textColor = standard_Green
            self.layer.borderColor = standard_Green.cgColor
        }
    }
    
    func getselectedState() ->Bool
    {
        return isSelected
    }
    
    
}
