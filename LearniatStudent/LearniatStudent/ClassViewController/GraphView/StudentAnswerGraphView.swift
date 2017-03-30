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
    
    @objc optional func delegateBarTouchedWithId(_ optionId: String, withView barButton:BarView)
    
    @objc optional func delegateShareButtonClickedWithDetails()
    
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
        
        super.init(frame:frame)
        
        self.backgroundColor = whiteBackgroundColor
        
        questionNamelabel.frame =  CGRect(x: 10,y: 10,width: self.frame.size.width - 50 ,height: 40)
        self.addSubview(questionNamelabel)
        questionNamelabel.font = UIFont (name: helveticaRegular, size: 18)
        questionNamelabel.textColor = blackTextColor
        questionNamelabel.textAlignment = .center
        
        
        shareGraphButton.frame = CGRect(x: self.frame.size.width - 50, y: 10, width: 40,height: 30)
        shareGraphButton.setImage(UIImage(named:"wrongMatch.png"), for:UIControlState())
        self.addSubview(shareGraphButton);
        shareGraphButton.imageView?.contentMode = .scaleAspectFit
        shareGraphButton.addTarget(self, action: #selector(StudentAnswerGraphView.onShareGraph), for: UIControlEvents.touchUpInside)

        
        
        
        lineContainerView.frame  = CGRect(x: 0, y: questionNamelabel.frame.size.height + questionNamelabel.frame.origin.y + 20 , width: self.frame.size.width, height: self.frame.size.height - (questionNamelabel.frame.size.height + questionNamelabel.frame.origin.y + 100))
        self.addSubview(lineContainerView)

        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func loadMRQViewWithOPtions(_ optionsArray:NSMutableArray, withQuestion questionName:String)
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
            if subview.isKind(of: FXLabel.self) || subview.isKind(of: BarView.self)
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
                
                let lineView = UIImageView(frame:CGRect(x: 100, y: height, width: self.frame.size.width - 100, height: 1))
                lineView.backgroundColor = UIColor(red: 117/255.0, green: 117/255.0, blue: 117/255.0, alpha: 0.3)
                lineContainerView.addSubview(lineView);
                
                
                let lable = UILabel(frame:CGRect(x: 60, y: height-25, width: 100, height: 50))
                lable.text = "\(i)"
                lineContainerView.addSubview(lable);
                lable.textColor = blackTextColor
                lable.tag  = kLabeltag + i
                labelCount = labelCount + 1;
            }
            else
            {

                let lineView = DottedLine(frame:CGRect(x: 100, y: height, width: self.frame.size.width - 100, height: 1))
                 lineView.drawDashedBorderAroundView(with: UIColor(red: 117/255.0, green: 117/255.0, blue: 117/255.0, alpha: 0.3))
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
            
            let optionDict = optionsArray.object(at: index)
            
            
                let optionsLabel = FXLabel(frame: CGRect(x: positionX , y: lineContainerView.frame.origin.y + lineContainerView.frame.size.height + 5, width: width ,height: self.frame.size.height - (lineContainerView.frame.origin.y + lineContainerView.frame.size.height + 10)));
                self.addSubview(optionsLabel)
                optionsLabel.lineBreakMode = .byTruncatingMiddle;
                optionsLabel.numberOfLines = 5;
                optionsLabel.textAlignment = .center;
                optionsLabel.contentMode = .top;
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
            
            if let optiontext = (optionDict as AnyObject).object(forKey: "OptionText") as? String
            {
                optionsLabel.text = optiontext
            }
            optionsLabel.backgroundColor = UIColor.clear
            

            let barView = BarView(frame: CGRect(x: positionX ,y: lineContainerView.frame.size.height, width: width ,height: 0))
            lineContainerView.addSubview(barView)
            barView.addTarget(self, action: #selector(StudentAnswerGraphView.onBarButtonPressed(_:)), for: UIControlEvents.touchUpInside)
            if let optionId = (optionDict as AnyObject).object(forKey: "OptionId") as? String
            {
                barView.tag = Int(optionId)!
            }
            
            
            if let IsAnswer = (optionDict as AnyObject).object(forKey: "IsAnswer") as? String
            {
               if IsAnswer == "1"
               {
                    barView.setBarColor( standard_Green)
                }
                else
               {
                 barView.setBarColor(UIColor.lightGray)
                }
            }
            else
            {
                barView.setBarColor(UIColor.lightGray)
            }
            positionX = positionX + width + widthSpace

        }
        
    }
    
    
    
    
    func loadMTCViewWithOPtions(_ optionsArray:NSMutableArray,WithRightSideOptionArray rightOPtionsArray:NSMutableArray, withQuestion questionName:String)
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
            if subview.isKind(of: FXLabel.self) || subview.isKind(of: BarView.self)
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
                
                let lineView = UIImageView(frame:CGRect(x: 100, y: height, width: self.frame.size.width - 100, height: 1))
                lineView.backgroundColor = UIColor(red: 117/255.0, green: 117/255.0, blue: 117/255.0, alpha: 0.3)
                lineContainerView.addSubview(lineView);
                
                
                let lable = UILabel(frame:CGRect(x: 60, y: height-25, width: 100, height: 50))
                lable.text = "\(i)"
                lineContainerView.addSubview(lable);
                lable.textColor = blackTextColor
                lable.tag  = kLabeltag + i
                labelCount = labelCount + 1;
            }
            else
            {
                
                let lineView = DottedLine(frame:CGRect(x: 100, y: height, width: self.frame.size.width - 100, height: 1))
                lineView.drawDashedBorderAroundView(with: UIColor(red: 117/255.0, green: 117/255.0, blue: 117/255.0, alpha: 0.3))
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
            
            let optionDict = optionsArray.object(at: index)
            let rightOPtionDict = rightOPtionsArray.object(at: index)
            
            let optionsLabel = FXLabel(frame: CGRect(x: positionX , y: lineContainerView.frame.origin.y + lineContainerView.frame.size.height + 5, width: width ,height: self.frame.size.height - (lineContainerView.frame.origin.y + lineContainerView.frame.size.height + 10)));
            self.addSubview(optionsLabel)
            optionsLabel.lineBreakMode = .byTruncatingMiddle;
            optionsLabel.numberOfLines = 5;
            optionsLabel.textAlignment = .center;
            optionsLabel.contentMode = .top;
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
            
            if let optiontext = (optionDict as AnyObject).object(forKey: "OptionText") as? String
            {
              
                if let rOptiontext = (rightOPtionDict as AnyObject).object(forKey: "OptionText") as? String
                {
                    optionsLabel.text = "\(optiontext)->\(rOptiontext)"
                }
                else
                {
                    optionsLabel.text = optiontext
                }
                
                
                
            }
            optionsLabel.backgroundColor = UIColor.clear
            
            
            let barView = BarView(frame: CGRect(x: positionX ,y: lineContainerView.frame.size.height, width: width ,height: 0))
            lineContainerView.addSubview(barView)
            barView.addTarget(self, action: #selector(StudentAnswerGraphView.onBarButtonPressed(_:)), for: UIControlEvents.touchUpInside)
            if let optionId = (optionDict as AnyObject).object(forKey: "OptionId") as? String
            {
                barView.tag = Int(optionId)!
                
                if let rOptiontext = (rightOPtionDict as AnyObject).object(forKey: "OptionText") as? String
                {
                    optionIdDictoryWIthText.setObject(optionId, forKey: rOptiontext as NSCopying)
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
    
    
    func increaseMultiplevalu(_ value:Int , withOptionId optionId:String)
    {
        for _ in 0 ..< value
        {
            increaseBarValueWithOPtionID(optionId)
        }
    }
    
    
    func increaseMTCMultiplevalu(_ value:Int , withOptionText OptionText:String)
    {
        for _ in 0 ..< value
        {
            increaseBarValueWithOptionText(OptionText)
        }
    }
    
    
    
    func increaseBarValueWithOPtionID(_ optionId:String)
    {
        
      
        
        
        if let answerBar  = self.viewWithTag(Int(optionId)!) as? BarView
        {
            answerBar.increasePresentValue()
            
            var presentValue:CGFloat = CGFloat(answerBar.presentValue)
            
            
            
            presentValue = presentValue * differenceheight
            
            
             answerBar.frame = CGRect(x: answerBar.frame.origin.x ,y: self.lineContainerView.frame.size.height - presentValue  , width: answerBar.frame.size.width ,height: presentValue)
            
           
            answerBar.changeFrameWithHeight(presentValue)
            
            
            if (answerBar.frame.size.height >= lineContainerView.frame.size.height)
            {
                differenceheight=differenceheight/2;
                
                
                
                let subViews = lineContainerView.subviews.flatMap{ $0 as? BarView }
                for updatedbarImageview in subViews
                {
                    if updatedbarImageview.isKind(of: BarView.self)
                    {
                        
                        var presentValue:CGFloat = CGFloat(updatedbarImageview.presentValue)
                        presentValue = presentValue * differenceheight
                        updatedbarImageview.frame = CGRect(x: updatedbarImageview.frame.origin.x ,y: self.lineContainerView.frame.size.height - presentValue  , width: updatedbarImageview.frame.size.width ,height: presentValue)
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
    
    
    func increaseBarValueWithOptionText(_ optionText:String)
    {
        
        if let optionId = optionIdDictoryWIthText.object(forKey: optionText) as? String
        {
            if let answerBar  = self.viewWithTag(Int(optionId)!) as? BarView
            {
                answerBar.increasePresentValue()
                
                var presentValue:CGFloat = CGFloat(answerBar.presentValue)
                
                
                
                presentValue = presentValue * differenceheight
                
                
                answerBar.frame = CGRect(x: answerBar.frame.origin.x ,y: self.lineContainerView.frame.size.height - presentValue  , width: answerBar.frame.size.width ,height: presentValue)
                
                
                answerBar.changeFrameWithHeight(presentValue)
                
                
                
                
                if (answerBar.frame.size.height >= lineContainerView.frame.size.height)
                {
                    differenceheight = differenceheight/2;
                    
                    
                    
                    let subViews = lineContainerView.subviews.flatMap{ $0 as? BarView }
                    for updatedbarImageview in subViews
                    {
                        if updatedbarImageview.isKind(of: BarView.self)
                        {
                            
                            var _presentValue:CGFloat = CGFloat(updatedbarImageview.presentValue)
                            _presentValue = _presentValue * differenceheight
                            updatedbarImageview.frame = CGRect(x: updatedbarImageview.frame.origin.x ,y: self.lineContainerView.frame.size.height - _presentValue  , width: updatedbarImageview.frame.size.width ,height: _presentValue)
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
    
    
    func onBarButtonPressed(_ sender:AnyObject)
    {
        if let currentButton = sender as? BarView
        {
            if delegate().responds(to: #selector(StudentAnswerGraphViewDelegate.delegateBarTouchedWithId(_:withView:)))
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
        if delegate().responds(to: #selector(StudentAnswerGraphViewDelegate.delegateShareButtonClickedWithDetails))
        {
            delegate().delegateShareButtonClickedWithDetails!()
        }
        
    }
    
    
    
    func roundOffNumberWithFloat(_ _numberToRound:Float) ->Int
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
