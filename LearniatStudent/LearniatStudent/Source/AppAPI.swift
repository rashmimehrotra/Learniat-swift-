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
    case GetSessionInfo(SessionId:String)
    case RefresAppWithUserId(userId:String)
    case updateUserState(userId:String,State:Int)
    
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
            return "\(self.base)/Login?app_id=4&user_name=\(username)&pass=\(password)"
            
        case .TodaysTimeTable(let userID):
            return "\(self.base)/GetMyTodaysSessions?user=\(userID)"
        
        case .InsertScribbleFileName(let userId, let FileName):
            return "\(self.base)/InsertScribbleFileName?user_id=\(userId)&filename=\(FileName)"
            
        case .GetSessionInfo(let SessionId):
            return  "\(self.base)/GetSessionInfo?SessionId=\(SessionId)"
            
        case .RefresAppWithUserId(let userId):
            return "\(self.base)/RefreshMyApp?userid=\(userId)"
        case .updateUserState(let userId , let State):
            return "\(self.base)/UpdateMyState?user=\(userId)&state=\(State)"
        
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


