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
    
    var activityIndicator  = UIActivityIndicatorView(activityIndicatorStyle:.gray)
    
    var mMrqAgregateView : MRQAggregateView!
    
    var mMtcAgregateView : MTCAggregateView!
    
    var cureentQuestionType  = ""
    
    var _delgate: AnyObject!
    func setdelegate(_ delegate:AnyObject)
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
        
        activityIndicator.frame = CGRect(x: 150, y: 0,width: 100,height: 100)
        self.view.addSubview(activityIndicator)
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
        
        self.view.backgroundColor = whiteBackgroundColor
        
        
    }
    
    
    func AggregateDrillDownWithOptionId(_ optionId:String, withQuestionDetails questionDetails:AnyObject, withQuestionLogId questionLogId:String, withQuestionTye type:String)
    {
        cureentQuestionType = type
        SSTeacherDataSource.sharedDataSource.getAgregateDrilDownWithOptionId(optionId, WithQuestionLogId: questionLogId, WithDelegate: self)
    }
    
    
    
    
    
    func didGetAgregateDrillDownWithDetails(_ details: AnyObject)
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
                mMtcAgregateView = MTCAggregateView(frame: CGRect(x: 0, y: 0,width: 400,height: 70))
                self.view.addSubview(mMtcAgregateView)
            }
            
            mMtcAgregateView.frame = CGRect(x: 0, y: 0,width: 400,height: mMtcAgregateView.showAggregateWithDetails(details))
            
            self.preferredContentSize = CGSize(width: 400, height: mMtcAgregateView.frame.size.height)
        }
        else
        {
            if mMrqAgregateView == nil
            {
                mMrqAgregateView = MRQAggregateView(frame: CGRect(x: 0, y: 0,width: 400,height: 70))
                self.view.addSubview(mMrqAgregateView)
            }
            
            
            mMrqAgregateView.frame = CGRect(x: 0, y: 0,width: 400,height: mMrqAgregateView.showAggregateWithDetails(details))
            
            
            self.preferredContentSize = CGSize(width: 400, height: mMrqAgregateView.frame.size.height)
            
        }
        
        
       
        
        
       
        
    }
    
}
