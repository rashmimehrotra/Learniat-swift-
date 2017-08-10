//
//  TimeTableTileViewModel.swift
//  LearniatStudent
//
//  Created by Deepak on 8/9/17.
//  Copyright © 2017 Mindshift. All rights reserved.
//

import Foundation
class TimeTableTileViewModel: NSObject {
    
    var borderColor = UIColor()
    var backgroundColor = UIColor()
    var circleImageColor = UIColor()
    
    func updateSesstionState(sessionState:SessionState) {
        switch sessionState
        {
        case .Scheduled:
            backgroundColor = scheduledColor
            borderColor = scheduledBorderColor
            circleImageColor = scheduledBorderColor
            break
        case .Opened:
            self.backgroundColor = OpenedColor
            borderColor = OpenedBorderColor
            circleImageColor = OpenedBorderColor
            break
        case .Live:
            self.backgroundColor = LiveColor
            borderColor = LiveColor
            circleImageColor = UIColor.white
            break
        case .Cancelled:
            borderColor = CancelledBorderColor
            backgroundColor = CancelledBorderColor
            circleImageColor = CancelledBorderColor
            break
        case .Ended:
            self.backgroundColor = EndedColor
            self.borderColor = EndedColor
            circleImageColor = EndedColor
            break
        }
    }
    
    func tappedOnSessionWithState(state:Int)->(isAbleToSendJson:Bool, message:String) {
        switch state {
        case SessionState.Live.rawValue:
            return (true, "")
        case SessionState.Opened.rawValue:
            return (true, "")
        case SessionState.Ended.rawValue:
            return (false, "This class has already ended.")
        case SessionState.Cancelled.rawValue:
            return (false, "This class was cancelled.")
        case SessionState.Scheduled.rawValue:
            return (false, "You cannot enter a scheduled class session")
        default:
            return (false, "You cannot enter a this class session")
        }
    }
}
