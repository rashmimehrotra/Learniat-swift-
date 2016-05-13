//
//  VolunteerPopoverController.swift
//  LearniatTeacher
//
//  Created by Deepak MK on 13/05/16.
//  Copyright © 2016 Mindshift. All rights reserved.
//

import Foundation

@objc protocol VolunteerPopoverControllerDelegate
{
    
    
    optional func delegateGiveAnswerPressedWithVolunteerDetails(volunteerDetails:AnyObject)
    
}


class VolunteerPopoverController: UIViewController,VolunteerPopopverCellDelegate
{
    
    var mStudentsScrollView = UIScrollView()
    
    var _delgate: AnyObject!
    
    func setdelegate(delegate:AnyObject)
    {
        _delgate = delegate;
    }
    
    func   delegate()->AnyObject
    {
        return _delgate;
    }
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.view.backgroundColor = whiteBackgroundColor
        
       

    }
    
    
    
    func addVolunteerWithDetails(VolunteersArray:NSMutableArray)
    {
        
       
        
        var height :CGFloat = CGFloat((VolunteersArray.count * 60))
        
        
        if height > UIScreen.mainScreen().bounds.height - 100
        {
            height = UIScreen.mainScreen().bounds.height - 100
        }
        

        
        mStudentsScrollView.frame = CGRectMake(0, 0, 300, height)
        self.view.addSubview(mStudentsScrollView)
        
        var currentYPosition :CGFloat = 0
        
        for index  in 0 ..< VolunteersArray.count
        {
            let details = VolunteersArray.objectAtIndex(index)
            
            let mQuerySubView = VolunteerPopopverCell(frame: CGRectMake(0 , currentYPosition, 300 ,60))
            mStudentsScrollView.addSubview(mQuerySubView)
            mQuerySubView.setdelegate(self)
            mQuerySubView.setVolunteersDetails(details)
            currentYPosition = currentYPosition + mQuerySubView.frame.size.height
        }
        
        
        self.preferredContentSize = CGSize(width: 300, height: height)
        
        
        mStudentsScrollView.contentSize = CGSizeMake(0, currentYPosition)

        
    }
    
    var _Popover:AnyObject!
    
    func setPopover(popover:AnyObject)
    {
        _Popover = popover
    }
    
    func popover()-> AnyObject
    {
        return _Popover
    }
    
    func delegateCellPressedWithVolunteerDetails(volunteerDetails: AnyObject)
    {
        delegate().delegateGiveAnswerPressedWithVolunteerDetails!(volunteerDetails)
        _Popover.dismissPopoverAnimated(true)
    }
    
}