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
    case ChangeSessionState(state:String,SessionID:String)
    case RefresAppWithUserId(userId:String)
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
            
        case .ChangeSessionState(let state, let SessionID):
            return  "\(self.base)/ChangeSessionState?SessionId=\(SessionID)&NewState=\(state)"
            
        case .RefresAppWithUserId(let userId):
            return "\(self.base)/RefreshMyApp?userid=\(userId)"
            
            
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


