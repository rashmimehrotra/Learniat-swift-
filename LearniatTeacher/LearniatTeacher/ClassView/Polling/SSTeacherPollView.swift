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
        
        
        createNewPollButton.frame = CGRectMake(self.frame.size.width - 210, 0, 200, mTopImageView.frame.size.height)
        createNewPollButton.setTitle("Create new poll", forState: .Normal)
        mTopImageView.addSubview(createNewPollButton)
        createNewPollButton.setTitleColor(standard_Green, forState: .Normal)
        createNewPollButton.contentHorizontalAlignment = UIControlContentHorizontalAlignment.Right
        createNewPollButton.addTarget(self, action: #selector(SSTeacherPollView.onCreatePollView), forControlEvents: .TouchUpInside)
        
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
//            if let questionTag = graphTagValues.objectForKey(questionName) as? String
//            {
//                
//                if let mCompltedView  = self.viewWithTag(Int(questionTag)!) as? PollCompletedView
//                {
//                    
//                }
//                else
//                {
//                    
//                }
//            }
            
            
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