//
//  VolunteerAnsweringPopOver.swift
//  LearniatTeacher
//
//  Created by Deepak MK on 13/05/16.
//  Copyright © 2016 Mindshift. All rights reserved.
//

import Foundation
import UIKit

@objc protocol VolunteerAnsweringPopOverDelegate
{
    
    
    @objc optional func delegateStopVolunteeringPressedWithVolunteerDetails(_ volunteerDetails:AnyObject, withThummbsUp ThummbsUp:String, withThummbsDown ThummbsDown:String, withTotalVotes totalVotes:String)
    
    
    
    
}


class VolunteerAnsweringPopOver: UIView{
    
     var mStudentName         = UILabel()
    
    var  mPieChart             = PNPieChart();

    let mDislikeImageView = UIImageView()
    
    let mLikeImageView = UIImageView()
    
    let mdislikeImageLabel = UILabel()
    
     let mLikeImageLabel = UILabel()
    
    var currentVolunteerDetails    :AnyObject!
    
    var votingStudentsDictonary     = NSMutableDictionary()
    
    var LikeCount               = 0
    
    var disLikeCount            = 0
    
    var liveTotalStudents = 0
    
    var valueForOneStudent :CGFloat = 1
    
    override init(frame: CGRect)
    {
        super.init(frame: frame)
        
        self.backgroundColor = whiteColor
        
        
        mStudentName.frame = CGRect( x: 10, y: 10,width: self.frame.size.width - 20 ,height: 30)
        mStudentName.textAlignment = .center;
        mStudentName.textColor = blackTextColor
        self.addSubview(mStudentName)
        mStudentName.backgroundColor = UIColor.clear
        mStudentName.textAlignment = .center;
        mStudentName.font = UIFont(name: helveticaMedium, size: 18)
        
        
        
        let _items:NSArray = [PNPieChartDataItem(value:100 , color: lightGrayColor,description: "")]
        
        mPieChart = PNPieChart(frame:CGRect(x: 35, y: 40, width: 80,height: 80), items:_items as [AnyObject]);
        mPieChart.descriptionTextColor =  whiteColor
        mPieChart.stroke();
        mPieChart.duration = 0.5;
        self.addSubview(mPieChart);
        mPieChart.descriptionTextFont  = UIFont(name: helveticaMedium, size: 0)
        
               
        mDislikeImageView.frame = CGRect(x: 25 ,y: 140, width: 25,height: 25)
        mDislikeImageView.image = UIImage(named:"Thumbs_Down.png");
        self.addSubview(mDislikeImageView);
        
       
        
        mdislikeImageLabel.frame  = CGRect(x: 25 ,y: 175, width: 25,height: 25);
        mdislikeImageLabel.textAlignment = .center;
        mdislikeImageLabel.text = "0";
        mdislikeImageLabel.textColor = standard_Red
        self.addSubview(mdislikeImageLabel);
        
        
        
        let lineView1 = UIImageView(frame:CGRect(x: 75, y: 140, width: 1, height: 55))
        lineView1.backgroundColor = topicsLineColor
        self.addSubview(lineView1);

        
        
        
        mLikeImageView.frame = CGRect(x: 95 ,y: 140, width: 25,height: 25)
        mLikeImageView.image = UIImage(named:"Thumbs_Up.png");
        self.addSubview(mLikeImageView);
        
        
        
        
        mLikeImageLabel.frame  = CGRect(x: 95,y: 175,width: 25, height: 25);
        mLikeImageLabel.textAlignment = .center;
        mLikeImageLabel.text = "0";
        mLikeImageLabel.textColor = standard_Green
        self.addSubview(mLikeImageLabel);
        
        let mGiveAnswerButton = UIButton()
        
        mGiveAnswerButton.frame = CGRect(x: 0,y: 210,width: self.frame.size.width ,height: 30)
        mGiveAnswerButton.setTitle("Stop", for: UIControlState())
        self.addSubview(mGiveAnswerButton)
        mGiveAnswerButton.setTitleColor(standard_Button, for: UIControlState())
        mGiveAnswerButton.contentHorizontalAlignment = UIControlContentHorizontalAlignment.center
        mGiveAnswerButton.titleLabel?.font = UIFont(name: helveticaRegular, size: 16)
        mGiveAnswerButton.addTarget(self, action: #selector(VolunteerAnsweringPopOver.onStopButton), for: .touchUpInside)
        mGiveAnswerButton.backgroundColor = UIColor.clear

        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var _delgate: AnyObject!
    
    func setdelegate(_ delegate:AnyObject)
    {
        _delgate = delegate;
    }
    
    func   delegate()->AnyObject
    {
        return _delgate;
    }
    
    
    var _Popover:UIPopoverController!
    
    func setPopover(_ popover:UIPopoverController)
    {
        _Popover = popover
    }
    
    func popover()-> UIPopoverController
    {
        return _Popover
    }
    
    
    func setProgressValueWithPercentagePositive( _ _positive:CGFloat, withNegetive _negetive:CGFloat, witTotalVlaue _totalVlaue:CGFloat)
    {
        
        
        var positive = _positive
        
        var negetive = _negetive
        
        var totalVlaue = _totalVlaue
        
        if (positive < 0)
        {
            positive = 0;
        }
        
        if (negetive<0)
        {
            negetive = 0;
        }
        
        if (totalVlaue<0)
        {
            totalVlaue = 0;
        }
    
        
        var remainingValue = totalVlaue - ( negetive + positive )
        
        if remainingValue <= 0
        {
            remainingValue = 0
        }
        
        
        let items :NSArray = [PNPieChartDataItem(value: positive , color: standard_Green,description: ""),
                              PNPieChartDataItem(value: negetive , color: standard_Red,description: ""),
                              PNPieChartDataItem(value: (remainingValue) , color: lightGrayColor,description: "")]
        
        
        
        mPieChart.updateData(items as [AnyObject]);
        mPieChart.stroke();
        mPieChart.recompute();
        
        
        
    }
    
    
    func setVolunteerDetails(_ details:AnyObject)
    {
        
        currentVolunteerDetails = details
        if let StudentName = details.object(forKey: "StudentName") as? String
        {
            mStudentName.text = StudentName
            
            if let QueryId = details.object(forKey: "QueryId") as? String
            {
                
                if let StudentId = details.object(forKey: "StudentId") as? String
                {
                     SSTeacherMessageHandler.sharedMessageHandler.sendQRVGiveAnswerMessageToRoom(SSTeacherDataSource.sharedDataSource.currentLiveSessionId, withstudentId: StudentId as NSString, withQueryId: QueryId, withStudentName: StudentName)
                }
            }
        }
        
    }
    
    
    
    func sendNewVoteWithStudentId(_ studentId:String, withVoteValue newVote:String, withTotalStudents totalStudents:Int)
    {
        
        
        liveTotalStudents = totalStudents - 1
        
        if (votingStudentsDictonary.object(forKey: studentId) != nil)
        {
            valueForOneStudent = 100 / CGFloat(totalStudents)
            
            let oldvoteValue = votingStudentsDictonary.object(forKey: studentId) as! String
            
            if oldvoteValue == "1"
            {
                if newVote == "-1"
                {
                    if LikeCount > 0
                    {
                        LikeCount = LikeCount - 1
                    }
                    
                    disLikeCount = disLikeCount + 1
                }
            }
            else
            {
                if newVote == "1"
                {
                    if disLikeCount > 0
                    {
                        disLikeCount = disLikeCount - 1
                    }
                    
                    LikeCount = LikeCount + 1
                }
            }
            
            
            votingStudentsDictonary.setObject(newVote, forKey: studentId as NSCopying)
        }
        else
        {
            votingStudentsDictonary.setObject(newVote, forKey: studentId as NSCopying)
            
            if newVote == "-1"
            {
                disLikeCount = disLikeCount + 1
            }
            else if newVote == "1"
            {
                LikeCount = LikeCount + 1
            }
        }
        
        
        
        mdislikeImageLabel.text = "\(disLikeCount)";
        mLikeImageLabel.text = "\(LikeCount)";
        
        setProgressValueWithPercentagePositive(CGFloat(LikeCount) * valueForOneStudent, withNegetive: CGFloat(disLikeCount) * valueForOneStudent, witTotalVlaue: CGFloat(totalStudents) * valueForOneStudent)
        
        
        
        
    }
    
    func onStopButton()
    {
        
         SSTeacherDataSource.sharedDataSource.isVolunteerAnswering = false
        
        delegate().delegateStopVolunteeringPressedWithVolunteerDetails!(currentVolunteerDetails, withThummbsUp: mLikeImageLabel.text!, withThummbsDown: mdislikeImageLabel.text!, withTotalVotes:"\(liveTotalStudents)")
        self.removeFromSuperview()
    }
    
    
    
}

