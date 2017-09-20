//
//  CollaborationMRQCategoryView.swift
//  LearniatTeacher
//
//  Created by Deepak MK on 26/01/17.
//  Copyright © 2017 Mindshift. All rights reserved.
//

import Foundation

@objc protocol CollaborationMRQCategoryViewDelegate
{
    
    @objc optional func delegateDoneButtonPressed()
    
    @objc optional func delegateDoneButtonPressedWithCategoryName(_ category:String)
    
    @objc optional func delegateBackButtonPressed()
    
    
}



class CollaborationMRQCategoryView: UIView
{
    
    var _delgate: AnyObject!
    
    var mCategoryTextView = UITextView()
    
    func setdelegate(_ delegate:AnyObject)
    {
        _delgate = delegate;
    }
    
    func   delegate()->AnyObject
    {
        return _delgate;
    }

    
    
    override init(frame: CGRect) {
        
        super.init(frame:frame)
        
        self.backgroundColor = whiteBackgroundColor

        
        
    }
    
    
    func loadAllSubView()
    {
        let mTopbarImageView = UIImageView(frame: CGRect(x: 0, y: 0,width: self.frame.size.width, height: 44))
        mTopbarImageView.backgroundColor = UIColor.white
        self.addSubview(mTopbarImageView)
        mTopbarImageView.isUserInteractionEnabled = true
        
        let seperatorView = UIView(frame: CGRect(x: 0 ,y: mTopbarImageView.frame.size.height - 1 , width: mTopbarImageView.frame.size.width,height: 1))
        seperatorView.backgroundColor = LineGrayColor;
        mTopbarImageView.addSubview(seperatorView)
        
        
        let  mDoneButton = UIButton(frame: CGRect(x: mTopbarImageView.frame.size.width - 210,  y: 0, width: 200 ,height: mTopbarImageView.frame.size.height))
        mTopbarImageView.addSubview(mDoneButton)
        mDoneButton.addTarget(self, action: #selector(QuestionsView.onDoneButton), for: UIControlEvents.touchUpInside)
        mDoneButton.setTitleColor(standard_Button, for: UIControlState())
        mDoneButton.setTitle("Done", for: UIControlState())
        mDoneButton.contentHorizontalAlignment = UIControlContentHorizontalAlignment.right
        mDoneButton.titleLabel?.font = UIFont(name: helveticaMedium, size: 20)
        
        
        
        
        let  mBackButton = UIButton(frame: CGRect(x: 10,  y: 0, width: 200 ,height: mTopbarImageView.frame.size.height))
        mTopbarImageView.addSubview(mBackButton)
        mBackButton.addTarget(self, action: #selector(QuestionsView.onBackButton), for: UIControlEvents.touchUpInside)
        mBackButton.setTitleColor(standard_Button, for: UIControlState())
        mBackButton.setTitle("Questions", for: UIControlState())
        mBackButton.contentHorizontalAlignment = UIControlContentHorizontalAlignment.left
        mBackButton.titleLabel?.font = UIFont(name: helveticaMedium, size: 20)
        mBackButton.setImage(UIImage(named: "arrow_Blue.png"), for: UIControlState())
        
        
        let mCategoryLabel = UILabel(frame: CGRect(x: 10 , y: mTopbarImageView.frame.origin.y + mTopbarImageView.frame.size.height + 10 , width: 100, height: 30))
        mCategoryLabel.font = UIFont(name:helveticaMedium, size: 20)
        self.addSubview(mCategoryLabel)
        mCategoryLabel.textColor = standard_TextGrey
        mCategoryLabel.textAlignment = .left
        mCategoryLabel.lineBreakMode = .byTruncatingMiddle
        mCategoryLabel.text = "Category :"
        
        
        mCategoryTextView.frame = CGRect(x: mCategoryLabel.frame.origin.x + mCategoryLabel.frame.size.width + 5,y: mCategoryLabel.frame.origin.y - 3,width: self.frame.size.width - (mCategoryLabel.frame.origin.x + mCategoryLabel.frame.size.width + 10), height: self.frame.size.height - 20)
        self.addSubview(mCategoryTextView)
        mCategoryTextView.font =  UIFont(name: helveticaMedium, size: 20);
        mCategoryTextView.textAlignment = .left
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    
    func onDoneButton()
    {
        
        
        mCategoryTextView.resignFirstResponder()
        
        if mCategoryTextView.text.isEmpty
        {
            if delegate().responds(to: #selector(CollaborationMRQCategoryViewDelegate.delegateDoneButtonPressed))
            {
                delegate().delegateDoneButtonPressed!()
            }
        }
        else
        {
            
            if delegate().responds(to: #selector(CollaborationMRQCategoryViewDelegate.delegateDoneButtonPressedWithCategoryName(_:)))
            {
                delegate().delegateDoneButtonPressedWithCategoryName!(mCategoryTextView.text)
            }
        }
        
        
    }
    
    
    
    func onBackButton()
    {
        if delegate().responds(to: #selector(CollaborationMRQCategoryViewDelegate.delegateBackButtonPressed))
        {
            self.removeFromSuperview()
            delegate().delegateBackButtonPressed!()
        }
    }
    

}
