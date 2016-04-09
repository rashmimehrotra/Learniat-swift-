//
//  SubmissionSubjectiveView.swift
//  LearniatTeacher
//
//  Created by Deepak MK on 07/04/16.
//  Copyright © 2016 Mindshift. All rights reserved.
//

import Foundation

let kAspectRation:CGFloat = 1.5

class SubmissionSubjectiveView: UIView,SmoothLineViewdelegate, SubjectiveLeftSideViewDelegate,SSStarRatingViewDelegate,UIPopoverControllerDelegate,SSTeacherDataSourceDelegate
{
    var _delgate: AnyObject!
    
    var _currentQuestionDetials:AnyObject!
    
    var subjectiveCellContainer :SubjectiveLeftSideView!
    
    func setdelegate(delegate:AnyObject)
    {
        _delgate = delegate;
    }
    
    func   delegate()->AnyObject
    {
        return _delgate;
    }
    
    
    
    var mainContainerView = UIView()
    
    let topImageView = UIImageView()
    
    let mCancelButton = UIButton()
    
    let mMarkModelButton = UIButton()
    
    let mStarRatingView = SSStarRatingView()
    
    let mSendButton = UIButton()
    
    let containerview = UIView()
    
    let overlayimageView = UIImageView()
    
    var mScribbleView : SmoothLineView!
    
    let studentsAswerDictonary      = NSMutableDictionary()
    
    
    let bottomview = UIView()
    
    let m_UndoButton = UIButton()
    
    let bottomtoolSelectedImageView = UIImageView()
    
    let m_BrushButton = UIButton()
    
    let m_EraserButton = UIButton()
    
    let m_RedoButton = UIButton()
    
    var selectedStudentsArray = NSMutableArray()
    
    let _ratingsPopoverController = RatingsPopOverViewController()
    
    var isModelAnswerSelected     = false
    
    let kUplodingServer     = "http://54.251.104.13/Jupiter/upload_photos.php"
    
    
    var          givenStarRatings       = 0
    var          givenBadgeId  :Int32   = 0
    var           givenTextReply        = ""
    
    let m_textButton = UIButton()
    let m_badgeButton = UIButton()
    
    var PopoverControllerRatings:UIPopoverController!
    
    var selectedtab    = ""

    
    
    override init(frame: CGRect)
    {
        super.init(frame:frame)
        
        
        
        
       mainContainerView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)
       mainContainerView.backgroundColor = whiteBackgroundColor
        self.addSubview(mainContainerView)
        
