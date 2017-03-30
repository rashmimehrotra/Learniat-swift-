//
//  barView.swift
//  graphView
//
//  Created by mindshift_Deepak on 09/02/16.
//  Copyright © 2016 mindShiftApps. All rights reserved.
//
import Foundation




class BarView: UIButton
{
    
    
    var presentValue :Int = 0
    
    var presentWidthValue :Int = 1
    
    var barView = UIImageView()
    

    
    override init(frame: CGRect)
    {
        
        super.init(frame:frame)
        
        barView.frame = CGRect(x: (self.frame.size.width - (self.frame.size.width * 0.7)) / 2, y: 0, width: (self.frame.size.width * 0.7), height: self.frame.size.height)
        self.addSubview(barView)
        
    }
    
    
    
    required init?(coder aDecoder: NSCoder)
    {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func setBarColor(_ color:UIColor)
    {
        barView.backgroundColor = color
    }
    
    func changeFrameWithHeight(_ height:CGFloat)
    {
        
        barView.frame = CGRect(x: barView.frame.origin.x ,y: 0 , width: barView.frame.size.width ,height: height)
    }
    
    func increasePresentValue()
    {
        presentValue = presentValue + 1
    }
    
    func increasePresentWidthvalue()
    {
        presentWidthValue  = presentWidthValue + 1
    }

    
    
}
