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
    
    
    
    @objc optional func delegateOnInfoButtonWithDetails(_ questionDetails:AnyObject, withButton infoButton:UIImageView)
    
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
        
        
        m_checkBoxButton = UIButton(frame:CGRect(x: 0, y: 0, width: self.frame.size.width/2 ,height: self.frame.size.height));
        self.addSubview(m_checkBoxButton);
       
        checkBoxImage.frame = CGRect(x: 10  , y: 10,width: 20,height: 20)
        checkBoxImage.image = UIImage(named:"Checked.png");
        self.addSubview(checkBoxImage);
        m_checkBoxButton.addTarget(self, action: #selector(LessonPlanQuestionViewCell.checkMarkPressed), for: UIControlEvents.touchUpInside)

        
        
        mQuestionNameLabel.frame = CGRect(x: checkBoxImage.frame.size.width + checkBoxImage.frame.origin.x + 10 , y: 10 , width: self.frame.size.width - (checkBoxImage.frame.size.width + checkBoxImage.frame.origin.x + 15) , height: self.frame.size.height)
        mQuestionNameLabel.font = UIFont(name:helveticaRegular, size: 18)
        self.addSubview(mQuestionNameLabel)
        mQuestionNameLabel.textColor = blackTextColor
        mQuestionNameLabel.textAlignment = .left
        mQuestionNameLabel.lineBreakMode = .byTruncatingMiddle
        mQuestionNameLabel.numberOfLines  = 20
        
        mIndexValuesLabel.font = UIFont(name:helveticaRegular, size: 16)
        self.addSubview(mIndexValuesLabel)
        mIndexValuesLabel.textColor = blackTextColor
        mIndexValuesLabel.textAlignment = .left
        mIndexValuesLabel.lineBreakMode = .byTruncatingMiddle
        
        
        mQuestionTypeLabel.font = UIFont(name:helveticaRegular, size: 16)
        self.addSubview(mQuestionTypeLabel)
        mQuestionTypeLabel.textColor = UIColor(red: 160.0/255.0, green: 160.0/255.0, blue: 160.0/255.0, alpha: 1)   //333333
        mQuestionTypeLabel.textAlignment = .center
        mQuestionTypeLabel.lineBreakMode = .byTruncatingMiddle
        
        
        self.addSubview(mInfoButtonImage)
        mInfoButtonImage.image = UIImage(named: "infoButton.png")
        mInfoButtonImage.contentMode = .scaleAspectFill
        
        self.addSubview(mInfoButtonButton)
        mInfoButtonButton.addTarget(self, action: #selector(LessonPlanQuestionViewCell.onInfoButton), for: UIControlEvents.touchUpInside)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func getCurrentCellHeightWithDetails(_ details:AnyObject, WIthCountValue questionCout:Int) -> CGFloat
    {
        
        var height :CGFloat = 100
        
        
        
        
        
        currentQuestionDetails = details
        
        if var questionName = details.object(forKey: "Name")as? String
        {
             questionName = questionName.capitalized
            
            mQuestionNameLabel.text = "\(questionCout). \(questionName)"
            
            height = heightForView(questionName, font: mQuestionNameLabel.font, width: mQuestionNameLabel.frame.size.width)
            
            mQuestionNameLabel.frame = CGRect(x: mQuestionNameLabel.frame.origin.x, y: mQuestionNameLabel.frame.origin.y, width: mQuestionNameLabel.frame.size.width, height: height)
        }
        else
        {
            mQuestionNameLabel.text = "\(questionCout)."
            
            height = heightForView(mQuestionNameLabel.text!, font: mQuestionNameLabel.font, width: mQuestionNameLabel.frame.size.width)
            
            mQuestionNameLabel.frame = CGRect(x: mQuestionNameLabel.frame.origin.x, y: mQuestionNameLabel.frame.origin.y + 10, width: mQuestionNameLabel.frame.size.width, height: height)
        }
        
        height = height + 60
        
        
        let seperatorView = UIView(frame: CGRect(x: 5 ,y: height - 1 , width: self.frame.size.width - 10,height: 1))
        seperatorView.backgroundColor = topicsLineColor;
        self.addSubview(seperatorView)
        
        
        
        
        if let QuestonAvgScore = details.object(forKey: "QuestonAvgScore")as? NSString
        {
//            QuestonAvgScore = String(format: "%02d", QuestonAvgScore.intValue)
            
            let questionAverage = QuestonAvgScore.floatValue * 100.0
            
            if let NumberOfResponses = details.object(forKey: "NumberOfResponses")as? NSString
            {
                
                if NumberOfResponses.intValue > 0
                {
                    mIndexValuesLabel.isHidden = false
                    
                    
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
                    mIndexValuesLabel.isHidden = true
                }
            }
            else
            {
                mIndexValuesLabel.isHidden = true
            }
        }
        
        
        
        
        
        
        if let questionType = details.object(forKey: "Type")as? NSString
        {
            if(questionType.isEqual(to: kText))
            {
                
                mQuestionTypeLabel.text = questionType as String;
                mInfoButtonButton.isHidden = true
                mInfoButtonImage.isHidden = true
                
            }
            else if(questionType.isEqual(to: kOverlayScribble))
            {
                
                mQuestionTypeLabel.text = questionType as String;
                mInfoButtonButton.isHidden = false
                mInfoButtonImage.isHidden = false
                
                
            }
            else if(questionType.isEqual(to: kFreshScribble))
            {
                
                mQuestionTypeLabel.text = questionType as String;
                mInfoButtonButton.isHidden = true
                mInfoButtonImage.isHidden =  true
                
                
            }
                
            else if(questionType.isEqual(to: kMRQ))
            {
                
                mQuestionTypeLabel.text = questionType as String;
                mInfoButtonButton.isHidden = false
                mInfoButtonImage.isHidden = false
                
                
            }
            else if(questionType.isEqual(to: kMCQ))
            {
                
                mQuestionTypeLabel.text = questionType as String;
                mInfoButtonButton.isHidden = false
                mInfoButtonImage.isHidden =  false
                
                
            }
            else
            {
                
                mQuestionTypeLabel.text = questionType as String;
                mInfoButtonButton.isHidden = false
                mInfoButtonImage.isHidden =  false
                
            }
            
        }
        
        
        mIndexValuesLabel.frame = CGRect(x: mQuestionNameLabel.frame.origin.x, y: mQuestionNameLabel.frame.origin.y + mQuestionNameLabel.frame.size.height + 5, width: self.frame.size.width / 5 , height: self.frame.size.width / 20)
        
        
        mQuestionTypeLabel.frame = CGRect(x: mIndexValuesLabel.frame.origin.x + mIndexValuesLabel.frame.size.width + 5 , y: mIndexValuesLabel.frame.origin.y, width: self.frame.size.width / 2, height: self.frame.size.width / 20)
        
        
        mInfoButtonImage.frame = CGRect(x: self.frame.size.width - ((self.frame.size.width / 15 ) + 10) ,y: mQuestionNameLabel.frame.origin.y + mQuestionNameLabel.frame.size.height + 5, width: self.frame.size.width / 15, height: self.frame.size.width / 20)
        
        mInfoButtonButton.frame = CGRect(x: self.frame.size.width/2 ,y: 0, width: self.frame.size.width/2, height: height)
        
        return height
        
    }
    
    
    func heightForView(_ text:String, font:UIFont, width:CGFloat) -> CGFloat
    {
        let label:UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: width, height: CGFloat.greatestFiniteMagnitude))
        label.numberOfLines = 0
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.font = font
        label.text = text
        
        label.sizeToFit()
        return label.frame.height
    }
    
   
    func onInfoButton()
    {
        if delegate().responds(to: #selector(LessonPlanQuestionViewCellDelegate.delegateOnInfoButtonWithDetails(_:withButton:)))
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
