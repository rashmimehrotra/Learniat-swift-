//
//  LessonPlanQuestionViewCell.swift
//  LearniatTeacher
//
//  Created by mindshift_Deepak on 16/04/16.
//  Copyright © 2016 Mindshift. All rights reserved.
//

import Foundation
@objc protocol LessonPlanQuestionViewCellDelegate
{
    
    
    
    optional func delegateOnInfoButtonWithDetails(questionDetails:AnyObject, withButton infoButton:UIImageView)
    
}


class LessonPlanQuestionViewCell: UIView
{
    var _delgate: AnyObject!
    
    
    var mQuestionNameLabel  :UILabel  = UILabel()
    
    var mIndexValuesLabel   :UILabel   = UILabel()
    
    var mInfoButtonButton    :UIButton  = UIButton()
    
    var mInfoButtonImage   = UIImageView()
    
    var mQuestionTypeLabel  :UILabel   = UILabel()
    
    let checkBoxImage       = UIImageView()
    
    var m_checkBoxButton :UIButton!
    
    var currentQuestionDetails :AnyObject!
    
     var  isSelected             = true
    
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
        
        
        m_checkBoxButton = UIButton(frame:CGRectMake(0, 0, self.frame.size.width/2 ,self.frame.size.height));
        self.addSubview(m_checkBoxButton);
       
