//
//  StudentAnswerGraphView.swift
//  LearniatTeacher
//
//  Created by Deepak MK on 02/04/16.
//  Copyright © 2016 Mindshift. All rights reserved.
//

import Foundation

let kbartag = 200
let kLabeltag = 400
var kOptionIdIncrementer  = 1000


@objc protocol StudentAnswerGraphViewDelegate
{
    
    optional func delegateBarTouchedWithId(optionId: String, withView barButton:BarView)
    
    optional func delegateShareButtonClickedWithDetails()
    
}

class StudentAnswerGraphView: UIView
{
    
    var questionNamelabel = UILabel()
    
    var barCellHeight = CGFloat()
    
    var lineContainerView = UIView()
    
    var basePostionValue :CGFloat = 20
    
    let shareGraphButton  = UIButton()
    
    var differenceheight      :CGFloat = 10
    
    var optionIdDictoryWIthText     = NSMutableDictionary()
    
    var _delgate: AnyObject!
    
    func setdelegate(delegate:AnyObject)
    {
        _delgate = delegate;
    }
    
    func   delegate()->AnyObject
    {
        return _delgate;
    }
    
    override init(frame: CGRect)
    {
        
        super.init(frame:frame)
        
        self.backgroundColor = whiteBackgroundColor
        
        questionNamelabel.frame =  CGRectMake(10,10,self.frame.size.width - 50 ,40)
        self.addSubview(questionNamelabel)
        questionNamelabel.font = UIFont (name: helveticaRegular, size: 18)
        questionNamelabel.textColor = blackTextColor
        questionNamelabel.textAlignment = .Center
        
        
        shareGraphButton.frame = CGRectMake(self.frame.size.width - 50, 10, 40,30)
        shareGraphButton.setImage(UIImage(named:"wrongMatch.png"), forState:.Normal)
        self.addSubview(shareGraphButton);
        shareGraphButton.imageView?.contentMode = .ScaleAspectFit
        shareGraphButton.addTarget(self, action: #selector(StudentAnswerGraphView.onShareGraph), forControlEvents: UIControlEvents.TouchUpInside)

        
        
        
        lineContainerView.frame  = CGRectMake(0, questionNamelabel.frame.size.height + questionNamelabel.frame.origin.y + 20 , self.frame.size.width, self.frame.size.height - (questionNamelabel.frame.size.height + questionNamelabel.frame.origin.y + 100))
        self.addSubview(lineContainerView)

        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func loadMRQViewWithOPtions(optionsArray:NSMutableArray, withQuestion questionName:String)
    {
        
        
        questionNamelabel.text = questionName
        
        
        var subViews = lineContainerView.subviews
        
        for subview in subViews
        {
             subview.removeFromSuperview()
        }
        
        
         subViews = self.subviews
        
        for subview in subViews
        {
            if subview.isKindOfClass(FXLabel) || subview.isKindOfClass(BarView)
            {
                 subview.removeFromSuperview()
            }
           
        }
        
       
        
        differenceheight = (lineContainerView.frame.size.height) / CGFloat(10)
        
        var labelCount = 0;
        var height:CGFloat = differenceheight * 10;
        for i in 0..<11
        {
            if (i % 2 == 0)
            {
                
                let lineView = UIImageView(frame:CGRectMake(100, height, self.frame.size.width - 100, 1))
                lineView.backgroundColor = UIColor(red: 117/255.0, green: 117/255.0, blue: 117/255.0, alpha: 0.3)
                lineContainerView.addSubview(lineView);
                
                
                let lable = UILabel(frame:CGRectMake(60, height-25, 100, 50))
                lable.text = "\(i)"
                lineContainerView.addSubview(lable);
                lable.textColor = blackTextColor
                lable.tag  = kLabeltag + i
                labelCount = labelCount + 1;
            }
            else
            {

                let lineView = DottedLine(frame:CGRectMake(100, height, self.frame.size.width - 100, 1))
                 lineView.drawDashedBorderAroundViewWithColor(UIColor(red: 117/255.0, green: 117/255.0, blue: 117/255.0, alpha: 0.3))
                lineContainerView.addSubview(lineView);

            }
            height = height - differenceheight
        }
        
        
        let columns: Int        = optionsArray.count
        
        
        var width = (lineContainerView.frame.size.width - 100) / CGFloat(columns)
        
        let widthSpace = width * 0.1
        
        width = width * 0.9
        
        var positionX = widthSpace / 2 + 100
        
        for index in 0 ..< optionsArray.count
        {
            
            let optionDict = optionsArray.objectAtIndex(index)
            
            
                let optionsLabel = FXLabel(frame: CGRectMake(positionX , lineContainerView.frame.origin.y + lineContainerView.frame.size.height + 5, width ,self.frame.size.height - (lineContainerView.frame.origin.y + lineContainerView.frame.size.height + 10)));
                self.addSubview(optionsLabel)
                optionsLabel.lineBreakMode = .ByTruncatingMiddle;
                optionsLabel.numberOfLines = 5;
                optionsLabel.textAlignment = .Center;
                optionsLabel.contentMode = .Top;
                optionsLabel.textColor = blackTextColor
            
            var font = UIFont(name:helveticaRegular, size:16)
            if (optionsArray.count > 4)
            {
                font = UIFont(name:helveticaRegular, size:14)
            }
            else
            {
                font = UIFont(name:helveticaRegular, size:18)
            }
            optionsLabel.font = font
            
            if let optiontext = optionDict.objectForKey("OptionText") as? String
            {
                optionsLabel.text = optiontext
            }
            optionsLabel.backgroundColor = UIColor.clearColor()
            

            let barView = BarView(frame: CGRectMake(positionX ,lineContainerView.frame.size.height, width ,0))
            lineContainerView.addSubview(barView)
            barView.addTarget(self, action: #selector(StudentAnswerGraphView.onBarButtonPressed(_:)), forControlEvents: UIControlEvents.TouchUpInside)
            if let optionId = optionDict.objectForKey("OptionId") as? String
            {
                barView.tag = Int(optionId)!
            }
            
            
            if let IsAnswer = optionDict.objectForKey("IsAnswer") as? String
            {
               if IsAnswer == "1"
               {
                    barView.setBarColor( standard_Green)
                }
                else
               {
                 barView.setBarColor(UIColor.lightGrayColor())
                }
            }
            else
            {
                barView.setBarColor(UIColor.lightGrayColor())
            }
            positionX = positionX + width + widthSpace

        }
        
    }
    
    
    
    
    func loadMTCViewWithOPtions(optionsArray:NSMutableArray,WithRightSideOptionArray rightOPtionsArray:NSMutableArray, withQuestion questionName:String)
    {
        
        
        questionNamelabel.text = questionName
        kOptionIdIncrementer = 1000
        
        var subViews = lineContainerView.subviews
        
        for subview in subViews
        {
            subview.removeFromSuperview()
        }
        
        
        subViews = self.subviews
        
        for subview in subViews
        {
            if subview.isKindOfClass(FXLabel) || subview.isKindOfClass(BarView)
            {
                subview.removeFromSuperview()
            }
            
        }
        
        
        
        differenceheight = (lineContainerView.frame.size.height) / CGFloat(10)
        
        var labelCount = 0;
        
        var height:CGFloat = differenceheight * 10;
        for i in 0..<11
        {
            if (i % 2 == 0)
            {
                
                let lineView = UIImageView(frame:CGRectMake(100, height, self.frame.size.width - 100, 1))
                lineView.backgroundColor = UIColor(red: 117/255.0, green: 117/255.0, blue: 117/255.0, alpha: 0.3)
                lineContainerView.addSubview(lineView);
                
                
                let lable = UILabel(frame:CGRectMake(60, height-25, 100, 50))
                lable.text = "\(i)"
                lineContainerView.addSubview(lable);
                lable.textColor = blackTextColor
                lable.tag  = kLabeltag + i
                labelCount = labelCount + 1;
            }
            else
            {
                
                let lineView = DottedLine(frame:CGRectMake(100, height, self.frame.size.width - 100, 1))
                lineView.drawDashedBorderAroundViewWithColor(UIColor(red: 117/255.0, green: 117/255.0, blue: 117/255.0, alpha: 0.3))
                lineContainerView.addSubview(lineView);
                
            }
            height = height - differenceheight
        }
        
        
        let columns: Int        = optionsArray.count
        
        
        var width = (lineContainerView.frame.size.width - 100) / CGFloat(columns)
        
        let widthSpace = width * 0.1
        
        width = width * 0.9
        
        var positionX = widthSpace / 2 + 100
        
        for index in 0 ..< optionsArray.count
        {
            
            let optionDict = optionsArray.objectAtIndex(index)
            let rightOPtionDict = rightOPtionsArray.objectAtIndex(index)
            
            let optionsLabel = FXLabel(frame: CGRectMake(positionX , lineContainerView.frame.origin.y + lineContainerView.frame.size.height + 5, width ,self.frame.size.height - (lineContainerView.frame.origin.y + lineContainerView.frame.size.height + 10)));
            self.addSubview(optionsLabel)
            optionsLabel.lineBreakMode = .ByTruncatingMiddle;
            optionsLabel.numberOfLines = 5;
            optionsLabel.textAlignment = .Center;
            optionsLabel.contentMode = .Top;
            optionsLabel.textColor = blackTextColor
            
            var font = UIFont(name:helveticaRegular, size:16)
            if (optionsArray.count > 4)
            {
                font = UIFont(name:helveticaRegular, size:14)
            }
            else
            {
                font = UIFont(name:helveticaRegular, size:18)
            }
            optionsLabel.font = font
            
            if let optiontext = optionDict.objectForKey("OptionText") as? String
            {
              
                if let rOptiontext = rightOPtionDict.objectForKey("OptionText") as? String
                {
                    optionsLabel.text = "\(optiontext)->\(rOptiontext)"
                }
                else
                {
                    optionsLabel.text = optiontext
                }
                
                
                
            }
            optionsLabel.backgroundColor = UIColor.clearColor()
            
            
            let barView = BarView(frame: CGRectMake(positionX ,lineContainerView.frame.size.height, width ,0))
            lineContainerView.addSubview(barView)
            barView.addTarget(self, action: #selector(StudentAnswerGraphView.onBarButtonPressed(_:)), forControlEvents: UIControlEvents.TouchUpInside)
            if let optionId = optionDict.objectForKey("OptionId") as? String
            {
                barView.tag = Int(optionId)!
                
                if let rOptiontext = rightOPtionDict.objectForKey("OptionText") as? String
                {
                    optionIdDictoryWIthText.setObject(optionId, forKey: rOptiontext)
                }
                
            }
            else
            {
                barView.tag = kOptionIdIncrementer + index
            }

            barView.setBarColor(standard_Button)
            positionX = positionX + width + widthSpace
            
        }
        
    }
    
    
    func increaseMultiplevalu(value:Int , withOptionId optionId:String)
    {
        for _ in 0 ..< value
        {
            increaseBarValueWithOPtionID(optionId)
        }
    }
    
    
    func increaseMTCMultiplevalu(value:Int , withOptionText OptionText:String)
    {
        for _ in 0 ..< value
        {
            increaseBarValueWithOptionText(OptionText)
        }
    }
    
    
    
    func increaseBarValueWithOPtionID(optionId:String)
    {
        
      
        
        
        if let answerBar  = self.viewWithTag(Int(optionId)!) as? BarView
        {
            answerBar.increasePresentValue()
            
            var presentValue:CGFloat = CGFloat(answerBar.presentValue)
            
            
            
            presentValue = presentValue * differenceheight
            
            
             answerBar.frame = CGRectMake(answerBar.frame.origin.x ,self.lineContainerView.frame.size.height - presentValue  , answerBar.frame.size.width ,presentValue)
            
           
            answerBar.changeFrameWithHeight(presentValue)
            
            
            if (answerBar.frame.size.height >= lineContainerView.frame.size.height)
            {
                differenceheight=differenceheight/2;
                
                
                
                let subViews = lineContainerView.subviews.flatMap{ $0 as? BarView }
                for updatedbarImageview in subViews
                {
                    if updatedbarImageview.isKindOfClass(BarView)
                    {
                        
                        var presentValue:CGFloat = CGFloat(updatedbarImageview.presentValue)
                        presentValue = presentValue * differenceheight
                        updatedbarImageview.frame = CGRectMake(updatedbarImageview.frame.origin.x ,self.lineContainerView.frame.size.height - presentValue  , updatedbarImageview.frame.size.width ,presentValue)
                        updatedbarImageview.changeFrameWithHeight(presentValue)

                        
                        
                        
                        
                        
                    }
                }
                for i in 0..<11
                {
                    if (i % 2 == 0)
                    {
                        if let label = lineContainerView.viewWithTag(kLabeltag + i) as? UILabel
                        {
                            let labelValue = NSString(format:"%@",label.text!).intValue;
                            label.text = "\(labelValue * 2)"
                        }
                    }
                }
            }
        }
    }
    
    
    func increaseBarValueWithOptionText(optionText:String)
    {
        
        if let optionId = optionIdDictoryWIthText.objectForKey(optionText) as? String
        {
            if let answerBar  = self.viewWithTag(Int(optionId)!) as? BarView
            {
                answerBar.increasePresentValue()
                
                var presentValue:CGFloat = CGFloat(answerBar.presentValue)
                
                
                
                presentValue = presentValue * differenceheight
                
                
                answerBar.frame = CGRectMake(answerBar.frame.origin.x ,self.lineContainerView.frame.size.height - presentValue  , answerBar.frame.size.width ,presentValue)
                
                
                answerBar.changeFrameWithHeight(presentValue)
                
                
                
                
                if (answerBar.frame.size.height >= lineContainerView.frame.size.height)
                {
                    differenceheight = differenceheight/2;
                    
                    
                    
                    let subViews = lineContainerView.subviews.flatMap{ $0 as? BarView }
                    for updatedbarImageview in subViews
                    {
                        if updatedbarImageview.isKindOfClass(BarView)
                        {
                            
                            var _presentValue:CGFloat = CGFloat(updatedbarImageview.presentValue)
                            _presentValue = _presentValue * differenceheight
                            updatedbarImageview.frame = CGRectMake(updatedbarImageview.frame.origin.x ,self.lineContainerView.frame.size.height - _presentValue  , updatedbarImageview.frame.size.width ,_presentValue)
                            updatedbarImageview.changeFrameWithHeight(_presentValue)
                            
                            
                            
                            
                        }
                    }
                    for i in 0..<11
                    {
                        if (i % 2 == 0)
                        {
                            if let label = lineContainerView.viewWithTag(kLabeltag + i) as? UILabel
                            {
                                let labelValue = NSString(format:"%@",label.text!).intValue;
                                 label.text = "\(labelValue * 2)"
                            }
                        }
                    }
                }
            }
        }
    }
    
    
    func onBarButtonPressed(sender:AnyObject)
    {
        if let currentButton = sender as? BarView
        {
            if delegate().respondsToSelector(#selector(StudentAnswerGraphViewDelegate.delegateBarTouchedWithId(_:withView:)))
            {
                delegate().delegateBarTouchedWithId!("\(currentButton.tag)", withView:currentButton)
            }
        }
    }
    
    func onShareGraph()
    {
        
        
//        let subViews = lineContainerView.subviews.flatMap{ $0 as? BarView }
//        let detailsDictonary = NSMutableDictionary()
//        for subview in subViews
//        {
//            if subview.isKindOfClass(BarView)
//            {
//                
//
//                let  optionsId = subview.tag
//                
//                let valueOfBars = subview.frame.size.height / differenceheight;
//                
//                
//                detailsDictonary.setObject(roundOffNumberWithFloat(Float(valueOfBars)), forKey: "option_\(optionsId)")
//                
//                
//
//                
//            }
//        }
//        
        if delegate().respondsToSelector(#selector(StudentAnswerGraphViewDelegate.delegateShareButtonClickedWithDetails))
        {
            delegate().delegateShareButtonClickedWithDetails!()
        }
        
    }
    
    
    
    func roundOffNumberWithFloat(_numberToRound:Float) ->Int
    {
        
        var numberToRound = _numberToRound
        
        let min = NSString(format: "%.0f", numberToRound).floatValue
    
        let max = min + 1;
        let maxdif = max - numberToRound;
        if (maxdif > 0.5)
        {
            numberToRound = min;
        }
        else
        {
            numberToRound = max;
        }
    
        return Int(numberToRound);
    
    }

    
    
}