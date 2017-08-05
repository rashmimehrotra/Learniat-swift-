//
//  PollingGraphView.swift
//  LearniatTeacher
//
//  Created by Deepak MK on 28/04/16.
//  Copyright © 2016 Mindshift. All rights reserved.
//

import Foundation

@objc protocol PollingGraphViewDelegate
{
    
    
    func delegateStopButtonPressedWithMultiplierValue(_ multiplier:Int, withOptionsArray optionsArray:NSMutableArray, withOptionsvalue optionsValue:NSMutableArray, withQuestionName questionName: String, withTagValue tag:Int)
    
    
}

class PollingGraphView: UIView
{
    
    let optionIndexValue = 1000
    
    var questionNamelabel = UILabel()
    
    var barCellHeight = CGFloat()
    
    var lineContainerView = UIView()
    
    var basePostionValue :CGFloat = 20
    
    let shareGraphButton  = UIButton()
    
    var differenceheight      :CGFloat = 10
    
    var currentOptionsArray        = NSMutableArray()
    
    var multipleValue               = 1
    
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
        
        self.backgroundColor = lightGrayTopBar
        
        
        questionNamelabel.frame =  CGRect(x: 10,y: 10,width: self.frame.size.width - 50 ,height: 40)
        self.addSubview(questionNamelabel)
        questionNamelabel.font = UIFont (name: helveticaRegular, size: 18)
        questionNamelabel.textColor = blackTextColor
        questionNamelabel.textAlignment = .center
        
        
        shareGraphButton.frame = CGRect(x: self.frame.size.width - 110, y: 0, width: 100, height: 50)
        shareGraphButton.setTitle("Stop", for: UIControlState())
        shareGraphButton.setTitleColor(standard_Red, for: UIControlState())
        self.addSubview(shareGraphButton);
        shareGraphButton.contentHorizontalAlignment = UIControlContentHorizontalAlignment.right
        shareGraphButton.addTarget(self, action: #selector(PollingGraphView.onStopButton), for: UIControlEvents.touchUpInside)
        
        
        
        
        lineContainerView.frame  = CGRect(x: 0, y: questionNamelabel.frame.size.height + questionNamelabel.frame.origin.y + 20 , width: self.frame.size.width, height: self.frame.size.height - (questionNamelabel.frame.size.height + questionNamelabel.frame.origin.y + 100))
        self.addSubview(lineContainerView)
        
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func loadGraphViewWithOPtions(_ optionsArray:NSMutableArray, withQuestion questionName:String)
    {
        
        
        questionNamelabel.text = questionName
        currentOptionsArray = optionsArray
        
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
            
            let optionText = optionsArray.object(at: index) as? String
            
            
            let optionsLabel = FXLabel(frame: CGRect(x: positionX , y: lineContainerView.frame.origin.y + lineContainerView.frame.size.height + 10, width: width ,height: self.frame.size.height - (lineContainerView.frame.origin.y + lineContainerView.frame.size.height + 15)));
            self.addSubview(optionsLabel)
            optionsLabel.lineBreakMode = .byTruncatingMiddle;
            optionsLabel.numberOfLines = 5;
            optionsLabel.textAlignment = .center;
            optionsLabel.contentMode = .top;
            optionsLabel.textColor = blackTextColor
            
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
            //barView.addTarget(self, action: #selector(StudentAnswerGraphView.onBarButtonPressed(_:)), for: UIControlEvents.touchUpInside)
            
            barView.tag = optionIndexValue + index
            barView.setBarColor(standard_Button)
            
            positionX = positionX + width + widthSpace
            
        }
        
    }
    
    
    func onStopButton()
    {
        SSTeacherMessageHandler.sharedMessageHandler.sendPollStoppedMessageToRoom(SSTeacherDataSource.sharedDataSource.currentLiveSessionId)
        
        let optionsValuesArray = NSMutableArray()
        
        let subViews = lineContainerView.subviews.flatMap{ $0 as? BarView }
        for mQuerySubView in subViews
        {
            if mQuerySubView.isKind(of: BarView.self)
            {
                
                optionsValuesArray.add(String(format: "\(mQuerySubView.presentValue)"))
                
            }
        }
        
        
        if delegate().responds(to: #selector(PollingGraphViewDelegate.delegateStopButtonPressedWithMultiplierValue(_:withOptionsArray:withOptionsvalue:withQuestionName:withTagValue:)))
         {
            delegate().delegateStopButtonPressedWithMultiplierValue(multipleValue, withOptionsArray: currentOptionsArray, withOptionsvalue: optionsValuesArray, withQuestionName: questionNamelabel.text!,withTagValue: self.tag)
        }
        
        self.removeFromSuperview()
    }
    
    func increaseBarWithOption(_ studentOption:String)
    {
        if currentOptionsArray.contains(studentOption)
        {
            var indexValue = currentOptionsArray.index(of: studentOption)
            
            indexValue = indexValue + optionIndexValue
            
            if let answerBar  = self.viewWithTag(indexValue) as? BarView
            {
                answerBar.increasePresentValue()
                
                var presentValue:CGFloat = CGFloat(answerBar.presentValue)
                
                
                
                presentValue = presentValue * differenceheight
                
                
                answerBar.frame = CGRect(x: answerBar.frame.origin.x ,y: self.lineContainerView.frame.size.height - presentValue  , width: answerBar.frame.size.width ,height: presentValue)
                
                
                answerBar.changeFrameWithHeight(presentValue)
                
                
                if (answerBar.frame.size.height >= lineContainerView.frame.size.height)
                {
                    differenceheight=differenceheight/2;
                    
                    multipleValue = multipleValue + 1
                    
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
    }
    

}
