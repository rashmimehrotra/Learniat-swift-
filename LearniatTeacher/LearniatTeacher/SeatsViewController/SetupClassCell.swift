//
//  SetupClassCell.swift
//  GridView
//
//  Created by mindshift_Deepak on 15/04/16.
//  Copyright © 2016 mindShiftApps. All rights reserved.
//

import Foundation
import UIKit

@objc protocol SetupClassCellDelegate
{
    
    
    optional func delegateCellPressedWithSelectedState(State:Bool, withCell seatCell:SetupClassCell)
    
    
    
}



class SetupClassCell: UIView,UIGestureRecognizerDelegate
{
    
     var refrenceDeskImageView = LBorderView()
    
    let EndCornerImageView = UIImageView()
    
    var _delgate: AnyObject!
    
    func setdelegate(delegate:AnyObject)
    {
        _delgate = delegate;
    }
    
    func   delegate()->AnyObject
    {
        return _delgate;
    }
    
    
    var currentSeatString = ""
    
    override init(frame: CGRect)
    {
        
        super.init(frame:frame)
        
        
        
        var deskSize:CGFloat = self.frame.size.width
        
        
        
        if (self.frame.size.height > self.frame.size.width)
        {
            deskSize = self.frame.size.width;
        }
        else if (self.frame.size.width>self.frame.size.height)
        {
            deskSize=self.frame.size.height;
        }
        else if(self.frame.size.width==self.frame.size.height)
        {
            deskSize=self.frame.size.width;
        }
        
        
        
        refrenceDeskImageView.frame = CGRectMake((self.frame.size.width-deskSize)/2, (self.frame.size.height-deskSize)/2,deskSize,deskSize)
        self.addSubview(refrenceDeskImageView)
        refrenceDeskImageView.backgroundColor = UIColor.clearColor()
        refrenceDeskImageView.userInteractionEnabled = true
        refrenceDeskImageView.borderType = BorderTypeDashed;
        refrenceDeskImageView.dashPattern = 4;
        refrenceDeskImageView.spacePattern = 4;
        refrenceDeskImageView.borderWidth = 1;
        
        refrenceDeskImageView.borderColor = standard_Red;
        let tap = UITapGestureRecognizer(target: self, action: Selector("handleTap:"))
        tap.delegate = self
        refrenceDeskImageView.addGestureRecognizer(tap)

        
        
        
        EndCornerImageView.frame = CGRectMake(-12,-12, 25,25)
        EndCornerImageView.image = UIImage(named: "Remove.png")
        refrenceDeskImageView.addSubview(EndCornerImageView)

        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func handleTap(sender: UITapGestureRecognizer? = nil) {
        // handling code
        
        
        if  EndCornerImageView.image == UIImage(named: "Add.png")
        {
                        
            if delegate().respondsToSelector(Selector("delegateCellPressedWithSelectedState:withCell:"))
            {
                delegate().delegateCellPressedWithSelectedState!(true, withCell:self)
                
            }
            
        }
        else
        {
                        
            if delegate().respondsToSelector(Selector("delegateCellPressedWithSelectedState:withCell:"))
            {
                delegate().delegateCellPressedWithSelectedState!(false, withCell:self)
                
            }
        }
        refrenceDeskImageView.bringSubviewToFront(EndCornerImageView)
        
    }
    
    
    
    
    
    
    

}