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
    
    
    var cureentQuestionDetails :AnyObject!
    
    let optionScrollView = UIScrollView()
    
    let headerlabel = UILabel()
    
    
    var studentAnswerArray = NSMutableArray()
    
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
        
        
        self.view.setNeedsLayout()
        self.view.layoutIfNeeded()
        
        
        
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: 500, height: 50))
        headerView.backgroundColor = lightGrayTopBar
        self.view.addSubview(headerView);
        
        
        let seperatorView = UIView(frame: CGRect(x: 0, y: headerView.frame.size.height-1, width: 500, height: 1))
        seperatorView.backgroundColor = LineGrayColor
        headerView.addSubview(seperatorView);
        
        
        headerlabel.frame = CGRect(x: 20, y: 0, width: 200, height: 50)
        headerlabel.text = "Match column"
        headerView.addSubview(headerlabel)
        headerlabel.textAlignment = .left;
        headerlabel.font = UIFont(name: helveticaRegular, size: 20)
        headerlabel.textColor  = blackTextColor
        
        
        
        let  mDoneButton = UIButton(frame: CGRect(x: headerView.frame.size.width - 220, y: 0, width: 200, height: 50))
        mDoneButton.addTarget(self, action: #selector(MatchColumnOption.onDoneButton as (MatchColumnOption) -> () -> ()), for: UIControlEvents.touchUpInside)
        mDoneButton.setTitleColor(standard_Button, for: UIControlState())
        mDoneButton.setTitle("Done", for: UIControlState())
        mDoneButton.contentHorizontalAlignment = UIControlContentHorizontalAlignment.right
        mDoneButton.titleLabel?.font = UIFont(name: helveticaMedium, size: 20)
        headerView.addSubview(mDoneButton)
        
        
        self.view.addSubview(optionScrollView)
        optionScrollView.frame = CGRect(x: 0, y: headerView.frame.size.height, width: headerView.frame.size.width, height: 10 )
        
        
        addOPtionsCells()
    }
    
    
    
    
    func onDoneButton(_ sender:AnyObject)
    {
        
    }
    
    func setQuestionDetails(_ details:AnyObject)
    {
        cureentQuestionDetails = details
        studentAnswerArray.removeAllObjects()
        
    }
    
    
    func setQuestionDetails(_ details:AnyObject, withStudentsAnswer RightSideArray:NSMutableArray)
    {
        
        cureentQuestionDetails = details
        
        studentAnswerArray = RightSideArray
        
        
    }
    
    func addOPtionsCells()
    {
        
        
        var optionArray = NSMutableArray()
        
        let leftSideArray = NSMutableArray()
        
        let RightSideArray = NSMutableArray()
        
        
        
        
        
      if  let classCheckingVariable = (cureentQuestionDetails.object(forKey: "Options")! as AnyObject).object(forKey: "Option") as? NSMutableArray
      {
        optionArray = classCheckingVariable
        }
        else
      {
        optionArray.add((cureentQuestionDetails.object(forKey: "Options")! as AnyObject).object(forKey: "Option")!)
        }
        
       
        
        
        for index in 0 ..< optionArray.count 
        {
            
           let optionDict = optionArray.object(at: index)
            
            if let Column = (optionDict as AnyObject).object(forKey: "Column") as? String
            {
                if Column == "1"
                {
                    leftSideArray.add(optionDict)
                }
                else if Column == "2"
                {
                    RightSideArray.add(optionDict)
                 
                }
                
            }
        }
        
        
       

        var postionYValue:CGFloat = 0
        var height :CGFloat = 44
        
        
        if leftSideArray.count == RightSideArray.count
        {
            for index in 0 ..< leftSideArray.count 
            {
                
                let leftSideOptionDict = leftSideArray.object(at: index)
                let rightSideOptionDict = RightSideArray.object(at: index)
                
                
                
                let optionsCell = MatchColumnCell(frame: CGRect(x: 0  , y: postionYValue, width: optionScrollView.frame.size.width, height: 50))
                
                optionsCell.frame = CGRect(x: 0  , y: postionYValue, width: optionScrollView.frame.size.width, height: optionsCell.getHeightWithDetails(leftSideOptionDict as AnyObject, withRightOptionDetails: rightSideOptionDict as AnyObject))
                
                optionsCell.changeFrameWithSize()
                
                optionScrollView.addSubview(optionsCell)
                
                if studentAnswerArray.count > 0
                {
                    let StudentsAnswerDict = studentAnswerArray.object(at: index)
                    
                    if let OldSequence = (StudentsAnswerDict as AnyObject).object(forKey: "OldSequence") as? String
                    {
                        if let Sequence = (StudentsAnswerDict as AnyObject).object(forKey: "Sequence") as? String
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
            for index in 0..<leftSideArray.count
            {
                
                let leftSideOptionDict = leftSideArray.object(at: index)
                let rightSideOptionDict = RightSideArray.object(at: index)
                
                
                
                let optionsCell = MatchColumnCell(frame: CGRect(x: 0  , y: postionYValue, width: optionScrollView.frame.size.width, height: 50))
                
                optionsCell.frame = CGRect(x: 0  , y: postionYValue, width: optionScrollView.frame.size.width, height: optionsCell.getHeightWithDetails(leftSideOptionDict as AnyObject, withRightOptionDetails: rightSideOptionDict as AnyObject))
                
                optionsCell.changeFrameWithSize()
                
                optionScrollView.addSubview(optionsCell)
                
                if studentAnswerArray.count > 0
                {
                    let StudentsAnswerDict = studentAnswerArray.object(at: index)
                    
                    if let OldSequence = (StudentsAnswerDict as AnyObject).object(forKey: "OldSequence") as? String
                    {
                        if let Sequence = (StudentsAnswerDict as AnyObject).object(forKey: "Sequence") as? String
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
            for index in 0..<RightSideArray.count 
            {
                
                let leftSideOptionDict = leftSideArray.object(at: index)
                let rightSideOptionDict = RightSideArray.object(at: index)
                
                
                
                let optionsCell = MatchColumnCell(frame: CGRect(x: 0  , y: postionYValue, width: optionScrollView.frame.size.width, height: 50))
                
                optionsCell.frame = CGRect(x: 0  , y: postionYValue, width: optionScrollView.frame.size.width, height: optionsCell.getHeightWithDetails(leftSideOptionDict as AnyObject, withRightOptionDetails: rightSideOptionDict as AnyObject))
                
                optionsCell.changeFrameWithSize()
                
                optionScrollView.addSubview(optionsCell)
                
                
                if studentAnswerArray.count > 0
                {
                    let StudentsAnswerDict = studentAnswerArray.object(at: index)
                   
                    if let OldSequence = (StudentsAnswerDict as AnyObject).object(forKey: "OldSequence") as? String
                    {
                        if let Sequence = (StudentsAnswerDict as AnyObject).object(forKey: "Sequence") as? String
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
        
        
        if height > UIScreen.main.bounds.height - 100
        {
            height = UIScreen.main.bounds.height - 100
        }
        
        
        
        self.preferredContentSize = CGSize(width: 500, height: height  )
        
        optionScrollView.frame = CGRect(x: 0, y: 50, width: optionScrollView.frame.size.width, height: height - 50)
        
        optionScrollView.contentSize = CGSize(width: 0, height: postionYValue)
        
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
    func onDoneButton()
    {
        
        popover().dismiss(animated: true)
        
    }
    
    
    
    
}
