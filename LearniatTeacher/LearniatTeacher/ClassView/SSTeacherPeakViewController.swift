//
//  SSTeacherPeakViewController.swift
//  LearniatTeacher
//
//  Created by Deepak MK on 21/05/16.
//  Copyright © 2016 Mindshift. All rights reserved.
//

import Foundation
import UIKit
class SSTeacherPeakViewController: UIViewController
{
    
     var _currentStudentDict:AnyObject!
    
    var peakImage = UIImage()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
       
        
        
        
        
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: 270, height: 40))
        headerView.backgroundColor = lightGrayTopBar
        self.view.addSubview(headerView);
        
        
        let seperatorView = UIView(frame: CGRect(x: 0, y: headerView.frame.size.height-1, width: headerView.frame.size.width, height: 1))
        seperatorView.backgroundColor = LineGrayColor
        headerView.addSubview(seperatorView);
        
        
        let headerlabel = UILabel(frame: CGRect(x: 20, y: 0, width: 200, height: 40))
        headerlabel.text = kOverlayScribble
        headerView.addSubview(headerlabel)
        headerlabel.textAlignment = .left;
        headerlabel.font = UIFont(name: helveticaRegular, size: 20)
        headerlabel.textColor  = blackTextColor
        
        
        
        let  mDoneButton = UIButton(frame: CGRect(x: headerView.frame.size.width - 120, y: 0, width: 100, height: 40))
        mDoneButton.addTarget(self, action: #selector(StudentQueryPopover.onDoneButton), for: UIControlEvents.touchUpInside)
        mDoneButton.setTitleColor(standard_Button, for: UIControlState())
        mDoneButton.setTitle("Done", for: UIControlState())
        mDoneButton.contentHorizontalAlignment = UIControlContentHorizontalAlignment.right
        mDoneButton.titleLabel?.font = UIFont(name: helveticaMedium, size: 20)
        headerView.addSubview(mDoneButton)
        
        
        
        
        
        
        
        
        if let StudentName = _currentStudentDict.object(forKey: "Name") as? String
        {
            headerlabel.text = StudentName
        }
        
        let overlayimageView =  CustomProgressImageView(frame: CGRect(x: 0,y: headerView.frame.origin.y + headerView.frame.size.height ,width: headerView.frame.size.width,height: 180))
        
        self.view.addSubview(overlayimageView);
        
        let urlString = UserDefaults.standard.object(forKey: k_INI_SCRIBBLE_IMAGE_URL) as! String
        
        if let checkedUrl = URL(string: "\(urlString)/\(SSTeacherDataSource.sharedDataSource.mOverlayImageName)")
        {
            overlayimageView.contentMode = .scaleAspectFit
            overlayimageView.downloadImage(checkedUrl, withFolderType: folderType.questionImage,withResizeValue: overlayimageView.frame.size)
        }
        
        
        
        let studentImage  = CustomProgressImageView(frame: CGRect(x: 0,y: headerView.frame.origin.y + headerView.frame.size.height ,width: headerView.frame.size.width,height: 180))
        self.view.addSubview(studentImage)
        studentImage.image = peakImage
        
        
        

    }
    
    func setStudentDetails(_ StudentDict:AnyObject,  withPeakImage _peakImage:UIImage)
    {
        _currentStudentDict = StudentDict
        
        peakImage = _peakImage
        
        
        
    }
    
    
    
    
    var _Popover:UIPopoverController!
    
    func setPopover(_ popover:UIPopoverController)
    {
        _Popover = popover
    }
    
    func popover()-> UIPopoverController
    {
        return _Popover
    }
    
    func onDoneButton()
    {
        popover().dismiss(animated: true)
        
    }
}
