//
//  OneStringGraphView.swift
//  LearniatTeacher
//
//  Created by Deepak MK on 24/05/16.
//  Copyright © 2016 Mindshift. All rights reserved.
//

import Foundation

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
        super.init(frame: frame)
        
        questionNamelabel.frame =  CGRectMake(10,10,self.frame.size.width - 50 ,40)
        self.addSubview(questionNamelabel)
        questionNamelabel.font = UIFont (name: helveticaRegular, size: 18)
        questionNamelabel.textColor = blackTextColor
        questionNamelabel.textAlignment = .Center
        

        lineContainerView.frame  = CGRectMake(0, questionNamelabel.frame.size.height + questionNamelabel.frame.origin.y + 20 , self.frame.size.width, self.frame.size.height - (questionNamelabel.frame.size.height + questionNamelabel.frame.origin.y + 100))
        self.addSubview(lineContainerView)
        
        
        optionsScrollView.frame = CGRectMake(100, questionNamelabel.frame.size.height + questionNamelabel.frame.origin.y + 20 , lineContainerView.frame.size.width - 100 , self.frame.size.height - (questionNamelabel.frame.size.height + questionNamelabel.frame.origin.y + 20))
        self.addSubview(optionsScrollView)
        
        
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
        
        
    }
    
    required init?(coder aDecoder: NSCoder)
    {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setQuestionName(questionName :String)
    {
         questionNamelabel.text = questionName
    }
    
    func setOptionWithString(optionString:String)
    {
        if optionIdDictionary.objectForKey(optionString) == nil
        {
            optionIdDictionary.setObject("\(OptionIdValue)", forKey: optionString)
            
            let optionsLabel = FXLabel(frame: CGRectMake(positionX , lineContainerView.frame.size.height + 5, 70 ,optionsScrollView.frame.size.height - (lineContainerView.frame.size.height + 10)));
            optionsScrollView.addSubview(optionsLabel)
            optionsLabel.lineBreakMode = .ByTruncatingMiddle;
            optionsLabel.numberOfLines = 5;
            optionsLabel.textAlignment = .Center;
            optionsLabel.contentMode = .Top;
            optionsLabel.textColor = blackTextColor
            optionsLabel.backgroundColor = UIColor.clearColor()
            
            optionsLabel.text = optionString
            
            
            let barView = BarView(frame: CGRectMake(positionX ,lineContainerView.frame.size.height, 70 ,0))
            optionsScrollView.addSubview(barView)
//            barView.addTarget(self, action: #selector(StudentAnswerGraphView.onBarButtonPressed(_:)), forControlEvents: UIControlEvents.TouchUpInside)
            barView.tag = OptionIdValue
             barView.setBarColor( standard_Green)
             barView.increasePresentValue()
            
            var presentValue:CGFloat = CGFloat(barView.presentValue)
            
            
            
            presentValue = presentValue * differenceheight
            
            
            barView.frame = CGRectMake(barView.frame.origin.x ,lineContainerView.frame.size.height - presentValue  , barView.frame.size.width ,presentValue)
            
            
            barView.changeFrameWithHeight(presentValue)
            
            positionX = positionX + optionsLabel.frame.size.width + 10
            
            OptionIdValue = OptionIdValue + 1
            
            optionsScrollView.contentSize = CGSizeMake(positionX, 0)
            
            
            
        }
        else
        {
          if  let optionString = optionIdDictionary.objectForKey(optionString) as? String
          {
                let optionValue = Int(optionString)
                if let answerBar  = self.viewWithTag(optionValue!) as? BarView
                {
                    answerBar.increasePresentValue()
                    
                    var presentValue:CGFloat = CGFloat(answerBar.presentValue)
                    
                    
                    
                    presentValue = presentValue * differenceheight
                    
                    
                    answerBar.frame = CGRectMake(answerBar.frame.origin.x ,lineContainerView.frame.size.height - presentValue  , answerBar.frame.size.width ,presentValue)
                    
                    
                    answerBar.changeFrameWithHeight(presentValue)
                    
                    
                    if (answerBar.frame.size.height >= lineContainerView.frame.size.height)
                    {
                        differenceheight=differenceheight/2;
                        
                        
                        
                        let subViews = optionsScrollView.subviews.flatMap{ $0 as? BarView }
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
        }
    }
    
    
}