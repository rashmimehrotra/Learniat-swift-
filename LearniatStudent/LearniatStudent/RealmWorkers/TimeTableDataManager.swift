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


class TimeTableDataManager: NSObject {
    override init() {  }
    
    func saveTimeTableDataWithJsonData(timeTableArray:NSArray) {
        var sessionModel : TimeTableModel!
        do {
            try RealmManager.shared.realm.write({
                for index in 0..<timeTableArray.count {
                    let userValue = timeTableArray.object(at: index) as AnyObject
                    if let session = RealmManager.shared.realm.object(ofType: TimeTableModel.self, forPrimaryKey: userValue[RAPIConstants.SessionID.rawValue]) {
                        sessionModel = session
                    } else {
                        sessionModel = TimeTableModel()
                        sessionModel.setTimeTableModelWithJsonData(json: userValue as! [String : Any])
                    }
                    sessionModel.updateTimeTableModelWithJsonData(json: userValue as! [String : Any])
                    RealmManager.shared.realm.create(TimeTableModel.self, value: sessionModel as Any, update: true)
                }
                
                SSStudentDataSource.sharedDataSource.TimeTableSaveSignal.fire(true)
                
            })
        } catch {
            
        }
    }
}

extension TimeTableDataManager {
    
    /// Returns all the `TimeTableModel` objects from Realm. Return list will not include past events.
    ///
    /// - Parameter completion: Closure
    func getTodaySchedules()->[TimeTableModel]{
        var mTimeTableModel = [TimeTableModel]()
        let objects = RealmManager.shared.realm.objects(TimeTableModel.self)
        for timeTableObject in Array(objects) {
            let dateFormatter: DateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            let datecomponents = dateFormatter.date(from: timeTableObject.StartTime!)
            let now = Date()
            if (datecomponents?.toShortDateString() == now.toShortDateString()) {
                mTimeTableModel.append(timeTableObject)
            }
        }
        return mTimeTableModel
    }
}


