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
    
    
    func delegatePollingStartedWithOptions(_ optionsArray:NSMutableArray)
    
    
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
        
        self.backgroundColor = whiteBackgroundColor
        
        mTopImageView.frame = CGRect(x: 0, y: 0, width: self.frame.size.width, height: 50)
        self.addSubview(mTopImageView)
        mTopImageView.backgroundColor = UIColor.white
        mTopImageView.isUserInteractionEnabled = true
        
        
        YPosition =  10
        
        createNewPollButton.frame = CGRect(x: self.frame.size.width - 210, y: 0, width: 200, height: mTopImageView.frame.size.height)
        createNewPollButton.setTitle("Create new poll", for: UIControlState())
        mTopImageView.addSubview(createNewPollButton)
        createNewPollButton.setTitleColor(standard_Green, for: UIControlState())
        createNewPollButton.contentHorizontalAlignment = UIControlContentHorizontalAlignment.right
        createNewPollButton.addTarget(self, action: #selector(SSTeacherPollView.onCreatePollView), for: .touchUpInside)
        
        
        mGraphScrollView.frame = CGRect(x: 0, y: mTopImageView.frame.size.height, width: self.frame.size.width, height: self.frame.size.height - mTopImageView.frame.size.height)
        self.addSubview(mGraphScrollView)
        
    }
    
    
    
    required init?(coder aDecoder: NSCoder)
    {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func onCreatePollView()
    {
        let mPollCreationView = PollingCreationView(frame:CGRect(x: self.frame.size.width,y: 0,width: self.frame.size.width,height: self.frame.size.height))
        self.addSubview(mPollCreationView)
        mPollCreationView.setdelegate(self)
        
        UIView.animate(withDuration: 0.6, animations:
            {
                 mPollCreationView.frame = CGRect(x: 0, y: 0 , width: self.frame.size.width , height: self.frame.size.height)
            },
                                   completion:
            { finished in
                mPollCreationView.loadScaleCells()
        })

    }
    
    
     // MARK: - Polling CreationView functions
    func delegateSendButtonpressedWithSelectedOptionsArray(_ selectedOptions: String, withQuestionName questionName:String)
    {
        
        let options = NSMutableArray()
        options.addObjects(from: selectedOptions.components(separatedBy: ";;;"))
        
         mPollGraphView = PollingGraphView(frame:CGRect(x: 0,y: 0,width: self.frame.size.width,height: self.frame.size.height))
        self.addSubview(mPollGraphView)
        mPollGraphView.setdelegate(self)
        mPollGraphView.tag = pollTagValue
        mPollGraphView.loadGraphViewWithOPtions(options, withQuestion: questionName)
        pollTagValue = pollTagValue + 1
        
        if delegate().responds(to: #selector(SSTeacherPollViewDelegate.delegatePollingStartedWithOptions(_:)))
        {
            delegate().delegatePollingStartedWithOptions(options)
        }
        
    }
    
    
    // MARK: - Polling GraphView functions
    
    func delegateStopButtonPressedWithMultiplierValue(_ multiplier: Int, withOptionsArray optionsArray: NSMutableArray, withOptionsvalue optionsValue: NSMutableArray, withQuestionName questionName: String, withTagValue tag: Int) {
        
//        if let mCompltedView  = self.viewWithTag(tag) as? PollCompletedView
//        {
//            mCompltedView.setGraphDetailsWithQuestionName(questionName,withOPtionsArray:optionsArray,withOptionsValues: optionsValue )
//        }
//        else
//        {
//            
        
            
            let mcomletedView = PollCompletedView(frame:CGRect(x: Xposition,y: YPosition,width: (self.frame.size.width - 40 )/2 ,height: (self.frame.size.width - 40 )/2 ))
            mGraphScrollView.addSubview(mcomletedView)
            mcomletedView.tag = tag
            mcomletedView.setGraphDetailsWithQuestionName(questionName,withOPtionsArray:optionsArray,withOptionsValues: optionsValue, withMultiplier: multiplier)
            mcomletedView.setdelegate(self)
            if Xposition ==  10
            {
                Xposition = Xposition + mcomletedView.frame.size.width + 20
                mGraphScrollView.contentSize = CGSize(width: 0, height: YPosition + mcomletedView.frame.size.height)
                
            }
            else
            {
                Xposition = 10
                YPosition = YPosition + mcomletedView.frame.size.height + 10
                mGraphScrollView.contentSize = CGSize(width: 0, height: YPosition)
                
            }
        
//        }
    }
    
    // MARK: - Poll completed view functions
    
    func delegateOnResendButtonPressedWithOptions(_ optionsArray: NSMutableArray, withQuestionName questionName: String, withTagValue tagValue: Int)
    {
        
        
        mPollGraphView = PollingGraphView(frame:CGRect(x: 0,y: 0,width: self.frame.size.width,height: self.frame.size.height))
        self.addSubview(mPollGraphView)
        mPollGraphView.setdelegate(self)
        mPollGraphView.tag =  tagValue
        mPollGraphView.loadGraphViewWithOPtions(optionsArray, withQuestion: questionName)
        
        
         if delegate().responds(to: #selector(SSTeacherPollViewDelegate.delegatePollingStartedWithOptions(_:)))
         {
            delegate().delegatePollingStartedWithOptions(optionsArray)
        }
    }
    
    
    
    func delegateOnFullScreenButtonPressedWithOPtions(_ optionsArray:NSMutableArray, withQuestionName questionName:String,withTagValue tagValue:Int)
    {
        
    }

    
    
    func didGetStudentPollValue(_ optionValue:String)
    {
        if mPollGraphView != nil
        {
            mPollGraphView.increaseBarWithOption(optionValue)
        }
        
    }
    
}
