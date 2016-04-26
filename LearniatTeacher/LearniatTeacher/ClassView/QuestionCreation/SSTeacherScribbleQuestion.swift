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
    
     optional func delegateQuestionSentWithQuestionDetails(questionDetails:AnyObject)
    
    
}


class SSTeacherScribbleQuestion: UIView,UIPopoverControllerDelegate,SSTeacherDataSourceDelegate {
    
    
    
    let mSendButton = UIButton()
    
    let mCancelButton = UIButton()
    
    let m_BrushButton = UIButton()
    
    let m_EraserButton = UIButton()
    
    let m_RedoButton = UIButton()
    
    let m_UndoButton = UIButton()
    
    let bottomtoolSelectedImageView = UIImageView()
    
    let mQuestionNametextView   = SZTextView()
    
    let containerview = UIView()
    
    var mScribbleView : SmoothLineView!
    
    let kUplodingServer     = "http://54.251.104.13/Jupiter/upload_photos.php"
    
    let imageUploading = ImageUploading()
    
    var sendButtonSpinner : UIActivityIndicatorView!
    
    var _currentTopicId  = ""
    
    var currentQuestionId = ""
    
    var nameOfImage = ""
    
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
        
        let  mTopbarImageView = UIImageView(frame: CGRectMake(0, 0, self.frame.size.width, 70))
        mTopbarImageView.backgroundColor = topbarColor
        self.addSubview(mTopbarImageView)
        mTopbarImageView.userInteractionEnabled = true
        
        
        
        
        
        
        mQuestionNametextView.frame =  CGRectMake((mTopbarImageView.frame.size.width - 600) / 2, 20, 600, mTopbarImageView.frame.size.height - 40)
        
        
        mTopbarImageView.addSubview(mQuestionNametextView)
        mQuestionNametextView.font = UIFont(name: helveticaRegular, size: 16)
        mQuestionNametextView.textColor = blackTextColor
        mQuestionNametextView.textAlignment = .Left
        mQuestionNametextView.placeholder = "Question name"
        mQuestionNametextView.placeholderTextColor = lightGrayColor

        
        
        
        let bottomview = UIImageView(frame: CGRectMake(0, self.frame.size.height - 60, self.frame.size.width, 60))
        bottomview.backgroundColor = lightGrayTopBar
        self.addSubview(bottomview)
        bottomview.userInteractionEnabled = true
        
