//
//  SSStudentDataSource.swift
//  Learniat Teacher
//
//  Created by Deepak MK on 19/03/16.
//  Copyright © 2016 Mindshift. All rights reserved.
//

import Foundation
import UIKit
import Alamofire

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




let URLPrefix                       =   "http://54.251.104.13/Jupiter/sun.php?api="

let APP_VERSION                     =   "1.6"

let kServiceGetMyState                      =   "GetMyState"

let kServiceUserLogin                       =   "Login"

let kServiceGetThisStudentSessions          =   "GetThisStudentSessions"

let kServiceGetGridDesign                   =   "GetGridDesign"

let kServiceUserLogOut                      =   "UserLogout"

let kServiceGetSeatAssignment               =   "RetrieveSeatAssignments"

let kServiceUpdateUserStatus                =   "UpdateUserStatus"

let kServiceGetSessionInfo                  =   "GetSessionInfo"

let kServiceGetQuestion                     =   "FetchQuestion"

let kServiceSendAnswer                      =   "SendAnswer"

let kGetEntityState                         =   "GetState"

let kServiceGetGraspIndex                   =   "GetGraspIndex"

let kServiceGetPiOfStudent                  =   "GetParticipationIndex"

let kServiceGetFeedBack                     =   "GetFeedback"

let kServiceWithDraw                        =   "WithdrawStudentSubmission"

let kServiceSetDoubt						=   "SaveStudentQuery"

let kGetResponseToQuery                     =   "GetQueryResponse"

let kServiceFetchSRQ                        =   "FetchSRQ"

let kServiceVolunteerRegister               =   "VolunteerRegister"

let kServiceWithDrawQuery                   =   "WithdrawQuery"

let kRecordSuggestion                       =   "RecordSuggestion"

let kGetAllModelAnswer                      =   "GetAllModelAnswers"

let kServiceSendFeedback                    =   "SendFeedback"




@objc protocol SSStudentDataSourceDelegate
{
    @objc optional func didgetErrorMessage(_ message:String, WithServiceName serviceName:String)
    
    @objc optional func didGetUserStateWithDetails(_ details:AnyObject)
    
    @objc optional func didGetloginWithDetails(_ details: AnyObject, withError error:NSError?)
    
    @objc optional func didGetSchedulesWithDetials(_ details:AnyObject)
    
    @objc optional func didGetGridDesignWithDetails(_ details:AnyObject)
    
    @objc optional func didGetSeatAssignmentWithDetails(_ details:AnyObject)
    
    @objc optional func didGetSessionInfoWithDetials(_ details:AnyObject)
    
    @objc optional func didGetUpdatedUserStateWithDetails(_ details:AnyObject)
    
    @objc optional func didGetQuestionWithDetails(_ details:AnyObject)
    
    @objc optional func didGetAnswerSentWithDetails(_ details:AnyObject)
    
    @objc optional func didGetQuerySentWithDetails(_ detail:AnyObject)
    
    @objc optional func didGetResponseToQueryWithDetails(_ details:AnyObject)
    
    @objc optional func didGetSRQWithDetails(_ details:AnyObject)
    
    @objc optional func didGetvolunteerRegisteredWithDetails(_ details:AnyObject)
    
    @objc optional func didGetAnswerFeedBackWithDetails(_ details: AnyObject)
    
     @objc optional func didGetAllModelAnswerWithDetails(_ details:AnyObject)
    
     @objc optional func didGetRecordedSuggestionWithDetails(_ details:AnyObject)
}



class SSStudentDataSource: NSObject, APIManagerDelegate
{
     internal  static let sharedDataSource = SSStudentDataSource()
    
    
    
    var _delgate            :AnyObject!
    
    var currentUserId       :String!
    
    var currentSchoolId     :String!
    
    var currentUSerState    :UserState!
    
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
    
    var currentSubtopicID               = ""
    
    
    
    
    // MARK: - Delegate Functions
    
