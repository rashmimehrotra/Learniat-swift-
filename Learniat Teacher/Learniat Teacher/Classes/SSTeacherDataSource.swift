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



@objc protocol SSTeacherDataSourceDelegate
{
    optional func didgetErrorMessage(message:String, WithServiceName serviceName:String)
    
    optional func didGetUserStateWithDetails(details:AnyObject)
    
    optional func didGetloginWithDetails(details:AnyObject)
    
    optional func didGetSchedulesWithDetials(details:AnyObject)
    
    optional func didGetMycurrentSessionWithDetials(details:AnyObject)
    
    optional func didGetSessionUpdatedWithDetials(details:AnyObject)
    
    
}



class SSTeacherDataSource: NSObject, APIManagerDelegate
{
     internal  static let sharedDataSource = SSTeacherDataSource()
    
    
    
    var _delgate            :AnyObject!
    
    var currentUserId       :String!
    
    var currentSchoolId     :String!
    
    var currentUSerState    :String!
    
    var currentUserName     :String     = String()
    
    var currentPassword     :String     = String()
    
    
    
    // MARK: - Delegate Functions
    
    func setdelegate(delegate:AnyObject)
    {
        _delgate = delegate;
    }
    
    func   delegate()->AnyObject
    {
        return _delgate;
    }
    
    // MARK: - API Functions
    
    
    func getUserState(userId :String, withDelegate Delegate:SSTeacherDataSourceDelegate)
    {
        setdelegate(Delegate)
        let manager = APIManager()
        
        
        let urlString = String(format: "%@<Sunstone><Action><Service>GetMyState</Service><UserId>%@</UserId></Action></Sunstone>",URLPrefix,userId)
        
        manager.downloadDataURL(urlString, withServiceName:kServiceGetMyState, withDelegate: self, withRequestType: eHTTPGetRequest)
    }
    
    
    
    func LoginWithUserId(userId :String , andPassword Password:String, withDelegate Delegate:SSTeacherDataSourceDelegate)
    {
        setdelegate(Delegate)
        
        
        let manager = APIManager()
        let uuidString:String = UIDevice.currentDevice().identifierForVendor!.UUIDString
        
        let urlString = String(format: "%@<Sunstone><Action><Service>Login</Service><UserName>%@</UserName><UserPassword>%@</UserPassword><AppVersion>%@</AppVersion><DeviceId>%@</DeviceId><IsTeacher>1</IsTeacher></Action></Sunstone>",URLPrefix,userId, Password,APP_VERSION,uuidString)
        
        manager.downloadDataURL(urlString, withServiceName:kServiceUserLogin, withDelegate: self, withRequestType: eHTTPGetRequest)
    }

    
    
    func getScheduleOfTeacher(Delegate:SSTeacherDataSourceDelegate)
    {
        setdelegate(Delegate)
        
        let manager = APIManager()
        
        let urlString = String(format: "%@<Sunstone><Action><Service>GetMyTodaysSessions</Service><UserId>%@</UserId></Action></Sunstone>",URLPrefix,currentUserId)
        
        manager.downloadDataURL(urlString, withServiceName: kServiceGetSchedules, withDelegate: self, withRequestType: eHTTPGetRequest)
    }
    
    
    func getMyCurrentSessionOfTeacher(Delegate:SSTeacherDataSourceDelegate)
    {
        setdelegate(Delegate)
        
        let manager = APIManager()
        
        let urlString = String(format: "%@<Sunstone><Action><Service>GetMyCurrentSession</Service><UserId>%@</UserId></Action></Sunstone>",URLPrefix,currentUserId)
        
        manager.downloadDataURL(urlString, withServiceName: kServiceGetMyCurrentSession, withDelegate: self, withRequestType: eHTTPGetRequest)
    }
    
    
    func updateSessionStateWithSessionId(sessionId:String,WithStatusvalue Status:String, WithDelegate Delegate:SSTeacherDataSourceDelegate)
    {
        setdelegate(Delegate)
        
        let manager = APIManager()
        
        let urlString = String(format: "%@<Sunstone><Action><Service>UpdateSessionState</Service><SessionId>%@</SessionId><StatusId>%@</StatusId></Action></Sunstone>",URLPrefix,sessionId,Status)
        
        manager.downloadDataURL(urlString, withServiceName: kServiceUpdateSessionState, withDelegate: self, withRequestType: eHTTPGetRequest)
    }

    
    
    // MARK: - API Delegate Functions
    func delegateDidGetServiceResponseWithDetails( dict: NSMutableDictionary!, WIthServiceName serviceName: String!)
    {
        
        let refinedDetails = dict.objectForKey(kSunstone)!.objectForKey(kSSAction)!
        if serviceName == kServiceGetMyState
        {
            if delegate().respondsToSelector(Selector("didGetUserStateWithDetails:"))
            {
                delegate().didGetUserStateWithDetails!(refinedDetails)
            }
            
        }
        else if serviceName == kServiceUserLogin
        {
            if delegate().respondsToSelector(Selector("didGetloginWithDetails:"))
            {
                delegate().didGetloginWithDetails!(refinedDetails)
            }
        }
        else if serviceName == kServiceGetSchedules
        {
            if delegate().respondsToSelector(Selector("didGetSchedulesWithDetials:"))
            {
                delegate().didGetSchedulesWithDetials!(refinedDetails)
            }
        }
        else if serviceName == kServiceGetMyCurrentSession
        {
            if delegate().respondsToSelector(Selector("didGetMycurrentSessionWithDetials:"))
            {
                delegate().didGetMycurrentSessionWithDetials!(refinedDetails)
            }
        }
        else if serviceName == kServiceUpdateSessionState
        {
            if delegate().respondsToSelector(Selector("didGetSessionUpdatedWithDetials:"))
            {
                delegate().didGetSessionUpdatedWithDetials!(refinedDetails)
            }
        }
    
    }
    func delegateServiceErrorMessage(message: String!, withServiceName ServiceName: String!, withErrorCode code: String!) {
    
        
        if delegate().respondsToSelector(Selector("didgetErrorMessage:WithServiceName:"))
        {
            delegate().didgetErrorMessage!(message,WithServiceName: ServiceName)
        }
        
        print("Error in API \(ServiceName)")
        
    }
    
}