//
//  SingleResponceOption.swift
//  LearniatTeacher
//
//  Created by Deepak MK on 28/03/16.
//  Copyright © 2016 Mindshift. All rights reserved.
//

import Foundation

class SingleResponceOption : UIViewController
{
    
    var _delgate: AnyObject!
    
    var cureentQuestionDetails :AnyObject!
    
    let optionScrollView = UIScrollView()
    
    
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
        
        
        self.view.setNeedsLayout()
        self.view.layoutIfNeeded()
        
        
        
        let headerView = UIView(frame: CGRectMake(0, 0, 400, 50))
        headerView.backgroundColor = lightGrayTopBar
        self.view.addSubview(headerView);
        
        
        let seperatorView = UIView(frame: CGRectMake(0, headerView.frame.size.height-1, 400, 1))
        seperatorView.backgroundColor = LineGrayColor
        headerView.addSubview(seperatorView);
        
        
        let headerlabel = UILabel(frame: CGRectMake(10, 0, 200, 50))
        
        if let questionType = cureentQuestionDetails.objectForKey("Type") as? String
        {
            headerlabel.text = questionType
        }
        else
        {
            headerlabel.text = "Overlay Scribble"
        }
        
        
        headerView.addSubview(headerlabel)
        headerlabel.textAlignment = .Left;
        headerlabel.font = UIFont(name: helveticaRegular, size: 20)
        headerlabel.textColor  = blackTextColor
        
        
        
        let  mDoneButton = UIButton(frame: CGRectMake(headerView.frame.size.width - 210, 0, 200, 50))
        mDoneButton.addTarget(self, action: "onDoneButton", forControlEvents: UIControlEvents.TouchUpInside)
        mDoneButton.setTitleColor(standard_Button, forState: .Normal)
        mDoneButton.setTitle("Done", forState: .Normal)
        mDoneButton.contentHorizontalAlignment = UIControlContentHorizontalAlignment.Right
        mDoneButton.titleLabel?.font = UIFont(name: helveticaMedium, size: 20)
        headerView.addSubview(mDoneButton)
        
        
        self.view.addSubview(optionScrollView)
        optionScrollView.frame = CGRectMake(0, headerView.frame.size.height, headerView.frame.size.width, 10 )
        
        
        
    }
    
    
    
    
    func onDoneButton(sender:AnyObject)
    {
        
    }
    
    func setQuestionDetails(details:AnyObject)
    {
        cureentQuestionDetails = details
    }
    
    
    func addOPtionsCells()
    {
        
        
        var optionArray = NSMutableArray()
        
        let classCheckingVariable = cureentQuestionDetails.objectForKey("Options")!.objectForKey("Option")!
        
        if classCheckingVariable.isKindOfClass(NSMutableArray)
        {
            optionArray = classCheckingVariable as! NSMutableArray
        }
        else
        {
            optionArray.addObject(cureentQuestionDetails.objectForKey("Options")!.objectForKey("Option")!)
            
        }
        
        
        
        
        
        var postionYValue:CGFloat = 0
        
        for var indexValu = 0 ;indexValu < optionArray.count; indexValu++
        {
            let optionDict = optionArray.objectAtIndex(indexValu)
            
            let optionsCell = SingleResponceOptionCell(frame: CGRectMake(0  , postionYValue, optionScrollView.frame.size.width, 50))
            optionsCell.getHeightWithDetails(optionDict)
            optionScrollView.addSubview(optionsCell)
            postionYValue = postionYValue + optionsCell.frame.size.height
            
            
        }
        
    }
    
    
    
    
    
}