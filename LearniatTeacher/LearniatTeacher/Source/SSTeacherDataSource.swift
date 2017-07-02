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
let kErrorMessage               = "error_message"





var URLPrefix                       =   "http://54.251.104.13/Jupiter/sun.php?api="

let APP_VERSION                     =   "1.6"

let kServiceUserLogin               =   "Login"

let kServiceGetMyState              =   "GetMyState"

let kGetStudentsState               =   "GetStudentsState"

let kServiceGetSchedules            =   "GetMyTodaysSessions"

let kServiceGetMyCurrentSession     =   "GetMyCurrentSession"

let kServiceUpdateSessionState      =   "UpdateSessionState"

let kServiceExtendTime              =   "ExtendSessionTime"

let kServiceGetScheduleSummary      =   "ClassSessionSummary"

let kServiceResetSeatAssignment		=   "ResetSeatAssignment"

let kServiceGetGridDesign           =   "RetrieveGridDesign"

let kGetStudentsSessionInfo         =   "GetStudentsSessionInfo"

let kServiceGetSeatAssignment       =   "RetrieveSeatAssignments"

let kServiceSeatAssignment          =   "StudentSeatAssignment"

let kServiceGetAllNodes				=   "GetAllNodes"

let kServiceSaveLessonPlan			=   "RecordLessonPlan"

let kServiceStartTopic              =   "SetCurrentTopic"

let kServiceStopTopic               =   "StopTopic"

let kServiceBroadcastQuestion		=   "BroadcastQuestion"

let kServiceEndQuestionInstance     =   "EndQuestionInstance"

let kServiceFreezQuestion           =   "CloseQuestionResponse"

let kServiceRetrieveStudentAnswer   =   "RetrieveStudentAnswer"

let kServiceAgregateDrillDown       =   "RetrieveAggregateDrillDown"

let kServiceSendFeedback            =   "SendFeedback"

let kServiceGetDoubt                =   "RetrieveStudentQuery"

let kServiceReplyToQuery            =   "RespondToQuery"

let kServiceSaveSelectedQueries     =   "SaveSelectedQueries"

let kServiceEndVolunteeringSession  =   "EndVolunteeringSession"

let kServiceGetMaxStudentRegisterd  =   "GetMaxStudentRegisterd"

let kServiceConfigureGrid           =   "ConfigureGrid"

let kuploadTeacherScribble          =   "UploadTeacherScribble"

let kRecordQuestion                 =   "RecordQuestion"

let kUpdateRecordedQuestion         =   "UpdateRecordedQuestion"

let kServiceGetQuestion             =   "FetchQuestion"

let  kGetAllModelAnswer             =   "GetAllModelAnswers"

let kRecordModelAnswer              =   "RecordModelAnswer"

let kServiceApproveVolunteer        =   "ApproveVolunteer"

let kServiceStopVolunteering        =   "StopVolunteering"

let kServiceUserLogout              =   "Logout"

let kServiceFetchSRQ                =   "FetchSRQ"

let kServiceMuteStudent             =   "MuteStudent"

let kServiceGetAllRooms             =   "GetAllRooms"

let kServiceGetGraspIndex           =   "GetAllStudentIndex"

let kFetchCategory                  =   "FetchCategory"

let kCreateCategory                 =   "CreateCategory"

let kSelectCategory                 =   "SelectCategory"

let kSaveSuggestionState            =   "SaveSuggestionState"


@objc protocol SSTeacherDataSourceDelegate
{
    @objc optional func didgetErrorMessage(_ message:String, WithServiceName serviceName:String)
    
    @objc optional func didGetUserStateWithDetails(_ details:AnyObject)
    
    @objc optional func didGetStudentsStateWithDetails(_ details:AnyObject)
    
    @objc optional func didGetloginWithDetails(_ details: AnyObject, withError error:NSError?)
    
    @objc optional func didGetSchedulesWithDetials(_ details:AnyObject)
    
    @objc optional func didGetMycurrentSessionWithDetials(_ details:AnyObject)
    
    @objc optional func didGetSessionUpdatedWithDetials(_ details:AnyObject)
    
    @objc optional func didGetSessionSummaryDetials(_ details:AnyObject)
    
    @objc optional func didGetSessionExtendedDetials(_ details:AnyObject)
    
    @objc optional func didGetSeatsRestWithDetials(_ details:AnyObject)
    
    @objc optional func didGetMaxStudentsRegistedWithDetails(_ details:AnyObject)
    
    @objc optional func didGetGridDesignWithDetails(_ details:AnyObject)
    
    @objc optional func didGetSeatsConfiguredWithDetails(_ details:AnyObject)
    
    @objc optional func didGetSeatAssignmentWithDetails(_ details:AnyObject)
    
    @objc optional func didGetStudentsInfoWithDetails(_ details:AnyObject)
    
    @objc optional func didGetSeatAssignmentSavedWithDetails(_ details:AnyObject)
    
    @objc optional func didGetAllNodesWithDetails(_ details:AnyObject)
    
    @objc optional func didGetSubtopicStartedWithDetails(_ details:AnyObject)
    
    @objc optional func didGetQuestionSentWithDetails(_ details:AnyObject)
    
    @objc optional func didGetQuestionClearedWithDetails(_ details:AnyObject)
    
    @objc optional func didGetStudentsAnswerWithDetails(_ details:AnyObject)
    
    @objc optional func didGetAgregateDrillDownWithDetails(_ details:AnyObject)
    
    @objc optional func didGetFeedbackSentWithDetails(_ details:AnyObject)
    
    @objc optional func didGetQueryWithDetails(_ details:AnyObject)
    
    @objc optional func didGetQueryRespondedWithDetails(_ details:AnyObject)
    
    @objc optional func didGetSaveSelectedQueryWithDetails(_ details:AnyObject)
    
    @objc optional func didGetVolunteeringEndedWithDetails(_ details:AnyObject)
    
    @objc optional func didGetLessonPlanSavedWithdetails(_ details:AnyObject)
    
    @objc optional func didGetScribbleUploadedWithDetaisl(_ details:AnyObject)
    
    @objc optional func didGetQuestionRecordedWithDetaisl(_ details:AnyObject)
    
    @objc optional func didGetQuestionRecordedUpdatedWithDetaisl(_ details:AnyObject)
    
    @objc optional func didGetQuestionWithDetails(_ details:AnyObject)
    
    @objc optional func didGetModelAnswerWithDetails(_ details:AnyObject)
    
    @objc optional func didGetModelAnswerRecordedWithDetails(_ details:AnyObject)
    
    @objc optional func didGetLogOutWithDetails(_ details:AnyObject)
    
    @objc optional func didGetSRQWithDetails(_ details:AnyObject)
    
    @objc optional func didGetAllGraspIndexWithDetails(_ details:AnyObject)
    
    @objc optional func didGetCategoryFetchedWithDetails(_ details:AnyObject)
    
    @objc optional func didGetCategoryCreatedWithDetails(_ details:AnyObject)
    
    @objc optional func didGetCategorySelectedWithDetails(_ details:AnyObject)
    
     @objc optional func didGetSaveSuggestionStateWithDetails(_ details:AnyObject)
}



class SSTeacherDataSource: NSObject, APIManagerDelegate
{
     internal  static let sharedDataSource = SSTeacherDataSource()
    
    
    
    var _delgate            :AnyObject!
    
    
    // MARK: - delegate Functions
    
    func setdelegate(_ delegate:AnyObject)
    {
        _delgate = delegate;
    }
    
    func   getDelegate()->AnyObject
    {
        return _delgate;
    }
    
