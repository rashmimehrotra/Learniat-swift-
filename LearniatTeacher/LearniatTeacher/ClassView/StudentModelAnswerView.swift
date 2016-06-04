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
    
    
    optional func delegateModelAnswerViewLoadedWithHeight(height:CGFloat , withCount modelCount:Int)
    

}

class StudentModelAnswerView: UIView,SSTeacherDataSourceDelegate,StudentModelAnswerCellDelegate
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
    
    var currentViewHeight  :CGFloat  = 44
    
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
        mDoneButton.addTarget(self, action: #selector(StudentModelAnswerView.onSendAllButton), forControlEvents: UIControlEvents.TouchUpInside)
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
    
    func onSendAllButton()
    {
        let subViews =  mModelAnswerContainerView.subviews.flatMap{ $0 as? StudentModelAnswerCell }
        for topicCell in subViews
        {
            if topicCell.isKindOfClass(StudentModelAnswerCell)
            {
                topicCell.removeFromSuperview()
            }
        }
        
        
        currentPositionY = 10
        currentViewHeight = 44
        
         delegate().delegateModelAnswerViewLoadedWithHeight!(44, withCount :0)
        
        SSTeacherMessageHandler.sharedMessageHandler.sendModelAnswerToStudentWithRoomId(SSTeacherDataSource.sharedDataSource.currentLiveSessionId, withQuestionLogId: SSTeacherDataSource.sharedDataSource.currentQuestionLogId)
        
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
                    modelAnswerCell.setdelegate(self)
                    currentPositionY = currentPositionY + modelAnswerCell.frame.size.height + 1
                    modelAnswerCell.backgroundColor = whiteColor
                    currentViewHeight = currentViewHeight + modelAnswerCell.frame.size.height + 1
                }
            }
        }
        
        
        
        mModelAnswerContainerView.contentSize = CGSizeMake(0, CGFloat(currentModelAnswerArray.count) * ((self.frame.size.width / 1.5) + 70 ))
        
        
        mModelAnswerContainerView.contentOffset = CGPoint(x: 0, y: 0)
        
        
        var height :CGFloat = currentViewHeight
        
        
        if height > UIScreen.mainScreen().bounds.height - 100
        {
            height = UIScreen.mainScreen().bounds.height - 100
        }
        
        
        
         mModelAnswerContainerView.frame = CGRectMake(mModelAnswerContainerView.frame.origin.x,mModelAnswerContainerView.frame.origin.y ,mModelAnswerContainerView.frame.size.width,height - 44)
        
        let subViews =  mModelAnswerContainerView.subviews.flatMap{ $0 as? StudentModelAnswerCell }
        
        delegate().delegateModelAnswerViewLoadedWithHeight!(height, withCount :subViews.count)
        
    }
    
    func delegateModelAnswerRemovedWithAssesmentAnswerId(assesmentAnswerID: String)
    {
        var currentYPosition :CGFloat = 0
        currentViewHeight = 44
        let subViews =  mModelAnswerContainerView.subviews.flatMap{ $0 as? StudentModelAnswerCell }
        for topicCell in subViews
        {
            if topicCell.isKindOfClass(StudentModelAnswerCell)
            {
                UIView.animateWithDuration(0.2, animations:
                    {
                        topicCell.frame = CGRectMake(topicCell.frame.origin.x ,currentYPosition,topicCell.frame.size.width,topicCell.frame.size.height)
                        
                })
                
                currentYPosition = currentYPosition + topicCell.frame.size.height + 1
                currentViewHeight = currentViewHeight + topicCell.frame.size.height + 1
            }
        }
        
        mModelAnswerContainerView.contentSize = CGSizeMake(0, currentYPosition)
        
        var height :CGFloat = currentViewHeight
        
        
        if height > UIScreen.mainScreen().bounds.height - 140
        {
            height = UIScreen.mainScreen().bounds.height - 140
        }
        
        
        
        mModelAnswerContainerView.frame = CGRectMake(mModelAnswerContainerView.frame.origin.x,mModelAnswerContainerView.frame.origin.y ,mModelAnswerContainerView.frame.size.width,height - 44)
        
        delegate().delegateModelAnswerViewLoadedWithHeight!(height, withCount :subViews.count)
    }
    
    
    func questionClearedByTeacher()
    {
        currentModelAnswerArray.removeAllObjects()
        
        currentPositionY = 10
        
        let subViews =  mModelAnswerContainerView.subviews.flatMap{ $0 as? StudentModelAnswerCell }
        for topicCell in subViews
        {
            if topicCell.isKindOfClass(StudentModelAnswerCell)
            {
                topicCell.removeFromSuperview()
            }
        }
        
    }
    
    
    
}