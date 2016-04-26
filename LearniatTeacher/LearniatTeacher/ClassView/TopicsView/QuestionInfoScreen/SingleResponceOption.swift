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
    
    var mAnswerOptions           = NSMutableArray()
    
    let optionScrollView = UIScrollView()
    
    var headerlabel = UILabel()
    
//    func setdelegate(delegate:AnyObject)
//    {
//        _delgate = delegate;
//    }
//    
//    func   delegate()->AnyObject
//    {
//        return _delgate;
//    }
    
    
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
        
        
         headerlabel.frame = CGRectMake(20, 0, 200, 50)
        
        if let questionType = cureentQuestionDetails.objectForKey("Type") as? String
        {
            headerlabel.text = questionType
        }
        else
        {
            headerlabel.text = "Multiple Response"
        }
        
        
        headerView.addSubview(headerlabel)
        headerlabel.textAlignment = .Left;
        headerlabel.font = UIFont(name: helveticaRegular, size: 20)
        headerlabel.textColor  = blackTextColor
        
        
        
        let  mDoneButton = UIButton(frame: CGRectMake(headerView.frame.size.width - 210, 0, 200, 50))
        mDoneButton.addTarget(self, action: #selector(SingleResponceOption.onDoneButton), forControlEvents: UIControlEvents.TouchUpInside)
        mDoneButton.setTitleColor(standard_Button, forState: .Normal)
        mDoneButton.setTitle("Done", forState: .Normal)
        mDoneButton.contentHorizontalAlignment = UIControlContentHorizontalAlignment.Right
        mDoneButton.titleLabel?.font = UIFont(name: helveticaMedium, size: 20)
        headerView.addSubview(mDoneButton)
        
        
        self.view.addSubview(optionScrollView)
        optionScrollView.frame = CGRectMake(0, headerView.frame.size.height, headerView.frame.size.width, 10 )
        
        
        addOPtionsCells()
    }
    
   
    
    func setQuestionDetails(details:AnyObject)
    {
        mAnswerOptions.removeAllObjects()
        cureentQuestionDetails = details
    }
    
    func setQuestionDetails(details:AnyObject, withAnswerOptions answerOptions:NSMutableArray)
    {
        cureentQuestionDetails = details
        mAnswerOptions = answerOptions
    }

    
    
    func addOPtionsCells()
    {
        
        
        var optionArray = NSMutableArray()
        
         var height :CGFloat = 44
        var postionYValue:CGFloat = 0
        if let options = cureentQuestionDetails.objectForKey("Options")
        {
           if let classCheckingVariable = options.objectForKey("Option")
            {
                    if classCheckingVariable.isKindOfClass(NSMutableArray)
                    {
                        optionArray = classCheckingVariable as! NSMutableArray
                    }
                    else
                    {
                        optionArray.addObject(cureentQuestionDetails.objectForKey("Options")!.objectForKey("Option")!)
                        
                    }
                    
                
                   
                    
                    
                    for indexValu in 0..<optionArray.count
                    {
                        let optionDict = optionArray.objectAtIndex(indexValu)
                        
                        let optionsCell = SingleResponceOptionCell(frame: CGRectMake(0  , postionYValue, optionScrollView.frame.size.width, 50))
                        
                        optionsCell.frame = CGRectMake(0  , postionYValue, optionScrollView.frame.size.width, optionsCell.getHeightWithDetails(optionDict))
                        
                        optionsCell.changeFrameWithSize()
                        
                        optionsCell.checkValueOfOPtion(optionDict, withanswerOptionsArray: mAnswerOptions)
                        
                        
                        optionScrollView.addSubview(optionsCell)
                        
                        postionYValue = postionYValue + optionsCell.frame.size.height
                        height = height + optionsCell.frame.size.height
                        
                    }
  
            }
           else
           {
            headerlabel.text = "No options"
            }
        }
        else
        {
            headerlabel.text = "No options"
        }
        
        
        
        if height > UIScreen.mainScreen().bounds.height - 100
        {
            height = UIScreen.mainScreen().bounds.height - 100
        }
        
        
        self.preferredContentSize = CGSize(width: 400, height: height  )
        
        optionScrollView.frame = CGRectMake(0, 50, optionScrollView.frame.size.width, height - 50)
        
        optionScrollView.contentSize = CGSizeMake(0, postionYValue)

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
    func onDoneButton()
    {
        popover().dismissPopoverAnimated(true)
        
    }
    
    
    
    
    
}