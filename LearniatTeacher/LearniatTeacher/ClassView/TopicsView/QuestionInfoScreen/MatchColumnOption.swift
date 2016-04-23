//
//  MatchColumnOption.swift
//  LearniatTeacher
//
//  Created by Deepak MK on 30/03/16.
//  Copyright © 2016 Mindshift. All rights reserved.
//

import Foundation

class MatchColumnOption : UIViewController
{
    
    var _delgate: AnyObject!
    
        var _Popover:AnyObject!
    
    var cureentQuestionDetails :AnyObject!
    
    let optionScrollView = UIScrollView()
    
    let headerlabel = UILabel()
    
    
    var studentAnswerArray = NSMutableArray()
    
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
        
        
        
        let headerView = UIView(frame: CGRectMake(0, 0, 500, 50))
        headerView.backgroundColor = lightGrayTopBar
        self.view.addSubview(headerView);
        
        
        let seperatorView = UIView(frame: CGRectMake(0, headerView.frame.size.height-1, 500, 1))
        seperatorView.backgroundColor = LineGrayColor
        headerView.addSubview(seperatorView);
        
        
        headerlabel.frame = CGRectMake(20, 0, 200, 50)
        headerlabel.text = "Match column"
        headerView.addSubview(headerlabel)
        headerlabel.textAlignment = .Left;
        headerlabel.font = UIFont(name: helveticaRegular, size: 20)
        headerlabel.textColor  = blackTextColor
        
        
        
        let  mDoneButton = UIButton(frame: CGRectMake(headerView.frame.size.width - 220, 0, 200, 50))
        mDoneButton.addTarget(self, action: #selector(MatchColumnOption.onDoneButton as (MatchColumnOption) -> () -> ()), forControlEvents: UIControlEvents.TouchUpInside)
        mDoneButton.setTitleColor(standard_Button, forState: .Normal)
        mDoneButton.setTitle("Done", forState: .Normal)
        mDoneButton.contentHorizontalAlignment = UIControlContentHorizontalAlignment.Right
        mDoneButton.titleLabel?.font = UIFont(name: helveticaMedium, size: 20)
        headerView.addSubview(mDoneButton)
        
        
        self.view.addSubview(optionScrollView)
        optionScrollView.frame = CGRectMake(0, headerView.frame.size.height, headerView.frame.size.width, 10 )
        
        
        addOPtionsCells()
    }
    
    
    
    
    func onDoneButton(sender:AnyObject)
    {
        
    }
    
    func setQuestionDetails(details:AnyObject)
    {
        cureentQuestionDetails = details
        studentAnswerArray.removeAllObjects()
        
    }
    
    
    func setQuestionDetails(details:AnyObject, withStudentsAnswer RightSideArray:NSMutableArray)
    {
        
        cureentQuestionDetails = details
        
        studentAnswerArray = RightSideArray
        
        
    }
    
