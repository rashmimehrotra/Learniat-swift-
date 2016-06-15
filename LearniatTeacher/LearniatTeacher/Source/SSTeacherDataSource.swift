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

let kServiceSaveLessonPlan			=    "SaveLessonPlan"

let kServiceStartTopic              =   "SetCurrentTopic"

let kServiceStopTopic               =   "StopTopic"

let kServiceBroadcastQuestion		=   "BroadcastQuestion"

let kServiceClearQuestion           =   "ClearQuestion"

let kServiceRetrieveStudentAnswer   =   "RetrieveStudentAnswer"

let kServiceAgregateDrillDown       =   "RetrieveAggregateDrillDown"

let kServiceSendFeedback            =   "SendFeedback"

let kServiceGetDoubt                =   "GetDoubts"

let kServiceReplyToQuery            =   "ReplyToQuery"

let kServiceSaveSelectedQueries     =   "SaveSelectedQueries"

let kServiceEndVolunteeringSession  =   "EndVolunteeringSession"

let kServiceGetMaxStudentRegisterd  =   "GetMaxStudentRegisterd"

let kServiceConfigureGrid           =   "ConfigureGrid"

let kuploadTeacherScribble          =   "UploadTeacherScribble"

let kRecordQuestion                 =   "RecordQuestion"

let kServiceGetQuestion             =   "GetQuestion"

let  kGetAllModelAnswer             =   "GetAllModelAnswers"

let kRecordModelAnswer              =   "RecordModelAnswer"

let kServiceApproveVolunteer        =   "ApproveVolunteer"

let kServiceStopVolunteering        =   "StopVolunteering"

let kServiceUserLogout              =   "UserLogout"

let kServiceFetchSRQ                =   "FetchSRQ"


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
    
    optional func didGetMaxStudentsRegistedWithDetails(details:AnyObject)
    
    optional func didGetGridDesignWithDetails(details:AnyObject)
    
    optional func didGetSeatsConfiguredWithDetails(details:AnyObject)
    
    optional func didGetSeatAssignmentWithDetails(details:AnyObject)
    
    optional func didGetStudentsInfoWithDetails(details:AnyObject)
    
    optional func didGetSeatAssignmentSavedWithDetails(details:AnyObject)
    
    optional func didGetAllNodesWithDetails(details:AnyObject)
    
    optional func didGetSubtopicStartedWithDetails(details:AnyObject)
    
    optional func didGetQuestionSentWithDetails(details:AnyObject)
    
    optional func didGetQuestionClearedWithDetails(details:AnyObject)
    
    optional func didGetStudentsAnswerWithDetails(details:AnyObject)
    
    optional func didGetAgregateDrillDownWithDetails(details:AnyObject)
    
    optional func didGetFeedbackSentWithDetails(details:AnyObject)
    
    optional func didGetQueryWithDetails(details:AnyObject)
    
    optional func didGetQueryRespondedWithDetails(details:AnyObject)
    
    optional func didGetSaveSelectedQueryWithDetails(details:AnyObject)
    
    optional func didGetVolunteeringEndedWithDetails(details:AnyObject)
    
    optional func didGetLessonPlanSavedWithdetails(details:AnyObject)
    
    optional func didGetScribbleUploadedWithDetaisl(details:AnyObject)
    
    optional func didGetQuestionRecordedWithDetaisl(details:AnyObject)
    
    optional func didGetQuestionWithDetails(details:AnyObject)
    
    optional func didGetModelAnswerWithDetails(details:AnyObject)
    
    optional func didGetModelAnswerRecordedWithDetails(details:AnyObject)
    
    optional func didGetLogOutWithDetails(details:AnyObject)
    
    optional func didGetSRQWithDetails(details:AnyObject)
}



class SSTeacherDataSource: NSObject, APIManagerDelegate
{
     internal  static let sharedDataSource = SSTeacherDataSource()
    
    
    
    var _delgate            :AnyObject!
    
    
    // MARK: - delegate Functions
    
    func setdelegate(delegate:AnyObject)
    {
        _delgate = delegate;
    }
    
    func   delegate()->AnyObject
    {
        return _delgate;
    }
    
    var currentUserId       :String!
    
    var currentSchoolId     :String!
    
    var currentUSerState    :String!
    
    var currentUserName     :String     = String()
    
    var currentPassword     :String     = String()
    
    var currentLiveSessionId        = ""
    
    var isSubtopicStarted           = false
    
    var isQuestionSent              = false
    
    var subTopicDetailsDictonary            = NSMutableDictionary()
    
    var questionsDictonary                  = NSMutableDictionary()
    
    var currentQuestionLogId                = ""
    
    var startedSubTopicId                   = ""
    
    var startedMainTopicId                  = ""
    
    var startedSubTopicName                 = ""
    
    var startedMainTopicName                = ""
    
    var taggedTopicIdArray                  = NSMutableArray()
    
    var isVolunteerAnswering                = false
    
    var isSimulationEnabled   :Bool         = false
    
    
    var mDemoQuerySubTopicsArray                = NSMutableArray()
    
    var mDemoCollaborationSubTopicArray         = NSMutableArray()
    
    var mDemoQuestionsIdArray                   = NSMutableArray()
    
    
    var mOverlayImageName                       = ""
    
    func setSubTopicDictonaryWithDict(details:NSMutableArray,withKey key:String)
    {
        subTopicDetailsDictonary.setObject(details, forKey: key)
    }
    
    func setQuestionDictonaryWithDict(details:NSMutableArray,withKey key:String)
    {
        questionsDictonary.setObject(details, forKey: key)
    }
    
    
    
