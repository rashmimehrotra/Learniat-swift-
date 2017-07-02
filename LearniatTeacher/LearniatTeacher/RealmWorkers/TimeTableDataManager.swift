//
//  TimeTableDataManager.swift
//  LearniatStudent
//
//  Created by Deepak on 7/1/17.
//  Copyright © 2017 administrator. All rights reserved.
//

import Foundation
import ObjectMapper
import RealmSwift


class TimeTableDataManager: NSObject
{
    override init() {  }
    
    
    func saveTimeTableDataWithJsonData(userValue:AnyObject)
    {
        
        var sessionModel : TimeTableModel!
        
        do {
            try RealmManager.shared.realm.write({
                if let session = RealmManager.shared.realm.object(ofType: TimeTableModel.self, forPrimaryKey: userValue[kSessionId])
                {
                    sessionModel = session
                }
                else
                {
                    sessionModel = TimeTableModel()
                }
                
                
                sessionModel.setTimeTableModelWithJsonData(json: userValue as! [String : Any])
                RealmManager.shared.realm.create(TimeTableModel.self, value: sessionModel as Any, update: true)
            })
        } catch
        {
            
        }
    }
    
}

extension TimeTableDataManager {
    
    /// Returns all the `TimeTableModel` objects from Realm. Return list will not include past events.
    ///
    /// - Parameter completion: Closure
    func getTodaySchedules(completion: @escaping (_ eventsList: [TimeTableModel]?) -> ())
    {
        DispatchQueue.main.async {
            let list = RealmManager.shared.realm.objects(TimeTableModel.self)
            
            //TODO: need to remove all expired events from realm.
            
            let events = list.count > 0 ? Array(list) : nil
            completion(events)
        }
    }
}