        mCancelButton.showsTouchWhenHighlighted = true;
        /* Add Cancel button target Cancel button should deselect all the selected submissions *defect 142 */
        mCancelButton.frame = CGRectMake(10 , 0, 100,  mTopbarImageView.frame.size.height);
        mTopbarImageView.addSubview(mCancelButton);
        mCancelButton.setTitle("Cancel", forState:.Normal);
        mCancelButton.setTitleColor(UIColor.whiteColor(), forState:.Normal);
        mCancelButton.titleLabel?.font = UIFont(name: helveticaMedium, size: 20);
        mCancelButton.contentHorizontalAlignment = UIControlContentHorizontalAlignment.Left
        mCancelButton.addTarget(self, action: #selector(StudentAnnotateView.onCancelButton), forControlEvents: UIControlEvents.TouchUpInside)
        
        
        mSendButton.frame = CGRectMake(mTopbarImageView.frame.size.width - 100 , 0, 100 , mTopbarImageView.frame.size.height );
        mTopbarImageView.addSubview(mSendButton);
        mSendButton.setTitle("Send", forState:.Normal);
        mSendButton.setTitleColor(UIColor.whiteColor(), forState:.Normal);
        mSendButton.titleLabel?.font = UIFont(name: helveticaMedium, size: 20);
        mSendButton.enabled = false
        mSendButton.highlighted = false;
        mSendButton.contentHorizontalAlignment = UIControlContentHorizontalAlignment.Center
        mSendButton.addTarget(self, action: #selector(StudentAnnotateView.onSendButton), forControlEvents: UIControlEvents.TouchUpInside)
        
        
        sendButtonSpinner = UIActivityIndicatorView(activityIndicatorStyle:.WhiteLarge);
        sendButtonSpinner.frame = mSendButton.frame;
        mTopbarImageView.addSubview(sendButtonSpinner);
        sendButtonSpinner.hidden = true;

        
        
        
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
        
        
        mScribbleView = SmoothLineView(frame: containerview.frame)
        mScribbleView.delegate = self
        self.addSubview(mScribbleView);
        mScribbleView.userInteractionEnabled = true
        mScribbleView.setDrawingColor(blackTextColor);
        mScribbleView.setBrushWidth(5)
        mScribbleView.setDrawingTool(kBrushTool)
        mScribbleView.hidden = false
        
        
        
       
       
        m_UndoButton.frame = CGRectMake(0, 0, bottomview.frame.size.height, bottomview.frame.size.height)
        m_UndoButton.setImage(UIImage(named:"Undo_Disabled.png"),forState:.Normal);
        bottomview.addSubview(m_UndoButton);
        m_UndoButton.imageView?.contentMode = .ScaleAspectFit
        m_UndoButton.addTarget(self, action: #selector(StudentAnnotateView.onUndoButton), forControlEvents: UIControlEvents.TouchUpInside)
        m_UndoButton.enabled = false
        
        bottomtoolSelectedImageView.backgroundColor = UIColor.whiteColor();
        bottomview.addSubview(bottomtoolSelectedImageView);
        bottomtoolSelectedImageView.layer.cornerRadius = 10.0;
        
        
        m_BrushButton.frame = CGRectMake((bottomview.frame.size.width/2) - (bottomview.frame.size.height + 10) ,5, bottomview.frame.size.height ,bottomview.frame.size.height - 10)
        m_BrushButton.setImage(UIImage(named:"Marker_Selected.png"), forState:.Normal)
        bottomview.addSubview(m_BrushButton);
        m_BrushButton.imageView?.contentMode = .ScaleAspectFit
        m_BrushButton.addTarget(self, action: #selector(StudentAnnotateView.onBrushButton), forControlEvents: UIControlEvents.TouchUpInside)
        bottomtoolSelectedImageView.frame = m_BrushButton.frame
        
        
        
        
        m_EraserButton.frame = CGRectMake((bottomview.frame.size.width/2) + 10  ,5, bottomview.frame.size.height ,bottomview.frame.size.height - 10)
        m_EraserButton.setImage(UIImage(named:"Eraser_Unselected.png"), forState:.Normal);
        bottomview.addSubview(m_EraserButton);
        m_EraserButton.imageView?.contentMode = .ScaleAspectFit
        m_EraserButton.addTarget(self, action: #selector(StudentAnnotateView.onEraserButton), forControlEvents: UIControlEvents.TouchUpInside)
        
        
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
    
    
    func setCurrentTopicId(topicId:String)
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
        
        sendButtonSpinner.hidden = false
        sendButtonSpinner.startAnimating()
        mSendButton.hidden = true
        
        
        if mScribbleView.curImage != nil
        {
            
            let currentDate = NSDate()
            
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = "yyyy-mm-dd HH:mm:ss"
            
            
            
            let currentDateString = dateFormatter.stringFromDate(currentDate)
            
            
             nameOfImage  = "TT-\(SSTeacherDataSource.sharedDataSource.currentUserId)-\(SSTeacherDataSource.sharedDataSource.currentLiveSessionId)-\(currentDateString)"
            nameOfImage =  nameOfImage.stringByReplacingOccurrencesOfString(" ", withString: "")
            
            
            imageUploading.uploadImageWithImage(mScribbleView.curImage, withImageName: nameOfImage, withUserId: SSTeacherDataSource.sharedDataSource.currentUserId)
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
        mSendButton.enabled = true;
        mSendButton.setTitleColor(UIColor.whiteColor(), forState:.Normal);
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

    
    // MARK: - ImageUploading delegate
    
    func ImageUploadedWithName(name: String!)
    {
//        newImageUploadedWithName(name)
//        currentTeacherImageURl = name
        
        SSTeacherDataSource.sharedDataSource.uploadTeacherScribble("upload/\(name).png", WithDelegate: self)
        
    }
    
    func ErrorInUploadingWithName(name: String!)
    {
        sendButtonSpinner.hidden = true
        sendButtonSpinner.stopAnimating()
        mSendButton.hidden = false
        mScribbleView.clearButtonClicked()
//        currentTeacherImageURl = ""
    }
    
    // MARK: - teacher datasource delegate
    
    func didGetScribbleUploadedWithDetaisl(details: AnyObject) {
     
        
        if mQuestionNametextView.text == nil
        {
            mQuestionNametextView.text = ""
        }
        
        if mQuestionNametextView.text.isEmpty
        {
            self.makeToast("Please type question name ", duration: 5.0, position: .Bottom)
        }
        else
        {
            if let ScribbleId = details.objectForKey("ScribbleId") as? String
            {
                SSTeacherDataSource.sharedDataSource.recordQuestionWithScribbleId(ScribbleId, withQuestionName: mQuestionNametextView.text, WithType: "4", withTopicId: _currentTopicId, WithDelegate: self)
            }
        }
        
        
        
        
    }
    
    func didGetQuestionRecordedWithDetaisl(details: AnyObject)
    {
        
       

        
        let questionDiconary = NSMutableDictionary()
        
        
        if let QuestionId = details.objectForKey("QuestionId") as? String
        {
             questionDiconary.setObject(QuestionId, forKey: "Id")
            
        }
        
        questionDiconary.setObject(mQuestionNametextView.text, forKey: "Name")
        questionDiconary.setObject("Overlay Scribble", forKey: "Type")
        questionDiconary.setObject("upload/\(nameOfImage).png", forKey: "Scribble")
       
        
        if delegate().respondsToSelector(#selector(SSTeacherScribbleQuestionDelegate.delegateQuestionSentWithQuestionDetails(_:)))
        {
            delegate().delegateQuestionSentWithQuestionDetails!(questionDiconary)
            
        }
        
        
        self.removeFromSuperview()
        
//        if let QuestionLogId = details.objectForKey("QuestionLogId") as? String
//        {
//            SSTeacherDataSource.sharedDataSource.fetchQuestionWithQuestionLogId(QuestionLogId, WithDelegate: self)
//        }
        
        
        
        
    }
    
    func didGetQuestionWithDetails(details: AnyObject)
    {
        
        
        if let status = details.objectForKey("Status") as? String
        {
            if status == "Success"
            {
                if delegate().respondsToSelector(#selector(SSTeacherScribbleQuestionDelegate.delegateQuestionSentWithQuestionDetails(_:)))
                {
                    delegate().delegateQuestionSentWithQuestionDetails!(details)
                    
                }
            }
        }
    }
    
    
    
}