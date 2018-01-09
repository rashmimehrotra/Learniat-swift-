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
        containerView.frame = CGRect(x: (self.frame.size.width - sizeOfCell)/2 , y: (self.frame.size.height - sizeOfCell)/2  , width: sizeOfCell, height: sizeOfCell)
        self.addSubview(containerView)
        
        
        StudentImageView.frame = CGRect(x: (containerView.frame.size.width - sizeOfCell * 0.7 )/2 , y: 0 , width: sizeOfCell * 0.7, height: sizeOfCell * 0.7)
        containerView.addSubview(StudentImageView)
        StudentImageView.backgroundColor = UIColor.white
        
        StudentNameLabel.frame = CGRect(x: 0, y: containerView.frame.size.height - sizeOfCell * 0.3  , width: containerView.frame.size.width , height: sizeOfCell * 0.3)
        containerView.addSubview(StudentNameLabel)
        StudentNameLabel.lineBreakMode = .byTruncatingTail
        StudentNameLabel.numberOfLines = 2
        StudentNameLabel.textAlignment = .center
        
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
    
    func setSeatIdValue(_ seatId:String)
    {
        seatIdvalue = seatId
    }
    
    func setStudentImageWithID(_ studentId:String, WithStudentname StudentName:String )
    {
        
        StudentNameLabel.text = StudentName
        StudentImageView.backgroundColor = UIColor.clear
        let urlString = UserDefaults.standard.object(forKey: k_INI_UserProfileImageURL) as! String
        if let checkedUrl = URL(string: "\(urlString)/\(studentId)_79px.jpg")
        {
            
            StudentImageView.downloadImage(checkedUrl, withFolderType: folderType.proFilePics)
            StudentImageView.contentMode = .scaleAspectFit
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