        subjectiveCellContainer  = SubjectiveLeftSideView(frame: CGRectMake(0, 0 , self.frame.size.width / 7, self.frame.size.height))
        subjectiveCellContainer.setdelegate(self)
        mainContainerView.addSubview(subjectiveCellContainer)
        
        
        
        
        topImageView.frame = CGRectMake(180,5, 780, 54)
        topImageView.backgroundColor = UIColor.whiteColor()
        mainContainerView.addSubview (topImageView);
        topImageView.layer.shadowColor = progressviewBackground.CGColor;
        topImageView.layer.shadowOffset = CGSizeMake(1, 1);
        topImageView.layer.shadowOpacity = 1;
        topImageView.layer.shadowRadius = 1.0;
        topImageView.clipsToBounds = false;
        topImageView.userInteractionEnabled = true
        
        
        mCancelButton.showsTouchWhenHighlighted = true;
        /* Add Cancel button target Cancel button should deselect all the selected submissions *defect 142 */
        mCancelButton.frame = CGRectMake(10 , 0, 139.0, 60.0);
        topImageView.addSubview(mCancelButton);
        mCancelButton.setTitle("Cancel", forState:.Normal);
        mCancelButton.setTitleColor(standard_Button, forState:.Normal);
        mCancelButton.titleLabel?.font = UIFont(name: helveticaMedium, size: 20);
        mCancelButton.contentHorizontalAlignment = UIControlContentHorizontalAlignment.Left
        mCancelButton.addTarget(self, action: "onCancelButton", forControlEvents: UIControlEvents.TouchUpInside)
        
        
        mSendButton.frame = CGRectMake(topImageView.frame.size.width - 100 , 0, 100 , topImageView.frame.size.height );
        topImageView.addSubview(mSendButton);
        mSendButton.setTitle("Send", forState:.Normal);
        mSendButton.setTitleColor(lightGrayColor, forState:.Normal);
        mSendButton.titleLabel?.font = UIFont(name: helveticaMedium, size: 20);
        mSendButton.enabled = false
        mSendButton.highlighted = false;
        mSendButton.contentHorizontalAlignment = UIControlContentHorizontalAlignment.Center
        mSendButton.addTarget(self, action: "onSendButton", forControlEvents: UIControlEvents.TouchUpInside)

        
        let lineImage = UIImageView(frame:CGRectMake(mSendButton.frame.origin.x, 5, 1, topImageView.frame.size.height - 10));
        lineImage.backgroundColor = progressviewBackground
        topImageView.addSubview(lineImage);
        
        
       
        
        m_textButton.frame = CGRectMake(lineImage.frame.origin.x - 50, 10, 40, topImageView.frame.size.height - 20);
//        [m_textButton addTarget:self action:@selector(onTextReplyButton:) forControlEvents:UIControlEventTouchUpInside];
        topImageView.addSubview(m_textButton);
        m_textButton.imageView?.contentMode = .ScaleAspectFit
        m_textButton.setImage(UIImage(named:"Text_Unselected.png"), forState:.Normal);
        m_textButton.addTarget(self, action: "onTextButton", forControlEvents: UIControlEvents.TouchUpInside)
        
        
        
        
        let lineImage1 = UIImageView(frame:CGRectMake(m_textButton.frame.origin.x - 10 , 5, 1, topImageView.frame.size.height - 10));
        lineImage1.backgroundColor = progressviewBackground
        topImageView.addSubview(lineImage1);
        
        
        m_badgeButton.frame = CGRectMake(lineImage1.frame.origin.x - 50, 10, 40, topImageView.frame.size.height - 20);
//        [m_badgeButton addTarget:self action:@selector(onBadgeButton:) forControlEvents:UIControlEventTouchUpInside];
        topImageView.addSubview(m_badgeButton);
        m_badgeButton.imageView?.contentMode = .ScaleAspectFit
        m_badgeButton.setImage(UIImage(named:"Cb_Like_Disabled.png"), forState:.Normal);
        m_badgeButton.addTarget(self, action: "onBadgeButton", forControlEvents: UIControlEvents.TouchUpInside)
        
        
        let lineImage2 = UIImageView(frame:CGRectMake(m_badgeButton.frame.origin.x - 10, 5, 1, topImageView.frame.size.height - 10));
        lineImage2.backgroundColor = progressviewBackground
        topImageView.addSubview(lineImage2);
        
        
        mStarRatingView.backgroundColor = UIColor.clearColor();
        mStarRatingView.frame = CGRectMake(lineImage2.frame.origin.x - 190, 10, 180, topImageView.frame.size.height - 20);
        mStarRatingView.setDelegate(self);
        topImageView.addSubview(mStarRatingView);
        mStarRatingView.setsizeOfStar(30);

        
        let  mMarkModelButtonlineImage = UIImageView(frame: CGRectMake(mStarRatingView.frame.origin.x - 10, 5, 1, topImageView.frame.size.height - 10));
        mMarkModelButtonlineImage.backgroundColor = progressviewBackground
        topImageView.addSubview(mMarkModelButtonlineImage);

        
       
        mMarkModelButton.frame = CGRectMake(mMarkModelButtonlineImage.frame.origin.x - 160, 0, 150, topImageView.frame.size.height);
        topImageView.addSubview(mMarkModelButton);
        mMarkModelButton.setImage(UIImage(named:"Mark_Model_Not_Selected.png"), forState:.Normal);
        mMarkModelButton.setTitle("  Mark Model", forState:.Normal);
        mMarkModelButton.setTitleColor(blackTextColor, forState:.Normal)
        mMarkModelButton.titleLabel?.font = UIFont(name: helveticaMedium, size: 20);
        mMarkModelButton.addTarget(self, action: "onModelAnswerButton", forControlEvents: UIControlEvents.TouchUpInside)
        
        
        
        
        
