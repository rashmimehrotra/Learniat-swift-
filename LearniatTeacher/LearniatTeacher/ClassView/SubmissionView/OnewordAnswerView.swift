//
//  OnewordAnswerView.swift
//  LearniatTeacher
//
//  Created by Deepak MK on 01/06/16.
//  Copyright © 2016 Mindshift. All rights reserved.
//

import Foundation

@objc protocol OnewordAnswerViewDelegate
{
    
    @objc optional func delegateGraphButtonPressed()
    
    
    
}



class OnewordAnswerView: UIView
{
    
    var questionNamelabel = UILabel()
    
    var wordDictonary = [String: Int]()
    
    var wordCloudLabel = UITextView()
    
    var OldString = ""
    
    var _delgate: AnyObject!
    
    var graphButton = UIButton()
    
    var currentOptionsArray  = NSMutableArray()
    
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
        super.init(frame: frame)
        
        
        
        graphButton.frame = CGRect(x: self.frame.size.width - 130 , y: 10, width: 120, height: 40)
        self.addSubview(graphButton)
        graphButton.backgroundColor = standard_Button
        graphButton.setTitleColor(whiteColor, for: UIControlState())
        graphButton.setTitle("Graph", for: UIControlState())
        graphButton.addTarget(self, action: #selector(OnewordAnswerView.onGraphButton), for: UIControlEvents.touchUpInside)
        
        questionNamelabel.frame =  CGRect(x: 10,y: 10,width: self.frame.size.width - 130 ,height: 40)
        self.addSubview(questionNamelabel)
        questionNamelabel.font = UIFont (name: helveticaRegular, size: 18)
        questionNamelabel.textColor = blackTextColor
        questionNamelabel.textAlignment = .center
        
        
        wordCloudLabel.frame = CGRect(x: 10, y: questionNamelabel.frame.size.height + questionNamelabel.frame.origin.y + 10  , width: self.frame.size.width - 20 , height: self.frame.size.height - (questionNamelabel.frame.size.height + questionNamelabel.frame.origin.y + 20))
        self.addSubview(wordCloudLabel)
        wordCloudLabel.textColor = UIColor.blue
        wordCloudLabel.isEditable = false

    }
    
    func setQuestionName(_ questionName :String, withDetails details:AnyObject)
    {
        questionNamelabel.text = questionName
        
        
        currentOptionsArray.removeAllObjects()
        
        if let options = details.object(forKey: kOptionTagMain)
        {
            if let classCheckingVariable = (options as AnyObject).object(forKey: "Option") as? NSMutableArray
            {
               currentOptionsArray = classCheckingVariable
                
            }
            else
            {
                currentOptionsArray.add((details.object(forKey: kOptionTagMain)! as AnyObject).object(forKey: "Option")!)
                
            }
        }
        
        
    }
    
    func onGraphButton()
    {
        delegate().delegateGraphButtonPressed!()
    }
    
    func setOptionWithString(_ studentWord:String)
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
                let theRange = str.range(of: keyvalue)
                
                
                mutableString.addAttribute(NSFontAttributeName, value: UIFont.systemFont(ofSize: CGFloat(wordFontValue!)) , range: theRange)
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
