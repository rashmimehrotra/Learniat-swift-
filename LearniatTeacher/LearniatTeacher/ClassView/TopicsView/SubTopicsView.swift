//
//  SubTopicsView.swift
//  LearniatTeacher
//
//  Created by Deepak MK on 25/04/16.
//  Copyright © 2016 Mindshift. All rights reserved.
//

import Foundation
@objc protocol SubTopicsViewDelegate
{
    
    
    @objc optional func delegateSubTopicBackButtonPressed()
    
    @objc optional func delegateSubtopicStateChanedWithSubTopicDetails(_ subTopicDetails:AnyObject, withState state:Bool, withmainTopicName mainTopicName:String)
    
    
    @objc optional func delegateQuestionButtonPressedWithSubtopicId(_ subtopicId:String, withSubTopicName subTopicName:String, withMainTopicId mainTopicId:String, withMainTopicName mainTopicName:String)
    

    @objc optional func delegateDoneButtonPressed()
    
    @objc optional func delegateTopicsSizeChangedWithHeight(_ height:CGFloat)
    
}

class SubTopicsView: UIView,SSTeacherDataSourceDelegate, SubTopicCellDelegate
{
    var _delgate: AnyObject!
    
    
    var currentSessionDetails       :AnyObject!
    
    var mTopicsContainerView        = UIScrollView()
    
    var mActivityIndicator  = UIActivityIndicatorView(activityIndicatorStyle:.gray)
    
    var  mTopicName  = UILabel()
    
    var currentMainTopicId                  = ""
    
    var startedSubtopicID                   = ""
    
    
     var currentMainTopicsViewHeight :CGFloat = 0
    
    
    var cumulativeTimer                    = Timer()
    
