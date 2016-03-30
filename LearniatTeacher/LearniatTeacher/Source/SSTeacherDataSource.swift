//
//  SSTeacherDataSource.swift
//  Learniat Teacher
//
//  Created by Deepak MK on 19/03/16.
//  Copyright © 2016 Mindshift. All rights reserved.
//

import Foundation
import UIKit


let	kSunstone                   = "SunStone"
let	kSSAction                   = "Action"
let kStatus                     = "Status"
let kSuccessString              = "Success"
let kSessions                   = "Sessions"
let kSubSession                 = "Session"
let kUserId                     = "UserId"
let kSchoolId                   = "SchoolId"
let kUserName                   = "UserName"
let kPassword                   = "Password"




let URLPrefix                       =   "http://54.251.104.13/Jupiter/sun.php?api="

let APP_VERSION                     =   "1.6"


let kServiceGetMyState              =   "GetMyState"

let kServiceUserLogin               =   "UserLogin"

let kServiceGetSchedules            =   "GetMyTodaysSessions"

let kServiceGetMyCurrentSession     =   "GetMyCurrentSession"

let kServiceUpdateSessionState      =   "UpdateSessionState"

let kServiceExtendTime              =   "ExtendSessionTime"

let kServiceGetScheduleSummary      =   "ScheduleSessionSummary"

let kServiceResetSeatAssignment		=   "ResetSeatAssignment"

let kServiceGetGridDesign           =   "GetGridDesign"

let kGetStudentsSessionInfo         =   "GetStudentsSessionInfo"

let kServiceGetSeatAssignment       =   "GetSeatAssignment"

let kServiceSeatAssignment          =   "StudentSeatAssignment"

let kServiceGetAllNodes				=   "GetAllNodes"

let kServiceStartTopic              =   "SetCurrentTopic"

let kServiceStopTopic               =   "StopTopic"

let kServiceBroadcastQuestion		=   "BroadcastQuestion"

let kServiceClearQuestion           =   "ClearQuestion"



@objc protocol SSTeacherDataSourceDelegate
{
    optional func didgetErrorMessage(message:String, WithServiceName serviceName:String)
    
    optional func didGetUserStateWithDetails(details:AnyObject)
    
    optional func didGetloginWithDetails(details:AnyObject)
    
    optional func didGetSchedulesWithDetials(details:AnyObject)
    
    optional func didGetMycurrentSessionWithDetials(details:AnyObject)
    
    optional func didGetSessionUpdatedWithDetials(details:AnyObject)
    
    optional func didGetSessionSummaryDetials(details:AnyObject)
    
    optional func didGetSessionExtendedDetials(details:AnyObject)
    
    optional func didGetSeatsRestWithDetials(details:AnyObject)
    
    optional func didGetGridDesignWithDetails(details:AnyObject)
    
    optional func didGetSeatAssignmentWithDetails(details:AnyObject)
    
    optional func didGetStudentsInfoWithDetails(details:AnyObject)
    
    optional func didGetSeatAssignmentSavedWithDetails(details:AnyObject)
    
    optional func didGetAllNodesWithDetails(details:AnyObject)
    
    optional func didGetSubtopicStartedWithDetails(details:AnyObject)
    
    optional func didGetQuestionSentWithDetails(details:AnyObject)
    
    optional func didGetQuestionClearedWithDetails(details:AnyObject)
    
    
}



class SSTeacherDataSource: NSObject, APIManagerDelegate
{
     internal  static let sharedDataSource = SSTeacherDataSource()
    
    
    
    var _delgate            :AnyObject!
    
    var currentUserId       :String!
    
    var currentSchoolId     :String!
    
    var currentUSerState    :String!
    
    var currentUserName     :String     = String()
    
    var currentPassword     :String     = String()
    
    var currentLiveSessionId        = ""
    
    
    // MARK: - Delegate Functions
    
