//
//  SSStudentFullscreenScribbleQuestion.swift
//  LearniatTeacher
//
//  Created by Deepak MK on 21/04/16.
//  Copyright © 2016 Mindshift. All rights reserved.
//

import Foundation

let kAspectRation:CGFloat = 1.5

@objc protocol SSStudentFullscreenScribbleQuestionDelegate
{
    
    optional func delegateFullScreenSendButtonPressedWithImage(writtenImage:UIImage)
    
    
}


class SSStudentFullscreenScribbleQuestion: UIView,UIPopoverControllerDelegate, TeacherShapesViewDelegate, ImageEditorSubViewDelegate
{
    
    
    var  mTopbarImageView : UIImageView!
    
    var mBottomToolBarImageView :UIImageView!
    
    let mSendButton = UIButton()
    
    let mCancelButton = UIButton()
    
    let m_BrushButton = UIButton()
    
    let m_EraserButton = UIButton()
    
    let m_RedoButton = UIButton()
    
    let m_UndoButton = UIButton()
    
    let bottomtoolSelectedImageView = UIImageView()
    
    let contanerBackgroundView = UIView()
    
    let containerview = UIView()
    
    var mScribbleView : SmoothLineView!
    
    let kUplodingServer     = "http://54.251.104.13/Jupiter/upload_photos.php"
    
    let imageUploading = ImageUploading()
    
    var sendButtonSpinner : UIActivityIndicatorView!
    
    var _currentTopicId  = ""
    
    var currentQuestionId = ""
    
    var nameOfImage = ""
    
    var mOverlayView            = UIImageView()
    
    var subCellsTagValue = 1000
    
    var _delgate: AnyObject!
    
    
    func setdelegate(delegate:AnyObject)
    {
        _delgate = delegate;
    }
    