    var currentCumulativeiTime              = ""
    
    
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
        mTopbarImageView.backgroundColor = lightGrayTopBar
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
        mDoneButton.addTarget(self, action: #selector(SubTopicsView.onDoneButton), for: UIControlEvents.touchUpInside)
        mDoneButton.setTitleColor(standard_Button, for: UIControlState())
        mDoneButton.setTitle("Done", for: UIControlState())
        mDoneButton.contentHorizontalAlignment = UIControlContentHorizontalAlignment.right
        mDoneButton.titleLabel?.font = UIFont(name: helveticaMedium, size: 20)
        
        
        
        
        let  mBackButton = UIButton(frame: CGRect(x: 10,  y: 0, width: 200 ,height: mTopbarImageView.frame.size.height))
        mTopbarImageView.addSubview(mBackButton)
        mBackButton.addTarget(self, action: #selector(SubTopicsView.onBackButton), for: UIControlEvents.touchUpInside)
        mBackButton.setTitleColor(standard_Button, for: UIControlState())
        mBackButton.setTitle("Back", for: UIControlState())
        mBackButton.contentHorizontalAlignment = UIControlContentHorizontalAlignment.left
        mBackButton.titleLabel?.font = UIFont(name: helveticaMedium, size: 20)
        
        
        mTopicName.frame = CGRect(x: (mTopbarImageView.frame.size.width - 400)/2, y: 0 , width: 400, height: mTopbarImageView.frame.size.height)
        mTopicName.font = UIFont(name:helveticaMedium, size: 20)
        mTopbarImageView.addSubview(mTopicName)
        mTopicName.textColor = UIColor.black
        mTopicName.text = "Sub topics"
        mTopicName.textAlignment = .center
        mTopicName.lineBreakMode = .byTruncatingMiddle
        
        mActivityIndicator.frame = CGRect(x: 100, y: 0, width: mTopbarImageView.frame.size.height,height: mTopbarImageView.frame.size.height)
        mTopbarImageView.addSubview(mActivityIndicator)
        mActivityIndicator.hidesWhenStopped = true
        mActivityIndicator.isHidden = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    func setSessionDetails(_ details:AnyObject)
    {
        currentSessionDetails = details
       
        
        
    }
    
    
    
    func clearSubTopicDetailsWithMainTopicId(_ mainTopicId:String)
    {
       
        if SSTeacherDataSource.sharedDataSource.subTopicDetailsDictonary.object(forKey: mainTopicId) != nil
        {
            SSTeacherDataSource.sharedDataSource.subTopicDetailsDictonary.removeObject(forKey: mainTopicId)
        }
    }
    
    
    func getSubtopicsDetailsWithMainTopicId(_ mainTopicId:String, withMainTopicName mainTopicname:String, withStartedSubtopicID _startedSubtopicID:String)
    {
        
        currentMainTopicId = mainTopicId
        startedSubtopicID = _startedSubtopicID
        mTopicName.text = mainTopicname
        
        
        
        
        
        
        if let currentMainTopicDetails = SSTeacherDataSource.sharedDataSource.subTopicDetailsDictonary.object(forKey: currentMainTopicId) as? NSMutableArray
        {
            
            if currentMainTopicDetails.count > 0
            {
                addTopicsWithDetailsArray(currentMainTopicDetails)
            }
            else
            {
                if let ClassId = currentSessionDetails.object(forKey: "ClassId") as? String
                {
                    
                    if let SubjectId = currentSessionDetails.object(forKey: "SubjectId") as? String
                    {
                        mActivityIndicator.isHidden = false
                        mActivityIndicator.startAnimating()
                        
                        SSTeacherDataSource.sharedDataSource.getAllNodesWithClassId(ClassId, withSubjectId: SubjectId, withTopicId: currentMainTopicId, withType: onlySubTopics, withDelegate: self)
                    }
                    
                    
                }
            }
        }
        else
        {
            if let ClassId = currentSessionDetails.object(forKey: "ClassId") as? String
            {
                
                if let SubjectId = currentSessionDetails.object(forKey: "SubjectId") as? String
                {
                    
                    let subViews = mTopicsContainerView.subviews.flatMap{ $0 as? SubTopicCell }
                    
                    for subview in subViews
                    {
                        if subview.isKind(of: SubTopicCell.self)
                        {
                            subview.removeFromSuperview()
                        }
                    }
                    mActivityIndicator.isHidden = false
                    mActivityIndicator.startAnimating()
                    
                    SSTeacherDataSource.sharedDataSource.getAllNodesWithClassId(ClassId, withSubjectId: SubjectId, withTopicId: currentMainTopicId, withType: onlySubTopics, withDelegate: self)
                }
                
                
            }
        }
        
        
    }
    
    
    
    func updateSubtopicCumulativeTimeWithID(_ subToicId:String, withCumulativeTime cumulativeTime:String)
    {
        if let subTopicView  = mTopicsContainerView.viewWithTag(Int(subToicId)!) as? SubTopicCell
        {
            subTopicView.m_SubTopicLabel.text = cumulativeTime.capitalized
            
        }
    }
    
    
    // MARK: - datasource delegate functions
    
    func didGetAllNodesWithDetails(_ details: AnyObject) {
        
        
        if let statusString = details.object(forKey: "Status") as? String
        {
            if statusString == kSuccessString
            {
                var mMaintopicsDetails = NSMutableArray()
               if let classCheckingVariable = (details.object(forKey: "SubTopics")! as AnyObject).object(forKey: "SubTopic") as? NSMutableArray
               {
                    mMaintopicsDetails = classCheckingVariable
                }
                else
               {
                    mMaintopicsDetails.add((details.object(forKey: "SubTopics")! as AnyObject).object(forKey: "SubTopic")!)
                }
                
                SSTeacherDataSource.sharedDataSource.setSubTopicDictonaryWithDict(mMaintopicsDetails, withKey: currentMainTopicId)
                
                
                
                
                addTopicsWithDetailsArray(mMaintopicsDetails)
            }
        }
    }
    
    
    func addTopicsWithDetailsArray(_ mMaintopicsDetails:NSMutableArray)
    {
        
        
        
        if mMaintopicsDetails.count <= 0
        {
            mTopicsContainerView.isHidden = true
        }
        else
        {
            mTopicsContainerView.isHidden = false
        }
        
        
        
        
        let subViews = mTopicsContainerView.subviews.flatMap{ $0 as? SubTopicCell }
        
        for subview in subViews
        {
            if subview.isKind(of: SubTopicCell.self)
            {
                subview.removeFromSuperview()
            }
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
        
        
        currentMainTopicsViewHeight = height
        
        UIView.animate(withDuration: 0.5, animations:
            {
                self.frame =  CGRect(x: self.frame.origin.x, y: self.frame.origin.y, width: 600, height: height)
        })
        
        
        
        mTopicsContainerView.frame = CGRect(x: 0, y: 44, width: mTopicsContainerView.frame.size.width, height: height - 44)
        
        var positionY :CGFloat = 0
        
        for index in 0 ..< topicsArray.count
        {
            let currentTopicDetails = topicsArray.object(at: index)
            
            if let Tagged = (currentTopicDetails as AnyObject).object(forKey: "Tagged") as? String
            {
                if Tagged == "1"
                {
                    let topicCell = SubTopicCell(frame: CGRect(x: 0  , y: positionY, width: mTopicsContainerView.frame.size.width, height: 60))
                    topicCell.setdelegate(self)
                    topicCell.setSubTopicDetails(currentTopicDetails as AnyObject)
                    
                    
                    if let id = (currentTopicDetails as AnyObject).object(forKey: "Id") as? String
                    {
                        if id == SSTeacherDataSource.sharedDataSource.startedSubTopicId && SSTeacherDataSource.sharedDataSource.isSubtopicStarted == true
                        {
                            topicCell.startButton.setTitle("Stop", for: UIControlState())
                            topicCell.startButton.setTitleColor(standard_Red, for: UIControlState())
                            
                            if let topicName = (currentTopicDetails as AnyObject).object(forKey: "Name")as? String
                            {
                                topicCell.m_SubTopicLabel.text = "\(topicName)(\(currentCumulativeiTime))".capitalized
                                
                            }
                           
                        }
                        else
                        {
                            topicCell.startButton.setTitle("Start", for: UIControlState())
                            topicCell.startButton.setTitleColor(standard_Green, for: UIControlState())
                        }
                    }
                    
                   
                    
                    mTopicsContainerView.addSubview(topicCell)
                    positionY = positionY + topicCell.frame.size.height
                    
                }
            }
            
            
        }
        
        mTopicsContainerView.contentSize = CGSize(width: 0, height: positionY + 20)
        
        mActivityIndicator.stopAnimating()
        
        
        if delegate().responds(to: #selector(SubTopicsViewDelegate.delegateTopicsSizeChangedWithHeight(_:)))
        {
            delegate().delegateTopicsSizeChangedWithHeight!(height)
        }
    }
    
    
    func onBackButton()
    {
        if delegate().responds(to: #selector(SubTopicsViewDelegate.delegateSubTopicBackButtonPressed))
        {
            delegate().delegateSubTopicBackButtonPressed!()
        }
    }
    
    
    // MARK: - SubTopics delegate functions
    
    func delegateQuestionButtonPressedWithID(_ subTopicId: String, withSubTopicName subTopicName: String) {
        
        if delegate().responds(to: #selector(SubTopicsViewDelegate.delegateQuestionButtonPressedWithSubtopicId(_:withSubTopicName:withMainTopicId:withMainTopicName:)))
        {
            
            delegate().delegateQuestionButtonPressedWithSubtopicId!(subTopicId, withSubTopicName: subTopicName, withMainTopicId: currentMainTopicId, withMainTopicName: mTopicName.text!)
        }
        
        
        
        let subViews = mTopicsContainerView.subviews.flatMap{ $0 as? SubTopicCell }
        
        for subview in subViews
        {
            if subview.isKind(of: SubTopicCell.self)
            {
                if subview.startButton.titleLabel?.text == "Stop"
                {
                    //                    delegate().delegateSubtopicHiddenWithCumulativeTime!((subview.currentSubTopicDetails.objectForKey("CumulativeTime")as? String)!)
                    
                }
                subview.removeFromSuperview()
            }
        }
    }
    
    
    func onDoneButton()
    {
        if delegate().responds(to: #selector(SubTopicsViewDelegate.delegateDoneButtonPressed))
        {
            delegate().delegateDoneButtonPressed!()
        }
    }
  
    func delegateSubTopicCellStartedWithDetails(_ subTopicDetails: AnyObject, witStatedState isStarted: Bool) {
        
        
        
        if SSTeacherDataSource.sharedDataSource.subTopicDetailsDictonary.object(forKey: currentMainTopicId) != nil
        {
            SSTeacherDataSource.sharedDataSource.subTopicDetailsDictonary.removeObject(forKey: currentMainTopicId)
        }

        
        if isStarted == true
        {
            
            if SSTeacherDataSource.sharedDataSource.isSubtopicStarted == true
            {
                if let subTopicCellView  = mTopicsContainerView.viewWithTag(Int(SSTeacherDataSource.sharedDataSource.startedSubTopicId)!) as? SubTopicCell
                {
                    subTopicCellView.startButton.setTitle("Stop", for: UIControlState())
                    subTopicCellView.startButton.setTitleColor(standard_Red, for: UIControlState())
                    
                }
                
                if let CumulativeTime = subTopicDetails.object(forKey: "CumulativeTime")as? String
                {
                    currentCumulativeiTime = CumulativeTime
                    
                }
                
                SSTeacherDataSource.sharedDataSource.startedMainTopicId = currentMainTopicId
                
                SSTeacherDataSource.sharedDataSource.startedMainTopicName = mTopicName.text!
                
                
                
                cumulativeTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(SubTopicsView.udpateCumulativeTime), userInfo: nil, repeats: true)
            }
            else
            {
                self.makeToast("Please stop current topic to start new topic.", duration: 5.0, position: .bottom)
            }
            
            
        }
        else
        {
            cumulativeTimer.invalidate()
            
            if SSTeacherDataSource.sharedDataSource.startedSubTopicId != ""
            {
                
                if let subTopicCellView  = mTopicsContainerView.viewWithTag(Int(SSTeacherDataSource.sharedDataSource.startedSubTopicId)!) as? SubTopicCell
                {
                    subTopicCellView.startButton.setTitle("Resume", for: UIControlState())
                    subTopicCellView.startButton.setTitleColor(standard_Green, for: UIControlState())
                    
                }
            }
            
            
           
            

        }
        
        if delegate().responds(to: #selector(SubTopicsViewDelegate.delegateSubtopicStateChanedWithSubTopicDetails(_:withState:withmainTopicName:)))
        {
            delegate().delegateSubtopicStateChanedWithSubTopicDetails!(subTopicDetails, withState: isStarted, withmainTopicName: mTopicName.text!)
        }
        
    }
    
    
    func delegateShowAlert() {
         self.makeToast("Please stop current topic to start new topic.", duration: 3.0, position: .bottom)
    }
    
    func udpateCumulativeTime()
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm:ss"
        
        var _string :String = ""
        var currentDate = Date()
        
        if SSTeacherDataSource.sharedDataSource.startedSubTopicId != ""
        {
            if let subTopicCellView  = mTopicsContainerView.viewWithTag(Int(SSTeacherDataSource.sharedDataSource.startedSubTopicId)!) as? SubTopicCell
            {
                
                currentDate = currentDate.addSeconds(1, withDate: dateFormatter.date(from: currentCumulativeiTime)!)
                _string = dateFormatter.string(from: currentDate)
                
                
                currentCumulativeiTime = _string
                
                
                if let topicName = subTopicCellView.currentSubTopicDetails.object(forKey: "Name")as? String
                {
                    subTopicCellView.m_SubTopicLabel.text = "\(topicName)(\(_string))".capitalized
                    
                }
            }
        }
        else{
            cumulativeTimer.invalidate()
        }
        
        
    }
    
    
    
}
