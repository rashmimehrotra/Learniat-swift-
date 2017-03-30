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
    
    func delegateOnResendButtonPressedWithOptions(_ optionsArray:NSMutableArray, withQuestionName questionName:String,withTagValue tagValue:Int)
    
    
    
}


class PollCompletedView: UIView
{
    var _delgate: AnyObject!
    
    
     let optionIndexValue = 1000
    
    var questionNamelabel = UILabel()
    
    var lineContainerView = UIView()
    
    var currentOptionsArray = NSMutableArray()
    
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
        
        
        self.backgroundColor = UIColor.white
        let mResendButton  = UIButton(frame :CGRect(x: 10, y: 0, width: 100, height: 30))
        mResendButton.setTitle("Resend", for: UIControlState())
        mResendButton.setTitleColor(standard_Green, for: UIControlState())
        self.addSubview(mResendButton);
        mResendButton.imageView?.contentMode = .scaleAspectFit
        mResendButton.contentHorizontalAlignment = UIControlContentHorizontalAlignment.left
        mResendButton.addTarget(self, action: #selector(PollCompletedView.onResendButton), for: UIControlEvents.touchUpInside)
        
        
        
        let mFullScreenButton  = UIButton(frame :CGRect(x: self.frame.size.width - 105, y: 0, width: 100, height: 30))
        mFullScreenButton.setTitle("Full screen", for: UIControlState())
        mFullScreenButton.setTitleColor(standard_Button, for: UIControlState())
        self.addSubview(mFullScreenButton);
        mFullScreenButton.imageView?.contentMode = .scaleAspectFit
        mFullScreenButton.addTarget(self, action: #selector(PollCompletedView.onFullScreenButton), for: UIControlEvents.touchUpInside)
        mFullScreenButton.contentHorizontalAlignment = UIControlContentHorizontalAlignment.right
        
        
        
        
        let lineView = UIImageView(frame:CGRect(x: 0, y: mFullScreenButton.frame.size.height + 5 , width: self.frame.size.width, height: 2))
        lineView.backgroundColor = lightGrayTopBar
        self.addSubview(lineView)
        
        
        
        
        let currentDate = Date()
       
    
        let timelabel = UILabel(frame:CGRect(x: self.frame.size.width - 80 ,y: lineView.frame.origin.y + lineView.frame.size.height ,width: 70 ,height: 40))
        self.addSubview(timelabel)
        timelabel.font = UIFont (name: helveticaRegular, size: 12)
        timelabel.textColor = lightGrayColor
        timelabel.textAlignment = .right
        timelabel.text = currentDate.toShortTimeString()
        
        questionNamelabel.frame =  CGRect(x: 10,y: lineView.frame.origin.y + lineView.frame.size.height ,width: self.frame.size.width - (timelabel.frame.size.width + 20) ,height: 40)
        self.addSubview(questionNamelabel)
        questionNamelabel.font = UIFont (name: helveticaRegular, size: 16)
        questionNamelabel.textColor = blackTextColor
        questionNamelabel.textAlignment = .left

        
        
        
        lineContainerView.frame  = CGRect(x: 0, y: questionNamelabel.frame.size.height + questionNamelabel.frame.origin.y + 10, width: self.frame.size.width, height: self.frame.size.height - (timelabel.frame.size.height + timelabel.frame.origin.y + 100))
        self.addSubview(lineContainerView)
        
        
    }
    func onResendButton()
    {
        if delegate().responds(to: #selector(PollCompletedViewDelegate.delegateOnResendButtonPressedWithOptions(_:withQuestionName:withTagValue:)))
        {
            
            if currentOptionsArray.count > 0
            {
                
                let optionsValue = currentOptionsArray.componentsJoined(by: ";;;")
                
                 SSTeacherMessageHandler.sharedMessageHandler.sendLikertPollMessageToRoom(SSTeacherDataSource.sharedDataSource.currentLiveSessionId, withSelectedOption: optionsValue, withQuestionName: questionNamelabel.text!)
                
                delegate().delegateOnResendButtonPressedWithOptions(currentOptionsArray, withQuestionName: questionNamelabel.text!, withTagValue: self.tag)
            }
            
            
            
           
        }
    }
    
    func onFullScreenButton()
    {
        
    }
    
    
    
    func setGraphDetailsWithQuestionName(_ questioName:String, withOPtionsArray optionsArray:NSMutableArray, withOptionsValues optionValuesArray:NSMutableArray, withMultiplier multiplier:Int)
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
            if subview.isKind(of: FXLabel.self) || subview.isKind(of: BarView.self)
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
                
                let lineView = UIImageView(frame:CGRect(x: 35, y: height, width: self.frame.size.width - 35, height: 1))
                lineView.backgroundColor = LineGrayColor
                lineContainerView.addSubview(lineView);
                
                
                let lable = UILabel(frame:CGRect(x: 5, y: height-25, width: 25, height: 50))
                lable.text = "\(i * multiplier)"
                lineContainerView.addSubview(lable);
                lable.textColor = blackTextColor
                lable.tag  = kLabeltag + i
                labelCount = labelCount + 1;
                lable.textAlignment = .right
            }
            else
            {
                
                let lineView = DottedLine(frame:CGRect(x: 35, y: height, width: self.frame.size.width - 35, height: 1))
                lineView.drawDashedBorderAroundView(with: UIColor(red: 117/255.0, green: 117/255.0, blue: 117/255.0, alpha: 0.3))
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
            
            let optionText = optionsArray.object(at: index) as? String
           
            
            let optionsLabel = FXLabel(frame: CGRect(x: positionX , y: lineContainerView.frame.origin.y + lineContainerView.frame.size.height + 10, width: width ,height: self.frame.size.height - (lineContainerView.frame.origin.y + lineContainerView.frame.size.height + 15)));
            self.addSubview(optionsLabel)
            optionsLabel.lineBreakMode = .byTruncatingMiddle;
            optionsLabel.numberOfLines = 5;
            optionsLabel.textAlignment = .center;
            optionsLabel.contentMode = .top;
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
            optionsLabel.backgroundColor = UIColor.clear
            
            

            
            let barView = BarView(frame: CGRect(x: positionX ,y: lineContainerView.frame.size.height, width: width ,height: 0))
            lineContainerView.addSubview(barView)
//            barView.addTarget(self, action: #selector(StudentAnswerGraphView.onBarButtonPressed(_:)), forControlEvents: UIControlEvents.TouchUpInside)
            barView.tag = optionIndexValue + index
            barView.setBarColor(standard_Button)
            
           
            
            if  let optionsValues = optionValuesArray.object(at: index) as? String
            {
                
               let presentValue = CGFloat(Int(optionsValues)!) * barValueVaueHeight
                barView.frame = CGRect(x: positionX ,y: lineContainerView.frame.size.height - presentValue, width: width ,height: presentValue)
                
                barView.changeFrameWithHeight(presentValue)
            }
            
           positionX = positionX + width + widthSpace
            
        }
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    
    
    
}
