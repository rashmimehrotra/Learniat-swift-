//
//  StudentAnswerOptionsView.swift
//  LearniatTeacher
//
//  Created by Deepak MK on 01/04/16.
//  Copyright © 2016 Mindshift. All rights reserved.
//

import Foundation
class StudentAnswerOptionsView: UIView
{
    
    var _currentQuestionDetials :AnyObject!
    
    
    var _studentFinalAnswerOptions = NSMutableArray()
    
    var _Popover:AnyObject!
    func setPopover(popover:AnyObject)
    {
        _Popover = popover
    }
    
    func popover()-> AnyObject
    {
        return _Popover
    }
    
    
    override init(frame: CGRect) {
        
        super.init(frame:frame)
        
    }
    
    
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
        
        
    }
    
    func addDontKnowImage()
    {
        let subViews = self.subviews
        
        for subview in subViews
        {
            
            subview.removeFromSuperview()
            
        }
        
        
        let mDontKnowImage = UIImageView(frame: CGRectMake(10,10,self.frame.size.width - 20 ,self.frame.size.height - 20 ))
        self.addSubview(mDontKnowImage)
        mDontKnowImage.contentMode = .ScaleAspectFit
        mDontKnowImage.image = UIImage(named: "don't-know.png")
        
        
        
        
    }
    
    
    func addScribbleWithDetiails(details:AnyObject, withOverlayImage overlayImage:String)
    {
        let subViews = self.subviews
        
        for subview in subViews
        {
           
                subview.removeFromSuperview()
            
        }
        
    
        
        if overlayImage != ""
        {
            let overLayImage = CustomProgressImageView(frame: CGRectMake(0,0,self.frame.size.width,self.frame.size.height))
            self.addSubview(overLayImage)
            
            
            let urlString = NSUserDefaults.standardUserDefaults().objectForKey(k_INI_QuestionsImageUrl) as! String
            
            if let checkedUrl = NSURL(string: "\(urlString)/\(overlayImage)")
            {
                overLayImage.contentMode = .ScaleAspectFit
                overLayImage.downloadImage(checkedUrl, withFolderType: folderType.questionImage,withResizeValue: self.frame.size)
            }
            
        }
        
        
        let studentAnswerImage = CustomProgressImageView(frame: CGRectMake(0,0,self.frame.size.width,self.frame.size.height))
        self.addSubview(studentAnswerImage)
       
        
        if let Scribble = details.objectForKey("Scribble") as? String
        {
            let urlString = NSUserDefaults.standardUserDefaults().objectForKey(k_INI_SCRIBBLE_IMAGE_URL) as! String
            
            if let checkedUrl = NSURL(string: "\(urlString)/\(Scribble)")
            {
                studentAnswerImage.contentMode = .ScaleAspectFit
                studentAnswerImage.downloadImage(checkedUrl, withFolderType: folderType.StudentAnswer,withResizeValue: self.frame.size)
            }
        }
    }
    
    
    
    func addTextWithDetiails(details:AnyObject)
    {
        let subViews = self.subviews
        
        for subview in subViews
        {
            
            subview.removeFromSuperview()
            
        }
        
        
        
        
        
        
        let studentAnswertext = UILabel(frame: CGRectMake((self.frame.size.width - (self.frame.size.width - 5))/2  ,(self.frame.size.height-(self.frame.size.height - 5 ))/2,self.frame.size.width - 5,self.frame.size.height - 5 ))
        self.addSubview(studentAnswertext)
       
        var fontHeight = studentAnswertext.frame.size.height/3;
        
        if (fontHeight > 16)
        {
            fontHeight = 16;
        }

        studentAnswertext.font = UIFont(name: helveticaRegular, size: fontHeight)
        studentAnswertext.textColor = blackTextColor
        studentAnswertext.lineBreakMode = .ByTruncatingMiddle
        studentAnswertext.numberOfLines = 10
        studentAnswertext.textAlignment = .Center
        if let TextAnswer = details.objectForKey("TextAnswer") as? String
        {
           studentAnswertext.text = TextAnswer
        }
        
        
        
    }
    
    
    func addOneStringAnswerWithString(answer:String)
    {   
        let subViews = self.subviews
        
        for subview in subViews
        {
            
            subview.removeFromSuperview()
            
        }
        
        
        
        
        
        
        let studentAnswertext = UILabel(frame: CGRectMake(0,0,self.frame.size.width,self.frame.size.height))
        self.addSubview(studentAnswertext)
        
        var fontHeight = studentAnswertext.frame.size.height/3;
        
        if (fontHeight > 16)
        {
            fontHeight = 16;
        }
        
        studentAnswertext.font = UIFont(name: helveticaRegular, size: fontHeight)
        studentAnswertext.textColor = blackTextColor
        studentAnswertext.lineBreakMode = .ByTruncatingMiddle
        studentAnswertext.numberOfLines = 10
        studentAnswertext.textAlignment = .Center
        studentAnswertext.text = answer
        
    }
    
    
    func addOptionsWithAnswerDetails(answerDetails: AnyObject, withQuestionDetails questionDetails :AnyObject)
    {
        _currentQuestionDetials = questionDetails
        var optionArray = NSMutableArray()
        
        if let options = _currentQuestionDetials.objectForKey("Options")
        {
            if let classCheckingVariable = options.objectForKey("Option")
            {
                if classCheckingVariable.isKindOfClass(NSMutableArray)
                {
                    optionArray = classCheckingVariable as! NSMutableArray
                }
                else
                {
                    optionArray.addObject(_currentQuestionDetials.objectForKey("Options")!.objectForKey("Option")!)
                    
                }
            }
        }
        
        
        
        if let Type = _currentQuestionDetials.objectForKey("Type") as? String
        {
            if Type == "Multiple Choice"
            {
                
                addSingleResponseQuestionAnswerWithDetails(answerDetails,withQuestionOptionsArray: optionArray)
            }
            else if Type == "Multiple Response"
            {
                
                addMultipleResponseQuestionAnswerWithDetails(answerDetails,withQuestionOptionsArray: optionArray)
            }
            else if Type == "Match Columns"
            {
                
                addMatchColumnQuestionAnswerWithDetails(answerDetails)
                
            }
        }
    }
    
    
    func addSingleResponseQuestionAnswerWithDetails(answerDetails:AnyObject, withQuestionOptionsArray questionOptions:NSMutableArray)
    {
        let studentAnsweOption = NSMutableArray()
        
        if let options = answerDetails.objectForKey("Options")
        {
            if let classCheckingVariable = options.objectForKey("Option")
            {
                if let _studentAnswerOption = classCheckingVariable.objectForKey("OptionText") as?String
                {
                    studentAnsweOption .addObject( _studentAnswerOption)
                }
            }
        }
        
        
        _studentFinalAnswerOptions = studentAnsweOption
        
//        let optionsDetails =  getOptionsValuesWithOptionsArray(studentAnsweOption, withQuestionOptions: questionOptions)
       addCheckMarksForMultipleResponseWithOptionsDetails(questionOptions,withAnswerOptions: studentAnsweOption)
        
    }
    
    func addMultipleResponseQuestionAnswerWithDetails(answerDetails:AnyObject, withQuestionOptionsArray questionOptions:NSMutableArray)
    {
        var studentAnsweOptions = NSMutableArray()
        if let options = answerDetails.objectForKey("Options")
        {
            if let classCheckingVariable = options.objectForKey("Option")
            {
                if classCheckingVariable.isKindOfClass(NSMutableArray)
                {
                    studentAnsweOptions = classCheckingVariable as! NSMutableArray
                }
                else
                {
                    studentAnsweOptions.addObject(answerDetails.objectForKey("Options")!.objectForKey("Option")!)
                    
                }
            }
        }
        
        
        let studentFinalAsnwer = NSMutableArray()
        for answerIndex in 0..<studentAnsweOptions.count
        {
            let answerOptiondict = studentAnsweOptions.objectAtIndex(answerIndex)
            
            if let answerOptionText = answerOptiondict.objectForKey("OptionText") as? String
            {
                studentFinalAsnwer.addObject(answerOptionText)
                
            }
        }
        
        _studentFinalAnswerOptions = studentFinalAsnwer
//        let optionsDetails =  getOptionsValuesWithOptionsArray(studentFinalAsnwer, withQuestionOptions: questionOptions)
       addCheckMarksForMultipleResponseWithOptionsDetails(questionOptions,withAnswerOptions: studentFinalAsnwer)
        
        
        
    }
    
    
    
    func addMatchColumnQuestionAnswerWithDetails(answerOptions:AnyObject)
    {
        
        var studentAnsweOptions = NSMutableArray()
        if let options = answerOptions.objectForKey("Options")
        {
            if let classCheckingVariable = options.objectForKey("Option")
            {
                if classCheckingVariable.isKindOfClass(NSMutableArray)
                {
                    studentAnsweOptions = classCheckingVariable as! NSMutableArray
                }
                else
                {
                    studentAnsweOptions.addObject(answerOptions.objectForKey("Options")!.objectForKey("Option")!)
                    
                }
            }
        }
        
        
        
        
        _studentFinalAnswerOptions = studentAnsweOptions
        addCheckMarksForMatchCoulmnWithOptionsDetails(studentAnsweOptions)
    }
    
    
    
    func getOptionsValuesWithOptionsArray(answerOptions:NSMutableArray, withQuestionOptions questionOptions:NSMutableArray)-> NSMutableArray
    {
        
        for index in 0..<questionOptions.count
        {
            let questionOptiondict = questionOptions.objectAtIndex(index)
            
            if let questionOptionText = questionOptiondict.objectForKey("OptionText") as? String
            {
                for answerIndex in 0..<answerOptions.count
                {
                    if let answerOptionText = answerOptions.objectAtIndex(answerIndex) as? String
                    {
                        if answerOptionText == questionOptionText
                        {
                            if let IsAnswer = questionOptiondict.objectForKey("IsAnswer") as? String
                            {
                                if IsAnswer == "1"
                                {
                                    questionOptiondict.setObject(KCorretValue, forKey: "IsAnswer")
                                    questionOptions.replaceObjectAtIndex(index, withObject: questionOptiondict)
                                }
                                else
                                {
                                    questionOptiondict.setObject(kWrongvalue, forKey: "IsAnswer")
                                    questionOptions.replaceObjectAtIndex(index, withObject: questionOptiondict)
                                }
                            }
                            
                            
                            break
                        }
                        
                    }
                }
            }
        }
        
        for index in 0..<questionOptions.count
        {
            let questionOptiondict = questionOptions.objectAtIndex(index)
            
            if let IsAnswer = questionOptiondict.objectForKey("IsAnswer") as? String
            {
                if IsAnswer == "0" || IsAnswer == "1"
                {
                    questionOptiondict.setObject(kMissedValue, forKey: "IsAnswer")
                    questionOptions.replaceObjectAtIndex(index, withObject: questionOptiondict)
                }
                
            }
        }
        
        _studentFinalAnswerOptions = questionOptions
        
        return questionOptions
    }
    
    
    func addCheckMarksForMultipleResponseWithOptionsDetails(optionsDetails:NSMutableArray, withAnswerOptions answerOptions:NSMutableArray)
    {
        
        
        
        let subViews = self.subviews
        
        for subview in subViews
        {
           
                subview.removeFromSuperview()
                   }
        
        
        if optionsDetails.count > 0
        {
            var  count :CGFloat = CGFloat(optionsDetails.count)
            var numberOfRow :CGFloat = 1
            var numberOfcolumn :CGFloat = 1
            
            
            
            if (count % 2 != 0)
            {
                
                count = count+1;
            }
            
            numberOfcolumn = count / 2;
            numberOfRow = 2;
            
            
            var barWidth = self.frame.size.width / numberOfcolumn
            let widthSpace = (barWidth * 0.6)
            barWidth = (barWidth * 0.4)
            var width = widthSpace / 2
            
            var barHeight = self.frame.size.height / numberOfRow
            
            let heightSpace = (barHeight * 0.6)
            barHeight = (barHeight * 0.4)
            var height = heightSpace / 2
            
            var optionsArrayCount = 0
            
            
            for _ in 0..<Int(numberOfRow)
            {
                for _ in 0..<Int(numberOfcolumn)
                {
                    let containerView =  UIImageView(frame:CGRectMake(width, height, barWidth, barHeight))
                    self.addSubview(containerView);
                    
                    let optionsValueImage = UIImageView()
                    
                    if containerView.frame.size.width > containerView.frame.size.height
                    {
                        optionsValueImage.frame = CGRectMake((containerView.frame.size.width - containerView.frame.size.height)/2 , (containerView.frame.size.width - containerView.frame.size.height)/2, containerView.frame.size.height, containerView.frame.size.height)
                    }
                    else
                    {
                        optionsValueImage.frame = CGRectMake((containerView.frame.size.height - containerView.frame.size.width)/2 , (containerView.frame.size.height - containerView.frame.size.width)/2, containerView.frame.size.width, containerView.frame.size.width)
                    }
                    
                    containerView.addSubview(optionsValueImage)
                    
                    optionsValueImage.contentMode = .ScaleAspectFit
                    
                    optionsValueImage.backgroundColor = topicsLineColor
                    
                    if optionsArrayCount < optionsDetails.count
                    {
                        let questionOptiondict = optionsDetails.objectAtIndex(optionsArrayCount)
                        
                        
                        if let questionOptionText = questionOptiondict.objectForKey("OptionText") as? String
                        {
                            for answerIndex in 0..<answerOptions.count
                            {
                                if let answerOptionText = answerOptions.objectAtIndex(answerIndex) as? String
                                {
                                    if answerOptionText == questionOptionText
                                    {
                                        if let IsAnswer = questionOptiondict.objectForKey("IsAnswer") as? String
                                        {
                                            if IsAnswer == "1"
                                            {
                                                optionsValueImage.image = UIImage(named: "Check.png")
                                                optionsValueImage.backgroundColor = UIColor.clearColor()
                                            }
                                            else if IsAnswer == "0"
                                            {
                                                optionsValueImage.image = UIImage(named: "X.png")
                                                optionsValueImage.backgroundColor = UIColor.clearColor()
                                            }
                                        }
                                    }
                                    
                                }
                            }
                        }
                        
                        
                        optionsArrayCount = optionsArrayCount + 1
                    }
                    width = width + widthSpace + barWidth;
                }
                width=widthSpace/2;
                height=height+heightSpace+barHeight;
            }
        }
    }
    
    func addCheckMarksForMatchCoulmnWithOptionsDetails(optionsDetails:NSMutableArray)
    {
        
        
        
        let subViews = self.subviews
        
        for subview in subViews
        {
                subview.removeFromSuperview()
            
        }
        
        
        if optionsDetails.count > 0
        {
            var  count :CGFloat = CGFloat(optionsDetails.count)
            var numberOfRow :CGFloat = 1
            var numberOfcolumn :CGFloat = 1
            
            
            
            if (count % 2 != 0)
            {
                
                count = count+1;
            }
            
            numberOfcolumn = count / 2;
            numberOfRow = 2;
            
            
            var barWidth = self.frame.size.width / numberOfcolumn
            let widthSpace = (barWidth * 0.6)
            barWidth = (barWidth * 0.4)
            var width = widthSpace / 2
            
            var barHeight = self.frame.size.height / numberOfRow
            
            let heightSpace = (barHeight * 0.6)
            barHeight = (barHeight * 0.4)
            var height = heightSpace / 2
            
            var optionsArrayCount = 0
            
            
            for _ in 0..<Int(numberOfRow)
            {
                for _ in 0..<Int(numberOfcolumn)
                {
                    let containerView =  UIImageView(frame:CGRectMake(width, height, barWidth, barHeight))
                    self.addSubview(containerView);
                    
                    let studentDesk = UIImageView()
                    
                    if containerView.frame.size.width > containerView.frame.size.height
                    {
                        studentDesk.frame = CGRectMake((containerView.frame.size.width - containerView.frame.size.height)/2 , (containerView.frame.size.width - containerView.frame.size.height)/2, containerView.frame.size.height, containerView.frame.size.height)
                    }
                    else
                    {
                        studentDesk.frame = CGRectMake((containerView.frame.size.height - containerView.frame.size.width)/2 , (containerView.frame.size.height - containerView.frame.size.width)/2, containerView.frame.size.width, containerView.frame.size.width)
                    }
                    
                    containerView.addSubview(studentDesk)
                    
                    studentDesk.contentMode = .ScaleAspectFit
                    
                    studentDesk.backgroundColor = topicsLineColor
                    
                    if optionsArrayCount < optionsDetails.count
                    {
                        let questionOptiondict = optionsDetails.objectAtIndex(optionsArrayCount)
                        
                        if let OldSequence = questionOptiondict.objectForKey("OldSequence") as? String
                        {
                            if let Sequence = questionOptiondict.objectForKey("Sequence") as? String
                            {
                                if OldSequence == Sequence
                                {
                                    studentDesk.image = UIImage(named: "Check.png")
                                    studentDesk.backgroundColor = UIColor.clearColor()
                                }
                                else
                                {
                                    studentDesk.image = UIImage(named: "X.png")
                                    studentDesk.backgroundColor = UIColor.clearColor()
                                }
                            }
                        }
                        optionsArrayCount = optionsArrayCount + 1
                    }
                    width = width + widthSpace + barWidth;
                }
                width=widthSpace/2;
                height=height+heightSpace+barHeight;
            }
        }
    }
    
    
    func setStudentEvaluationStatusWithDetails(details:AnyObject)
    {
        
        /* 
            AssessmentAnswerId = 11356;
            BadgeId = 2;
            ModelAnswerFlag = false;
            Rating = 3;
            StudentId = 527;
            imageUrl = "TT-496-2224-2016-57-1217:57:27";
            textRating = "Dads ad sad";
        */

        
        if let teacherScribble = details.objectForKey("imageUrl") as? String
        {
            let overLayImage = CustomProgressImageView(frame: CGRectMake(0,0,self.frame.size.width,self.frame.size.height))
            self.addSubview(overLayImage)
            
            
            let urlString = NSUserDefaults.standardUserDefaults().objectForKey(k_INI_QuestionsImageUrl) as! String
            
            if let checkedUrl = NSURL(string: "\(urlString)/\(teacherScribble)")
            {
                overLayImage.contentMode = .ScaleAspectFit
                overLayImage.downloadImage(checkedUrl, withFolderType: folderType.questionImage,withResizeValue: self.frame.size)
            }
            
        }

        
        
        var ratings = 0
        var badgeId = 0
        var textReply = ""
        
        
        
        let mTeacherReplyState = UIImageView(frame: CGRectMake(0,self.frame.size.height - (self.frame.size.height / 3) ,self.frame.size.width,self.frame.size.height / 3))
        self.addSubview(mTeacherReplyState)
        mTeacherReplyState.backgroundColor = UIColor(red: 34/255.0, green:68/255.0, blue:99/255.0, alpha: 0.8)
        
        

       
        
       
        
        if let Rating = details.objectForKey("Rating") as? String
        {
            
            ratings = Int(Rating)!
        }
        
        if let BadgeId = details.objectForKey("BadgeId") as? String
        {
            badgeId = Int(BadgeId)!
            
        }
        
        if let textRating = details.objectForKey("textRating") as? String
        {
            textReply = textRating
            
        }

        
        
        if ratings > 0
        {
            let starview = StudentStarView(frame: CGRectMake(0,0,mTeacherReplyState.frame.size.width,mTeacherReplyState.frame.size.height))
           starview.addStarsWithRatings(Int32(ratings), withSize: Float(mTeacherReplyState.frame.size.height))
            starview.backgroundColor = UIColor.clearColor()
            mTeacherReplyState.addSubview(starview)
        }
        else if badgeId > 0
        {
            let imageLoader = ImageUploading()
            
            let BadgeIdImage = UIImageView(frame: CGRectMake(0,0,mTeacherReplyState.frame.size.width,mTeacherReplyState.frame.size.height))
            BadgeIdImage.contentMode = .ScaleAspectFit
            BadgeIdImage.image = imageLoader.getImageWithBadgeId(Int32(badgeId))
            
            mTeacherReplyState.addSubview(BadgeIdImage)
        }
        else if textReply != ""
        {
            let studentAnswertext = UILabel(frame: CGRectMake(0,0,mTeacherReplyState.frame.size.width,mTeacherReplyState.frame.size.height))
            mTeacherReplyState.addSubview(studentAnswertext)
            
            var fontHeight = studentAnswertext.frame.size.height/3;
            
            if (fontHeight > 16)
            {
                fontHeight = 16;
            }
            
            studentAnswertext.font = UIFont(name: helveticaRegular, size: fontHeight)
            studentAnswertext.textColor = UIColor.whiteColor()
            studentAnswertext.lineBreakMode = .ByTruncatingMiddle
            studentAnswertext.numberOfLines = 10
            studentAnswertext.textAlignment = .Center
            studentAnswertext.text = textReply
            
        }
        
        
        if let ModelAnswerFlag = details.objectForKey("ModelAnswerFlag") as? String
        {
            if ModelAnswerFlag == "true"
            {
                let modelAnswerLabel = UILabel(frame: CGRectMake(0,0,self.frame.size.width,mTeacherReplyState.frame.size.height / 1.8))
                modelAnswerLabel.backgroundColor = standard_Green
                modelAnswerLabel.textColor = UIColor.whiteColor()
                
                var fontHeight = modelAnswerLabel.frame.size.height/1.2;
                
                if (fontHeight > 16)
                {
                    fontHeight = 16;
                }
                
                modelAnswerLabel.font = UIFont(name: helveticaRegular, size: fontHeight)
                modelAnswerLabel.textColor = UIColor.whiteColor()
                modelAnswerLabel.lineBreakMode = .ByTruncatingMiddle
                modelAnswerLabel.numberOfLines = 10
                modelAnswerLabel.textAlignment = .Center
                modelAnswerLabel.text = "Model Answer"
                self.addSubview(modelAnswerLabel)
                
                
            }
            
            
        }
        
        
        
        
    }
    
    
    
    
    
}