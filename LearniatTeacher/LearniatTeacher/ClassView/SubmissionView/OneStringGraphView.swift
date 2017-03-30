//
//  OneStringGraphView.swift
//  LearniatTeacher
//
//  Created by Deepak MK on 24/05/16.
//  Copyright © 2016 Mindshift. All rights reserved.
//

import Foundation


@objc protocol OneStringGraphViewDelegate
{
    
    @objc optional func delegateWordCloudButtonPressed()
    
    
    
}



class OneStringGraphView: UIView
{
    
    var questionNamelabel = UILabel()
    
    var barCellHeight = CGFloat()
    
    var lineContainerView = UIView()
    
    var basePostionValue :CGFloat = 20
    
    var differenceheight      :CGFloat = 10
    
    var optionIdDictionary = NSMutableDictionary()
    
    var  OptionIdValue = 10
    
    var positionX:CGFloat = 10
    
    var optionsScrollView   = UIScrollView()
    
    var _delgate: AnyObject!
    
    var currentOptionsArray  = NSMutableArray()
    
    
    var wordCloudButton = UIButton()
    
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
        super.init(frame: frame)
        
        
        wordCloudButton.frame = CGRect(x: self.frame.size.width - 130 , y: 10, width: 120, height: 40)
        self.addSubview(wordCloudButton)
        wordCloudButton.backgroundColor = standard_Button
        wordCloudButton.setTitleColor(whiteColor, for: UIControlState())
        wordCloudButton.setTitle("Word cloud", for: UIControlState())
        wordCloudButton.addTarget(self, action: #selector(OneStringGraphView.onWordCloudButton), for: UIControlEvents.touchUpInside)

        
        questionNamelabel.frame =  CGRect(x: 10,y: 10,width: self.frame.size.width - 130 ,height: 40)
        self.addSubview(questionNamelabel)
        questionNamelabel.font = UIFont (name: helveticaRegular, size: 18)
        questionNamelabel.textColor = blackTextColor
        questionNamelabel.textAlignment = .center
        

        lineContainerView.frame  = CGRect(x: 0, y: questionNamelabel.frame.size.height + questionNamelabel.frame.origin.y + 20 , width: self.frame.size.width, height: self.frame.size.height - (questionNamelabel.frame.size.height + questionNamelabel.frame.origin.y + 100))
        self.addSubview(lineContainerView)
        
        
        optionsScrollView.frame = CGRect(x: 100, y: questionNamelabel.frame.size.height + questionNamelabel.frame.origin.y + 20 , width: lineContainerView.frame.size.width - 100 , height: self.frame.size.height - (questionNamelabel.frame.size.height + questionNamelabel.frame.origin.y + 20))
        self.addSubview(optionsScrollView)
        
        
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
        
        
    }
    
    
    func onWordCloudButton()
    {
        delegate().delegateWordCloudButtonPressed!()
    }
    
    required init?(coder aDecoder: NSCoder)
    {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setQuestionName(_ questionName :String, withDetails details:AnyObject)
    {
         questionNamelabel.text = questionName
        
        
        print(details)
        currentOptionsArray.removeAllObjects()
        
        if let options = details.object(forKey: "Options")
        {
            if let classCheckingVariable = (options as AnyObject).object(forKey: "Option") as? NSMutableArray
            {
                currentOptionsArray = classCheckingVariable
            }
            else
            {
                currentOptionsArray.add((details.object(forKey: "Options")! as AnyObject).object(forKey: "Option")!)
                
            }
        }
        
        
        
        
    }
    
    func setOptionWithString(_ optionString:String, withCheckingState state:Bool)
    {
        if optionIdDictionary.object(forKey: optionString.removeWhitespace().removeSpecialCharsFromString().capitalized) == nil
        {
            optionIdDictionary.setObject("\(OptionIdValue)", forKey: optionString.removeWhitespace().removeSpecialCharsFromString().capitalized as NSCopying)

            let optionsLabel = FXLabel(frame: CGRect(x: positionX , y: lineContainerView.frame.size.height + 5, width: 100 ,height: optionsScrollView.frame.size.height - (lineContainerView.frame.size.height + 10)));
            optionsScrollView.addSubview(optionsLabel)
            optionsLabel.lineBreakMode = .byTruncatingMiddle;
            optionsLabel.numberOfLines = 5;
            optionsLabel.textAlignment = .center;
            optionsLabel.contentMode = .top;
            optionsLabel.textColor = blackTextColor
            optionsLabel.backgroundColor = UIColor.clear
            
            optionsLabel.text = optionString
            
            
            let barView = BarView(frame: CGRect(x: positionX ,y: lineContainerView.frame.size.height, width: optionsLabel.frame.size.width ,height: 0))
            optionsScrollView.addSubview(barView)
//            barView.addTarget(self, action: #selector(StudentAnswerGraphView.onBarButtonPressed(_:)), forControlEvents: UIControlEvents.TouchUpInside)
            barView.tag = OptionIdValue
            
            print(currentOptionsArray)
            
             barView.setBarColor( lightGrayColor)
            
            for index in currentOptionsArray
            {
                if let optionText = (index as AnyObject).object(forKey: "OptionText") as? String
                {
                    if optionText.removeWhitespace().removeSpecialCharsFromString().capitalized == optionString.removeWhitespace().removeSpecialCharsFromString().capitalized
                    {
                        barView.setBarColor( standard_Green)
                        break
                        
                    }
                }
            }
            
            
            
            
            
             barView.increasePresentValue()
            
            var presentValue:CGFloat = CGFloat(barView.presentValue)
            
            
            
            presentValue = presentValue * differenceheight
            
            
            barView.frame = CGRect(x: barView.frame.origin.x ,y: lineContainerView.frame.size.height - presentValue  , width: barView.frame.size.width ,height: presentValue)
            
            
            barView.changeFrameWithHeight(presentValue)
            
            positionX = positionX + optionsLabel.frame.size.width + 10
            
            OptionIdValue = OptionIdValue + 1
            
            optionsScrollView.contentSize = CGSize(width: positionX, height: 0)
            
            
            
        }
        else
        {
          if  let optionStringValue = optionIdDictionary.object(forKey: (optionString.removeWhitespace().removeSpecialCharsFromString().capitalized)) as? String

          {
                let optionValue = Int(optionStringValue)
                if let answerBar  = self.viewWithTag(optionValue!) as? BarView
                {
                    answerBar.increasePresentValue()
                    
                    var presentValue:CGFloat = CGFloat(answerBar.presentValue)
                    
                    
                    
                    presentValue = presentValue * differenceheight
                    
                    
                    answerBar.frame = CGRect(x: answerBar.frame.origin.x ,y: lineContainerView.frame.size.height - presentValue  , width: answerBar.frame.size.width ,height: presentValue)
                    
                    
                    answerBar.changeFrameWithHeight(presentValue)
                    
                    
                    if (answerBar.frame.size.height >= lineContainerView.frame.size.height)
                    {
                        differenceheight=differenceheight/2;
                        
                        
                        
                        let subViews = optionsScrollView.subviews.flatMap{ $0 as? BarView }
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
        }
    }
    
    
}
