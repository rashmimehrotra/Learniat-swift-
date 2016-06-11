//
//  TeacherMathView.swift
//  LearniatTeacher
//
//  Created by mindshift_Deepak on 05/05/16.
//  Copyright © 2016 Mindshift. All rights reserved.
//

import Foundation

@objc protocol TeacherMathViewDelegate
{
    
    optional func delegateShapesImages(image:UIImage, withBinaryData binaryData:NSData, withtagValue tagValue:Int, withType type:String)
    
    
}

class TeacherMathView: UIView,MAWMathViewDelegate,UIPopoverControllerDelegate
{
    
    let containerview = UIView()
    
    let m_BrushButton = UIButton()
    
    let m_EraserButton = UIButton()
    
    let m_RedoButton = UIButton()
    
    let m_UndoButton = UIButton()
    
    var mathView = MAWMathView()
    
    var _mathCertificateRegistered = Bool()
    
    
    let bottomtoolSelectedImageView = UIImageView()
    
    
    var _delgate: AnyObject!
    
    
    func setdelegate(delegate:AnyObject)
    {
        _delgate = delegate;
    }
    
    func   delegate()->AnyObject
    {
        return _delgate;
    }
    
    
    override init(frame: CGRect)
    {
        super.init(frame: frame)
       
        
        self.backgroundColor = whiteBackgroundColor
        
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
        mDoneButton.addTarget(self, action: #selector(TeacherMathView.onSendButton), forControlEvents: UIControlEvents.TouchUpInside)
        mDoneButton.setTitleColor(standard_Button, forState: .Normal)
        mDoneButton.setTitle("Done", forState: .Normal)
        mDoneButton.contentHorizontalAlignment = UIControlContentHorizontalAlignment.Right
        mDoneButton.titleLabel?.font = UIFont(name: helveticaMedium, size: 18)
        
        
        let  mBackButton = UIButton(frame: CGRectMake(10,  0, 200 ,mTopbarImageView.frame.size.height))
        mTopbarImageView.addSubview(mBackButton)
        mBackButton.addTarget(self, action: #selector(TeacherMathView.onCancelButton), forControlEvents: UIControlEvents.TouchUpInside)
        mBackButton.setTitleColor(standard_Button, forState: .Normal)
        mBackButton.setTitle("Cancel", forState: .Normal)
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
        m_UndoButton.addTarget(self, action: #selector(TeacherMathView.onUndoButton), forControlEvents: UIControlEvents.TouchUpInside)
        m_UndoButton.enabled = false
        
        bottomtoolSelectedImageView.backgroundColor = UIColor.whiteColor();
        bottomview.addSubview(bottomtoolSelectedImageView);
        bottomtoolSelectedImageView.layer.cornerRadius = 10.0;
        
        
        m_BrushButton.frame = CGRectMake((bottomview.frame.size.width - bottomview.frame.size.height) / 2 ,5, bottomview.frame.size.height ,bottomview.frame.size.height - 10)
        m_BrushButton.setImage(UIImage(named:"Marker_Selected.png"), forState:.Normal)
        bottomview.addSubview(m_BrushButton);
        m_BrushButton.imageView?.contentMode = .ScaleAspectFit
        m_BrushButton.addTarget(self, action: #selector(TeacherMathView.onBrushButton), forControlEvents: UIControlEvents.TouchUpInside)
        bottomtoolSelectedImageView.frame = m_BrushButton.frame
        
        
        
        m_RedoButton.frame = CGRectMake(bottomview.frame.size.width - bottomview.frame.size.height ,0, bottomview.frame.size.height ,bottomview.frame.size.height)
        m_RedoButton.setImage(UIImage(named:"Redo_Disabled.png"), forState:.Normal);
        bottomview.addSubview(m_RedoButton);
        m_RedoButton.imageView?.contentMode = .ScaleAspectFit
        m_RedoButton.addTarget(self, action: #selector(TeacherMathView.onRedoButton), forControlEvents: UIControlEvents.TouchUpInside)
        m_RedoButton.enabled = false
        
        
        
        let certificate:NSData = NSData(bytes:myCertificate.bytes , length: myCertificate.length)
        
        _mathCertificateRegistered = mathView.registerCertificate(certificate);
        
        if(_mathCertificateRegistered)
        {
            mathView.delegate = self;
            
            let mainBundle:NSBundle  = NSBundle.mainBundle();
            var bundlePath:NSString = mainBundle.pathForResource("MathResources", ofType: "bundle")!
            bundlePath = bundlePath.stringByAppendingPathComponent("conf")
            
            mathView.addSearchDir(bundlePath as String);
            
            // The configuration is an asynchronous operation. Callbacks are provided to
            // monitor the beginning and end of the configuration process.
            //
            // "en_US" references the en_US bundle name in the conf/en_US.conf file in your resources.
            // "si_text" references the configuration name in en_US.conf
            mathView.configureWithBundle("math", andConfig:"standard");
            mathView.frame = CGRectMake(0, 0, containerview.frame.size.width, containerview.frame.size.height)
            containerview.addSubview(mathView)
            mathView.backgroundColor = UIColor.greenColor()
            mathView.inkColor = UIColor(red:0.200, green:0.710, blue:0.898, alpha:1.0)
            
            
        }
        

    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func onRedoButton()
    {
        mathView.redo()
    }
    
    func onUndoButton()
    {
        mathView.undo()
    }
    
    func onBrushButton()
    {
        let buttonPosition :CGPoint = m_BrushButton.convertPoint(CGPointZero, toView: self)
        
        
        let colorSelectContoller = colorpopOverViewController()
        colorSelectContoller.setSelectTab(1);
        colorSelectContoller.setDelegate(self);
        colorSelectContoller.setRect(CGRectMake(0,0,400,400));
        
        
        colorSelectContoller.title = "Brush Size & Colour";
        
        let navController = UINavigationController(rootViewController:colorSelectContoller)
        
        let colorPopoverController = UIPopoverController(contentViewController:navController);
        colorPopoverController.popoverContentSize = CGSizeMake(400, 400);
        colorPopoverController.delegate = self;
        colorSelectContoller.setPopOverController(colorPopoverController);
        
        colorPopoverController.presentPopoverFromRect(CGRectMake(buttonPosition.x  + (m_BrushButton.frame.size.width/2),buttonPosition.y,1,1), inView: self, permittedArrowDirections: .Down, animated: true)
    }
    
    func onCancelButton()
    {
        self.removeFromSuperview()
    }
    
    
    
    func onSendButton()
    {
        delegate().delegateShapesImages!(mathView.resultAsImage(), withBinaryData: mathView.serialize(), withtagValue: self.tag, withType: "Equation")
        self.removeFromSuperview()
    }
    
    func mathViewDidBeginConfiguration(mathView: MAWMathView!)
    {
        
    }
    
    func mathViewDidEndConfiguration(mathView: MAWMathView!) {
        print("Math Widget recognition: \(mathView.resultAsText())");
    }
    
    func mathView(mathView: MAWMathView!, didFailConfigurationWithError error: NSError!)
    {
        
        print("Unable to configure the Math Widget: \(error.localizedDescription)");
    }
    
    func mathViewDidChangeUndoRedoState(mathView: MAWMathView!)
    {
        
        
        if mathView.canUndo()
        {
            m_UndoButton.setImage(UIImage(named:"Undo_Active.png"),forState:.Normal);
            m_UndoButton.enabled = true
        }
        else
        {
            m_UndoButton.setImage(UIImage(named:"Undo_Disabled.png"),forState:.Normal);
            m_UndoButton.enabled = false
        }
        
        
        
        if  mathView.canRedo()
        {
            m_RedoButton.setImage(UIImage(named:"Redo_Active.png"),forState:.Normal);
            m_RedoButton.enabled = true
        }
        else
        {
            m_RedoButton.setImage(UIImage(named:"Redo_Disabled.png"),forState:.Normal);
            m_RedoButton.enabled = false
        }

        
        
    }
    
    // MARK: - Color popover delegate
    
    func selectedbrushSize(sender: AnyObject!, withSelectedTab tabTag: Int32)
    {
        
        if let progressView = sender as? UISlider
        {
            mathView.inkThickness = CGFloat(progressView.value)
        }
        
        
    }
    
    func selectedColor(sender: AnyObject!, withSelectedTab tabTag: Int32)
    {
        if let progressColor = sender as? UIColor
        {
            mathView.inkColor = progressColor
        
        }
    }

    
    
    
}