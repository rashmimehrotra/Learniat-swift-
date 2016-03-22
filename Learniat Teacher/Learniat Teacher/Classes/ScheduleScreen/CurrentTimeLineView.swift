//
//  CurrentTimeLineView.swift
//  Learniat_Student_Iphone
//
//  Created by mindshift_Deepak on 30/01/16.
//  Copyright © 2016 mindShiftApps. All rights reserved.
//

import Foundation
class CurrentTimeLineView: UIView
{
    override init(frame: CGRect) {
        
        super.init(frame:frame)
        
        
        self.backgroundColor = UIColor.clearColor()
        
        let lineview =  UIImageView()
        lineview.frame = CGRectMake(5, 4, self.frame.size.width,2)
        self.addSubview(lineview)
        lineview.backgroundColor = standard_Green

        
        let circleView = UIImageView()
        circleView.frame = CGRectMake(0,0,10,10)
        self.addSubview(circleView)
        circleView.layer.cornerRadius =  circleView.frame.size.width/2
        circleView.backgroundColor = standard_Green
        
        
        
        
        
    }
    
    
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
        
       
    }

    
   
}