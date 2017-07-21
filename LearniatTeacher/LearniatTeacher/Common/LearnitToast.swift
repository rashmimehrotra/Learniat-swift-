//
//  LearnitToast.swift
//  LearniatTeacher
//
//  Created by Sourabh on 21/07/17.
//  Copyright © 2017 Mindshift. All rights reserved.
//

import Foundation
class LearnitToast {
    static func showToast(view: UIView, duration: TimeInterval, image: String, text: String){
        let toastView = UIView(frame: CGRect(x: 0, y: 0, width: 140, height: 140))
        toastView.layer.cornerRadius = 20
        toastView.layer.shadowColor = UIColor.black.cgColor
        toastView.layer.shadowRadius = 5.0
        toastView.backgroundColor = UIColor.white
        
        let toastLabel = UILabel(frame: CGRect(x: 0, y: 100, width: 140, height: 24))
        toastLabel.textAlignment = .center
        toastLabel.text = text
        toastView.addSubview(toastLabel)
        
        let toastImage : UIImage = UIImage(named:image)!
        let toastImageView = UIImageView(image: toastImage)
        toastImageView.frame = CGRect(x: 30, y: 10, width: 80, height: 80)
        toastView.addSubview(toastImageView)
        
        for subview in view.subviews as [UIView] {
            subview.alpha = 0.5
        }
        
        view.showToast(toastView, duration: duration, position: .center) { didTap in
            for subview in view.subviews as [UIView] {
                subview.alpha = 1.0
            }
        }
        
    }
    
    static func showToast(view: UIView, duration: TimeInterval, text: String){
        showToast(view: view, duration: duration, image:"Check.png", text:text)
    }
    
    static func showToast(view: UIView, image: String, text: String){
        showToast(view: view, duration: 2.0, image:image, text:text)
    }
    
    static func showToast(view: UIView, text: String){
        showToast(view: view, duration: 2.0, image:"Check.png", text:text)
    }
    
    
}
