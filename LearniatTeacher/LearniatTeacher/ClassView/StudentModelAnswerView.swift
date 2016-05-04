//
//  StudentModelAnswerView.swift
//  LearniatTeacher
//
//  Created by Deepak MK on 04/05/16.
//  Copyright © 2016 Mindshift. All rights reserved.
//

import Foundation

@objc protocol StudentModelAnswerViewDelegate
{
    
    
    optional func delegateModelAnswerViewLoadedWithHeight(height:CGFloat)
    

}

class StudentModelAnswerView: UIView,SSTeacherDataSourceDelegate
{
    
    var _delgate: AnyObject!
    
    func setdelegate(delegate:AnyObject)
    {
        _delgate = delegate;
    }
    
    func   delegate()->AnyObject
    {
        return _delgate;
    }
    
    
    var mActivityIndicator  = UIActivityIndicatorView(activityIndicatorStyle:.Gray)
    
    
    var currentModelAnswerArray = NSMutableArray()
    
     var mModelAnswerContainerView        = UIScrollView()
    
    var currentPositionY :CGFloat = 0
    
    var currentViewHeight  :CGFloat  = 10
    
    override init(frame: CGRect)
    {
          super.init(frame:frame)
        
        let mTopbarImageView = UIImageView(frame: CGRectMake(0, 0, self.frame.size.width, 44))
        mTopbarImageView.backgroundColor = lightGrayTopBar
        self.addSubview(mTopbarImageView)
        mTopbarImageView.userInteractionEnabled = true
        
        
        
        let seperatorView = UIView(frame: CGRectMake(0 ,mTopbarImageView.frame.size.height - 1 , mTopbarImageView.frame.size.width,1))
        seperatorView.backgroundColor = LineGrayColor;
        mTopbarImageView.addSubview(seperatorView)
        
        let mTopicName = UILabel()
        mTopicName.frame = CGRectMake(10, 0 , 150, mTopbarImageView.frame.size.height)
        mTopicName.font = UIFont(name:helveticaMedium, size: 18)
        mTopbarImageView.addSubview(mTopicName)
        mTopicName.textColor = UIColor.blackColor()
        mTopicName.text = "Model answer"
        mTopicName.textAlignment = .Left
        
        let  mDoneButton = UIButton(frame: CGRectMake(mTopbarImageView.frame.size.width - 210,  0, 200 ,mTopbarImageView.frame.size.height))
        mTopbarImageView.addSubview(mDoneButton)
        mDoneButton.addTarget(self, action: #selector(MainTopicsView.onDoneButton), forControlEvents: UIControlEvents.TouchUpInside)
        mDoneButton.setTitleColor(standard_Button, forState: .Normal)
        mDoneButton.setTitle("Send all", forState: .Normal)
        mDoneButton.contentHorizontalAlignment = UIControlContentHorizontalAlignment.Right
        mDoneButton.titleLabel?.font = UIFont(name: helveticaMedium, size: 18)
        
        mActivityIndicator.frame = CGRectMake(mTopicName.frame.origin.x + mTopicName.frame.size.width, 0, mTopbarImageView.frame.size.height,mTopbarImageView.frame.size.height)
        mTopbarImageView.addSubview(mActivityIndicator)
        mActivityIndicator.hidesWhenStopped = true
        mActivityIndicator.stopAnimating()
        
        
        
        mModelAnswerContainerView.frame = CGRectMake(0,  mTopbarImageView.frame.size.height ,self.frame.size.width,self.frame.size.height -  mTopbarImageView.frame.size.height )
        self.addSubview(mModelAnswerContainerView)
        mModelAnswerContainerView.backgroundColor = lightGrayTopBar
        

    }
    
    required init?(coder aDecoder: NSCoder)
    {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    func newModelAnswerAddedWithQuestionLogId(questionLogId:String)
    {
        mActivityIndicator.startAnimating()
        SSTeacherDataSource.sharedDataSource.getModelAnswerWithQuestionLogId(questionLogId, WithDelegate: self)
    }
    
    func didGetModelAnswerWithDetails(details: AnyObject)
    {

        mActivityIndicator.stopAnimating()
        var mModelAnswerDetails = NSMutableArray()
        
        let classCheckingVariable = details.objectForKey("AssessmentAnswerIdList")!.objectForKey("AssessmentAnswerId")!
        
        if classCheckingVariable.isKindOfClass(NSMutableArray)
        {
            mModelAnswerDetails = classCheckingVariable as! NSMutableArray
        }
        else
        {
            mModelAnswerDetails.addObject(details.objectForKey("AssessmentAnswerIdList")!.objectForKey("AssessmentAnswerId")!)
            
        }
        
        
        
        
        
        for index  in 0 ..< mModelAnswerDetails.count
        {
            let object = mModelAnswerDetails.objectAtIndex(index)
            
            if let  AssessmentAnswerId = object.objectForKey("AssessmentAnswerId") as? String
            {
                if currentModelAnswerArray.containsObject(AssessmentAnswerId) == false
                {
                    currentModelAnswerArray.addObject(AssessmentAnswerId)
                    let modelAnswerCell = StudentModelAnswerCell(frame:CGRectMake(0,currentPositionY,self.frame.size.width,(self.frame.size.width / 1.5) + 70 ))
                    modelAnswerCell.setModelAnswerWithDetails(object)
                    mModelAnswerContainerView.addSubview(modelAnswerCell)
                    currentPositionY = currentPositionY + modelAnswerCell.frame.size.height + 2
                    modelAnswerCell.backgroundColor = whiteColor
                    currentViewHeight = currentViewHeight + modelAnswerCell.frame.size.height + 2
                }
            }
        }
        
        
        
        mModelAnswerContainerView.contentSize = CGSizeMake(0, currentPositionY)
        
        
        var height :CGFloat = currentViewHeight
        
        
        if height > UIScreen.mainScreen().bounds.height - 140
        {
            height = UIScreen.mainScreen().bounds.height - 140
        }
        
        
        
         mModelAnswerContainerView.frame = CGRectMake(mModelAnswerContainerView.frame.origin.x,mModelAnswerContainerView.frame.origin.y ,mModelAnswerContainerView.frame.size.width,height)
        
        delegate().delegateModelAnswerViewLoadedWithHeight!(height)
        
    }
    
    
}