    func setdelegate(delegate:AnyObject)
    {
        _delgate = delegate;
    }
    
    func   delegate()->AnyObject
    {
        return _delgate;
    }
    
    // MARK: - API Functions
    
    
    func getUserState(userId :String, withDelegate Delegate:SSTeacherDataSourceDelegate)
    {
        setdelegate(Delegate)
        let manager = APIManager()
        
        
        let urlString = String(format: "%@<Sunstone><Action><Service>GetMyState</Service><UserId>%@</UserId></Action></Sunstone>",URLPrefix,userId)
        
        manager.downloadDataURL(urlString, withServiceName:kServiceGetMyState, withDelegate: self, withRequestType: eHTTPGetRequest)
    }
    
    
    
    func LoginWithUserId(userId :String , andPassword Password:String, withDelegate Delegate:SSTeacherDataSourceDelegate)
    {
        setdelegate(Delegate)
        
        
        let manager = APIManager()
        let uuidString:String = UIDevice.currentDevice().identifierForVendor!.UUIDString
        
        let urlString = String(format: "%@<Sunstone><Action><Service>Login</Service><UserName>%@</UserName><UserPassword>%@</UserPassword><AppVersion>%@</AppVersion><DeviceId>%@</DeviceId><IsTeacher>1</IsTeacher></Action></Sunstone>",URLPrefix,userId, Password,APP_VERSION,uuidString)
        
        manager.downloadDataURL(urlString, withServiceName:kServiceUserLogin, withDelegate: self, withRequestType: eHTTPGetRequest)
    }

    
    
    func getScheduleOfTeacher(Delegate:SSTeacherDataSourceDelegate)
    {
        setdelegate(Delegate)
        
        let manager = APIManager()
        
        let urlString = String(format: "%@<Sunstone><Action><Service>GetMyTodaysSessions</Service><UserId>%@</UserId></Action></Sunstone>",URLPrefix,currentUserId)
        
        manager.downloadDataURL(urlString, withServiceName: kServiceGetSchedules, withDelegate: self, withRequestType: eHTTPGetRequest)
    }
    
    
    func getMyCurrentSessionOfTeacher(Delegate:SSTeacherDataSourceDelegate)
    {
        setdelegate(Delegate)
        
        let manager = APIManager()
        
        let urlString = String(format: "%@<Sunstone><Action><Service>GetMyCurrentSession</Service><UserId>%@</UserId></Action></Sunstone>",URLPrefix,currentUserId)
        
        manager.downloadDataURL(urlString, withServiceName: kServiceGetMyCurrentSession, withDelegate: self, withRequestType: eHTTPGetRequest)
    }
    
    
    func updateSessionStateWithSessionId(sessionId:String,WithStatusvalue Status:String, WithDelegate Delegate:SSTeacherDataSourceDelegate)
    {
        setdelegate(Delegate)
        
        let manager = APIManager()
        
        let urlString = String(format: "%@<Sunstone><Action><Service>UpdateSessionState</Service><SessionId>%@</SessionId><StatusId>%@</StatusId></Action></Sunstone>",URLPrefix,sessionId,Status)
        
        manager.downloadDataURL(urlString, withServiceName: kServiceUpdateSessionState, withDelegate: self, withRequestType: eHTTPGetRequest)
    }
    
    
    func getScheduleSummaryWithSessionId(sessionId:String, WithDelegate Delegate:SSTeacherDataSourceDelegate)
    {
        setdelegate(Delegate)
        
        let manager = APIManager()
        
        let urlString = String(format: "%@<Sunstone><Action><Service>ClassSessionSummary</Service><SessionId>%@</SessionId></Action></Sunstone>",URLPrefix,sessionId)
        
        manager.downloadDataURL(urlString, withServiceName: kServiceGetScheduleSummary, withDelegate: self, withRequestType: eHTTPGetRequest)
    }

    
    func extendSessionWithSessionId(sessionId:String, withTime Time:String, WithDelegate Delegate:SSTeacherDataSourceDelegate)
    {
        setdelegate(Delegate)
        
        let manager = APIManager()
        
        let urlString = String(format: "%@<Sunstone><Action><Service>ExtendSessionTime</Service><SessionId>%@</SessionId><MinutesExtended>%@</MinutesExtended></Action></Sunstone>",URLPrefix,sessionId,Time)
        
        manager.downloadDataURL(urlString, withServiceName: kServiceExtendTime, withDelegate: self, withRequestType: eHTTPGetRequest)
    }
    
