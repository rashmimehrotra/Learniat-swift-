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
        lineview.frame = CGRectMake(5, 2, self.frame.size.width, 1)
        self.addSubview(lineview)
        lineview.backgroundColor = UIColor(red: 204.0/255.0, green: 204.0/255.0, blue: 0/255.0, alpha: 1)

        
        let circleView = UIImageView()
        circleView.frame = CGRectMake(0,0,5,5)
        self.addSubview(circleView)
        circleView.layer.cornerRadius =  circleView.frame.size.width/2
        circleView.backgroundColor = UIColor(red: 204.0/255.0, green: 204.0/255.0, blue: 0/255.0, alpha: 1)
        
        
        
        
        
    }
    
    
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
        
       
    }

    
   
}