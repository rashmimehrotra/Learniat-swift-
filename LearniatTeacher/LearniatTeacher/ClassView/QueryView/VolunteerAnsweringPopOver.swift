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
    
    
    optional func delegateStopVolunteeringPressedWithVolunteerDetails(volunteerDetails:AnyObject, withThummbsUp ThummbsUp:String, withThummbsDown ThummbsDown:String, withTotalVotes totalVotes:String)
    
    
    
    
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
        
        
        mStudentName.frame = CGRectMake( 10, 10,self.frame.size.width - 20 ,30)
        mStudentName.textAlignment = .Center;
        mStudentName.textColor = blackTextColor
        self.addSubview(mStudentName)
        mStudentName.backgroundColor = UIColor.clearColor()
        mStudentName.textAlignment = .Center;
        mStudentName.font = UIFont(name: helveticaMedium, size: 18)
        
        
        
        let _items:NSArray = [PNPieChartDataItem(value:100 , color: lightGrayColor,description: "")]
        
        mPieChart = PNPieChart(frame:CGRectMake(35, 40, 80,80), items:_items as [AnyObject]);
        mPieChart.descriptionTextColor =  whiteColor
        mPieChart.strokeChart();
        mPieChart.duration = 0.5;
        self.addSubview(mPieChart);
        mPieChart.descriptionTextFont  = UIFont(name: helveticaMedium, size: 0)
        
               
        mDislikeImageView.frame = CGRectMake(25 ,140, 25,25)
        mDislikeImageView.image = UIImage(named:"Thumbs_Down.png");
        self.addSubview(mDislikeImageView);
        
       
        
        mdislikeImageLabel.frame  = CGRectMake(25 ,175, 25,25);
        mdislikeImageLabel.textAlignment = .Center;
        mdislikeImageLabel.text = "0";
        mdislikeImageLabel.textColor = standard_Red
        self.addSubview(mdislikeImageLabel);
        
        
        
        let lineView1 = UIImageView(frame:CGRectMake(75, 140, 1, 55))
        lineView1.backgroundColor = topicsLineColor
        self.addSubview(lineView1);

        
        
        
        mLikeImageView.frame = CGRectMake(95 ,140, 25,25)
        mLikeImageView.image = UIImage(named:"Thumbs_Up.png");
        self.addSubview(mLikeImageView);
        
        
        
        
        mLikeImageLabel.frame  = CGRectMake(95,175,25, 25);
        mLikeImageLabel.textAlignment = .Center;
        mLikeImageLabel.text = "0";
        mLikeImageLabel.textColor = standard_Green
        self.addSubview(mLikeImageLabel);
        
        let mGiveAnswerButton = UIButton()
        
        mGiveAnswerButton.frame = CGRectMake(0,210,self.frame.size.width ,30)
        mGiveAnswerButton.setTitle("Stop", forState: .Normal)
        self.addSubview(mGiveAnswerButton)
        mGiveAnswerButton.setTitleColor(standard_Button, forState: .Normal)
        mGiveAnswerButton.contentHorizontalAlignment = UIControlContentHorizontalAlignment.Center
        mGiveAnswerButton.titleLabel?.font = UIFont(name: helveticaRegular, size: 16)
        mGiveAnswerButton.addTarget(self, action: #selector(VolunteerAnsweringPopOver.onStopButton), forControlEvents: .TouchUpInside)
        mGiveAnswerButton.backgroundColor = UIColor.clearColor()

        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var _delgate: AnyObject!
    
    func setdelegate(delegate:AnyObject)
    {
        _delgate = delegate;
    }
    
    func   delegate()->AnyObject
    {
        return _delgate;
    }
    
    var _Popover:AnyObject!
    
    func setPopover(popover:AnyObject)
    {
        _Popover = popover
    }
    
    func popover()-> AnyObject
    {
        return _Popover
    }
    func setProgressValueWithPercentagePositive( _positive:CGFloat, withNegetive _negetive:CGFloat, witTotalVlaue _totalVlaue:CGFloat)
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
        
        
        
        mPieChart.updateChartData(items as [AnyObject]);
        mPieChart.strokeChart();
        mPieChart.recompute();
        
        
        
    }
    
    
    func setVolunteerDetails(details:AnyObject)
    {
        
        currentVolunteerDetails = details
        if let StudentName = details.objectForKey("StudentName") as? String
        {
            mStudentName.text = StudentName
            
            if let QueryId = details.objectForKey("QueryId") as? String
            {
                
                if let StudentId = details.objectForKey("StudentId") as? String
                {
                     SSTeacherMessageHandler.sharedMessageHandler.sendQRVGiveAnswerMessageToRoom(SSTeacherDataSource.sharedDataSource.currentLiveSessionId, withstudentId: StudentId, withQueryId: QueryId, withStudentName: StudentName)
                }
            }
            
           
            
        }
        
    }
    
    func sendNewVoteWithStudentId(studentId:String, withVoteValue newVote:String, withTotalStudents totalStudents:Int)
    {
        
        
        liveTotalStudents = totalStudents
        
        if (votingStudentsDictonary.objectForKey(studentId) != nil)
        {
            
            
            valueForOneStudent = 100 / CGFloat(totalStudents)
            
            
            let oldvoteValue = votingStudentsDictonary.objectForKey(studentId) as! String
            
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
            
            
            votingStudentsDictonary.setObject(newVote, forKey: studentId)
        }
        else
        {
            votingStudentsDictonary.setObject(newVote, forKey: studentId)
            
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

