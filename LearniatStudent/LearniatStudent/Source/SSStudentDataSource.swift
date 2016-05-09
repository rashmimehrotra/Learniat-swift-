//
//  SSStudentDataSource.swift
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

let kServiceGetSchedules            =   "GetThisStudentSessions"

let kServiceGetGridDesign           =   "GetGridDesign"

let kServiceGetSeatAssignment       =   "GetSeatAssignment"

let kServiceSeatAssignment          =   "StudentSeatAssignment"

let  kServiceGetSessionInfo         =   "SessionDetailsInfo"

let kServiceGetQuestion             =   "GetQuestion"


@objc protocol SSStudentDataSourceDelegate
{
    optional func didgetErrorMessage(message:String, WithServiceName serviceName:String)
    
    optional func didGetUserStateWithDetails(details:AnyObject)
    
    optional func didGetloginWithDetails(details:AnyObject)
    
    optional func didGetSchedulesWithDetials(details:AnyObject)
    
    optional func didGetGridDesignWithDetails(details:AnyObject)
    
    optional func didGetSeatAssignmentWithDetails(details:AnyObject)
    
//    optional func didGetMycurrentSessionWithDetials(details:AnyObject)
//    
//    optional func didGetSessionUpdatedWithDetials(details:AnyObject)
//    
//    optional func didGetSessionSummaryDetials(details:AnyObject)
//    
//    optional func didGetSessionExtendedDetials(details:AnyObject)
//    
//    optional func didGetSeatsRestWithDetials(details:AnyObject)
//    
//    optional func didGetMaxStudentsRegistedWithDetails(details:AnyObject)
//    

//    
//    optional func didGetSeatsConfiguredWithDetails(details:AnyObject)
//    
 
//    
//    optional func didGetStudentsInfoWithDetails(details:AnyObject)
//    
//    optional func didGetSeatAssignmentSavedWithDetails(details:AnyObject)
//    
//    optional func didGetAllNodesWithDetails(details:AnyObject)
//    
//    optional func didGetSubtopicStartedWithDetails(details:AnyObject)
//    
//    optional func didGetQuestionSentWithDetails(details:AnyObject)
//    
//    optional func didGetQuestionClearedWithDetails(details:AnyObject)
//    
//    optional func didGetStudentsAnswerWithDetails(details:AnyObject)
//    
//    optional func didGetAgregateDrillDownWithDetails(details:AnyObject)
//    
//    optional func didGetFeedbackSentWithDetails(details:AnyObject)
//    
//    optional func didGetQueryWithDetails(details:AnyObject)
//    
//    optional func didGetQueryRespondedWithDetails(details:AnyObject)
//    
//    optional func didGetSaveSelectedQueryWithDetails(details:AnyObject)
//    
//    optional func didGetVolunteeringEndedWithDetails(details:AnyObject)
//    
//    optional func didGetLessonPlanSavedWithdetails(details:AnyObject)
//    
//    optional func didGetScribbleUploadedWithDetaisl(details:AnyObject)
//    
//    optional func didGetQuestionRecordedWithDetaisl(details:AnyObject)
//    
//    optional func didGetQuestionWithDetails(details:AnyObject)
}



class SSStudentDataSource: NSObject, APIManagerDelegate
{
     internal  static let sharedDataSource = SSStudentDataSource()
    
    
    
    var _delgate            :AnyObject!
    
    var currentUserId       :String!
    
    var currentSchoolId     :String!
    
    var currentUSerState    :String!
    
    var currentUserName     :String     = String()
    
    var currentPassword     :String     = String()
    
    var currentLiveSessionId        = ""
    
    var isSubtopicStarted           = false
    
    var subTopicDetailsDictonary            = NSMutableDictionary()
    
    var questionsDictonary                  = NSMutableDictionary()
    
    
    // MARK: - Delegate Functions
    
    func setdelegate(delegate:AnyObject)
    {
        _delgate = delegate;
    }
    
    func   delegate()->AnyObject
    {
        return _delgate;
    }
    
    
    
    
    func setSubTopicDictonaryWithDict(details:NSMutableArray,withKey key:String)
    {
        subTopicDetailsDictonary.setObject(details, forKey: key)
    }
    
    func setQuestionDictonaryWithDict(details:NSMutableArray,withKey key:String)
    {
        questionsDictonary.setObject(details, forKey: key)
    }
    
    
    
    // MARK: - API Functions
    
    
    func getUserState(userId :String, withDelegate delegate:SSStudentDataSourceDelegate)
    {
        let manager = APIManager()
        
        
        let urlString = String(format: "%@<Sunstone><Action><Service>GetMyState</Service><UserId>%@</UserId></Action></Sunstone>",URLPrefix,userId)
        
        manager.downloadDataURL(urlString, withServiceName:kServiceGetMyState, withDelegate: self, withRequestType: eHTTPGetRequest , withReturningDelegate:delegate )
    }
    
    
    
    func LoginWithUserId(userId :String , andPassword Password:String, withDelegate delegate:SSStudentDataSourceDelegate)
    {
        
        
        let manager = APIManager()
        let uuidString:String = UIDevice.currentDevice().identifierForVendor!.UUIDString
        
        let urlString = String(format: "%@<Sunstone><Action><Service>Login</Service><UserName>%@</UserName><UserPassword>%@</UserPassword><AppVersion>%@</AppVersion><DeviceId>%@</DeviceId><IsTeacher>0</IsTeacher></Action></Sunstone>",URLPrefix,userId, Password,APP_VERSION,uuidString)
        
        manager.downloadDataURL(urlString, withServiceName:kServiceUserLogin, withDelegate: self, withRequestType: eHTTPGetRequest, withReturningDelegate: delegate)
    }

    
    