        checkBoxImage.frame = CGRectMake(10  , 10,20,20)
        checkBoxImage.image = UIImage(named:"Checked.png");
        self.addSubview(checkBoxImage);
        m_checkBoxButton.addTarget(self, action: #selector(LessonPlanQuestionViewCell.checkMarkPressed), forControlEvents: UIControlEvents.TouchUpInside)

        
        
        mQuestionNameLabel.frame = CGRectMake(checkBoxImage.frame.size.width + checkBoxImage.frame.origin.x + 10 , 10 , self.frame.size.width - (checkBoxImage.frame.size.width + checkBoxImage.frame.origin.x + 15) , self.frame.size.height)
        mQuestionNameLabel.font = UIFont(name:helveticaRegular, size: 18)
        self.addSubview(mQuestionNameLabel)
        mQuestionNameLabel.textColor = blackTextColor
        mQuestionNameLabel.textAlignment = .Left
        mQuestionNameLabel.lineBreakMode = .ByTruncatingMiddle
        mQuestionNameLabel.numberOfLines  = 20
        
        mIndexValuesLabel.font = UIFont(name:helveticaRegular, size: 16)
        self.addSubview(mIndexValuesLabel)
        mIndexValuesLabel.textColor = blackTextColor
        mIndexValuesLabel.textAlignment = .Left
        mIndexValuesLabel.lineBreakMode = .ByTruncatingMiddle
        
        
        mQuestionTypeLabel.font = UIFont(name:helveticaRegular, size: 16)
        self.addSubview(mQuestionTypeLabel)
        mQuestionTypeLabel.textColor = UIColor(red: 160.0/255.0, green: 160.0/255.0, blue: 160.0/255.0, alpha: 1)   //333333
        mQuestionTypeLabel.textAlignment = .Center
        mQuestionTypeLabel.lineBreakMode = .ByTruncatingMiddle
        
        
        self.addSubview(mInfoButtonImage)
        mInfoButtonImage.image = UIImage(named: "infoButton.png")
        mInfoButtonImage.contentMode = .ScaleAspectFill
        
        self.addSubview(mInfoButtonButton)
        mInfoButtonButton.addTarget(self, action: #selector(LessonPlanQuestionViewCell.onInfoButton), forControlEvents: UIControlEvents.TouchUpInside)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func getCurrentCellHeightWithDetails(details:AnyObject, WIthCountValue questionCout:Int) -> CGFloat
    {
        
        var height :CGFloat = 100
        
        
        
        
        
        currentQuestionDetails = details
        
        if var questionName = details.objectForKey("Name")as? String
        {
             questionName = questionName.capitalizedString
            
            mQuestionNameLabel.text = "\(questionCout). \(questionName)"
            
            height = heightForView(questionName, font: mQuestionNameLabel.font, width: mQuestionNameLabel.frame.size.width)
            
            mQuestionNameLabel.frame = CGRectMake(mQuestionNameLabel.frame.origin.x, mQuestionNameLabel.frame.origin.y, mQuestionNameLabel.frame.size.width, height)
        }
        else
        {
            mQuestionNameLabel.text = "\(questionCout)."
            
            height = heightForView(mQuestionNameLabel.text!, font: mQuestionNameLabel.font, width: mQuestionNameLabel.frame.size.width)
            
            mQuestionNameLabel.frame = CGRectMake(mQuestionNameLabel.frame.origin.x, mQuestionNameLabel.frame.origin.y + 10, mQuestionNameLabel.frame.size.width, height)
        }
        
        height = height + 60
        
        
        let seperatorView = UIView(frame: CGRectMake(5 ,height - 1 , self.frame.size.width - 10,1))
        seperatorView.backgroundColor = topicsLineColor;
        self.addSubview(seperatorView)
        
        
        
        
        if let QuestonAvgScore = details.objectForKey("QuestonAvgScore")as? NSString
        {
//            QuestonAvgScore = String(format: "%02d", QuestonAvgScore.intValue)
            
            let questionAverage = QuestonAvgScore.floatValue * 100.0
            
            if let NumberOfResponses = details.objectForKey("NumberOfResponses")as? NSString
            {
                
                if NumberOfResponses.intValue > 0
                {
                    mIndexValuesLabel.hidden = false
                    
                    
                   let  _string =  NSMutableAttributedString(string:"\(String(format: "%02d", Int(questionAverage)))% (\(NumberOfResponses))")
                    
                    
                    
                    
                    var  tintColor  = standard_Red
                    if (questionAverage<=33)
                    {
                        tintColor = standard_Red;
                    }
                    else if (questionAverage>33 && questionAverage<=66)
                    {
                        tintColor = standard_Yellow
                    }
                    else
                    {
                        tintColor = standard_Green
                    }
                    
                    _string.addAttribute(NSForegroundColorAttributeName, value: tintColor, range: NSRange(location: 0, length: 4) )
                    
                    mIndexValuesLabel.attributedText = _string
                }
                else
                {
                    mIndexValuesLabel.hidden = true
                }
            }
            else
            {
                mIndexValuesLabel.hidden = true
            }
        }
        
        
        
        
        
        
        if let questionType = details.objectForKey("Type")as? NSString
        {
            if(questionType.isEqualToString(kText))
            {
                
                mQuestionTypeLabel.text = questionType as String;
                mInfoButtonButton.hidden = true
                mInfoButtonImage.hidden = true
                
            }
            else if(questionType.isEqualToString(kOverlayScribble))
            {
                
                mQuestionTypeLabel.text = questionType as String;
                mInfoButtonButton.hidden = false
                mInfoButtonImage.hidden = false
                
                
            }
            else if(questionType.isEqualToString(kFreshScribble))
            {
                
                mQuestionTypeLabel.text = questionType as String;
                mInfoButtonButton.hidden = true
                mInfoButtonImage.hidden =  true
                
                
            }
                
            else if(questionType.isEqualToString(kMRQ))
            {
                
                mQuestionTypeLabel.text = questionType as String;
                mInfoButtonButton.hidden = false
                mInfoButtonImage.hidden = false
                
                
            }
            else if(questionType.isEqualToString(kMCQ))
            {
                
                mQuestionTypeLabel.text = questionType as String;
                mInfoButtonButton.hidden = false
                mInfoButtonImage.hidden =  false
                
                
            }
            else
            {
                
                mQuestionTypeLabel.text = questionType as String;
                mInfoButtonButton.hidden = false
                mInfoButtonImage.hidden =  false
                
            }
            
        }
        
        
        mIndexValuesLabel.frame = CGRectMake(mQuestionNameLabel.frame.origin.x, mQuestionNameLabel.frame.origin.y + mQuestionNameLabel.frame.size.height + 5, self.frame.size.width / 5 , self.frame.size.width / 20)
        
        
        mQuestionTypeLabel.frame = CGRectMake(mIndexValuesLabel.frame.origin.x + mIndexValuesLabel.frame.size.width + 5 , mIndexValuesLabel.frame.origin.y, self.frame.size.width / 2, self.frame.size.width / 20)
        
        
        mInfoButtonImage.frame = CGRectMake(self.frame.size.width - ((self.frame.size.width / 15 ) + 10) ,mQuestionNameLabel.frame.origin.y + mQuestionNameLabel.frame.size.height + 5, self.frame.size.width / 15, self.frame.size.width / 20)
        
        mInfoButtonButton.frame = CGRectMake(self.frame.size.width/2 ,0, self.frame.size.width/2, height)
        
        return height
        
    }
    
    
    func heightForView(text:String, font:UIFont, width:CGFloat) -> CGFloat
    {
        let label:UILabel = UILabel(frame: CGRectMake(0, 0, width, CGFloat.max))
        label.numberOfLines = 0
        label.lineBreakMode = NSLineBreakMode.ByWordWrapping
        label.font = font
        label.text = text
        
        label.sizeToFit()
        return label.frame.height
    }
    
   
    func onInfoButton()
    {
        if delegate().respondsToSelector(#selector(LessonPlanQuestionViewCellDelegate.delegateOnInfoButtonWithDetails(_:withButton:)))
        {
            delegate().delegateOnInfoButtonWithDetails!(currentQuestionDetails, withButton: mInfoButtonImage)
            
            
        }
    }
    
    func checkMarkPressed()
    {
        if isSelected == true
        {
            checkBoxImage.image = UIImage(named:"Unchecked.png");
            isSelected = false
        }
        else
        {
            checkBoxImage.image = UIImage(named:"Checked.png");
            isSelected = true
        }
        
    }
    
}