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
    
    @objc optional func delegateTextViewTextChanged(_ chnagedText:String)
    
    
}



class CustomTextView: UIView,UITextViewDelegate
{
    
    
    let mQuestionTextView       = SZTextView()
    
    var currentPlaceHolder      = ""
    
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
        
        self.layer.borderColor = topicsLineColor.cgColor
        self.layer.borderWidth = 1
        self.layer.cornerRadius = 5
        
        
        
        mQuestionTextView.frame = CGRect(x: 10, y: 10, width: self.frame.size.width - 20, height: self.frame.size.height - 20)
        self.addSubview(mQuestionTextView)
        mQuestionTextView.delegate = self
        mQuestionTextView.font =  UIFont(name: helveticaMedium, size: 18);
        mQuestionTextView.textAlignment = .left
        mQuestionTextView.placeholder = ""
        mQuestionTextView.placeholderTextColor = lightGrayColor
        mQuestionTextView.textColor = blackTextColor
        
        
        mQuestionTextView.selectedTextRange = mQuestionTextView.textRange(from: mQuestionTextView.beginningOfDocument, to: mQuestionTextView.beginningOfDocument)
        
        
        // By Ujjval
        // Allow textfield editing tools e.g. tap to take the cursor on any word, double tap on a word to highlight it, delete word, etc.
        // ==========================================
        
        //        let mStartButton = UIButton(frame:CGRect(x: 0, y: 0, width: self.frame.size.width,height: self.frame.size.height))
        //        self.addSubview(mStartButton)
        //        mStartButton.addTarget(self, action: #selector(CustomTextView.onSelfButton), for: .touchUpInside)
        
        // ==========================================

    }
    
    
    func setPlaceHolder(_ _placeHolder:String, withStartSting _startString:String)
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
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        // Combine the textView text and the replacement text to
        // create the updated text string
        let currentText:NSString = textView.text as NSString
        
        if currentText as String == currentPlaceHolder
        {
            // By Ujjval
            // ==========================================
            
            if text != UIPasteboard.general.string {
                delegate().delegateTextViewTextChanged!("")
            }
            else {
                delegate().delegateTextViewTextChanged!(text)
            }
            
            // ==========================================
        }
        else
        {
            delegate().delegateTextViewTextChanged!(currentText as String)
        }
        
        
        let updatedText = currentText.replacingCharacters(in: range, with:text)
        
        // If updated text view will be empty, add the placeholder
        // and set the cursor to the beginning of the text view
        if updatedText.isEmpty
        {
            
            textView.text = currentPlaceHolder
            textView.textColor = UIColor.lightGray
            
            textView.selectedTextRange = textView.textRange(from: textView.beginningOfDocument, to: textView.beginningOfDocument)
            
            return false
        }
            
            // Else if the text view's placeholder is showing and the
            // length of the replacement string is greater than 0, clear
            // the text view and set its color to black to prepare for
            // the user's entry
        else if textView.textColor == UIColor.lightGray && !text.isEmpty
        {
            textView.text = nil
            textView.textColor = blackTextColor
        }
        
        return true
    }
    
    
    
       
}


extension UITextView {
    open override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool
    {
//        return false
        
        // By Ujjval
        // ==========================================
        
        return true
        
        // ==========================================
    }
}
