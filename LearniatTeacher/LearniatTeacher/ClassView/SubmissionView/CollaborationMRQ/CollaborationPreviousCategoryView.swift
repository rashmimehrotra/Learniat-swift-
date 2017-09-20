//
//  CollaborationPreviousCategoryView.swift
//  LearniatTeacher
//
//  Created by Deepak MK on 18/03/17.
//  Copyright © 2017 Mindshift. All rights reserved.
//

import Foundation

@objc protocol CollaborationPreviousCategoryViewDelegate
{
    
    @objc optional func delegateCategoryIdSelectedWithDetails(details:AnyObject)
    
    
}



class CollaborationPreviousCategoryView: UIView {

    var mScrollView = UIScrollView()
    
    var _delgate: AnyObject!
    
    func setdelegate(_ delegate:AnyObject)
    {
        _delgate = delegate;
    }
    
    func   delegate()->AnyObject
    {
        return _delgate;
    }
    
    
    override init(frame: CGRect)
    {
        super.init(frame:frame)
        
      
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func loadAllSubview()
    {
        mScrollView.frame = CGRect(x: 0, y: 0, width: self.frame.size.width, height: self.frame.size.height)
        self.addSubview(mScrollView)

    }
    
    func addPreviousCategoryWithCategoires(categories:NSMutableArray)
    {
        var currentYposition:CGFloat = 10
        
        let subViews = mScrollView.subviews
        for mQuerySubView in subViews
        {
           mQuerySubView.removeFromSuperview()
        }
        
        
        
        for categoryValues in categories
        {
            let mPreviousCategoryCells = previousCategoryCells(frame:CGRect(x: 5, y: Int(currentYposition), width: Int(mScrollView.frame.size.width - 10) , height: 40))
            mPreviousCategoryCells.backgroundColor = whiteColor
            mPreviousCategoryCells.setdelegate(self)
            mPreviousCategoryCells.frame = CGRect(x: mPreviousCategoryCells.frame.origin.x, y: mPreviousCategoryCells.frame.origin.y, width: mPreviousCategoryCells.frame.size.width, height: mPreviousCategoryCells.getHeightFromCategoryDetails(details: categoryValues as AnyObject))
            mScrollView.addSubview(mPreviousCategoryCells)
            
            currentYposition = currentYposition + mPreviousCategoryCells.frame.size.height + 2
            
            
        }
        
        mScrollView.contentSize = CGSize(width: 0, height: currentYposition)
    }
    
    func delegateCategorySelectedWithDetails(details:AnyObject)
    {
        delegate().delegateCategoryIdSelectedWithDetails!(details: details)
    }
    
    

}
