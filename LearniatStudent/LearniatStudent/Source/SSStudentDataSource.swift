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



let     kUserStateLive          =  "1"
let     kUserStateBackGround    =  "11"
let     kUserStateFree          =  "7"
let     kuserStateSignedOut     =  "8"
let     kUserOccupied           =  "10"




let URLPrefix                       =   "http://54.251.104.13/Jupiter/sun.php?api="

let APP_VERSION                     =   "1.6"

let kServiceGetMyState                      = "GetMyState"

let kServiceUserLogin                       = "UserLogin"

let kServiceGetThisStudentSessions          = "GetThisStudentSessions"

let kServiceGetGridDesign                   = "GetGridDesign"

let kServiceUserLogOut                      = "UserLogout"

let kServiceGetSeatAssignment               = "GetSeatAssignment"

let kServiceUpdateUserStatus                = "UpdateUserStatus"

let kServiceGetSessionInfo                  = "SessionDetailsInfo"

let kServiceGetQuestion                     = "GetQuestion"

let kServiceSendAnswer                      = "SendAnswer"

let kGetEntityState                         = "GetState"

let kServiceGetGraspIndex                   = "GetGraspIndex"

let kServiceGetPiOfStudent                  = "GetParticipationIndex"

let kServiceGetFeedBack                     = "GetFeedback"

let kServiceWithDraw                        = "WithdrawStudentSubmission"

let kServiceSetDoubt						= "SetDoubt"

let kGetResponseToQuery                     = "GetResponseToQuery"

let kServiceFetchSRQ                        = "FetchSRQ"

let kServiceVolunteerRegister               = "VolunteerRegister"

let kServiceWithDrawQuery                   = "WithdrawQuery"

let kRecordSuggestion                       = "RecordSuggestion"

let kGetAllModelAnswer                      = "GetAllModelAnswers"




@objc protocol SSStudentDataSourceDelegate
{
    optional func didgetErrorMessage(message:String, WithServiceName serviceName:String)
    
    optional func didGetUserStateWithDetails(details:AnyObject)
    
    optional func didGetloginWithDetails(details:AnyObject)
    
    optional func didGetSchedulesWithDetials(details:AnyObject)
    
    optional func didGetGridDesignWithDetails(details:AnyObject)
    
    optional func didGetSeatAssignmentWithDetails(details:AnyObject)
    
    optional func didGetSessionInfoWithDetials(details:AnyObject)
    
    optional func didGetUpdatedUserStateWithDetails(details:AnyObject)
    
    optional func didGetQuestionWithDetails(details:AnyObject)
    
    optional func didGetAnswerSentWithDetails(details:AnyObject)
    
    optional func didGetQuerySentWithDetails(detail:AnyObject)
    
    optional func didGetResponseToQueryWithDetails(details:AnyObject)
    
    optional func didGetSRQWithDetails(details:AnyObject)
    
    optional func didGetvolunteerRegisteredWithDetails(details:AnyObject)
    
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
    
    var currentTeacherId    :String!
    
    var currentTeacherName  :String!
    
    var currentLiveSessionId        = ""
    
    var isSubtopicStarted           = false
    
    var subTopicDetailsDictonary            = NSMutableDictionary()
    
    var questionsDictonary                  = NSMutableDictionary()
    
    var QRVQueryDictonary                   = NSMutableDictionary()
    
    var answerSent :Bool                    = false
    
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
    
    func  updateStudentStatus(status:String, ofSession sessionId:String, withDelegate  delegate:SSStudentDataSourceDelegate)
    {

        currentUSerState = status
        
        let manager = APIManager()
        
        let urlString = String(format: "%@<Sunstone><Action><Service>UpdateUserState</Service><UserId>%@</UserId><StatusId>%@</StatusId><SessionId>%@</SessionId></Action></Sunstone>",URLPrefix,currentUserId,status,sessionId)
        
        manager.downloadDataURL(urlString, withServiceName: kServiceUpdateUserStatus, withDelegate: self, withRequestType: eHTTPGetRequest, withReturningDelegate: delegate)
        
    }
    
    
    
