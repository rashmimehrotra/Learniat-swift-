//
//  SSTeacherScribbleQuestion.swift
//  LearniatTeacher
//
//  Created by Deepak MK on 21/04/16.
//  Copyright © 2016 Mindshift. All rights reserved.
//

import Foundation
@objc protocol SSTeacherScribbleQuestionDelegate
{
    
     @objc optional func delegateQuestionSentWithQuestionDetails(_ questionDetails:AnyObject)
    
    
}


class SSTeacherScribbleQuestion: UIView,UIPopoverControllerDelegate,SSTeacherDataSourceDelegate, ImageEditorSubViewDelegate
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
    
    var mQuestionNametextView   = CustomTextView()
    
    let containerview = UIView()
    
    var mScribbleView : SmoothLineView!
    
    let kUplodingServer     = "http://54.251.104.13/Jupiter/upload_photos.php"
    
    let imageUploading = ImageUploading()
    
    var sendButtonSpinner : UIActivityIndicatorView!
    
    var _currentTopicId  = ""
    
    var currentQuestionId = ""
    
    var nameOfImage = ""
    
    var subCellsTagValue = 1000
    
    var _delgate: AnyObject!
    
    
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
        mTopbarImageView.backgroundColor = topbarColor
        self.addSubview(mTopbarImageView)
        mTopbarImageView.isUserInteractionEnabled = true
        
        
        
        
        
        
        mQuestionNametextView =  CustomTextView(frame:CGRect(x: (mTopbarImageView.frame.size.width - 600) / 2, y: 20, width: 600, height: mTopbarImageView.frame.size.height - 30))
        mQuestionNametextView.setdelegate(self)
         mQuestionNametextView.setPlaceHolder("Please type Question text", withStartSting: "Question:-")
        mTopbarImageView.addSubview(mQuestionNametextView)


        
        
        
        mBottomToolBarImageView = UIImageView(frame: CGRect(x: 0, y: self.frame.size.height - 60, width: self.frame.size.width, height: 60))
        mBottomToolBarImageView.backgroundColor = lightGrayTopBar
        self.addSubview(mBottomToolBarImageView)
        mBottomToolBarImageView.isUserInteractionEnabled = true
        
        mCancelButton.showsTouchWhenHighlighted = true;
        /* Add Cancel button target Cancel button should deselect all the selected submissions *defect 142 */
        mCancelButton.frame = CGRect(x: 10 , y: 0, width: 100,  height: mTopbarImageView.frame.size.height);
        mTopbarImageView.addSubview(mCancelButton);
        mCancelButton.setTitle("Cancel", for:UIControlState());
        mCancelButton.setTitleColor(UIColor.white, for:UIControlState());
        mCancelButton.titleLabel?.font = UIFont(name: helveticaMedium, size: 20);
        mCancelButton.contentHorizontalAlignment = UIControlContentHorizontalAlignment.left
        mCancelButton.addTarget(self, action: #selector(StudentAnnotateView.onCancelButton), for: UIControlEvents.touchUpInside)
        
        
        mSendButton.frame = CGRect(x: mTopbarImageView.frame.size.width - 100 , y: 0, width: 100 , height: mTopbarImageView.frame.size.height );
        mTopbarImageView.addSubview(mSendButton);
        mSendButton.setTitle("Send", for:UIControlState());
        mSendButton.setTitleColor(UIColor.white, for:UIControlState());
        mSendButton.titleLabel?.font = UIFont(name: helveticaMedium, size: 20);
        mSendButton.isEnabled = false
        mSendButton.isHighlighted = false;
        mSendButton.contentHorizontalAlignment = UIControlContentHorizontalAlignment.center
        mSendButton.addTarget(self, action: #selector(StudentAnnotateView.onSendButton), for: UIControlEvents.touchUpInside)
        
        
        sendButtonSpinner = UIActivityIndicatorView(activityIndicatorStyle:.whiteLarge);
        sendButtonSpinner.frame = mSendButton.frame;
        mTopbarImageView.addSubview(sendButtonSpinner);
        sendButtonSpinner.isHidden = true;

        
        
        
        var contanerHeight  = mTopbarImageView.frame.origin.y + mTopbarImageView.frame.size.height + mBottomToolBarImageView.frame.size.height + 20
        contanerHeight = self.frame.size.height - contanerHeight
        
        containerview.frame = CGRect(x: (self.frame.size.width - (contanerHeight * kAspectRation)) / 2 , y: mTopbarImageView.frame.origin.y + mTopbarImageView.frame.size.height + 10 ,  width: contanerHeight * kAspectRation ,height: contanerHeight)
        containerview.backgroundColor = UIColor.white
        self.addSubview(containerview);
        containerview.layer.shadowColor = progressviewBackground.cgColor;
        containerview.layer.shadowOffset = CGSize(width: 0,height: 0);
        containerview.layer.shadowOpacity = 1;
        containerview.layer.shadowRadius = 1.0;
        containerview.clipsToBounds = false;
        
        
        mScribbleView = SmoothLineView(frame: CGRect(x: 0,y: 0,width: containerview.frame.size.width, height: containerview.frame.size.height))
        mScribbleView.delegate = self
        containerview.addSubview(mScribbleView);
        mScribbleView.isUserInteractionEnabled = true
        mScribbleView.setDrawing(blackTextColor);
        mScribbleView.setBrushWidth(5)
        mScribbleView.setDrawing(kBrushTool)
        mScribbleView.isHidden = false
        
        
        
       
       
        m_UndoButton.frame = CGRect(x: 0, y: 0, width: mBottomToolBarImageView.frame.size.height, height: mBottomToolBarImageView.frame.size.height)
        m_UndoButton.setImage(UIImage(named:"Undo_Disabled.png"),for:UIControlState());
        mBottomToolBarImageView.addSubview(m_UndoButton);
        m_UndoButton.imageView?.contentMode = .scaleAspectFit
        m_UndoButton.addTarget(self, action: #selector(StudentAnnotateView.onUndoButton), for: UIControlEvents.touchUpInside)
        m_UndoButton.isEnabled = false
        
        bottomtoolSelectedImageView.backgroundColor = UIColor.white;
        mBottomToolBarImageView.addSubview(bottomtoolSelectedImageView);
        bottomtoolSelectedImageView.layer.cornerRadius = 10.0;
        
        
        m_BrushButton.frame = CGRect(x: (mBottomToolBarImageView.frame.size.width/2) - (mBottomToolBarImageView.frame.size.height + 10) ,y: 5, width: mBottomToolBarImageView.frame.size.height ,height: mBottomToolBarImageView.frame.size.height - 10)
        m_BrushButton.setImage(UIImage(named:"Marker_Selected.png"), for:UIControlState())
        mBottomToolBarImageView.addSubview(m_BrushButton);
        m_BrushButton.imageView?.contentMode = .scaleAspectFit
        m_BrushButton.addTarget(self, action: #selector(StudentAnnotateView.onBrushButton), for: UIControlEvents.touchUpInside)
        bottomtoolSelectedImageView.frame = m_BrushButton.frame
        
        
        
        
        m_EraserButton.frame = CGRect(x: (mBottomToolBarImageView.frame.size.width/2) + 10  ,y: 5, width: mBottomToolBarImageView.frame.size.height ,height: mBottomToolBarImageView.frame.size.height - 10)
        m_EraserButton.setImage(UIImage(named:"Eraser_Unselected.png"), for:UIControlState());
        mBottomToolBarImageView.addSubview(m_EraserButton);
        m_EraserButton.imageView?.contentMode = .scaleAspectFit
        m_EraserButton.addTarget(self, action: #selector(StudentAnnotateView.onEraserButton), for: UIControlEvents.touchUpInside)
        
        
        m_RedoButton.frame = CGRect(x: mBottomToolBarImageView.frame.size.width - mBottomToolBarImageView.frame.size.height ,y: 0, width: mBottomToolBarImageView.frame.size.height ,height: mBottomToolBarImageView.frame.size.height)
        m_RedoButton.setImage(UIImage(named:"Redo_Disabled.png"), for:UIControlState());
        mBottomToolBarImageView.addSubview(m_RedoButton);
        m_RedoButton.imageView?.contentMode = .scaleAspectFit
        m_RedoButton.addTarget(self, action: #selector(StudentAnnotateView.onRedoButton), for: UIControlEvents.touchUpInside)
        m_RedoButton.isEnabled = false
        
        
        
        
//        let  mEquationButton = UIButton(frame: CGRect(x: m_RedoButton.frame.origin.x - 140,  y: bottomtoolSelectedImageView.frame.origin.y,width: 130 ,height: bottomtoolSelectedImageView.frame.size.height))
//        mBottomToolBarImageView.addSubview(mEquationButton)
//        mEquationButton.addTarget(self, action: #selector(SSTeacherScribbleQuestion.onEquationButton), for: UIControlEvents.touchUpInside)
//        mEquationButton.imageView?.contentMode = .scaleAspectFit
//        mEquationButton.setTitle("Equation", for: UIControlState())
//        mEquationButton.setTitleColor(standard_Button, for: UIControlState())
//         mEquationButton.contentHorizontalAlignment = UIControlContentHorizontalAlignment.right
//        mEquationButton.titleLabel?.font = UIFont(name: helveticaMedium, size: 18);
//        
//        let mEquationImage = UIImageView(frame:CGRect(x: 10, y: 10, width: mEquationButton.frame.size.height - 20 ,height: mEquationButton.frame.size.height - 20 ))
//        mEquationImage.image = UIImage(named: "Equation.png")
//        mEquationImage.contentMode = .scaleAspectFit
//        mEquationButton.addSubview(mEquationImage)
        
        
        
        
        
//        let  mShapesButton = UIButton(frame: CGRect(x: mEquationButton.frame.origin.x - 120,  y: bottomtoolSelectedImageView.frame.origin.y,width: 110 ,height: bottomtoolSelectedImageView.frame.size.height  ))
//        mBottomToolBarImageView.addSubview(mShapesButton)
//        mShapesButton.addTarget(self, action: #selector(SSTeacherScribbleQuestion.onShapesButton), for: UIControlEvents.touchUpInside)
//        mShapesButton.imageView?.contentMode = .scaleAspectFit
//        mShapesButton.setTitle("Shapes", for: UIControlState())
//        mShapesButton.setTitleColor(standard_Button, for: UIControlState())
//        mShapesButton.contentHorizontalAlignment = UIControlContentHorizontalAlignment.right
//        mShapesButton.titleLabel?.font = UIFont(name: helveticaMedium, size: 18)
//        
//        let mShapesImage = UIImageView(frame:CGRect(x: 10, y: 10, width: mShapesButton.frame.size.height - 20 ,height: mShapesButton.frame.size.height - 20 ))
//        mShapesImage.image = UIImage(named: "Shapes.png")
//        mShapesImage.contentMode = .scaleAspectFit
//        mShapesButton.addSubview(mShapesImage)
        
        
        
        
        
        
        
        
    }
    
    
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
        
        
    }
    
    
    func setCurrentTopicId(_ topicId:String)
    {
        _currentTopicId = topicId
    }
    
    
     // MARK: - Buttons Function
    
    func onCancelButton()
    {
       
        self.removeFromSuperview()
        
    }
    
    func onSendButton()
    {
        
        
        
        let image = UIImage.imageWithView(containerview)
        
        
         let subViews = containerview.subviews.flatMap{ $0 as? ImageEditorSubView }
        
        if (mQuestionNametextView.mQuestionTextView.text?.isEmpty)!
        {
            self.makeToast("Please type question name ", duration: 5.0, position: .bottom)
        }
        else if mScribbleView.curImage != nil || subViews.count >= 0
        {
            
            sendButtonSpinner.isHidden = false
            sendButtonSpinner.startAnimating()
            mSendButton.isHidden = true

            
            let currentDate = Date()
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-mm-dd HH:mm:ss"
            
            
            
            let currentDateString = dateFormatter.string(from: currentDate)
            
             let imagePathString = SSTeacherDataSource.sharedDataSource.currentUserId.appending("-").appending(SSTeacherDataSource.sharedDataSource.currentLiveSessionId).appending("-").appending(currentDateString)
            
             nameOfImage  = "TT-".appending(imagePathString)
            
            nameOfImage =  nameOfImage.replacingOccurrences(of: " ", with: "")
            
            
            imageUploading.uploadImage(with: image, withImageName: nameOfImage, withUserId: SSTeacherDataSource.sharedDataSource.currentUserId)
        }
        else
        {
            
        }
        
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
        
        
        mTopbarImageView.isUserInteractionEnabled  = true
        mBottomToolBarImageView.isUserInteractionEnabled = true
        mTopbarImageView.alpha = 1
        mBottomToolBarImageView.alpha = 1
        mSendButton.isEnabled = true
       
        
    }
    
    
    // MARK: - SPUserResizableView Delegate
    
    
    func delegateEditButtonPressed(with editorView: ImageEditorSubView!)
    {
        
//        if editorView.typeString == "Shapes"
//        {
//            let shapesView = TeacherShapesView(frame:CGRect(x: 0,y: 0,width: self.frame.size.width, height: self.frame.size.height))
//            self.addSubview(shapesView)
//            shapesView.setdelegate(self)
//            shapesView.tag = editorView.tag
//            if editorView.getBinarayData() != nil
//            {
//                shapesView.mShapesView.unserialize(editorView.getBinarayData())
//            }
//            
//            mTopbarImageView.isUserInteractionEnabled  = true
//            mBottomToolBarImageView.isUserInteractionEnabled = true
//            mTopbarImageView.alpha = 1
//            mBottomToolBarImageView.alpha = 1
//        }
//        else if  editorView.typeString == "Equation"
//        {
//            let shapesView = TeacherMathView(frame:CGRect(x: 0,y: 0,width: self.frame.size.width, height: self.frame.size.height))
//            self.addSubview(shapesView)
//            shapesView.setdelegate(self)
//            shapesView.tag = editorView.tag
//            if editorView.getBinarayData() != nil
//            {
//                shapesView.mathView.unserialize(editorView.getBinarayData())
//            }
//            
//            mTopbarImageView.isUserInteractionEnabled  = true
//            mBottomToolBarImageView.isUserInteractionEnabled = true
//            mTopbarImageView.alpha = 1
//            mBottomToolBarImageView.alpha = 1
//        }
    }
    
    
    func delegateDeleteDeleteButtonPressed(with editorView: ImageEditorSubView!)
    {
        editorView.removeFromSuperview()
        mTopbarImageView.isUserInteractionEnabled  = true
        mBottomToolBarImageView.isUserInteractionEnabled = true
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
            mTopbarImageView.isUserInteractionEnabled  = false
            mBottomToolBarImageView.isUserInteractionEnabled = false
            mTopbarImageView.alpha = 0.2
            mBottomToolBarImageView.alpha = 0.2
            
            
        }
        else
        {
            mTopbarImageView.isUserInteractionEnabled  = true
            mBottomToolBarImageView.isUserInteractionEnabled = true
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
        mSendButton.isEnabled = true;
        mSendButton.setTitleColor(UIColor.white, for:UIControlState());
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

    
    // MARK: - ImageUploading delegate
    
    func ImageUploadedWithName(_ name: String!)
    {
//        newImageUploadedWithName(name)
//        currentTeacherImageURl = name
        
        SSTeacherDataSource.sharedDataSource.uploadTeacherScribble("upload/".appending(name).appending(".png"), WithDelegate: self)
        
    }
    
    func ErrorInUploadingWithName(_ name: String!)
    {
        sendButtonSpinner.isHidden = true
        sendButtonSpinner.stopAnimating()
        mSendButton.isHidden = false
        mScribbleView.clearButtonClicked()
//        currentTeacherImageURl = ""
    }
    
    // MARK: - teacher datasource delegate
    
    func didGetScribbleUploadedWithDetaisl(_ details: AnyObject) {
     
        
        if mQuestionNametextView.mQuestionTextView.text == nil
        {
            mQuestionNametextView.mQuestionTextView.text = ""
        }
        
        if (mQuestionNametextView.mQuestionTextView.text?.isEmpty)!
        {
            self.makeToast("Please type question name ", duration: 5.0, position: .bottom)
        }
        else
        {
            if let ScribbleId = details.object(forKey: "ScribbleId") as? String
            {
                SSTeacherDataSource.sharedDataSource.recordQuestionWithScribbleId(ScribbleId, withQuestionName: mQuestionNametextView.mQuestionTextView.text!, WithType: "4", withTopicId: _currentTopicId, WithDelegate: self)
            }
        }
        
        
        
        
    }
    
    func didGetQuestionRecordedWithDetaisl(_ details: AnyObject)
    {
        
       

        
        let questionDiconary = NSMutableDictionary()
        
        
        if let QuestionId = details.object(forKey: "QuestionId") as? String
        {
             questionDiconary.setObject(QuestionId, forKey: "Id" as NSCopying)
            
        }
        
        questionDiconary.setObject(mQuestionNametextView.mQuestionTextView.text, forKey: "Name" as NSCopying)
        questionDiconary.setObject(kOverlayScribble, forKey: kQuestionType as NSCopying)
        questionDiconary.setObject("upload/".appending(nameOfImage).appending(".png"), forKey: "Scribble" as NSCopying)
       
        
        if delegate().responds(to: #selector(SSTeacherScribbleQuestionDelegate.delegateQuestionSentWithQuestionDetails(_:)))
        {
            delegate().delegateQuestionSentWithQuestionDetails!(questionDiconary)
            
        }
        
        
        self.removeFromSuperview()
        
//        if let QuestionLogId = details.objectForKey("QuestionLogId") as? String
//        {
//            SSTeacherDataSource.sharedDataSource.fetchQuestionWithQuestionLogId(QuestionLogId, WithDelegate: self)
//        }
        
        
        
        
    }
    
    func didGetQuestionWithDetails(_ details: AnyObject)
    {
        
        
        if let status = details.object(forKey: "Status") as? String
        {
            if status == "Success"
            {
                if delegate().responds(to: #selector(SSTeacherScribbleQuestionDelegate.delegateQuestionSentWithQuestionDetails(_:)))
                {
                    delegate().delegateQuestionSentWithQuestionDetails!(details)
                    
                }
            }
        }
    }
    
    
    
}
