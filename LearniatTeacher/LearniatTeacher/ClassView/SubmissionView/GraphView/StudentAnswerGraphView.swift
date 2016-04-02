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


class StudentAnswerGraphView: UIView
{
    var _delgate: AnyObject!
    
    var questionNamelabel = UILabel()
    
    var barCellHeight = CGFloat()
    
    var lineContainerView = UIView()
    
    var basePostionValue :CGFloat = 20
    
    
    var differenceheight      :CGFloat = 10
    
    override init(frame: CGRect)
    {
        
        super.init(frame:frame)
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func setdelegate(delegate:AnyObject)
    {
        _delgate = delegate;
    }
    
    func   delegate()->AnyObject
    {
        return _delgate;
    }
    
    
    func loadViewWithOPtions(optionsArray:NSMutableArray, withQuestion questionName:String)
    {
        
        questionNamelabel.frame =  CGRectMake(10,10,self.frame.size.width,40)
        self.addSubview(questionNamelabel)
        questionNamelabel.font = UIFont (name: helveticaRegular, size: 18)
        questionNamelabel.textColor = blackTextColor
        questionNamelabel.textAlignment = .Center
        
        questionNamelabel.text = questionName
        
        
        lineContainerView.frame  = CGRectMake(0, questionNamelabel.frame.size.height + questionNamelabel.frame.origin.y + 20 , self.frame.size.width, self.frame.size.height - (questionNamelabel.frame.size.height + questionNamelabel.frame.origin.y + 100))
        self.addSubview(lineContainerView)
        
        
        differenceheight = (lineContainerView.frame.size.height) / CGFloat(10)
        
        var labelCount = 0;
        var height:CGFloat = 0;
        for (var i = 10; i >= 0 ; i--)
        {
            if (i % 2 == 0)
            {
                
                let lineView = UIImageView(frame:CGRectMake(100, height, 1000, 1))
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

                let lineView = DottedLine(frame:CGRectMake(100, height, 1000, 1))
                 lineView.drawDashedBorderAroundViewWithColor(UIColor(red: 117/255.0, green: 117/255.0, blue: 117/255.0, alpha: 0.3))
                lineContainerView.addSubview(lineView);

            }
            height = height + differenceheight
        }
        
        
        let columns: Int        = optionsArray.count
        
        
        var width = (lineContainerView.frame.size.width - 100) / CGFloat(columns)
        
        let widthSpace = width * 0.1
        
        width = width * 0.9
        
        var positionX = widthSpace / 2 + 100
        
        for var index = 0; index < optionsArray.count; index++
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
            

            let barView = BarView(frame: CGRectMake(positionX ,lineContainerView.frame.size.height - differenceheight  , width ,differenceheight))
            lineContainerView.addSubview(barView)
            
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
            
            positionX = positionX + width + widthSpace

        }
        
    }
    
}