    var currentUserId       :String!
    
    var currentSchoolId     :String!
    
    var currentUSerState    :String!
    
    var currentUserName     :String             = String()
    
    var currentPassword     :String             = String()
    
    var currentLiveSessionId                    = ""
    
    var isSubtopicStarted                       = false
    
    var isQuestionSent                          = false
    
    var subTopicDetailsDictonary                = NSMutableDictionary()
    
    var questionsDictonary                      = NSMutableDictionary()
    
    var currentQuestionLogId                    = ""
    
    var startedSubTopicId                       = ""
    
    var startedMainTopicId                      = ""
    
    var startedSubTopicName                     = ""
    
    var startedMainTopicName                    = ""
    
    var taggedTopicIdArray                      = NSMutableArray()
    
    var isVolunteerAnswering                    = false
    
    var isSimulationEnabled   :Bool             = false
    
    var mDemoQuerySubTopicsArray                = NSMutableArray()
    
    var mDemoCollaborationSubTopicArray         = NSMutableArray()
    
    var mDemoQuestionsIdArray                   = NSMutableArray()
    
    var mOverlayImageName                       = ""
    
    
    func setSubTopicDictonaryWithDict(_ details:NSMutableArray,withKey key:String)
    {
        subTopicDetailsDictonary.setObject(details, forKey: key as NSCopying)
    }
    
    func setQuestionDictonaryWithDict(_ details:NSMutableArray,withKey key:String)
    {
        questionsDictonary.setObject(details, forKey: key as NSCopying)
    }
    
    
    
    // MARK: - API Functions
    
    
    func getUserState(_ userId :String, withDelegate delegate:SSTeacherDataSourceDelegate)
    {
        
        let manager = APIManager()
        
        
        let urlString = String(format: "%@<Sunstone><Action><Service>GetMyState</Service><UserId>%@</UserId></Action></Sunstone>",URLPrefix,userId)
        
        print("ApiValue - \(urlString)")
        
        manager.downloadDataURL(urlString, withServiceName:kServiceGetMyState, withDelegate: self, with: eHTTPGetRequest, withReturningDelegate: delegate)
    }
    
    
    func getStudentsState(_ SessionID :String, withDelegate delegate:SSTeacherDataSourceDelegate)
    {
        
        let manager = APIManager()
        let uuidString:String = UIDevice.current.identifierForVendor!.uuidString

        
        let urlString = String(format: "%@<Sunstone><Action><Service>GetStudentsState</Service><SessionId>%@</SessionId><UserId>%@</UserId><UUID>%@</UUID></Action></Sunstone>",URLPrefix,SessionID,SSTeacherDataSource.sharedDataSource.currentUserId,uuidString)
        print("ApiValue - \(urlString)")
        manager.downloadDataURL(urlString, withServiceName:kGetStudentsState, withDelegate: self, with: eHTTPGetRequest, withReturningDelegate: delegate)
    }
    
    
    
    func LoginWithUserId(_ userId :String , andPassword Password:String, withSuccessHandle success:@escaping ApiSuccessHandler, withfailurehandler failure:@escaping ApiErrorHandler)
    {
        WebServicesAPI().getRequest(fromUrl: AppAPI.Login(UserName: userId, Password: Password).path, details: nil, success: { (result) in
            
            
            let JsonValue = result.parseJSONString
            
            if(JsonValue.jsonData != nil)
            {
                success(JsonValue.jsonData!)
            }
            else
            {
                failure(JsonValue.error!)
            }
            
        }) { (error) in
            failure(error as NSError)
        }
    }
 

    
    /*
    func LoginWithUserId(userId :String , andPassword Password:String, withDelegate Delegate:SSTeacherDataSourceDelegate)
    {
        setdelegate(Delegate)
        
        
        let manager = APIManager()
        let uuidString:String = UIDevice.current.identifierForVendor!.uuidString
        
        let urlString = String(format: "%@<Sunstone><Action><Service>Login</Service><UserName>%@</UserName><UserPassword>%@</UserPassword><AppVersion>%@</AppVersion><DeviceId>%@</DeviceId><IsTeacher>1</IsTeacher></Action></Sunstone>",URLPrefix,userId, Password,APP_VERSION,uuidString)
        
        manager.downloadDataURL(urlString, withServiceName:kServiceUserLogin, withDelegate: self, with: eHTTPGetRequest, withReturningDelegate: Delegate)
    }
    
 */
    
    
    
   
    
    
    func getScheduleOfTeacher(_ delegate:SSTeacherDataSourceDelegate)
    {

        
        let manager = APIManager()
        
        let urlString = String(format: "%@<Sunstone><Action><Service>GetMyTodaysSessions</Service><UserId>%@</UserId></Action></Sunstone>",URLPrefix,currentUserId)
        print("ApiValue - \(urlString)")
        manager.downloadDataURL(urlString, withServiceName: kServiceGetSchedules, withDelegate: self, with: eHTTPGetRequest, withReturningDelegate: delegate)
 
    }
    
    
    
    
    func getScheduleOfTeacher(success:@escaping (_ result: NSArray) -> (), withfailurehandler failure:@escaping ApiErrorHandler)
    {
        WebServicesAPI().getRequest(fromUrl:  AppAPI.TodaysTimeTable(UserId: self.currentUserId).path, details: nil, success: { (result) in
            
            let JsonValue = result.ParseForArrayOfJson
            
            if(JsonValue.arrayObjects != nil)
            {
                success(JsonValue.arrayObjects!)
            }
            else
            {
                failure(JsonValue.error!)
            }
            
        }) { (error) in
            failure(error as NSError)
        }
        
    }
    
    
    
    
    func getMyCurrentSessionOfTeacher(_ delegate:SSTeacherDataSourceDelegate)
    {

        
        let manager = APIManager()
        
        let urlString = String(format: "%@<Sunstone><Action><Service>GetMyCurrentSession</Service><UserId>%@</UserId></Action></Sunstone>",URLPrefix,currentUserId)
        print("ApiValue - \(urlString)")
        manager.downloadDataURL(urlString, withServiceName: kServiceGetMyCurrentSession, withDelegate: self, with: eHTTPGetRequest, withReturningDelegate: delegate)
    }
    
    
    func updateSessionStateWithSessionId(_ sessionId:String,WithStatusvalue Status:String, WithDelegate delegate:SSTeacherDataSourceDelegate)
    {

        
        let manager = APIManager()
        
        let urlString = String(format: "%@<Sunstone><Action><Service>UpdateSessionState</Service><SessionId>%@</SessionId><StatusId>%@</StatusId></Action></Sunstone>",URLPrefix,sessionId,Status)
        print("ApiValue - \(urlString)")
        manager.downloadDataURL(urlString, withServiceName: kServiceUpdateSessionState, withDelegate: self, with: eHTTPGetRequest, withReturningDelegate: delegate)
    }
    
    
    func getScheduleSummaryWithSessionId(_ sessionId:String, WithDelegate delegate:SSTeacherDataSourceDelegate)
    {

        
        let manager = APIManager()
        
        let urlString = String(format: "%@<Sunstone><Action><Service>ClassSessionSummary</Service><SessionId>%@</SessionId></Action></Sunstone>",URLPrefix,sessionId)
        print("ApiValue - \(urlString)")
        manager.downloadDataURL(urlString, withServiceName: kServiceGetScheduleSummary, withDelegate: self, with: eHTTPGetRequest, withReturningDelegate: delegate)
    }

    
    func extendSessionWithSessionId(_ sessionId:String, withTime Time:String, WithDelegate delegate:SSTeacherDataSourceDelegate)
    {

        
        let manager = APIManager()
        
        let urlString = String(format: "%@<Sunstone><Action><Service>ExtendSessionTime</Service><SessionId>%@</SessionId><MinutesExtended>%@</MinutesExtended></Action></Sunstone>",URLPrefix,sessionId,Time)
        print("ApiValue - \(urlString)")
        manager.downloadDataURL(urlString, withServiceName: kServiceExtendTime, withDelegate: self, with: eHTTPGetRequest, withReturningDelegate: delegate)
    }
    
