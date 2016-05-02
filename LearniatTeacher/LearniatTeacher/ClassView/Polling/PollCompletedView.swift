//
//  PollCompletedView.swift
//  LearniatTeacher
//
//  Created by Deepak MK on 28/04/16.
//  Copyright © 2016 Mindshift. All rights reserved.
//

import Foundation
@objc protocol PollCompletedViewDelegate
{
    
    func delegateOnResendButtonPressedWithOptions(optionsArray:NSMutableArray, withQuestionName questionName:String,withTagValue tagValue:Int)
    
    
    
}


class PollCompletedView: UIView
{
    var _delgate: AnyObject!
    
    
     let optionIndexValue = 1000
    
    var questionNamelabel = UILabel()
    
    var lineContainerView = UIView()
    
    var currentOptionsArray = NSMutableArray()
    
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
        
        
        self.backgroundColor = UIColor.whiteColor()
        let mResendButton  = UIButton(frame :CGRectMake(10, 0, 100, 30))
        mResendButton.setTitle("Resend", forState: .Normal)
        mResendButton.setTitleColor(standard_Green, forState: .Normal)
        self.addSubview(mResendButton);
        mResendButton.imageView?.contentMode = .ScaleAspectFit
        mResendButton.contentHorizontalAlignment = UIControlContentHorizontalAlignment.Left
        mResendButton.addTarget(self, action: #selector(PollCompletedView.onResendButton), forControlEvents: UIControlEvents.TouchUpInside)
        
        
        
        let mFullScreenButton  = UIButton(frame :CGRectMake(self.frame.size.width - 105, 0, 100, 30))
        mFullScreenButton.setTitle("Full screen", forState: .Normal)
        mFullScreenButton.setTitleColor(standard_Button, forState: .Normal)
        self.addSubview(mFullScreenButton);
        mFullScreenButton.imageView?.contentMode = .ScaleAspectFit
        mFullScreenButton.addTarget(self, action: #selector(PollCompletedView.onFullScreenButton), forControlEvents: UIControlEvents.TouchUpInside)
        mFullScreenButton.contentHorizontalAlignment = UIControlContentHorizontalAlignment.Right
        
        
        
        
        let lineView = UIImageView(frame:CGRectMake(0, mFullScreenButton.frame.size.height + 5 , self.frame.size.width, 2))
        lineView.backgroundColor = lightGrayTopBar
        self.addSubview(lineView)
        
        
        
        
        let currentDate = NSDate()
       
    
        let timelabel = UILabel(frame:CGRectMake(self.frame.size.width - 80 ,lineView.frame.origin.y + lineView.frame.size.height ,70 ,40))
        self.addSubview(timelabel)
        timelabel.font = UIFont (name: helveticaRegular, size: 12)
        timelabel.textColor = lightGrayColor
        timelabel.textAlignment = .Right
        timelabel.text = currentDate.toShortTimeString()
        
        questionNamelabel.frame =  CGRectMake(10,lineView.frame.origin.y + lineView.frame.size.height ,self.frame.size.width - (timelabel.frame.size.width + 20) ,40)
        self.addSubview(questionNamelabel)
        questionNamelabel.font = UIFont (name: helveticaRegular, size: 16)
        questionNamelabel.textColor = blackTextColor
        questionNamelabel.textAlignment = .Left

        
        
        
        lineContainerView.frame  = CGRectMake(0, questionNamelabel.frame.size.height + questionNamelabel.frame.origin.y + 10, self.frame.size.width, self.frame.size.height - (timelabel.frame.size.height + timelabel.frame.origin.y + 100))
        self.addSubview(lineContainerView)
        
        
    }
    func onResendButton()
    {
        if delegate().respondsToSelector(#selector(PollCompletedViewDelegate.delegateOnResendButtonPressedWithOptions(_:withQuestionName:withTagValue:)))
        {
            
            if currentOptionsArray.count > 0
            {
                
                let optionsValue = currentOptionsArray.componentsJoinedByString(";;;")
                
                 SSTeacherMessageHandler.sharedMessageHandler.sendLikertPollMessageToRoom(SSTeacherDataSource.sharedDataSource.currentLiveSessionId, withSelectedOption: optionsValue, withQuestionName: questionNamelabel.text!)
                
                delegate().delegateOnResendButtonPressedWithOptions(currentOptionsArray, withQuestionName: questionNamelabel.text!, withTagValue: self.tag)
            }
            
            
            
           
        }
    }
    
    func onFullScreenButton()
    {
        
    }
    
    
    
    func setGraphDetailsWithQuestionName(questioName:String, withOPtionsArray optionsArray:NSMutableArray, withOptionsValues optionValuesArray:NSMutableArray, withMultiplier multiplier:Int)
    {
        
        currentOptionsArray = optionsArray
        
        questionNamelabel.text = questioName
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
        
        
        
        let  differenceheight = (lineContainerView.frame.size.height) / CGFloat(10)
        
        var labelCount = 0;
        var height:CGFloat = differenceheight * 10;
        for i in 0..<11
        {
            if (i % 2 == 0)
            {
                
                let lineView = UIImageView(frame:CGRectMake(35, height, self.frame.size.width - 35, 1))
                lineView.backgroundColor = LineGrayColor
                lineContainerView.addSubview(lineView);
                
                
                let lable = UILabel(frame:CGRectMake(5, height-25, 25, 50))
                lable.text = "\(i * multiplier)"
                lineContainerView.addSubview(lable);
                lable.textColor = blackTextColor
                lable.tag  = kLabeltag + i
                labelCount = labelCount + 1;
                lable.textAlignment = .Right
            }
            else
            {
                
                let lineView = DottedLine(frame:CGRectMake(35, height, self.frame.size.width - 35, 1))
                lineView.drawDashedBorderAroundViewWithColor(UIColor(red: 117/255.0, green: 117/255.0, blue: 117/255.0, alpha: 0.3))
                lineContainerView.addSubview(lineView);
                
            }
            height = height - differenceheight
        }
        
        
        
        let columns: Int        = optionsArray.count
        
        
        var width = (lineContainerView.frame.size.width - 35) / CGFloat(columns)
        
        let widthSpace = width * 0.1
        
        width = width * 0.9
        
        var positionX = widthSpace / 2 + 35
        
        let barValueVaueHeight =  differenceheight / CGFloat(multiplier)
        
        for index in 0 ..< optionsArray.count
        {
            
            let optionText = optionsArray.objectAtIndex(index) as? String
           
            
            let optionsLabel = FXLabel(frame: CGRectMake(positionX , lineContainerView.frame.origin.y + lineContainerView.frame.size.height + 10, width ,self.frame.size.height - (lineContainerView.frame.origin.y + lineContainerView.frame.size.height + 15)));
            self.addSubview(optionsLabel)
            optionsLabel.lineBreakMode = .ByTruncatingMiddle;
            optionsLabel.numberOfLines = 5;
            optionsLabel.textAlignment = .Center;
            optionsLabel.contentMode = .Top;
            optionsLabel.textColor = blackTextColor
            optionsLabel.backgroundColor = standard_Button
            var font = UIFont(name:helveticaRegular, size:16)
            if (optionsArray.count > 4)
            {
                font = UIFont(name:helveticaRegular, size:16)
            }
            else
            {
                font = UIFont(name:helveticaRegular, size:18)
            }
            optionsLabel.font = font
            
            optionsLabel.text = optionText
            optionsLabel.backgroundColor = UIColor.clearColor()
            
            

            
            let barView = BarView(frame: CGRectMake(positionX ,lineContainerView.frame.size.height, width ,0))
            lineContainerView.addSubview(barView)
//            barView.addTarget(self, action: #selector(StudentAnswerGraphView.onBarButtonPressed(_:)), forControlEvents: UIControlEvents.TouchUpInside)
            barView.tag = optionIndexValue + index
            barView.setBarColor(standard_Button)
            
           
            
            if  let optionsValues = optionValuesArray.objectAtIndex(index) as? String
            {
                
               let presentValue = CGFloat(Int(optionsValues)!) * barValueVaueHeight
                barView.frame = CGRectMake(positionX ,lineContainerView.frame.size.height - presentValue, width ,presentValue)
                
                barView.changeFrameWithHeight(presentValue)
            }
            
           positionX = positionX + width + widthSpace
            
        }
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    
    
    
}