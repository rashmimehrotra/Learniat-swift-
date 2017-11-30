//
//  InternetConnection.swift
//  LearniatStudent
//
//  Created by Deepak on 7/8/17.
//  Copyright © 2017 Mindshift. All rights reserved.
//

import Foundation
class InternetConnection: UIView {
    @IBOutlet weak var mRetryButton: UIButton!
    @IBAction func onRetryButtin(_ sender: Any) {
        mRetryButton.isUserInteractionEnabled = false
       SSStudentMessageHandler.sharedMessageHandler.performReconnet(connectType: "Retry")
        mRetryButton.setTitle("Retrying", for: .normal)
        mRetryButton.setTitleColor(lightGrayColor, for: .normal)
    }
    
    func stopLoading() {
        mRetryButton.isUserInteractionEnabled = true
        mRetryButton.setTitle("Retry", for: .normal)
        mRetryButton.setTitleColor(whiteColor, for: .normal)
    }
}


extension UIView {
    class func fromNib<T : UIView>(nibName:String) -> T {
        return Bundle.main.loadNibNamed(nibName, owner: nil, options: nil)![0] as! T
    }
}
