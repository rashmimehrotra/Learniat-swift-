//
//  WebServiceManager.swift
//  anITa
//
//  Created by Vinayak on 6/6/17.
//  Copyright © 2017 MBRDI. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON
import Kingfisher

protocol WebServicesManager: class {
    func getTimeoutInterval() -> TimeInterval
}

extension WebServicesManager {
    
    private func configSessionManager() -> SessionManager {
        let sessionManager =  Alamofire.SessionManager.default
        sessionManager.session.configuration.timeoutIntervalForRequest = getTimeoutInterval()
        sessionManager.session.configuration.httpShouldUsePipelining = true
        
        return sessionManager
    }
    
    private func createRequest(forPath url: String, httpMethod: HTTPMethod, details: NSDictionary?, withHeader header:NSDictionary?) -> DataRequest
    {
        
        let request = configSessionManager().request(url, method: httpMethod, parameters: details as? Parameters, encoding: JSONEncoding.default, headers: nil)
        
        ApiResponseLogging.logAPIForRequest(request: request, options: LogOption.defaultOptions)
        return request
    }
    
    func callAPI(forUrl path: String, httpMethod: HTTPMethod, details: NSDictionary?,
                 successHandler: @escaping ApiSuccessHandler,
                 failureHandler: @escaping ApiErrorHandler) {
        
        let request =  createRequest(forPath: path, httpMethod: httpMethod, details: details,withHeader: nil)

        
        request.validate().responseString { response in
             ApiResponseLogging.logResponse(request: request, response: response)
            switch response.result {
            case .success(let responseString):
                
               successHandler(responseString)
               
               break
                
            case .failure(let error):
                if (error as NSError).code == NSURLErrorNotConnectedToInternet
                {
                    failureHandler(error as NSError)
                    
                } else
                {
                    failureHandler(error as NSError)
                }
                
                break
            }
        }
    }
    
    func downloadImage(fromUrl path: String, isCaching: Bool = false, isRoundingImage: Bool = false, downloadCompletionHandler: @escaping ImageDownloaderCompletionHandler) {
        
        guard let imgOptions = getOptions(url: path, isCaching: isCaching, isRoundingImage: isRoundingImage) else {
            return
        }
        
        let url = URL(string: path)!
        ImageDownloader.default.downloadImage(with: url, options: imgOptions, completionHandler: downloadCompletionHandler)
    }
    
    func downloadAndSetImage(inImageView imageView: UIImageView, fromUrl path: String, isRounding: Bool = false) {
        guard let imgOptions = getOptions(url: path, isRoundingImage: isRounding) else {
            return
        }
        let url = URL(string: path)!
        imageView.kf.setImage(with: url, options: imgOptions)
    }
    
    private func getOptions(url: String, isCaching: Bool = false, isRoundingImage: Bool = false) ->  KingfisherOptionsInfo? {
        
        var imgOptions = KingfisherOptionsInfo()
        
        let modifier = AnyModifier { request in
            var r = request
            r.setValue("", forHTTPHeaderField: "Authorization")
            return r
        }
        imgOptions.append(.requestModifier(modifier))
        
        if isRoundingImage {
            let imgProcessor = RoundCornerImageProcessor(cornerRadius: 500)
            imgOptions.append(.processor(imgProcessor))
        }
        
        if isCaching {
            let cache = ImageCache(name: url)
            imgOptions.append(.targetCache(cache))
            imgOptions.append(.cacheOriginalImage)
        }
        
        return imgOptions
    }
    
   
    private func parseResponse(response: NSDictionary) -> (isSuccess: Bool, msg: String?) {
        if let status  =  response["status"] as? String {
            if status == "error" {
                return (false, response["msg"] as? String)
            }
        }
        return (true, nil)
    }
    
    
}


public enum customErrors: Error
{
    case RegisterationError
    case CustomErrorMessage(msg:String)

}

extension customErrors: LocalizedError
{
    public var errorDescription: String? {
        switch self
        {
        case .RegisterationError:
            return NSLocalizedString("Error ", comment: "")
            
        case .CustomErrorMessage(let message):
            return NSLocalizedString(message, comment: "")

        
        }
    }
}

