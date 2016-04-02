//
//  SSTeacherQueryView.swift
//  LearniatTeacher
//
//  Created by Deepak MK on 02/04/16.
//  Copyright © 2016 Mindshift. All rights reserved.
//

import Foundation

class SSTeacherQueryView: UIView
{
    var _delgate: AnyObject!
    override init(frame: CGRect)
    {
        
        super.init(frame:frame)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func setdelegate(delegate:AnyObject)
    {
        _delgate = delegate;
    }
    
    func   delegate()->AnyObject
    {
        return _delgate;
    }
}