    func resetPreallocatedSeatsOfSession(_ sessionId:String, WithDelegate delegate:SSTeacherDataSourceDelegate)
    {

        
        let manager = APIManager()
        
        let urlString = String(format: "%@<Sunstone><Action><Service>ResetSeatAssignment</Service><SessionId>%@</SessionId></Action></Sunstone>",URLPrefix,sessionId)
        print("ApiValue - \(urlString)")
        manager.downloadDataURL(urlString, withServiceName: kServiceResetSeatAssignment, withDelegate: self, with: eHTTPGetRequest, withReturningDelegate: delegate)
    }
    
    func getGridDesignDetails(_ roomId :String, WithDelegate delegate:SSTeacherDataSourceDelegate)
    {

        
        let manager = APIManager()
        
        let urlString = String(format: "%@<Sunstone><Action><Service>RetrieveGridDesign</Service><RoomId>%@</RoomId></Action></Sunstone>",URLPrefix,roomId)
        print("ApiValue - \(urlString)")
        manager.downloadDataURL(urlString, withServiceName: kServiceGetGridDesign, withDelegate: self, with: eHTTPGetRequest, withReturningDelegate: delegate)
        
    }
    
    func getMaxStudentRegisterdwiRoomId(_ roomId :String, WithDelegate delegate:SSTeacherDataSourceDelegate)
    {

        
        let manager = APIManager()
        
        let urlString = String(format: "%@<Sunstone><Action><Service>GetMaxStudentsRegistered</Service><RoomId>%@</RoomId></Action></Sunstone>",URLPrefix,roomId)
        print("ApiValue - \(urlString)")
        manager.downloadDataURL(urlString, withServiceName: kServiceGetMaxStudentRegisterd, withDelegate: self, with: eHTTPGetRequest, withReturningDelegate: delegate)
        
    }
    
    func ConfigureSeatsWithRoomId(_ roomId :String, withRows rowValue:String, withColumnValue columnValue:String,withRemovedSeats removedSeats:String, WithDelegate delegate:SSTeacherDataSourceDelegate)
    {

        
        let manager = APIManager()
        
        let urlString = String(format: "%@<Sunstone><Action><Service>ConfigureGrid</Service><RoomId>%@</RoomId><Rows>%@</Rows><Columns>%@</Columns><SeatsRemoved>%@</SeatsRemoved></Action></Sunstone>",URLPrefix,roomId,rowValue,columnValue,removedSeats)
        print("ApiValue - \(urlString)")
        manager.downloadDataURL(urlString, withServiceName: kServiceConfigureGrid, withDelegate: self, with: eHTTPGetRequest, withReturningDelegate: delegate)
        
    }
    
    
    
    
    func getSeatAssignmentofSession(_ sessionId:String,  withDelegate delegate:SSTeacherDataSourceDelegate)
    {

        
        let manager = APIManager()
        
        let urlString = String(format: "%@<Sunstone><Action><Service>RetrieveSeatAssignments</Service><SessionId>%@</SessionId></Action></Sunstone>",URLPrefix,sessionId)
        print("ApiValue - \(urlString)")
        manager.downloadDataURL(urlString, withServiceName: kServiceGetSeatAssignment, withDelegate: self, with: eHTTPGetRequest, withReturningDelegate: delegate)
    }
    
    func getStudentsInfoWithSessionId(_ sessionId:String,  withDelegate delegate:SSTeacherDataSourceDelegate)
    {

        
        let manager = APIManager()
        
        let urlString = String(format: "%@<Sunstone><Action><Service>GetStudentsSessionInfo</Service><SessionId>%@</SessionId></Action></Sunstone>",URLPrefix,sessionId)
        print("ApiValue - \(urlString)")
        manager.downloadDataURL(urlString, withServiceName: kGetStudentsSessionInfo, withDelegate: self, with: eHTTPGetRequest, withReturningDelegate: delegate)
    }
    
    func SaveSeatAssignmentWithStudentsList(_ studentsList:String, withSeatsIdList seatIdList:String, withSessionId sessionId:String, withDelegate delegate:SSTeacherDataSourceDelegate)
    {

        
        let manager = APIManager()
        
        let urlString = String(format: "%@<Sunstone><Action><Service>StudentSeatAssignment</Service><SessionId>%@</SessionId><StudentIdList>%@</StudentIdList><SeatIdList>%@</SeatIdList><StatusId>9</StatusId></Action></Sunstone>",URLPrefix,sessionId,studentsList,seatIdList)
        print("ApiValue - \(urlString)")
        manager.downloadDataURL(urlString, withServiceName: kServiceSeatAssignment, withDelegate: self, with: eHTTPGetRequest, withReturningDelegate: delegate)
    }
    
    
    func getAllNodesWithClassId(_ classId:String, withSubjectId subjectId:String, withTopicId topicId:String,withType type:String, withDelegate delegate:SSTeacherDataSourceDelegate)
    {

        
        let manager = APIManager()
        
        let urlString = String(format: "%@<Sunstone><Action><Service>GetAllNodes</Service><ClassId>%@</ClassId><SubjectId>%@</SubjectId><TopicId>%@</TopicId><Type>%@</Type></Action></Sunstone>",URLPrefix,classId,subjectId,topicId,type)
        print("ApiValue - \(urlString)")
        manager.downloadDataURL(urlString, withServiceName: kServiceGetAllNodes, withDelegate: self, with: eHTTPGetRequest, withReturningDelegate: delegate)
    }
    
    func saveLessonPlan(_ classId:String,  withTopicIdList topicIdList:String, withDelegate delegate:SSTeacherDataSourceDelegate)
    {

        
        let manager = APIManager()
        
        let urlString = String(format: "%@<Sunstone><Action><Service>RecordLessonPlan</Service><TeacherId>%@</TeacherId><ClassId>%@</ClassId><TopicIdList>%@</TopicIdList></Action></Sunstone>",URLPrefix,currentUserId,classId,topicIdList)
        print("ApiValue - \(urlString)")
        manager.downloadDataURL(urlString, withServiceName: kServiceSaveLessonPlan, withDelegate: self, with: eHTTPGetRequest, withReturningDelegate: delegate)
    }
    
   
    func startSubTopicWithTopicID(_ topicId:String,withStudentId studentId:String,withSessionID sessionid:String, withDelegate delegate:SSTeacherDataSourceDelegate)
    {

        
        let manager = APIManager()
        
        let urlString = String(format: "%@<Sunstone><Action><Service>SetCurrentTopic</Service><TopicId>%@</TopicId><SessionId>%@</SessionId><StudentId>%@</StudentId></Action></Sunstone>",URLPrefix,topicId,sessionid,studentId)
        print("ApiValue - \(urlString)")
        manager.downloadDataURL(urlString, withServiceName: kServiceStartTopic, withDelegate: self, with: eHTTPGetRequest, withReturningDelegate: delegate)
    }
    
