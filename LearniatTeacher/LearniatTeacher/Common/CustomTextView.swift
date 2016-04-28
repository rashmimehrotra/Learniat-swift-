//
//  CustomTextView.swift
//  LearniatTeacher
//
//  Created by Deepak MK on 28/04/16.
//  Copyright © 2016 Mindshift. All rights reserved.
//

import Foundation
class CustomTextView: UIView,UITextViewDelegate
{
    
    

    let mTopicText              = UILabel()
    
    let mQuestionTextView       = UITextView()
    
    
    var currentPlaceHolder      = ""
    
    var StartText               = ""
    
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
        
        
       
       self.backgroundColor = UIColor.whiteColor()
        self.layer.borderColor = lightGrayColor.CGColor
        self.layer.borderWidth = 1
        self.layer.cornerRadius = 5
        
        mTopicText.frame = CGRectMake(10,10 , 100, self.frame.size.height - 20)
        self.addSubview(mTopicText)
        mTopicText.text = StartText
        mTopicText.textColor = blackTextColor
        mTopicText.font =  UIFont(name: helveticaRegular, size: 20);
        
        
        mQuestionTextView.frame = CGRectMake(mTopicText.frame.origin.x + mTopicText.frame.size.width + 10, 10, self.frame.size.width - (mTopicText.frame.origin.x + mTopicText.frame.size.width + 20), self.frame.size.height - 20)
        self.addSubview(mQuestionTextView)
        mQuestionTextView.delegate = self
        mQuestionTextView.font =  UIFont(name: helveticaRegular, size: 20);
        mQuestionTextView.textAlignment = .Left
        mQuestionTextView.text = currentPlaceHolder
        mQuestionTextView.scrollsToTop = true
        
        let mStartButton = UIButton(frame:CGRectMake(0, 0, self.frame.size.width,self.frame.size.height))
        self.addSubview(mStartButton)
        mStartButton.addTarget(self, action: #selector(CustomTextView.onSelfButton), forControlEvents: .TouchUpInside)

    }
    
    
    func setPlaceHolder(_placeHolder:String, withStartSting _startString:String)
    {
        currentPlaceHolder = _placeHolder
        
        mQuestionTextView.textColor = UIColor.lightGrayColor()
        mQuestionTextView.text = _placeHolder
       
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
    
    func textViewDidBeginEditing(textView: UITextView)
    {
        if textView.textColor == UIColor.lightGrayColor()
        {
            textView.text = ""
            textView.textColor = UIColor.blackColor()
        }
    }
    func textViewDidEndEditing(textView: UITextView)
    {
        if textView.text.isEmpty
        {
            textView.text = currentPlaceHolder
            textView.textColor = UIColor.lightGrayColor()
        }
    }
    
    func textViewDidChange(textView: UITextView)
    {
        if textView.text.isEmpty
        {
            textView.text = currentPlaceHolder
            textView.textColor = UIColor.lightGrayColor()
        }
        else
        {
            textView.textColor = blackTextColor
        }
    }
    
    func getTextOfCurrentTextView()->String
    {
        
        if mQuestionTextView.text.isEmpty || mQuestionTextView.text == currentPlaceHolder
        {
            mQuestionTextView.text = ""
        }
        
        
        return mQuestionTextView.text
    }
}