    func getScheduleOfTheDay(delegate:SSStudentDataSourceDelegate)
    {
        
        let manager = APIManager()
        
        let urlString = String(format: "%@<Sunstone><Action><Service>GetThisStudentSessions</Service><UserId>%@</UserId></Action></Sunstone>",URLPrefix,currentUserId)
        
        manager.downloadDataURL(urlString, withServiceName: kServiceGetSchedules, withDelegate: self, withRequestType: eHTTPGetRequest, withReturningDelegate: delegate)
    }
    
    
   
    func getGridDesignDetails(roomId :String, WithDelegate delegate:SSStudentDataSourceDelegate)
    {
        
        let manager = APIManager()
        
        let urlString = String(format: "%@<Sunstone><Action><Service>RetrieveGridDesign</Service><RoomId>%@</RoomId></Action></Sunstone>",URLPrefix,roomId)
        
        manager.downloadDataURL(urlString, withServiceName: kServiceGetGridDesign, withDelegate: self, withRequestType: eHTTPGetRequest,withReturningDelegate: delegate)
        
    }
    
    
    func getSeatAssignmentofSession(sessionId:String,  withDelegate delegate:SSStudentDataSourceDelegate)
    {
        
        let manager = APIManager()
        
        let urlString = String(format: "%@<Sunstone><Action><Service>RetrieveSeatAssignments</Service><SessionId>%@</SessionId></Action></Sunstone>",URLPrefix,sessionId)
        
        manager.downloadDataURL(urlString, withServiceName: kServiceGetSeatAssignment, withDelegate: self, withRequestType: eHTTPGetRequest,withReturningDelegate: delegate)
    }
    
    
    
    
    
    func getUserSessionWithDetails(sessionId:String,  withDelegate delegate:SSStudentDataSourceDelegate)
    {
        
        let manager = APIManager()
        
        let urlString = String(format: "%@<Sunstone><Action><Service>GetSessionInfo</Service><SessionId>%@</SessionId></Action></Sunstone>",URLPrefix,sessionId)
        
        manager.downloadDataURL(urlString, withServiceName: kServiceGetSessionInfo, withDelegate: self, withRequestType: eHTTPGetRequest,withReturningDelegate: delegate)
    }
    

    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    func fetchQuestionWithQuestionLogId(questionLogId:String, WithDelegate delegate:SSStudentDataSourceDelegate)
    {
        let manager = APIManager()
        
        let urlString = String(format: "%@<Sunstone><Action><Service>FetchQuestion</Service><QuestionLogId>%@</QuestionLogId></Action></Sunstone>",URLPrefix,questionLogId)
        
        manager.downloadDataURL(urlString, withServiceName: kServiceGetQuestion, withDelegate: self, withRequestType: eHTTPGetRequest, withReturningDelegate: delegate)
    }

 
    
    
    // MARK: - API Delegate Functions
    func delegateDidGetServiceResponseWithDetails(dict: NSMutableDictionary!, WIthServiceName serviceName: String!, withRetruningDelegate returningDelegate: AnyObject!) {
        
        let refinedDetails = dict.objectForKey(kSunstone)!.objectForKey(kSSAction)!
        if serviceName == kServiceGetMyState
        {
            if returningDelegate.respondsToSelector(#selector(SSStudentDataSourceDelegate.didGetUserStateWithDetails(_:)))
            {
                returningDelegate.didGetUserStateWithDetails!(refinedDetails)
            }
            
        }
        else if serviceName == kServiceUserLogin
        {
            if returningDelegate.respondsToSelector(#selector(SSStudentDataSourceDelegate.didGetloginWithDetails(_:)))
            {
                returningDelegate.didGetloginWithDetails!(refinedDetails)
            }
        }
        else if serviceName == kServiceGetSchedules
        {
            if returningDelegate.respondsToSelector(#selector(SSStudentDataSourceDelegate.didGetSchedulesWithDetials(_:)))
            {
                returningDelegate.didGetSchedulesWithDetials!(refinedDetails)
            }
        }
        else if serviceName == kServiceGetGridDesign
        {
            if returningDelegate.respondsToSelector(#selector(SSStudentDataSourceDelegate.didGetGridDesignWithDetails(_:)))
            {
                returningDelegate.didGetGridDesignWithDetails!(refinedDetails)
            }
        }
        else if serviceName == kServiceGetSeatAssignment
        {
            if returningDelegate.respondsToSelector(#selector(SSStudentDataSourceDelegate.didGetSeatAssignmentWithDetails(_:)))
            {
                returningDelegate.didGetSeatAssignmentWithDetails!(refinedDetails)
            }
        }
        else if serviceName == kServiceGetSessionInfo
        {
            if returningDelegate.respondsToSelector(#selector(SSStudentDataSourceDelegate.didGetSeatAssignmentWithDetails(_:)))
            {
                returningDelegate.didGetSeatAssignmentWithDetails!(refinedDetails)
            }
        }
        
    }
    
    
    
    
    
    
    func delegateServiceErrorMessage(message: String!, withServiceName ServiceName: String!, withErrorCode code: String!, withRetruningDelegate returningDelegate: AnyObject!) {
        
        
        if delegate().respondsToSelector(#selector(SSStudentDataSourceDelegate.didgetErrorMessage(_:WithServiceName:)))
        {
            delegate().didgetErrorMessage!(message,WithServiceName: ServiceName)
        }
        
        print("Error in API \(ServiceName)")
        
    }
    
}