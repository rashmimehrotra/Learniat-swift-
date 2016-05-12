//
//  QRVVolunteerView.swift
//  Learniat_Student_Iphone
//
//  Created by Deepak MK on 24/02/16.
//  Copyright © 2016 mindShiftApps. All rights reserved.
//

import Foundation
import UIKit
class QRVVolunteerView: UIView
{
    
    
    
    override init(frame: CGRect)
    {
        super.init(frame:frame)
        
    }
    
    required init?(coder aDecoder: NSCoder)
    {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    
    func setStudentImageWithId(studentId:String, withColor color:UIColor)
    {
        
        let studentImageView = UIImageView(frame: CGRectMake(0,0,self.frame.size.width,self.frame.size.height))
        self.addSubview(studentImageView)
        studentImageView.layer.cornerRadius = studentImageView.frame.size.width/2
        studentImageView.layer.masksToBounds = true
//        studentImageView.image = UIImage(named: (INILoader.sharediniLoader.returnImageNameWithImagename("Seat.png")))
        let urlString = NSUserDefaults.standardUserDefaults().objectForKey(k_INI_UserProfileImageURL) as! String
        if let checkedUrl = NSURL(string: "\(urlString)/\(studentId)_79px.jpg")
        {
            studentImageView.contentMode = .ScaleAspectFit
            studentImageView.downloadImage(checkedUrl, withFolderType: folderType.ProFilePics)
        }


        
        
        let borderCircle = UIImageView(frame: CGRectMake(self.frame.size.width - 10 ,0,10,10))
        self.addSubview(borderCircle)
        borderCircle.layer.cornerRadius = borderCircle.frame.size.width/2
        borderCircle.layer.masksToBounds = true
        borderCircle.backgroundColor = color
        borderCircle.layer.borderColor = UIColor.whiteColor().CGColor
        borderCircle.layer.borderWidth = 2
        
        
        
        
    }
    

}