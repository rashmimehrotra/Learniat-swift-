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
        
        mQuestionLabel.frame = CGRect(x: 10, y: 10, width: self.frame.size.width-20, height: 80)
        mQuestionLabel.numberOfLines = 20;
        mQuestionLabel.textAlignment = .center
        self.addSubview(mQuestionLabel)
        mQuestionLabel.textColor = topbarColor
        mQuestionLabel.font = UIFont (name: helveticaRegular, size: 20)
        mQuestionLabel.lineBreakMode = .byTruncatingMiddle
        
        
        modelAnswerScrollView.frame = CGRect(x: 10, y: mQuestionLabel.frame.origin.y + mQuestionLabel.frame.size.height, width: self.frame.size.width - 20, height: self.frame.size.height - (mQuestionLabel.frame.origin.y + mQuestionLabel.frame.size.height));
        self.addSubview(modelAnswerScrollView)
        
        

        shareGraphButton.frame = CGRect(x: self.frame.size.width - 50, y: 10, width: 40,height: 30)
        shareGraphButton.setImage(UIImage(named:"wrongMatch.png"), for:UIControlState())
        self.addSubview(shareGraphButton);
        shareGraphButton.imageView?.contentMode = .scaleAspectFit
        shareGraphButton.addTarget(self, action: #selector(ModelAnswerFullView.onCloseButton), for: UIControlEvents.touchUpInside)

        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func onCloseButton()
    {
        self.removeFromSuperview()
    }
    func setModelAnswerDetailsArray(_ modelAnswersArray:NSMutableArray, withQuestionName questionName:String , withOverlayImage overlay:UIImage)
    {
        
        mQuestionLabel.text = questionName
        
        let subViews = modelAnswerScrollView.subviews
        
        for subview in subViews
        {
            if subview.isKind(of: ModelAnswerFullViewSubView.self)
            {
                subview.removeFromSuperview()
            }
        }

        
        
        var positionY:CGFloat = 0
        
        for index in 0  ..< modelAnswersArray.count
        {
            
            let dict = modelAnswersArray.object(at: index)
            
            print(dict)
            let modelAnswer  = ModelAnswerFullViewSubView(frame: CGRect(x: 0, y: positionY, width: modelAnswerScrollView.frame.size.width,height: modelAnswerScrollView.frame.size.height))
            modelAnswerScrollView.addSubview(modelAnswer)
           modelAnswer.setModelAnswerDetails(dict as AnyObject,withOverlay:overlay )
            
            
            
            
            positionY = positionY + modelAnswer.frame.size.height 
            
        }
        
        modelAnswerScrollView.contentSize = CGSize(width: 0,height: positionY)
        
    }
    
    
}
