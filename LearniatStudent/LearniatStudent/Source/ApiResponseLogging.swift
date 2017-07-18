//
//  ApiResponseLogging.swift
//  anITa
//
//  Created by administrator on 5/31/17.
//  Copyright © 2017 MBRDI. All rights reserved.
//

import Foundation
import Alamofire
private let nullString = "(null)"
let separatorString = "*********************************************************************************************"

/**
 A struct that put together the relevant info from a Response
 */
public struct ResponseInfo {
    public var httpResponse: HTTPURLResponse?
    public var data: Data?
    public var error: Error?
    public var elapsedTime: TimeInterval
}

public enum LogOption {
    case onlyDebug
    case jsonPrettyPrint
    case includeSeparator
    
    static var defaultOptions: [LogOption] {
        return [.onlyDebug, .jsonPrettyPrint, .includeSeparator]
    }
}

enum ApiType {
    case requestFromClient
    case responseFromServer
    
    
    public var ApiTypeValue: String?
    {
        switch self {
        case .requestFromClient:
            return "Request"
        case .responseFromServer:
            return "Response"
        }
    }
}


class ApiResponseLogging: NSObject
{
    
    static func logAPIForRequest(request: DataRequest, options: [LogOption])
    {
        
            let method = request.request?.httpMethod
            let url = request.request?.url?.absoluteString ?? ""
            let headers = prettyPrintedString(from: request.request?.allHTTPHeaderFields) ?? ""
            let body = string(from: request.request?.httpBody, prettyPrint: true) ?? ""

        
        
        
//            print("\n\n\(separatorString) \n Request \(String(describing: method)) \n'\(url)':\n\n[Headers]\n\(String(describing: headers))\n\n[Body]\n\(body)\n\(separatorString)")
        
       
    }
    
    static func logResponse(request: DataRequest?, response: DataResponse<String>?)
    {
        
        
        
        let options   = [LogOption]()
        
        let httpResponse = response?.response
        let data = response?.data
        let elapsedTime = response?.timeline.requestDuration
        let error = response?.error
        
        if request == nil && response?.response == nil {
            return
        }
        
        // options
        let prettyPrint = options.contains(.includeSeparator)
        
        // request
        let requestMethod = response?.request?.httpMethod ?? nullString
        let requestUrl = response?.request?.url?.absoluteString ?? nullString
        
        // response
        let responseStatusCode = httpResponse?.statusCode ?? 0
        let responseHeaders = prettyPrintedString(from: httpResponse?.allHeaderFields) ?? nullString
        let responseData = string(from: data, prettyPrint: prettyPrint) ?? nullString
        
        // time
        let elapsedTimeString = String(format: "[%.4f s]", elapsedTime!)
        
        
        // log
        let success = (error == nil)
        let responseTitle = success ? "Response" : "Response Error"
        
        
        
        
//        print("\n\n\n\n\(separatorString)\n\(responseTitle) Method: \(requestMethod) \nStatus:\(responseStatusCode) '\(requestUrl)' \(elapsedTimeString):\n\n[Headers]:\n\(responseHeaders)\n\n[Body]\n\(responseData )\(separatorString)")
        
      

    }
   
    
    
     static func prettyPrintedString(from json: Any?) -> String? {
        guard let json = json else {
            return nil
        }
        
        var response: String? = nil
        
        if let data = try? JSONSerialization.data(withJSONObject: json, options: .prettyPrinted),
            let dataString = String.init(data: data, encoding: .utf8) {
            response = dataString
        }
        
        return response
    }
    
    
    // MARK: - Private helpers
    private static func string(from data: Data?, prettyPrint: Bool) -> String? {
        
        guard let data = data else {
            return nil
        }
        
        var response: String? = nil
        
        if
            let json = try? JSONSerialization.jsonObject(with: data, options: []),
            let prettyString = prettyPrintedString(from: json) {
            response = prettyString
        }
        else if let dataString = String.init(data: data, encoding: .utf8) {
            response = dataString
        }
        
        return response
    }
    
    
}


class AlamoFireManager
{
    static func manager()->SessionManager
    {
        let manager = Alamofire.SessionManager.default
        manager.session.configuration.timeoutIntervalForRequest = 120
        manager.session.configuration.httpShouldUsePipelining = true

        return manager
    }
}
