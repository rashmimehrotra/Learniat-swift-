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
    
    
    var timeLabel = UILabel()
    
    override init(frame: CGRect) {
        
        super.init(frame:frame)
        
        
        timeLabel.frame = CGRectMake(0, 0, 50, self.frame.size.height)
        self.addSubview(timeLabel)
        timeLabel.font = UIFont(name: helveticaRegular, size: 10)
        timeLabel.textColor = standard_Red
        timeLabel.textAlignment = .Right
        
        let circleView = UIImageView()
        circleView.frame = CGRectMake(timeLabel.frame.origin.x + timeLabel.frame.size.width + 5,0,10,10)
        self.addSubview(circleView)
        circleView.layer.cornerRadius =  circleView.frame.size.width/2
        circleView.backgroundColor = standard_Yellow

        
        
        self.backgroundColor = UIColor.clearColor()
        
        let lineview =  UIImageView()
        lineview.frame = CGRectMake(circleView.frame.origin.x + (circleView.frame.size.width/2), 4, self.frame.size.width - (timeLabel.frame.origin.x + (timeLabel.frame.size.width/2)),2)
        self.addSubview(lineview)
        lineview.backgroundColor = standard_Yellow

        
        
        
        
        
        
    }
    
    
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
        
       
    }
    
    func setCurrentTimeLabel(currentTime :String)
    {
        timeLabel.text = currentTime
    }
    

    
   
}