    // MARK: - API Functions
    
    
    func getUserState(userId :String, withDelegate delegate:SSTeacherDataSourceDelegate)
    {
        
        let manager = APIManager()
        
        
        let urlString = String(format: "%@<Sunstone><Action><Service>GetMyState</Service><UserId>%@</UserId></Action></Sunstone>",URLPrefix,userId)
        
        manager.downloadDataURL(urlString, withServiceName:kServiceGetMyState, withDelegate: self, withRequestType: eHTTPGetRequest, withReturningDelegate: delegate)
    }
    
    
    
    func LoginWithUserId(userId :String , andPassword Password:String, withDelegate delegate:SSTeacherDataSourceDelegate)
    {

        
        
        let manager = APIManager()
        let uuidString:String = UIDevice.currentDevice().identifierForVendor!.UUIDString
        
        let urlString = String(format: "%@<Sunstone><Action><Service>Login</Service><UserName>%@</UserName><UserPassword>%@</UserPassword><AppVersion>%@</AppVersion><DeviceId>%@</DeviceId><IsTeacher>1</IsTeacher></Action></Sunstone>",URLPrefix,userId, Password,APP_VERSION,uuidString)
        
        manager.downloadDataURL(urlString, withServiceName:kServiceUserLogin, withDelegate: self, withRequestType: eHTTPGetRequest, withReturningDelegate: delegate)
    }

    
    
    func getScheduleOfTeacher(delegate:SSTeacherDataSourceDelegate)
    {

        
        let manager = APIManager()
        
        let urlString = String(format: "%@<Sunstone><Action><Service>GetMyTodaysSessions</Service><UserId>%@</UserId></Action></Sunstone>",URLPrefix,currentUserId)
        
        manager.downloadDataURL(urlString, withServiceName: kServiceGetSchedules, withDelegate: self, withRequestType: eHTTPGetRequest, withReturningDelegate: delegate)
    }
    
    
    func getMyCurrentSessionOfTeacher(delegate:SSTeacherDataSourceDelegate)
    {

        
        let manager = APIManager()
        
        let urlString = String(format: "%@<Sunstone><Action><Service>GetMyCurrentSession</Service><UserId>%@</UserId></Action></Sunstone>",URLPrefix,currentUserId)
        
        manager.downloadDataURL(urlString, withServiceName: kServiceGetMyCurrentSession, withDelegate: self, withRequestType: eHTTPGetRequest, withReturningDelegate: delegate)
    }
    
    
    func updateSessionStateWithSessionId(sessionId:String,WithStatusvalue Status:String, WithDelegate delegate:SSTeacherDataSourceDelegate)
    {

        
        let manager = APIManager()
        
        let urlString = String(format: "%@<Sunstone><Action><Service>UpdateSessionState</Service><SessionId>%@</SessionId><StatusId>%@</StatusId></Action></Sunstone>",URLPrefix,sessionId,Status)
        
        manager.downloadDataURL(urlString, withServiceName: kServiceUpdateSessionState, withDelegate: self, withRequestType: eHTTPGetRequest, withReturningDelegate: delegate)
    }
    
    
    func getScheduleSummaryWithSessionId(sessionId:String, WithDelegate delegate:SSTeacherDataSourceDelegate)
    {

        
        let manager = APIManager()
        
        let urlString = String(format: "%@<Sunstone><Action><Service>ClassSessionSummary</Service><SessionId>%@</SessionId></Action></Sunstone>",URLPrefix,sessionId)
        
        manager.downloadDataURL(urlString, withServiceName: kServiceGetScheduleSummary, withDelegate: self, withRequestType: eHTTPGetRequest, withReturningDelegate: delegate)
    }

    
    func extendSessionWithSessionId(sessionId:String, withTime Time:String, WithDelegate delegate:SSTeacherDataSourceDelegate)
    {

        
        let manager = APIManager()
        
        let urlString = String(format: "%@<Sunstone><Action><Service>ExtendSessionTime</Service><SessionId>%@</SessionId><MinutesExtended>%@</MinutesExtended></Action></Sunstone>",URLPrefix,sessionId,Time)
        
        manager.downloadDataURL(urlString, withServiceName: kServiceExtendTime, withDelegate: self, withRequestType: eHTTPGetRequest, withReturningDelegate: delegate)
    }
    
    func resetPreallocatedSeatsOfSession(sessionId:String, WithDelegate delegate:SSTeacherDataSourceDelegate)
    {

        
        let manager = APIManager()
        
        let urlString = String(format: "%@<Sunstone><Action><Service>ResetSeatAssignment</Service><SessionId>%@</SessionId></Action></Sunstone>",URLPrefix,sessionId)
        
        manager.downloadDataURL(urlString, withServiceName: kServiceResetSeatAssignment, withDelegate: self, withRequestType: eHTTPGetRequest, withReturningDelegate: delegate)
    }
    
    func getGridDesignDetails(roomId :String, WithDelegate delegate:SSTeacherDataSourceDelegate)
    {

        
        let manager = APIManager()
        
        let urlString = String(format: "%@<Sunstone><Action><Service>RetrieveGridDesign</Service><RoomId>%@</RoomId></Action></Sunstone>",URLPrefix,roomId)
        
        manager.downloadDataURL(urlString, withServiceName: kServiceGetGridDesign, withDelegate: self, withRequestType: eHTTPGetRequest, withReturningDelegate: delegate)
        
    }
    
