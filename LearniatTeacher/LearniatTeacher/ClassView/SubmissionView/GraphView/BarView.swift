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
    
    var barView = UIImageView()
    

    
    override init(frame: CGRect)
    {
        
        super.init(frame:frame)
        
        barView.frame = CGRectMake((self.frame.size.width - (self.frame.size.width * 0.7)) / 2, 0, (self.frame.size.width * 0.7), self.frame.size.height)
        self.addSubview(barView)
        
    }
    
    
    
    required init?(coder aDecoder: NSCoder)
    {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func setBarColor(color:UIColor)
    {
        barView.backgroundColor = color
    }
    
    func changeFrameWithHeight(height:CGFloat)
    {
        barView.frame = CGRectMake(barView.frame.origin.x ,0 , barView.frame.size.width ,height)
    }
    
    func increasePresentValue()
    {
        presentValue = presentValue + 8
    }
    

    
    
}