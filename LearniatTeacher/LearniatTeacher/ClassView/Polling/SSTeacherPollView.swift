//
//  SSTeacherPollView.swift
//  LearniatTeacher
//
//  Created by Deepak MK on 28/04/16.
//  Copyright © 2016 Mindshift. All rights reserved.
//

import Foundation
class SSTeacherPollView: UIView,PollingCreationViewDelegate,PollingGraphViewDelegate
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
        
        if graphTagValues.objectForKey(questionName) == nil
        {
            graphTagValues.setObject(pollTagValue, forKey: questionName)
            pollTagValue = pollTagValue + 1
        }
        
        let options = NSMutableArray()
        options.addObjectsFromArray(selectedOptions.componentsSeparatedByString(";;;"))
        
         mPollGraphView = PollingGraphView(frame:CGRectMake(0,0,self.frame.size.width,self.frame.size.height))
        self.addSubview(mPollGraphView)
        mPollGraphView.setdelegate(self)
        mPollGraphView.loadGraphViewWithOPtions(options, withQuestion: questionName)
        
        
    }
    
    
    // MARK: - Polling GraphView functions
    
    func delegateStopButtonPressedWithMultiplierValue(multiplier: Int, withOptionsArray optionsArray: NSMutableArray, withOptionsvalue optionsValue: NSMutableArray, withQuestionName questionName: String)
    {
        
        if graphTagValues.objectForKey(questionName) != nil
        {
            if let questionTag = graphTagValues.objectForKey(questionName) as? Int
            {
                
                if let mCompltedView  = self.viewWithTag(questionTag) as? PollCompletedView
                {
                    mCompltedView.setGraphDetailsWithQuestionName(questionName)
                }
                else
                {
                    
                    
                    let remainngValue = (self.frame.size.width - 40 )/2
                    
                    let mcomletedView = PollCompletedView(frame:CGRectMake(Xposition,YPosition,remainngValue / 1.01 ,remainngValue / 1.06 ))
                    mGraphScrollView.addSubview(mcomletedView)
                    mcomletedView.tag = questionTag
                    mcomletedView.setGraphDetailsWithQuestionName(questionName)
                    
                   
                    
                    
                    if Xposition ==  10
                    {
                       Xposition = Xposition + mcomletedView.frame.size.width + 20
                       
                    }
                    else
                    {
                        Xposition = 10
                        YPosition = YPosition + mcomletedView.frame.size.height + 10

                    }

                    mGraphScrollView.contentSize = CGSizeMake(0, YPosition)
                    
                    
                }
            }
            
            
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