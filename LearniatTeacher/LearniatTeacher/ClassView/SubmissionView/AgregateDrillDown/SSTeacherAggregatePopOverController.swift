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
        
        activityIndicator.frame = CGRectMake(0, 0,100,100)
        self.view.addSubview(activityIndicator)
        activityIndicator.hidden = false
        activityIndicator.startAnimating()
        
        self.view.backgroundColor = whiteBackgroundColor
        
        
    }
    
    
    func AggregateDrillDownWithOptionId(optionId:String, withQuestionDetails questionDetails:AnyObject, withQuestionLogId questionLogId:String)
    {
        SSTeacherDataSource.sharedDataSource.getAgregateDrilDownWithOptionId(optionId, WithQuestionLogId: questionLogId, WithDelegate: self)
    }
    
    
    
    
    
    func didGetAgregateDrillDownWithDetails(details: AnyObject)
    {

        print(details)
        
        activityIndicator.stopAnimating()
        
        if mMrqAgregateView == nil
        {
            mMrqAgregateView = MRQAggregateView(frame: CGRectMake(0, 0,400,70))
            self.view.addSubview(mMrqAgregateView)
        }
        
        
        
        
        self.preferredContentSize = CGSize(width: 400, height: mMrqAgregateView.showAggregateWithDetails(details))
        
        
       
        
    }
    
}