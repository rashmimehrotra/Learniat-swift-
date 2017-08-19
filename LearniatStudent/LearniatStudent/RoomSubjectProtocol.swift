//
//  RoomSubjectProtocol.swift
//  LearniatTeacher
//
//  Created by Sourabh on 14/08/17.
//  Copyright © 2017 Mindshift. All rights reserved.
//

import Foundation
protocol RoomSubjectProtocol {
    func setRoomSubject(json:String)
    func getRoomSubject() -> String
    func getRoomUrl() -> String
    
}
