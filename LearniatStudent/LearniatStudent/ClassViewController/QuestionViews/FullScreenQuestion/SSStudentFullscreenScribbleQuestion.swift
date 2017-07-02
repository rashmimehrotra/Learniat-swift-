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
    
    @objc optional func delegateFullScreenSendButtonPressedWithImage(_ writtenImage:UIImage)
    
    
}


class SSStudentFullscreenScribbleQuestion: UIView,UIPopoverControllerDelegate, ImageEditorSubViewDelegate
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
    
    var questionText = UILabel()
    
    
    func setdelegate(_ delegate:AnyObject)
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
        
        mTopbarImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: self.frame.size.width, height: 70))
        mTopbarImageView.backgroundColor = whiteColor
        self.addSubview(mTopbarImageView)
        mTopbarImageView.isUserInteractionEnabled = true
        
        
        
        
        
        
        
        
        
        
        
        mBottomToolBarImageView = UIImageView(frame: CGRect(x: 0, y: self.frame.size.height - 60, width: self.frame.size.width, height: 60))
        mBottomToolBarImageView.backgroundColor = lightGrayTopBar
        self.addSubview(mBottomToolBarImageView)
        mBottomToolBarImageView.isUserInteractionEnabled = true
        
        mCancelButton.showsTouchWhenHighlighted = true;
        /* Add Cancel button target Cancel button should deselect all the selected submissions *defect 142 */
        mCancelButton.frame = CGRect(x: 10 , y: 0, width: 100,  height: mTopbarImageView.frame.size.height);
        mTopbarImageView.addSubview(mCancelButton);
        mCancelButton.setTitle("Back", for:UIControlState());
        mCancelButton.setTitleColor(standard_Button, for:UIControlState());
        
        mCancelButton.titleLabel?.font = UIFont(name: helveticaMedium, size: 20);
        mCancelButton.contentHorizontalAlignment = UIControlContentHorizontalAlignment.left
        mCancelButton.addTarget(self, action: #selector(SSStudentFullscreenScribbleQuestion.onCancelButton), for: UIControlEvents.touchUpInside)
        
        
      

        
        
        mSendButton.frame = CGRect(x: mTopbarImageView.frame.size.width - 100 , y: 0, width: 100 , height: mTopbarImageView.frame.size.height );
        mTopbarImageView.addSubview(mSendButton);
        mSendButton.setTitle("Done", for:UIControlState());
        mSendButton.setTitleColor(standard_Button, for:UIControlState());
        mSendButton.titleLabel?.font = UIFont(name: helveticaMedium, size: 20);
        mSendButton.isEnabled = true
        mSendButton.isHighlighted = false;
        mSendButton.contentHorizontalAlignment = UIControlContentHorizontalAlignment.center
        mSendButton.addTarget(self, action: #selector(SSStudentFullscreenScribbleQuestion.onSendButton), for: UIControlEvents.touchUpInside)
        
        
        let remainSpaceForQuestion = self.frame.size.width - (mCancelButton.frame.origin.x + mCancelButton.frame.size.width + 20 + mSendButton.frame.size.width)
        
        questionText.frame = CGRect(x: (mCancelButton.frame.origin.x + mCancelButton.frame.size.width + 10), y: 0, width: remainSpaceForQuestion,height: mTopbarImageView.frame.size.height)
        questionText.font = UIFont(name:HelveticaNeueItalic, size: 22)
        questionText.text = ""
        self.addSubview(questionText)
        questionText.textColor = topbarColor
        questionText.textAlignment = .center
        questionText.lineBreakMode = .byTruncatingMiddle
        
        
        sendButtonSpinner = UIActivityIndicatorView(activityIndicatorStyle:.whiteLarge);
        sendButtonSpinner.frame = mSendButton.frame;
        mTopbarImageView.addSubview(sendButtonSpinner);
        sendButtonSpinner.isHidden = true;

        
        
        
        var contanerHeight  = mTopbarImageView.frame.origin.y + mTopbarImageView.frame.size.height + mBottomToolBarImageView.frame.size.height + 20
        contanerHeight = self.frame.size.height - contanerHeight
        
        
        
        contanerBackgroundView.frame = CGRect(x: (self.frame.size.width - (contanerHeight * kAspectRation)) / 2 , y: mTopbarImageView.frame.origin.y + mTopbarImageView.frame.size.height + 10 ,  width: contanerHeight * kAspectRation ,height: contanerHeight)
          contanerBackgroundView.backgroundColor = UIColor.white
        self.addSubview(contanerBackgroundView)
        contanerBackgroundView.layer.shadowColor = progressviewBackground.cgColor;
        contanerBackgroundView.layer.shadowOffset = CGSize(width: 0,height: 0);
        contanerBackgroundView.layer.shadowOpacity = 1;
        contanerBackgroundView.layer.shadowRadius = 1.0;
        contanerBackgroundView.clipsToBounds = false;
        
        
        
        mOverlayView.frame = CGRect(x: 0,y: 0,width: contanerBackgroundView.frame.size.width, height: contanerBackgroundView.frame.size.height)
        contanerBackgroundView.addSubview(mOverlayView);
        
        
        
        containerview.frame = CGRect(x: 0,y: 0,width: contanerBackgroundView.frame.size.width, height: contanerBackgroundView.frame.size.height)
       contanerBackgroundView.addSubview(containerview);
        
      
        
        
        mScribbleView = SmoothLineView(frame: CGRect(x: 0,y: 0,width: containerview.frame.size.width, height: containerview.frame.size.height))
        mScribbleView.delegate = self
        containerview.addSubview(mScribbleView);
        mScribbleView.isUserInteractionEnabled = true
        mScribbleView.setDrawing(blackTextColor);
        mScribbleView.setBrushWidth(5)
        mScribbleView.setDrawing(kBrushTool)
        var brushSize = UserDefaults.standard.float(forKey: "selectedBrushsize")
        if brushSize < 5
        {
            brushSize = 5
        }
        mScribbleView.setBrushWidth(Int32(brushSize))
        mScribbleView.isHidden = false
        
        
        
       
       
        m_UndoButton.frame = CGRect(x: 0, y: 0, width: mBottomToolBarImageView.frame.size.height, height: mBottomToolBarImageView.frame.size.height)
        m_UndoButton.setImage(UIImage(named:"Undo_Disabled.png"),for:UIControlState());
        mBottomToolBarImageView.addSubview(m_UndoButton);
        m_UndoButton.imageView?.contentMode = .scaleAspectFit
        m_UndoButton.addTarget(self, action: #selector(SSStudentFullscreenScribbleQuestion.onUndoButton), for: UIControlEvents.touchUpInside)
        m_UndoButton.isEnabled = false
        
        bottomtoolSelectedImageView.backgroundColor = UIColor.white;
        mBottomToolBarImageView.addSubview(bottomtoolSelectedImageView);
        
        
        m_BrushButton.frame = CGRect(x: (mBottomToolBarImageView.frame.size.width/2) - (mBottomToolBarImageView.frame.size.height + 10) ,y: 5, width: mBottomToolBarImageView.frame.size.height ,height: mBottomToolBarImageView.frame.size.height - 10)
        m_BrushButton.setImage(UIImage(named:"Marker_Selected.png"), for:UIControlState())
        mBottomToolBarImageView.addSubview(m_BrushButton);
        m_BrushButton.imageView?.contentMode = .scaleAspectFit
        m_BrushButton.addTarget(self, action: #selector(SSStudentFullscreenScribbleQuestion.onBrushButton), for: UIControlEvents.touchUpInside)
        bottomtoolSelectedImageView.frame = m_BrushButton.frame
        
        
        
        
        m_EraserButton.frame = CGRect(x: (mBottomToolBarImageView.frame.size.width/2) + 10  ,y: 5, width: mBottomToolBarImageView.frame.size.height ,height: mBottomToolBarImageView.frame.size.height - 10)
        m_EraserButton.setImage(UIImage(named:"Eraser_Unselected.png"), for:UIControlState());
        mBottomToolBarImageView.addSubview(m_EraserButton);
        m_EraserButton.imageView?.contentMode = .scaleAspectFit
        m_EraserButton.addTarget(self, action: #selector(SSStudentFullscreenScribbleQuestion.onEraserButton), for: UIControlEvents.touchUpInside)
        
        
        m_RedoButton.frame = CGRect(x: mBottomToolBarImageView.frame.size.width - mBottomToolBarImageView.frame.size.height ,y: 0, width: mBottomToolBarImageView.frame.size.height ,height: mBottomToolBarImageView.frame.size.height)
        m_RedoButton.setImage(UIImage(named:"Redo_Disabled.png"), for:UIControlState());
        mBottomToolBarImageView.addSubview(m_RedoButton);
        m_RedoButton.imageView?.contentMode = .scaleAspectFit
        m_RedoButton.addTarget(self, action: #selector(SSStudentFullscreenScribbleQuestion.onRedoButton), for: UIControlEvents.touchUpInside)
        m_RedoButton.isEnabled = false
        
        
        
        
    }
    
    
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
        
        
    }
    
    func setOverlayImage(_ _overlay :UIImage)
    {
        
        mOverlayView.image = _overlay
    }
    
    func setCurrentTopicId(_ topicId:String)
    {
        _currentTopicId = topicId
    }
    
    
     // MARK: - Buttons Function
    
    func onCancelButton()
    {
       
        self.isHidden = true
        
    }
    
    func onSendButton()
    {
        
        
        
        let image = UIImage.renderUIViewToImage(containerview)
        
        
        delegate().delegateFullScreenSendButtonPressedWithImage!(image)
        
    }
    
    func getCurrentImage()->UIImage
    {
        let image = UIImage.renderUIViewToImage(containerview)
        
        return image
    }
    
    
    func onUndoButton()
    {
        mScribbleView.undoButtonClicked()
    }
    
    func onBrushButton()
    {
        
        
        
        if bottomtoolSelectedImageView.frame == m_BrushButton.frame
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
        
        bottomtoolSelectedImageView.frame = m_BrushButton.frame
        m_BrushButton.setImage(UIImage(named:"Marker_Selected.png"), for:UIControlState())
        m_EraserButton.setImage(UIImage(named:"Eraser_Unselected.png"), for:UIControlState())
        mScribbleView.setDrawing(kBrushTool)
        var brushSize = UserDefaults.standard.float(forKey: "selectedBrushsize")
        if brushSize < 5
        {
            brushSize = 5
        }
        mScribbleView.setBrushWidth(Int32(brushSize))
        
        
        
        
        
        
    }
    
    func onEraserButton()
    {
        
        
        if bottomtoolSelectedImageView.frame == m_EraserButton.frame
        {
            
            let buttonPosition :CGPoint = m_EraserButton.convert(CGPoint.zero, to: self)
            
            
            let colorSelectContoller = colorpopOverViewController()
            colorSelectContoller.setSelectTab(2);
            colorSelectContoller.setDelegate(self);
            colorSelectContoller.setRect(CGRect(x: 0,y: 0,width: 200,height: 200));
            
            
            colorSelectContoller.title = "Eraser Size & Colour";
            
            let navController = UINavigationController(rootViewController:colorSelectContoller)
            
            let colorPopoverController = UIPopoverController(contentViewController:navController);
            colorPopoverController.contentSize = CGSize(width: 200, height: 150);
            colorPopoverController.delegate = self;
            colorSelectContoller.setPopOver(colorPopoverController);
            
            colorPopoverController.present(from: CGRect(x: buttonPosition.x  + (m_EraserButton.frame.size.width/2),y: buttonPosition.y,width: 1,height: 1), in: self, permittedArrowDirections: .down, animated: true)
            
        }
        
        
        
        
        bottomtoolSelectedImageView.frame = m_EraserButton.frame
        m_BrushButton.setImage(UIImage(named:"Marker_Unselected.png"), for:UIControlState())
        m_EraserButton.setImage(UIImage(named:"Eraser_Selected.png"), for:UIControlState())
        mScribbleView.setDrawing(kEraserTool)
        let eraserSize = UserDefaults.standard.float(forKey: "selectedEraserSize")
        mScribbleView.setBrushWidth(Int32(eraserSize))
        
        
        
        
        
        
        
        
        
    }
    
    func onRedoButton()
    {
        mScribbleView.redoButtonClicked()
    }
    
    func onEquationButton()
    {
//        let mathView = TeacherMathView(frame:CGRect(x: 0,y: 0,width: self.frame.size.width, height: self.frame.size.height))
//       
//        mathView.setdelegate(self)
//         self.addSubview(mathView)
    }
    
    func onShapesButton()
    {
//        let shapesView = TeacherShapesView(frame:CGRect(x: 0,y: 0,width: self.frame.size.width, height: self.frame.size.height))
//        self.addSubview(shapesView)
//        shapesView.setdelegate(self)
    }
    
    
    // MARK: - Shapes delegate
    
    func delegateShapesImages(_ image: UIImage, withBinaryData binaryData: Data, withtagValue tagValue: Int, withType type: String) {
        
        
        let imageView = UIImageView()
        imageView.image = image
        imageView.contentMode = .scaleAspectFit;
        imageView.isUserInteractionEnabled = true
        
        
        var shapeSize:CGSize = image.size;
        
        if (shapeSize.width < 100)
        {
            shapeSize = CGSize(width: 100, height: shapeSize.height);
        }
        if (shapeSize.height < 100)
        {
            shapeSize = CGSize(width: shapeSize.width, height: 100);
        }
        
        
        imageView.frame = CGRect(x: 0,y: 0, width: shapeSize.width, height: shapeSize.height);
        
        
        
        if let shapesImage = containerview.viewWithTag(tagValue) as? ImageEditorSubView
        {
             shapesImage.frame = imageView.frame
            shapesImage.setContentImage(imageView, with: image)
            shapesImage.setBinaryValue(binaryData)
            shapesImage.typeString = type
        }
        
        else
        {
            let shapesImage = ImageEditorSubView(frame:imageView.frame)
            containerview.addSubview(shapesImage)
            shapesImage.setdelegate(self)
            shapesImage.setContentImage(imageView, with: image)
            shapesImage.setBinaryValue(binaryData)
            shapesImage.typeString = type
            shapesImage.tag = subCellsTagValue
            subCellsTagValue = subCellsTagValue + 1

        }
        
        

        mTopbarImageView.alpha = 1
        mBottomToolBarImageView.alpha = 1

       
        
    }
    
    
    // MARK: - SPUserResizableView Delegate
    
    
    func delegateEditButtonPressed(with editorView: ImageEditorSubView!)
    {
        /*
        if editorView.typeString == "Shapes"
        {
            let shapesView = TeacherShapesView(frame:CGRect(x: 0,y: 0,width: self.frame.size.width, height: self.frame.size.height))
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
            let shapesView = TeacherMathView(frame:CGRect(x: 0,y: 0,width: self.frame.size.width, height: self.frame.size.height))
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
 
 */
    }
    
    
    func delegateDeleteDeleteButtonPressed(with editorView: ImageEditorSubView!)
    {
        editorView.removeFromSuperview()


        mTopbarImageView.alpha = 1
        mBottomToolBarImageView.alpha = 1

        
    }
    
    
    func delegateSelectPressed(with editorView: ImageEditorSubView!, withSelectedState selectedState: Bool)
    {
        
        
        
        
        let subViews = containerview.subviews.flatMap{ $0 as? ImageEditorSubView }
        
        for mSubView in subViews
        {
            if mSubView.isKind(of: ImageEditorSubView.self)
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
    
    func popoverControllerDidDismissPopover(_ popoverController: UIPopoverController)
    {

    }
    
    // MARK: - Smooth line delegate
    
    func setUndoButtonEnable(_ enable: NSNumber!)
    {
        if enable == 1
        {
            m_UndoButton.setImage(UIImage(named:"Undo_Active.png"),for:UIControlState());
            m_UndoButton.isEnabled = true
        }
        else
        {
            m_UndoButton.setImage(UIImage(named:"Undo_Disabled.png"),for:UIControlState());
            m_UndoButton.isEnabled = false
        }
        
    }
    
    func setRedoButtonEnable(_ enable: NSNumber!)
    {
        if enable == 1
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
    
    func lineDrawnChanged()
    {
        
    }
    
    
    // MARK: - Color popover delegate
    
    func selectedbrushSize(_ sender: AnyObject!, withSelectedTab tabTag: Int32)
    {
        
        if let progressView = sender as? UISlider
        {
            mScribbleView.setBrushWidth(Int32(progressView.value));
        }
        
        
    }
    
    func selectedColor(_ sender: AnyObject!, withSelectedTab tabTag: Int32)
    {
        if let progressColor = sender as? UIColor
        {
            mScribbleView.setDrawing(progressColor);
        }
    }

    
    
    
    
}
