//
//  InternetConnection.swift
//  LearniatStudent
//
//  Created by Deepak on 7/8/17.
//  Copyright © 2017 Mindshift. All rights reserved.
//

import Foundation
class InternetConnection: UIView
{
    @IBOutlet weak var mRetryButton: RNLoadingButton!
    class func instanceFromNib() -> UIView {
        return UINib(nibName: "InternetDisconnected", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! UIView
    }
    @IBAction func onRetryButtin(_ sender: Any)
    {
        mRetryButton.isUserInteractionEnabled = false
        SSTeacherMessageHandler.sharedMessageHandler.performReconnet(connectType: "Retry")
        mRetryButton.activityIndicatorAlignment = RNActivityIndicatorAlignment.right
        mRetryButton.isLoading = true
        mRetryButton.setTitle("Retrying", for: .normal)
        mRetryButton.setTitleColor(lightGrayColor, for: .normal)
    }
    
    func stopLoading()
    {
        mRetryButton.isUserInteractionEnabled = true
        mRetryButton.isLoading = false
        mRetryButton.setTitle("Retry", for: .normal)
        mRetryButton.setTitleColor(whiteColor, for: .normal)
    }
    
}
