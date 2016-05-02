//
//  SSTeacherPollView.swift
//  LearniatTeacher
//
//  Created by Deepak MK on 28/04/16.
//  Copyright © 2016 Mindshift. All rights reserved.
//

import Foundation

@objc protocol SSTeacherPollViewDelegate
{
    
    
    func delegatePollingStartedWithOptions(optionsArray:NSMutableArray)
    
    
}

class SSTeacherPollView: UIView,PollingCreationViewDelegate,PollingGraphViewDelegate,PollCompletedViewDelegate
{
    
    let mTopImageView = UIImageView()
    
    let createNewPollButton = UIButton()
    
    var _delgate: AnyObject!
   
    var mPollGraphView : PollingGraphView!
    
    let graphTagValues  = NSMutableDictionary()
    
    var pollTagValue            = 100000001
    
    var Xposition :CGFloat  = 10
    
    var YPosition:CGFloat   = 10
    
    var mGraphScrollView    = UIScrollView()
    
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
        
        mTopImageView.frame = CGRectMake(0, 0, self.frame.size.width, 50)
        self.addSubview(mTopImageView)
        mTopImageView.backgroundColor = UIColor.whiteColor()
        mTopImageView.userInteractionEnabled = true
        
        
        YPosition =  10
        
        createNewPollButton.frame = CGRectMake(self.frame.size.width - 210, 0, 200, mTopImageView.frame.size.height)
        createNewPollButton.setTitle("Create new poll", forState: .Normal)
        mTopImageView.addSubview(createNewPollButton)
        createNewPollButton.setTitleColor(standard_Green, forState: .Normal)
        createNewPollButton.contentHorizontalAlignment = UIControlContentHorizontalAlignment.Right
        createNewPollButton.addTarget(self, action: #selector(SSTeacherPollView.onCreatePollView), forControlEvents: .TouchUpInside)
        
        
        mGraphScrollView.frame = CGRectMake(0, mTopImageView.frame.size.height, self.frame.size.width, self.frame.size.height - mTopImageView.frame.size.height)
        self.addSubview(mGraphScrollView)
        
    }
    
    
    
    required init?(coder aDecoder: NSCoder)
    {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func onCreatePollView()
    {
        let mPollCreationView = PollingCreationView(frame:CGRectMake(self.frame.size.width,0,self.frame.size.width,self.frame.size.height))
        self.addSubview(mPollCreationView)
        mPollCreationView.setdelegate(self)
        
        UIView.animateWithDuration(0.6, animations:
            {
                 mPollCreationView.frame = CGRectMake(0, 0 , self.frame.size.width , self.frame.size.height)
            },
                                   completion:
            { finished in
                mPollCreationView.loadScaleCells()
        })

    }
    
    
     // MARK: - Polling CreationView functions
    func delegateSendButtonpressedWithSelectedOptionsArray(selectedOptions: String, withQuestionName questionName:String)
    {
        
        let options = NSMutableArray()
        options.addObjectsFromArray(selectedOptions.componentsSeparatedByString(";;;"))
        
         mPollGraphView = PollingGraphView(frame:CGRectMake(0,0,self.frame.size.width,self.frame.size.height))
        self.addSubview(mPollGraphView)
        mPollGraphView.setdelegate(self)
        mPollGraphView.tag = pollTagValue
        mPollGraphView.loadGraphViewWithOPtions(options, withQuestion: questionName)
        pollTagValue = pollTagValue + 1
        
        if delegate().respondsToSelector(#selector(SSTeacherPollViewDelegate.delegatePollingStartedWithOptions(_:)))
        {
            delegate().delegatePollingStartedWithOptions(options)
        }
        
    }
    
    
    // MARK: - Polling GraphView functions
    
    func delegateStopButtonPressedWithMultiplierValue(multiplier: Int, withOptionsArray optionsArray: NSMutableArray, withOptionsvalue optionsValue: NSMutableArray, withQuestionName questionName: String, withTagValue tag: Int) {
        
//        if let mCompltedView  = self.viewWithTag(tag) as? PollCompletedView
//        {
//            mCompltedView.setGraphDetailsWithQuestionName(questionName,withOPtionsArray:optionsArray,withOptionsValues: optionsValue )
//        }
//        else
//        {
//            
        
            
            let mcomletedView = PollCompletedView(frame:CGRectMake(Xposition,YPosition,(self.frame.size.width - 40 )/2 ,(self.frame.size.width - 40 )/2 ))
            mGraphScrollView.addSubview(mcomletedView)
            mcomletedView.tag = tag
            mcomletedView.setGraphDetailsWithQuestionName(questionName,withOPtionsArray:optionsArray,withOptionsValues: optionsValue, withMultiplier: multiplier)
            mcomletedView.setdelegate(self)
            if Xposition ==  10
            {
                Xposition = Xposition + mcomletedView.frame.size.width + 20
                mGraphScrollView.contentSize = CGSizeMake(0, YPosition + mcomletedView.frame.size.height)
                
            }
            else
            {
                Xposition = 10
                YPosition = YPosition + mcomletedView.frame.size.height + 10
                mGraphScrollView.contentSize = CGSizeMake(0, YPosition)
                
            }
        
//        }
    }
    
    // MARK: - Poll completed view functions
    
    func delegateOnResendButtonPressedWithOptions(optionsArray: NSMutableArray, withQuestionName questionName: String, withTagValue tagValue: Int)
    {
        
        
        mPollGraphView = PollingGraphView(frame:CGRectMake(0,0,self.frame.size.width,self.frame.size.height))
        self.addSubview(mPollGraphView)
        mPollGraphView.setdelegate(self)
        mPollGraphView.tag =  tagValue
        mPollGraphView.loadGraphViewWithOPtions(optionsArray, withQuestion: questionName)
        
        
         if delegate().respondsToSelector(#selector(SSTeacherPollViewDelegate.delegatePollingStartedWithOptions(_:)))
         {
            delegate().delegatePollingStartedWithOptions(optionsArray)
        }
    }
    
    
    func didGetStudentPollValue(optionValue:String)
    {
        if mPollGraphView != nil
        {
            mPollGraphView.increaseBarWithOption(optionValue)
        }
        
    }
    
}