    func stopSubTopicWithTopicID(_ topicId:String,withSessionID sessionid:String, withDelegate delegate:SSTeacherDataSourceDelegate)
    {

        
        let manager = APIManager()
        
        let urlString = String(format: "%@<Sunstone><Action><Service>StopTopic</Service><TopicId>%@</TopicId><SessionId>%@</SessionId></Action></Sunstone>",URLPrefix,topicId,sessionid)
        print("ApiValue - \(urlString)")
        manager.downloadDataURL(urlString, withServiceName: kServiceStopTopic, withDelegate: self, with: eHTTPGetRequest, withReturningDelegate: delegate)
    }
    
    
    func getGraspIndexOfAllStudentsWithTopic(_ topicId:String,withSessionID sessionid:String, withDelegate delegate:SSTeacherDataSourceDelegate)
    {
        
        
        let manager = APIManager()
        
        let urlString = String(format: "%@<Sunstone><Action><Service>GetAllStudentIndex</Service><TopicId>%@</TopicId><SessionId>%@</SessionId></Action></Sunstone>",URLPrefix,topicId,sessionid)
        print("ApiValue - \(urlString)")
        manager.downloadDataURL(urlString, withServiceName: kServiceGetGraspIndex, withDelegate: self, with: eHTTPGetRequest, withReturningDelegate: delegate)
    }
    
    
    func broadcastQuestionWithQuestionId(_ questionId:String,withSessionID sessionID:String, withDelegate delegate:SSTeacherDataSourceDelegate)
    {

        
        let manager = APIManager()
        
        let urlString = String(format: "%@<Sunstone><Action><Service>BroadcastQuestion</Service><QuestionId>%@</QuestionId><SessionId>%@</SessionId></Action></Sunstone>",URLPrefix,questionId,sessionID)
        print("ApiValue - \(urlString)")
        manager.downloadDataURL(urlString, withServiceName: kServiceBroadcastQuestion, withDelegate: self, with: eHTTPGetRequest, withReturningDelegate: delegate)
    }

    func clearQuestionWithQuestionogId(_ questionLogId:String,withTopicId topicId:String, withSessionId sessionId:String, withDelegate delegate:SSTeacherDataSourceDelegate)
    {

        
        let manager = APIManager()
        
        let urlString = String(format: "%@<Sunstone><Action><Service>EndQuestionInstance</Service><QuestionLogId>%@</QuestionLogId><TopicId>%@</TopicId><StudentId>%@</StudentId></Action></Sunstone>",URLPrefix,questionLogId,topicId,sessionId)
        print("ApiValue - \(urlString)")
        manager.downloadDataURL(urlString, withServiceName: kServiceEndQuestionInstance, withDelegate: self, with: eHTTPGetRequest, withReturningDelegate: delegate)
    }
    
    
    func freezQuestionWithQuestionogId(_ questionLogId:String,withTopicId topicId:String, withSessionId sessionId:String, withDelegate delegate:SSTeacherDataSourceDelegate)
    {
        
        
        let manager = APIManager()
        
        let urlString = String(format: "%@<Sunstone><Action><Service>CloseQuestionResponse</Service><QuestionLogId>%@</QuestionLogId><TopicId>%@</TopicId><SessionId>%@</SessionId></Action></Sunstone>",URLPrefix,questionLogId,topicId,sessionId)
        print("ApiValue - \(urlString)")
        manager.downloadDataURL(urlString, withServiceName: kServiceFreezQuestion, withDelegate: self, with: eHTTPGetRequest, withReturningDelegate: delegate)
    }
    
    func getStudentsAswerWithAnswerId(_ answerId:String, withDelegate delegate:SSTeacherDataSourceDelegate)
    {
        let manager = APIManager()
        
        let urlString = String(format: "%@<Sunstone><Action><Service>RetrieveStudentAnswer</Service><AssessmentAnswerId>%@</AssessmentAnswerId></Action></Sunstone>",URLPrefix,answerId)
        print("ApiValue - \(urlString)")
        manager.downloadDataURL(urlString, withServiceName: kServiceRetrieveStudentAnswer, withDelegate: self, with: eHTTPGetRequest, withReturningDelegate: delegate)
    }
    
    func getAgregateDrilDownWithOptionId(_ OptionId:String,WithQuestionLogId QuestionLogId:String, WithDelegate delegate:SSTeacherDataSourceDelegate)
    {

        
        let manager = APIManager()
        
        let urlString = String(format: "%@<Sunstone><Action><Service>RetrieveAggregateDrillDown</Service><QuestionLogId>%@</QuestionLogId><OptionId>%@</OptionId></Action></Sunstone>",URLPrefix,QuestionLogId,OptionId)
        print("ApiValue - \(urlString)")
        manager.downloadDataURL(urlString, withServiceName: kServiceAgregateDrillDown, withDelegate: self, with: eHTTPGetRequest, withReturningDelegate: delegate)
    }
    
    
    func fetchQuestionWithQuestionLogId(_ questionId:String, WithDelegate delegate:SSTeacherDataSourceDelegate)
    {

        
        let manager = APIManager()
        
        let urlString = String(format: "%@<Sunstone><Action><Service>FetchQuestion</Service><QuestionId>%@</QuestionId></Action></Sunstone>",URLPrefix,questionId)
        print("ApiValue - \(urlString)")
        manager.downloadDataURL(urlString, withServiceName: kServiceGetQuestion, withDelegate: self, with: eHTTPGetRequest, withReturningDelegate: delegate)
    }

    
    
    func getModelAnswerWithQuestionLogId(_ questionLogId:String, WithDelegate delegate:SSTeacherDataSourceDelegate)
    {
        
        
        let manager = APIManager()
        
        let urlString = String(format: "%@<Sunstone><Action><Service>GetAllModelAnswers</Service><QuestionLogId>%@</QuestionLogId></Action></Sunstone>",URLPrefix,questionLogId)
        print("ApiValue - \(urlString)")
        manager.downloadDataURL(urlString, withServiceName: kGetAllModelAnswer, withDelegate: self, with: eHTTPGetRequest, withReturningDelegate: delegate)
    }

    
    
