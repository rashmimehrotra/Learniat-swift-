//
//  AutoSeatSubView.swift
//  Learniat Teacher
//
//  Created by Deepak MK on 23/03/16.
//  Copyright © 2016 Mindshift. All rights reserved.
//

import Foundation
class AutoSeatSubView: UIView{
    
    
    var sizeOfCell:CGFloat = 0
    
    var StudentImageView = CustomProgressImageView()
    
    var StudentNameLabel    = UILabel()
    
    var seatIdvalue         = "0"
    
    var StudentIdValue      = "0"
    
    override init(frame: CGRect)
    {
        super.init(frame:frame)
        
        
        
        if self.frame.size.width > self.frame.size.height
        {
            sizeOfCell = self.frame.size.height
        }
        else
        {
            sizeOfCell = self.frame.size.width
        }
        
        
        
        let containerView = UIImageView()
        containerView.frame = CGRectMake((self.frame.size.width - sizeOfCell)/2 , (self.frame.size.height - sizeOfCell)/2  , sizeOfCell, sizeOfCell)
        self.addSubview(containerView)
        
        
        StudentImageView.frame = CGRectMake((containerView.frame.size.width - sizeOfCell * 0.7 )/2 , 0 , sizeOfCell * 0.7, sizeOfCell * 0.7)
        containerView.addSubview(StudentImageView)
        StudentImageView.backgroundColor = UIColor.whiteColor()
        
        StudentNameLabel.frame = CGRectMake(0, containerView.frame.size.height - sizeOfCell * 0.3  , containerView.frame.size.width , sizeOfCell * 0.3)
        containerView.addSubview(StudentNameLabel)
        StudentNameLabel.lineBreakMode = .ByTruncatingTail
        StudentNameLabel.numberOfLines = 2
        StudentNameLabel.textAlignment = .Center
        
        if (StudentNameLabel.frame.size.height)/1.2 < 18
        {
            StudentNameLabel.font = UIFont(name:helveticaRegular, size: (StudentNameLabel.frame.size.height)/1.2)
        }
        else
        {
             StudentNameLabel.font = UIFont(name:helveticaRegular, size: 18)
        }
        
    }
    
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")

    }
    
    func setSeatIdValue(seatId:String)
    {
        seatIdvalue = seatId
    }
    
    func setStudentImageWithID(studentId:String, WithStudentname StudentName:String )
    {
        
        StudentNameLabel.text = StudentName
        StudentImageView.backgroundColor = UIColor.clearColor()
        let urlString = NSUserDefaults.standardUserDefaults().objectForKey(k_INI_UserProfileImageURL) as! String
        if let checkedUrl = NSURL(string: "\(urlString)/\(studentId)_79px.jpg")
        {
            StudentImageView.contentMode = .ScaleAspectFit
            StudentImageView.downloadImage(checkedUrl, withFolderType: folderType.ProFilePics)
        }
        StudentImageView.layer.cornerRadius = 2
        StudentImageView.layer.masksToBounds = true
        StudentIdValue = studentId
    }
    
    
    func getSeatIdAndStudentId() ->(seatId:String , StudentId :String)
    {
        
        return (seatIdvalue , StudentIdValue)
    }
    
    
}