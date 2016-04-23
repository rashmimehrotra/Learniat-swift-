//
//  File.swift
//  Learniat_Student_Iphone
//
//  Created by mindshift_Deepak on 28/01/16.
//  Copyright © 2016 mindShiftApps. All rights reserved.
//


//Student Keys

let kBenchcode                  = "SeatLabel"
let kBenchState                 = "BenchState"

let kTimeExtended          =   "180"
let kSeatingChanged        =   "195"
let kTeacherEndsSession    =   "706"
let kQuestionLabel         =   "170"
let kAllowVoiting          =   "173"
let kLiveClassRoomName      =   "723"
let kTeacherQnASubmitted    =   "231"
let kStudentSentBenchState  =   "220"
let kTeacherQnADone         =   "233"
let kStudentSendAnswer      =   "321"
let kDontKnow               =   "710"
let kTeacherQnAFreeze       =   "232"
let kSharegraph             =   "190"
let kTeacherHandRaiseInReview   = "223"
let kStudentQnAAccept           = "217"
let kSendFeedBack               = "701"
let kWithDrawSubmission         = "707"
let kStudentDoubtSubmission		= "215"
let kReplyToQuery               = "708"
let kQueryStartedForVolunteer   = "703"
let keToo                      = "175"
let kIVolunteer                 = "176"
let kEndVolunteeringSession     = "187"
let kTeacherReviewDoubt         = "702"
let kDoubtWithDrawn             = "177"
let kQueryAnswering             = "182"
let kQueryCloseVoting           = "185"
let kVolunteerMeeToLikeAndDislike = "717"
let kVolunteerIVolunteerLikeNDislike = "718"
let kTeacherReplayForVolunteer      = "186"
let kGiveMeAnswertoStudent          = "181"
let kSendPollMessageToStudents      = "719"
let kSendSelectedPollToTeacher      = "720"
let kSendPollStoppedToStudent       = "721"
let kCollaborationPing              = "713"
let kCollaborationOption            = "714"
let kCloseCollaboration             = "715"
let kodelAnswerDetails             = "179"
let kMuteStudent                    = "712"




import Foundation

@objc protocol SSStudentMessageHandlerDelegate
{
    optional func smhDidRecieveStreamConnectionsState(state:Bool)
    
    optional  func smhDidReciveAuthenticationState(state:Bool, WithName userName:String)
    
    optional  func smhStreamReconnectingWithDelay(delay:Int32)
    
    optional  func smhDidcreateRoomWithRoomName(roomName:String)
    
    
    
    
    optional  func smhDidgetTimeExtendedWithDetails(Details:AnyObject)
    
    optional  func smhDidGetSeatingChangedWithDetails(details:AnyObject)
    
    
    
}

public class SSStudentMessageHandler:NSObject,SSStudentMessageHandlerDelegate,MessageManagerDelegate {
    
    var _delgate: AnyObject!
    var currentUserName:String!
   
    
   public  static let sharedMessageHandler = SSStudentMessageHandler()
    
    
    
  let kBaseXMPPURL	=	NSUserDefaults.standardUserDefaults().objectForKey(k_INI_BaseXMPPURL) as! String
    
    
    // MARK: - Delegate Functions

    func setdelegate(delegate:AnyObject)
    {
        _delgate = delegate;
    }
    
    func   delegate()->AnyObject
    {
        return _delgate;
    }
    
    
    // MARK: - Stream Setup
    
    func setUpMessangerStream()
    {
        
        MessageManager.sharedMessageHandler().setdelegate(self)
        MessageManager.sharedMessageHandler().setupStream()
    }
    
    //MARK: - Registration Function
    
    func registerStudentWithUserName(userName:String , withPassword password:String, withEmailId EmailId:String)
    {
        guard userName.characters.count>0 || password.characters.count>0 || EmailId.characters.count>0  else
        {
            return
        }

         MessageManager.sharedMessageHandler().setdelegate(self)
        MessageManager.sharedMessageHandler().registerStudentWithUserName(userName, withPassword: password, withEmailId: EmailId)
    }

    //MARK: - ..........Delegate
    func didGetRegistrationState (state: Bool,withErrorMessage errorMessage:String )
    {

    }
    

   
    
    
    //MARK: - Login
    /*- this function is called to connect to XMPP Server -*/
    func connectWithUserId(userID:String, andWithPassword password:String, withDelegate delegate:SSStudentMessageHandlerDelegate)
    {
        guard userID.characters.count>0 || password.characters.count>0  else
        {
            return
        }
        
        setdelegate(delegate)
        
        MessageManager.sharedMessageHandler().setdelegate(self)
        
        MessageManager.sharedMessageHandler().connectWithUserId("\(userID)@\(kBaseXMPPURL)", withPassword: password)
    }
    
    
    func authenticateUserithUserId(userId:String ,withPassword passowrd:String)
    {
    
        guard userId.characters.count>0 || passowrd.characters.count>0 else
        {
            return
        }
        currentUserName=userId;
        MessageManager.sharedMessageHandler().setdelegate(self)
        MessageManager.sharedMessageHandler().authenticateUserWIthUSerName("\(userId)@\(kBaseXMPPURL)", withPassword: passowrd)
    
    }
    
    func perFormLogout()
    {
        MessageManager.sharedMessageHandler().disconnect()
        
    }
   
    func getXmppConnectionStatus()->Bool
    {
        
        
        return  MessageManager.sharedMessageHandler().xmppStream.isConnected()
    }
    
