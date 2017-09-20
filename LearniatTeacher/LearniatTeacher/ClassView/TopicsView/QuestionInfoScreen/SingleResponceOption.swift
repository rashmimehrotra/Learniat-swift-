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
        
        
        
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: 400, height: 50))
        headerView.backgroundColor = lightGrayTopBar
        self.view.addSubview(headerView);
        
        
        let seperatorView = UIView(frame: CGRect(x: 0, y: headerView.frame.size.height-1, width: 400, height: 1))
        seperatorView.backgroundColor = LineGrayColor
        headerView.addSubview(seperatorView);
        
        
         headerlabel.frame = CGRect(x: 20, y: 0, width: 200, height: 50)
        
        if let questionType = cureentQuestionDetails.object(forKey: kQuestionType) as? String
        {
            headerlabel.text = questionType
        }
        else
        {
            headerlabel.text = kMRQ
        }
        
        
        headerView.addSubview(headerlabel)
        headerlabel.textAlignment = .left;
        headerlabel.font = UIFont(name: helveticaRegular, size: 20)
        headerlabel.textColor  = blackTextColor
        
        
        
        let  mDoneButton = UIButton(frame: CGRect(x: headerView.frame.size.width - 210, y: 0, width: 200, height: 50))
        mDoneButton.addTarget(self, action: #selector(SingleResponceOption.onDoneButton), for: UIControlEvents.touchUpInside)
        mDoneButton.setTitleColor(standard_Button, for: UIControlState())
        mDoneButton.setTitle("Done", for: UIControlState())
        mDoneButton.contentHorizontalAlignment = UIControlContentHorizontalAlignment.right
        mDoneButton.titleLabel?.font = UIFont(name: helveticaMedium, size: 20)
        headerView.addSubview(mDoneButton)
        
        
        self.view.addSubview(optionScrollView)
        optionScrollView.frame = CGRect(x: 0, y: headerView.frame.size.height, width: headerView.frame.size.width, height: 10 )
        
        
        addOPtionsCells()
    }
    
   
    
    func setQuestionDetails(_ details:AnyObject)
    {
        mAnswerOptions.removeAllObjects()
        cureentQuestionDetails = details
    }
    
    func setQuestionDetails(_ details:AnyObject, withAnswerOptions answerOptions:NSMutableArray)
    {
        cureentQuestionDetails = details
        mAnswerOptions = answerOptions
    }

    
    
    func addOPtionsCells()
    {
        
        
        var optionArray = NSMutableArray()
        
         var height :CGFloat = 44
        var postionYValue:CGFloat = 0
        if let options = cureentQuestionDetails.object(forKey: kOptionTagMain)
        {
           if let classCheckingVariable = (options as AnyObject).object(forKey: "Option") as? NSMutableArray
            {
                    
                optionArray = classCheckingVariable
                
            }
           else if (((cureentQuestionDetails.object(forKey: kOptionTagMain)! as AnyObject).object(forKey: "Option")) as? NSMutableDictionary) != nil
           {
                optionArray.add((cureentQuestionDetails.object(forKey: kOptionTagMain)! as AnyObject).object(forKey: "Option")!)
            
            }
            
            if (optionArray.count > 0)
            {
            
            
                    for indexValu in 0..<optionArray.count
                    {
                        let optionDict = optionArray.object(at: indexValu)
                        
                        let optionsCell = SingleResponceOptionCell(frame: CGRect(x: 0  , y: postionYValue, width: optionScrollView.frame.size.width, height: 50))
                        
                        optionsCell.frame = CGRect(x: 0  , y: postionYValue, width: optionScrollView.frame.size.width, height: optionsCell.getHeightWithDetails(optionDict as AnyObject))
                        
                        optionsCell.changeFrameWithSize()
                        
                        optionsCell.checkValueOfOPtion(optionDict as AnyObject, withanswerOptionsArray: mAnswerOptions)
                        
                        
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
        
        
        
        if height > UIScreen.main.bounds.height - 100
        {
            height = UIScreen.main.bounds.height - 100
        }
        
        
        self.preferredContentSize = CGSize(width: 400, height: height  )
        
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