    func getMaxStudentRegisterdwiRoomId(roomId :String, WithDelegate delegate:SSTeacherDataSourceDelegate)
    {

        
        let manager = APIManager()
        
        let urlString = String(format: "%@<Sunstone><Action><Service>GetMaxStudentsRegistered</Service><RoomId>%@</RoomId></Action></Sunstone>",URLPrefix,roomId)
        
        manager.downloadDataURL(urlString, withServiceName: kServiceGetMaxStudentRegisterd, withDelegate: self, withRequestType: eHTTPGetRequest, withReturningDelegate: delegate)
        
    }
    
    func ConfigureSeatsWithRoomId(roomId :String, withRows rowValue:String, withColumnValue columnValue:String,withRemovedSeats removedSeats:String, WithDelegate delegate:SSTeacherDataSourceDelegate)
    {

        
        let manager = APIManager()
        
        let urlString = String(format: "%@<Sunstone><Action><Service>ConfigureGrid</Service><RoomId>%@</RoomId><Rows>%@</Rows><Columns>%@</Columns><SeatsRemoved>%@</SeatsRemoved></Action></Sunstone>",URLPrefix,roomId,rowValue,columnValue,removedSeats)
        
        manager.downloadDataURL(urlString, withServiceName: kServiceConfigureGrid, withDelegate: self, withRequestType: eHTTPGetRequest, withReturningDelegate: delegate)
        
    }
    
    
    
    
    func getSeatAssignmentofSession(sessionId:String,  withDelegate delegate:SSTeacherDataSourceDelegate)
    {

        
        let manager = APIManager()
        
        let urlString = String(format: "%@<Sunstone><Action><Service>RetrieveSeatAssignments</Service><SessionId>%@</SessionId></Action></Sunstone>",URLPrefix,sessionId)
        
        manager.downloadDataURL(urlString, withServiceName: kServiceGetSeatAssignment, withDelegate: self, withRequestType: eHTTPGetRequest, withReturningDelegate: delegate)
    }
    
    func getStudentsInfoWithSessionId(sessionId:String,  withDelegate delegate:SSTeacherDataSourceDelegate)
    {

        
        let manager = APIManager()
        
        let urlString = String(format: "%@<Sunstone><Action><Service>GetStudentsSessionInfo</Service><SessionId>%@</SessionId></Action></Sunstone>",URLPrefix,sessionId)
        
        manager.downloadDataURL(urlString, withServiceName: kGetStudentsSessionInfo, withDelegate: self, withRequestType: eHTTPGetRequest, withReturningDelegate: delegate)
    }
    
    func SaveSeatAssignmentWithStudentsList(studentsList:String, withSeatsIdList seatIdList:String, withSessionId sessionId:String, withDelegate delegate:SSTeacherDataSourceDelegate)
    {

        
        let manager = APIManager()
        
        let urlString = String(format: "%@<Sunstone><Action><Service>StudentSeatAssignment</Service><SessionId>%@</SessionId><StudentIdList>%@</StudentIdList><SeatIdList>%@</SeatIdList><StatusId>9</StatusId></Action></Sunstone>",URLPrefix,sessionId,studentsList,seatIdList)
        
        manager.downloadDataURL(urlString, withServiceName: kServiceSeatAssignment, withDelegate: self, withRequestType: eHTTPGetRequest, withReturningDelegate: delegate)
    }
    
    
    func getAllNodesWithClassId(classId:String, withSubjectId subjectId:String, withTopicId topicId:String,withType type:String, withDelegate delegate:SSTeacherDataSourceDelegate)
    {

        
        let manager = APIManager()
        
        let urlString = String(format: "%@<Sunstone><Action><Service>GetAllNodes</Service><ClassId>%@</ClassId><SubjectId>%@</SubjectId><TopicId>%@</TopicId><Type>%@</Type></Action></Sunstone>",URLPrefix,classId,subjectId,topicId,type)
        
        manager.downloadDataURL(urlString, withServiceName: kServiceGetAllNodes, withDelegate: self, withRequestType: eHTTPGetRequest, withReturningDelegate: delegate)
    }
    
    func saveLessonPlan(classId:String,  withTopicIdList topicIdList:String, withDelegate delegate:SSTeacherDataSourceDelegate)
    {

        
        let manager = APIManager()
        
        let urlString = String(format: "%@<Sunstone><Action><Service>RecordLessonPlan</Service><TeacherId>%@</TeacherId><ClassId>%@</ClassId><TopicIdList>%@</TopicIdList></Action></Sunstone>",URLPrefix,currentUserId,classId,topicIdList)
        
        manager.downloadDataURL(urlString, withServiceName: kServiceSaveLessonPlan, withDelegate: self, withRequestType: eHTTPGetRequest, withReturningDelegate: delegate)
    }
    
   
    func startSubTopicWithTopicID(topicId:String,withStudentId studentId:String,withSessionID sessionid:String, withDelegate delegate:SSTeacherDataSourceDelegate)
    {

        
        let manager = APIManager()
        
        let urlString = String(format: "%@<Sunstone><Action><Service>SetCurrentTopic</Service><TopicId>%@</TopicId><SessionId>%@</SessionId><StudentId>%@</StudentId></Action></Sunstone>",URLPrefix,topicId,sessionid,studentId)
        
        manager.downloadDataURL(urlString, withServiceName: kServiceStartTopic, withDelegate: self, withRequestType: eHTTPGetRequest, withReturningDelegate: delegate)
    }
    
