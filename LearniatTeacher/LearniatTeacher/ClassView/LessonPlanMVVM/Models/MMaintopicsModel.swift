//
//  MMaintopicsModel.swift
//  Learniat Teacher
//  Created by Deepak on 10/13/17.
//  Copyright © 2017 Mindshift. All rights reserved.
//





import Foundation
import ObjectMapper
import RealmSwift
class MMaintopicsModel: Object,Mappable {
   
    dynamic var mTopicId: Int = 0
    dynamic var mTagged : Int = 0
    dynamic var mTopicName :String = ""
    dynamic var mPercentageStarted : Int = 0
    dynamic var mPercentageTagged : Int = 0
    dynamic var mGraspIndex : CGFloat = 0
    dynamic var mTaggedSubTopicCount : Int = 0
    dynamic var mSubTopicCount  = 0
    dynamic var mCumulativeTime = ""
    
    //Impl. of Mappable protocol
    required convenience init?(map: Map) {
        self.init()
    }
    
    /// This func will set primery key for realm model
    ///
    /// - Returns: primery key name
    override static func primaryKey() -> String? {
        return "mTopicId"
    }
    
    
    /// Setting reversion mapping
    ///
    /// - Parameter map: maping values
    func mapping(map: Map) {
        mTopicId >>> map[APIKeyValues.getAllNodes.TopicId]
    }
    
    /// This func will be used to set main topic details in json model
    ///
    /// - Parameter json: mainTopic details 
    func setMainTopicWithDetails(json:[String:Any]) {
        let map = Map(mappingType: .fromJSON, JSON: json )
        if mTopicId == 0  {
            mTopicId <- map[APIKeyValues.getAllNodes.TopicId]
        }
        mTagged <- map[APIKeyValues.getAllNodes.Tagged]
        mTopicName <- map[APIKeyValues.getAllNodes.TopicName]
        mPercentageStarted <- map[APIKeyValues.getAllNodes.PercentageStarted]
        mPercentageTagged <- map[APIKeyValues.getAllNodes.PercentageTagged]
        mGraspIndex     <- map[APIKeyValues.getAllNodes.GraspIndex]
        mTaggedSubTopicCount <- map[APIKeyValues.getAllNodes.TaggedSubTopicCount]
        mTaggedSubTopicCount <- map[APIKeyValues.getAllNodes.TaggedSubTopicCount]
        mCumulativeTime <- map[APIKeyValues.getAllNodes.CumulativeTime]
    }
    
    
    
}
