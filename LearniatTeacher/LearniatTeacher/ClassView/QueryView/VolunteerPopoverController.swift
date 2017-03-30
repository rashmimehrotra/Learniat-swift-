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
    
    
    @objc optional func delegateGiveAnswerPressedWithVolunteerDetails(_ volunteerDetails:AnyObject)
    
}


class VolunteerPopoverController: UIViewController,VolunteerPopopverCellDelegate
{
    
    var mStudentsScrollView = UIScrollView()
    
    var _delgate: AnyObject!
    
    func setdelegate(_ delegate:AnyObject)
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
    
    
    
    func addVolunteerWithDetails(_ VolunteersArray:NSMutableArray)
    {
        
       
        
        var height :CGFloat = CGFloat((VolunteersArray.count * 60))
        
        
        if height > UIScreen.main.bounds.height - 100
        {
            height = UIScreen.main.bounds.height - 100
        }
        

        
        mStudentsScrollView.frame = CGRect(x: 0, y: 0, width: 300, height: height)
        self.view.addSubview(mStudentsScrollView)
        
        var currentYPosition :CGFloat = 0
        
        for index  in 0 ..< VolunteersArray.count
        {
            let details = VolunteersArray.object(at: index)
            
            let mQuerySubView = VolunteerPopopverCell(frame: CGRect(x: 0 , y: currentYPosition, width: 300 ,height: 60))
            mStudentsScrollView.addSubview(mQuerySubView)
            mQuerySubView.setdelegate(self)
            mQuerySubView.setVolunteersDetails(details as AnyObject)
            currentYPosition = currentYPosition + mQuerySubView.frame.size.height
        }
        
        
        self.preferredContentSize = CGSize(width: 300, height: height)
        
        
        mStudentsScrollView.contentSize = CGSize(width: 0, height: currentYPosition)

        
    }
    
    
    var _Popover:UIPopoverController!
    
    func setPopover(_ popover:UIPopoverController)
    {
        _Popover = popover
    }
    
    func popover()-> UIPopoverController
    {
        return _Popover
    }
    
    
    func delegateCellPressedWithVolunteerDetails(_ volunteerDetails: AnyObject)
    {
        delegate().delegateGiveAnswerPressedWithVolunteerDetails!(volunteerDetails)
       
        popover().dismiss(animated: true)
        
    }
    
}
