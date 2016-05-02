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
    
    
    func delegateStopButtonPressedWithMultiplierValue(multiplier:Int, withOptionsArray optionsArray:NSMutableArray, withOptionsvalue optionsValue:NSMutableArray, withQuestionName questionName: String, withTagValue tag:Int)
    
    
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
        
        self.backgroundColor = lightGrayTopBar
        
        
        questionNamelabel.frame =  CGRectMake(10,10,self.frame.size.width - 50 ,40)
        self.addSubview(questionNamelabel)
        questionNamelabel.font = UIFont (name: helveticaRegular, size: 18)
        questionNamelabel.textColor = blackTextColor
        questionNamelabel.textAlignment = .Center
        
        
        shareGraphButton.frame = CGRectMake(self.frame.size.width - 110, 0, 100, 50)
        shareGraphButton.setTitle("Stop", forState: .Normal)
        shareGraphButton.setTitleColor(standard_Red, forState: .Normal)
        self.addSubview(shareGraphButton);
        shareGraphButton.contentHorizontalAlignment = UIControlContentHorizontalAlignment.Right
        shareGraphButton.addTarget(self, action: #selector(PollingGraphView.onStopButton), forControlEvents: UIControlEvents.TouchUpInside)
        
        
        
        
        lineContainerView.frame  = CGRectMake(0, questionNamelabel.frame.size.height + questionNamelabel.frame.origin.y + 20 , self.frame.size.width, self.frame.size.height - (questionNamelabel.frame.size.height + questionNamelabel.frame.origin.y + 100))
        self.addSubview(lineContainerView)
        
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func loadGraphViewWithOPtions(optionsArray:NSMutableArray, withQuestion questionName:String)
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
            
            let optionText = optionsArray.objectAtIndex(index) as? String
            
            
            let optionsLabel = FXLabel(frame: CGRectMake(positionX , lineContainerView.frame.origin.y + lineContainerView.frame.size.height + 10, width ,self.frame.size.height - (lineContainerView.frame.origin.y + lineContainerView.frame.size.height + 15)));
            self.addSubview(optionsLabel)
            optionsLabel.lineBreakMode = .ByTruncatingMiddle;
            optionsLabel.numberOfLines = 5;
            optionsLabel.textAlignment = .Center;
            optionsLabel.contentMode = .Top;
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
            optionsLabel.backgroundColor = UIColor.clearColor()
            
            
            let barView = BarView(frame: CGRectMake(positionX ,lineContainerView.frame.size.height, width ,0))
            lineContainerView.addSubview(barView)
            barView.addTarget(self, action: #selector(StudentAnswerGraphView.onBarButtonPressed(_:)), forControlEvents: UIControlEvents.TouchUpInside)
            
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
            if mQuerySubView.isKindOfClass(BarView)
            {
                
                optionsValuesArray.addObject(String(format: "\(mQuerySubView.presentValue)"))
                
            }
        }
        
        
        if delegate().respondsToSelector(#selector(PollingGraphViewDelegate.delegateStopButtonPressedWithMultiplierValue(_:withOptionsArray:withOptionsvalue:withQuestionName:withTagValue:)))
         {
            delegate().delegateStopButtonPressedWithMultiplierValue(multipleValue, withOptionsArray: currentOptionsArray, withOptionsvalue: optionsValuesArray, withQuestionName: questionNamelabel.text!,withTagValue: self.tag)
        }
        
        self.removeFromSuperview()
    }
    
    func increaseBarWithOption(studentOption:String)
    {
        if currentOptionsArray.containsObject(studentOption)
        {
            var indexValue = currentOptionsArray.indexOfObject(studentOption)
            
            indexValue = indexValue + optionIndexValue
            
            if let answerBar  = self.viewWithTag(indexValue) as? BarView
            {
                answerBar.increasePresentValue()
                
                var presentValue:CGFloat = CGFloat(answerBar.presentValue)
                
                
                
                presentValue = presentValue * differenceheight
                
                
                answerBar.frame = CGRectMake(answerBar.frame.origin.x ,self.lineContainerView.frame.size.height - presentValue  , answerBar.frame.size.width ,presentValue)
                
                
                answerBar.changeFrameWithHeight(presentValue)
                
                
                if (answerBar.frame.size.height >= lineContainerView.frame.size.height)
                {
                    differenceheight=differenceheight/2;
                    
                    multipleValue = multipleValue + 1
                    
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
    }
    

}
