//
//  Enumerations.swift
//  LearniatStudent
//
//  Created by Deepak MK on 30/06/17.
//  Copyright © 2017 Mindshift. All rights reserved.
//

import Foundation

enum UserState:String
{
    case Live           =  "1"
    case BackGround     =  "11"
    case Free           =  "7"
    case SignedOut      =  "8"
    case Occupied       =  "10"
 
}

enum SessionState:Int
{
    case Live           = 1
    case Scheduled      = 4
    case Ended          = 5
    case Cancelled      = 6
    case Opened         = 2
}


enum UserStateInt:Int
{
    case Live           =  1
    case BackGround     =  11
    case Free           =  7
    case SignedOut      =  8
    case Occupied       =  10
    case Preallocated   =  9
    
}


enum folderType
{
    case proFilePics
    case studentAnswer
    case questionImage
    case badgesImages
}


