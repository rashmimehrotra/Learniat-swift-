//
//  MSetUpLessonPlanView.swift
//  LearniatTeacher
//
//  Created by mindshift_Deepak on 16/04/16.
//  Copyright © 2016 Mindshift. All rights reserved.
//

import Foundation
@objc protocol MSetUpLessonPlanViewDelegate {
    @objc optional func delegateDoneButtonPressed()
}

class MSetUpLessonPlanView: UIView,SSTeacherDataSourceDelegate, UISearchBarDelegate,UIPopoverControllerDelegate {
    
    let mViewModel = MSetUpLessonPlanViewModel()
    let mSendButton = UIButton()
    let mCancelButton = UIButton()
    var sendButtonSpinner : UIActivityIndicatorView!
    let  mTopbarImageView = UIImageView()
    var _currentSessionDetails:AnyObject!
    var MainTopicsView : MLessonPlanMainTopicsView!
    var fullLessonPlanDetails    : AnyObject!
    let lessonPlanSearchBar = UISearchBar()
    var _delgate: AnyObject!
    
    func setdelegate(_ delegate:AnyObject) {
        _delgate = delegate;
    }
    
    func   delegate()->AnyObject {
        return _delgate;
    }
    
    override init(frame: CGRect) {
        super.init(frame:frame)
        self.backgroundColor = whiteBackgroundColor
        
        mTopbarImageView.frame = CGRect(x: 0, y: 0, width: self.frame.size.width, height: 60)
        mTopbarImageView.backgroundColor = topbarColor
        self.addSubview(mTopbarImageView)
        mTopbarImageView.isUserInteractionEnabled = true
        
        mCancelButton.showsTouchWhenHighlighted = true;
        mCancelButton.frame = CGRect(x: 10 , y: 0, width: 100,  height: mTopbarImageView.frame.size.height);
        mTopbarImageView.addSubview(mCancelButton);
        mCancelButton.setTitle("Cancel", for:UIControlState());
        mCancelButton.setTitleColor(UIColor.white, for:UIControlState());
        mCancelButton.titleLabel?.font = UIFont(name: helveticaMedium, size: 20);
        mCancelButton.contentHorizontalAlignment = UIControlContentHorizontalAlignment.left
        mCancelButton.addTarget(self, action: #selector(MSetUpLessonPlanView.onCancelButton), for: UIControlEvents.touchUpInside)
        
        mSendButton.frame = CGRect(x: mTopbarImageView.frame.size.width - 100 , y: 0, width: 100 , height: mTopbarImageView.frame.size.height );
        mTopbarImageView.addSubview(mSendButton);
        mSendButton.setTitle("Done", for:UIControlState());
        mSendButton.setTitleColor(UIColor.white, for:UIControlState());
        mSendButton.titleLabel?.font = UIFont(name: helveticaMedium, size: 20);
        mSendButton.isHighlighted = false;
        mSendButton.contentHorizontalAlignment = UIControlContentHorizontalAlignment.center
        mSendButton.addTarget(self, action: #selector(MSetUpLessonPlanView.onSendButton), for: UIControlEvents.touchUpInside)
        mSendButton.isHidden = true
        
        sendButtonSpinner = UIActivityIndicatorView(activityIndicatorStyle:.whiteLarge);
        sendButtonSpinner.frame = mSendButton.frame;
        mTopbarImageView.addSubview(sendButtonSpinner);
        sendButtonSpinner.isHidden = false;
        sendButtonSpinner.startAnimating()
        
        MainTopicsView = MLessonPlanMainTopicsView(frame: CGRect(x: 0,y: mTopbarImageView.frame.size.height,width: self.frame.size.width,height: self.frame.size.height - mTopbarImageView.frame.size.height ))
        self.addSubview(MainTopicsView)
        MainTopicsView.LoadMainTopicsForClassId(classId: "")
        
        lessonPlanSearchBar.frame = CGRect(x: (mTopbarImageView.frame.size.width - 400)/2 , y: 10, width: 400, height: 40)
        lessonPlanSearchBar.placeholder = "Search"
        mTopbarImageView.addSubview(lessonPlanSearchBar)
        lessonPlanSearchBar.backgroundColor = UIColor.clear
        lessonPlanSearchBar.barTintColor = topbarColor
        lessonPlanSearchBar.delegate = self
        lessonPlanSearchBar.barStyle = UIBarStyle.default
        lessonPlanSearchBar.isTranslucent = true
        lessonPlanSearchBar.tintColor = UIColor.white
        
        let image = UIImage()
        lessonPlanSearchBar.backgroundImage = image
        lessonPlanSearchBar.setImage(UIImage(named: "LessonPLanDismissed.png"), for: .clear, state: UIControlState())
        lessonPlanSearchBar.autocapitalizationType = .none
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func onCancelButton() {
        self.removeFromSuperview()
    }
    
    func onSendButton() {
        if let ClassId = _currentSessionDetails.object(forKey: "ClassId") as? String {
//             SSTeacherDataSource.sharedDataSource.saveLessonPlan(ClassId, withTopicIdList: MainTopicsView.getAllSelectedtopicId(), withDelegate: self)
            sendButtonSpinner.isHidden = false
            sendButtonSpinner.startAnimating()
            mSendButton.isHidden = true
        }
    }
    
    func setCurrentSessionDetails(_ details:AnyObject) {
        _currentSessionDetails = details
//        if let ClassId = details.object(forKey: "ClassId") as? String  {
//            if let SubjectId = details.object(forKey: "SubjectId") as? String {
//                SSTeacherDataSource.sharedDataSource.getAllNodesWithClassId(ClassId, withSubjectId: SubjectId, withTopicId: "", withType: onlyMainTopics, withDelegate: self)
//            }
//        }
    }
    
    // MARK: - datasource delegate functions
    func didGetAllNodesWithDetails(_ details: AnyObject) {
        sendButtonSpinner.isHidden = true
        sendButtonSpinner.stopAnimating()
        mSendButton.isHidden = false
        fullLessonPlanDetails = details
        SSTeacherDataSource.sharedDataSource.taggedTopicIdArray.removeAllObjects()
//        MainTopicsView.setCurrentSessionDetails(_currentSessionDetails, withFullLessonPlanDetails: details)
    }
    
    func didGetLessonPlanSavedWithdetails(_ details: AnyObject) {
        sendButtonSpinner.isHidden = true
        sendButtonSpinner.stopAnimating()
        mSendButton.isHidden = false
        self.removeFromSuperview()
    }
    
    func didgetErrorMessage(_ message: String, WithServiceName serviceName: String) {
        sendButtonSpinner.isHidden = true
        sendButtonSpinner.stopAnimating()
        mSendButton.isHidden = false
    }
    
    // MARK: - search bar delegate functions
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar)  {
        searchBar.showsCancelButton = true
//        if MainTopicsView != nil {
//            MainTopicsView.searchingStarted()
//        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        searchBar.showsCancelButton = false
//        if MainTopicsView != nil {
//            MainTopicsView.searchingStopped()
//        }
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
//        if MainTopicsView != nil {
//            MainTopicsView.searchingTextWithSearchText(searchText.lowercased())
//        }
    }
}
