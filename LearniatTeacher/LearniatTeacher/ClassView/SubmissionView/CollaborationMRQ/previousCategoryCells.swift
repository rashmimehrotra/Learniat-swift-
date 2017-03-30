//
//  previousCategoryCells.swift
//  LearniatTeacher
//
//  Created by Deepak MK on 18/03/17.
//  Copyright © 2017 Mindshift. All rights reserved.
//

import UIKit

@objc protocol previousCategoryCellsDelegate
{
    
    @objc optional func delegateCategorySelectedWithDetails(details:AnyObject)
    
    
}


class previousCategoryCells: UIView {

    var mCategoryDetails :AnyObject!
    
    var mCategoryLabel = UILabel()
    
    var mTopicLabel = UILabel()
    
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
        
        
        mCategoryLabel.frame = CGRect(x: 10 , y: 10 , width: self.frame.size.width - 20 , height: 20)
        mCategoryLabel.font = UIFont(name:helveticaRegular, size: 16)
        self.addSubview(mCategoryLabel)
        mCategoryLabel.textColor = blackTextColor
        mCategoryLabel.textAlignment = .left
        mCategoryLabel.lineBreakMode = .byTruncatingMiddle
        mCategoryLabel.numberOfLines  = 20
        mCategoryLabel.text = ""
        
        mTopicLabel.frame = CGRect(x: 10 , y: mCategoryLabel.frame.origin.y + mCategoryLabel.frame.size.height + 5 , width: self.frame.size.width - 10 , height: 20)
        mTopicLabel.font = UIFont(name:helveticaRegular, size: 12)
        self.addSubview(mTopicLabel)
        mTopicLabel.textColor = standard_TextGrey
        mTopicLabel.textAlignment = .left
        mTopicLabel.lineBreakMode = .byTruncatingMiddle
        mTopicLabel.numberOfLines  = 20
        mTopicLabel.text = ""

        
        let longGesture = UITapGestureRecognizer(target: self, action: #selector(previousCategoryCells.CellPressed)) //Long function will call when user long press on button.
        self.addGestureRecognizer(longGesture)
        longGesture.numberOfTapsRequired = 1

        
    }
    
    required init?(coder aDecoder: NSCoder)
    {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    
    
    func heightForView(_ text:String, font:UIFont, width:CGFloat) -> CGFloat
    {
        let label:UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: width, height: CGFloat.greatestFiniteMagnitude))
        label.numberOfLines = 0
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.font = font
        label.text = text
        
        label.sizeToFit()
        
        if label.frame.height < 20
        {
            return 20
        }
        
        return label.frame.height
    }
    
    
    func getHeightFromCategoryDetails(details:AnyObject)-> CGFloat
    {
        var cellHeight : CGFloat = 30
        
        mCategoryDetails = details
        
        if let categroyName = details.object(forKey: "CategoryTitle") as? String
        {
             mCategoryLabel.text = "Category :- ".appending(categroyName)
        }
        
       
        
       
        mCategoryLabel.frame = CGRect(x: mCategoryLabel.frame.origin.x, y: mCategoryLabel.frame.origin.y, width: mCategoryLabel.frame.size.width, height: heightForView(mCategoryLabel.text!, font: mCategoryLabel.font, width: mCategoryLabel.frame.size.width))
        
        if let topicName = details.object(forKey: "TopicName") as? String
        {
            mTopicLabel.text = "/ Topic :- ".appending(topicName)
           
        }
        
        if let subTopicName = details.object(forKey: "SubTopicName") as? String
        {
            mTopicLabel.text = mTopicLabel.text?.appending(" / subTopic:- ").appending(subTopicName)
        }
        
        if let SubjectName = details.object(forKey: "SubTopicName") as? String
        {
            mTopicLabel.text = mTopicLabel.text?.appending("/ Subject:- ").appending(SubjectName)
        }
        
        mTopicLabel.frame = CGRect(x: mTopicLabel.frame.origin.x, y: mCategoryLabel.frame.origin.y + mCategoryLabel.frame.size.height , width: mCategoryLabel.frame.size.width, height: heightForView(mTopicLabel.text!, font: mTopicLabel.font, width: mTopicLabel.frame.size.width) + 20)
        
        
        
        cellHeight = mTopicLabel.frame.origin.y + mTopicLabel.frame.size.height + 5
        
        return cellHeight
        
    }
    
    func CellPressed()
    {
        delegate().delegateCategorySelectedWithDetails!(details: mCategoryDetails)
    }
    

}