    func logOutTeacherWithDelegate( _ delegate:SSTeacherDataSourceDelegate)
    {
        
        
        let manager = APIManager()
        
        let urlString = String(format: "%@<Sunstone><Action><Service>Logout</Service><UserId>%@</UserId></Action></Sunstone>",URLPrefix,currentUserId)
        print("ApiValue - \(urlString)")
        manager.downloadDataURL(urlString, withServiceName: kServiceUserLogout, withDelegate: self, with: eHTTPGetRequest, withReturningDelegate: delegate)
    }

    
    
    
    
    
    func sendFeedbackToStudentWithDetails(_ details:AnyObject, WithDelegate delegate:SSTeacherDataSourceDelegate)
    {

        
        let manager = APIManager()
        
        
        var assessmentId = ""
        
        var imageUrl = ""
        
        var ratings = ""
        
        var badgeId = ""
        
        var textRating = ""
        
        var studentId = ""
        
        var modelAnswerFalg = "0"
        
        
        
        
        if let  AssessmentAnswerId = details.object(forKey: "AssessmentAnswerId") as? String
        {
            assessmentId  = AssessmentAnswerId
        }
        
        if let  BadgeId = details.object(forKey: "BadgeId") as? String
        {
            badgeId  = BadgeId
        }
        
        if let  _ModelAnswerFlag = details.object(forKey: "ModelAnswerFlag") as? String
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
        
        if let  Rating = details.object(forKey: "Rating") as? String
        {
            ratings  = Rating
        }
        
        if let  StudentId = details.object(forKey: "StudentId") as? String
        {
            studentId  = StudentId
        }
        
        if let  _imageUrl = details.object(forKey: "imageUrl") as? String
        {
            imageUrl  = _imageUrl
        }
        
        if let  _textRating = details.object(forKey: "textRating") as? String
        {
            textRating  = _textRating
        }
        
        
        let urlString = String(format: "%@<Sunstone><Action><Service>SendFeedback</Service><AssessmentAnswerIdList>%@</AssessmentAnswerIdList><TeacherId>%@</TeacherId><URL>%@</URL><Rating>%@</Rating><TextRating>%@</TextRating><BadgeId>%@</BadgeId><StudentId>%@</StudentId><ModelAnswerFlag>%@</ModelAnswerFlag></Action></Sunstone>",URLPrefix,assessmentId,currentUserId,imageUrl,ratings,textRating,badgeId,studentId,modelAnswerFalg)
        print("ApiValue - \(urlString)")
        manager.downloadDataURL(urlString, withServiceName: kServiceSendFeedback, withDelegate: self, with: eHTTPGetRequest, withReturningDelegate: delegate)
    }
    
    
    func getQueryWithQueryId(_ QueryId:String, WithDelegate delegate:SSTeacherDataSourceDelegate)
    {

        
        let manager = APIManager()
        
        let urlString = String(format: "%@<Sunstone><Action><Service>RetrieveStudentQuery</Service><QueryId>%@</QueryId></Action></Sunstone>",URLPrefix,QueryId)
        print("ApiValue - \(urlString)")
        manager.downloadDataURL(urlString, withServiceName: kServiceGetDoubt, withDelegate: self, with: eHTTPGetRequest, withReturningDelegate: delegate)
    }
    
    
    func replyToDoubtWithDetails(_ details:AnyObject, WithDelegate delegate:SSTeacherDataSourceDelegate)
    {

        
        var QueryId = ""
        
        var TeacherReplyText = ""
        
        var BadgeId = ""
        
        var DismissFlag = ""
        
        var StudentId = ""
        
        
        
        
        if let  _QueryId = details.object(forKey: "QueryId") as? String
        {
            QueryId  = _QueryId
        }
        
        if let  _TeacherReplyText = details.object(forKey: "TeacherReplyText") as? String
        {
            TeacherReplyText  = _TeacherReplyText
        }
        
        
        if let  _BadgeId = details.object(forKey: "GoodQuery") as? String
        {
            BadgeId  = _BadgeId
        }
        
        if let  _DismissFlag = details.object(forKey: "DismissFlag") as? String
        {
            DismissFlag  = _DismissFlag
        }
        
        if let  _StudentId = details.object(forKey: "StudentId") as? String
        {
            StudentId  = _StudentId
        }


        let manager = APIManager()
        
        let urlString = String(format: "%@<Sunstone><Action><Service>RespondToQuery</Service><QueryId>%@</QueryId><TeacherReplyText>%@</TeacherReplyText><BadgeId>%@</BadgeId><DismissFlag>%@</DismissFlag><StudentId>%@</StudentId></Action></Sunstone>",URLPrefix,QueryId,TeacherReplyText,BadgeId,DismissFlag,StudentId)
        print("ApiValue - \(urlString)")
        manager.downloadDataURL(urlString, withServiceName: kServiceReplyToQuery, withDelegate: self, with: eHTTPGetRequest, withReturningDelegate: delegate)
    }
    
    
    
    
    
    func dismissQuerySelectedForVolunteerWithQueryId(_ queryId:String, withStudentId StudentId:String, WithDelegate delegate:SSTeacherDataSourceDelegate)
    {
        let manager = APIManager()
        
        let urlString = String(format: "%@<Sunstone><Action><Service>RespondToQuery</Service><QueryId>%@</QueryId><DismissFlag>1</DismissFlag><StudentId>%@</StudentId></Action></Sunstone>",URLPrefix,queryId,StudentId)
        print("ApiValue - \(urlString)")
        manager.downloadDataURL(urlString, withServiceName: kServiceReplyToQuery, withDelegate: self, with: eHTTPGetRequest, withReturningDelegate: delegate)
    }
    
    func GetSRQWithSessionId(_ sessionId:String, withDelegate delegate:SSTeacherDataSourceDelegate)
    {
        
        
        let manager = APIManager()
        
        let urlString = String(format: "%@<Sunstone><Action><Service>FetchSRQ</Service><SessionId>%@</SessionId></Action></Sunstone>",URLPrefix,sessionId)
        print("ApiValue - \(urlString)")
        manager.downloadDataURL(urlString, withServiceName: kServiceFetchSRQ, withDelegate: self, with: eHTTPGetRequest, withReturningDelegate: delegate)
    }
    
    
    
    func saveSelectedVolunteers(_ QueryIdList:String, withAllowVolunteerList allowVolunteer:String, WithDelegate delegate:SSTeacherDataSourceDelegate)
    {

        
        let manager = APIManager()
        
        let urlString = String(format: "%@<Sunstone><Action><Service>SaveSelectedQueries</Service><QueryIdList>%@</QueryIdList><AllowVolunteerFlag>%@</AllowVolunteerFlag></Action></Sunstone>",URLPrefix,QueryIdList,allowVolunteer)
        print("ApiValue - \(urlString)")
        manager.downloadDataURL(urlString, withServiceName: kServiceSaveSelectedQueries, withDelegate: self, with: eHTTPGetRequest, withReturningDelegate: delegate)
    }
    
    
    
    func EndVolunteeringSessionwithQueryId(_ QueryIdList:String, withMeTooList MeTooList:String, WithDelegate delegate:SSTeacherDataSourceDelegate)
    {

        
        
        let manager = APIManager()
        
        let urlString = String(format: "%@<Sunstone><Action><Service>EndVolunteeringSession</Service><SessionId>%@</SessionId><QueryIdList>%@</QueryIdList><MeTooCountList>%@</MeTooCountList></Action></Sunstone>",URLPrefix,currentLiveSessionId,QueryIdList,MeTooList)
        print("ApiValue - \(urlString)")
        manager.downloadDataURL(urlString, withServiceName: kServiceEndVolunteeringSession, withDelegate: self, with: eHTTPGetRequest, withReturningDelegate: delegate)
    }
    
    func uploadTeacherScribble(_ ScribbleId:String, WithDelegate delegate:SSTeacherDataSourceDelegate)
    {
        
        let manager = APIManager()
        let urlString = String(format: "%@<Sunstone><Action><Service>UploadTeacherScribble</Service><ImagePath>%@</ImagePath><TeacherId>%@</TeacherId></Action></Sunstone>",URLPrefix,ScribbleId,currentUserId)
        print("ApiValue - \(urlString)")
        manager.downloadDataURL(urlString, withServiceName: kuploadTeacherScribble, withDelegate: self, with: eHTTPGetRequest, withReturningDelegate: delegate)
    }
    
