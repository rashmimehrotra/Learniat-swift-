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
    
    
    var _Popover:UIPopoverController!
    
    func setPopover(_ popover:UIPopoverController)
    {
        _Popover = popover
    }
    
    func popover()-> UIPopoverController
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
        
        
        let mDontKnowImage = UIImageView(frame: CGRect(x: 10,y: 10,width: self.frame.size.width - 20 ,height: self.frame.size.height - 20 ))
        self.addSubview(mDontKnowImage)
        mDontKnowImage.contentMode = .scaleAspectFit
        mDontKnowImage.image = UIImage(named: "don't-know.png")
        
        
        
        
    }
    
    
    func addScribbleWithDetiails(_ details:AnyObject, withOverlayImage overlayImage:String)
    {
        let subViews = self.subviews
        
        for subview in subViews
        {
           
                subview.removeFromSuperview()
            
        }
        
    
        
        if overlayImage != ""
        {
            let overLayImage = CustomProgressImageView(frame: CGRect(x: 0,y: 0,width: self.frame.size.width,height: self.frame.size.height))
            self.addSubview(overLayImage)
            
            
            let urlString = UserDefaults.standard.object(forKey: k_INI_QuestionsImageUrl) as! String
            
            if let checkedUrl = URL(string: "\(urlString)/\(overlayImage)")
            {
                overLayImage.contentMode = .scaleAspectFit
                overLayImage.downloadImage(checkedUrl, withFolderType: folderType.questionImage,withResizeValue: self.frame.size)
            }
            
        }
        
        
        let studentAnswerImage = CustomProgressImageView(frame: CGRect(x: 0,y: 0,width: self.frame.size.width,height: self.frame.size.height))
        self.addSubview(studentAnswerImage)
       
        
        if let Scribble = details.object(forKey: "Scribble") as? String
        {
            let urlString = UserDefaults.standard.object(forKey: k_INI_SCRIBBLE_IMAGE_URL) as! String
            
            if let checkedUrl = URL(string: "\(urlString)/\(Scribble)")
            {
                studentAnswerImage.contentMode = .scaleAspectFit
                studentAnswerImage.downloadImage(checkedUrl, withFolderType: folderType.studentAnswer,withResizeValue: self.frame.size)
            }
        }
    }
    
    
    
    func addTextWithDetiails(_ details:AnyObject)
    {
        let subViews = self.subviews
        
        for subview in subViews
        {
            
            subview.removeFromSuperview()
            
        }
        
        
        
        
        
        
        let studentAnswertext = UILabel(frame: CGRect(x: (self.frame.size.width - (self.frame.size.width - 5))/2  ,y: (self.frame.size.height-(self.frame.size.height - 5 ))/2,width: self.frame.size.width - 5,height: self.frame.size.height - 5 ))
        self.addSubview(studentAnswertext)
       
        var fontHeight = studentAnswertext.frame.size.height/3;
        
        if (fontHeight > 14)
        {
            fontHeight = 14;
        }

        studentAnswertext.font = UIFont(name: RobotItalic, size: fontHeight)
        studentAnswertext.textColor = blackTextColor
        studentAnswertext.lineBreakMode = .byTruncatingMiddle
        studentAnswertext.numberOfLines = 10
        studentAnswertext.textAlignment = .center
        if let TextAnswer = details.object(forKey: "TextAnswer") as? String
        {
           studentAnswertext.text = TextAnswer
        }
        
        
        
    }
    
    
    func addOneStringAnswerWithString(_ answer:String)
    {   
        let subViews = self.subviews
        
        for subview in subViews
        {
            
            subview.removeFromSuperview()
            
        }
        
        
        
        
        
        
        let studentAnswertext = UILabel(frame: CGRect(x: 0,y: 0,width: self.frame.size.width,height: self.frame.size.height))
        self.addSubview(studentAnswertext)
        
        var fontHeight = studentAnswertext.frame.size.height/3;
        
        if (fontHeight > 14)
        {
            fontHeight = 14;
        }
        
        studentAnswertext.font = UIFont(name: RobotItalic, size: fontHeight)
        studentAnswertext.textColor = blackTextColor
        studentAnswertext.lineBreakMode = .byTruncatingMiddle
        studentAnswertext.numberOfLines = 10
        studentAnswertext.textAlignment = .center
        studentAnswertext.text = answer
        
    }
    
    
    func addOptionsWithAnswerDetails(_ answerDetails: AnyObject, withQuestionDetails questionDetails :AnyObject)
    {
        _currentQuestionDetials = questionDetails
        var optionArray = NSMutableArray()
        
        if let options = _currentQuestionDetials.object(forKey: kOptionTagMain) as? NSMutableDictionary
        {
            if let classCheckingVariable = options.object(forKey: "Option") as? NSMutableArray
            {
                
                optionArray = classCheckingVariable
            }
            else if let classCheckingVariable = options.object(forKey: "Option") as? NSMutableDictionary
            {
                   optionArray.add(classCheckingVariable)
            }
        }
        
        
        
        if let Type = _currentQuestionDetials.object(forKey: kQuestionType) as? String
        {
            if Type == kMCQ
            {
                
                addSingleResponseQuestionAnswerWithDetails(answerDetails,withQuestionOptionsArray: optionArray)
            }
            else if Type == kMRQ
            {
                
                addMultipleResponseQuestionAnswerWithDetails(answerDetails,withQuestionOptionsArray: optionArray)
            }
            else if Type == kMatchColumn
            {
                
                addMatchColumnQuestionAnswerWithDetails(answerDetails)
                
            }
        }
    }
    
    
    func addSingleResponseQuestionAnswerWithDetails(_ answerDetails:AnyObject, withQuestionOptionsArray questionOptions:NSMutableArray)
    {
        let studentAnsweOption = NSMutableArray()
        
        if let options = answerDetails.object(forKey: kOptionTagMain)
        {
            if let classCheckingVariable = (options as AnyObject).object(forKey: "Option")
            {
                if let _studentAnswerOption = (classCheckingVariable as AnyObject).object(forKey: "OptionText") as?String
                {
                    studentAnsweOption .add( _studentAnswerOption)
                }
            }
        }
        
        
        _studentFinalAnswerOptions = studentAnsweOption
        
//        let optionsDetails =  getOptionsValuesWithOptionsArray(studentAnsweOption, withQuestionOptions: questionOptions)
       addCheckMarksForMultipleResponseWithOptionsDetails(questionOptions,withAnswerOptions: studentAnsweOption)
        
    }
    
    func addMultipleResponseQuestionAnswerWithDetails(_ answerDetails:AnyObject, withQuestionOptionsArray questionOptions:NSMutableArray)
    {
        var studentAnsweOptions = NSMutableArray()
        if let options = answerDetails.object(forKey: kOptionTagMain) as? NSMutableDictionary
        {
            if let classCheckingVariable = options.object(forKey: "Option") as? NSMutableArray
            {
                studentAnsweOptions = classCheckingVariable
                    
            }
            else
            {
                 studentAnsweOptions.add(options.object(forKey: "Option")!)
            }
            
        }
        
        
        
        let studentFinalAsnwer = NSMutableArray()
        for answerIndex in 0..<studentAnsweOptions.count
        {
            let answerOptiondict = studentAnsweOptions.object(at: answerIndex)
            
            if let answerOptionText = (answerOptiondict as AnyObject).object(forKey: "OptionText") as? String
            {
                studentFinalAsnwer.add(answerOptionText)
                
            }
        }
        
        _studentFinalAnswerOptions = studentFinalAsnwer
//        let optionsDetails =  getOptionsValuesWithOptionsArray(studentFinalAsnwer, withQuestionOptions: questionOptions)
       addCheckMarksForMultipleResponseWithOptionsDetails(questionOptions,withAnswerOptions: studentFinalAsnwer)
        
        
        
    }
    
    
    
    func addMatchColumnQuestionAnswerWithDetails(_ answerOptions:AnyObject)
    {
        
        var studentAnsweOptions = NSMutableArray()
        if let options = answerOptions.object(forKey: kOptionTagMain) as? NSMutableDictionary
        {
            if let classCheckingVariable = options.object(forKey: "Option") as? NSMutableArray
            {
               studentAnsweOptions = classCheckingVariable
            }
            else if let classCheckingVariable = options.object(forKey: "Option") as? NSMutableDictionary
            {
                studentAnsweOptions.add(classCheckingVariable)
                
            }
        }
        
        
        
        
        _studentFinalAnswerOptions = studentAnsweOptions
        addCheckMarksForMatchCoulmnWithOptionsDetails(studentAnsweOptions)
    }
    
    
    
    func getOptionsValuesWithOptionsArray(_ answerOptions:NSMutableArray, withQuestionOptions questionOptions:NSMutableArray)-> NSMutableArray
    {
        
        for index in 0..<questionOptions.count
        {
            let questionOptiondict = questionOptions.object(at: index)
            
            if let questionOptionText = (questionOptiondict as AnyObject).object(forKey: "OptionText") as? String
            {
                for answerIndex in 0..<answerOptions.count
                {
                    if let answerOptionText = answerOptions.object(at: answerIndex) as? String
                    {
                        if answerOptionText == questionOptionText
                        {
                            if let IsAnswer = (questionOptiondict as AnyObject).object(forKey: "IsAnswer") as? String
                            {
                                if IsAnswer == "1"
                                {
                                    (questionOptiondict as AnyObject).set(KCorretValue, forKey: "IsAnswer")
                                    questionOptions.replaceObject(at: index, with: questionOptiondict)
                                }
                                else
                                {
                                    (questionOptiondict as AnyObject).set(kWrongvalue, forKey: "IsAnswer")
                                    questionOptions.replaceObject(at: index, with: questionOptiondict)
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
            let questionOptiondict = questionOptions.object(at: index)
            
            if let IsAnswer = (questionOptiondict as AnyObject).object(forKey: "IsAnswer") as? String
            {
                if IsAnswer == "0" || IsAnswer == "1"
                {
                    (questionOptiondict as AnyObject).set(kMissedValue, forKey: "IsAnswer")
                    questionOptions.replaceObject(at: index, with: questionOptiondict)
                }
                
            }
        }
        
        _studentFinalAnswerOptions = questionOptions
        
        return questionOptions
    }
    
    
    func addCheckMarksForMultipleResponseWithOptionsDetails(_ optionsDetails:NSMutableArray, withAnswerOptions answerOptions:NSMutableArray)
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
            
            
            
            if (count.truncatingRemainder(dividingBy: 2) != 0)
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
                    let containerView =  UIImageView(frame:CGRect(x: width, y: height, width: barWidth, height: barHeight))
                    self.addSubview(containerView);
                    
                    let optionsValueImage = UIImageView()
                    
                    if containerView.frame.size.width > containerView.frame.size.height
                    {
                        optionsValueImage.frame = CGRect(x: (containerView.frame.size.width - containerView.frame.size.height)/2 , y: (containerView.frame.size.width - containerView.frame.size.height)/2, width: containerView.frame.size.height, height: containerView.frame.size.height)
                    }
                    else
                    {
                        optionsValueImage.frame = CGRect(x: (containerView.frame.size.height - containerView.frame.size.width)/2 , y: (containerView.frame.size.height - containerView.frame.size.width)/2, width: containerView.frame.size.width, height: containerView.frame.size.width)
                    }
                    
                    containerView.addSubview(optionsValueImage)
                    
                    optionsValueImage.contentMode = .scaleAspectFit
                    
                    optionsValueImage.backgroundColor = topicsLineColor
                    
                    if optionsArrayCount < optionsDetails.count
                    {
                        let questionOptiondict = optionsDetails.object(at: optionsArrayCount)
                        
                        
                        if let questionOptionText = (questionOptiondict as AnyObject).object(forKey: "OptionText") as? String
                        {
                            for answerIndex in 0..<answerOptions.count
                            {
                                if let answerOptionText = answerOptions.object(at: answerIndex) as? String
                                {
                                    if answerOptionText == questionOptionText
                                    {
                                        if let IsAnswer = (questionOptiondict as AnyObject).object(forKey: "IsAnswer") as? String
                                        {
                                            if IsAnswer == "1"
                                            {
                                                optionsValueImage.image = UIImage(named: "Check.png")
                                                optionsValueImage.backgroundColor = UIColor.clear
                                            }
                                            else if IsAnswer == "0"
                                            {
                                                optionsValueImage.image = UIImage(named: "X.png")
                                                optionsValueImage.backgroundColor = UIColor.clear
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
    
    func addCheckMarksForMatchCoulmnWithOptionsDetails(_ optionsDetails:NSMutableArray)
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
            
            
            
            if (count.truncatingRemainder(dividingBy: 2) != 0)
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
                    let containerView =  UIImageView(frame:CGRect(x: width, y: height, width: barWidth, height: barHeight))
                    self.addSubview(containerView);
                    
                    let studentDesk = UIImageView()
                    
                    if containerView.frame.size.width > containerView.frame.size.height
                    {
                        studentDesk.frame = CGRect(x: (containerView.frame.size.width - containerView.frame.size.height)/2 , y: (containerView.frame.size.width - containerView.frame.size.height)/2, width: containerView.frame.size.height, height: containerView.frame.size.height)
                    }
                    else
                    {
                        studentDesk.frame = CGRect(x: (containerView.frame.size.height - containerView.frame.size.width)/2 , y: (containerView.frame.size.height - containerView.frame.size.width)/2, width: containerView.frame.size.width, height: containerView.frame.size.width)
                    }
                    
                    containerView.addSubview(studentDesk)
                    
                    studentDesk.contentMode = .scaleAspectFit
                    
                    studentDesk.backgroundColor = topicsLineColor
                    
                    if optionsArrayCount < optionsDetails.count
                    {
                        let questionOptiondict = optionsDetails.object(at: optionsArrayCount)
                        
                        if let OldSequence = (questionOptiondict as AnyObject).object(forKey: "OldSequence") as? String
                        {
                            if let Sequence = (questionOptiondict as AnyObject).object(forKey: "Sequence") as? String
                            {
                                if OldSequence == Sequence
                                {
                                    studentDesk.image = UIImage(named: "Check.png")
                                    studentDesk.backgroundColor = UIColor.clear
                                }
                                else
                                {
                                    studentDesk.image = UIImage(named: "X.png")
                                    studentDesk.backgroundColor = UIColor.clear
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
    
    
    func setStudentEvaluationStatusWithDetails(_ details:AnyObject)
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

        
        if let teacherScribble = details.object(forKey: "imageUrl") as? String
        {
            let overLayImage = CustomProgressImageView(frame: CGRect(x: 0,y: 0,width: self.frame.size.width,height: self.frame.size.height))
            self.addSubview(overLayImage)
            
            
            let urlString = UserDefaults.standard.object(forKey: k_INI_QuestionsImageUrl) as! String
            
            if let checkedUrl = URL(string: "\(urlString)/\(teacherScribble)")
            {
                overLayImage.contentMode = .scaleAspectFit
                overLayImage.downloadImage(checkedUrl, withFolderType: folderType.questionImage,withResizeValue: self.frame.size)
            }
            
        }

        
        
        var ratings = 0
        var badgeId = 0
        var textReply = ""
        
        
        
        let mTeacherReplyState = UIImageView(frame: CGRect(x: 0,y: self.frame.size.height - (self.frame.size.height / 3) ,width: self.frame.size.width,height: self.frame.size.height / 3))
        self.addSubview(mTeacherReplyState)
        mTeacherReplyState.backgroundColor = UIColor(red: 34/255.0, green:68/255.0, blue:99/255.0, alpha: 0.8)
        
        

       
        
       print("details ==== \(details)")
        
        if let Rating = details.object(forKey: "Rating") as? String
        {
            
            ratings = Int(Rating)!
        }
        
        if let BadgeId = details.object(forKey: "BadgeId") as? String
        {
            badgeId = Int(BadgeId)!
            
        }
        
        if let textRating = details.object(forKey: "textRating") as? String
        {
            textReply = textRating
            
        }

        
        
        if ratings > 0
        {
            let starview = StudentStarView(frame: CGRect(x: 0,y: 0,width: mTeacherReplyState.frame.size.width,height: mTeacherReplyState.frame.size.height))
           starview.addStars(withRatings: Int32(ratings), withSize: Float(mTeacherReplyState.frame.size.height))
            starview.backgroundColor = UIColor.clear
            mTeacherReplyState.addSubview(starview)
        }
        else if badgeId > 0
        {
            let imageLoader = ImageUploading()
            
            let BadgeIdImage = UIImageView(frame: CGRect(x: 0,y: 0,width: mTeacherReplyState.frame.size.width,height: mTeacherReplyState.frame.size.height))
            BadgeIdImage.contentMode = .scaleAspectFit
            BadgeIdImage.image = imageLoader.getImageWithBadgeId(Int32(badgeId))
            
            mTeacherReplyState.addSubview(BadgeIdImage)
        }
        else if textReply != ""
        {
            let studentAnswertext = UILabel(frame: CGRect(x: 0,y: 0,width: mTeacherReplyState.frame.size.width,height: mTeacherReplyState.frame.size.height))
            mTeacherReplyState.addSubview(studentAnswertext)
            
            var fontHeight = studentAnswertext.frame.size.height/3;
            
            if (fontHeight > 14)
            {
                fontHeight = 14;
            }
            
            studentAnswertext.font = UIFont(name: RobotItalic, size: fontHeight)
            studentAnswertext.textColor = UIColor.white
            studentAnswertext.lineBreakMode = .byTruncatingMiddle
            studentAnswertext.numberOfLines = 10
            studentAnswertext.textAlignment = .center
            studentAnswertext.text = textReply
            
        }
        
        
        if let ModelAnswerFlag = details.object(forKey: "ModelAnswerFlag") as? String
        {
            if ModelAnswerFlag == "true"
            {
                let modelAnswerLabel = UILabel(frame: CGRect(x: 0,y: 0,width: self.frame.size.width,height: mTeacherReplyState.frame.size.height / 1.8))
                modelAnswerLabel.backgroundColor = standard_Green
                modelAnswerLabel.textColor = UIColor.white
                
                var fontHeight = modelAnswerLabel.frame.size.height/1.2;
                
                if (fontHeight > 14)
                {
                    fontHeight = 14;
                }
                
                modelAnswerLabel.font = UIFont(name: RobotItalic, size: fontHeight)
                modelAnswerLabel.textColor = UIColor.white
                modelAnswerLabel.lineBreakMode = .byTruncatingMiddle
                modelAnswerLabel.numberOfLines = 10
                modelAnswerLabel.textAlignment = .center
                modelAnswerLabel.text = "Model Answer"
                self.addSubview(modelAnswerLabel)
                
                
            }
            
            
        }
        
        
        
        
    }
    
    
    
    
    
}