    func stopSubTopicWithTopicID(topicId:String,withSessionID sessionid:String, withDelegate delegate:SSTeacherDataSourceDelegate)
    {

        
        let manager = APIManager()
        
        let urlString = String(format: "%@<Sunstone><Action><Service>StopTopic</Service><TopicId>%@</TopicId><SessionId>%@</SessionId></Action></Sunstone>",URLPrefix,topicId,sessionid)
        
        manager.downloadDataURL(urlString, withServiceName: kServiceStopTopic, withDelegate: self, withRequestType: eHTTPGetRequest, withReturningDelegate: delegate)
    }
    
    
    
    
    func broadcastQuestionWithQuestionId(questionId:String,withSessionID sessionID:String, withDelegate delegate:SSTeacherDataSourceDelegate)
    {

        
        let manager = APIManager()
        
        let urlString = String(format: "%@<Sunstone><Action><Service>BroadcastQuestion</Service><QuestionId>%@</QuestionId><SessionId>%@</SessionId></Action></Sunstone>",URLPrefix,questionId,sessionID)
        
        manager.downloadDataURL(urlString, withServiceName: kServiceBroadcastQuestion, withDelegate: self, withRequestType: eHTTPGetRequest, withReturningDelegate: delegate)
    }

    func clearQuestionWithQuestionogId(questionLogId:String, withDelegate delegate:SSTeacherDataSourceDelegate)
    {

        
        let manager = APIManager()
        
        let urlString = String(format: "%@<Sunstone><Action><Service>ClearQuestion</Service><QuestionId>%@</QuestionId></Action></Sunstone>",URLPrefix,questionLogId)
        
        manager.downloadDataURL(urlString, withServiceName: kServiceClearQuestion, withDelegate: self, withRequestType: eHTTPGetRequest, withReturningDelegate: delegate)
    }
    
    func getStudentsAswerWithAnswerId(answerId:String, withDelegate delegate:SSTeacherDataSourceDelegate)
    {

        
        let manager = APIManager()
        
        let urlString = String(format: "%@<Sunstone><Action><Service>RetrieveStudentAnswer</Service><AssessmentAnswerId>%@</AssessmentAnswerId></Action></Sunstone>",URLPrefix,answerId)
        
        manager.downloadDataURL(urlString, withServiceName: kServiceRetrieveStudentAnswer, withDelegate: self, withRequestType: eHTTPGetRequest, withReturningDelegate: delegate)
    }
    
    func getAgregateDrilDownWithOptionId(OptionId:String,WithQuestionLogId QuestionLogId:String, WithDelegate delegate:SSTeacherDataSourceDelegate)
    {

        
        let manager = APIManager()
        
        let urlString = String(format: "%@<Sunstone><Action><Service>RetrieveAggregateDrillDown</Service><QuestionLogId>%@</QuestionLogId><OptionId>%@</OptionId></Action></Sunstone>",URLPrefix,QuestionLogId,OptionId)
        
        manager.downloadDataURL(urlString, withServiceName: kServiceAgregateDrillDown, withDelegate: self, withRequestType: eHTTPGetRequest, withReturningDelegate: delegate)
    }
    
    
    func fetchQuestionWithQuestionLogId(questionLogId:String, WithDelegate delegate:SSTeacherDataSourceDelegate)
    {

        
        let manager = APIManager()
        
        let urlString = String(format: "%@<Sunstone><Action><Service>FetchQuestion</Service><QuestionLogId>%@</QuestionLogId></Action></Sunstone>",URLPrefix,questionLogId)
        
        manager.downloadDataURL(urlString, withServiceName: kServiceGetQuestion, withDelegate: self, withRequestType: eHTTPGetRequest, withReturningDelegate: delegate)
    }

    
    
    func getModelAnswerWithQuestionLogId(questionLogId:String, WithDelegate delegate:SSTeacherDataSourceDelegate)
    {
        
        
        let manager = APIManager()
        
        let urlString = String(format: "%@<Sunstone><Action><Service>GetAllModelAnswers</Service><QuestionLogId>%@</QuestionLogId></Action></Sunstone>",URLPrefix,questionLogId)
        
        manager.downloadDataURL(urlString, withServiceName: kGetAllModelAnswer, withDelegate: self, withRequestType: eHTTPGetRequest, withReturningDelegate: delegate)
    }

    
    
