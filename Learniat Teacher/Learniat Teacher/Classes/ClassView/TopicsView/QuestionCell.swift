//
//  QuestionCell.swift
//  Learniat Teacher
//
//  Created by Deepak MK on 24/03/16.
//  Copyright © 2016 Mindshift. All rights reserved.
//

import Foundation
class QuestionCell: UIView
{
    var _delgate: AnyObject!
    
    
    var mQuestionNameLabel :UILabel  = UILabel()
    
    var mIndexValuesLabel  :UILabel   = UILabel()
    
    var infoButtonButton   :UIButton  = UIButton()
    
    var mQuestionTypeLabel :UILabel   = UILabel()
    
    
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
        
       

        mQuestionNameLabel.frame = CGRectMake(10 , 5 , self.frame.size.width - 50 , self.frame.size.height)
        mQuestionNameLabel.font = UIFont(name:helveticaRegular, size: 18)
        self.addSubview(mQuestionNameLabel)
        mQuestionNameLabel.textColor = blackTextColor
        mQuestionNameLabel.textAlignment = .Left
        mQuestionNameLabel.lineBreakMode = .ByTruncatingMiddle
        mQuestionNameLabel.numberOfLines  = 20
        
        

    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func getCurrentCellHeightWithDetails(details:AnyObject, WIthCountValue questionCout:Int) -> CGFloat
    {
        
        var height :CGFloat = 100
        
        

        
        if let questionName = details.objectForKey("Name")as? String
        {
            mQuestionNameLabel.text = "\(questionCout).\(questionName)"
            
            height = heightForView(questionName, font: mQuestionNameLabel.font, width: mQuestionNameLabel.frame.size.width)
            
            mQuestionNameLabel.frame = CGRectMake(mQuestionNameLabel.frame.origin.x, mQuestionNameLabel.frame.origin.y, mQuestionNameLabel.frame.size.width, height)
        }
        else
        {
            mQuestionNameLabel.text = "\(questionCout)."
            
            height = heightForView(mQuestionNameLabel.text!, font: mQuestionNameLabel.font, width: mQuestionNameLabel.frame.size.width)
            
            mQuestionNameLabel.frame = CGRectMake(mQuestionNameLabel.frame.origin.x, mQuestionNameLabel.frame.origin.y, mQuestionNameLabel.frame.size.width, height)
        }
        
        height = height + 60
        
        
        let seperatorView = UIView(frame: CGRectMake(0 ,height - 1 , self.frame.size.width,1))
        seperatorView.backgroundColor = topicsLineColor;
        self.addSubview(seperatorView)
        
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
    
}