    func addOPtionsCells()
    {
        
        
        var optionArray = NSMutableArray()
        
        let leftSideArray = NSMutableArray()
        
        let RightSideArray = NSMutableArray()
        
        
        
        
        
        let classCheckingVariable = cureentQuestionDetails.objectForKey("Options")!.objectForKey("Option")!
        
        if classCheckingVariable.isKindOfClass(NSMutableArray)
        {
            optionArray = classCheckingVariable as! NSMutableArray
        }
        else
        {
            optionArray.addObject(cureentQuestionDetails.objectForKey("Options")!.objectForKey("Option")!)
            
        }
        
        
        
        for index in 0 ..< optionArray.count 
        {
            
           let optionDict = optionArray.objectAtIndex(index)
            
            if let Column = optionDict.objectForKey("Column") as? String
            {
                if Column == "1"
                {
                    leftSideArray.addObject(optionDict)
                }
                else if Column == "2"
                {
                    RightSideArray.addObject(optionDict)
                 
                }
                
            }
        }
        
        
       

        var postionYValue:CGFloat = 0
        var height :CGFloat = 44
        
        
        if leftSideArray.count == RightSideArray.count
        {
            for index in 0 ..< leftSideArray.count 
            {
                
                let leftSideOptionDict = leftSideArray.objectAtIndex(index)
                let rightSideOptionDict = RightSideArray.objectAtIndex(index)
                
                
                
                let optionsCell = MatchColumnCell(frame: CGRectMake(0  , postionYValue, optionScrollView.frame.size.width, 50))
                
                optionsCell.frame = CGRectMake(0  , postionYValue, optionScrollView.frame.size.width, optionsCell.getHeightWithDetails(leftSideOptionDict, withRightOptionDetails: rightSideOptionDict))
                
                optionsCell.changeFrameWithSize()
                
                optionScrollView.addSubview(optionsCell)
                
                if studentAnswerArray.count > 0
                {
                    let StudentsAnswerDict = studentAnswerArray.objectAtIndex(index)
                    
                    if let OldSequence = StudentsAnswerDict.objectForKey("OldSequence") as? String
                    {
                        if let Sequence = StudentsAnswerDict.objectForKey("Sequence") as? String
                        {
                            
                            
                            if OldSequence == Sequence
                            {
                                optionsCell._optionValueImageView.image = UIImage(named: "Check.png")
                            }
                            else
                            {
                                optionsCell._optionValueImageView.image = UIImage(named: "X.png")
                            }
                        }
                    }
                }
                
                postionYValue = postionYValue + optionsCell.frame.size.height
                height = height + optionsCell.frame.size.height

                
                
            }
        }
        else if leftSideArray.count < RightSideArray.count
        {
            for var index = 0; index < leftSideArray.count ; index += 1
            {
                
                let leftSideOptionDict = leftSideArray.objectAtIndex(index)
                let rightSideOptionDict = RightSideArray.objectAtIndex(index)
                
                
                
                let optionsCell = MatchColumnCell(frame: CGRectMake(0  , postionYValue, optionScrollView.frame.size.width, 50))
                
                optionsCell.frame = CGRectMake(0  , postionYValue, optionScrollView.frame.size.width, optionsCell.getHeightWithDetails(leftSideOptionDict, withRightOptionDetails: rightSideOptionDict))
                
                optionsCell.changeFrameWithSize()
                
                optionScrollView.addSubview(optionsCell)
                
                if studentAnswerArray.count > 0
                {
                    let StudentsAnswerDict = studentAnswerArray.objectAtIndex(index)
                    
                    if let OldSequence = StudentsAnswerDict.objectForKey("OldSequence") as? String
                    {
                        if let Sequence = StudentsAnswerDict.objectForKey("Sequence") as? String
                        {
                            
                            
                            if OldSequence == Sequence
                            {
                                optionsCell._optionValueImageView.image = UIImage(named: "Check.png")
                            }
                            else
                            {
                                optionsCell._optionValueImageView.image = UIImage(named: "X.png")
                            }
                        }
                    }
                }
                
                postionYValue = postionYValue + optionsCell.frame.size.height
                height = height + optionsCell.frame.size.height
                
                
                
            }
        }
        else
        {
            for var index = 0; index < RightSideArray.count ; index += 1
            {
                
                let leftSideOptionDict = leftSideArray.objectAtIndex(index)
                let rightSideOptionDict = RightSideArray.objectAtIndex(index)
                
                
                
                let optionsCell = MatchColumnCell(frame: CGRectMake(0  , postionYValue, optionScrollView.frame.size.width, 50))
                
                optionsCell.frame = CGRectMake(0  , postionYValue, optionScrollView.frame.size.width, optionsCell.getHeightWithDetails(leftSideOptionDict, withRightOptionDetails: rightSideOptionDict))
                
                optionsCell.changeFrameWithSize()
                
                optionScrollView.addSubview(optionsCell)
                
                
                if studentAnswerArray.count > 0
                {
                    let StudentsAnswerDict = studentAnswerArray.objectAtIndex(index)
                   
                    if let OldSequence = StudentsAnswerDict.objectForKey("OldSequence") as? String
                    {
                        if let Sequence = StudentsAnswerDict.objectForKey("Sequence") as? String
                        {
                            
                            
                            if OldSequence == Sequence
                            {
                                optionsCell._optionValueImageView.image = UIImage(named: "Check.png")
                            }
                            else
                            {
                                optionsCell._optionValueImageView.image = UIImage(named: "X.png")
                            }
                        }
                    }
                }
                
                
                postionYValue = postionYValue + optionsCell.frame.size.height
                height = height + optionsCell.frame.size.height
                
                
                
            }
        }
        
        
        if leftSideArray.count <= 0 || RightSideArray.count <= 0
        {
            headerlabel.text = "No option"
        }
        
        
        if height > UIScreen.mainScreen().bounds.height - 100
        {
            height = UIScreen.mainScreen().bounds.height - 100
        }
        
        
        
        self.preferredContentSize = CGSize(width: 500, height: height  )
        
        optionScrollView.frame = CGRectMake(0, 50, optionScrollView.frame.size.width, height - 50)
        
        optionScrollView.contentSize = CGSizeMake(0, postionYValue)
        
    }
    
    

    func setPopover(popover:AnyObject)
    {
        _Popover = popover
    }
    
    func popover()-> AnyObject
    {
        return _Popover
    }
    func onDoneButton()
    {
        popover().dismissPopoverAnimated(true)
        
    }
    
    
    
    
}