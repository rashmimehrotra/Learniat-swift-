//
//  APIKeyValues.swift
//  Learniat Teacher
//
//  Created by Deepak on 10/16/17.
//  Copyright © 2017 Mindshift. All rights reserved.
//
import Foundation

/// This Class will give all the key parameters of API
struct APIKeyValues {
    static let getAllNodes = GetAllNodes()
}

struct GetAllNodes {
    let MainTopic = "MainTopics"
    let Tagged      = "Tagged"
    let TopicId     = "Id"
    let TopicName   = "Name"
    let PercentageStarted   = "PercentageStarted"
    let PercentageTagged    = "PercentageTagged"
    let GraspIndex          = "GraspIndex"
    let TaggedSubTopicCount = "TaggedSubTopicCount"
    let SubTopicCount       = "SubTopicCount"
    let CumulativeTime      = "CumulativeTime"
}
