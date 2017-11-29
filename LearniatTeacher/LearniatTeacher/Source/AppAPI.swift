//
//  AppAPI.swift
//  anITa
//
//  Created by Deepak MK on 24/04/17.
//  Copyright © 2017 MBRDI. All rights reserved.
//

import Foundation
import Alamofire

enum AppAPI {

    case Login(UserName:String,Password:String)
    case TodaysTimeTable(UserId:String)
    case InsertScribbleFileName(userId:String,FileName:String)
    case ChangeSessionState(userId: String, state:String,SessionID:String)
    case RefresAppWithUserId(userId:String)
    case GetJoinedStudentsWithUserId(UserId:String, sessionID:String)
    case TopicCompleted(topicId:String, sessionid:String,UserId:String)
    case TopicCompletedRemoveOptions(topicId:String, sessionid:String,UserId:String)
    case RemoveModelAnswer(UserId:String, assesmentId:String, modelAnswerFlag:String)
}

extension AppAPI {
    
    public var parameterEncoding: ParameterEncoding {
        return JSONEncoding.default
    }
    
   /*
    public var task: Task {
        return .request
    }
 */
    
    var base: String
    {
        
        return  Config.sharedInstance.baseUrl()

    }
    
    
    var path: String {
        switch self {
            
        case .Login(let username, let password):
            return "\(self.base)/Login?app_id=3&user_name=\(username)&pass=\(password)"
            
        case .TodaysTimeTable(let userID):
            return "\(self.base)/GetMyTodaysSessions?user_id=\(userID)"
            
        case .InsertScribbleFileName(let userId, let FileName):
            return "\(self.base)/InsertScribbleFileName?user_id=\(userId)&filename=\(FileName)"
            
        case .ChangeSessionState(let userId, let state, let SessionID):
            return  "\(self.base)/ChangeSessionState?userid=\(userId)&SessionId=\(SessionID)&NewState=\(state)"
            
        case .RefresAppWithUserId(let userId):
            return "\(self.base)/RefreshMyApp?userid=\(userId)"
        case .GetJoinedStudentsWithUserId(let userID, let sessionID):
            return "\(self.base)/RefreshJoinedStudents?user=\(userID)&session=\(sessionID)"
            
        case .TopicCompleted(let topicId, let sessionid, let UserId):
            return "\(self.base)/MarkTopicCompleted?userid=\(UserId)&sessionid=\(sessionid)&topicid=\(topicId)"
            
        case .TopicCompletedRemoveOptions(let topicId, let sessionid, let UserId):
            return "\(self.base)/MarkTopicCompleted?userid=\(UserId)&sessionid=\(sessionid)&topicid=\(topicId)&remove=T"
            
        case .RemoveModelAnswer(let UserId, let assesmentId, let modelAnswerFlag):
            return "\(self.base)/SetModel?userid=\(UserId)&asses_id=\(assesmentId)&model_flag=\(modelAnswerFlag)"
            
        }
    }
    /*
    var method: Moya.Method {
        switch self {
        case .appVersion,
             .getProfile:
            return .get
        default:
            return .post
        }
    }
    
 */
    
    // MARK: - Provider support
    func stubbedResponse(_ filename: String) -> Data! {
        @objc class TestClass: NSObject { }
        
        let bundle = Bundle(for: TestClass.self)
        let path = bundle.path(forResource: filename, ofType: "json")
        return (try? Data(contentsOf: URL(fileURLWithPath: path!)))
    }
    
    /*
    func url(_ route: TargetType) -> String {
        return route.baseURL.appendingPathComponent(route.path).absoluteString
    }
 */
}