    func logOutTeacherWithDelegate( delegate:SSTeacherDataSourceDelegate)
    {
        
        
        let manager = APIManager()
        
        let urlString = String(format: "%@<Sunstone><Action><Service>Logout</Service><UserId>%@</UserId></Action></Sunstone>",URLPrefix,currentUserId)
        
        manager.downloadDataURL(urlString, withServiceName: kServiceUserLogout, withDelegate: self, withRequestType: eHTTPGetRequest, withReturningDelegate: delegate)
    }

    
    
    
    
    
    func sendFeedbackToStudentWithDetails(details:AnyObject, WithDelegate delegate:SSTeacherDataSourceDelegate)
    {

        
        let manager = APIManager()
        
        
        var assessmentId = ""
        
        var imageUrl = ""
        
        var ratings = ""
        
        var badgeId = ""
        
        var textRating = ""
        
        var studentId = ""
        
        var modelAnswerFalg = "0"
        
        
        
        
        if let  AssessmentAnswerId = details.objectForKey("AssessmentAnswerId") as? String
        {
            assessmentId  = AssessmentAnswerId
        }
        
        if let  BadgeId = details.objectForKey("BadgeId") as? String
        {
            badgeId  = BadgeId
        }
        
        if let  _ModelAnswerFlag = details.objectForKey("ModelAnswerFlag") as? String
        {
            if _ModelAnswerFlag == "true"
            {
                modelAnswerFalg = "1"
            }
            else
            {
                modelAnswerFalg = "0"
            }
            
        }
        
        if let  Rating = details.objectForKey("Rating") as? String
        {
            ratings  = Rating
        }
        
        if let  StudentId = details.objectForKey("StudentId") as? String
        {
            studentId  = StudentId
        }
        
        if let  _imageUrl = details.objectForKey("imageUrl") as? String
        {
            imageUrl  = _imageUrl
        }
        
        if let  _textRating = details.objectForKey("textRating") as? String
        {
            textRating  = _textRating
        }
        
        
        
        
        
        let urlString = String(format: "%@<Sunstone><Action><Service>SendFeedback</Service><AssessmentAnswerIdList>%@</AssessmentAnswerIdList><TeacherId>%@</TeacherId><URL>%@</URL><Rating>%@</Rating><TextRating>%@</TextRating><BadgeId>%@</BadgeId><StudentId>%@</StudentId><ModelAnswerFlag>%@</ModelAnswerFlag></Action></Sunstone>",URLPrefix,assessmentId,currentUserId,imageUrl,ratings,textRating,badgeId,studentId,modelAnswerFalg)
        
        manager.downloadDataURL(urlString, withServiceName: kServiceSendFeedback, withDelegate: self, withRequestType: eHTTPGetRequest, withReturningDelegate: delegate)
    }
    
    
    
//    
//    func sendFeedbackToStudentWithDetails(details:AnyObject, WithDelegate delegate:SSTeacherDataSourceDelegate)
//    {
//        setdelegate(delegate)
//        
//       
//        
//        
//        
//        
//        
//        let urlString = String(format: "%@<Sunstone><Action><Service>SendFeedback</Service><AssessmentAnswerIdList>%@</AssessmentAnswerIdList><TeacherId>%@</TeacherId><URL>%@</URL><Rating>%@</Rating><TextRating>%@</TextRating><BadgeId>%@</BadgeId><StudentId>%@</StudentId><ModelAnswerFlag>%@</ModelAnswerFlag></Action></Sunstone>",URLPrefix,assessmentId,currentUserId,imageUrl,ratings,textRating,badgeId,studentId,modelAnswerFalg)
//        
//        manager.downloadDataURL(urlString, withServiceName: kServiceSendFeedback, withDelegate: self, withRequestType: eHTTPGetRequest)
//    }
//    
//    
    
    
    func getQueryWithQueryId(QueryId:String, WithDelegate delegate:SSTeacherDataSourceDelegate)
    {

        
        let manager = APIManager()
        
        let urlString = String(format: "%@<Sunstone><Action><Service>RetrieveStudentQuery</Service><QueryId>%@</QueryId></Action></Sunstone>",URLPrefix,QueryId)
        
        manager.downloadDataURL(urlString, withServiceName: kServiceGetDoubt, withDelegate: self, withRequestType: eHTTPGetRequest, withReturningDelegate: delegate)
    }
    
    
    func replyToDoubtWithDetails(details:AnyObject, WithDelegate delegate:SSTeacherDataSourceDelegate)
    {

        
        
        
        
        
        
        var QueryId = ""
        
        var TeacherReplyText = ""
        
        var BadgeId = ""
        
        var DismissFlag = ""
        
        var StudentId = ""
        
        
        
        
        if let  _QueryId = details.objectForKey("QueryId") as? String
        {
            QueryId  = _QueryId
        }
        
        if let  _TeacherReplyText = details.objectForKey("TeacherReplyText") as? String
        {
            TeacherReplyText  = _TeacherReplyText
        }
        
        
        if let  _BadgeId = details.objectForKey("GoodQuery") as? String
        {
            BadgeId  = _BadgeId
        }
        
        if let  _DismissFlag = details.objectForKey("DismissFlag") as? String
        {
            DismissFlag  = _DismissFlag
        }
        
        if let  _StudentId = details.objectForKey("StudentId") as? String
        {
            StudentId  = _StudentId
        }


        
        
        
        
        
        
        
        
        
        let manager = APIManager()
        
        let urlString = String(format: "%@<Sunstone><Action><Service>RespondToQuery</Service><QueryId>%@</QueryId><TeacherReplyText>%@</TeacherReplyText><BadgeId>%@</BadgeId><DismissFlag>%@</DismissFlag><StudentId>%@</StudentId></Action></Sunstone>",URLPrefix,QueryId,TeacherReplyText,BadgeId,DismissFlag,StudentId)
        
        manager.downloadDataURL(urlString, withServiceName: kServiceReplyToQuery, withDelegate: self, withRequestType: eHTTPGetRequest, withReturningDelegate: delegate)
    }
    
    
    func dismissQuerySelectedForVolunteerWithQueryId(queryId:String, withStudentId StudentId:String, WithDelegate delegate:SSTeacherDataSourceDelegate)
    {
        let manager = APIManager()
        
        let urlString = String(format: "%@<Sunstone><Action><Service>RespondToQuery</Service><QueryId>%@</QueryId><DismissFlag>1</DismissFlag><StudentId>%@</StudentId></Action></Sunstone>",URLPrefix,queryId,StudentId)
        
        manager.downloadDataURL(urlString, withServiceName: kServiceReplyToQuery, withDelegate: self, withRequestType: eHTTPGetRequest, withReturningDelegate: delegate)
    }
    
