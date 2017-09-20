//
//  AggregateCell.swift
//  LearniatTeacher
//
//  Created by Deepak MK on 04/04/16.
//  Copyright © 2016 Mindshift. All rights reserved.
//

import Foundation
class AggregateCell: UIView
{
    let studentName = UILabel()
    let graspLevelLabel = UILabel()
    var studentImage = CustomProgressImageView()
    var progressView = YLProgressBar()
    var graspImageView = UIImageView()
    
    
    override init(frame: CGRect) {
        
        super.init(frame:frame)
        
        
        self.backgroundColor = UIColor.clear
        
        
        
        // Initialization code

        studentName.frame = CGRect(x: 70 ,y: 20, width: 200, height: 25);
        studentName.textAlignment = .left;
        studentName.font =  UIFont(name: helveticaRegular, size: 16);
        self.addSubview(studentName)
        
         graspLevelLabel.frame = CGRect(x: 195 ,y: 20, width: 100, height: 25);
        graspLevelLabel.textAlignment = .right;
        graspLevelLabel.font = UIFont(name: helveticaRegular, size: 16);

        
        
        
        studentImage.frame =  CGRect(x: 20 ,y: 15, width: 40,height: 40);
        studentImage.layer.cornerRadius=studentImage.frame.size.width/8;
        studentImage.layer.masksToBounds = true;
        self.addSubview(studentImage)
        
        
        progressView.type                     = .flat;
        progressView.isStripesAnimated = false;
        progressView.hideStripes     = true;
        progressView.trackTintColor = UIColor(red: 213/255.0, green:213/255.0, blue:213/255.0, alpha: 1) //EEEEEE
        progressView.frame = CGRect(x: 70, y: 50, width: 305, height: 4);
        progressView.isUserInteractionEnabled = false;
        self.addSubview(progressView)
        
        
        graspImageView.frame = CGRect(x: 325, y: 12, width: 50,height: 32);
        self.addSubview(graspImageView)
        
        
        
        let seperatorView = UIView(frame: CGRect(x: 0 ,y: self.frame.size.height - 2 , width: self.frame.size.width,height: 2))
        seperatorView.backgroundColor = topicsLineColor;
        self.addSubview(seperatorView)

        
    }
    
    
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
        
        
    }
    
    
    func addStudentId(_ studentId:NSString, withName name:NSString, withgraspLevel grasp:NSString, withParticipation participation:Float)
    {
        studentName.text = name as String
        
        let urlString = UserDefaults.standard.object(forKey: k_INI_UserProfileImageURL) as! String
        
        if let checkedUrl = URL(string: "\(urlString)/\(studentId)_79px.jpg")
        {
            studentImage.contentMode = .scaleAspectFit
            studentImage.downloadImage(checkedUrl, withFolderType: folderType.proFilePics)
        }
        
        
        
        
        var graspIndexValue = grasp.integerValue
        
        if (graspIndexValue>0)
        {
            graspIndexValue = graspIndexValue/10;
            
        }
        
        if (graspIndexValue>10)
        {
            graspIndexValue = 10;
        }
        
        if (graspIndexValue<0)
        {
            graspIndexValue=0;
        }
        
        graspImageView.image = UIImage(named:"\(graspIndexValue)0.png")

        
    }
}
