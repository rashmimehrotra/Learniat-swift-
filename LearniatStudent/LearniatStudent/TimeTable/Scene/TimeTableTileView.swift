//
//  TimeTableTileView.swift
//  LearniatStudent
//
//  Created by Deepak on 8/9/17.
//  Copyright © 2017 Mindshift. All rights reserved.
//

import Foundation

@objc protocol TimeTableTileViewDelegate {
   @objc optional func delegateScheduleTileTouchedWithSessionDetails(_ details: AnyObject?, message:String)
}

class TimeTableTileView: UIView {
   
    var mViewModel = TimeTableTileViewModel()
    
    var mSessionDetailsModel :TimeTableModel?
    
    var mClassName = UIVerticalAlignLabel()
    
    var circleImage                     = UIImageView()
    
    var _delgate: AnyObject!

    
    override init(frame: CGRect) {
        super.init(frame:frame)
        self.layer.borderWidth = 1
        self.addSubview(mClassName)
        mClassName.adjustsFontSizeToFitWidth = true
        mClassName.minimumScaleFactor = 0.2
        mClassName.lineBreakMode = NSLineBreakMode.byTruncatingTail;
        mClassName.numberOfLines = 4
        mClassName.verticalAlignment = .verticalAlignmentTop
        mClassName.textAlignment = .left
        self.addSubview(circleImage)
        mClassName.textColor = UIColor.white
        self.layer.masksToBounds = true
        self.layer.cornerRadius = 5
        let tapGesture = UITapGestureRecognizer(target: self, action:#selector(TimeTableTileView.tappedOnSession))
        tapGesture.numberOfTapsRequired = 1
        self.addGestureRecognizer(tapGesture)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    /// This func will be called when session is tapped
    func tappedOnSession() {
        let viewState = mViewModel.tappedOnSessionWithState(state: (mSessionDetailsModel?.SessionState)!)
        if viewState.isAbleToSendJson == true {
            _delgate.delegateScheduleTileTouchedWithSessionDetails!(mSessionDetailsModel?.getJsonFromModel(), message: "")
        } else {
            _delgate.delegateScheduleTileTouchedWithSessionDetails!(nil, message: viewState.message)
        }
    }
    
    /// This func is used to set the session details in model
    ///
    /// - Parameter model: TimeTable model
    func setTileWithModelDetails(model:TimeTableModel) {
        mSessionDetailsModel = model
        let classNameWithRoom = String(format:"%@(%@)",(mSessionDetailsModel?.ClassName)!,(mSessionDetailsModel?.RoomName)!)
        mClassName.text = classNameWithRoom
        self.updateSessionColorWithSessionState(SessionState(rawValue: (mSessionDetailsModel?.SessionState)!)!)
    }
}

// MARK: - Session updation functions 
extension TimeTableTileView {
    
    /// This func is used to update the session details according to the state in input rawValue
    ///
    /// - Parameter sessionState: Current state of the session
    fileprivate func updateSessionColorWithSessionState(_ sessionState:SessionState) {
        setClassNameWithFont(helveticaMedium)
        mViewModel.updateSesstionState(sessionState: sessionState)
        self.backgroundColor = mViewModel.backgroundColor
        self.layer.borderColor = mViewModel.borderColor.cgColor
        circleImage.backgroundColor = mViewModel.circleImageColor
    }
    
   /// This func is used to set class Name with given font, This will be helpfull to set class name frame
   ///
   /// - Parameter fontname: fontname for given class name
   fileprivate func setClassNameWithFont(_ fontname: String) {
        if self.frame.size.height/2 < 20 {
            mClassName.frame = CGRect(x: 40, y: 4, width: self.frame.size.width/3, height: (self.frame.size.height/1.2))
            mClassName.font = UIFont(name: fontname, size: (self.frame.size.height/2))
            circleImage.frame = CGRect(x: 15, y: 6, width: 15, height: 15)
        } else {
            mClassName.frame = CGRect(x: 40, y: 10, width: self.frame.size.width/3, height: (self.frame.size.height/1.2))
            mClassName.font = UIFont(name: fontname, size: 18)
            circleImage.frame = CGRect(x: 15, y: 15, width: 15, height: 15)
        }
        circleImage.layer.cornerRadius = circleImage.frame.size.width/2
        circleImage.layer.masksToBounds = true
    }

}