    func GetSRQWithSessionId(sessionId:String, withDelegate delegate:SSTeacherDataSourceDelegate)
    {
        
        
        let manager = APIManager()
        
        let urlString = String(format: "%@<Sunstone><Action><Service>FetchSRQ</Service><SessionId>%@</SessionId></Action></Sunstone>",URLPrefix,sessionId)
        
        manager.downloadDataURL(urlString, withServiceName: kServiceFetchSRQ, withDelegate: self, withRequestType: eHTTPGetRequest, withReturningDelegate: delegate)
    }
    
    
    
    func saveSelectedVolunteers(QueryIdList:String, withAllowVolunteerList allowVolunteer:String, WithDelegate delegate:SSTeacherDataSourceDelegate)
    {

        
        let manager = APIManager()
        
        let urlString = String(format: "%@<Sunstone><Action><Service>SaveSelectedQueries</Service><QueryIdList>%@</QueryIdList><AllowVolunteerFlag>%@</AllowVolunteerFlag></Action></Sunstone>",URLPrefix,QueryIdList,allowVolunteer)
        
        manager.downloadDataURL(urlString, withServiceName: kServiceSaveSelectedQueries, withDelegate: self, withRequestType: eHTTPGetRequest, withReturningDelegate: delegate)
    }
    
    
    
    func EndVolunteeringSessionwithQueryId(QueryIdList:String, withMeTooList MeTooList:String, WithDelegate delegate:SSTeacherDataSourceDelegate)
    {

        
        
        let manager = APIManager()
        
        let urlString = String(format: "%@<Sunstone><Action><Service>EndVolunteeringSession</Service><SessionId>%@</SessionId><QueryIdList>%@</QueryIdList><MeTooCountList>%@</MeTooCountList></Action></Sunstone>",URLPrefix,currentLiveSessionId,QueryIdList,MeTooList)
        
        manager.downloadDataURL(urlString, withServiceName: kServiceEndVolunteeringSession, withDelegate: self, withRequestType: eHTTPGetRequest, withReturningDelegate: delegate)
    }
    
    
    
    
    func uploadTeacherScribble(ScribbleId:String, WithDelegate delegate:SSTeacherDataSourceDelegate)
    {

        
        let manager = APIManager()
        
        
        
        let urlString = String(format: "%@<Sunstone><Action><Service>UploadTeacherScribble</Service><ImagePath>%@</ImagePath><TeacherId>%@</TeacherId></Action></Sunstone>",URLPrefix,ScribbleId,currentUserId)
        
        manager.downloadDataURL(urlString, withServiceName: kuploadTeacherScribble, withDelegate: self, withRequestType: eHTTPGetRequest, withReturningDelegate: delegate)
    }
    
    func recordQuestionWithScribbleId(ScribbleId:String,withQuestionName questionName:String,WithType Type:String,withTopicId topicd:String, WithDelegate delegate:SSTeacherDataSourceDelegate)
    {

        
        let manager = APIManager()
        
        
        
        let urlString = String(format: "%@<Sunstone><Action><Service>RecordQuestion</Service><SessionId>%@</SessionId><QuestionType>%@</QuestionType><TopicId>%@</TopicId><TeacherId>%@</TeacherId><ScribbleId>%@</ScribbleId><QuestionTitle>%@</QuestionTitle></Action></Sunstone>",URLPrefix,currentLiveSessionId,Type,topicd,currentUserId,ScribbleId,questionName)
        
        manager.downloadDataURL(urlString, withServiceName: kRecordQuestion, withDelegate: self, withRequestType: eHTTPGetRequest, withReturningDelegate: delegate)
    }
    
    
    func recordModelAnswerwithAssesmentAnswerId(AssesmentAnswerId:String,WithDelegate delegate:SSTeacherDataSourceDelegate)
    {

        
        let manager = APIManager()
        
        let urlString = String(format: "%@<Sunstone><Action><Service>RecordModelAnswer</Service><AssessmentAnswerId>%@</AssessmentAnswerId></Action></Sunstone>",URLPrefix,AssesmentAnswerId)
        
        manager.downloadDataURL(urlString, withServiceName: kRecordModelAnswer, withDelegate: self, withRequestType: eHTTPGetRequest, withReturningDelegate: delegate)
    }
    
    
    func sendApporoveVolunteerWithVolunteerId(VolunteerId:String,withstateFlag stateFlag:String, WithDelegate delegate:SSTeacherDataSourceDelegate)
    {
        
        let manager = APIManager()
        
        let urlString = String(format: "%@<Sunstone><Action><Service>ApproveVolunteer</Service><VolunteerId>%@</VolunteerId><StoppedFlag>%@</StoppedFlag></Action></Sunstone>",URLPrefix,VolunteerId,stateFlag)
        
        manager.downloadDataURL(urlString, withServiceName: kServiceApproveVolunteer, withDelegate: self, withRequestType: eHTTPGetRequest, withReturningDelegate: delegate)
    }
    
