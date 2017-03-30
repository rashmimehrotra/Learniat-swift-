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
    
    @objc optional func delegateShapesImages(_ image:UIImage, withBinaryData binaryData:Data, withtagValue tagValue:Int, withType type:String)
    
    
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
    
    
    func setdelegate(_ delegate:AnyObject)
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
        
        let mTopbarImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: self.frame.size.width, height: 60))
        mTopbarImageView.backgroundColor = whiteColor
        self.addSubview(mTopbarImageView)
        mTopbarImageView.isUserInteractionEnabled = true
        
        
        let mTopicName = UILabel()
        mTopicName.frame = CGRect(x: (self.frame.size.width - 150) / 2, y: 0 , width: 150, height: mTopbarImageView.frame.size.height)
        mTopicName.font = UIFont(name:helveticaBold, size: 22)
        mTopbarImageView.addSubview(mTopicName)
        mTopicName.textColor = UIColor.black
        mTopicName.text = "Add shapes"
        mTopicName.textAlignment = .left

        
        
        let  mDoneButton = UIButton(frame: CGRect(x: mTopbarImageView.frame.size.width - 210,  y: 0, width: 200 ,height: mTopbarImageView.frame.size.height))
        mTopbarImageView.addSubview(mDoneButton)
        mDoneButton.addTarget(self, action: #selector(TeacherMathView.onSendButton), for: UIControlEvents.touchUpInside)
        mDoneButton.setTitleColor(standard_Button, for: UIControlState())
        mDoneButton.setTitle("Done", for: UIControlState())
        mDoneButton.contentHorizontalAlignment = UIControlContentHorizontalAlignment.right
        mDoneButton.titleLabel?.font = UIFont(name: helveticaMedium, size: 18)
        
        
        let  mBackButton = UIButton(frame: CGRect(x: 10,  y: 0, width: 200 ,height: mTopbarImageView.frame.size.height))
        mTopbarImageView.addSubview(mBackButton)
        mBackButton.addTarget(self, action: #selector(TeacherMathView.onCancelButton), for: UIControlEvents.touchUpInside)
        mBackButton.setTitleColor(standard_Button, for: UIControlState())
        mBackButton.setTitle("Cancel", for: UIControlState())
        mBackButton.contentHorizontalAlignment = UIControlContentHorizontalAlignment.left
        mBackButton.titleLabel?.font = UIFont(name: helveticaMedium, size: 18)
        
        let bottomview = UIImageView(frame: CGRect(x: 0, y: self.frame.size.height - 60, width: self.frame.size.width, height: 60))
        bottomview.backgroundColor = lightGrayTopBar
        self.addSubview(bottomview)
        bottomview.isUserInteractionEnabled = true
        
        
        var contanerHeight  = mTopbarImageView.frame.origin.y + mTopbarImageView.frame.size.height + bottomview.frame.size.height + 20
        contanerHeight = self.frame.size.height - contanerHeight

        containerview.frame = CGRect(x: (self.frame.size.width - (contanerHeight * kAspectRation)) / 2 , y: mTopbarImageView.frame.origin.y + mTopbarImageView.frame.size.height + 10 ,  width: contanerHeight * kAspectRation ,height: contanerHeight)
        containerview.backgroundColor = UIColor.white
        self.addSubview(containerview);
        containerview.layer.shadowColor = progressviewBackground.cgColor;
        containerview.layer.shadowOffset = CGSize(width: 0,height: 0);
        containerview.layer.shadowOpacity = 1;
        containerview.layer.shadowRadius = 1.0;
        containerview.clipsToBounds = false;
        
        m_UndoButton.frame = CGRect(x: 0, y: 0, width: bottomview.frame.size.height, height: bottomview.frame.size.height)
        m_UndoButton.setImage(UIImage(named:"Undo_Disabled.png"),for:UIControlState());
        bottomview.addSubview(m_UndoButton);
        m_UndoButton.imageView?.contentMode = .scaleAspectFit
        m_UndoButton.addTarget(self, action: #selector(TeacherMathView.onUndoButton), for: UIControlEvents.touchUpInside)
        m_UndoButton.isEnabled = false
        
        bottomtoolSelectedImageView.backgroundColor = UIColor.white;
        bottomview.addSubview(bottomtoolSelectedImageView);
        bottomtoolSelectedImageView.layer.cornerRadius = 10.0;
        
        
        m_BrushButton.frame = CGRect(x: (bottomview.frame.size.width - bottomview.frame.size.height) / 2 ,y: 5, width: bottomview.frame.size.height ,height: bottomview.frame.size.height - 10)
        m_BrushButton.setImage(UIImage(named:"Marker_Selected.png"), for:UIControlState())
        bottomview.addSubview(m_BrushButton);
        m_BrushButton.imageView?.contentMode = .scaleAspectFit
        m_BrushButton.addTarget(self, action: #selector(TeacherMathView.onBrushButton), for: UIControlEvents.touchUpInside)
        bottomtoolSelectedImageView.frame = m_BrushButton.frame
        
        
        
        m_RedoButton.frame = CGRect(x: bottomview.frame.size.width - bottomview.frame.size.height ,y: 0, width: bottomview.frame.size.height ,height: bottomview.frame.size.height)
        m_RedoButton.setImage(UIImage(named:"Redo_Disabled.png"), for:UIControlState());
        bottomview.addSubview(m_RedoButton);
        m_RedoButton.imageView?.contentMode = .scaleAspectFit
        m_RedoButton.addTarget(self, action: #selector(TeacherMathView.onRedoButton), for: UIControlEvents.touchUpInside)
        m_RedoButton.isEnabled = false
        
        
        
        let certificate:Data = Data(bytes: UnsafePointer(myCertificate.bytes) , count: myCertificate.length)
        
        _mathCertificateRegistered = mathView.registerCertificate(certificate);
        
        if(_mathCertificateRegistered)
        {
            mathView.delegate = self;
            
            let mainBundle:Bundle  = Bundle.main;
            var bundlePath:NSString = mainBundle.path(forResource: "MathResources", ofType: "bundle")! as NSString
            bundlePath = bundlePath.appendingPathComponent("conf") as NSString
            
            mathView.addSearchDir(bundlePath as String);
            
            // The configuration is an asynchronous operation. Callbacks are provided to
            // monitor the beginning and end of the configuration process.
            //
            // "en_US" references the en_US bundle name in the conf/en_US.conf file in your resources.
            // "si_text" references the configuration name in en_US.conf
            mathView.configure(withBundle: "math", andConfig:"standard");
            mathView.frame = CGRect(x: 0, y: 0, width: containerview.frame.size.width, height: containerview.frame.size.height)
            containerview.addSubview(mathView)
            mathView.backgroundColor = UIColor.green
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
        let buttonPosition :CGPoint = m_BrushButton.convert(CGPoint.zero, to: self)
        
        
        let colorSelectContoller = colorpopOverViewController()
        colorSelectContoller.setSelectTab(1);
        colorSelectContoller.setDelegate(self);
        colorSelectContoller.setRect(CGRect(x: 0,y: 0,width: 400,height: 400));
        
        
        colorSelectContoller.title = "Brush Size & Colour";
        
        let navController = UINavigationController(rootViewController:colorSelectContoller)
        
        let colorPopoverController = UIPopoverController(contentViewController:navController);
        colorPopoverController.contentSize = CGSize(width: 400, height: 400);
        colorPopoverController.delegate = self;
        colorSelectContoller.setPopOver(colorPopoverController);
        
        colorPopoverController.present(from: CGRect(x: buttonPosition.x  + (m_BrushButton.frame.size.width/2),y: buttonPosition.y,width: 1,height: 1), in: self, permittedArrowDirections: .down, animated: true)
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
    
    func mathViewDidBeginConfiguration(_ mathView: MAWMathView!)
    {
        
    }
    
    func mathViewDidEndConfiguration(_ mathView: MAWMathView!) {
        print("Math Widget recognition: \(mathView.resultAsText())");
    }
    
    func mathView(_ mathView: MAWMathView!, didFailConfigurationWithError error: Error!)
    {
        
        print("Unable to configure the Math Widget: \(error.localizedDescription)");
    }
    
    func mathViewDidChangeUndoRedoState(_ mathView: MAWMathView!)
    {
        
        
        if mathView.canUndo()
        {
            m_UndoButton.setImage(UIImage(named:"Undo_Active.png"),for:UIControlState());
            m_UndoButton.isEnabled = true
        }
        else
        {
            m_UndoButton.setImage(UIImage(named:"Undo_Disabled.png"),for:UIControlState());
            m_UndoButton.isEnabled = false
        }
        
        
        
        if  mathView.canRedo()
        {
            m_RedoButton.setImage(UIImage(named:"Redo_Active.png"),for:UIControlState());
            m_RedoButton.isEnabled = true
        }
        else
        {
            m_RedoButton.setImage(UIImage(named:"Redo_Disabled.png"),for:UIControlState());
            m_RedoButton.isEnabled = false
        }

        
        
    }
    
    // MARK: - Color popover delegate
    
    func selectedbrushSize(_ sender: AnyObject!, withSelectedTab tabTag: Int32)
    {
        
        if let progressView = sender as? UISlider
        {
            mathView.inkThickness = CGFloat(progressView.value)
        }
        
        
    }
    
    func selectedColor(_ sender: AnyObject!, withSelectedTab tabTag: Int32)
    {
        if let progressColor = sender as? UIColor
        {
            mathView.inkColor = progressColor
        
        }
    }

    
    
    
}
