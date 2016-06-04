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
        
        
        
        let mTopbarImageView = UIImageView(frame: CGRectMake(0, 0,self.frame.size.width, 44))
        mTopbarImageView.backgroundColor = UIColor.whiteColor()
        self.addSubview(mTopbarImageView)
        mTopbarImageView.userInteractionEnabled = true
        
        
        
        
        let seperatorView = UIView(frame: CGRectMake(0 ,mTopbarImageView.frame.size.height - 1 , mTopbarImageView.frame.size.width,1))
        seperatorView.backgroundColor = LineGrayColor;
        mTopbarImageView.addSubview(seperatorView)
        
        let  mDoneButton = UIButton(frame: CGRectMake(mTopbarImageView.frame.size.width - 210,  0, 200 ,mTopbarImageView.frame.size.height))
        mTopbarImageView.addSubview(mDoneButton)
        mDoneButton.addTarget(self, action: #selector(QuizModeView.onSendButton), forControlEvents: UIControlEvents.TouchUpInside)
        mDoneButton.setTitleColor(standard_Button, forState: .Normal)
        mDoneButton.setTitle("Send", forState: .Normal)
        mDoneButton.contentHorizontalAlignment = UIControlContentHorizontalAlignment.Right
        mDoneButton.titleLabel?.font = UIFont(name: helveticaMedium, size: 20)
        
        
        
        
        let  mBackButton = UIButton(frame: CGRectMake(10,  0, 200 ,mTopbarImageView.frame.size.height))
        mTopbarImageView.addSubview(mBackButton)
        mBackButton.addTarget(self, action: #selector(QuizModeView.onBackButton), forControlEvents: UIControlEvents.TouchUpInside)
        mBackButton.setTitleColor(standard_Button, forState: .Normal)
        mBackButton.setTitle("Back", forState: .Normal)
        mBackButton.contentHorizontalAlignment = UIControlContentHorizontalAlignment.Left
        mBackButton.titleLabel?.font = UIFont(name: helveticaMedium, size: 20)

        
        
        
        mQuestionsView.frame = CGRectMake(0, mTopbarImageView.frame.size.height , self.frame.size.width, self.frame.size.height - mTopbarImageView.frame.size.height)
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
    
    func setQuestionWithDetails(questionsArray:NSMutableArray)
    {
        
        currentQuestionsArray.removeAllObjects()
        
        var postionY:CGFloat = 10
        
        for index in 0 ..< questionsArray.count
        {
            let questionDict  = questionsArray.objectAtIndex(index)
            
            if let questionType = questionDict.objectForKey("Type")as? NSString
            {
                if questionType == kMRQ || questionType == kMCQ
                {
                    let mQuizCell = QuizmodeCell(frame:CGRectMake(10,postionY , self.frame.size.width - 20 , 60 ))
                    mQuestionsView.addSubview(mQuizCell)
                    postionY = postionY + mQuizCell.frame.size.height + 10
                    mQuizCell.setQuestionDict(questionDict)
                }
            }
            
            
        }
        
        mQuestionsView.contentSize = CGSizeMake(0, postionY)
        
    }
    
}