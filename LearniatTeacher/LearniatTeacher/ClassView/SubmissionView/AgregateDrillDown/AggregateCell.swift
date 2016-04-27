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
        
        
        self.backgroundColor = UIColor.clearColor()
        
        
        
        // Initialization code

        studentName.frame = CGRectMake(70 ,20, 200, 25);
        studentName.textAlignment = .Left;
        studentName.font =  UIFont(name: helveticaRegular, size: 16);
        self.addSubview(studentName)
        
         graspLevelLabel.frame = CGRectMake(195 ,20, 100, 25);
        graspLevelLabel.textAlignment = .Right;
        graspLevelLabel.font = UIFont(name: helveticaRegular, size: 16);

        
        
        
        studentImage.frame =  CGRectMake(20 ,15, 40,40);
        studentImage.layer.cornerRadius=studentImage.frame.size.width/8;
        studentImage.layer.masksToBounds = true;
        self.addSubview(studentImage)
        
        
        progressView.type                     = .Flat;
        progressView.stripesAnimated = false;
        progressView.hideStripes     = true;
        progressView.trackTintColor = UIColor(red: 213/255.0, green:213/255.0, blue:213/255.0, alpha: 1) //EEEEEE
        progressView.frame = CGRectMake(70, 50, 305, 4);
        progressView.userInteractionEnabled = false;
        self.addSubview(progressView)
        
        
        graspImageView.frame = CGRectMake(325, 12, 50,32);
        self.addSubview(graspImageView)
        
        
        
        let seperatorView = UIView(frame: CGRectMake(0 ,self.frame.size.height - 2 , self.frame.size.width,2))
        seperatorView.backgroundColor = topicsLineColor;
        self.addSubview(seperatorView)

        
    }
    
    
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
        
        
    }
    
    
    func addStudentId(studentId:NSString, withName name:NSString, withgraspLevel grasp:NSString, withParticipation participation:Float)
    {
        studentName.text = name as String
        
        let urlString = NSUserDefaults.standardUserDefaults().objectForKey(k_INI_UserProfileImageURL) as! String
        
        if let checkedUrl = NSURL(string: "\(urlString)/\(studentId)_79px.jpg")
        {
            studentImage.contentMode = .ScaleAspectFit
            studentImage.downloadImage(checkedUrl, withFolderType: folderType.ProFilePics)
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