//
//  SSTeacherAggregatePopOverController.swift
//  LearniatTeacher
//
//  Created by Deepak MK on 02/04/16.
//  Copyright © 2016 Mindshift. All rights reserved.
//

import Foundation
class SSTeacherAggregatePopOverController: UIViewController, SSTeacherDataSourceDelegate
{
    
    var activityIndicator  = UIActivityIndicatorView(activityIndicatorStyle:.Gray)
    
    var mMrqAgregateView : MRQAggregateView!
    
    var mMtcAgregateView : MTCAggregateView!
    
    var cureentQuestionType  = ""
    
    var _delgate: AnyObject!
    func setdelegate(delegate:AnyObject)
    {
        _delgate = delegate;
    }
    
    func   delegate()->AnyObject
    {
        return _delgate;
    }
    
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.view.backgroundColor = whiteBackgroundColor
        
        activityIndicator.frame = CGRectMake(150, 0,100,100)
        self.view.addSubview(activityIndicator)
        activityIndicator.hidden = false
        activityIndicator.startAnimating()
        
        self.view.backgroundColor = whiteBackgroundColor
        
        
    }
    
    
    func AggregateDrillDownWithOptionId(optionId:String, withQuestionDetails questionDetails:AnyObject, withQuestionLogId questionLogId:String, withQuestionTye type:String)
    {
        cureentQuestionType = type
        SSTeacherDataSource.sharedDataSource.getAgregateDrilDownWithOptionId(optionId, WithQuestionLogId: questionLogId, WithDelegate: self)
    }
    
    
    
    
    
    func didGetAgregateDrillDownWithDetails(details: AnyObject)
    {

        
        activityIndicator.stopAnimating()
        
        
        if (cureentQuestionType  == kOverlayScribble  || cureentQuestionType == kFreshScribble)
        {
            
        }
        else if (cureentQuestionType == kText)
        {
            
        }
        else if (cureentQuestionType == kMatchColumn)
        {
            if mMtcAgregateView == nil
            {
                mMtcAgregateView = MTCAggregateView(frame: CGRectMake(0, 0,400,70))
                self.view.addSubview(mMtcAgregateView)
            }
            
            mMtcAgregateView.frame = CGRectMake(0, 0,400,mMtcAgregateView.showAggregateWithDetails(details))
            
            self.preferredContentSize = CGSize(width: 400, height: mMtcAgregateView.frame.size.height)
        }
        else
        {
            if mMrqAgregateView == nil
            {
                mMrqAgregateView = MRQAggregateView(frame: CGRectMake(0, 0,400,70))
                self.view.addSubview(mMrqAgregateView)
            }
            
            
            mMrqAgregateView.frame = CGRectMake(0, 0,400,mMrqAgregateView.showAggregateWithDetails(details))
            
            
            self.preferredContentSize = CGSize(width: 400, height: mMrqAgregateView.frame.size.height)
            
        }
        
        
       
        
        
       
        
    }
    
}