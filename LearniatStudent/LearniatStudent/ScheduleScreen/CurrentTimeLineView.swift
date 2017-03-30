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
        
        
        self.backgroundColor = UIColor.clear
        
        let lineview =  UIImageView()
        lineview.frame = CGRect(x: 5, y: 4, width: self.frame.size.width,height: 2)
        self.addSubview(lineview)
        lineview.backgroundColor = standard_Green

        
        let circleView = UIImageView()
        circleView.frame = CGRect(x: 0,y: 0,width: 10,height: 10)
        self.addSubview(circleView)
        circleView.layer.cornerRadius =  circleView.frame.size.width/2
        circleView.backgroundColor = standard_Green
        
        
    }
    
    
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
        
       
    }

    
   
}
