//
//  GetAllNodesAPIHelper.swift
//  Learniat Teacher
//
//  Created by Deepak on 10/16/17.
//  Copyright © 2017 Mindshift. All rights reserved.
//

import Foundation
enum TopicType:String {
    case onlyMainTopics   = "Only MainTopics"
    case onlySubTopics    = "Only SubTopics"
    case onlyQuestions    = "Only Questions"
}
struct GetAllNodesAPIHelper {
    var classId = ""
    var subjectId   = ""
    var topicId     = ""
    var topicType  :TopicType  = .onlyMainTopics
}
