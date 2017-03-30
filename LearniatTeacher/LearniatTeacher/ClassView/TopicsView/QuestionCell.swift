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
    
    
    @objc optional func delegateSendQuestionDetails(_ questionDetails:AnyObject)
    
    @objc optional func delegateOnInfoButtonWithDetails(_ questionDetails:AnyObject, withButton infoButton:UIButton)
    
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
        
       

        mQuestionNameLabel.frame = CGRect(x: 10 , y: 10 , width: self.frame.size.width - 60 , height: self.frame.size.height)
        mQuestionNameLabel.font = UIFont(name:helveticaMedium, size: 18)
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
        
        
        mQuestionTypeLabel.font = UIFont(name:helveticaBold, size: 16)
        self.addSubview(mQuestionTypeLabel)
        mQuestionTypeLabel.textColor = UIColor(red: 160.0/255.0, green: 160.0/255.0, blue: 160.0/255.0, alpha: 1)   //333333
        mQuestionTypeLabel.textAlignment = .center
        mQuestionTypeLabel.lineBreakMode = .byTruncatingMiddle
        
        self.addSubview(mSendButton)
        mSendButton.addTarget(self, action: #selector(QuestionCell.onSendButton), for: UIControlEvents.touchUpInside)
        mSendButton.setTitleColor(standard_Button, for: UIControlState())
        mSendButton.setTitle("Send", for: UIControlState())
        mSendButton.contentHorizontalAlignment = UIControlContentHorizontalAlignment.right
        mSendButton.titleLabel?.font = UIFont(name: helveticaMedium, size: 18)
        
        
        
        self.addSubview(mInfoButtonButton)
        mInfoButtonButton.addTarget(self, action: #selector(QuestionCell.onInfoButton), for: UIControlEvents.touchUpInside)
        mInfoButtonButton.setImage(UIImage(named: "infoButton.png"), for: UIControlState())
        mInfoButtonButton.contentHorizontalAlignment = UIControlContentHorizontalAlignment.right
        
        
        mDemoLabel = UILabel(frame: CGRect(x: 10 , y: 0 , width: 100, height: 10))
        mDemoLabel.font = UIFont(name:helveticaMedium, size: 10)
        self.addSubview(mDemoLabel)
        mDemoLabel.textColor = standard_Green
        mDemoLabel.textAlignment = .left
        mDemoLabel.lineBreakMode = .byTruncatingMiddle
        mDemoLabel.text = "Simulation"

    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func getCurrentCellHeightWithDetails(_ details:AnyObject, WIthCountValue questionCout:Int) -> CGFloat
    {
        
        var height :CGFloat = 100
        
        
        
        
        currentQuestionDetails = details
        
        
        
        if let topicId = currentQuestionDetails.object(forKey: "Id")as? String
        {
            if SSTeacherDataSource.sharedDataSource.mDemoQuestionsIdArray.count>0
            {
                if SSTeacherDataSource.sharedDataSource.mDemoQuestionsIdArray.contains(topicId)
                {
                    if UserDefaults.standard.bool(forKey: "isSimulateMode") == true
                    {
                        mDemoLabel.isHidden = false
                    }
                    else
                    {
                        mDemoLabel.isHidden = true
                    }
                }
                else
                {
                    mDemoLabel.isHidden = true
                }
                
                
            }
            else
            {
                mDemoLabel.isHidden = true
            }
            
           
        
        
        
        if let questionName = details.object(forKey: "Name")as? String
        {
            mQuestionNameLabel.text = "\(questionCout). \(questionName) (\(topicId))"
            
            height = heightForView(questionName, font: mQuestionNameLabel.font, width: mQuestionNameLabel.frame.size.width)
            
            mQuestionNameLabel.frame = CGRect(x: mQuestionNameLabel.frame.origin.x, y: mQuestionNameLabel.frame.origin.y, width: mQuestionNameLabel.frame.size.width, height: height)
        }
        else
        {
            mQuestionNameLabel.text = "\(questionCout)."
            
            height = heightForView(mQuestionNameLabel.text!, font: mQuestionNameLabel.font, width: mQuestionNameLabel.frame.size.width)
            
            mQuestionNameLabel.frame = CGRect(x: mQuestionNameLabel.frame.origin.x, y: mQuestionNameLabel.frame.origin.y + 10, width: mQuestionNameLabel.frame.size.width, height: height)
        }
        
        height = height + 80
        
        
        let seperatorView = UIView(frame: CGRect(x: 5 ,y: height - 1 , width: self.frame.size.width - 10,height: 1))
        seperatorView.backgroundColor = topicsLineColor;
        self.addSubview(seperatorView)
        
        
        }
        
        if let QuestonAvgScore = details.object(forKey: "QuestonAvgScore")as? NSString
        {
           
            
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
                
                mQuestionTypeLabel.text = questionType as String ;
                mInfoButtonButton.isHidden = true
                
            }
            else if(questionType.isEqual(to: kOverlayScribble))
            {
            
                mQuestionTypeLabel.text = questionType as String;
                mInfoButtonButton.isHidden = false
            
            
            }
            else if(questionType.isEqual(to: kFreshScribble))
            {
            
                mQuestionTypeLabel.text = questionType as String;
                mInfoButtonButton.isHidden = true
            
            
            }
           
            else if(questionType.isEqual(to: kMRQ))
            {
            
                mQuestionTypeLabel.text = questionType as String;
                mInfoButtonButton.isHidden = false
            
            
            }
            else if(questionType.isEqual(to: kMCQ))
            {
            
                mQuestionTypeLabel.text = questionType as String;
                 mInfoButtonButton.isHidden = false
            
            
            }
            else
            {
            
                mQuestionTypeLabel.text = questionType as String;
                 mInfoButtonButton.isHidden = false
            
            }
            
        }
       
        
        mIndexValuesLabel.frame = CGRect(x: mQuestionNameLabel.frame.origin.x, y: mQuestionNameLabel.frame.origin.y + mQuestionNameLabel.frame.size.height + 25, width: self.frame.size.width / 5 , height: self.frame.size.width / 20)
        
        
        mQuestionTypeLabel.frame = CGRect(x: mIndexValuesLabel.frame.origin.x + mIndexValuesLabel.frame.size.width + 15 , y: mIndexValuesLabel.frame.origin.y, width: self.frame.size.width / 2, height: self.frame.size.width / 20)
        
        
         mDemoLabel.frame = CGRect(x: 10 , y: mQuestionNameLabel.frame.origin.y + mQuestionNameLabel.frame.size.height + 5 , width: 100, height: 10)
        
        
         mSendButton.frame = CGRect(x: self.frame.size.width - ((self.frame.size.width / 4.5 ) + 10) , y: mIndexValuesLabel.frame.origin.y, width: self.frame.size.width / 4.5, height: self.frame.size.width / 20)
        
        
        mInfoButtonButton.frame = CGRect(x: self.frame.size.width - ((self.frame.size.width / 15) + 10), y: 5, width: self.frame.size.width / 15,height: self.frame.size.width / 15)
        
        
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
    
    func onSendButton()
    {
        if delegate().responds(to: #selector(QuestionCellDelegate.delegateSendQuestionDetails(_:)))
        {
            delegate().delegateSendQuestionDetails!(currentQuestionDetails)
             
            
        }
    }
    
    func onInfoButton()
    {
        if delegate().responds(to: #selector(QuestionCellDelegate.delegateOnInfoButtonWithDetails(_:withButton:)))
        {
            delegate().delegateOnInfoButtonWithDetails!(currentQuestionDetails, withButton: mInfoButtonButton)
            
            
        }
    }
    
}
