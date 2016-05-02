//
//  PollingCreationView.swift
//  LearniatTeacher
//
//  Created by Deepak MK on 28/04/16.
//  Copyright © 2016 Mindshift. All rights reserved.
//

import Foundation

@objc protocol PollingCreationViewDelegate
{
    
    
    func delegateSendButtonpressedWithSelectedOptionsArray(selectedOptions: String, withQuestionName questionName:String)
    

}
class PollingCreationView: UIView,PollViewCellDelegate
{
    
    let mTopImageView = UIImageView()
    
    let mStartButton = UIButton()
    
    let mCancelButton = UIButton()
    
    
    var mQuestionTextView       : CustomTextView!
    
    var mLikerScaleScrollView      = UIScrollView()
    
    var _delgate: AnyObject!
    
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
        
        self.backgroundColor = lightGrayTopBar
        
       
        mTopImageView.frame = CGRectMake(0, 0, self.frame.size.width, 50)
        self.addSubview(mTopImageView)
        mTopImageView.backgroundColor = UIColor.whiteColor()
        mTopImageView.userInteractionEnabled = true
        
        mCancelButton.frame = CGRectMake(10, 0, 200, mTopImageView.frame.size.height)
        mCancelButton.setTitle("Cancel", forState: .Normal)
        mTopImageView.addSubview(mCancelButton)
        mCancelButton.setTitleColor(standard_Button, forState: .Normal)
        mCancelButton.contentHorizontalAlignment = UIControlContentHorizontalAlignment.Left
        mCancelButton.addTarget(self, action: #selector(PollingCreationView.onCancelButton), forControlEvents: .TouchUpInside)
        
        
        mStartButton.frame = CGRectMake(self.frame.size.width - 210, 0, 200, mTopImageView.frame.size.height)
        mStartButton.setTitle("Start", forState: .Normal)
        mTopImageView.addSubview(mStartButton)
        mStartButton.setTitleColor(standard_Button, forState: .Normal)
        mStartButton.contentHorizontalAlignment = UIControlContentHorizontalAlignment.Right
        mStartButton.addTarget(self, action: #selector(PollingCreationView.onSendButton), forControlEvents: .TouchUpInside)
        
        
    }
    
    
    
    func loadScaleCells()
    {
        
        
        
      
        
        
        
        let screenName = UILabel(frame: CGRectMake((mTopImageView.frame.size.width - 300)/2, 0, 300, mTopImageView.frame.size.height))
        mTopImageView.addSubview(screenName)
        screenName.text = "Create new polls"
        screenName.textColor = blackTextColor
        screenName.textAlignment = .Center
        screenName.font =  UIFont(name: helveticaMedium, size: 20);
        
        
        mQuestionTextView = CustomTextView(frame:CGRectMake(10, mTopImageView.frame.size.height + 10 , self.frame.size.width - 20, mTopImageView.frame.size.height))
        mQuestionTextView.setdelegate(self)
        mQuestionTextView.setPlaceHolder("Write question", withStartSting: "Question:")
        self.addSubview(mQuestionTextView)
        
        
        mLikerScaleScrollView.frame = CGRectMake(10, (self.frame.size.height - 250) / 2, self.frame.size.width - 20, 250)
        self.addSubview(mLikerScaleScrollView)
        
        
        var  positionXvalue :CGFloat = 10;
        for index in 0..<5
        {
            let cellView = PollViewCell(frame:CGRectMake(positionXvalue,10, 175, 270))
            mLikerScaleScrollView.addSubview(cellView);
            cellView.backgroundColor = pollCellBackgroundColor
            cellView.setdelegate(self);
            cellView.setSelectedState(kNotSelected)
            
            positionXvalue=positionXvalue+cellView.frame.size.width+20;
            switch (index)
            {
            case 0:
                cellView.mMainOptionlabel.text = "Agree"
                cellView.setPollOptions("strongly agree;;;Agree;;;Not Sure;;;Disagree;;;strongly disagree");
                break;
                
            case 1:
                cellView.mMainOptionlabel.text = "Likely"
                cellView.setPollOptions("Highly Likely;;;Likely;;;Not Sure;;;Unlikely;;;Highly Unlikely");
                break;
            case 2:
                cellView.mMainOptionlabel.text = "Satisfied"
                cellView.setPollOptions("Not at all satisfied;;;Slightly satisfied;;;Neutral;;;very satisfied;;;Extremely satisfied");
                break;
                
            case 3:
                cellView.mMainOptionlabel.text = "Interested"
                cellView.setPollOptions("Not at all Interested;;;Some what Interested;;;Neutral;;;Not very Interested;;;Very Interested");
                break;
                
            case 4:
                cellView.mMainOptionlabel.text = "Happy"
                cellView.setPollOptions("Very Happy;;;Some what Happy;;;Neutral;;;Not very happy;;;Not at all happy");
                break;
            default:
                break;
            }
        }
        mLikerScaleScrollView.contentSize = CGSizeMake(positionXvalue, 0)

       
    }
    
    
    
    required init?(coder aDecoder: NSCoder)
    {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func onCancelButton()
    {
        self.removeFromSuperview()
    }
    
    func onSendButton()
    {
        if mQuestionTextView.getTextOfCurrentTextView() != ""
        {
            let subViews = mLikerScaleScrollView.subviews.flatMap{ $0 as? PollViewCell }
            for mQuerySubView in subViews
            {
                if mQuerySubView.isKindOfClass(PollViewCell)
                {
                    print(mQuerySubView.getPollSubcellState())
                    
                   if mQuerySubView.getPollSubcellState() == kSelected
                   {
                    
                    
                    
                        if delegate().respondsToSelector(#selector(PollingCreationViewDelegate.delegateSendButtonpressedWithSelectedOptionsArray(_:withQuestionName:)))
                        {
                            
                            let optionsValue = mQuerySubView.getPollOptions()
                            SSTeacherMessageHandler.sharedMessageHandler.sendLikertPollMessageToRoom(SSTeacherDataSource.sharedDataSource.currentLiveSessionId, withSelectedOption: optionsValue, withQuestionName: mQuestionTextView.getTextOfCurrentTextView())
                            
                            delegate().delegateSendButtonpressedWithSelectedOptionsArray(optionsValue, withQuestionName: mQuestionTextView.getTextOfCurrentTextView())
                            
                            
                            self.removeFromSuperview()
                            break
                        }
                    }
                }
            }
            
            
        }
        
       
    }
    
    func delegateIgnoreButtonPressedWithOptionCell(selectedCell: PollViewCell!) {
        
        let subViews = mLikerScaleScrollView.subviews.flatMap{ $0 as? PollViewCell }
        for mQuerySubView in subViews
        {
            if mQuerySubView.isKindOfClass(PollViewCell)
            {
                if selectedCell != mQuerySubView
                {
                    mQuerySubView.setSelectedState(kNotSelected)
                    mQuerySubView.backgroundColor = pollCellBackgroundColor
                }

            }
        }
        
        
        
    }
    
    func delegateSelectButtonPressedWithOptionCell(selectedCell: PollViewCell!) {
        
        let subViews = mLikerScaleScrollView.subviews.flatMap{ $0 as? PollViewCell }
        for mQuerySubView in subViews
        {
            if mQuerySubView.isKindOfClass(PollViewCell)
            {
                if selectedCell != mQuerySubView
                {
                    mQuerySubView.setSelectedState(kNotSelected)
                    mQuerySubView.backgroundColor = pollCellBackgroundColor
                }
               
            }
        }
        
        
    }
    
    
}