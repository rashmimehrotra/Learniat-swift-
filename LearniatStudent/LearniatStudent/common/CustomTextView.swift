//
//  CustomTextView.swift
//  LearniatTeacher
//
//  Created by Deepak MK on 28/04/16.
//  Copyright © 2016 Mindshift. All rights reserved.
//

import Foundation

@objc protocol CustomTextViewDelegate
{
    
    optional func delegateTextViewTextChanged(chnagedText:String)
    
    
}



class CustomTextView: UIView,UITextViewDelegate
{
    
    
    let mQuestionTextView       = SZTextView()
    
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
        
        self.layer.borderColor = topicsLineColor.CGColor
        self.layer.borderWidth = 1
        self.layer.cornerRadius = 5
        
        
        
        mQuestionTextView.frame = CGRectMake(10, 10, self.frame.size.width - 20, self.frame.size.height - 20)
        self.addSubview(mQuestionTextView)
        mQuestionTextView.delegate = self
        mQuestionTextView.font =  UIFont(name: helveticaMedium, size: 18);
        mQuestionTextView.textAlignment = .Left
        mQuestionTextView.placeholder = ""
        mQuestionTextView.placeholderTextColor = lightGrayColor
        mQuestionTextView.textColor = blackTextColor
        
        
        mQuestionTextView.selectedTextRange = mQuestionTextView.textRangeFromPosition(mQuestionTextView.beginningOfDocument, toPosition: mQuestionTextView.beginningOfDocument)
        
        
        let mStartButton = UIButton(frame:CGRectMake(0, 0, self.frame.size.width,self.frame.size.height))
        self.addSubview(mStartButton)
        mStartButton.addTarget(self, action: #selector(CustomTextView.onSelfButton), forControlEvents: .TouchUpInside)

    }
    
    
    func setPlaceHolder(_placeHolder:String, withStartSting _startString:String)
    {
        
//        mQuestionTextView.text = _placeHolder
        currentPlaceHolder = _placeHolder
       mQuestionTextView.placeholder = currentPlaceHolder
        StartText = _startString
        
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
        
        if mQuestionTextView.text!.isEmpty || mQuestionTextView.text == currentPlaceHolder
        {
            mQuestionTextView.text = ""
           
        }
        
        mQuestionTextView.resignFirstResponder()
        
        return mQuestionTextView.text!
    }
    
//    
//    func textViewDidBeginEditing(textView: UITextView) {
//        if textView.textColor == UIColor.lightGrayColor() {
//            textView.text = nil
//            textView.textColor = blackTextColor
//        }
//    }
//    
//    func textViewDidEndEditing(textView: UITextView) {
//        if textView.text.isEmpty {
//            textView.text = currentPlaceHolder
//            textView.textColor = UIColor.lightGrayColor()
//        }
//    }
//   
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        
        // Combine the textView text and the replacement text to
        // create the updated text string
        let currentText:NSString = textView.text
        
        if currentText == currentPlaceHolder
        {
            delegate().delegateTextViewTextChanged!("")
        }
        else
        {
            delegate().delegateTextViewTextChanged!(currentText as String)
        }
        
        
        let updatedText = currentText.stringByReplacingCharactersInRange(range, withString:text)
        
        // If updated text view will be empty, add the placeholder
        // and set the cursor to the beginning of the text view
        if updatedText.isEmpty
        {
            
            textView.text = currentPlaceHolder
            textView.textColor = UIColor.lightGrayColor()
            
            textView.selectedTextRange = textView.textRangeFromPosition(textView.beginningOfDocument, toPosition: textView.beginningOfDocument)
            
            return false
        }
            
            // Else if the text view's placeholder is showing and the
            // length of the replacement string is greater than 0, clear
            // the text view and set its color to black to prepare for
            // the user's entry
        else if textView.textColor == UIColor.lightGrayColor() && !text.isEmpty
        {
            textView.text = nil
            textView.textColor = blackTextColor
        }
        
        return true
    }
    
}