    func resetPreallocatedSeatsOfSession(sessionId:String, WithDelegate Delegate:SSTeacherDataSourceDelegate)
    {
        setdelegate(Delegate)
        
        let manager = APIManager()
        
        let urlString = String(format: "%@<Sunstone><Action><Service>ResetSeatAssignment</Service><SessionId>%@</SessionId></Action></Sunstone>",URLPrefix,sessionId)
        
        manager.downloadDataURL(urlString, withServiceName: kServiceResetSeatAssignment, withDelegate: self, withRequestType: eHTTPGetRequest)
    }
    
    func getGridDesignDetails(roomId :String, WithDelegate delegate:SSTeacherDataSourceDelegate)
    {
        setdelegate(delegate)
        
        let manager = APIManager()
        
        let urlString = String(format: "%@<Sunstone><Action><Service>RetrieveGridDesign</Service><RoomId>%@</RoomId></Action></Sunstone>",URLPrefix,roomId)
        
        manager.downloadDataURL(urlString, withServiceName: kServiceGetGridDesign, withDelegate: self, withRequestType: eHTTPGetRequest)
        
    }
    
    
    
    
    func getSeatAssignmentofSession(sessionId:String,  withDelegate delegate:SSTeacherDataSourceDelegate)
    {
        setdelegate(delegate)
        
        let manager = APIManager()
        
        let urlString = String(format: "%@<Sunstone><Action><Service>RetrieveSeatAssignments</Service><SessionId>%@</SessionId></Action></Sunstone>",URLPrefix,sessionId)
        
        manager.downloadDataURL(urlString, withServiceName: kServiceGetSeatAssignment, withDelegate: self, withRequestType: eHTTPGetRequest)
    }
    
    func getStudentsInfoWithSessionId(sessionId:String,  withDelegate delegate:SSTeacherDataSourceDelegate)
    {
        setdelegate(delegate)
        
        let manager = APIManager()
        
        let urlString = String(format: "%@<Sunstone><Action><Service>GetStudentsSessionInfo</Service><SessionId>%@</SessionId></Action></Sunstone>",URLPrefix,sessionId)
        
        manager.downloadDataURL(urlString, withServiceName: kGetStudentsSessionInfo, withDelegate: self, withRequestType: eHTTPGetRequest)
    }
    
    func SaveSeatAssignmentWithStudentsList(studentsList:String, withSeatsIdList seatIdList:String, withSessionId sessionId:String, withDelegate delegate:SSTeacherDataSourceDelegate)
    {
        setdelegate(delegate)
        
        let manager = APIManager()
        
        let urlString = String(format: "%@<Sunstone><Action><Service>StudentSeatAssignment</Service><SessionId>%@</SessionId><StudentIdList>%@</StudentIdList><SeatIdList>%@</SeatIdList><StatusId>9</StatusId></Action></Sunstone>",URLPrefix,sessionId,studentsList,seatIdList)
        
        manager.downloadDataURL(urlString, withServiceName: kServiceSeatAssignment, withDelegate: self, withRequestType: eHTTPGetRequest)
    }
    
    
    func getAllNodesWithClassId(classId:String, withSubjectId subjectId:String, withTopicId topicId:String,withType type:String, withDelegate delegate:SSTeacherDataSourceDelegate)
    {
        setdelegate(delegate)
        
        let manager = APIManager()
        
        let urlString = String(format: "%@<Sunstone><Action><Service>GetAllNodes</Service><ClassId>%@</ClassId><SubjectId>%@</SubjectId><TopicId>%@</TopicId><Type>%@</Type></Action></Sunstone>",URLPrefix,classId,subjectId,topicId,type)
        
        manager.downloadDataURL(urlString, withServiceName: kServiceGetAllNodes, withDelegate: self, withRequestType: eHTTPGetRequest)
    }
    
    
   
