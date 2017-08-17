//
//  SpinnerButtonView.swift
//  SpinnerButton
//
//  Created by Deepak MK on 07/04/17.
//  Copyright © 2017 Mindshift. All rights reserved.
//

import UIKit

@objc protocol SpinnerButtonViewDelegate
{
    
    @objc optional func delegateButtonPressedWithButtonText(buttonText:String)
}

class SpinnerButtonView: UIView,UIGestureRecognizerDelegate {

    var mButtonLabel = UILabel()
    
    var mActivityIndicator =  UIActivityIndicatorView()
  
    var _delgate: AnyObject!
    
    func setdelegate(_ delegate:AnyObject)
    {
        _delgate = delegate;
    }
    
    func   delegate()->AnyObject
    {
        return _delgate;
    }
    
    
    override init(frame: CGRect)
    {
        super.init(frame: frame)
        
        
        mButtonLabel.frame = CGRect(x: 0, y: 0, width: self.frame.size.width, height: self.frame.size.height)
        mButtonLabel.numberOfLines = 4
        mButtonLabel.lineBreakMode = .byTruncatingMiddle
        mButtonLabel.textAlignment = .center
        mButtonLabel.font =  UIFont(name: "Roboto-Regular", size: 16)
        self.addSubview(mButtonLabel)
        
        
        
        mActivityIndicator.frame = CGRect(x: 0, y: 0, width: self.frame.size.width, height: self.frame.size.height)
        self.addSubview(mActivityIndicator)
        mActivityIndicator.isHidden = true
        mActivityIndicator.color = UIColor.lightGray
        
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(SpinnerButtonView.handleTap(_:)))
        tap.delegate = self
        self.addGestureRecognizer(tap)
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
   
    
    func setButtonTex(text:String, withFont font:UIFont, withColor color:UIColor)
    {
        mButtonLabel.font =  font
        mButtonLabel.text = text
        mButtonLabel.textColor = color
    }
    
    func handleTap(_ sender: UITapGestureRecognizer? = nil)
    {
       
        
        UIView.animate(withDuration: 0.5, animations:
            {
                
                self.mButtonLabel.isHidden = true
                self.mActivityIndicator.isHidden = false
                self.mActivityIndicator.startAnimating()
        })
        
        
        
        
        if delegate().responds(to: #selector(SpinnerButtonViewDelegate.delegateButtonPressedWithButtonText(buttonText:)))
        {
            delegate().delegateButtonPressedWithButtonText!(buttonText: mButtonLabel.text ?? String())
        }
       
        
    }
    
    
    func restartButton()
    {
        
        UIView.animate(withDuration: 0.5, animations:
            {
               
                self.mButtonLabel.isHidden = false
                self.mActivityIndicator.isHidden = true
                self.mActivityIndicator.stopAnimating()
        })
    }
    
    
    
    

}
