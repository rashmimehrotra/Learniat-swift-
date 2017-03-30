//
//  CustomTextView.swift
//  LearniatTeacher
//
//  Created by Deepak MK on 28/04/16.
//  Copyright © 2016 Mindshift. All rights reserved.
//

import Foundation
class CustomTextView: UIView,UITextFieldDelegate
{
    
    

    let mTopicText              = UILabel()
    
    let mQuestionTextView       = UITextField()
    
    
    
    var StartText               = ""
    
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
        
        
       
       self.backgroundColor = UIColor.white
        self.layer.borderColor = lightGrayColor.cgColor
        self.layer.borderWidth = 1
        self.layer.cornerRadius = 5
        
        mTopicText.frame = CGRect(x: 10,y: 10 , width: 80, height: self.frame.size.height - 20)
        self.addSubview(mTopicText)
        mTopicText.text = StartText
        mTopicText.textColor = blackTextColor
        mTopicText.font =  UIFont(name: helveticaRegular, size: 16);
        
        
        mQuestionTextView.frame = CGRect(x: mTopicText.frame.origin.x + mTopicText.frame.size.width + 10, y: 10, width: self.frame.size.width - (mTopicText.frame.origin.x + mTopicText.frame.size.width + 20), height: self.frame.size.height - 20)
        self.addSubview(mQuestionTextView)
        mQuestionTextView.delegate = self
        mQuestionTextView.font =  UIFont(name: helveticaRegular, size: 16);
        mQuestionTextView.textAlignment = .left
        mQuestionTextView.minimumFontSize = 0.4
        
        let mStartButton = UIButton(frame:CGRect(x: 0, y: 0, width: self.frame.size.width,height: self.frame.size.height))
        self.addSubview(mStartButton)
        mStartButton.addTarget(self, action: #selector(CustomTextView.onSelfButton), for: .touchUpInside)

    }
    
    
    func setPlaceHolder(_ _placeHolder:String, withStartSting _startString:String)
    {
        
        mQuestionTextView.placeholder = _placeHolder
       
        StartText = _startString
        mTopicText.text = StartText
        
    }
    
    
    func onSelfButton()
    {
       mQuestionTextView.becomeFirstResponder()
    }
    
    required init?(coder aDecoder: NSCoder)
    {
        fatalError("init(coder:) has not been implemented")
    }
    

    
    func getTextOfCurrentTextView()->String
    {
        
        if mQuestionTextView.text!.isEmpty
        {
            mQuestionTextView.text = ""
        }
        
        
        return mQuestionTextView.text!
    }
    
    func isBorderRequired(isReuired:Bool)
    {
        if isReuired == true
        {
            self.layer.borderColor = lightGrayColor.cgColor
            self.layer.borderWidth = 1
            self.layer.cornerRadius = 5
        }
        else
        {
            self.layer.borderColor = UIColor.clear.cgColor
            self.layer.borderWidth = 0
            self.layer.cornerRadius = 5
        }
        
    }
}