    func startSubTopicWithTopicID(topicId:String,withStudentId studentId:String,withSessionID sessionid:String, withDelegate delegate:SSTeacherDataSourceDelegate)
    {
        setdelegate(delegate)
        
        let manager = APIManager()
        
        let urlString = String(format: "%@<Sunstone><Action><Service>SetCurrentTopic</Service><TopicId>%@</TopicId><SessionId>%@</SessionId><StudentId>%@</StudentId></Action></Sunstone>",URLPrefix,topicId,sessionid,studentId)
        
        manager.downloadDataURL(urlString, withServiceName: kServiceStartTopic, withDelegate: self, withRequestType: eHTTPGetRequest)
    }
    
    func stopSubTopicWithTopicID(topicId:String,withSessionID sessionid:String, withDelegate delegate:SSTeacherDataSourceDelegate)
    {
        setdelegate(delegate)
        
        let manager = APIManager()
        
        let urlString = String(format: "%@<Sunstone><Action><Service>StopTopic</Service><TopicId>%@</TopicId><SessionId>%@</SessionId></Action></Sunstone>",URLPrefix,topicId,sessionid)
        
        manager.downloadDataURL(urlString, withServiceName: kServiceStopTopic, withDelegate: self, withRequestType: eHTTPGetRequest)
    }
    
    
    
    
    func broadcastQuestionWithQuestionId(questionId:String,withSessionID sessionID:String, withDelegate delegate:SSTeacherDataSourceDelegate)
    {
        setdelegate(delegate)
        
        let manager = APIManager()
        
        let urlString = String(format: "%@<Sunstone><Action><Service>BroadcastQuestion</Service><QuestionId>%@</QuestionId><SessionId>%@</SessionId></Action></Sunstone>",URLPrefix,questionId,sessionID)
        
        manager.downloadDataURL(urlString, withServiceName: kServiceBroadcastQuestion, withDelegate: self, withRequestType: eHTTPGetRequest)
    }