    func recordQuestionWithScribbleId(_ ScribbleId:String,withQuestionName questionName:String,WithType Type:String,withTopicId topicd:String, WithDelegate delegate:SSTeacherDataSourceDelegate)
    {

        
        let manager = APIManager()
        
        
        
        let urlString = String(format: "%@<Sunstone><Action><Service>RecordQuestion</Service><SessionId>%@</SessionId><QuestionType>%@</QuestionType><TopicId>%@</TopicId><TeacherId>%@</TeacherId><ScribbleId>%@</ScribbleId><QuestionTitle>%@</QuestionTitle></Action></Sunstone>",URLPrefix,currentLiveSessionId,Type,topicd,currentUserId,ScribbleId,questionName)
        print("ApiValue - \(urlString)")
        manager.downloadDataURL(urlString, withServiceName: kRecordQuestion, withDelegate: self, with: eHTTPGetRequest, withReturningDelegate: delegate)
    }
    
    
    func updateRecorededQuestionWithQuestionLogId(_ questionLogId:String, withQuestionName QuestionName:String, withQuestionOptions QuestionOptions:String, withAnswerStates answerStates:String, WithDelegate delegate:SSTeacherDataSourceDelegate)
    {
        
        let manager = APIManager()
        
        let urlString = String(format: "%@<Sunstone><Action><Service>UpdateRecordedQuestion</Service><QuestionId>%@</QuestionId><QuestionTitle>%@</QuestionTitle><ElementId>%@</ElementId><IsAnswer>%@</IsAnswer><Column></Column><Sequence></Sequence></Action></Sunstone>",URLPrefix,questionLogId, QuestionName, QuestionOptions, answerStates)
        print("ApiValue - \(urlString)")
        manager.downloadDataURL(urlString, withServiceName: kUpdateRecordedQuestion, withDelegate: self, with: eHTTPGetRequest, withReturningDelegate: delegate)
        
    }
    
    
    
    func recordModelAnswerwithAssesmentAnswerId(_ AssesmentAnswerId:String,WithDelegate delegate:SSTeacherDataSourceDelegate)
    {

        
        let manager = APIManager()
        
        let urlString = String(format: "%@<Sunstone><Action><Service>RecordModelAnswer</Service><AssessmentAnswerId>%@</AssessmentAnswerId></Action></Sunstone>",URLPrefix,AssesmentAnswerId)
        print("ApiValue - \(urlString)")
        manager.downloadDataURL(urlString, withServiceName: kRecordModelAnswer, withDelegate: self, with: eHTTPGetRequest, withReturningDelegate: delegate)
    }
    
    
    func sendApporoveVolunteerWithVolunteerId(_ VolunteerId:String,withstateFlag stateFlag:String, WithDelegate delegate:SSTeacherDataSourceDelegate)
    {
        
        let manager = APIManager()
        
        let urlString = String(format: "%@<Sunstone><Action><Service>ApproveVolunteer</Service><VolunteerId>%@</VolunteerId><StoppedFlag>%@</StoppedFlag></Action></Sunstone>",URLPrefix,VolunteerId,stateFlag)
        print("ApiValue - \(urlString)")
        manager.downloadDataURL(urlString, withServiceName: kServiceApproveVolunteer, withDelegate: self, with: eHTTPGetRequest, withReturningDelegate: delegate)
    }
    
    func StopVolunteeringwithVolunteerId(_ VolunteerId:String,withthumbsUp ThumbsUpValue:String,withthumbsDown ThumbsDown:String, WithDelegate delegate:SSTeacherDataSourceDelegate)
    {
        
        let manager = APIManager()
        
        let urlString = String(format: "%@<Sunstone><Action><Service>StopVolunteering</Service><VolunteerId>%@</VolunteerId><ThumbsUpVotes>%@</ThumbsUpVotes><ThumbsDownVotes>%@</ThumbsDownVotes></Action></Sunstone>",URLPrefix,VolunteerId,ThumbsUpValue,ThumbsDown)
        print("ApiValue - \(urlString)")
        manager.downloadDataURL(urlString, withServiceName: kServiceStopVolunteering, withDelegate: self, with: eHTTPGetRequest, withReturningDelegate: delegate)
    }
    
    func FetchCategoryWithName(InputCategoryname :String, withTopicId topicId:String , WithDelegate delegate:SSTeacherDataSourceDelegate)
    {
        let uuidString:String = UIDevice.current.identifierForVendor!.uuidString
        
        let manager = APIManager()
        
        let urlString = String(format: "%@<Sunstone><Action><Service>FetchCategory</Service><InputCategory>%@</InputCategory><TopicId>%@</TopicId><UserId>%@</UserId><UUID>%@</UUID></Action></Sunstone>",URLPrefix,InputCategoryname,topicId,SSTeacherDataSource.sharedDataSource.currentUserId,uuidString)
        print("ApiValue - \(urlString)")
        manager.downloadDataURL(urlString, withServiceName: kFetchCategory, withDelegate: self, with: eHTTPGetRequest, withReturningDelegate: delegate)
    }
    
    func sendCategoryWithName(category:String,withDescrpition CategoryDescription:String, withTopicID topicId:String, WithDelegate delegate:SSTeacherDataSourceDelegate)
    {
        
        let uuidString:String = UIDevice.current.identifierForVendor!.uuidString
        
        let manager = APIManager()
        
        let urlString = String(format: "%@<Sunstone><Action><Service>CreateCategory</Service><CategoryTitle>%@</CategoryTitle><CategoryDescription>%@</CategoryDescription><TopicId>%@</TopicId><UserId>%@</UserId><UUID>%@</UUID></Action></Sunstone>",URLPrefix,category,CategoryDescription,topicId,SSTeacherDataSource.sharedDataSource.currentUserId,uuidString)
        print("ApiValue - \(urlString)")
        manager.downloadDataURL(urlString, withServiceName: kCreateCategory, withDelegate: self, with: eHTTPGetRequest, withReturningDelegate: delegate)
        
        
    }
    
    
    func selectCategoryWithCategoryID(categoryId:String,WithDelegate delegate:SSTeacherDataSourceDelegate)
    {
        
        
        let uuidString:String = UIDevice.current.identifierForVendor!.uuidString
        
        let manager = APIManager()
        
        let urlString = String(format: "%@<Sunstone><Action><Service>SelectCategory</Service><CategoryId>%@</CategoryId><UserId>%@</UserId><DeviceId></DeviceId><UUID></UUID></Action></Sunstone>",URLPrefix,categoryId,SSTeacherDataSource.sharedDataSource.currentUserId,uuidString)
        print("ApiValue - \(urlString)")
        manager.downloadDataURL(urlString, withServiceName: kSelectCategory, withDelegate: self, with: eHTTPGetRequest, withReturningDelegate: delegate)
        
    }
    