    func setdelegate(_ delegate:AnyObject)
    {
        _delgate = delegate;
    }
    
    func   delegate()->AnyObject
    {
        return _delgate;
    }
    
    
    
    
    func setSubTopicDictonaryWithDict(_ details:NSMutableArray,withKey key:String)
    {
        subTopicDetailsDictonary.setObject(details, forKey: key as NSCopying)
    }
    
    func setQuestionDictonaryWithDict(_ details:NSMutableArray,withKey key:String)
    {
        questionsDictonary.setObject(details, forKey: key as NSCopying)
    }
    
    // MARK: - API Functions
    
    
    func getUserState(_ userId :String, withDelegate delegate:SSStudentDataSourceDelegate)
    {
        let manager = APIManager()
        
        
        let urlString = String(format: "%@<Sunstone><Action><Service>GetMyState</Service><UserId>%@</UserId></Action></Sunstone>",URLPrefix,userId)
        print("ApiValue - \(urlString)")
        manager.downloadDataURL(urlString, withServiceName:kServiceGetMyState, withDelegate: self, with: eHTTPGetRequest , withReturningDelegate:delegate )
    }
    
    
    
    func LoginWithUserId(_ userId :String , andPassword Password:String, withDelegate delegate:SSStudentDataSourceDelegate)
    {
        
        WebServicesAPI().getRequest(fromUrl: "http://54.251.104.13:8000/login?app_id=4&user_name=\(userId)&pass=\(Password)", details: nil,
            success: { (result) in
            if (delegate as AnyObject).responds(to: #selector(SSStudentDataSourceDelegate.didGetloginWithDetails(_:withError:)))
            {
                delegate.didGetloginWithDetails!(result.parseJSONString as AnyObject,withError: nil)
            }},
            failure: { (error) in
            
            delegate.didGetloginWithDetails!(NSMutableDictionary(),withError:error)
        })
    }
    
    func  updateStudentStatus(_ status:String, ofSession sessionId:String, withDelegate  delegate:SSStudentDataSourceDelegate)
    {

        currentUSerState = UserState(rawValue: status)
        
        let manager = APIManager()
        
        let urlString = String(format: "%@<Sunstone><Action><Service>UpdateUserState</Service><UserId>%@</UserId><StatusId>%@</StatusId><SessionId>%@</SessionId></Action></Sunstone>",URLPrefix,currentUserId,status,sessionId)
        print("ApiValue - \(urlString)")
        manager.downloadDataURL(urlString, withServiceName: kServiceUpdateUserStatus, withDelegate: self, with: eHTTPGetRequest, withReturningDelegate: delegate)
        
    }
    
    
    
    func getScheduleOfTheDay(_ delegate:SSStudentDataSourceDelegate)
    {
       
      
//        urlString = urlString.encodeUrl()
//        
//        
//        
//        WebServicesAPI().getRequest(fromUrl: urlString, details: nil, success: { (result) in
//          print(result)
//        }) { (error) in
//            print(error)
//        }
        
        let manager = APIManager()
        
         let urlString = String(format: "%@<Sunstone><Action><Service>GetThisStudentSessions</Service><UserId>%@</UserId></Action></Sunstone>",URLPrefix,currentUserId)
        print("ApiValue - \(urlString)")
        manager.downloadDataURL(urlString, withServiceName: kServiceGetThisStudentSessions, withDelegate: self, with: eHTTPGetRequest, withReturningDelegate: delegate)
    }
    
    
   
    func getGridDesignDetails(_ roomId :String, WithDelegate delegate:SSStudentDataSourceDelegate)
    {
        
        let manager = APIManager()
        
        let urlString = String(format: "%@<Sunstone><Action><Service>RetrieveGridDesign</Service><RoomId>%@</RoomId></Action></Sunstone>",URLPrefix,roomId)
        print("ApiValue - \(urlString)")
        manager.downloadDataURL(urlString, withServiceName: kServiceGetGridDesign, withDelegate: self, with: eHTTPGetRequest,withReturningDelegate: delegate)
        
    }
    
    
    func getSeatAssignmentofSession(_ sessionId:String,  withDelegate delegate:SSStudentDataSourceDelegate)
    {
        
        let manager = APIManager()
        
        let urlString = String(format: "%@<Sunstone><Action><Service>RetrieveSeatAssignments</Service><SessionId>%@</SessionId></Action></Sunstone>",URLPrefix,sessionId)
        print("ApiValue - \(urlString)")
        manager.downloadDataURL(urlString, withServiceName: kServiceGetSeatAssignment, withDelegate: self, with: eHTTPGetRequest,withReturningDelegate: delegate)
    }
    
    
    
    
    
    func getUserSessionWithDetails(_ sessionId:String,  withDelegate delegate:SSStudentDataSourceDelegate)
    {
        
        let manager = APIManager()
        
        let urlString = String(format: "%@<Sunstone><Action><Service>GetSessionInfo</Service><SessionId>%@</SessionId></Action></Sunstone>",URLPrefix,sessionId)
        print("ApiValue - \(urlString)")
        manager.downloadDataURL(urlString, withServiceName: kServiceGetSessionInfo, withDelegate: self, with: eHTTPGetRequest,withReturningDelegate: delegate)
    }
    

    
    
    
    func updateStudentAnswerScoreWithAssessmentAnswerId(_ assessmentId:String,withRating ratings:String, WithDelegate delegate:SSStudentDataSourceDelegate)
    {
        
        
        let manager = APIManager()
        
        let urlString = String(format: "%@<Sunstone><Action><Service>SendFeedback</Service><AssessmentAnswerIdList>%@</AssessmentAnswerIdList><TeacherId>%@</TeacherId><Rating>%@</Rating><StudentId>%@</StudentId><ModelAnswerFlag>0</ModelAnswerFlag></Action></Sunstone>",URLPrefix,assessmentId,currentTeacherId,ratings,currentUserId)
        print("ApiValue - \(urlString)")
        manager.downloadDataURL(urlString, withServiceName: kServiceSendFeedback, withDelegate: self, with: eHTTPGetRequest, withReturningDelegate: delegate)
    }
    
    
    
    
    
    
    
    
    
    
    
    
    func fetchQuestionWithQuestionLogId(_ questionLogId:String, WithDelegate delegate:SSStudentDataSourceDelegate)
    {
        let manager = APIManager()
        
        let urlString = String(format: "%@<Sunstone><Action><Service>FetchQuestion</Service><QuestionLogId>%@</QuestionLogId></Action></Sunstone>",URLPrefix,questionLogId)
        print("ApiValue - \(urlString)")
        manager.downloadDataURL(urlString, withServiceName: kServiceGetQuestion, withDelegate: self, with: eHTTPGetRequest, withReturningDelegate: delegate)
    }

    
    func sendObjectvieAnswer(_ optionsList:String,withQuestionType questionType:String, withQuestionLogId questionLogId:String, withsessionId currentSessionId:String, withDelegate delegate:SSStudentDataSourceDelegate)
    {
        
        
        let manager = APIManager()
        
        let urlString = String(format: "%@<Sunstone><Action><Service>SendAnswer</Service><StudentId>%@</StudentId><OptionText>%@</OptionText><SessionId>%@</SessionId><QuestionLogId>%@</QuestionLogId><QuestionType>%@</QuestionType></Action></Sunstone>",URLPrefix,currentUserId, optionsList,currentSessionId, questionLogId, questionType )
        print("ApiValue - \(urlString)")
        manager.downloadDataURL(urlString, withServiceName: kServiceSendAnswer, withDelegate: self, with: eHTTPGetRequest,withReturningDelegate:delegate)
    }
    
    func sendScribbleAnswer(_ ImagePath:String,withQuestionType questionType:String, withQuestionLogId questionLogId:String, withsessionId currentSessionId:String, withDelegate delegate:SSStudentDataSourceDelegate)
    {
        
        
        let manager = APIManager()
        
        let urlString = String(format: "%@<Sunstone><Action><Service>SendAnswer</Service><StudentId>%@</StudentId><ImagePath>%@</ImagePath><SessionId>%@</SessionId><QuestionLogId>%@</QuestionLogId><QuestionType>%@</QuestionType></Action></Sunstone>",URLPrefix,currentUserId, ImagePath,currentSessionId, questionLogId, questionType )
        print("ApiValue - \(urlString)")
        manager.downloadDataURL(urlString, withServiceName: kServiceSendAnswer, withDelegate: self, with: eHTTPGetRequest,withReturningDelegate:delegate)
    }
    
    
    func sendTextAnswer(_ TextReply:String,withQuestionType questionType:String, withQuestionLogId questionLogId:String, withsessionId currentSessionId:String, withDelegate delegate:SSStudentDataSourceDelegate)
    {
        
        
        let manager = APIManager()
        
        let urlString = String(format: "%@<Sunstone><Action><Service>SendAnswer</Service><StudentId>%@</StudentId><TextAnswer>%@</TextAnswer><SessionId>%@</SessionId><QuestionLogId>%@</QuestionLogId><QuestionType>%@</QuestionType></Action></Sunstone>",URLPrefix,currentUserId, TextReply,currentSessionId, questionLogId, questionType )
        print("ApiValue - \(urlString)")
        manager.downloadDataURL(urlString, withServiceName: kServiceSendAnswer, withDelegate: self, with: eHTTPGetRequest,withReturningDelegate:delegate)
    }
 
    
    
    
    func sendMTCAnswer(_ sequenceList:String,withQuestionType questionType:String, withQuestionLogId questionLogId:String, withsessionId currentSessionId:String, withDelegate delegate:SSStudentDataSourceDelegate)
    {
        
        
        
        let manager = APIManager()
        
        let urlString = String(format: "%@<Sunstone><Action><Service>SendAnswer</Service><StudentId>%@</StudentId><Sequence>%@</Sequence><SessionId>%@</SessionId><QuestionLogId>%@</QuestionLogId><QuestionType>%@</QuestionType></Action></Sunstone>",URLPrefix,currentUserId, sequenceList,currentSessionId, questionLogId, questionType )
        print("ApiValue - \(urlString)")
        manager.downloadDataURL(urlString, withServiceName: kServiceSendAnswer, withDelegate: self, with: eHTTPGetRequest,withReturningDelegate:delegate)
    }
    
    
    func sendQueryWithQueryText(_ queryText:String,withAnonymous isAnonymous:String,withDelegate delegate:SSStudentDataSourceDelegate)
    {
        let manager = APIManager()
        
        
        
        let urlString = String(format: "%@<Sunstone><Action><Service>SaveStudentQuery</Service><StudentId>%@</StudentId><SessionId>%@</SessionId><QueryText>%@</QueryText><Anonymous>%@</Anonymous></Action></Sunstone>",URLPrefix,currentUserId,currentLiveSessionId,queryText,isAnonymous)
        print("ApiValue - \(urlString)")
        manager.downloadDataURL(urlString, withServiceName: kServiceSetDoubt, withDelegate: self, with: eHTTPGetRequest, withReturningDelegate: delegate)
    }
    
    func getDoubtReplyForDoutId(_ doubtId:String, withDelegate delegate:SSStudentDataSourceDelegate)
    {
        
        
        let manager = APIManager()
        
        let urlString = String(format: "%@<Sunstone><Action><Service>GetQueryResponse</Service><QueryId>%@</QueryId></Action></Sunstone>",URLPrefix,doubtId)
        print("ApiValue - \(urlString)")
        manager.downloadDataURL(urlString, withServiceName: kGetResponseToQuery, withDelegate: self, with: eHTTPGetRequest, withReturningDelegate: delegate)
    }
    
    func GetSRQWithSessionId(_ sessionId:String, withDelegate delegate:SSStudentDataSourceDelegate)
    {
        
        
        let manager = APIManager()
        
        let urlString = String(format: "%@<Sunstone><Action><Service>FetchSRQ</Service><SessionId>%@</SessionId></Action></Sunstone>",URLPrefix,sessionId)
        print("ApiValue - \(urlString)")
        manager.downloadDataURL(urlString, withServiceName: kServiceFetchSRQ, withDelegate: self, with: eHTTPGetRequest, withReturningDelegate: delegate)
    }
    
    
    func volunteerRegisterwithQueryId(_ doubtId:String, withDelegate delegate:SSStudentDataSourceDelegate)
    {
        
        
        let manager = APIManager()
        
        let urlString = String(format: "%@<Sunstone><Action><Service>VolunteerRegister</Service><StudentId>%@</StudentId><QueryId>%@</QueryId></Action></Sunstone>",URLPrefix,self.currentUserId,doubtId)
        print("ApiValue - \(urlString)")
        manager.downloadDataURL(urlString, withServiceName: kServiceVolunteerRegister, withDelegate: self, with: eHTTPGetRequest , withReturningDelegate: delegate)
    }
    
    func getFeedbackFromTeacherForAssesment(_ assesmentId:String, withDelegate delegate:SSStudentDataSourceDelegate)
    {
        
        setdelegate(delegate)
        
        let manager = APIManager()
        
        let urlString = String(format: "%@<Sunstone><Action><Service>GetFeedback</Service><AssessmentAnswerId>%@</AssessmentAnswerId></Action></Sunstone>",URLPrefix,assesmentId)
        print("ApiValue - \(urlString)")
        manager.downloadDataURL(urlString, withServiceName: kServiceGetFeedBack, withDelegate: self, with: eHTTPGetRequest, withReturningDelegate: delegate)
    }

    func getModelAnswerFromTeacherForQuestionLogId(_ QuestionLogId:String, withDelegate delegate:SSStudentDataSourceDelegate)
    {
        setdelegate(delegate)
        
        let manager = APIManager()
        
        let urlString = String(format: "%@<Sunstone><Action><Service>GetAllModelAnswers</Service><QuestionLogId>%@</QuestionLogId></Action></Sunstone>",URLPrefix,QuestionLogId)
        print("ApiValue - \(urlString)")
        manager.downloadDataURL(urlString, withServiceName: kGetAllModelAnswer, withDelegate: self, with: eHTTPGetRequest,
                                withReturningDelegate: delegate)
    }
    
    func withDrawQueryWithQueryId(_ queryId:String, withDelegate delegate:SSStudentDataSourceDelegate)
    {
        
        setdelegate(delegate)
        
        let manager = APIManager()
        
        let urlString = String(format: "%@<Sunstone><Action><Service>WithdrawStudentSubmission</Service><QueryId>%@</QueryId></Action></Sunstone>",URLPrefix,queryId)
        print("ApiValue - \(urlString)")
        manager.downloadDataURL(urlString, withServiceName: kServiceWithDrawQuery, withDelegate: self, with: eHTTPGetRequest,withReturningDelegate: delegate)
    }
    
    func recordSuggestionWithSuggestionText(_ Suggestion:String,withCategoryId CategoryID:String,withTopicId topicId:String, withDelegate delegate:SSStudentDataSourceDelegate)
    {
        setdelegate(delegate)
        
        
        
        let uuidString:String = UIDevice.current.identifierForVendor!.uuidString
        
        let manager = APIManager()
        
        let urlString = String(format: "%@<Sunstone><Action><Service>RecordSuggestion</Service><StudentId>%@</StudentId><SuggestTxt>%@</SuggestTxt><CategoryId>%@</CategoryId><SessionId>%@</SessionId><TopicId>%@</TopicId><DeviceId>%@</DeviceId><UUID>%@</UUID></Action></Sunstone>",URLPrefix,currentUserId,Suggestion,CategoryID,currentLiveSessionId,topicId,uuidString,uuidString)
        print("ApiValue - \(urlString)")
        manager.downloadDataURL(urlString, withServiceName: kRecordSuggestion, withDelegate: self, with: eHTTPGetRequest,withReturningDelegate: delegate)
    }
    
    
    
    // MARK: - API Delegate Functions
    func delegateDidGetServiceResponse(withDetails dict: NSMutableDictionary!, wIthServiceName serviceName: String!, withRetruningDelegate returningDelegate: Any!) {
        
        let refinedDetails = (dict.object(forKey: kSunstone)! as AnyObject).object(forKey: kSSAction)!
        
        let mReturningDelegate = returningDelegate as AnyObject
        
        
        if serviceName == kServiceGetMyState
        {
            if mReturningDelegate.responds(to: #selector(SSStudentDataSourceDelegate.didGetUserStateWithDetails(_:)))
            {
                mReturningDelegate.didGetUserStateWithDetails!(refinedDetails as AnyObject)
            }
            
        }
        else if serviceName == kServiceUserLogin
        {
            if mReturningDelegate.responds(to: #selector(SSStudentDataSourceDelegate.didGetloginWithDetails(_:withError:)))
            {
                mReturningDelegate.didGetloginWithDetails!(refinedDetails as AnyObject,withError: nil)
                
            }

        }
        else if serviceName == kServiceGetThisStudentSessions
        {
            if mReturningDelegate.responds(to: #selector(SSStudentDataSourceDelegate.didGetSchedulesWithDetials(_:)))
            {
                mReturningDelegate.didGetSchedulesWithDetials!(refinedDetails as AnyObject)
            }
        }
        else if serviceName == kServiceGetGridDesign
        {
            if mReturningDelegate.responds(to: #selector(SSStudentDataSourceDelegate.didGetGridDesignWithDetails(_:)))
            {
                mReturningDelegate.didGetGridDesignWithDetails!(refinedDetails as AnyObject)
            }
        }
        else if serviceName == kServiceGetSeatAssignment
        {
            if mReturningDelegate.responds(to: #selector(SSStudentDataSourceDelegate.didGetSeatAssignmentWithDetails(_:)))
            {
                mReturningDelegate.didGetSeatAssignmentWithDetails!(refinedDetails as AnyObject)
            }
        }
        else if serviceName == kServiceGetSessionInfo
        {
            
            if mReturningDelegate.responds(to: #selector(SSStudentDataSourceDelegate.didGetSessionInfoWithDetials(_:)))
            {
                mReturningDelegate.didGetSessionInfoWithDetials!(refinedDetails as AnyObject)
            }
        }
        else if serviceName == kServiceUpdateUserStatus
        {
            if mReturningDelegate.responds(to: #selector(SSStudentDataSourceDelegate.didGetUpdatedUserStateWithDetails(_:)))
            {
                mReturningDelegate.didGetUpdatedUserStateWithDetails!(refinedDetails as AnyObject)
            }
        }
        else if serviceName == kServiceGetQuestion
        {
            if mReturningDelegate.responds(to: #selector(SSStudentDataSourceDelegate.didGetQuestionWithDetails(_:)))
            {
                mReturningDelegate.didGetQuestionWithDetails!(refinedDetails as AnyObject)
            }
        }
        else if serviceName == kServiceSendAnswer
        {
            if mReturningDelegate.responds(to: #selector(SSStudentDataSourceDelegate.didGetAnswerSentWithDetails(_:)))
            {
                mReturningDelegate.didGetAnswerSentWithDetails!(refinedDetails as AnyObject)
            }
            
        }
        else if serviceName == kServiceSetDoubt
        {
            if mReturningDelegate.responds(to: #selector(SSStudentDataSourceDelegate.didGetQuerySentWithDetails(_:)))
            {
                mReturningDelegate.didGetQuerySentWithDetails!(refinedDetails as AnyObject)
            }
            
        }
        else if serviceName == kGetResponseToQuery
        {
            
            if mReturningDelegate.responds(to: #selector(SSStudentDataSourceDelegate.didGetResponseToQueryWithDetails(_:)))
            {
                mReturningDelegate.didGetResponseToQueryWithDetails!(refinedDetails as AnyObject)
            }
            
        }
        else if serviceName == kServiceFetchSRQ
        {
            
            if mReturningDelegate.responds(to: #selector(SSStudentDataSourceDelegate.didGetSRQWithDetails(_:)))
            {
                mReturningDelegate.didGetSRQWithDetails!(refinedDetails as AnyObject)
            }
            
        }
        else if serviceName == kServiceVolunteerRegister
        {
            
            if mReturningDelegate.responds(to: #selector(SSStudentDataSourceDelegate.didGetvolunteerRegisteredWithDetails(_:)))
            {
                mReturningDelegate.didGetvolunteerRegisteredWithDetails!(refinedDetails as AnyObject)
            }
            
        }
        else if serviceName == kServiceGetFeedBack
        {
            
            if delegate().responds(to: #selector(SSStudentDataSourceDelegate.didGetAnswerFeedBackWithDetails(_:)))
            {
                mReturningDelegate.didGetAnswerFeedBackWithDetails!(refinedDetails as AnyObject)
            }
            
        }
        else if serviceName == kGetAllModelAnswer
        {
            if delegate().responds(to: #selector(SSStudentDataSourceDelegate.didGetAllModelAnswerWithDetails(_:)))
            {
                mReturningDelegate.didGetAllModelAnswerWithDetails!(refinedDetails as AnyObject)
            }
            
            
        }
        
        else if serviceName == kRecordSuggestion
        {
            if delegate().responds(to: #selector(SSStudentDataSourceDelegate.didGetRecordedSuggestionWithDetails(_:)))
            {
                mReturningDelegate.didGetRecordedSuggestionWithDetails!(refinedDetails as AnyObject)
            }
            
            
        }
    }
    
    
    
    
    
    
    func delegateServiceErrorMessage(_ message: String!, withServiceName ServiceName: String!, withErrorCode code: String!, withRetruningDelegate returningDelegate: Any!) {
        
        let mReturningDelegate = returningDelegate as AnyObject
        
        if mReturningDelegate.responds(to: #selector(SSStudentDataSourceDelegate.didgetErrorMessage(_:WithServiceName:)))
        {
            mReturningDelegate.didgetErrorMessage!(message,WithServiceName: ServiceName)
        }
        
        print("Error in API \(ServiceName)")
        
    }
    
}

extension user: URLConvertible
{
    
    static let baseURLString = "http://54.251.104.13/Jupiter/sun.php?api="
    
    public func asURL() throws -> URL
    {
        let urlString = user.baseURLString
        return try urlString.asURL()
    }
    
    
    func getScheudelSummary(sufix:String) -> URL
    {
        
        let urlString = user.baseURLString + sufix
        return  try! urlString.asURL()
    }
    
    
    
}

extension String
{
    func encodeUrl() -> String
    {
        return self.addingPercentEncoding( withAllowedCharacters: NSCharacterSet.urlQueryAllowed)!
    }
    func decodeUrl() -> String
    {
        return self.removingPercentEncoding!
    }
    
}

extension String
{
    var parseJSONString: AnyObject?
    {
        let data = self.data(using: String.Encoding.utf8, allowLossyConversion: false)
        if let jsonData = data
        {
            // Will return an object or nil if JSON decoding fails
            do
            {
                let message = try JSONSerialization.jsonObject(with: jsonData, options:.mutableContainers)
                
                
                var jsonValue = NSDictionary()
                if message is NSArray
                {
                    jsonValue = (message as AnyObject).firstObject as! NSDictionary
                    return jsonValue
                }
                else
                {
                    return message as AnyObject
                }
            }
            catch let error as NSError
            {
                print("An error occurred: \(error)")
                return nil
            }
        }
        else
        {
            // Lossless conversion of the string was not possible
            return nil
        }
    }
}