    func StopVolunteeringwithVolunteerId(VolunteerId:String,withthumbsUp ThumbsUpValue:String,withthumbsDown ThumbsDown:String, WithDelegate delegate:SSTeacherDataSourceDelegate)
    {
        
        let manager = APIManager()
        
        let urlString = String(format: "%@<Sunstone><Action><Service>StopVolunteering</Service><VolunteerId>%@</VolunteerId><ThumbsUpVotes>%@</ThumbsUpVotes><ThumbsDownVotes>%@</ThumbsDownVotes></Action></Sunstone>",URLPrefix,VolunteerId,ThumbsUpValue,ThumbsDown)
        
        manager.downloadDataURL(urlString, withServiceName: kServiceStopVolunteering, withDelegate: self, withRequestType: eHTTPGetRequest, withReturningDelegate: delegate)
    }
    
    
    
    
    // MARK: - API delegate Functions
    func delegateDidGetServiceResponseWithDetails(dict: NSMutableDictionary!, WIthServiceName serviceName: String!, withRetruningDelegate returningDelegate: AnyObject!)
    {
        
        let refinedDetails = dict.objectForKey(kSunstone)!.objectForKey(kSSAction)!
        if serviceName == kServiceGetMyState
        {
            if returningDelegate.respondsToSelector(#selector(SSTeacherDataSourceDelegate.didGetUserStateWithDetails(_:)))
            {
                returningDelegate.didGetUserStateWithDetails!(refinedDetails)
            }
            
        }
        else if serviceName == kServiceUserLogin
        {
            if returningDelegate.respondsToSelector(#selector(SSTeacherDataSourceDelegate.didGetloginWithDetails(_:)))
            {
                returningDelegate.didGetloginWithDetails!(refinedDetails)
            }
        }
        else if serviceName == kServiceGetSchedules
        {
            if returningDelegate.respondsToSelector(#selector(SSTeacherDataSourceDelegate.didGetSchedulesWithDetials(_:)))
            {
                returningDelegate.didGetSchedulesWithDetials!(refinedDetails)
            }
        }
        else if serviceName == kServiceGetMyCurrentSession
        {
            if returningDelegate.respondsToSelector(#selector(SSTeacherDataSourceDelegate.didGetMycurrentSessionWithDetials(_:)))
            {
                returningDelegate.didGetMycurrentSessionWithDetials!(refinedDetails)
            }
        }
        else if serviceName == kServiceGetScheduleSummary
        {
            if returningDelegate.respondsToSelector(#selector(SSTeacherDataSourceDelegate.didGetSessionSummaryDetials(_:)))
            {
                returningDelegate.didGetSessionSummaryDetials!(refinedDetails)
            }
        }
        else if serviceName == kServiceUpdateSessionState
        {
            if returningDelegate.respondsToSelector(#selector(SSTeacherDataSourceDelegate.didGetSessionUpdatedWithDetials(_:)))
            {
                returningDelegate.didGetSessionUpdatedWithDetials!(refinedDetails)
            }
        }
        else if serviceName == kServiceExtendTime
        {
            if returningDelegate.respondsToSelector(#selector(SSTeacherDataSourceDelegate.didGetSessionExtendedDetials(_:)))
            {
                returningDelegate.didGetSessionExtendedDetials!(refinedDetails)
            }
        }
        else if serviceName == kServiceResetSeatAssignment
        {
            if returningDelegate.respondsToSelector(#selector(SSTeacherDataSourceDelegate.didGetSeatsRestWithDetials(_:)))
            {
                returningDelegate.didGetSeatsRestWithDetials!(refinedDetails)
            }
        }
        
        else if serviceName == kServiceGetGridDesign
        {
            if returningDelegate.respondsToSelector(#selector(SSTeacherDataSourceDelegate.didGetGridDesignWithDetails(_:)))
            {
                returningDelegate.didGetGridDesignWithDetails!(refinedDetails)
            }
        }
            
        else if serviceName == kServiceGetSeatAssignment
        {
            if returningDelegate.respondsToSelector(#selector(SSTeacherDataSourceDelegate.didGetSeatAssignmentWithDetails(_:)))
            {
                returningDelegate.didGetSeatAssignmentWithDetails!(refinedDetails)
            }
        }
        else if serviceName == kGetStudentsSessionInfo
        {
            if returningDelegate.respondsToSelector(#selector(SSTeacherDataSourceDelegate.didGetStudentsInfoWithDetails(_:)))
            {
                returningDelegate.didGetStudentsInfoWithDetails!(refinedDetails)
            }
        }
        else if serviceName == kServiceSeatAssignment
        {
            if returningDelegate.respondsToSelector(#selector(SSTeacherDataSourceDelegate.didGetSeatAssignmentSavedWithDetails(_:)))
            {
                returningDelegate.didGetSeatAssignmentSavedWithDetails!(refinedDetails)
            }
        }
        else if serviceName == kServiceGetAllNodes
        {
            if returningDelegate.respondsToSelector(#selector(SSTeacherDataSourceDelegate.didGetAllNodesWithDetails(_:)))
            {
                returningDelegate.didGetAllNodesWithDetails!(refinedDetails)
            }
        }
        else if serviceName == kServiceStartTopic
        {
            if returningDelegate.respondsToSelector(#selector(SSTeacherDataSourceDelegate.didGetSubtopicStartedWithDetails(_:)))
            {
                returningDelegate.didGetSubtopicStartedWithDetails!(refinedDetails)
            }
        }
        else if serviceName == kServiceBroadcastQuestion
        {
            if returningDelegate.respondsToSelector(#selector(SSTeacherDataSourceDelegate.didGetQuestionSentWithDetails(_:)))
            {
                returningDelegate.didGetQuestionSentWithDetails!(refinedDetails)
            }
        }
        else if serviceName == kServiceClearQuestion
        {
            if returningDelegate.respondsToSelector(#selector(SSTeacherDataSourceDelegate.didGetQuestionClearedWithDetails(_:)))
            {
                returningDelegate.didGetQuestionClearedWithDetails!(refinedDetails)
            }
        }
        else if serviceName == kServiceRetrieveStudentAnswer
        {
            if returningDelegate.respondsToSelector(#selector(SSTeacherDataSourceDelegate.didGetStudentsAnswerWithDetails(_:)))
            {
                returningDelegate.didGetStudentsAnswerWithDetails!(refinedDetails)
            }
        }
        else if serviceName == kServiceAgregateDrillDown
        {
            if returningDelegate.respondsToSelector(#selector(SSTeacherDataSourceDelegate.didGetAgregateDrillDownWithDetails(_:)))
            {
                returningDelegate.didGetAgregateDrillDownWithDetails!(refinedDetails)
            }
        }
        else if serviceName == kServiceSendFeedback
        {
            if returningDelegate.respondsToSelector(#selector(SSTeacherDataSourceDelegate.didGetFeedbackSentWithDetails(_:)))
            {
                returningDelegate.didGetFeedbackSentWithDetails!(refinedDetails)
            }
        }
        else if serviceName == kServiceGetDoubt
        {
            if returningDelegate.respondsToSelector(#selector(SSTeacherDataSourceDelegate.didGetQueryWithDetails(_:)))
            {
                returningDelegate.didGetQueryWithDetails!(refinedDetails)
            }
        }
        else if serviceName == kServiceReplyToQuery
        {
            if returningDelegate.respondsToSelector(#selector(SSTeacherDataSourceDelegate.didGetQueryRespondedWithDetails(_:)))
            {
                returningDelegate.didGetQueryRespondedWithDetails!(refinedDetails)
            }
        }
        else if serviceName == kServiceSaveSelectedQueries
        {
            if returningDelegate.respondsToSelector(#selector(SSTeacherDataSourceDelegate.didGetSaveSelectedQueryWithDetails(_:)))
            {
                returningDelegate.didGetSaveSelectedQueryWithDetails!(refinedDetails)
            }
        }
        else if serviceName == kServiceEndVolunteeringSession
        {
            if returningDelegate.respondsToSelector(#selector(SSTeacherDataSourceDelegate.didGetVolunteeringEndedWithDetails(_:)))
            {
                returningDelegate.didGetVolunteeringEndedWithDetails!(refinedDetails)
            }
        }
        else if serviceName == kServiceGetMaxStudentRegisterd
        {
            if returningDelegate.respondsToSelector(#selector(SSTeacherDataSourceDelegate.didGetMaxStudentsRegistedWithDetails(_:)))
            {
                returningDelegate.didGetMaxStudentsRegistedWithDetails!(refinedDetails)
            }
        }
        else if serviceName == kServiceConfigureGrid
        {
            if returningDelegate.respondsToSelector(#selector(SSTeacherDataSourceDelegate.didGetSeatsConfiguredWithDetails(_:)))
            {
                returningDelegate.didGetSeatsConfiguredWithDetails!(refinedDetails)
            }
        }
        
        else if serviceName == kServiceSaveLessonPlan
        {
            if returningDelegate.respondsToSelector(#selector(SSTeacherDataSourceDelegate.didGetLessonPlanSavedWithdetails(_:)))
            {
                returningDelegate.didGetLessonPlanSavedWithdetails!(refinedDetails)
            }
        }
        else if serviceName == kuploadTeacherScribble
        {
            if returningDelegate.respondsToSelector(#selector(SSTeacherDataSourceDelegate.didGetScribbleUploadedWithDetaisl(_:)))
            {
                returningDelegate.didGetScribbleUploadedWithDetaisl!(refinedDetails)
            }
        }
        else if serviceName == kRecordQuestion
        {
            if returningDelegate.respondsToSelector(#selector(SSTeacherDataSourceDelegate.didGetQuestionRecordedWithDetaisl(_:)))
            {
                returningDelegate.didGetQuestionRecordedWithDetaisl!(refinedDetails)
            }
        }
        else if serviceName == kServiceGetQuestion
        {
            if returningDelegate.respondsToSelector(#selector(SSTeacherDataSourceDelegate.didGetQuestionWithDetails(_:)))
            {
                returningDelegate.didGetQuestionWithDetails!(refinedDetails)
            }
        }
        else if serviceName == kGetAllModelAnswer
        {
            if returningDelegate.respondsToSelector(#selector(SSTeacherDataSourceDelegate.didGetModelAnswerWithDetails(_:)))
            {
                returningDelegate.didGetModelAnswerWithDetails!(refinedDetails)
            }
        }
        else if serviceName == kRecordModelAnswer
        {
            if returningDelegate.respondsToSelector(#selector(SSTeacherDataSourceDelegate.didGetModelAnswerRecordedWithDetails(_:)))
            {
                returningDelegate.didGetModelAnswerRecordedWithDetails!(refinedDetails)
            }
        }
        else if serviceName == kServiceUserLogout
        {
            if returningDelegate.respondsToSelector(#selector(SSTeacherDataSourceDelegate.didGetLogOutWithDetails(_:)))
            {
                returningDelegate.didGetLogOutWithDetails!(refinedDetails)
            }
        }
        else if serviceName == kServiceFetchSRQ
        {
            if returningDelegate.respondsToSelector(#selector(SSTeacherDataSourceDelegate.didGetSRQWithDetails(_:)))
            {
                returningDelegate.didGetSRQWithDetails!(refinedDetails)
            }
            
        }
    }
    

    
    
    
    
    func delegateServiceErrorMessage(message: String!, withServiceName ServiceName: String!, withErrorCode code: String!, withRetruningDelegate returningDelegate: AnyObject!)
    {
        
        if returningDelegate.respondsToSelector(#selector(SSTeacherDataSourceDelegate.didgetErrorMessage(_:WithServiceName:)))
        {
            returningDelegate.didgetErrorMessage!(message,WithServiceName: ServiceName)
        }
        
        print("Error in API \(ServiceName)")
        
    }
    
}