        containerview.frame = CGRectMake(topImageView.frame.origin.x,topImageView.frame.origin.y + topImageView.frame.size.height + 1 ,  topImageView.frame.size.width,topImageView.frame.size.width / kAspectRation)
        containerview.backgroundColor = UIColor.whiteColor()
        mainContainerView.addSubview(containerview);
        containerview.layer.shadowColor = progressviewBackground.CGColor;
        containerview.layer.shadowOffset = CGSizeMake(0,0);
        containerview.layer.shadowOpacity = 1;
        containerview.layer.shadowRadius = 1.0;
        containerview.clipsToBounds = false;
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        overlayimageView.frame = containerview.frame
        mainContainerView.addSubview(overlayimageView);

        mScribbleView = SmoothLineView(frame: containerview.frame)
        mScribbleView.delegate = self
        mainContainerView.addSubview(mScribbleView);
        mScribbleView.userInteractionEnabled = true
        mScribbleView.setDrawingColor(standard_Red);
        mScribbleView.setBrushWidth(5)
        mScribbleView.setDrawingTool(kBrushTool)
        mScribbleView.hidden = false
        
        
        
        bottomview.frame = CGRectMake(topImageView.frame.origin.x, containerview.frame.origin.y + containerview.frame.size.height , topImageView.frame.size.width,topImageView.frame.size.height)
        bottomview.backgroundColor = lightGrayTopBar
        mainContainerView.addSubview(bottomview);
        
        
        
       
        
        

        
        m_UndoButton.frame = CGRectMake(0, 0, bottomview.frame.size.height, bottomview.frame.size.height)
        m_UndoButton.setImage(UIImage(named:"Undo_Disabled.png"),forState:.Normal);
        bottomview.addSubview(m_UndoButton);
        m_UndoButton.imageView?.contentMode = .ScaleAspectFit
        
        
       
        bottomtoolSelectedImageView.backgroundColor = UIColor.whiteColor();
        bottomview.addSubview(bottomtoolSelectedImageView);
        bottomtoolSelectedImageView.layer.cornerRadius = 10.0;
        
        
        m_BrushButton.frame = CGRectMake((bottomview.frame.size.width/2) - (bottomview.frame.size.height + 10) ,5, bottomview.frame.size.height ,bottomview.frame.size.height - 10)
        m_BrushButton.setImage(UIImage(named:"Marker_Selected.png"), forState:.Normal)
        bottomview.addSubview(m_BrushButton);
        m_BrushButton.imageView?.contentMode = .ScaleAspectFit

        bottomtoolSelectedImageView.frame = m_BrushButton.frame
        
        
        
       
        m_EraserButton.frame = CGRectMake((bottomview.frame.size.width/2) + 10  ,5, bottomview.frame.size.height ,bottomview.frame.size.height - 10)
        m_EraserButton.setImage(UIImage(named:"Eraser_Unselected.png"), forState:.Normal);
        bottomview.addSubview(m_EraserButton);
        m_EraserButton.imageView?.contentMode = .ScaleAspectFit
        
        
        
