//
//  TeacherMathView.swift
//  LearniatTeacher
//
//  Created by mindshift_Deepak on 05/05/16.
//  Copyright © 2016 Mindshift. All rights reserved.
//

import Foundation

class TeacherMathView: UIView
{
    
    let containerview = UIView()
    
    let m_BrushButton = UIButton()
    
    let m_EraserButton = UIButton()
    
    let m_RedoButton = UIButton()
    
    let m_UndoButton = UIButton()
    
    let bottomtoolSelectedImageView = UIImageView()
    
    override init(frame: CGRect)
    {
        super.init(frame: frame)
       
        let mTopbarImageView = UIImageView(frame: CGRectMake(0, 0, self.frame.size.width, 60))
        mTopbarImageView.backgroundColor = whiteColor
        self.addSubview(mTopbarImageView)
        mTopbarImageView.userInteractionEnabled = true
        
        
        let mTopicName = UILabel()
        mTopicName.frame = CGRectMake((self.frame.size.width - 150) / 2, 0 , 150, mTopbarImageView.frame.size.height)
        mTopicName.font = UIFont(name:helveticaBold, size: 22)
        mTopbarImageView.addSubview(mTopicName)
        mTopicName.textColor = UIColor.blackColor()
        mTopicName.text = "Add shapes"
        mTopicName.textAlignment = .Left

        
        
        let  mDoneButton = UIButton(frame: CGRectMake(mTopbarImageView.frame.size.width - 210,  0, 200 ,mTopbarImageView.frame.size.height))
        mTopbarImageView.addSubview(mDoneButton)
        mDoneButton.addTarget(self, action: #selector(StudentModelAnswerView.onSendAllButton), forControlEvents: UIControlEvents.TouchUpInside)
        mDoneButton.setTitleColor(standard_Button, forState: .Normal)
        mDoneButton.setTitle("Send all", forState: .Normal)
        mDoneButton.contentHorizontalAlignment = UIControlContentHorizontalAlignment.Right
        mDoneButton.titleLabel?.font = UIFont(name: helveticaMedium, size: 18)
        
        
        let  mBackButton = UIButton(frame: CGRectMake(10,  0, 200 ,mTopbarImageView.frame.size.height))
        mTopbarImageView.addSubview(mBackButton)
        mBackButton.addTarget(self, action: #selector(StudentModelAnswerView.onSendAllButton), forControlEvents: UIControlEvents.TouchUpInside)
        mBackButton.setTitleColor(standard_Button, forState: .Normal)
        mBackButton.setTitle("Send all", forState: .Normal)
        mBackButton.contentHorizontalAlignment = UIControlContentHorizontalAlignment.Left
        mBackButton.titleLabel?.font = UIFont(name: helveticaMedium, size: 18)
        
        let bottomview = UIImageView(frame: CGRectMake(0, self.frame.size.height - 60, self.frame.size.width, 60))
        bottomview.backgroundColor = lightGrayTopBar
        self.addSubview(bottomview)
        bottomview.userInteractionEnabled = true
        
        
        var contanerHeight  = mTopbarImageView.frame.origin.y + mTopbarImageView.frame.size.height + bottomview.frame.size.height + 20
        contanerHeight = self.frame.size.height - contanerHeight

        containerview.frame = CGRectMake((self.frame.size.width - (contanerHeight * kAspectRation)) / 2 , mTopbarImageView.frame.origin.y + mTopbarImageView.frame.size.height + 10 ,  contanerHeight * kAspectRation ,contanerHeight)
        containerview.backgroundColor = UIColor.whiteColor()
        self.addSubview(containerview);
        containerview.layer.shadowColor = progressviewBackground.CGColor;
        containerview.layer.shadowOffset = CGSizeMake(0,0);
        containerview.layer.shadowOpacity = 1;
        containerview.layer.shadowRadius = 1.0;
        containerview.clipsToBounds = false;
        
        m_UndoButton.frame = CGRectMake(0, 0, bottomview.frame.size.height, bottomview.frame.size.height)
        m_UndoButton.setImage(UIImage(named:"Undo_Disabled.png"),forState:.Normal);
        bottomview.addSubview(m_UndoButton);
        m_UndoButton.imageView?.contentMode = .ScaleAspectFit
        m_UndoButton.addTarget(self, action: #selector(StudentAnnotateView.onUndoButton), forControlEvents: UIControlEvents.TouchUpInside)
        m_UndoButton.enabled = false
        
        bottomtoolSelectedImageView.backgroundColor = UIColor.whiteColor();
        bottomview.addSubview(bottomtoolSelectedImageView);
        bottomtoolSelectedImageView.layer.cornerRadius = 10.0;
        
        
        m_BrushButton.frame = CGRectMake((bottomview.frame.size.width - bottomview.frame.size.height) / 2 ,5, bottomview.frame.size.height ,bottomview.frame.size.height - 10)
        m_BrushButton.setImage(UIImage(named:"Marker_Selected.png"), forState:.Normal)
        bottomview.addSubview(m_BrushButton);
        m_BrushButton.imageView?.contentMode = .ScaleAspectFit
        m_BrushButton.addTarget(self, action: #selector(StudentAnnotateView.onBrushButton), forControlEvents: UIControlEvents.TouchUpInside)
        bottomtoolSelectedImageView.frame = m_BrushButton.frame
        
        
//        m_EraserButton.frame = CGRectMake((bottomview.frame.size.width/2) + 10  ,5, bottomview.frame.size.height ,bottomview.frame.size.height - 10)
//        m_EraserButton.setImage(UIImage(named:"Eraser_Unselected.png"), forState:.Normal);
//        bottomview.addSubview(m_EraserButton);
//        m_EraserButton.imageView?.contentMode = .ScaleAspectFit
//        m_EraserButton.addTarget(self, action: #selector(StudentAnnotateView.onEraserButton), forControlEvents: UIControlEvents.TouchUpInside)
//        
        
        m_RedoButton.frame = CGRectMake(bottomview.frame.size.width - bottomview.frame.size.height ,0, bottomview.frame.size.height ,bottomview.frame.size.height)
        m_RedoButton.setImage(UIImage(named:"Redo_Disabled.png"), forState:.Normal);
        bottomview.addSubview(m_RedoButton);
        m_RedoButton.imageView?.contentMode = .ScaleAspectFit
        m_RedoButton.addTarget(self, action: #selector(StudentAnnotateView.onRedoButton), forControlEvents: UIControlEvents.TouchUpInside)
        m_RedoButton.enabled = false
        
        

    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
}