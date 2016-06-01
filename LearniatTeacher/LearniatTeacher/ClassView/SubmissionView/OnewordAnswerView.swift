//
//  OnewordAnswerView.swift
//  LearniatTeacher
//
//  Created by Deepak MK on 01/06/16.
//  Copyright © 2016 Mindshift. All rights reserved.
//

import Foundation
class OnewordAnswerView: UIView
{
    
    var questionNamelabel = UILabel()
    
    var wordDictonary = [String: Int]()
    
    var wordCloudLabel = UITextView()
    
    var OldString = ""
    
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
        super.init(frame: frame)
        
        
        questionNamelabel.frame =  CGRectMake(10,10,self.frame.size.width - 50 ,40)
        self.addSubview(questionNamelabel)
        questionNamelabel.font = UIFont (name: helveticaMedium, size: 18)
        questionNamelabel.textColor = blackTextColor
        questionNamelabel.textAlignment = .Center
        

        
        
        wordCloudLabel.frame = CGRectMake(10, questionNamelabel.frame.size.height + questionNamelabel.frame.origin.y + 10  , self.frame.size.width - 20 , self.frame.size.height - (questionNamelabel.frame.size.height + questionNamelabel.frame.origin.y + 20))
        self.addSubview(wordCloudLabel)
        wordCloudLabel.textColor = UIColor.blueColor()
        wordCloudLabel.editable = false

    }
    
    func setQuestionName(questionName :String)
    {
        questionNamelabel.text = questionName
    }
    
    func setOptionWithString(studentWord:String)
    {
        
        var wordFont = wordDictonary[studentWord]
        
        if wordFont != nil
        {
            wordFont = wordFont! + 2
            
            wordDictonary[studentWord] = wordFont
        }
        else
        {
            wordDictonary[studentWord] = 16
            OldString = "\(OldString) \(studentWord)"
        }
        var mutableString = NSMutableAttributedString()
        
        let keysArray = [String] (wordDictonary.keys)
        
        mutableString = NSMutableAttributedString(string: OldString)
        
        for index  in  0 ..< keysArray.count
        {
            let keyvalue = keysArray[index]
            
            
            let wordFontValue = wordDictonary[keyvalue]
            
            if wordFontValue != nil
            {
                let str = NSString(string: OldString)
                let theRange = str.rangeOfString(keyvalue)
                
                
                mutableString.addAttribute(NSFontAttributeName, value: UIFont.systemFontOfSize(CGFloat(wordFontValue!)) , range: theRange)
            }
            
            
            
        }
        
        wordCloudLabel.attributedText = mutableString
        wordCloudLabel.textColor = topbarColor
        
    }
    
    
    func questionCleared()
    {
        var mutableString = NSMutableAttributedString()
         mutableString = NSMutableAttributedString(string: "")
        wordCloudLabel.attributedText = mutableString
        wordDictonary.removeAll()
        OldString = ""
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
}