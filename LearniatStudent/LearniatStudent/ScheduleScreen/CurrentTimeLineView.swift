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
        
        // By Ujjval
        // ==========================================
        
        // Add current time label & change frame of circle and line view
        
        timeLabel.frame = CGRect(x: 0, y: 0, width: 50, height: self.frame.size.height)
        self.addSubview(timeLabel)
        timeLabel.font = UIFont(name: helveticaRegular, size: 10)
        timeLabel.textColor = standard_Red
        timeLabel.textAlignment = .right
        
        self.backgroundColor = UIColor.clear
        
        let circleView = UIImageView()
        circleView.frame = CGRect(x: timeLabel.frame.origin.x + timeLabel.frame.size.width + 5,y: 0,width: 10,height: 10)
        self.addSubview(circleView)
        circleView.layer.cornerRadius =  circleView.frame.size.width/2
        circleView.backgroundColor = standard_Green
        
        let lineview =  UIImageView()
        lineview.frame = CGRect(x: circleView.frame.origin.x + (circleView.frame.size.width/2), y: 4, width: self.frame.size.width - (timeLabel.frame.origin.x + (timeLabel.frame.size.width/2)),height: 2)
        self.addSubview(lineview)
        lineview.backgroundColor = standard_Green
        
        // ==========================================
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // By Ujjval
    // Set current time on label
    // ==========================================
    
    func setCurrentTimeLabel(_ currentTime :String)
    {
        timeLabel.text = currentTime
    }
    
    // ==========================================
}