    func getCurrentUSerName()->String
    {
    
        return MessageManager.sharedMessageHandler().xmppStream.myJID.bare();
    }
    
    //MARK: ..........Delegate
    public func didGetStreamState(state:Bool)
    {
        if delegate().respondsToSelector(#selector(SSStudentMessageHandlerDelegate.smhDidRecieveStreamConnectionsState(_:)))
        {
            delegate().smhDidRecieveStreamConnectionsState!(state)
        }
        

    }
    public func didGetAuthenticationState(state:Bool)
    {
         if delegate().respondsToSelector(#selector(SSStudentMessageHandlerDelegate.smhDidReciveAuthenticationState(_:WithName:)))
         {
            delegate().smhDidReciveAuthenticationState!(state, WithName: getCurrentUSerName())
        }
    }
    
    
    public func didReconnectingWithDelaytime(delayTime: Int32) {
        if delegate().respondsToSelector(#selector(SSStudentMessageHandlerDelegate.smhStreamReconnectingWithDelay(_:)))
        {
            delegate().smhStreamReconnectingWithDelay!(delayTime)
        }
    }
    
    
    //MARK: Create and join Room
    
    func createRoomWithRoomName(roomName: String!, withHistory history:String!)
    {
        MessageManager.sharedMessageHandler().setdelegate(self)
        MessageManager.sharedMessageHandler().setUpRoom(roomName, withAdminPrivilage: true, withHistoryValue: history)
    }
    
    
    
    public func didCreatedOrJoinedRoomWithCreatedRoomName(_roomName: String!)
    {
        if delegate().respondsToSelector(#selector(SSStudentMessageHandlerDelegate.smhDidcreateRoomWithRoomName(_:)))
        {
            delegate().smhDidcreateRoomWithRoomName!(_roomName)
        }
        
    }
    
    
    
    func didGetUserJoinedToRoomORLeaveRoomWithName(_userName: String!, withPresence presence: String!)
    {
        
       
    }
    
    
    func checkAndRemoveJoinedRoomsArrayWithRoomid(roomId:String)
    {
        MessageManager.sharedMessageHandler().removeIfRoomPresentWithRoomId(roomId)
    }
    
    
    func sendInviteToRoomWithUserName(userName:String)
    {
      
    }
    
    //MARK: chat Messages
//    func sendAllowVotingToStudents(studentId :String , withValue votingState:String, withSubTopicName subTopicName:String , withSubtopicID subTopicId:String)
//    {
//        if(MessageManager.sharedMessageHandler().xmppStream.isConnected() == true)
//        {
//            let userId           = SSStudentDataSource.sharedDataSource.currentUserId
//            let msgType             = kAllowVoiting
//            
//            
//            let messageBody = ["VotingValue":votingState,"SubTopicName":subTopicName, "SubTopicId":subTopicId]
//            
//            
//            
//            let details:NSMutableDictionary = ["From":userId,
//                "To":studentId,
//                "Type":msgType,
//                "Body":messageBody];
//            
//            
//            
//            let msg = SSMessage()
//            msg.setMsgDetails( details)
//            
//            let xmlBody:String = msg.XMLMessage()
//            
//            MessageManager.sharedMessageHandler().sendMessageTo("\(studentId)@\(kBaseXMPPURL)", withContents: xmlBody)
//        }
//    }
//   
    
    //MARK: Group   Messages
//    func sendExtendedTimetoRoom(roomId:String, withClassName className:String, withStartTime StartTime:String, withDelayTime timeDelay:String)
//    {
//        if(MessageManager.sharedMessageHandler().xmppStream.isConnected() == true)
//        {
//            
//            
//            let _roomId = "room_\(roomId)@conference.\(kBaseXMPPURL)";
//            
//            let userId           = SSStudentDataSource.sharedDataSource.currentUserId
//            let msgType             = kTimeExtended
//            
//            
//              let messageBody = ["timedelay":timeDelay ,
//                                "ClassName":className,
//                                "stratTime":StartTime]
//            
//            
//            
//            let details:NSMutableDictionary = ["From":userId,
//                "To":_roomId,
//                "Type":msgType,
//                "Body":messageBody];
//            
//            
//            
//            let msg = SSMessage()
//            msg.setMsgDetails( details)
//            
//            let xmlBody:String = msg.XMLMessage()
//            
//            MessageManager.sharedMessageHandler().sendGroupMessageWithBody(xmlBody, withRoomId: _roomId)
//        }
//    }
    
    
   
    
    //MARK: Recieve Message
    public func didReceiveMessageWithBody(body: String!)
    {
        
        let message = SSMessage.init(XMLString: body)
        
        
        if message.messageType() == nil
        {
            return
        }
        
        
        
        switch ( message.messageType())
        {
            case kTimeExtended:
                if delegate().respondsToSelector(#selector(SSStudentMessageHandlerDelegate.smhDidgetTimeExtendedWithDetails))
                {
                    delegate().smhDidgetTimeExtendedWithDetails!(message.messageBody())
                }
                break
                
            case kSeatingChanged:
                if delegate().respondsToSelector(#selector(SSStudentMessageHandlerDelegate.smhDidGetSeatingChangedWithDetails))
                {
                    delegate().smhDidGetSeatingChangedWithDetails!(message.messageBody())
                }
                break

            
        default:
            break
            
        }
    }
}