    func getScheduleOfTheDay(delegate:SSStudentDataSourceDelegate)
    {
        
        let manager = APIManager()
        
        let urlString = String(format: "%@<Sunstone><Action><Service>GetThisStudentSessions</Service><UserId>%@</UserId></Action></Sunstone>",URLPrefix,currentUserId)
        
        manager.downloadDataURL(urlString, withServiceName: kServiceGetThisStudentSessions, withDelegate: self, withRequestType: eHTTPGetRequest, withReturningDelegate: delegate)
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

    
    func sendObjectvieAnswer(optionsList:String,withQuestionType questionType:String, withQuestionLogId questionLogId:String, withsessionId currentSessionId:String, withDelegate delegate:SSStudentDataSourceDelegate)
    {
        
        
        let manager = APIManager()
        
        let urlString = String(format: "%@<Sunstone><Action><Service>SendAnswer</Service><StudentId>%@</StudentId><OptionText>%@</OptionText><SessionId>%@</SessionId><QuestionLogId>%@</QuestionLogId><QuestionType>%@</QuestionType></Action></Sunstone>",URLPrefix,currentUserId, optionsList,currentSessionId, questionLogId, questionType )
        
        manager.downloadDataURL(urlString, withServiceName: kServiceSendAnswer, withDelegate: self, withRequestType: eHTTPGetRequest,withReturningDelegate:delegate)
    }
    
    func sendScribbleAnswer(ImagePath:String,withQuestionType questionType:String, withQuestionLogId questionLogId:String, withsessionId currentSessionId:String, withDelegate delegate:SSStudentDataSourceDelegate)
    {
        
        
        let manager = APIManager()
        
        let urlString = String(format: "%@<Sunstone><Action><Service>SendAnswer</Service><StudentId>%@</StudentId><ImagePath>%@</ImagePath><SessionId>%@</SessionId><QuestionLogId>%@</QuestionLogId><QuestionType>%@</QuestionType></Action></Sunstone>",URLPrefix,currentUserId, ImagePath,currentSessionId, questionLogId, questionType )
        
        manager.downloadDataURL(urlString, withServiceName: kServiceSendAnswer, withDelegate: self, withRequestType: eHTTPGetRequest,withReturningDelegate:delegate)
    }
    
 
    
    
    
    func sendMTCAnswer(sequenceList:String,withQuestionType questionType:String, withQuestionLogId questionLogId:String, withsessionId currentSessionId:String, withDelegate delegate:SSStudentDataSourceDelegate)
    {
        
        
        
        let manager = APIManager()
        
        let urlString = String(format: "%@<Sunstone><Action><Service>SendAnswer</Service><StudentId>%@</StudentId><Sequence>%@</Sequence><SessionId>%@</SessionId><QuestionLogId>%@</QuestionLogId><QuestionType>%@</QuestionType></Action></Sunstone>",URLPrefix,currentUserId, sequenceList,currentSessionId, questionLogId, questionType )
        
        manager.downloadDataURL(urlString, withServiceName: kServiceSendAnswer, withDelegate: self, withRequestType: eHTTPGetRequest,withReturningDelegate:delegate)
    }
    
    
    func sendQueryWithQueryText(queryText:String,withAnonymous isAnonymous:String,withDelegate delegate:SSStudentDataSourceDelegate)
    {
        let manager = APIManager()
        
        
        
        let urlString = String(format: "%@<Sunstone><Action><Service>SaveStudentQuery</Service><StudentId>%@</StudentId><SessionId>%@</SessionId><QueryText>%@</QueryText><Anonymous>%@</Anonymous></Action></Sunstone>",URLPrefix,currentUserId,currentLiveSessionId,queryText,isAnonymous)
        
        manager.downloadDataURL(urlString, withServiceName: kServiceSetDoubt, withDelegate: self, withRequestType: eHTTPGetRequest, withReturningDelegate: delegate)
    }
    
    func getDoubtReplyForDoutId(doubtId:String, withDelegate delegate:SSStudentDataSourceDelegate)
    {
        
        
        let manager = APIManager()
        
        let urlString = String(format: "%@<Sunstone><Action><Service>GetQueryResponse</Service><QueryId>%@</QueryId></Action></Sunstone>",URLPrefix,doubtId)
        
        manager.downloadDataURL(urlString, withServiceName: kGetResponseToQuery, withDelegate: self, withRequestType: eHTTPGetRequest, withReturningDelegate: delegate)
    }
    
    func GetSRQWithSessionId(sessionId:String, withDelegate delegate:SSStudentDataSourceDelegate)
    {
        
        
        let manager = APIManager()
        
        let urlString = String(format: "%@<Sunstone><Action><Service>FetchSRQ</Service><SessionId>%@</SessionId></Action></Sunstone>",URLPrefix,sessionId)
        
        manager.downloadDataURL(urlString, withServiceName: kServiceFetchSRQ, withDelegate: self, withRequestType: eHTTPGetRequest, withReturningDelegate: delegate)
    }
    
    
    func volunteerRegisterwithQueryId(doubtId:String, withDelegate delegate:SSStudentDataSourceDelegate)
    {
        
        
        let manager = APIManager()
        
        let urlString = String(format: "%@<Sunstone><Action><Service>VolunteerRegister</Service><StudentId>%@</StudentId><QueryId>%@</QueryId></Action></Sunstone>",URLPrefix,self.currentUserId,doubtId)
        
        manager.downloadDataURL(urlString, withServiceName: kServiceVolunteerRegister, withDelegate: self, withRequestType: eHTTPGetRequest , withReturningDelegate: delegate)
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
        else if serviceName == kServiceGetThisStudentSessions
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
            
            if returningDelegate.respondsToSelector(#selector(SSStudentDataSourceDelegate.didGetSessionInfoWithDetials(_:)))
            {
                returningDelegate.didGetSessionInfoWithDetials!(refinedDetails)
            }
        }
        else if serviceName == kServiceUpdateUserStatus
        {
            if returningDelegate.respondsToSelector(#selector(SSStudentDataSourceDelegate.didGetUpdatedUserStateWithDetails(_:)))
            {
                returningDelegate.didGetUpdatedUserStateWithDetails!(refinedDetails)
            }
        }
        else if serviceName == kServiceGetQuestion
        {
            if returningDelegate.respondsToSelector(#selector(SSStudentDataSourceDelegate.didGetQuestionWithDetails(_:)))
            {
                returningDelegate.didGetQuestionWithDetails!(refinedDetails)
            }
        }
        else if serviceName == kServiceSendAnswer
        {
            if returningDelegate.respondsToSelector(#selector(SSStudentDataSourceDelegate.didGetAnswerSentWithDetails(_:)))
            {
                returningDelegate.didGetAnswerSentWithDetails!(refinedDetails)
            }
            
        }
        else if serviceName == kServiceSetDoubt
        {
            if returningDelegate.respondsToSelector(#selector(SSStudentDataSourceDelegate.didGetQuerySentWithDetails(_:)))
            {
                returningDelegate.didGetQuerySentWithDetails!(refinedDetails)
            }
            
        }
        else if serviceName == kGetResponseToQuery
        {
            
            if returningDelegate.respondsToSelector(#selector(SSStudentDataSourceDelegate.didGetResponseToQueryWithDetails(_:)))
            {
                returningDelegate.didGetResponseToQueryWithDetails!(refinedDetails)
            }
            
        }
        else if serviceName == kServiceFetchSRQ
        {
            
            if returningDelegate.respondsToSelector(#selector(SSStudentDataSourceDelegate.didGetSRQWithDetails(_:)))
            {
                returningDelegate.didGetSRQWithDetails!(refinedDetails)
            }
            
        }
        else if serviceName == kServiceVolunteerRegister
        {
            
            if returningDelegate.respondsToSelector(#selector(SSStudentDataSourceDelegate.didGetvolunteerRegisteredWithDetails(_:)))
            {
                returningDelegate.didGetvolunteerRegisteredWithDetails!(refinedDetails)
            }
            
        }
    }
    
    
    
    
    
    
    func delegateServiceErrorMessage(message: String!, withServiceName ServiceName: String!, withErrorCode code: String!, withRetruningDelegate returningDelegate: AnyObject!) {
        
        
        if returningDelegate.respondsToSelector(#selector(SSStudentDataSourceDelegate.didgetErrorMessage(_:WithServiceName:)))
        {
            returningDelegate.didgetErrorMessage!(message,WithServiceName: ServiceName)
        }
        
        print("Error in API \(ServiceName)")
        
    }
    
}