        m_RedoButton.frame = CGRectMake(bottomview.frame.size.width - bottomview.frame.size.height ,0, bottomview.frame.size.height ,bottomview.frame.size.height)
        m_RedoButton.setImage(UIImage(named:"Redo_Disabled.png"), forState:.Normal);
        bottomview.addSubview(m_RedoButton);
        m_RedoButton.imageView?.contentMode = .ScaleAspectFit
        
        
        
        
        
//
//        NOsubmissionLabel = [[UILabel alloc] initWithFrame:CGRectMake((self.frame.size.width-600)/2, (self.frame.size.height/2)-30, 600, 60)];
//        [NOsubmissionLabel setText:@"There are no submission Yet"];
//        [NOsubmissionLabel setBackgroundColor:[UIColor clearColor]];
//        [NOsubmissionLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:40]];
//        [NOsubmissionLabel setTextAlignment:NSTextAlignmentCenter];
//        [NOsubmissionLabel setTextColor:[UIColor grayColor]];
//        [self addSubview:NOsubmissionLabel];
//        [NOsubmissionLabel setHidden:YES];
        
        
        self.bringSubviewToFront(mScribbleView)
        mainContainerView.hidden = true
        
        
    }
    
    required init?(coder aDecoder: NSCoder)
    {
        fatalError("init(coder:) has not been implemented")
        
        
        
    }
    
    
    func setStudentAnswerWithAnswer(studentAnswer:AnyObject, withStudentDict studentdict:AnyObject, withQuestionDict QuestionDetails:AnyObject )
    {
        mainContainerView.hidden = false
        
        _currentQuestionDetials = QuestionDetails
        
        
        overlayimageView.image = nil
        let subViews = containerview.subviews
        
        for subview in subViews
        {
            subview.removeFromSuperview()
        }
        
        if let studentId = studentdict.objectForKey("StudentId") as? String
        {
            studentsAswerDictonary.setObject(studentAnswer, forKey: studentId)
        
        }
       
        
        if let overlayImage = _currentQuestionDetials.objectForKey("Scribble") as? String
        {
            
            
            if overlayImage != ""
            {
                let urlString = NSUserDefaults.standardUserDefaults().objectForKey(k_INI_SCRIBBLE_IMAGE_URL) as! String
                
                if let checkedUrl = NSURL(string: "\(urlString)/\(overlayImage)")
                {
                    overlayimageView.contentMode = .ScaleAspectFit
                    overlayimageView.downloadImage(checkedUrl, withFolderType: folderType.questionImage,withResizeValue: overlayimageView.frame.size)
                }
                overlayimageView.hidden = false
            }

            
            
              subjectiveCellContainer.addStudentSubmissionWithStudentAnswer(studentAnswer, withStudentDetails: studentdict, withOverlay:overlayImage)
            
        }
        else
        {
              subjectiveCellContainer.addStudentSubmissionWithStudentAnswer(studentAnswer, withStudentDetails: studentdict, withOverlay:"")
        }
      
    }
    // MARK: - Subjective LeftSide View Delegate
    
    func delegateStudentSelectedWithState(state: Bool, withStudentDetails studentDetails: AnyObject, withAnswerDetails answerDetails: AnyObject)
    {
        if state == true
        {
            
            if let studentId = studentDetails.objectForKey("StudentId") as? String
            {
                if !selectedStudentsArray.containsObject(answerDetails)
                {
                    selectedStudentsArray.addObject(answerDetails)
                    
                    
                    let studentAnswerImage = UIImageView(frame: CGRectMake(0, 0, containerview.frame.size.width, containerview.frame.size.height))
                    studentAnswerImage.tag  = Int(studentId)!
                    containerview.addSubview(studentAnswerImage)
                    
                    if let Scribble = answerDetails.objectForKey("Scribble") as? String
                    {
                        let urlString = NSUserDefaults.standardUserDefaults().objectForKey(k_INI_SCRIBBLE_IMAGE_URL) as! String
                        
                        if let checkedUrl = NSURL(string: "\(urlString)/\(Scribble)")
                        {
                            studentAnswerImage.contentMode = .ScaleAspectFit
                            studentAnswerImage.downloadImage(checkedUrl, withFolderType: folderType.StudentAnswer,withResizeValue: studentAnswerImage.frame.size)
                        }
                    }
                }
            }
            
            
        }
        else
        {
            if let studentId = studentDetails.objectForKey("StudentId") as? String
            {
                if selectedStudentsArray.containsObject(answerDetails)
                {
                    selectedStudentsArray.removeObject(answerDetails)
                }
                
                if let studentDeskView  = containerview.viewWithTag(Int(studentId)!) as? UIImageView
                {
                    studentDeskView.removeFromSuperview()
                }
                
            }
            
        }
        
    }
    
    
    func questionCleared()
    {
         subjectiveCellContainer.clearedQuestion()
        overlayimageView.image = nil
        selectedStudentsArray.removeAllObjects()
        let subViews = containerview.subviews
        
        for subview in subViews
        {
            subview.removeFromSuperview()
        }
        
        mScribbleView.clearButtonClicked()
        givenBadgeId = 0
        givenStarRatings = 0
        givenTextReply = ""
        mScribbleView.clearButtonClicked()

        
    }
   
    // MARK: - Buttons function 
    
    
    func onCancelButton()
    {
        
    }
    
    func onSendButton()
    {
        let currentDate = NSDate()
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-mm-dd HH:mm:ss"
        

        
        let currentDateString = dateFormatter.stringFromDate(currentDate)
        
        
        let nameOfImage  = "TT-\(SSTeacherDataSource.sharedDataSource.currentUserId)-\(SSTeacherDataSource.sharedDataSource.currentLiveSessionId)-\(currentDateString)"
        
        
        if (mScribbleView.curImage != nil)
        {
            uploadImageWithImage(mScribbleView.curImage, withName: nameOfImage)
        }
        else
        {
            for var index = 0; index < selectedStudentsArray.count ; index++
            {
                
                let feedBackDetails  = NSMutableDictionary()
                let studentdict = selectedStudentsArray.objectAtIndex(index)
                
                if let studentId = studentdict.objectForKey("StudentId") as? String
                {
                    
                    if let studentAnswerDict = studentsAswerDictonary.objectForKey(studentId)
                    {
                        
                        if let AssessmentAnswerId = studentAnswerDict.objectForKey("AssessmentAnswerId") as? String
                        {
                            
                            
                            feedBackDetails.setObject(studentId, forKey: "StudentId")
                            
                            feedBackDetails.setObject(AssessmentAnswerId, forKey: "AssessmentAnswerId")
                            
                            feedBackDetails.setObject("\(givenStarRatings)", forKey: "Rating")
                            
                            feedBackDetails.setObject("\(givenBadgeId)", forKey: "BadgeId")
                            
                            feedBackDetails.setObject("\(givenTextReply)", forKey: "textRating")
                            
                            feedBackDetails.setObject("\(isModelAnswerSelected)", forKey: "ModelAnswerFlag")
                            
                            SSTeacherDataSource.sharedDataSource.sendFeedbackToStudentWithDetails(feedBackDetails, WithDelegate: self)
                            
                        }
                        
                    }
                    
                    
                }
                
                
                
                
            }
        }
        
        
        
    }
    
    func onTextButton()
    {
        
        selectedtab = "Text"
        
        _ratingsPopoverController.addTextviewwithtext(givenTextReply, withtopviewText:"Rate with Text")
        let navController = UINavigationController(rootViewController: _ratingsPopoverController)
        
        
        
        PopoverControllerRatings = UIPopoverController(contentViewController: navController)
        PopoverControllerRatings.popoverContentSize = CGSizeMake(200,100);
        PopoverControllerRatings.delegate = self;
        navController.navigationBarHidden = true;
        
        
        let buttonPosition :CGPoint = m_textButton.convertPoint(CGPointZero, toView: self)
        
        PopoverControllerRatings.presentPopoverFromRect(CGRectMake(buttonPosition.x + m_textButton.frame.size.width / 2 , topImageView.frame.origin.y + topImageView.frame.size.height , 1, 1), inView: self, permittedArrowDirections: .Up, animated: true)
    }
    
    func onBadgeButton()
    {
        
        selectedtab = "Badge"
        _ratingsPopoverController.addBadgesWithValueValue(givenBadgeId, withtext:"Rate with badge");
        let navController = UINavigationController(rootViewController: _ratingsPopoverController)
        
        
        let buttonPosition :CGPoint = m_badgeButton.convertPoint(CGPointZero, toView: self)
        PopoverControllerRatings = UIPopoverController(contentViewController: navController)
        PopoverControllerRatings.popoverContentSize = CGSizeMake(200,150);
        PopoverControllerRatings.delegate = self;
        navController.navigationBarHidden = true;
        
        PopoverControllerRatings.presentPopoverFromRect(CGRectMake(buttonPosition.x + m_badgeButton.frame.size.width / 2 , topImageView.frame.origin.y + topImageView.frame.size.height , 1, 1), inView: self, permittedArrowDirections: .Up, animated: true)
        
    }
    
    func onModelAnswerButton()
    {
        if isModelAnswerSelected == false
        {
            isModelAnswerSelected = true
            
            
            mMarkModelButton.setImage(UIImage(named:"Mark_Model_Selected.png"), forState:.Normal);
        }
        else
        {
            isModelAnswerSelected = false
            mMarkModelButton.setImage(UIImage(named:"Mark_Model_Not_Selected.png"), forState:.Normal);
        }
    }
    
    // MARK: - popover delegate
    
    func popoverControllerDidDismissPopover(popoverController: UIPopoverController)
    {
        
        if popoverController == PopoverControllerRatings
        {
            if selectedtab == "Badge"
            {
                givenBadgeId = _ratingsPopoverController.badgeId()
            }
            else
            {
                givenTextReply = _ratingsPopoverController.textViewtext()
            }
        }
        
        
        if ((givenStarRatings > 0 ) || (givenBadgeId > 0) || givenTextReply != "")
        {
            mSendButton.enabled = true;
            mSendButton.setTitleColor(standard_Button, forState:.Normal);
        }
        else
        {
            mSendButton.enabled = false;
            mSendButton.setTitleColor(UIColor.lightGrayColor(), forState:.Normal);
        }
        
        
    }
    
    
    
    
    // MARK: - Smooth line delegate
    
    func setUndoButtonEnable(enable: NSNumber!) {
        
    }
    
    func setRedoButtonEnable(enable: NSNumber!) {
        
    }
    
    func lineDrawnChanged()
    {
        
    }
    
    // MARK: - Star view delegate
    
    func starRatingDidChange()
    {
        givenStarRatings = mStarRatingView.rating()
        
    }
    

     // MARK: - image Uploadeding delegate
    func uploadImageWithImage(scribbleImage:UIImage, withName nameOftheImage:String)
    {
       
        let imageData = UIImagePNGRepresentation(scribbleImage)
        
        if imageData != nil
        {
            let request = NSMutableURLRequest(URL: NSURL(string:kUplodingServer)!)

            request.HTTPMethod = "POST"
            
            let boundary = NSString(format:"---------------------------14737809831466499882746641449")
            
            let contentType = String(format: "multipart/form-data; boundary=%@",boundary)
            //  println("Content Type \(contentType)")
            
            request.addValue(contentType, forHTTPHeaderField: "Content-Type")
            
            let body = NSMutableData()
            
            // Title
            body.appendData(NSString(format: "\r\n--%@\r\n",boundary).dataUsingEncoding(NSUTF8StringEncoding)!)
           
            body.appendData(NSString(format:"Content-Disposition: form-data; name=\"userfile\"; filename=\"\(nameOftheImage).png\"\r\n").dataUsingEncoding(NSUTF8StringEncoding)!)
//            body.appendData("Hello World".dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: true)!)
            
            // Image
            body.appendData("Content-Type: application/octet-stream\r\n\r\n".dataUsingEncoding(NSUTF8StringEncoding)!)
            
            
             body.appendData(imageData!)
            
            body.appendData(NSString(format:"Content-Disposition: form-data; name=\"profile_img\"; filename=\"img.jpg\"\\r\n").dataUsingEncoding(NSUTF8StringEncoding)!)
            
            body.appendData(NSString(format: "Content-Type: application/octet-stream\r\n\r\n").dataUsingEncoding(NSUTF8StringEncoding)!)
            
           
            
            body.appendData(NSString(format: "\r\n--%@\r\n", boundary).dataUsingEncoding(NSUTF8StringEncoding)!)
            
            
            
            request.HTTPBody = body
            
//            
//            NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue()) { response, data, error in
//                guard data != nil else
//                {
//                    completionHandler(nil, error)
//                    return
//                }
//                
//                completionHandler(NSString(data: data!, encoding: NSUTF8StringEncoding), nil)
//            }
//            
            
            
            let task = NSURLSession.sharedSession().dataTaskWithRequest(request) {
                data, response, error in
                
                if error != nil
                {
                    print("error=\(error)")
                    return
                }
                
                // You can print out response object
                print("******* response = \(response)")
                self.newImageUploadedWithName(nameOftheImage)
//                // Print out reponse body
//                let responseString = NSString(data: imageData!, encoding: NSUTF8StringEncoding)
//                print("****** response data = \(responseString!)")
                
                
//                dispatch_async(dispatch_get_main_queue(),
//                    {
//                    self.myActivityIndicator.stopAnimating()
//                    self.myImageView.image = nil;
//                });
                
                /*
                if let parseJSON = json {
                var firstNameValue = parseJSON["firstName"] as? String
                println("firstNameValue: \(firstNameValue)")
                }
                */
                
            }
            
            task.resume()
            
            
            
        }
        
        
    }
    
    
    func newImageUploadedWithName(imageName:String)
    {
        
        
        
        
        
        for var index = 0; index < selectedStudentsArray.count ; index++
        {
            
            let feedBackDetails  = NSMutableDictionary()
            let studentdict = selectedStudentsArray.objectAtIndex(index)
            
            if let studentId = studentdict.objectForKey("StudentId") as? String
            {
                
                if let studentAnswerDict = studentsAswerDictonary.objectForKey(studentId)
                {
                    
                    if let AssessmentAnswerId = studentAnswerDict.objectForKey("AssessmentAnswerId") as? String
                    {
                        
                        
                        feedBackDetails.setObject(studentId, forKey: "StudentId")
                        
                        feedBackDetails.setObject(AssessmentAnswerId, forKey: "AssessmentAnswerId")
                        
                        feedBackDetails.setObject("\(givenStarRatings)", forKey: "Rating")
                        
                        feedBackDetails.setObject("upload/\(imageName)", forKey: "imageUrl")
                        
                        feedBackDetails.setObject("\(givenBadgeId)", forKey: "BadgeId")
                        
                        feedBackDetails.setObject("\(givenTextReply)", forKey: "textRating")
                        
                        feedBackDetails.setObject("\(isModelAnswerSelected)", forKey: "ModelAnswerFlag")
                        
                         SSTeacherDataSource.sharedDataSource.sendFeedbackToStudentWithDetails(feedBackDetails, WithDelegate: self)
                        
                    }
                    
                }
                
                
            }
            
            
            
            
        }
    }
    
    func didGetFeedbackSentWithDetails(details: AnyObject)
    {
        
        
        print(details)
        
        
        mSendButton.setTitleColor(lightGrayColor, forState:.Normal);
        mSendButton.enabled = false
        
        givenBadgeId = 0
        givenStarRatings = 0
        givenTextReply = ""
        mScribbleView.clearButtonClicked()
        
        
        if let studentId = details.objectForKey("Students")!.objectForKey("Student")!.objectForKey("StudentId") as? String
        {
           if let AssessmentAnswerId = details.objectForKey("AssessmentAnswerId") as? String
           {
                    SSTeacherMessageHandler.sharedMessageHandler.sendFeedbackToStudentWitId(studentId, withassesmentAnswerId: AssessmentAnswerId)
            
            
            subjectiveCellContainer.feedbackSentToStudentsWithStudentsId(studentId)
            
            
            if let answerDetails = studentsAswerDictonary.objectForKey(studentId)
            {
                if selectedStudentsArray.containsObject(answerDetails)
                {
                    selectedStudentsArray.removeObject(answerDetails)
                }
            }
            
           
            if let studentDeskView  = containerview.viewWithTag(Int(studentId)!) as? UIImageView
            {
                studentDeskView.removeFromSuperview()
            }
            
            
            
            }
        }
    }
    
    
}