    func SaveSuggestionStateWithSuggestions(Sugguestion:String, withState State:String,WithDelegate delegate:SSTeacherDataSourceDelegate)
    {
        let uuidString:String = UIDevice.current.identifierForVendor!.uuidString
        
        let manager = APIManager()
        
        let urlString = String(format: "%@<Sunstone><Action><Service>SaveSuggestionState</Service><SuggestionId>%@</SuggestionId><SuggestionState>%@</SuggestionState><UserId>%@</UserId><DeviceId>%@</DeviceId><UUID>%@</UUID></Action></Sunstone>",URLPrefix,Sugguestion,State,SSTeacherDataSource.sharedDataSource.currentUserId,uuidString,uuidString)
        print("ApiValue - \(urlString)")
        manager.downloadDataURL(urlString, withServiceName: kSaveSuggestionState, withDelegate: self, with: eHTTPGetRequest, withReturningDelegate: delegate)
    }
    
    
    // MARK: - API delegate Functions
    func delegateDidGetServiceResponse(withDetails dict: NSMutableDictionary!, wIthServiceName serviceName: String!, withRetruningDelegate returningDelegate: Any!)
    {
        
        let refinedDetails = ((dict.object(forKey: kSunstone) ??  NSMutableDictionary()) as AnyObject).object(forKey: kSSAction) ?? NSMutableDictionary()
        
        let mReturningDelegate = returningDelegate as AnyObject
        
        
        if serviceName == kServiceGetMyState
        {
            if mReturningDelegate.responds(to: #selector(SSTeacherDataSourceDelegate.didGetUserStateWithDetails(_:)))
            {
                mReturningDelegate.didGetUserStateWithDetails!(refinedDetails as AnyObject)
            }
            
        }
        else if serviceName == kGetStudentsState
        {
            if mReturningDelegate.responds(to: #selector(SSTeacherDataSourceDelegate.didGetStudentsStateWithDetails(_:)))
            {
                mReturningDelegate.didGetStudentsStateWithDetails!(refinedDetails as AnyObject)
            }
            
        }
        else if serviceName == kServiceUserLogin
        {
            if mReturningDelegate.responds(to: #selector(SSTeacherDataSourceDelegate.didGetloginWithDetails(_:withError:)))
            {
                mReturningDelegate.didGetloginWithDetails!(refinedDetails as AnyObject,withError: nil)
                
            }
        }
        else if serviceName == kServiceGetSchedules
        {
            if mReturningDelegate.responds(to: #selector(SSTeacherDataSourceDelegate.didGetSchedulesWithDetials(_:)))
            {
                mReturningDelegate.didGetSchedulesWithDetials!(refinedDetails as AnyObject)
            }
        }
        else if serviceName == kServiceGetMyCurrentSession
        {
            if mReturningDelegate.responds(to: #selector(SSTeacherDataSourceDelegate.didGetMycurrentSessionWithDetials(_:)))
            {
                mReturningDelegate.didGetMycurrentSessionWithDetials!(refinedDetails as AnyObject)
            }
        }
        else if serviceName == kServiceGetScheduleSummary
        {
            if mReturningDelegate.responds(to: #selector(SSTeacherDataSourceDelegate.didGetSessionSummaryDetials(_:)))
            {
                mReturningDelegate.didGetSessionSummaryDetials!(refinedDetails as AnyObject)
            }
        }
        else if serviceName == kServiceUpdateSessionState
        {
            if mReturningDelegate.responds(to: #selector(SSTeacherDataSourceDelegate.didGetSessionUpdatedWithDetials(_:)))
            {
                mReturningDelegate.didGetSessionUpdatedWithDetials!(refinedDetails as AnyObject)
            }
        }
        else if serviceName == kServiceExtendTime
        {
            if mReturningDelegate.responds(to: #selector(SSTeacherDataSourceDelegate.didGetSessionExtendedDetials(_:)))
            {
                mReturningDelegate.didGetSessionExtendedDetials!(refinedDetails as AnyObject)
            }
        }
        else if serviceName == kServiceResetSeatAssignment
        {
            if mReturningDelegate.responds(to: #selector(SSTeacherDataSourceDelegate.didGetSeatsRestWithDetials(_:)))
            {
                mReturningDelegate.didGetSeatsRestWithDetials!(refinedDetails as AnyObject)
            }
        }
        
        else if serviceName == kServiceGetGridDesign
        {
            if mReturningDelegate.responds(to: #selector(SSTeacherDataSourceDelegate.didGetGridDesignWithDetails(_:)))
            {
                mReturningDelegate.didGetGridDesignWithDetails!(refinedDetails as AnyObject)
            }
        }
            
        else if serviceName == kServiceGetSeatAssignment
        {
            if mReturningDelegate.responds(to: #selector(SSTeacherDataSourceDelegate.didGetSeatAssignmentWithDetails(_:)))
            {
                mReturningDelegate.didGetSeatAssignmentWithDetails!(refinedDetails as AnyObject)
            }
        }
        else if serviceName == kGetStudentsSessionInfo
        {
            if mReturningDelegate.responds(to: #selector(SSTeacherDataSourceDelegate.didGetStudentsInfoWithDetails(_:)))
            {
                mReturningDelegate.didGetStudentsInfoWithDetails!(refinedDetails as AnyObject)
            }
        }
        else if serviceName == kServiceSeatAssignment
        {
            if mReturningDelegate.responds(to: #selector(SSTeacherDataSourceDelegate.didGetSeatAssignmentSavedWithDetails(_:)))
            {
                mReturningDelegate.didGetSeatAssignmentSavedWithDetails!(refinedDetails as AnyObject)
            }
        }
        else if serviceName == kServiceGetAllNodes
        {
            if mReturningDelegate.responds(to: #selector(SSTeacherDataSourceDelegate.didGetAllNodesWithDetails(_:)))
            {
                mReturningDelegate.didGetAllNodesWithDetails!(refinedDetails as AnyObject)
            }
        }
        else if serviceName == kServiceStartTopic || serviceName == kServiceStopTopic
        {
            if mReturningDelegate.responds(to: #selector(SSTeacherDataSourceDelegate.didGetSubtopicStartedWithDetails(_:)))
            {
                mReturningDelegate.didGetSubtopicStartedWithDetails!(refinedDetails as AnyObject)
            }
        }
        else if serviceName == kServiceGetGraspIndex
        {
            if mReturningDelegate.responds(to: #selector(SSTeacherDataSourceDelegate.didGetAllGraspIndexWithDetails(_:)))
            {
                mReturningDelegate.didGetAllGraspIndexWithDetails!(refinedDetails as AnyObject)
            }
        }
        else if serviceName == kServiceBroadcastQuestion
        {
            if mReturningDelegate.responds(to: #selector(SSTeacherDataSourceDelegate.didGetQuestionSentWithDetails(_:)))
            {
                mReturningDelegate.didGetQuestionSentWithDetails!(refinedDetails as AnyObject)
            }
        }
        else if serviceName == kServiceEndQuestionInstance
        {
            if mReturningDelegate.responds(to: #selector(SSTeacherDataSourceDelegate.didGetQuestionClearedWithDetails(_:)))
            {
                mReturningDelegate.didGetQuestionClearedWithDetails!(refinedDetails as AnyObject)
            }
        }
        else if serviceName == kServiceRetrieveStudentAnswer
        {
            if mReturningDelegate.responds(to: #selector(SSTeacherDataSourceDelegate.didGetStudentsAnswerWithDetails(_:)))
            {
                mReturningDelegate.didGetStudentsAnswerWithDetails!(refinedDetails as AnyObject)
            }
        }
        else if serviceName == kServiceAgregateDrillDown
        {
            if mReturningDelegate.responds(to: #selector(SSTeacherDataSourceDelegate.didGetAgregateDrillDownWithDetails(_:)))
            {
                mReturningDelegate.didGetAgregateDrillDownWithDetails!(refinedDetails as AnyObject)
            }
        }
        else if serviceName == kServiceSendFeedback
        {
            if mReturningDelegate.responds(to: #selector(SSTeacherDataSourceDelegate.didGetFeedbackSentWithDetails(_:)))
            {
                mReturningDelegate.didGetFeedbackSentWithDetails!(refinedDetails as AnyObject)
            }
        }
        else if serviceName == kServiceGetDoubt
        {
            if mReturningDelegate.responds(to: #selector(SSTeacherDataSourceDelegate.didGetQueryWithDetails(_:)))
            {
                mReturningDelegate.didGetQueryWithDetails!(refinedDetails as AnyObject)
            }
        }
        else if serviceName == kServiceReplyToQuery
        {
            if mReturningDelegate.responds(to: #selector(SSTeacherDataSourceDelegate.didGetQueryRespondedWithDetails(_:)))
            {
                mReturningDelegate.didGetQueryRespondedWithDetails!(refinedDetails as AnyObject)
            }
        }
        else if serviceName == kServiceSaveSelectedQueries
        {
            if mReturningDelegate.responds(to: #selector(SSTeacherDataSourceDelegate.didGetSaveSelectedQueryWithDetails(_:)))
            {
                mReturningDelegate.didGetSaveSelectedQueryWithDetails!(refinedDetails as AnyObject)
            }
        }
        else if serviceName == kServiceEndVolunteeringSession
        {
            if mReturningDelegate.responds(to: #selector(SSTeacherDataSourceDelegate.didGetVolunteeringEndedWithDetails(_:)))
            {
                mReturningDelegate.didGetVolunteeringEndedWithDetails!(refinedDetails as AnyObject)
            }
        }
        else if serviceName == kServiceGetMaxStudentRegisterd
        {
            if mReturningDelegate.responds(to: #selector(SSTeacherDataSourceDelegate.didGetMaxStudentsRegistedWithDetails(_:)))
            {
                mReturningDelegate.didGetMaxStudentsRegistedWithDetails!(refinedDetails as AnyObject)
            }
        }
        else if serviceName == kServiceConfigureGrid
        {
            if mReturningDelegate.responds(to: #selector(SSTeacherDataSourceDelegate.didGetSeatsConfiguredWithDetails(_:)))
            {
                mReturningDelegate.didGetSeatsConfiguredWithDetails!(refinedDetails as AnyObject)
            }
        }
        
        else if serviceName == kServiceSaveLessonPlan
        {
            if mReturningDelegate.responds(to: #selector(SSTeacherDataSourceDelegate.didGetLessonPlanSavedWithdetails(_:)))
            {
                mReturningDelegate.didGetLessonPlanSavedWithdetails!(refinedDetails as AnyObject)
            }
        }
        else if serviceName == kuploadTeacherScribble
        {
            if mReturningDelegate.responds(to: #selector(SSTeacherDataSourceDelegate.didGetScribbleUploadedWithDetaisl(_:)))
            {
                mReturningDelegate.didGetScribbleUploadedWithDetaisl!(refinedDetails as AnyObject)
            }
        }
        else if serviceName == kRecordQuestion
        {
            if mReturningDelegate.responds(to: #selector(SSTeacherDataSourceDelegate.didGetQuestionRecordedWithDetaisl(_:)))
            {
                mReturningDelegate.didGetQuestionRecordedWithDetaisl!(refinedDetails as AnyObject)
            }
        }
        else if serviceName == kUpdateRecordedQuestion
        {
            if mReturningDelegate.responds(to:#selector(SSTeacherDataSourceDelegate.didGetQuestionRecordedUpdatedWithDetaisl(_:)))
            {
                mReturningDelegate.didGetQuestionRecordedUpdatedWithDetaisl!(refinedDetails as AnyObject)
            }
        }
        else if serviceName == kServiceGetQuestion
        {
            if mReturningDelegate.responds(to: #selector(SSTeacherDataSourceDelegate.didGetQuestionWithDetails(_:)))
            {
                mReturningDelegate.didGetQuestionWithDetails!(refinedDetails as AnyObject)
            }
        }
        else if serviceName == kGetAllModelAnswer
        {
            if mReturningDelegate.responds(to: #selector(SSTeacherDataSourceDelegate.didGetModelAnswerWithDetails(_:)))
            {
                mReturningDelegate.didGetModelAnswerWithDetails!(refinedDetails as AnyObject)
            }
        }
        else if serviceName == kRecordModelAnswer
        {
            if mReturningDelegate.responds(to: #selector(SSTeacherDataSourceDelegate.didGetModelAnswerRecordedWithDetails(_:)))
            {
                mReturningDelegate.didGetModelAnswerRecordedWithDetails!(refinedDetails as AnyObject)
            }
        }
        else if serviceName == kServiceUserLogout
        {
            if mReturningDelegate.responds(to: #selector(SSTeacherDataSourceDelegate.didGetLogOutWithDetails(_:)))
            {
                mReturningDelegate.didGetLogOutWithDetails!(refinedDetails as AnyObject)
            }
        }
        else if serviceName == kServiceFetchSRQ
        {
            if mReturningDelegate.responds(to: #selector(SSTeacherDataSourceDelegate.didGetSRQWithDetails(_:)))
            {
                mReturningDelegate.didGetSRQWithDetails!(refinedDetails as AnyObject)
            }
            
        }
        else if serviceName == kFetchCategory
        {
            if mReturningDelegate.responds(to: #selector(SSTeacherDataSourceDelegate.didGetCategoryFetchedWithDetails(_:)))
            {
                mReturningDelegate.didGetCategoryFetchedWithDetails!(refinedDetails as AnyObject)
            }
            
        }
        else if serviceName == kCreateCategory
        {
            if mReturningDelegate.responds(to: #selector(SSTeacherDataSourceDelegate.didGetCategoryCreatedWithDetails(_:)))
            {
                mReturningDelegate.didGetCategoryCreatedWithDetails!(refinedDetails as AnyObject)
            }
            
        }
        else if serviceName == kSaveSuggestionState
        {
            if mReturningDelegate.responds(to: #selector(SSTeacherDataSourceDelegate.didGetSaveSuggestionStateWithDetails(_:)))
            {
                mReturningDelegate.didGetSaveSuggestionStateWithDetails!(refinedDetails as AnyObject)
            }
            
        }
        else if serviceName == kSelectCategory
        {
            if mReturningDelegate.responds(to: #selector(SSTeacherDataSourceDelegate.didGetCategorySelectedWithDetails(_:)))
            {
                mReturningDelegate.didGetCategorySelectedWithDetails!(refinedDetails as AnyObject)
            }
            
        }
    }
    

    
    
    func delegateServiceErrorMessage(_ message: String!, withServiceName ServiceName: String!, withErrorCode code: String!, withRetruningDelegate returningDelegate: Any!)
    {
        
        
        let mReturningDelegate = returningDelegate as AnyObject
        
        if mReturningDelegate.responds(to: #selector(SSTeacherDataSourceDelegate.didgetErrorMessage(_:WithServiceName:)))
        {
            mReturningDelegate.didgetErrorMessage!(message,WithServiceName: ServiceName)
        }
        
        print("Error in API \(ServiceName)")
        
    }
    
}


extension String
{
    var parseJSONString: (jsonData:AnyObject?,error:NSError?)
    {
        let data = self.data(using: String.Encoding.utf8, allowLossyConversion: false)
        if let jsonData = data
        {
            // Will return an object or nil if JSON decoding fails
            do
            {
                let message = try JSONSerialization.jsonObject(with: jsonData, options:.mutableContainers)
                
                
                if message is NSArray
                {
                    if let jsonValue =  (message as AnyObject).firstObject as? NSDictionary
                    {
                        return (jsonValue,nil)
                    }
                    
                    return (nil,customErrors.jsonParsingError as NSError)
                }
                else
                {
                    return (message as AnyObject, nil)
                }
            }
            catch let error as NSError
            {
                return (nil,error)
            }
        }
        else
        {
            // Lossless conversion of the string was not possible
            return (nil,customErrors.jsonParsingError as NSError)
        }
    }
    
    var ParseForArrayOfJson:(arrayObjects:NSArray?,error:NSError?)
    {
        let data = self.data(using: String.Encoding.utf8, allowLossyConversion: false)
        if let jsonData = data
        {
            // Will return an object or nil if JSON decoding fails
            do
            {
                let message = try JSONSerialization.jsonObject(with: jsonData, options:.mutableContainers)
                
                
                if message is NSArray
                {
                    return (message as? NSArray,nil)
                }
                else
                {
                    return (nil,customErrors.jsonParsingError as NSError)
                }
            }
            catch let error as NSError
            {
                return (nil,error)
            }
        }
        else
        {
            // Lossless conversion of the string was not possible
            return (nil,customErrors.jsonParsingError as NSError)
        }
    }
}
