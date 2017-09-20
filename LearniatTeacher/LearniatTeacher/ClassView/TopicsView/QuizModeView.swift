//
//  QuizModeView.swift
//  LearniatTeacher
//
//  Created by Deepak MK on 01/06/16.
//  Copyright © 2016 Mindshift. All rights reserved.
//

import Foundation
import UIKit
class QuizModeView: UIView
{
    
    
    var currentQuestionsArray = NSMutableArray()
    
    var mQuestionsView          = UIScrollView()
    
    override init(frame: CGRect)
    {
        super.init(frame: frame)
        self.backgroundColor = standard_Green
        
        
        
        let mTopbarImageView = UIImageView(frame: CGRect(x: 0, y: 0,width: self.frame.size.width, height: 44))
        mTopbarImageView.backgroundColor = UIColor.white
        self.addSubview(mTopbarImageView)
        mTopbarImageView.isUserInteractionEnabled = true
        
        
        
        
        let seperatorView = UIView(frame: CGRect(x: 0 ,y: mTopbarImageView.frame.size.height - 1 , width: mTopbarImageView.frame.size.width,height: 1))
        seperatorView.backgroundColor = LineGrayColor;
        mTopbarImageView.addSubview(seperatorView)
        
        let  mDoneButton = UIButton(frame: CGRect(x: mTopbarImageView.frame.size.width - 210,  y: 0, width: 200 ,height: mTopbarImageView.frame.size.height))
        mTopbarImageView.addSubview(mDoneButton)
        mDoneButton.addTarget(self, action: #selector(QuizModeView.onSendButton), for: UIControlEvents.touchUpInside)
        mDoneButton.setTitleColor(standard_Button, for: UIControlState())
        mDoneButton.setTitle("Send", for: UIControlState())
        mDoneButton.contentHorizontalAlignment = UIControlContentHorizontalAlignment.right
        mDoneButton.titleLabel?.font = UIFont(name: helveticaMedium, size: 20)
        
        
        
        
        let  mBackButton = UIButton(frame: CGRect(x: 10,  y: 0, width: 200 ,height: mTopbarImageView.frame.size.height))
        mTopbarImageView.addSubview(mBackButton)
        mBackButton.addTarget(self, action: #selector(QuizModeView.onBackButton), for: UIControlEvents.touchUpInside)
        mBackButton.setTitleColor(standard_Button, for: UIControlState())
        mBackButton.setTitle("Back", for: UIControlState())
        mBackButton.contentHorizontalAlignment = UIControlContentHorizontalAlignment.left
        mBackButton.titleLabel?.font = UIFont(name: helveticaMedium, size: 20)

        
        
        
        mQuestionsView.frame = CGRect(x: 0, y: mTopbarImageView.frame.size.height , width: self.frame.size.width, height: self.frame.size.height - mTopbarImageView.frame.size.height)
        self.addSubview(mQuestionsView)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func onBackButton()
    {
        self.removeFromSuperview()
    }
    
    
    func onSendButton()
    {
        
//        let questionLogIdList = NSMutableArray()
//        
//        let subViews = mQuestionsView.subviews.flatMap{ $0 as? QuizmodeCell }
//        
//        for mQuerySubView in subViews
//        {
//            if mQuerySubView.isKindOfClass(QuizmodeCell)
//            {
//                if mQuerySubView.isSelected == true
//                {
////                    questionLogIdList.addObject(<#T##anObject: AnyObject##AnyObject#>)
//                }
//            }
//        }
//
//        
        
        
        self.removeFromSuperview()
    }
    
    func setQuestionWithDetails(_ questionsArray:NSMutableArray)
    {
        
        currentQuestionsArray.removeAllObjects()
        
        var postionY:CGFloat = 10
        
        for index in 0 ..< questionsArray.count
        {
            let questionDict  = questionsArray.object(at: index)
            
            if let questionType = (questionDict as AnyObject).object(forKey: kQuestionType)as? NSString
            {
                if questionType as String == kMRQ || questionType as String == kMCQ
                {
                    let mQuizCell = QuizmodeCell(frame:CGRect(x: 10,y: postionY , width: self.frame.size.width - 20 , height: 60 ))
                    mQuestionsView.addSubview(mQuizCell)
                    postionY = postionY + mQuizCell.frame.size.height + 10
                    mQuizCell.setQuestionDict(questionDict as AnyObject)
                }
            }
            
            
        }
        
        mQuestionsView.contentSize = CGSize(width: 0, height: postionY)
        
    }
    
}