    func clearQuestionWithQuestionogId(questionLogId:String, withDelegate delegate:SSTeacherDataSourceDelegate)
    {
        setdelegate(delegate)
        
        let manager = APIManager()
        
        let urlString = String(format: "%@<Sunstone><Action><Service>ClearQuestion</Service><QuestionId>%@</QuestionId></Action></Sunstone>",URLPrefix,questionLogId)
        
        manager.downloadDataURL(urlString, withServiceName: kServiceClearQuestion, withDelegate: self, withRequestType: eHTTPGetRequest)
    }
    
    
    // MARK: - API Delegate Functions
    func delegateDidGetServiceResponseWithDetails( dict: NSMutableDictionary!, WIthServiceName serviceName: String!)
    {
        
        let refinedDetails = dict.objectForKey(kSunstone)!.objectForKey(kSSAction)!
        if serviceName == kServiceGetMyState
        {
            if delegate().respondsToSelector(Selector("didGetUserStateWithDetails:"))
            {
                delegate().didGetUserStateWithDetails!(refinedDetails)
            }
            
        }
        else if serviceName == kServiceUserLogin
        {
            if delegate().respondsToSelector(Selector("didGetloginWithDetails:"))
            {
                delegate().didGetloginWithDetails!(refinedDetails)
            }
        }
        else if serviceName == kServiceGetSchedules
        {
            if delegate().respondsToSelector(Selector("didGetSchedulesWithDetials:"))
            {
                delegate().didGetSchedulesWithDetials!(refinedDetails)
            }
        }
        else if serviceName == kServiceGetMyCurrentSession
        {
            if delegate().respondsToSelector(Selector("didGetMycurrentSessionWithDetials:"))
            {
                delegate().didGetMycurrentSessionWithDetials!(refinedDetails)
            }
        }
        else if serviceName == kServiceGetScheduleSummary
        {
            if delegate().respondsToSelector(Selector("didGetSessionSummaryDetials:"))
            {
                delegate().didGetSessionSummaryDetials!(refinedDetails)
            }
        }
        else if serviceName == kServiceUpdateSessionState
        {
            if delegate().respondsToSelector(Selector("didGetSessionUpdatedWithDetials:"))
            {
                delegate().didGetSessionUpdatedWithDetials!(refinedDetails)
            }
        }
        else if serviceName == kServiceExtendTime
        {
            if delegate().respondsToSelector(Selector("didGetSessionExtendedDetials:"))
            {
                delegate().didGetSessionExtendedDetials!(refinedDetails)
            }
        }
        else if serviceName == kServiceResetSeatAssignment
        {
            if delegate().respondsToSelector(Selector("didGetSeatsRestWithDetials:"))
            {
                delegate().didGetSeatsRestWithDetials!(refinedDetails)
            }
        }
        
        else if serviceName == kServiceGetGridDesign
        {
            if delegate().respondsToSelector(Selector("didGetGridDesignWithDetails:"))
            {
                delegate().didGetGridDesignWithDetails!(refinedDetails)
            }
        }
            
        else if serviceName == kServiceGetSeatAssignment
        {
            if delegate().respondsToSelector(Selector("didGetSeatAssignmentWithDetails:"))
            {
                delegate().didGetSeatAssignmentWithDetails!(refinedDetails)
            }
        }
        else if serviceName == kGetStudentsSessionInfo
        {
            if delegate().respondsToSelector(Selector("didGetStudentsInfoWithDetails:"))
            {
                delegate().didGetStudentsInfoWithDetails!(refinedDetails)
            }
        }
        else if serviceName == kServiceSeatAssignment
        {
            if delegate().respondsToSelector(Selector("didGetSeatAssignmentSavedWithDetails:"))
            {
                delegate().didGetSeatAssignmentSavedWithDetails!(refinedDetails)
            }
        }
        else if serviceName == kServiceGetAllNodes
        {
            if delegate().respondsToSelector(Selector("didGetAllNodesWithDetails:"))
            {
                delegate().didGetAllNodesWithDetails!(refinedDetails)
            }
        }
        else if serviceName == kServiceStartTopic
        {
            if delegate().respondsToSelector(Selector("didGetSubtopicStartedWithDetails:"))
            {
                delegate().didGetSubtopicStartedWithDetails!(refinedDetails)
            }
        }
        else if serviceName == kServiceBroadcastQuestion
        {
            if delegate().respondsToSelector(Selector("didGetQuestionSentWithDetails:"))
            {
                delegate().didGetQuestionSentWithDetails!(refinedDetails)
            }
        }
        else if serviceName == kServiceClearQuestion
        {
            if delegate().respondsToSelector(Selector("didGetQuestionClearedWithDetails:"))
            {
                delegate().didGetQuestionClearedWithDetails!(refinedDetails)
            }
        }
    
    }
    
    
    
    
    
    
    func delegateServiceErrorMessage(message: String!, withServiceName ServiceName: String!, withErrorCode code: String!) {
    
        
        if delegate().respondsToSelector(Selector("didgetErrorMessage:WithServiceName:"))
        {
            delegate().didgetErrorMessage!(message,WithServiceName: ServiceName)
        }
        
        print("Error in API \(ServiceName)")
        
    }
    
}