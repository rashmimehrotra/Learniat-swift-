//
//  MainTopicsView.swift
//  LearniatTeacher
//
//  Created by Deepak MK on 25/04/16.
//  Copyright © 2016 Mindshift. All rights reserved.
//

import Foundation

@objc protocol MainTopicsViewDelegate
{
    
    
    @objc optional func delegateShowSubTopicWithMainTopicId(_ mainTopicID:String, WithMainTopicName mainTopicName:String)
    
    @objc optional func delegateDoneButtonPressed()
    
    @objc optional func delegateTopicsSizeChangedWithHeight(_ height:CGFloat)
    
    
    
}



class MainTopicsView: UIView, SSTeacherDataSourceDelegate,MainTopicCellDelegate
{
    
    var currentSessionDetails       :AnyObject!
    
    var mTopicsContainerView        = UIScrollView()
    
    var mMaintopicsDetails          = NSMutableArray()
    
    var startedmainTopicId           = ""
    
    var mActivityIndicator  = UIActivityIndicatorView(activityIndicatorStyle:.gray)
    
    var  mTopicName  = UILabel()
    
    
    var _delgate: AnyObject!
    
    
    var currentMainTopicsViewHeight :CGFloat = 0
    
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
        
        let mTopbarImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: self.frame.size.width, height: 44))
        
        mTopbarImageView.backgroundColor = UIColor.white
        self.addSubview(mTopbarImageView)
        mTopbarImageView.isUserInteractionEnabled = true
        
        
        
        
        
        
        mTopicsContainerView.frame = CGRect(x: 0, y: 44, width: self.frame.size.width, height: self.frame.size.height - 44)
        mTopicsContainerView.backgroundColor = UIColor.white
        self.addSubview(mTopicsContainerView)
        mTopicsContainerView.isHidden = true
        
        
        let seperatorView = UIView(frame: CGRect(x: 0 ,y: mTopbarImageView.frame.size.height - 1 , width: mTopbarImageView.frame.size.width,height: 1))
        seperatorView.backgroundColor = LineGrayColor;
        mTopbarImageView.addSubview(seperatorView)
        
        
        let  mDoneButton = UIButton(frame: CGRect(x: mTopbarImageView.frame.size.width - 210,  y: 0, width: 200 ,height: mTopbarImageView.frame.size.height))
        mTopbarImageView.addSubview(mDoneButton)
        mDoneButton.addTarget(self, action: #selector(MainTopicsView.onDoneButton), for: UIControlEvents.touchUpInside)
        mDoneButton.setTitleColor(standard_Button, for: UIControlState())
        mDoneButton.setTitle("Done", for: UIControlState())
        mDoneButton.contentHorizontalAlignment = UIControlContentHorizontalAlignment.right
        mDoneButton.titleLabel?.font = UIFont(name: helveticaMedium, size: 20)
        
        
        mTopicName.frame = CGRect(x: (mTopbarImageView.frame.size.width - 200)/2, y: 0 , width: 200, height: mTopbarImageView.frame.size.height)
        mTopicName.font = UIFont(name:helveticaMedium, size: 20)
        mTopbarImageView.addSubview(mTopicName)
        mTopicName.textColor = UIColor.black
        mTopicName.text = "Topics"
        mTopicName.textAlignment = .center
        
        
        mActivityIndicator.frame = CGRect(x: 20, y: 0, width: mTopbarImageView.frame.size.height,height: mTopbarImageView.frame.size.height)
        mTopbarImageView.addSubview(mActivityIndicator)
        mActivityIndicator.hidesWhenStopped = true
        mActivityIndicator.isHidden = true
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    func setSessionDetails( _ details:AnyObject)
    {
        currentSessionDetails = details
    }
    
    
    
    
    func getTopicsDetailswithStartedMaintopicId(_ topicId:String)
    {
        
        
        if mMaintopicsDetails.count <= 0
        {
            if let ClassId = currentSessionDetails.object(forKey: "ClassId") as? String
            {
                
                if let SubjectId = currentSessionDetails.object(forKey: "SubjectId") as? String
                {
                    
                    let subViews = mTopicsContainerView.subviews.flatMap{ $0 as? MainTopicCell }
                    
                    for subview in subViews
                    {
                        if subview.isKind(of: MainTopicCell.self)
                        {
                            subview.removeFromSuperview()
                        }
                    }
                    
                    mActivityIndicator.isHidden = false
                    mActivityIndicator.startAnimating()
                    
                    SSTeacherDataSource.sharedDataSource.getAllNodesWithClassId(ClassId, withSubjectId: SubjectId, withTopicId: "", withType: onlyMainTopics, withDelegate: self)
                }
                
                
            }
        }
        
        if SSTeacherDataSource.sharedDataSource.startedMainTopicId != ""
        {
            if let subTopicCellView  = mTopicsContainerView.viewWithTag(Int(SSTeacherDataSource.sharedDataSource.startedMainTopicId)!) as? MainTopicCell
            {
                
                if SSTeacherDataSource.sharedDataSource.isSubtopicStarted == true
                {
                    subTopicCellView.m_MainTopicLabel.textColor = standard_Green
                }
                else
                {
                    subTopicCellView.m_MainTopicLabel.textColor = blackTextColor
                }
                
            }
            
        }
        
        
        
    }
    
    
    // MARK: - datasource delegate functions
    
    func didGetAllNodesWithDetails(_ details: AnyObject) {
        
        mMaintopicsDetails.removeAllObjects()
        
        if let statusString = details.object(forKey: "Status") as? String
        {
            if statusString == kSuccessString
            {
                
               if let classCheckingVariable = (details.object(forKey: "MainTopics")! as AnyObject).object(forKey: "MainTopic") as? NSMutableArray
               {
                    mMaintopicsDetails = classCheckingVariable
                }
                else
                {
                    mMaintopicsDetails.add((details.object(forKey: "MainTopics")! as AnyObject).object(forKey: "MainTopic")!)
                    
                }
                
                addTopicsForheight()
            }
        }
    }
    
    
    func addTopicsForheight()
    {
        
        
        
        if mMaintopicsDetails.count <= 0
        {
            mTopicName.text = "No Topics found"
            
            mTopicsContainerView.isHidden = true
        }
        else
        {
            mTopicName.text = "Topics"
            mTopicsContainerView.isHidden = false
        }
        
        
        
        
        let topicsArray = NSMutableArray()
        for index in 0 ..< mMaintopicsDetails.count
        {
            
            
            let currentTopicDetails = mMaintopicsDetails.object(at: index)
            
            if let Tagged = (currentTopicDetails as AnyObject).object(forKey: "Tagged") as? String
            {
                if Tagged == "1"
                {
                    topicsArray.add(currentTopicDetails)
                }
            }
        }
        
        var height :CGFloat = CGFloat((topicsArray.count * 60) + 44)
        
        
        if height > UIScreen.main.bounds.height - 100
        {
            height = UIScreen.main.bounds.height - 100
        }
        
        
        UIView.animate(withDuration: 0.5, animations:
            {
                self.frame =  CGRect(x: self.frame.origin.x, y: self.frame.origin.y, width: 600, height: height)
        })
        
        
        
        
        
        mTopicsContainerView.frame = CGRect(x: 0, y: 44, width: mTopicsContainerView.frame.size.width, height: height - 44)
        
        var positionY :CGFloat = 0
        
        for index in 0 ..< topicsArray.count
        {
            let currentTopicDetails = topicsArray.object(at: index)
            let topicCell = MainTopicCell(frame: CGRect(x: 0  , y: positionY, width: mTopicsContainerView.frame.size.width, height: 60))
            topicCell.setdelegate(self)
            topicCell.setMainTopicDetails(currentTopicDetails as AnyObject)
            mTopicsContainerView.addSubview(topicCell)
            positionY = positionY + topicCell.frame.size.height
        }
        
        mTopicsContainerView.contentSize = CGSize(width: 0, height: positionY + 20)
        
        mActivityIndicator.stopAnimating()
        
        currentMainTopicsViewHeight = height
        
        if delegate().responds(to: #selector(MainTopicsViewDelegate.delegateTopicsSizeChangedWithHeight(_:)))
        {
            delegate().delegateTopicsSizeChangedWithHeight!(height)
        }
        
    }
    
    
    func onDoneButton()
    {
        if delegate().responds(to: #selector(MainTopicsViewDelegate.delegateDoneButtonPressed))
        {
            delegate().delegateDoneButtonPressed!()
        }
        
        
    }
    
   
    
    func delegateSubtopicButtonPressedWithID(_ mainTopicId: String, withmainTopicname mainTopicName: String) {
        
        if delegate().responds(to: #selector(MainTopicsViewDelegate.delegateShowSubTopicWithMainTopicId(_:WithMainTopicName:)))
        {
            delegate().delegateShowSubTopicWithMainTopicId!(mainTopicId ,WithMainTopicName:mainTopicName )
        }
        
    }
    
    
}
