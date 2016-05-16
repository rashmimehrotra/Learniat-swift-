//
//  QuestionCell.swift
//  Learniat Teacher
//
//  Created by Deepak MK on 24/03/16.
//  Copyright © 2016 Mindshift. All rights reserved.
//

import Foundation

@objc protocol QuestionCellDelegate
{
    
    
    optional func delegateSendQuestionDetails(questionDetails:AnyObject)
    
    optional func delegateOnInfoButtonWithDetails(questionDetails:AnyObject, withButton infoButton:UIButton)
    
}


class QuestionCell: UIView
{
    var _delgate: AnyObject!
    
    
    var mQuestionNameLabel  :UILabel  = UILabel()
    
    var mIndexValuesLabel   :UILabel   = UILabel()
    
    var mInfoButtonButton    :UIButton  = UIButton()
    
    var mQuestionTypeLabel  :UILabel   = UILabel()
   
    var mSendButton         :UIButton  = UIButton()
    
    var currentQuestionDetails :AnyObject!
    
    var mDemoLabel          = UILabel()
    
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
        
       

        mQuestionNameLabel.frame = CGRectMake(10 , 10 , self.frame.size.width - 60 , self.frame.size.height)
        mQuestionNameLabel.font = UIFont(name:helveticaMedium, size: 18)
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
        
        
        mQuestionTypeLabel.font = UIFont(name:helveticaBold, size: 16)
        self.addSubview(mQuestionTypeLabel)
        mQuestionTypeLabel.textColor = UIColor(red: 160.0/255.0, green: 160.0/255.0, blue: 160.0/255.0, alpha: 1)   //333333
        mQuestionTypeLabel.textAlignment = .Center
        mQuestionTypeLabel.lineBreakMode = .ByTruncatingMiddle
        
