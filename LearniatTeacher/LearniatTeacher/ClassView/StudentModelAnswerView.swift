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
    
    
    @objc optional func delegateModelAnswerViewLoadedWithHeight(_ height:CGFloat , withCount modelCount:Int)
    @objc optional func delegateModelAnswerViewLoadedWithHeight(_ height:CGFloat , withCount modelCount:Int, studentID: String)
    

}

class StudentModelAnswerView: UIView,SSTeacherDataSourceDelegate,StudentModelAnswerCellDelegate
{
    
    var _delgate: AnyObject!
    
    func setdelegate(_ delegate:AnyObject)
    {
        _delgate = delegate;
    }
    
    func   delegate()->AnyObject
    {
        return _delgate;
    }
    
    
    var mActivityIndicator  = UIActivityIndicatorView(activityIndicatorStyle:.gray)
    
    
    var currentModelAnswerArray = NSMutableArray()
    
     var mModelAnswerContainerView        = UIScrollView()
    
    var currentPositionY :CGFloat = 0
    
    var currentViewHeight  :CGFloat  = 44
    
    override init(frame: CGRect)
    {
          super.init(frame:frame)
        
        let mTopbarImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: self.frame.size.width, height: 44))
        mTopbarImageView.backgroundColor = lightGrayTopBar
        self.addSubview(mTopbarImageView)
        mTopbarImageView.isUserInteractionEnabled = true
        
        
        
        let seperatorView = UIView(frame: CGRect(x: 0 ,y: mTopbarImageView.frame.size.height - 1 , width: mTopbarImageView.frame.size.width,height: 1))
        seperatorView.backgroundColor = LineGrayColor;
        mTopbarImageView.addSubview(seperatorView)
        
        let mTopicName = UILabel()
        mTopicName.frame = CGRect(x: 10, y: 0 , width: 150, height: mTopbarImageView.frame.size.height)
        mTopicName.font = UIFont(name:helveticaMedium, size: 18)
        mTopbarImageView.addSubview(mTopicName)
        mTopicName.textColor = UIColor.black
        mTopicName.text = "Model answer"
        mTopicName.textAlignment = .left
        
        let  mDoneButton = UIButton(frame: CGRect(x: mTopbarImageView.frame.size.width - 210,  y: 0, width: 200 ,height: mTopbarImageView.frame.size.height))
        mTopbarImageView.addSubview(mDoneButton)
        mDoneButton.addTarget(self, action: #selector(StudentModelAnswerView.onSendAllButton), for: UIControlEvents.touchUpInside)
        mDoneButton.setTitleColor(standard_Button, for: UIControlState())
        mDoneButton.setTitle("Send all", for: UIControlState())
        mDoneButton.contentHorizontalAlignment = UIControlContentHorizontalAlignment.right
        mDoneButton.titleLabel?.font = UIFont(name: helveticaMedium, size: 18)
        
        mActivityIndicator.frame = CGRect(x: mTopicName.frame.origin.x + mTopicName.frame.size.width, y: 0, width: mTopbarImageView.frame.size.height,height: mTopbarImageView.frame.size.height)
        mTopbarImageView.addSubview(mActivityIndicator)
        mActivityIndicator.hidesWhenStopped = true
        mActivityIndicator.stopAnimating()
        
        
        
        mModelAnswerContainerView.frame = CGRect(x: 0,  y: mTopbarImageView.frame.size.height ,width: self.frame.size.width,height: self.frame.size.height -  mTopbarImageView.frame.size.height )
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
            if topicCell.isKind(of: StudentModelAnswerCell.self)
            {
                topicCell.removeFromSuperview()
            }
        }
        
        
        currentPositionY = 10
        currentViewHeight = 44
        
         delegate().delegateModelAnswerViewLoadedWithHeight!(44, withCount :0)
        
        SSTeacherMessageHandler.sharedMessageHandler.sendModelAnswerToStudentWithRoomId(SSTeacherDataSource.sharedDataSource.currentLiveSessionId, withQuestionLogId: SSTeacherDataSource.sharedDataSource.currentQuestionLogId as NSString)
        
    }
    
    
    func newModelAnswerAddedWithQuestionLogId(_ questionLogId:String)
    {
        mActivityIndicator.startAnimating()
        SSTeacherDataSource.sharedDataSource.getModelAnswerWithQuestionLogId(questionLogId, WithDelegate: self)
    }
    
    func didGetModelAnswerWithDetails(_ details: AnyObject)
    {

        mActivityIndicator.stopAnimating()
        var mModelAnswerDetails = NSMutableArray()
        
       if let classCheckingVariable = (details.object(forKey: "AssessmentAnswerIdList")! as AnyObject).object(forKey: "AssessmentAnswerId") as? NSMutableArray
       {
            mModelAnswerDetails = classCheckingVariable
        }
        else
       {
            mModelAnswerDetails.add((details.object(forKey: "AssessmentAnswerIdList")! as AnyObject).object(forKey: "AssessmentAnswerId")!)
        }
        
        
        
        for index  in 0 ..< mModelAnswerDetails.count
        {
            let object = mModelAnswerDetails.object(at: index)
            
            if let  AssessmentAnswerId = (object as AnyObject).object(forKey: "AssessmentAnswerId") as? String
            {
                if currentModelAnswerArray.contains(AssessmentAnswerId) == false
                {
                    currentModelAnswerArray.add(AssessmentAnswerId)
                    let modelAnswerCell = StudentModelAnswerCell(frame:CGRect(x: 0,y: currentPositionY,width: self.frame.size.width,height: (self.frame.size.width / 1.5) + 70 ))
                    modelAnswerCell.setModelAnswerWithDetails(object as AnyObject)
                    mModelAnswerContainerView.addSubview(modelAnswerCell)
                    modelAnswerCell.setdelegate(self)
                    currentPositionY = currentPositionY + modelAnswerCell.frame.size.height + 1
                    modelAnswerCell.backgroundColor = whiteColor
                    currentViewHeight = currentViewHeight + modelAnswerCell.frame.size.height + 1
                }
            }
        }
        
        
        
        mModelAnswerContainerView.contentSize = CGSize(width: 0, height: CGFloat(currentModelAnswerArray.count) * ((self.frame.size.width / 1.5) + 70 ))
        
        
        mModelAnswerContainerView.contentOffset = CGPoint(x: 0, y: 0)
        
        
        var height :CGFloat = currentViewHeight
        
        
        if height > UIScreen.main.bounds.height - 100
        {
            height = UIScreen.main.bounds.height - 100
        }
        
        
        
         mModelAnswerContainerView.frame = CGRect(x: mModelAnswerContainerView.frame.origin.x,y: mModelAnswerContainerView.frame.origin.y ,width: mModelAnswerContainerView.frame.size.width,height: height - 44)
        
        let subViews =  mModelAnswerContainerView.subviews.flatMap{ $0 as? StudentModelAnswerCell }
        
        delegate().delegateModelAnswerViewLoadedWithHeight!(height, withCount :subViews.count)
        
    }
    
