//
//  MLessonPlanMainTopicsViewModel.swift
//  Learniat Teacher
//
//  Created by Deepak on 10/13/17.
//  Copyright © 2017 Mindshift. All rights reserved.
//

import Foundation
import RxSwift
class MLessonPlanMainTopicsViewModel: NSObject {

    var mMaintopicsArray = Variable(NSArray())
    func LoadmainTopics() {
        SSTeacherDataSource.sharedDataSource.getAllNodesWithClassId(helperValue: GetAllNodesAPIHelper()) { isSuccess, response, error in
                if isSuccess == true {
                    if  let mainTopicsArray:NSArray = response?.object(forKey: APIKeyValues.getAllNodes.MainTopic) as? NSArray {
                        self.mMaintopicsArray.value = mainTopicsArray
                    }
            }
        }
    }
}