        self.addSubview(mSendButton)
        mSendButton.addTarget(self, action: #selector(QuestionCell.onSendButton), forControlEvents: UIControlEvents.TouchUpInside)
        mSendButton.setTitleColor(standard_Button, forState: .Normal)
        mSendButton.setTitle("Send", forState: .Normal)
        mSendButton.contentHorizontalAlignment = UIControlContentHorizontalAlignment.Right
        mSendButton.titleLabel?.font = UIFont(name: helveticaMedium, size: 18)
        
        
        
        self.addSubview(mInfoButtonButton)
        mInfoButtonButton.addTarget(self, action: #selector(QuestionCell.onInfoButton), forControlEvents: UIControlEvents.TouchUpInside)
        mInfoButtonButton.setImage(UIImage(named: "infoButton.png"), forState: .Normal)
        mInfoButtonButton.contentHorizontalAlignment = UIControlContentHorizontalAlignment.Right
        
        
        mDemoLabel = UILabel(frame: CGRectMake(10 , 0 , 100, 10))
        mDemoLabel.font = UIFont(name:helveticaMedium, size: 10)
        self.addSubview(mDemoLabel)
        mDemoLabel.textColor = standard_Green
        mDemoLabel.textAlignment = .Left
        mDemoLabel.lineBreakMode = .ByTruncatingMiddle
        mDemoLabel.text = "Simulation"

    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func getCurrentCellHeightWithDetails(details:AnyObject, WIthCountValue questionCout:Int) -> CGFloat
    {
        
        var height :CGFloat = 100
        
        
        
        
        currentQuestionDetails = details
        
        
        
        if let topicId = currentQuestionDetails.objectForKey("Id")as? String
        {
            if SSTeacherDataSource.sharedDataSource.mDemoQuestionsIdArray.count>0
            {
                if SSTeacherDataSource.sharedDataSource.mDemoQuestionsIdArray.containsObject(topicId)
                {
                    if NSUserDefaults.standardUserDefaults().boolForKey("isSimulateMode") == true
                    {
                        mDemoLabel.hidden = false
                    }
                    else
                    {
                        mDemoLabel.hidden = true
                    }
                }
                else
                {
                    mDemoLabel.hidden = true
                }
                
                
            }
            else
            {
                mDemoLabel.hidden = true
            }
            
           
        
        
        
        if let questionName = details.objectForKey("Name")as? String
        {
            mQuestionNameLabel.text = "\(questionCout). \(questionName) (\(topicId))"
            
            height = heightForView(questionName, font: mQuestionNameLabel.font, width: mQuestionNameLabel.frame.size.width)
            
            mQuestionNameLabel.frame = CGRectMake(mQuestionNameLabel.frame.origin.x, mQuestionNameLabel.frame.origin.y, mQuestionNameLabel.frame.size.width, height)
        }
        else
        {
            mQuestionNameLabel.text = "\(questionCout)."
            
            height = heightForView(mQuestionNameLabel.text!, font: mQuestionNameLabel.font, width: mQuestionNameLabel.frame.size.width)
            
            mQuestionNameLabel.frame = CGRectMake(mQuestionNameLabel.frame.origin.x, mQuestionNameLabel.frame.origin.y + 10, mQuestionNameLabel.frame.size.width, height)
        }
        
        height = height + 80
        
        
        let seperatorView = UIView(frame: CGRectMake(5 ,height - 1 , self.frame.size.width - 10,1))
        seperatorView.backgroundColor = topicsLineColor;
        self.addSubview(seperatorView)
        
        
        }
        
        if let QuestonAvgScore = details.objectForKey("QuestonAvgScore")as? NSString
        {
           
            
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
                
                mQuestionTypeLabel.text = questionType as String ;
                mInfoButtonButton.hidden = true
                
            }
            else if(questionType.isEqualToString(kOverlayScribble))
            {
            
                mQuestionTypeLabel.text = questionType as String;
                mInfoButtonButton.hidden = false
            
            
            }
            else if(questionType.isEqualToString(kFreshScribble))
            {
            
                mQuestionTypeLabel.text = questionType as String;
                mInfoButtonButton.hidden = true
            
            
            }
           
            else if(questionType.isEqualToString(kMRQ))
            {
            
                mQuestionTypeLabel.text = questionType as String;
                mInfoButtonButton.hidden = false
            
            
            }
            else if(questionType.isEqualToString(kMCQ))
            {
            
                mQuestionTypeLabel.text = questionType as String;
                 mInfoButtonButton.hidden = false
            
            
            }
            else
            {
            
                mQuestionTypeLabel.text = questionType as String;
                 mInfoButtonButton.hidden = false
            
            }
            
        }
       
        
        mIndexValuesLabel.frame = CGRectMake(mQuestionNameLabel.frame.origin.x, mQuestionNameLabel.frame.origin.y + mQuestionNameLabel.frame.size.height + 25, self.frame.size.width / 5 , self.frame.size.width / 20)
        
        
        mQuestionTypeLabel.frame = CGRectMake(mIndexValuesLabel.frame.origin.x + mIndexValuesLabel.frame.size.width + 15 , mIndexValuesLabel.frame.origin.y, self.frame.size.width / 2, self.frame.size.width / 20)
        
        
         mDemoLabel.frame = CGRectMake(10 , mQuestionNameLabel.frame.origin.y + mQuestionNameLabel.frame.size.height + 5 , 100, 10)
        
        
         mSendButton.frame = CGRectMake(self.frame.size.width - ((self.frame.size.width / 4.5 ) + 10) , mIndexValuesLabel.frame.origin.y, self.frame.size.width / 4.5, self.frame.size.width / 20)
        
        
        mInfoButtonButton.frame = CGRectMake(self.frame.size.width - ((self.frame.size.width / 15) + 10), 5, self.frame.size.width / 15,self.frame.size.width / 15)
        
        
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
    
    func onSendButton()
    {
        if delegate().respondsToSelector(#selector(QuestionCellDelegate.delegateSendQuestionDetails(_:)))
        {
            delegate().delegateSendQuestionDetails!(currentQuestionDetails)
             
            
        }
    }
    
    func onInfoButton()
    {
        if delegate().respondsToSelector(#selector(QuestionCellDelegate.delegateOnInfoButtonWithDetails(_:withButton:)))
        {
            delegate().delegateOnInfoButtonWithDetails!(currentQuestionDetails, withButton: mInfoButtonButton)
            
            
        }
    }
    
}