    func   delegate()->AnyObject
    {
        return _delgate;
    }
    
    
    override init(frame: CGRect) {
        
        super.init(frame:frame)
        
        
        self.backgroundColor = whiteBackgroundColor
        
         imageUploading.setDelegate(self)
        
        mTopbarImageView = UIImageView(frame: CGRectMake(0, 0, self.frame.size.width, 70))
        mTopbarImageView.backgroundColor = whiteColor
        self.addSubview(mTopbarImageView)
        mTopbarImageView.userInteractionEnabled = true
        
        
        
        
        
        
        
        
        
        
        
        mBottomToolBarImageView = UIImageView(frame: CGRectMake(0, self.frame.size.height - 60, self.frame.size.width, 60))
        mBottomToolBarImageView.backgroundColor = lightGrayTopBar
        self.addSubview(mBottomToolBarImageView)
        mBottomToolBarImageView.userInteractionEnabled = true
        
        mCancelButton.showsTouchWhenHighlighted = true;
        /* Add Cancel button target Cancel button should deselect all the selected submissions *defect 142 */
        mCancelButton.frame = CGRectMake(10 , 0, 100,  mTopbarImageView.frame.size.height);
        mTopbarImageView.addSubview(mCancelButton);
        mCancelButton.setTitle("Cancel", forState:.Normal);
        mCancelButton.setTitleColor(standard_Button, forState:.Normal);
        mCancelButton.titleLabel?.font = UIFont(name: helveticaMedium, size: 20);
        mCancelButton.contentHorizontalAlignment = UIControlContentHorizontalAlignment.Left
        mCancelButton.addTarget(self, action: #selector(SSStudentFullscreenScribbleQuestion.onCancelButton), forControlEvents: UIControlEvents.TouchUpInside)
        
        
        mSendButton.frame = CGRectMake(mTopbarImageView.frame.size.width - 100 , 0, 100 , mTopbarImageView.frame.size.height );
        mTopbarImageView.addSubview(mSendButton);
        mSendButton.setTitle("Done", forState:.Normal);
        mSendButton.setTitleColor(standard_Button, forState:.Normal);
        mSendButton.titleLabel?.font = UIFont(name: helveticaMedium, size: 20);
        mSendButton.enabled = true
        mSendButton.highlighted = false;
        mSendButton.contentHorizontalAlignment = UIControlContentHorizontalAlignment.Center
        mSendButton.addTarget(self, action: #selector(SSStudentFullscreenScribbleQuestion.onSendButton), forControlEvents: UIControlEvents.TouchUpInside)
        
        
        sendButtonSpinner = UIActivityIndicatorView(activityIndicatorStyle:.WhiteLarge);
        sendButtonSpinner.frame = mSendButton.frame;
        mTopbarImageView.addSubview(sendButtonSpinner);
        sendButtonSpinner.hidden = true;

        
        
        
        var contanerHeight  = mTopbarImageView.frame.origin.y + mTopbarImageView.frame.size.height + mBottomToolBarImageView.frame.size.height + 20
        contanerHeight = self.frame.size.height - contanerHeight
        
        
        
        contanerBackgroundView.frame = CGRectMake((self.frame.size.width - (contanerHeight * kAspectRation)) / 2 , mTopbarImageView.frame.origin.y + mTopbarImageView.frame.size.height + 10 ,  contanerHeight * kAspectRation ,contanerHeight)
          contanerBackgroundView.backgroundColor = UIColor.whiteColor()
        self.addSubview(contanerBackgroundView)
        contanerBackgroundView.layer.shadowColor = progressviewBackground.CGColor;
        contanerBackgroundView.layer.shadowOffset = CGSizeMake(0,0);
        contanerBackgroundView.layer.shadowOpacity = 1;
        contanerBackgroundView.layer.shadowRadius = 1.0;
        contanerBackgroundView.clipsToBounds = false;
        
        
        
        mOverlayView.frame = CGRectMake(0,0,contanerBackgroundView.frame.size.width, contanerBackgroundView.frame.size.height)
        contanerBackgroundView.addSubview(mOverlayView);
        
        
        
        containerview.frame = CGRectMake(0,0,contanerBackgroundView.frame.size.width, contanerBackgroundView.frame.size.height)
       contanerBackgroundView.addSubview(containerview);
        
      
        
        
        mScribbleView = SmoothLineView(frame: CGRectMake(0,0,containerview.frame.size.width, containerview.frame.size.height))
        mScribbleView.delegate = self
        containerview.addSubview(mScribbleView);
        mScribbleView.userInteractionEnabled = true
        mScribbleView.setDrawingColor(blackTextColor);
        mScribbleView.setBrushWidth(5)
        mScribbleView.setDrawingTool(kBrushTool)
        mScribbleView.hidden = false
        
        
        
       
       
        m_UndoButton.frame = CGRectMake(0, 0, mBottomToolBarImageView.frame.size.height, mBottomToolBarImageView.frame.size.height)
        m_UndoButton.setImage(UIImage(named:"Undo_Disabled.png"),forState:.Normal);
        mBottomToolBarImageView.addSubview(m_UndoButton);
        m_UndoButton.imageView?.contentMode = .ScaleAspectFit
        m_UndoButton.addTarget(self, action: #selector(SSStudentFullscreenScribbleQuestion.onUndoButton), forControlEvents: UIControlEvents.TouchUpInside)
        m_UndoButton.enabled = false
        
        bottomtoolSelectedImageView.backgroundColor = UIColor.whiteColor();
        mBottomToolBarImageView.addSubview(bottomtoolSelectedImageView);
        
        
        m_BrushButton.frame = CGRectMake((mBottomToolBarImageView.frame.size.width/2) - (mBottomToolBarImageView.frame.size.height + 10) ,5, mBottomToolBarImageView.frame.size.height ,mBottomToolBarImageView.frame.size.height - 10)
        m_BrushButton.setImage(UIImage(named:"Marker_Selected.png"), forState:.Normal)
        mBottomToolBarImageView.addSubview(m_BrushButton);
        m_BrushButton.imageView?.contentMode = .ScaleAspectFit
        m_BrushButton.addTarget(self, action: #selector(SSStudentFullscreenScribbleQuestion.onBrushButton), forControlEvents: UIControlEvents.TouchUpInside)
        bottomtoolSelectedImageView.frame = m_BrushButton.frame
        
        
        
        
        m_EraserButton.frame = CGRectMake((mBottomToolBarImageView.frame.size.width/2) + 10  ,5, mBottomToolBarImageView.frame.size.height ,mBottomToolBarImageView.frame.size.height - 10)
        m_EraserButton.setImage(UIImage(named:"Eraser_Unselected.png"), forState:.Normal);
        mBottomToolBarImageView.addSubview(m_EraserButton);
        m_EraserButton.imageView?.contentMode = .ScaleAspectFit
        m_EraserButton.addTarget(self, action: #selector(SSStudentFullscreenScribbleQuestion.onEraserButton), forControlEvents: UIControlEvents.TouchUpInside)
        
        
        m_RedoButton.frame = CGRectMake(mBottomToolBarImageView.frame.size.width - mBottomToolBarImageView.frame.size.height ,0, mBottomToolBarImageView.frame.size.height ,mBottomToolBarImageView.frame.size.height)
        m_RedoButton.setImage(UIImage(named:"Redo_Disabled.png"), forState:.Normal);
        mBottomToolBarImageView.addSubview(m_RedoButton);
        m_RedoButton.imageView?.contentMode = .ScaleAspectFit
        m_RedoButton.addTarget(self, action: #selector(SSStudentFullscreenScribbleQuestion.onRedoButton), forControlEvents: UIControlEvents.TouchUpInside)
        m_RedoButton.enabled = false
        
        
        
        
        let  mEquationButton = UIButton(frame: CGRectMake(m_RedoButton.frame.origin.x - 140,  bottomtoolSelectedImageView.frame.origin.y,130 ,bottomtoolSelectedImageView.frame.size.height))
        mBottomToolBarImageView.addSubview(mEquationButton)
        mEquationButton.addTarget(self, action: #selector(SSStudentFullscreenScribbleQuestion.onEquationButton), forControlEvents: UIControlEvents.TouchUpInside)
        mEquationButton.imageView?.contentMode = .ScaleAspectFit
        mEquationButton.setTitle("Equation", forState: .Normal)
        mEquationButton.setTitleColor(standard_Button, forState: .Normal)
         mEquationButton.contentHorizontalAlignment = UIControlContentHorizontalAlignment.Right
        mEquationButton.titleLabel?.font = UIFont(name: helveticaMedium, size: 18);
        
        let mEquationImage = UIImageView(frame:CGRectMake(10, 10, mEquationButton.frame.size.height - 20 ,mEquationButton.frame.size.height - 20 ))
        mEquationImage.image = UIImage(named: "Equation.png")
        mEquationImage.contentMode = .ScaleAspectFit
        mEquationButton.addSubview(mEquationImage)
        
        
        
        
        
        let  mShapesButton = UIButton(frame: CGRectMake(mEquationButton.frame.origin.x - 120,  bottomtoolSelectedImageView.frame.origin.y,110 ,bottomtoolSelectedImageView.frame.size.height  ))
        mBottomToolBarImageView.addSubview(mShapesButton)
        mShapesButton.addTarget(self, action: #selector(SSStudentFullscreenScribbleQuestion.onShapesButton), forControlEvents: UIControlEvents.TouchUpInside)
        mShapesButton.imageView?.contentMode = .ScaleAspectFit
        mShapesButton.setTitle("Shapes", forState: .Normal)
        mShapesButton.setTitleColor(standard_Button, forState: .Normal)
        mShapesButton.contentHorizontalAlignment = UIControlContentHorizontalAlignment.Right
        mShapesButton.titleLabel?.font = UIFont(name: helveticaMedium, size: 18)
        
        let mShapesImage = UIImageView(frame:CGRectMake(10, 10, mShapesButton.frame.size.height - 20 ,mShapesButton.frame.size.height - 20 ))
        mShapesImage.image = UIImage(named: "Shapes.png")
        mShapesImage.contentMode = .ScaleAspectFit
        mShapesButton.addSubview(mShapesImage)
        
        
        
        
        
        
        
        
    }
    
    
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
        
        
    }
    
    func setOverlayImage(_overlay :UIImage)
    {
        
        mOverlayView.image = _overlay
    }
    
    func setCurrentTopicId(topicId:String)
    {
        _currentTopicId = topicId
    }
    
    
     // MARK: - Buttons Function
    
    func onCancelButton()
    {
       
        self.hidden = true
        
    }
    
    func onSendButton()
    {
        
        
        
        let image = UIImage.renderUIViewToImage(containerview)
        
        
        delegate().delegateFullScreenSendButtonPressedWithImage!(image)
        
    }
    
    
    func onUndoButton()
    {
        mScribbleView.undoButtonClicked()
    }
    
    func onBrushButton()
    {
        
        
        
        if bottomtoolSelectedImageView.frame == m_BrushButton.frame
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
        
        bottomtoolSelectedImageView.frame = m_BrushButton.frame
        m_BrushButton.setImage(UIImage(named:"Marker_Selected.png"), forState:.Normal)
        m_EraserButton.setImage(UIImage(named:"Eraser_Unselected.png"), forState:.Normal)
        mScribbleView.setDrawingTool(kBrushTool)
        
        
        
        
        
        
    }
    
    func onEraserButton()
    {
        
        
        if bottomtoolSelectedImageView.frame == m_EraserButton.frame
        {
            
            let buttonPosition :CGPoint = m_EraserButton.convertPoint(CGPointZero, toView: self)
            
            
            let colorSelectContoller = colorpopOverViewController()
            colorSelectContoller.setSelectTab(2);
            colorSelectContoller.setDelegate(self);
            colorSelectContoller.setRect(CGRectMake(0,0,200,200));
            
            
            colorSelectContoller.title = "Eraser Size & Colour";
            
            let navController = UINavigationController(rootViewController:colorSelectContoller)
            
            let colorPopoverController = UIPopoverController(contentViewController:navController);
            colorPopoverController.popoverContentSize = CGSizeMake(200, 150);
            colorPopoverController.delegate = self;
            colorSelectContoller.setPopOverController(colorPopoverController);
            
            colorPopoverController.presentPopoverFromRect(CGRectMake(buttonPosition.x  + (m_EraserButton.frame.size.width/2),buttonPosition.y,1,1), inView: self, permittedArrowDirections: .Down, animated: true)
            
        }
        
        
        
        
        bottomtoolSelectedImageView.frame = m_EraserButton.frame
        m_BrushButton.setImage(UIImage(named:"Marker_Unselected.png"), forState:.Normal)
        m_EraserButton.setImage(UIImage(named:"Eraser_Selected.png"), forState:.Normal)
        mScribbleView.setDrawingTool(kEraserTool)
        
        
        
        
        
        
        
        
        
    }
    
    func onRedoButton()
    {
        mScribbleView.redoButtonClicked()
    }
    
    func onEquationButton()
    {
        let mathView = TeacherMathView(frame:CGRectMake(0,0,self.frame.size.width, self.frame.size.height))
       
        mathView.setdelegate(self)
         self.addSubview(mathView)
    }
    
    func onShapesButton()
    {
        let shapesView = TeacherShapesView(frame:CGRectMake(0,0,self.frame.size.width, self.frame.size.height))
        self.addSubview(shapesView)
        shapesView.setdelegate(self)
    }
    
    
    // MARK: - Shapes delegate
    
    func delegateShapesImages(image: UIImage, withBinaryData binaryData: NSData, withtagValue tagValue: Int, withType type: String) {
        
        
        let imageView = UIImageView()
        imageView.image = image
        imageView.contentMode = .ScaleAspectFit;
        imageView.userInteractionEnabled = true
        
        
        var shapeSize:CGSize = image.size;
        
        if (shapeSize.width < 100)
        {
            shapeSize = CGSizeMake(100, shapeSize.height);
        }
        if (shapeSize.height < 100)
        {
            shapeSize = CGSizeMake(shapeSize.width, 100);
        }
        
        
        imageView.frame = CGRectMake(0,0, shapeSize.width, shapeSize.height);
        
        
        
        if let shapesImage = containerview.viewWithTag(tagValue) as? ImageEditorSubView
        {
             shapesImage.frame = imageView.frame
            shapesImage.setContentImageView(imageView, withImage: image)
            shapesImage.setBinaryValue(binaryData)
            shapesImage.typeString = type
        }
        
        else
        {
            let shapesImage = ImageEditorSubView(frame:imageView.frame)
            containerview.addSubview(shapesImage)
            shapesImage.setdelegate(self)
            shapesImage.setContentImageView(imageView, withImage: image)
            shapesImage.setBinaryValue(binaryData)
            shapesImage.typeString = type
            shapesImage.tag = subCellsTagValue
            subCellsTagValue = subCellsTagValue + 1

        }
        
        

        mTopbarImageView.alpha = 1
        mBottomToolBarImageView.alpha = 1

       
        
    }
    
    
    // MARK: - SPUserResizableView Delegate
    
    
    func delegateEditButtonPressedWithView(editorView: ImageEditorSubView!)
    {
        
        if editorView.typeString == "Shapes"
        {
            let shapesView = TeacherShapesView(frame:CGRectMake(0,0,self.frame.size.width, self.frame.size.height))
            self.addSubview(shapesView)
            shapesView.setdelegate(self)
            shapesView.tag = editorView.tag
            if editorView.getBinarayData() != nil
            {
                shapesView.mShapesView.unserialize(editorView.getBinarayData())
            }
            

            mTopbarImageView.alpha = 1
            mBottomToolBarImageView.alpha = 1
        }
        else if  editorView.typeString == "Equation"
        {
            let shapesView = TeacherMathView(frame:CGRectMake(0,0,self.frame.size.width, self.frame.size.height))
            self.addSubview(shapesView)
            shapesView.setdelegate(self)
            shapesView.tag = editorView.tag
            if editorView.getBinarayData() != nil
            {
                shapesView.mathView.unserialize(editorView.getBinarayData())
            }
            


            mTopbarImageView.alpha = 1
            mBottomToolBarImageView.alpha = 1
        }
    }
    
    
    func delegateDeleteDeleteButtonPressedWithView(editorView: ImageEditorSubView!)
    {
        editorView.removeFromSuperview()


        mTopbarImageView.alpha = 1
        mBottomToolBarImageView.alpha = 1

        
    }
    
    
    func delegateSelectPressedWithView(editorView: ImageEditorSubView!, withSelectedState selectedState: Bool)
    {
        
        
        
        
        let subViews = containerview.subviews.flatMap{ $0 as? ImageEditorSubView }
        
        for mSubView in subViews
        {
            if mSubView.isKindOfClass(ImageEditorSubView)
            {
                mSubView.hideHandles()
            }
        }
        
        
        if selectedState == true
        {


            mTopbarImageView.alpha = 0.2
            mBottomToolBarImageView.alpha = 0.2
            
            
        }
        else
        {


            mTopbarImageView.alpha = 1
            mBottomToolBarImageView.alpha = 1
        }
        
        

        
    }
    
    
    
    
         // MARK: - popover delegate
    
    func popoverControllerDidDismissPopover(popoverController: UIPopoverController)
    {

    }
    
    // MARK: - Smooth line delegate
    
    func setUndoButtonEnable(enable: NSNumber!)
    {
        if enable == 1
        {
            m_UndoButton.setImage(UIImage(named:"Undo_Active.png"),forState:.Normal);
            m_UndoButton.enabled = true
        }
        else
        {
            m_UndoButton.setImage(UIImage(named:"Undo_Disabled.png"),forState:.Normal);
            m_UndoButton.enabled = false
        }
        
    }
    
    func setRedoButtonEnable(enable: NSNumber!)
    {
        if enable == 1
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
    
    func lineDrawnChanged()
    {
        
    }
    
    
    // MARK: - Color popover delegate
    
    func selectedbrushSize(sender: AnyObject!, withSelectedTab tabTag: Int32)
    {
        
        if let progressView = sender as? UISlider
        {
            mScribbleView.setBrushWidth(Int32(progressView.value));
        }
        
        
    }
    
    func selectedColor(sender: AnyObject!, withSelectedTab tabTag: Int32)
    {
        if let progressColor = sender as? UIColor
        {
            mScribbleView.setDrawingColor(progressColor);
        }
    }

    
    
    
    
}