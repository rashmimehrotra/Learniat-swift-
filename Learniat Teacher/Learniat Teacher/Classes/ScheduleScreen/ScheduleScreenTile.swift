
//
//  ScheduleScreenTile.swift
//  Learniat_Student_Iphone
//
//  Created by Deepak MK on 01/02/16.
//  Copyright © 2016 mindShiftApps. All rights reserved.
//

import Foundation

@objc protocol ScheduleScreenTileDelegate
{
    
    optional func delegateScheduleTileTouchedWithState(state: String, withCurrentTileDetails Details:AnyObject)
    
    
}

class ScheduleScreenTile: UIImageView, UIGestureRecognizerDelegate
{
    
    
    var mClassName = UIVerticalAlignLabel()
    var mTimeLabel = UILabel()
    var _delgate: AnyObject!
    var sessionDetails : AnyObject!
    override init(frame: CGRect) {
        
        super.init(frame:frame)
    }
    
    
    
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func setdelegate(delegate:AnyObject)
    {
        _delgate = delegate;
    }
    
    func   delegate()->AnyObject
    {
        return _delgate;
    }
    
    
    func loadAllViewObjects()
    {
        let tap = UITapGestureRecognizer(target: self, action: Selector("handleTap:"))
        tap.delegate = self
        self.addGestureRecognizer(tap)
        
        
        mClassName.verticalAlignment = .VerticalAlignmentTop
        
        mClassName.textColor = UIColor.whiteColor()
        self.addSubview(mClassName)
        mClassName.adjustsFontSizeToFitWidth = true
        mClassName.minimumScaleFactor = 0.2
        mClassName.lineBreakMode = NSLineBreakMode.ByTruncatingTail;
        
        
        if self.frame.size.height/2 < 12
        {
//            mClassName.font = mClassName.font.fontWithSize(self.frame.size.height/2)
            
            mClassName.frame = CGRectMake(10, 2, self.frame.size.width, (self.frame.size.height/1.2))
            
            mClassName.font = UIFont(name: "Roboto-Regular", size: (self.frame.size.height/2))
        }
        else
        {
            mClassName.frame = CGRectMake(10, 5, self.frame.size.width, (self.frame.size.height/1.2))
            
            mClassName.font = UIFont(name: "Roboto-Regular", size: 12)
        }
        
        
        
        
        
        
        
        self.userInteractionEnabled = true

        
    }
    
    func handleTap(sender: UITapGestureRecognizer? = nil)
    {
        // handling code
        
        let sessionState = sessionDetails.objectForKey(kSessionState) as! String
        
        delegate().delegateScheduleTileTouchedWithState!(sessionState, withCurrentTileDetails: sessionDetails)
        
    }
    
    func setCurrentSessionDetails(details :AnyObject)
    {
        
        
        loadAllViewObjects()
        
        sessionDetails = details

        updateSessionColorWithSessionState(sessionDetails.objectForKey(kSessionState) as! String)
        
        let classNameWithRoom = String(format:"%@(%@)",(details.objectForKey(kClassName) as! String),(details.objectForKey(kRoomName) as! String))
        mClassName.text = classNameWithRoom
    
    }
    
    
    
    
    
    func updateSessionColorWithSessionState(sessionState:String)
    {
        
        
        switch sessionState
        {
            case kScheduled:
                self.backgroundColor = UIColor(red: 58.0/255.0, green: 114.0/255.0, blue: 168.0/255.0, alpha: 1)
                break
                
            case kopened:
                self.backgroundColor = UIColor(red: 0.0/255.0, green: 174.0/255.0, blue: 239.0/255.0, alpha: 1)
                break
                
            case kLive:
                self.backgroundColor = UIColor(red: 76.0/255.0, green: 217.0/255.0, blue: 100.0/255.0, alpha: 1)
                
                break
                
            case kCanClled:
                self.image = UIImage(named:"Cancelled.png")
                break
                
            case kEnded:
                self.backgroundColor = UIColor(red: 152.0/255.0, green: 180.0/255.0, blue: 207.0/255.0, alpha: 1)
                
                break
                
                
            default:
                print("Not the letter A")
        }
    }
    
    
    
}