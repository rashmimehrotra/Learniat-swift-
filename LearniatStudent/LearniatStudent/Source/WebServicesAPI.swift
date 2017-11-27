//
//  WebServicesAPI.swift
//  Learniat Teacher
//
//  Created by Deepak MK on 19/03/16.
//  Copyright © 2016 Mindshift. All rights reserved.
//

import Foundation
import Alamofire

typealias ApiSuccessStringHandler = (_ result: String) -> ()
typealias ApiSuccessHandler = (_ result: AnyObject) -> ()
typealias ApiErrorHandler = (_ error:NSError) -> ()

class WebServicesAPI: NSObject, WebServicesManager {
    
    private var timeoutInterval: TimeInterval!
    
    init(timeout: TimeInterval? = 120) {
        super.init()
        timeoutInterval = timeout
    }
    
    func getRequest(fromUrl path: String, details: NSDictionary?, success: @escaping ApiSuccessStringHandler,
                   failure: @escaping ApiErrorHandler) {
        print("ApiValue - \(path)")
        callAPI(forUrl: path, httpMethod: HTTPMethod.get, details: details, successHandler: success, failureHandler: failure)
    }
    
    func postRequest(toUrl path: String, details: NSDictionary, isWritingToWebSocket: Bool = false, success: @escaping ApiSuccessStringHandler, failure: @escaping ApiErrorHandler) {
        print("ApiValue - \(path)")
        callAPI(forUrl: path, httpMethod: HTTPMethod.post, details: details, successHandler: success, failureHandler: failure)
    }
    
    
    //MARK: - WebServicesManager
    func getTimeoutInterval() -> TimeInterval {
        return timeoutInterval
    }
}




