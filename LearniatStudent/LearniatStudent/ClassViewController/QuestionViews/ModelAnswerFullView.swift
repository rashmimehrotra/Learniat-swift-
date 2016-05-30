//
//  ModelAnswerFullView.swift
//  LearniatStudent
//
//  Created by Deepak MK on 27/05/16.
//  Copyright © 2016 Mindshift. All rights reserved.
//

import Foundation
class ModelAnswerFullView: UIView{
   
    
    var mQuestionLabel = UILabel()
    
    var modelAnswerScrollView = UIScrollView()
    
    let shareGraphButton  = UIButton()
    
    var   modelAnswerArray = NSMutableArray()
    override init(frame: CGRect)
    {
        super.init(frame: frame)
        
        self.backgroundColor = whiteBackgroundColor
        
        mQuestionLabel.frame = CGRectMake(10, 10, self.frame.size.width-20, 80)
        mQuestionLabel.numberOfLines = 20;
        mQuestionLabel.textAlignment = .Center
        self.addSubview(mQuestionLabel)
        mQuestionLabel.textColor = topbarColor
        mQuestionLabel.font = UIFont (name: helveticaRegular, size: 20)
        mQuestionLabel.lineBreakMode = .ByTruncatingMiddle
        
        
        modelAnswerScrollView.frame = CGRectMake(10, mQuestionLabel.frame.origin.y + mQuestionLabel.frame.size.height, self.frame.size.width - 20, self.frame.size.height - (mQuestionLabel.frame.origin.y + mQuestionLabel.frame.size.height));
        self.addSubview(modelAnswerScrollView)
        
        

        shareGraphButton.frame = CGRectMake(self.frame.size.width - 50, 10, 40,30)
        shareGraphButton.setImage(UIImage(named:"wrongMatch.png"), forState:.Normal)
        self.addSubview(shareGraphButton);
        shareGraphButton.imageView?.contentMode = .ScaleAspectFit
        shareGraphButton.addTarget(self, action: #selector(ModelAnswerFullView.onCloseButton), forControlEvents: UIControlEvents.TouchUpInside)

        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func onCloseButton()
    {
        self.removeFromSuperview()
    }
    func setModelAnswerDetailsArray(modelAnswersArray:NSMutableArray, withQuestionName questionName:String , withOverlayImage overlay:UIImage)
    {
        
        mQuestionLabel.text = questionName
        
        let subViews = modelAnswerScrollView.subviews
        
        for subview in subViews
        {
            if subview.isKindOfClass(ModelAnswerFullViewSubView)
            {
                subview.removeFromSuperview()
            }
        }

        
        
        var positionY:CGFloat = 0
        
        for index in 0  ..< modelAnswersArray.count
        {
            
            let dict = modelAnswersArray.objectAtIndex(index)
            
            print(dict)
            let modelAnswer  = ModelAnswerFullViewSubView(frame: CGRectMake(0, positionY, modelAnswerScrollView.frame.size.width,modelAnswerScrollView.frame.size.height))
            modelAnswerScrollView.addSubview(modelAnswer)
           modelAnswer.setModelAnswerDetails(dict,withOverlay:overlay )
            
            
            
            
            positionY = positionY + modelAnswer.frame.size.height 
            
        }
        
        modelAnswerScrollView.contentSize = CGSizeMake(0,positionY)
        
    }
    
    
}