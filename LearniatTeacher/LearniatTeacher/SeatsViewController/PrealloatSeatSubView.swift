//
//  PrealloatSeatSubView.swift
//  Learniat Teacher
//
//  Created by Deepak MK on 23/03/16.
//  Copyright © 2016 Mindshift. All rights reserved.
//

import Foundation
class PrealloatSeatSubView: UIView{
    
    
    override init(frame: CGRect)
    {
        super.init(frame:frame)
        
        
        var sizeOfCell:CGFloat = self.frame.size.width
        
        
        if self.frame.size.width > self.frame.size.height
        {
            sizeOfCell = self.frame.size.height
        }
        else
        {
            sizeOfCell = self.frame.size.width
        }
        
        sizeOfCell = sizeOfCell * 0.9
        
        let mainChariView = LBorderView(frame: CGRect(x: (self.frame.size.width - sizeOfCell )/2 , y: (self.frame.size.height - sizeOfCell )/2 , width: sizeOfCell, height: sizeOfCell))
        self.addSubview(mainChariView)
        mainChariView.borderType = BorderTypeDashed;
        mainChariView.dashPattern = 4;
        mainChariView.spacePattern = 4;
        mainChariView.borderWidth = 1;
        mainChariView.borderColor = lightGrayColor;
    }
    
    required init?(coder aDecoder: NSCoder)
    {
        fatalError("init(coder:) has not been implemented")
    }
    
}