//    func delegateModelAnswerRemovedWithAssesmentAnswerId(_ assesmentAnswerID: String)
//    {
//        var currentYPosition :CGFloat = 0
//        currentViewHeight = 44
//        let subViews =  mModelAnswerContainerView.subviews.flatMap{ $0 as? StudentModelAnswerCell }
//        for topicCell in subViews
//        {
//            if topicCell.isKind(of: StudentModelAnswerCell.self)
//            {
//                UIView.animate(withDuration: 0.2, animations:
//                    {
//                        topicCell.frame = CGRect(x: topicCell.frame.origin.x ,y: currentYPosition,width: topicCell.frame.size.width,height: topicCell.frame.size.height)
//                        
//                })
//                
//                currentYPosition = currentYPosition + topicCell.frame.size.height + 1
//                currentViewHeight = currentViewHeight + topicCell.frame.size.height + 1
//            }
//        }
//        
//        mModelAnswerContainerView.contentSize = CGSize(width: 0, height: currentYPosition)
//        
//        var height :CGFloat = currentViewHeight
//        
//        
//        if height > UIScreen.main.bounds.height - 140
//        {
//            height = UIScreen.main.bounds.height - 140
//        }
//        
//        
//        
//        mModelAnswerContainerView.frame = CGRect(x: mModelAnswerContainerView.frame.origin.x,y: mModelAnswerContainerView.frame.origin.y ,width: mModelAnswerContainerView.frame.size.width,height: height - 44)
//        
////        delegate().delegateModelAnswerViewLoadedWithHeight!(height, withCount :subViews.count)
//        delegate().delegateModelAnswerViewLoadedWithHeight!(height, withCount :subViews.count, assesmentAnswerID : assesmentAnswerID)
//    }
    
    func delegateModelAnswerRemovedWithAssesmentAnswerId(_ assesmentAnswerID: String, studentID: String)
    {
        var currentYPosition :CGFloat = 0
        currentViewHeight = 44
        let subViews =  mModelAnswerContainerView.subviews.flatMap{ $0 as? StudentModelAnswerCell }
        for topicCell in subViews
        {
            if topicCell.isKind(of: StudentModelAnswerCell.self)
            {
                UIView.animate(withDuration: 0.2, animations:
                    {
                        topicCell.frame = CGRect(x: topicCell.frame.origin.x ,y: currentYPosition,width: topicCell.frame.size.width,height: topicCell.frame.size.height)
                        
                })
                
                currentYPosition = currentYPosition + topicCell.frame.size.height + 1
                currentViewHeight = currentViewHeight + topicCell.frame.size.height + 1
            }
        }
        
        mModelAnswerContainerView.contentSize = CGSize(width: 0, height: currentYPosition)
        
        var height :CGFloat = currentViewHeight
        
        
        if height > UIScreen.main.bounds.height - 140
        {
            height = UIScreen.main.bounds.height - 140
        }
        
        
        
        mModelAnswerContainerView.frame = CGRect(x: mModelAnswerContainerView.frame.origin.x,y: mModelAnswerContainerView.frame.origin.y ,width: mModelAnswerContainerView.frame.size.width,height: height - 44)
        
        //        delegate().delegateModelAnswerViewLoadedWithHeight!(height, withCount :subViews.count)
        delegate().delegateModelAnswerViewLoadedWithHeight!(height, withCount :subViews.count, studentID : studentID)
    }
    
    func questionClearedByTeacher()
    {
        currentModelAnswerArray.removeAllObjects()
        
        currentPositionY = 10
        
        let subViews =  mModelAnswerContainerView.subviews.flatMap{ $0 as? StudentModelAnswerCell }
        for topicCell in subViews
        {
            if topicCell.isKind(of: StudentModelAnswerCell.self)
            {
                topicCell.removeFromSuperview()
            }
        }
        
    }
    
    
    
}
