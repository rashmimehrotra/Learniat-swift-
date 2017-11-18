//
//  CollaborationQuestionCell.swift
//  LearniatTeacher
//
//  Created by Deepak MK on 01/03/17.
//  Copyright © 2017 Mindshift. All rights reserved.
//

import Foundation

class CollaborationQuestionCell: UIButton {

   
    var optionDetails :AnyObject!
    
    var mCorrectButton  = UIImageView()
    
    var isCorrect = false
    
    var mSuggestiontext = DynamicFontSize()
    
    override init(frame: CGRect)
    {
        super.init(frame:frame)
        
        
        
        mCorrectButton.frame = CGRect(x: (self.frame.size.width - 40)/2, y: 10, width: 40, height: 40)
        mCorrectButton.image = UIImage(named: "wrongMatch.png")
        self.addSubview(mCorrectButton)
        
        
        
        mSuggestiontext = DynamicFontSize(frame: CGRect(x:5, y: mCorrectButton.frame.origin.y + mCorrectButton.frame.size.height + 5,width: self.frame.size.width - 10, height: self.frame.size.height - (mCorrectButton.frame.origin.y + mCorrectButton.frame.size.height + 5)))
        mSuggestiontext.font = UIFont(name:helveticaMedium, size: 18)
        self.addSubview(mSuggestiontext)
        mSuggestiontext.textColor = blackTextColor
        mSuggestiontext.textAlignment = .center
        mSuggestiontext.lineBreakMode = .byTruncatingMiddle
        mSuggestiontext.numberOfLines = 10
        
        mSuggestiontext.minimumScaleFactor = 0.2
        mSuggestiontext.verticalAlignment = VerticalAlignmentTop
        mSuggestiontext.adjustHeight()

        self.addTarget(self, action: #selector(CollaborationQuestionCell.onSelfButtonPressed), for: UIControlEvents.touchUpInside)

        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
        
    }

    func setOptionDetails(details:AnyObject)
    {
        optionDetails = details
        print(optionDetails)
        if let mSuggestion = details.object(forKey: "SuggestTxt") as? String
        {
            mSuggestiontext.text = mSuggestion
            
        }
        
    }
    
    func onSelfButtonPressed()
    {
        if isCorrect == true
        {
            isCorrect = false
            
            mCorrectButton.image = UIImage(named: "wrongMatch.png")
            
        }
        else
        {
            isCorrect = true
            mCorrectButton.image = UIImage(named: "correctMatch.png")
        }
    }

}
