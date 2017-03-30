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
    
    
    func delegateSendButtonpressedWithSelectedOptionsArray(_ selectedOptions: String, withQuestionName questionName:String)
    

}
class PollingCreationView: UIView,PollViewCellDelegate
{
    
    let mTopImageView = UIImageView()
    
    let mStartButton = UIButton()
    
    let mCancelButton = UIButton()
    
    
    var mQuestionTextView       : CustomTextView!
    
    var mLikerScaleScrollView      = UIScrollView()
    
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
        
        self.backgroundColor = lightGrayTopBar
        
       
        mTopImageView.frame = CGRect(x: 0, y: 0, width: self.frame.size.width, height: 50)
        self.addSubview(mTopImageView)
        mTopImageView.backgroundColor = UIColor.white
        mTopImageView.isUserInteractionEnabled = true
        
        mCancelButton.frame = CGRect(x: 10, y: 0, width: 200, height: mTopImageView.frame.size.height)
        mCancelButton.setTitle("Cancel", for: UIControlState())
        mTopImageView.addSubview(mCancelButton)
        mCancelButton.setTitleColor(standard_Button, for: UIControlState())
        mCancelButton.contentHorizontalAlignment = UIControlContentHorizontalAlignment.left
        mCancelButton.addTarget(self, action: #selector(PollingCreationView.onCancelButton), for: .touchUpInside)
        
        
        mStartButton.frame = CGRect(x: self.frame.size.width - 210, y: 0, width: 200, height: mTopImageView.frame.size.height)
        mStartButton.setTitle("Start", for: UIControlState())
        mTopImageView.addSubview(mStartButton)
        mStartButton.setTitleColor(standard_Button, for: UIControlState())
        mStartButton.contentHorizontalAlignment = UIControlContentHorizontalAlignment.right
        mStartButton.addTarget(self, action: #selector(PollingCreationView.onSendButton), for: .touchUpInside)
        
        
    }
    
    
    
    func loadScaleCells()
    {
        
        
        
      
        
        
        
        let screenName = UILabel(frame: CGRect(x: (mTopImageView.frame.size.width - 300)/2, y: 0, width: 300, height: mTopImageView.frame.size.height))
        mTopImageView.addSubview(screenName)
        screenName.text = "Create new polls"
        screenName.textColor = blackTextColor
        screenName.textAlignment = .center
        screenName.font =  UIFont(name: helveticaMedium, size: 20);
        
        
        mQuestionTextView = CustomTextView(frame:CGRect(x: 10, y: mTopImageView.frame.size.height + 10 , width: self.frame.size.width - 20, height: mTopImageView.frame.size.height))
        mQuestionTextView.setdelegate(self)
        mQuestionTextView.setPlaceHolder("Write question", withStartSting: "Question:")
        self.addSubview(mQuestionTextView)
        
        
        mLikerScaleScrollView.frame = CGRect(x: 10, y: (self.frame.size.height - 250) / 2, width: self.frame.size.width - 20, height: 250)
        self.addSubview(mLikerScaleScrollView)
        
        
        var  positionXvalue :CGFloat = 10;
        for index in 0..<5
        {
            let cellView = PollViewCell(frame:CGRect(x: positionXvalue,y: 10, width: 175, height: 270))
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
        mLikerScaleScrollView.contentSize = CGSize(width: positionXvalue, height: 0)

       
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
                if mQuerySubView.isKind(of: PollViewCell.self)
                {
                    
                   if mQuerySubView.getPollSubcellState() == kSelected
                   {
                    
                    
                    
                        if delegate().responds(to: #selector(PollingCreationViewDelegate.delegateSendButtonpressedWithSelectedOptionsArray(_:withQuestionName:)))
                        {
                            
                            let optionsValue = mQuerySubView.getPollOptions()
                            SSTeacherMessageHandler.sharedMessageHandler.sendLikertPollMessageToRoom(SSTeacherDataSource.sharedDataSource.currentLiveSessionId, withSelectedOption: optionsValue!, withQuestionName: mQuestionTextView.getTextOfCurrentTextView())
                            
                            delegate().delegateSendButtonpressedWithSelectedOptionsArray(optionsValue!, withQuestionName: mQuestionTextView.getTextOfCurrentTextView())
                            
                            
                            self.removeFromSuperview()
                            break
                        }
                    }
                }
            }
            
            
        }
        
       
    }
    
    func delegateIgnoreButtonPressed(withOptionCell selectedCell: PollViewCell!) {
        
        let subViews = mLikerScaleScrollView.subviews.flatMap{ $0 as? PollViewCell }
        for mQuerySubView in subViews
        {
            if mQuerySubView.isKind(of: PollViewCell.self)
            {
                if selectedCell != mQuerySubView
                {
                    mQuerySubView.setSelectedState(kNotSelected)
                    mQuerySubView.backgroundColor = pollCellBackgroundColor
                }

            }
        }
        
        
        
    }
    
    func delegateSelectButtonPressed(withOptionCell selectedCell: PollViewCell!) {
        
        let subViews = mLikerScaleScrollView.subviews.flatMap{ $0 as? PollViewCell }
        for mQuerySubView in subViews
        {
            if mQuerySubView.isKind(of: PollViewCell.self)
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
