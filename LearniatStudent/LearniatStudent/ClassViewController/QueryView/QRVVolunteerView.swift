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
    
    
    
    
    func setStudentImageWithId(_ studentId:String, withColor color:UIColor)
    {
        
        let studentImageView = CustomProgressImageView(frame: CGRect(x: 0,y: 0,width: self.frame.size.width,height: self.frame.size.height))
        self.addSubview(studentImageView)
        studentImageView.layer.cornerRadius = studentImageView.frame.size.width/2
        studentImageView.layer.masksToBounds = true
        let urlString = UserDefaults.standard.object(forKey: k_INI_UserProfileImageURL) as! String
        if let checkedUrl = URL(string: "\(urlString)/\(studentId)_79px.jpg")
        {
            studentImageView.contentMode = .scaleAspectFit
            studentImageView.downloadImage(checkedUrl, withFolderType: folderType.proFilePics)
        }


        
        
        let borderCircle = UIImageView(frame: CGRect(x: self.frame.size.width - 10 ,y: 0,width: 10,height: 10))
        self.addSubview(borderCircle)
        borderCircle.layer.cornerRadius = borderCircle.frame.size.width/2
        borderCircle.layer.masksToBounds = true
        borderCircle.backgroundColor = color
        borderCircle.layer.borderColor = UIColor.white.cgColor
        borderCircle.layer.borderWidth = 2
        
        
        
        
    }
    

}
