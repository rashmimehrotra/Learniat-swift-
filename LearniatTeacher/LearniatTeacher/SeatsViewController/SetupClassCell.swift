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
    
    
    @objc optional func delegateCellPressedWithSelectedState(_ State:Bool, withCell seatCell:SetupClassCell)
    
    
    
}



class SetupClassCell: UIView,UIGestureRecognizerDelegate
{
    
     var refrenceDeskImageView = LBorderView()
    
    let EndCornerImageView = UIImageView()
    
    var _delgate: AnyObject!
    
    func setdelegate(_ delegate:AnyObject)
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
        
        
        
        refrenceDeskImageView.frame = CGRect(x: (self.frame.size.width-deskSize)/2, y: (self.frame.size.height-deskSize)/2,width: deskSize,height: deskSize)
        self.addSubview(refrenceDeskImageView)
        refrenceDeskImageView.backgroundColor = UIColor.clear
        refrenceDeskImageView.isUserInteractionEnabled = true
        refrenceDeskImageView.borderType = BorderTypeDashed;
        refrenceDeskImageView.dashPattern = 4;
        refrenceDeskImageView.spacePattern = 4;
        refrenceDeskImageView.borderWidth = 1;
        
        refrenceDeskImageView.borderColor = standard_Red;
        let tap = UITapGestureRecognizer(target: self, action: #selector(SetupClassCell.handleTap(_:)))
        tap.delegate = self
        refrenceDeskImageView.addGestureRecognizer(tap)

        
        
        
        EndCornerImageView.frame = CGRect(x: -12,y: -12, width: 25,height: 25)
        EndCornerImageView.image = UIImage(named: "Remove.png")
        refrenceDeskImageView.addSubview(EndCornerImageView)

        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func handleTap(_ sender: UITapGestureRecognizer? = nil) {
        // handling code
        
        
        if  EndCornerImageView.image == UIImage(named: "Add.png")
        {
                        
            if delegate().responds(to: #selector(SetupClassCellDelegate.delegateCellPressedWithSelectedState(_:withCell:)))
            {
                delegate().delegateCellPressedWithSelectedState!(true, withCell:self)
                
            }
            
        }
        else
        {
                        
            if delegate().responds(to: #selector(SetupClassCellDelegate.delegateCellPressedWithSelectedState(_:withCell:)))
            {
                delegate().delegateCellPressedWithSelectedState!(false, withCell:self)
                
            }
        }
        refrenceDeskImageView.bringSubview(toFront: EndCornerImageView)
        
    }
    
    
    
    
    
    
    

}
