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
let kMeToo                      = "175"
let kIVolunteer                 = "176"
let kEndVolunteeringSession     = "187"
let kTeacherReviewDoubt         = "702"
let kDoubtWithDrawn             = "177"
let kQueryAnswering             = "182"
let kQueryCloseVoting           = "185"
let kVolunteerVoteSent          = "717"
let kVolunteerIVolunteerLikeNDislike = "718"
let kTeacherReplayForVolunteer      = "186"
let kGiveMeAnswertoStudent          = "181"
let kSendPollMessageToStudents      = "719"
let kSendSelectedPollToTeacher      = "720"
let kSendPollStoppedToStudent       = "721"
let kCollaborationPing              = "713"
let kCollaborationOption            = "714"
let kCloseCollaboration             = "715"
let kModelAnswerDetails             = "179"
let kMuteStudent                    = "712"

let kGetPeakView                    = "704"
let kSendPeakView                   = "705"
let kQueryUnderstood                = "1102"
let kSendSingleString               = "1101"
let kTeacherQuizSubmitted           = "1103"
let kCollaborationCancelled         = "1104"
let kCollaborationStatusChanged     = "1105"
let kTakeOver = "2001"
let kTakeOverTime = "2002"


import Foundation
import Signals

@objc protocol SSTeacherMessagehandlerDelegate
{
    @objc optional func smhDidRecieveStreamConnectionsState(_ state:Bool)
    
    @objc optional  func smhDidReciveAuthenticationState(_ state:Bool, WithName userName:String)
    
    @objc optional  func smhStreamReconnectingWithDelay(_ delay:Int32)
    
    @objc optional  func smhDidcreateRoomWithRoomName(_ roomName:String)
    
    
    
    
    @objc optional  func smhDidgetStudentBentchStateWithStudentId(_ studentId:String, withState state:String)
    
    @objc optional  func smhDidgetStudentQuestionAccepetedMessageWithStudentId(_ StudentId: String)
    
    @objc optional  func smhDidgetStudentAnswerMessageWithStudentId(_ StudentId: String, withAnswerString answerStrin:String)
    
    @objc optional func smhDidGetstudentSubmissionWithDrawn(_ StudentId:String)
    
   
    @objc optional func smhDidgetStudentDontKnowMessageRecieved(_ StudentId:String)
    
    @objc optional func smhDidgetStudentQueryWithDetails(_ queryId:String)
    
    @objc optional func smhDidgetQueryWithdrawnWithDetails(_ queryId:String, withStudentId studentId:String)
    
    @objc optional func smhDidgetStudentPollWithDetails(optionValue:NSMutableDictionary)
    
    @objc optional func smhDidgetMeTooValueWithDetails(_ details:AnyObject)
    
    @objc optional func smhDidgetVolunteerValueWithDetails(_ details:AnyObject)
    
    @objc optional func smhDidgetVoteFromStudentWithStudentId(_ StudentId:String, withVote newVote:String)
    
     @objc optional func smhDidgetUnderstoodMessageWithDetails(_ details: AnyObject, withStudentId StudentId:String)
    
    @objc optional func smhDidgetPeakViewWithDetails(_ details:AnyObject, withStudentId studentId:String)
    
    @objc optional func smhDidgetOneStringAnswerWithDetails(_ details:AnyObject, withStudentId studentId:String)
    
    @objc optional func smhDidgetCollaborationSuggestion(_ details:AnyObject)
    
}

open class SSTeacherMessageHandler:NSObject,SSTeacherMessagehandlerDelegate,MessageManagerDelegate {
    
    var _delgate: AnyObject!
    var currentUserName:String!
    var connectType:String = "Login"
    var retryConnectTime:Int64 = 0
    var currentAppState:String = "Active"
   
    let Error_NotConnectedToInternetSignal = Signal<(Bool)>()
    var kBaseXMPPURL	=	""
    
    open  static let sharedMessageHandler :SSTeacherMessageHandler = {
        
        
        let instance = SSTeacherMessageHandler()
        
        return instance
    }()
    
    
    
  
    
    
    // MARK: - Delegate Functions

    func setdelegate(_ delegate:AnyObject)
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
    
    func registerStudentWithUserName(_ userName:String , withPassword password:String, withEmailId EmailId:String)
    {
        guard userName.characters.count>0 || password.characters.count>0 || EmailId.characters.count>0  else
        {
            return
        }

         MessageManager.sharedMessageHandler().setdelegate(self)
        MessageManager.sharedMessageHandler().registerStudent(withUserName: userName, withPassword: password, withEmailId: EmailId)
    }

    //MARK: - ..........Delegate
    public func didGetRegistrationState (_ state: Bool,withErrorMessage errorMessage:String )
    {

    }
    

   
    
    
    //MARK: - Login
    /*- this function is called to connect to XMPP Server -*/
    func connectWithUserId(_ userID:String, andWithPassword password:String, withDelegate delegate:SSTeacherMessagehandlerDelegate)
    {
        SSTeacherMessageHandler.sharedMessageHandler.connectType = "Login"
        if let baseXmppUrl = UserDefaults.standard.object(forKey: k_INI_BaseXMPPURL) as? String
        {
            kBaseXMPPURL = baseXmppUrl
        }
        
        guard userID.characters.count>0 || password.characters.count>0  else
        {
            return
        }
        
        setdelegate(delegate)
        
        MessageManager.sharedMessageHandler().setdelegate(self)
        
        MessageManager.sharedMessageHandler().connect(withUserId: "\(userID)@\(kBaseXMPPURL)", withPassword: password)
    }
    
    
    func authenticateUserithUserId(_ userId:String ,withPassword passowrd:String)
    {
    
        guard userId.characters.count>0 || passowrd.characters.count>0 else
        {
            return
        }
        currentUserName=userId;
        MessageManager.sharedMessageHandler().setdelegate(self)
        MessageManager.sharedMessageHandler().authenticateUserWIthUSerName("\(userId)@\(kBaseXMPPURL)", withPassword: passowrd)
    
    }
    
    func goOffline()
    {
        MessageManager.sharedMessageHandler().goOffline()
    }
    
    func perFormLogout()
    {
        MessageManager.sharedMessageHandler().disconnect()
        
    }
    
    func performReconnet(connectType: String)
    {
        SSTeacherMessageHandler.sharedMessageHandler.connectType = connectType
        
        if let password  =  UserDefaults.standard.object(forKey: kPassword) as? String
        {
            let connectionUrl = SSTeacherDataSource.sharedDataSource.currentUserId.appending("@").appending(kBaseXMPPURL)
            MessageManager.sharedMessageHandler().connect(withUserId: connectionUrl, withPassword: password)
        }
       
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
    open func didGetStreamState(_ state:Bool)
    {
        if state {
            self.Error_NotConnectedToInternetSignal.fire( true)
        }else{
            self.Error_NotConnectedToInternetSignal.fire(false)
        }
        

    }
    open func didGetAuthenticationState(_ state:Bool)
    {
        
        if state {
            if connectType == "Login"{
                MessageManager.sharedMessageHandler().goActive()
                currentAppState = "Active"
                MessageManager.sharedMessageHandler().goOnline()
            }
            else if connectType == "Retry"{
                MessageManager.sharedMessageHandler().goRetryActive()
                currentAppState = "Retry Active"
                retryConnectTime = Int64(Date().timeIntervalSince1970 * 1000)
                MessageManager.sharedMessageHandler().goOnline()
            }
            else if connectType == "Reconnect"{
                MessageManager.sharedMessageHandler().goActive()
                currentAppState = "Active"
                MessageManager.sharedMessageHandler().goOnline()
            }
        }

         if delegate().responds(to: #selector(SSTeacherMessagehandlerDelegate.smhDidReciveAuthenticationState(_:WithName:)))
         {
            delegate().smhDidReciveAuthenticationState!(state, WithName: getCurrentUSerName())
        }
    }
    
    
    open func didReconnecting(withDelaytime delayTime: Int32) {
        if delegate().responds(to: #selector(SSTeacherMessagehandlerDelegate.smhStreamReconnectingWithDelay(_:)))
        {
            delegate().smhStreamReconnectingWithDelay!(delayTime)
        }
    }
    
    
    open func gotOnline() {
        refreshApp()
    }
    
    open func didRecievePresenceSelf(_ state: String!, withUserName userName: String!, withSubState subState: String!, withSenderJid senderJid: XMPPJID!) {
        
        let myJid:XMPPJID = MessageManager.sharedMessageHandler().xmppStream.myJID;
        if myJid.resource != senderJid.resource{
            if state == "active"{
                AppDelegate.appState = "TakenOver"
                MessageManager.sharedMessageHandler().disconnect()
            }
            if state == "retry-active"{
                if currentAppState == "Active"{
                    let details:NSMutableDictionary = ["From":myJid.user,
                                                       "To":senderJid.user,
                                                       "Type":kTakeOver];
                    let msg = SSMessage()
                    msg.setMsgDetails( details)
                    let xmlBody:String = msg.xmlMessage()
                    MessageManager.sharedMessageHandler().sendMessage(to: senderJid.bare(), withContents: xmlBody)
                }
                else if currentAppState == "Retry Active"{
                    let details:NSMutableDictionary = ["From":myJid.user,
                                                       "To":senderJid.user,
                                                       "Type":kTakeOverTime,
                                                       "Body":retryConnectTime];
                    let msg = SSMessage()
                    msg.setMsgDetails( details)
                    let xmlBody:String = msg.xmlMessage()
                    MessageManager.sharedMessageHandler().sendMessage(to: senderJid.bare(), withContents: xmlBody)
                    
                }
            }
        }
    }

    
    
    //MARK: Create and join Room
    
    func createRoomWithRoomName(_ roomName: String!, withHistory history:String!)
    {
        MessageManager.sharedMessageHandler().setdelegate(self)
        MessageManager.sharedMessageHandler().setUpRoom(roomName, withAdminPrivilage: true, withHistoryValue: history)
    }
    
    
    func destroyRoom(_ roomName: String!){
        MessageManager.sharedMessageHandler().destroyRoom(roomName)
        MessageManager.sharedMessageHandler().destroyRoom(roomName)

    }
    
    
    open func didCreatedOrJoinedRoom(withCreatedRoomName _roomName: String!)
    {
        if delegate().responds(to: #selector(SSTeacherMessagehandlerDelegate.smhDidcreateRoomWithRoomName(_:)))
        {
            delegate().smhDidcreateRoomWithRoomName!(_roomName)
        }
        
    }
    
    
    
    func didGetUserJoinedToRoomORLeaveRoomWithName(_ _userName: String!, withPresence presence: String!)
    {
        
       
    }
    
    
    func checkAndRemoveJoinedRoomsArrayWithRoomid(_ roomId:String)
    {
        MessageManager.sharedMessageHandler().removeIfRoomPresent(withRoomId: roomId)
    }
    
    
    func sendInviteToRoomWithUserName(_ userName:String)
    {
      
    }
    
    //MARK: chat Messages
    func sendAllowVotingToStudents(_ studentId :String , withValue votingState:String, withSubTopicName subTopicName:String , withSubtopicID subTopicId:String)
    {
        if(MessageManager.sharedMessageHandler().xmppStream.isConnected() == true)
        {
            let userId           = SSTeacherDataSource.sharedDataSource.currentUserId
            let msgType             = kAllowVoiting
            
            
            let messageBody = ["VotingValue":votingState,"SubTopicName":subTopicName, "SubTopicId":subTopicId]
            
            
            
            let details:NSMutableDictionary = ["From":userId!,
                "To":studentId,
                "Type":msgType,
                "Body":messageBody];
            
            
            
            let msg = SSMessage()
            msg.setMsgDetails( details)
            
            let xmlBody:String = msg.xmlMessage()
            
            MessageManager.sharedMessageHandler().sendMessage(to: "\(studentId)@\(kBaseXMPPURL)", withContents: xmlBody)
        }
    }
    func sendLiveClassRoomName( _ roomId :String , withQuestionLogId studentId:String, withQuestionType QuestionType:String)
    {
        if(MessageManager.sharedMessageHandler().xmppStream.isConnected() == true)
        {
            let userId           = SSTeacherDataSource.sharedDataSource.currentUserId
            let msgType             = kLiveClassRoomName
            
            
            let messageBody = ["CreatedRoomName":roomId, "QuestionType":QuestionType]
            
            
            
            let details:NSMutableDictionary = ["From":userId!,
                "To":studentId,
                "Type":msgType,
                "Body":messageBody];
            
            
            
            let msg = SSMessage()
            msg.setMsgDetails( details)
            
            let xmlBody:String = msg.xmlMessage()
            
            MessageManager.sharedMessageHandler().sendMessage(to: "\(studentId)@\(kBaseXMPPURL)", withContents: xmlBody)
        }
    }
    
    
    
    func sendHandRaiseReceivedMessageToStudentWithId(_ studentId :String)
    {
        if(MessageManager.sharedMessageHandler().xmppStream.isConnected() == true)
        {
            
            
            
            let userId           = SSTeacherDataSource.sharedDataSource.currentUserId
            let msgType             = kTeacherHandRaiseInReview
            
            
            let details:NSMutableDictionary = ["From":userId!,
                "To":studentId,
                "Type":msgType];
            
            
            
            let msg = SSMessage()
            msg.setMsgDetails( details)
            
            let xmlBody:String = msg.xmlMessage()
            
           MessageManager.sharedMessageHandler().sendMessage(to: "\(studentId)@\(kBaseXMPPURL)", withContents: xmlBody)
        }
    }
    
    
    
    func sendFeedbackToStudentWitId( _ studentId :String , withassesmentAnswerId assesmentAnswerId:String)
    {
        if(MessageManager.sharedMessageHandler().xmppStream.isConnected() == true)
        {
            let userId           = SSTeacherDataSource.sharedDataSource.currentUserId
            let msgType             = kSendFeedBack
            
            
            let messageBody = ["AssesmentAnswerId":assesmentAnswerId]
            
            
            
            let details:NSMutableDictionary = ["From":userId!,
                "To":studentId,
                "Type":msgType,
                "Body":messageBody];
            
            
            
            let msg = SSMessage()
            msg.setMsgDetails( details)
            
            let xmlBody:String = msg.xmlMessage()
            
            MessageManager.sharedMessageHandler().sendMessage(to: "\(studentId)@\(kBaseXMPPURL)", withContents: xmlBody)
        }
    }
    
    
    
    
    func sendQueryFeedbackToStudentWitId(_ studentId :String , withQueryId QueryId:String)
    {
        if(MessageManager.sharedMessageHandler().xmppStream.isConnected() == true)
        {
            let userId    = SSTeacherDataSource.sharedDataSource.currentUserId
            let msgType   = kReplyToQuery
            
            
            let messageBody = ["QueryId":QueryId]
            
            
            
            let details:NSMutableDictionary = ["From":userId!,
                "To":studentId,
                "Type":msgType,
                "Body":messageBody];
            
            
            
            let msg = SSMessage()
            msg.setMsgDetails( details)
            
            let xmlBody:String = msg.xmlMessage()
            
            MessageManager.sharedMessageHandler().sendMessage(to: "\(studentId)@\(kBaseXMPPURL)", withContents: xmlBody)
        }
    }
    
    
    func sendMuteMessageToStudentWithStudentId(_ studentId :String , withStatus Status:String)
    {
        if(MessageManager.sharedMessageHandler().xmppStream.isConnected() == true)
        {
            let userId    = SSTeacherDataSource.sharedDataSource.currentUserId
            let msgType   = kMuteStudent
            
            
            let messageBody = ["MUTESTATUS":Status]
            
            
            
            let details:NSMutableDictionary = ["From":userId!,
                "To":studentId,
                "Type":msgType,
                "Body":messageBody];
            
            
            
            let msg = SSMessage()
            msg.setMsgDetails( details)
            
            let xmlBody:String = msg.xmlMessage()
            
            MessageManager.sharedMessageHandler().sendMessage(to: "\(studentId)@\(kBaseXMPPURL)", withContents: xmlBody)
        }
    }
    
    func sendPeakViewMessageToStudentWithId(_ studentId :String)
    {
        if(MessageManager.sharedMessageHandler().xmppStream.isConnected() == true)
        {
            
            
            
            let userId           = SSTeacherDataSource.sharedDataSource.currentUserId
            let msgType             = kGetPeakView
            
            
            let details:NSMutableDictionary = ["From":userId!,
                                               "To":studentId,
                                               "Type":msgType];
            
            
            
            let msg = SSMessage()
            msg.setMsgDetails( details)
            
            let xmlBody:String = msg.xmlMessage()
            
            MessageManager.sharedMessageHandler().sendMessage(to: "\(studentId)@\(kBaseXMPPURL)", withContents: xmlBody)
        }
    }
    
    
    func sendCollaborationQuestionStatus(_ studentId:String, withStatus status:String)
    {
        if(MessageManager.sharedMessageHandler().xmppStream.isConnected() == true)
        {
            
            
            
            let userId           = SSTeacherDataSource.sharedDataSource.currentUserId
            let msgType             = kCollaborationStatusChanged
            
            
            let messageBody = ["status":status]
            
            
            
            let details:NSMutableDictionary = ["From":userId!,
                                               "To":studentId,
                                               "Type":msgType,
                                               "Body":messageBody];
            
            let msg = SSMessage()
            msg.setMsgDetails( details)
            
            let xmlBody:String = msg.xmlMessage()
            
            MessageManager.sharedMessageHandler().sendMessage(to: "\(studentId)@\(kBaseXMPPURL)", withContents: xmlBody)
        }
    }
    
    
    //MARK: Group   Messages
    func sendExtendedTimetoRoom(_ roomId:String, withClassName className:String, withStartTime StartTime:String, withDelayTime timeDelay:String)
    {
        if(MessageManager.sharedMessageHandler().xmppStream.isConnected() == true)
        {
            
            
            let _roomId = "room_\(roomId)@conference.\(kBaseXMPPURL)";
            
            let userId           = SSTeacherDataSource.sharedDataSource.currentUserId
            let msgType             = kTimeExtended
            
            
              let messageBody = ["timedelay":timeDelay ,
                                "ClassName":className,
                                "stratTime":StartTime]
            
            
            
            let details:NSMutableDictionary = ["From":userId!,
                "To":_roomId,
                "Type":msgType,
                "Body":messageBody];
            
            
            
            let msg = SSMessage()
            msg.setMsgDetails( details)
            
            let xmlBody:String = msg.xmlMessage()
            
            MessageManager.sharedMessageHandler().sendGroupMessage(withBody: xmlBody, withRoomId: _roomId)
        }
    }
    
  
    
    func sendEndSessionMessageToRoom(_ roomId:String)
    {
        if(MessageManager.sharedMessageHandler().xmppStream.isConnected() == true)
        {
            
            let messageBody = ["RoomName":roomId]
            

            
            let _roomId = "room_\(roomId)@conference.\(kBaseXMPPURL)";
            
            let userId           = SSTeacherDataSource.sharedDataSource.currentUserId
            let msgType             = kTeacherEndsSession
            
            
            
            
            let details:NSMutableDictionary = ["From":userId!,
                                               "To":_roomId,
                                               "Type":msgType,
                                               "Body":messageBody];
            
            
            
            let msg = SSMessage()
            msg.setMsgDetails( details)
            
            let xmlBody:String = msg.xmlMessage()
            
            MessageManager.sharedMessageHandler().sendGroupMessage(withBody: xmlBody, withRoomId: _roomId)
        }
    }
    
    
    func sendSeatingChangedtoRoom(_ _roomId:String, withSeatName seatName:String, withRoomName roomName:String)
    {
        if(MessageManager.sharedMessageHandler().xmppStream.isConnected() == true)
        {
            
            
           let roomId = "room_\(_roomId)@conference.\(kBaseXMPPURL)";
            
            let userId           = SSTeacherDataSource.sharedDataSource.currentUserId
            let msgType             = kSeatingChanged
            
            
            let messageBody = ["state":seatName ,
                "RoomName":roomName]
            
            
            
            let details:NSMutableDictionary = ["From":userId!,
                "To":roomId,
                "Type":msgType,
                "Body":messageBody];
            
            
            
            let msg = SSMessage()
            msg.setMsgDetails( details)
            
            let xmlBody:String = msg.xmlMessage()
            
            MessageManager.sharedMessageHandler().sendGroupMessage(withBody: xmlBody, withRoomId: roomId)
        }
    }
    
    
    func sendAllowVotingToRoom(_ _roomId :String , withValue votingState:String, withSubTopicName subTopicName:String , withSubtopicID subTopicId:String)
    {
        if(MessageManager.sharedMessageHandler().xmppStream.isConnected() == true)
        {
            
            
            let roomId = "room_\(_roomId)@conference.\(kBaseXMPPURL)";
            
            let userId           = SSTeacherDataSource.sharedDataSource.currentUserId
            let msgType             = kAllowVoiting
            
            
            let messageBody = ["VotingValue":votingState,"SubTopicName":subTopicName, "SubTopicId":subTopicId]
            
            
            
            let details:NSMutableDictionary = ["From":userId!,
                "To":roomId,
                "Type":msgType,
                "Body":messageBody];
            
            
            
            let msg = SSMessage()
            msg.setMsgDetails( details)
            
            let xmlBody:String = msg.xmlMessage()
            
            MessageManager.sharedMessageHandler().sendGroupMessage(withBody: xmlBody, withRoomId: roomId)
        }
    }
    
    
    func sendQuestionWithRoomName(_ _roomId :String , withQuestionLogId QuestionLogId:String, withQuestionType QuestionType:String)
    {
        if(MessageManager.sharedMessageHandler().xmppStream.isConnected() == true)
        {
           let roomId = "\(_roomId)@conference.\(kBaseXMPPURL)";
            
            let userId           = SSTeacherDataSource.sharedDataSource.currentUserId
            let msgType             = kTeacherQnASubmitted
            
            
            let messageBody = ["QuestionLogId":QuestionLogId,
                                "QuestionType":QuestionType]
            
            
            
            let details:NSMutableDictionary = ["From":userId!,
                "To":roomId,
                "Type":msgType,
                "Body":messageBody];
            
            
            
            let msg = SSMessage()
            msg.setMsgDetails( details)
            
            let xmlBody:String = msg.xmlMessage()
            
            MessageManager.sharedMessageHandler().sendGroupMessage(withBody: xmlBody, withRoomId: roomId)
        }
    }
    
    
    func sendQuizQuestionWithRoomName(_ _roomId :String , withQuestionLogId QuestionLogId:String, withQuestionType QuestionType:String)
    {
        if(MessageManager.sharedMessageHandler().xmppStream.isConnected() == true)
        {
            let roomId = "\(_roomId)@conference.\(kBaseXMPPURL)";
            
            let userId           = SSTeacherDataSource.sharedDataSource.currentUserId
            let msgType             = kTeacherQuizSubmitted
            
            
            let messageBody = ["QuestionLogIdDetails":QuestionLogId,
                               "QuestionType":QuestionType]
            
            
            
            let details:NSMutableDictionary = ["From":userId!,
                                               "To":roomId,
                                               "Type":msgType,
                                               "Body":messageBody];
            
            
            
            let msg = SSMessage()
            msg.setMsgDetails( details)
            
            let xmlBody:String = msg.xmlMessage()
            
            MessageManager.sharedMessageHandler().sendGroupMessage(withBody: xmlBody, withRoomId: roomId)
        }
    }
    
    
    func sendHandRaiseReceivedMessageToRoom(_ _roomId :String)
    {
        if(MessageManager.sharedMessageHandler().xmppStream.isConnected() == true)
        {
            
            
            let roomId = "room_\(_roomId)@conference.\(kBaseXMPPURL)";
            
            let userId           = SSTeacherDataSource.sharedDataSource.currentUserId
            let msgType             = kTeacherHandRaiseInReview
            
            
            let details:NSMutableDictionary = ["From":userId!,
                "To":roomId,
                "Type":msgType];
            
            
            
            let msg = SSMessage()
            msg.setMsgDetails( details)
            
            let xmlBody:String = msg.xmlMessage()
            
            MessageManager.sharedMessageHandler().sendGroupMessage(withBody: xmlBody, withRoomId: roomId)
        }
    }
    
    func freezeQnAMessageToRoom(_ _roomId :String, withAverageScore averageScore:String, withTotalResponses totalResponse:String)
    {
        if(MessageManager.sharedMessageHandler().xmppStream.isConnected() == true)
        {
            
            
           let roomId = "\(_roomId)@conference.\(kBaseXMPPURL)"
            
            let userId           = SSTeacherDataSource.sharedDataSource.currentUserId
            let msgType             = kTeacherQnAFreeze
            
            
            let messageBody = ["averageScore":averageScore,
                "totalResponces":totalResponse]
            

            
            
            let details:NSMutableDictionary = ["From":userId!,
                "To":roomId,
                "Type":msgType,
                "Body":messageBody];
            
            
            
            let msg = SSMessage()
            msg.setMsgDetails( details)
            
            let xmlBody:String = msg.xmlMessage()
            
            MessageManager.sharedMessageHandler().sendGroupMessage(withBody: xmlBody, withRoomId: roomId)
        }
    }
    
    
    func shareGraphtoiPhoneStudentId(_ _roomId :String, withDetails Details:AnyObject)
    {
        if(MessageManager.sharedMessageHandler().xmppStream.isConnected() == true)
        {
            
            
           let roomId = "\(_roomId)@conference.\(kBaseXMPPURL)"
            
            let userId           = SSTeacherDataSource.sharedDataSource.currentUserId
            let msgType             = kSharegraph
            
            
            let messageBody = ["Details":Details]
            
            
            
            let details:NSMutableDictionary = ["From":userId!,
                "To":roomId,
                "Type":msgType,
                "Body":messageBody];
            
            
            
            let msg = SSMessage()
            msg.setMsgDetails( details)
            
            let xmlBody:String = msg.xmlMessage()
            
            MessageManager.sharedMessageHandler().sendGroupMessage(withBody: xmlBody, withRoomId: roomId)
        }
    }
    
    
    func sendClearQuestionMessageWithRoomId(_ _roomId :String)
    {
        if(MessageManager.sharedMessageHandler().xmppStream.isConnected() == true)
        {
            
            
           let roomId = "\(_roomId)@conference.\(kBaseXMPPURL)";
            
            let userId           = SSTeacherDataSource.sharedDataSource.currentUserId
            let msgType             = kTeacherQnADone
            
            
            let details:NSMutableDictionary = ["From":userId!,
                "To":roomId,
                "Type":msgType];
            
            
            
            let msg = SSMessage()
            msg.setMsgDetails( details)
            
            let xmlBody:String = msg.xmlMessage()
            
            MessageManager.sharedMessageHandler().sendGroupMessage(withBody: xmlBody, withRoomId: roomId)
        }
    }
    
    
    
    func sendQueryRecievedMessageToRoom(_ _roomId :String)
    {
        if(MessageManager.sharedMessageHandler().xmppStream.isConnected() == true)
        {
            
            
          let  roomId = "room_\(_roomId)@conference.\(kBaseXMPPURL)";
            
            let userId           = SSTeacherDataSource.sharedDataSource.currentUserId
            let msgType             = kTeacherReviewDoubt
            
            
            let details:NSMutableDictionary = ["From":userId!,
                "To":roomId,
                "Type":msgType];
            
            
            
            let msg = SSMessage()
            msg.setMsgDetails( details)
            
            let xmlBody:String = msg.xmlMessage()
            
            MessageManager.sharedMessageHandler().sendGroupMessage(withBody: xmlBody, withRoomId: roomId)
        }
    }
    
    
    func sendVolunteerVoteStartedMessgeToStudents(_ _roomId :String)
    {
        if(MessageManager.sharedMessageHandler().xmppStream.isConnected() == true)
        {
            
            
            let roomId = "room_\(_roomId)@conference.\(kBaseXMPPURL)";
            
            let userId           = SSTeacherDataSource.sharedDataSource.currentUserId
            let msgType             = kQueryStartedForVolunteer
            
            
            let details:NSMutableDictionary = ["From":userId!,
                "To":roomId,
                "Type":msgType];
            
            
            
            let msg = SSMessage()
            msg.setMsgDetails( details)
            
            let xmlBody:String = msg.xmlMessage()
            
            MessageManager.sharedMessageHandler().sendGroupMessage(withBody: xmlBody, withRoomId: roomId)
        }
    }
    
    
    func sendEndVolunteeringMessagetoStudent(_ _roomId :String)
    {
        if(MessageManager.sharedMessageHandler().xmppStream.isConnected() == true)
        {
            
            
            let roomId = "room_\(_roomId)@conference.\(kBaseXMPPURL)";
            
            let userId           = SSTeacherDataSource.sharedDataSource.currentUserId
            let msgType             = kEndVolunteeringSession
            
            
            let details:NSMutableDictionary = ["From":userId!,
                "To":roomId,
                "Type":msgType];
            
            
            
            let msg = SSMessage()
            msg.setMsgDetails( details)
            
            let xmlBody:String = msg.xmlMessage()
            
            MessageManager.sharedMessageHandler().sendGroupMessage(withBody: xmlBody, withRoomId: roomId)
        }
    }
    
    
    func sendLikertPollMessageToRoom(_ _roomId :String, withSelectedOption options:String, withQuestionName questionName:String)
    {
        if(MessageManager.sharedMessageHandler().xmppStream.isConnected() == true)
        {
            
            
            let roomId = "room_\(_roomId)@conference.\(kBaseXMPPURL)";
            
            let userId           = SSTeacherDataSource.sharedDataSource.currentUserId
            let msgType             = kSendPollMessageToStudents
            
            let messageBody = ["selectedOptions":options,
                               "questionName":questionName]
            
            let details:NSMutableDictionary = ["From":userId!,
                                               "To":roomId,
                                               "Type":msgType,
                                               "Body":messageBody];
            
            
            
            let msg = SSMessage()
            msg.setMsgDetails( details)
            
            let xmlBody:String = msg.xmlMessage()
            
            MessageManager.sharedMessageHandler().sendGroupMessage(withBody: xmlBody, withRoomId: roomId)
        }
    }
    func sendPollStoppedMessageToRoom(_ _roomId :String)
    {
        if(MessageManager.sharedMessageHandler().xmppStream.isConnected() == true)
        {
            
            
            let roomId = "room_\(_roomId)@conference.\(kBaseXMPPURL)";
            
            let userId           = SSTeacherDataSource.sharedDataSource.currentUserId
            let msgType             = kSendPollStoppedToStudent
            
            
            let details:NSMutableDictionary = ["From":userId!,
                                               "To":roomId,
                                               "Type":msgType];
            
            
            
            let msg = SSMessage()
            msg.setMsgDetails( details)
            
            let xmlBody:String = msg.xmlMessage()
            
            MessageManager.sharedMessageHandler().sendGroupMessage(withBody: xmlBody, withRoomId: roomId)
        }
    }
    
    
    func sendModelAnswerToStudentWithRoomId(_ _roomId :String, withQuestionLogId QuestionLogId:NSString)
    {
        if(MessageManager.sharedMessageHandler().xmppStream.isConnected() == true)
        {
            
            
            let roomId = "room_\(_roomId)@conference.\(kBaseXMPPURL)";
            
            let userId           = SSTeacherDataSource.sharedDataSource.currentUserId
            let msgType             = kModelAnswerDetails
            
            
            let messageBody = ["modelAnserDetails":QuestionLogId]
            

            
            let details:NSMutableDictionary = ["From":userId!,
                                               "To":roomId,
                                               "Type":msgType,
                                               "Body":messageBody];

            
            
            
            let msg = SSMessage()
            msg.setMsgDetails( details)
            
            let xmlBody:String = msg.xmlMessage()
            
            MessageManager.sharedMessageHandler().sendGroupMessage(withBody: xmlBody, withRoomId: roomId)
        }
    }
    
    
    func sendQRVGiveAnswerMessageToRoom(_ _roomId :String, withstudentId studentId:NSString, withQueryId queryId:String ,withStudentName studentName:String)
    {
        if(MessageManager.sharedMessageHandler().xmppStream.isConnected() == true)
        {
            
            
            let roomId = "room_\(_roomId)@conference.\(kBaseXMPPURL)";
            
            let userId           = SSTeacherDataSource.sharedDataSource.currentUserId
            let msgType             = kQueryAnswering
            
            
            let messageBody = ["QueryId":queryId,
                               "StudentName":studentName,
                               "AnsweringStudentId":studentId] as [String : Any]
            
            
            
            let details:NSMutableDictionary = ["From":userId!,
                                               "To":roomId,
                                               "Type":msgType,
                                               "Body":messageBody];
            
            
            
            
            let msg = SSMessage()
            msg.setMsgDetails( details)
            
            let xmlBody:String = msg.xmlMessage()
            
            MessageManager.sharedMessageHandler().sendGroupMessage(withBody: xmlBody, withRoomId: roomId)
        }
    }
    
    func sendQRVClosedMessageToRoom(_ _roomId :String, withstudentId studentId:NSString, withQueryId queryId:String, withVolunterPercentage totalPercentage:String)
    {
        if(MessageManager.sharedMessageHandler().xmppStream.isConnected() == true)
        {
            
            
            let roomId = "room_\(_roomId)@conference.\(kBaseXMPPURL)";
            
            let userId           = SSTeacherDataSource.sharedDataSource.currentUserId
            let msgType             = kQueryCloseVoting
            
            
            let messageBody = ["QueryId":queryId,
                               "StudentId":studentId,
                               "totalPercentage":totalPercentage] as [String : Any]
            
            
            
            let details:NSMutableDictionary = ["From":userId!,
                                               "To":roomId,
                                               "Type":msgType,
                                               "Body":messageBody];
            
            
            
            
            let msg = SSMessage()
            msg.setMsgDetails( details)
            
            let xmlBody:String = msg.xmlMessage()
            
            MessageManager.sharedMessageHandler().sendGroupMessage(withBody: xmlBody, withRoomId: roomId)
        }
    }
    
    
    func sendCollaborationQuestionEnabledWithRoomId(_ _roomId:String, withType Type:String, withCategory Category:String, withCategoryID CategoryID:String)
    {
        if(MessageManager.sharedMessageHandler().xmppStream.isConnected() == true)
        {
            
            
            let roomId = "room_\(_roomId)@conference.\(kBaseXMPPURL)";
            
            let userId           = SSTeacherDataSource.sharedDataSource.currentUserId
            let msgType             = kCollaborationPing
            
            
            let messageBody = ["Type":Type,
                               "category":Category,
                               "categoryID":CategoryID]
            
            
            
            let details:NSMutableDictionary = ["From":userId!,
                                               "To":roomId,
                                               "Type":msgType,
                                               "Body":messageBody];
            
            
            
            
            let msg = SSMessage()
            msg.setMsgDetails( details)
            
            let xmlBody:String = msg.xmlMessage()
            
            MessageManager.sharedMessageHandler().sendGroupMessage(withBody: xmlBody, withRoomId: roomId)
        }
    }
    
    
    
    
    func sendCollaborationQuestionEnded(_ _roomId:String)
    {
        if(MessageManager.sharedMessageHandler().xmppStream.isConnected() == true)
        {
            
            
            let roomId = "room_\(_roomId)@conference.\(kBaseXMPPURL)";
            
            let userId           = SSTeacherDataSource.sharedDataSource.currentUserId
            let msgType             = kCollaborationCancelled
            
            
            let messageBody = ["Type":"MRQ"]
            
            
            
            let details:NSMutableDictionary = ["From":userId!,
                                               "To":roomId,
                                               "Type":msgType,
                                               "Body":messageBody];
            
            let msg = SSMessage()
            msg.setMsgDetails( details)
            
            let xmlBody:String = msg.xmlMessage()
            
            MessageManager.sharedMessageHandler().sendGroupMessage(withBody: xmlBody, withRoomId: roomId)
        }
    }
    
    
    //MARK: Recieve Message
    open func didReceiveMessage(withBody body: String!, withSenderJid senderJid: XMPPJID!)
    {
        
        let message = SSMessage.init(xmlString: body)
        
        if message?.messageType() == nil
        {
            return
        }
        
        
        print("XMPP Message : \(String(describing: message?.messageType())):\n\(message?.messageBody() ?? "")")
        
        switch (message?.messageType())
        {
            case kStudentSentBenchState?:
                if let studentId = message?.messageFrom()
                {
                    if let studentState = (message?.messageBody() as AnyObject).object(forKey: "BenchState") as? String
                    {
                        if delegate().responds(to: #selector(SSTeacherMessagehandlerDelegate.smhDidgetStudentBentchStateWithStudentId(_:withState:)))
                        {
                             delegate().smhDidgetStudentBentchStateWithStudentId!(studentId, withState: studentState)
                        }
                    }
                }
                break
            
            
        case kStudentQnAAccept? :
            if let studentId = message?.messageFrom()
            {
                if delegate().responds(to: #selector(SSTeacherMessagehandlerDelegate.smhDidgetStudentQuestionAccepetedMessageWithStudentId(_:)))
                {
                    delegate().smhDidgetStudentQuestionAccepetedMessageWithStudentId!(studentId)
                }
            }
            break
            
        case kStudentSendAnswer?:
           
            if let studentId = message?.messageFrom()
            {
                if delegate().responds(to: #selector(SSTeacherMessagehandlerDelegate.smhDidgetStudentAnswerMessageWithStudentId(_:withAnswerString:)))
                {
                    
                    if message?.messageBody() != nil
                    {
                        if let AnswerString = (message?.messageBody() as AnyObject).object(forKey: "AnswerString") as? String
                        {
                             delegate().smhDidgetStudentAnswerMessageWithStudentId!(studentId, withAnswerString: AnswerString)
                        }
                    }
                }
            }
            break
            
            
            
        case kStudentDoubtSubmission?:
            
            if delegate().responds(to: #selector(SSTeacherMessagehandlerDelegate.smhDidgetStudentQueryWithDetails(_:)))
            {
                
                if message?.messageBody() != nil
                {
                    delegate().smhDidgetStudentQueryWithDetails!(message?.messageBody() as! String)
                }
            }
            break
            
            
        case kDontKnow?:
           
            if delegate().responds(to: #selector(SSTeacherMessagehandlerDelegate.smhDidgetStudentDontKnowMessageRecieved(_:)))
            {
                delegate().smhDidgetStudentDontKnowMessageRecieved!((message?.messageFrom())!)
               
            }
            break

            
        case kWithDrawSubmission?:
            
            if delegate().responds(to: #selector(SSTeacherMessagehandlerDelegate.smhDidGetstudentSubmissionWithDrawn(_:)))
            {
                delegate().smhDidGetstudentSubmissionWithDrawn!((message?.messageFrom())!)
                
            }
            break
            
        case kSendSelectedPollToTeacher?:
            
            if delegate().responds(to: #selector(SSTeacherMessagehandlerDelegate.smhDidgetStudentPollWithDetails(optionValue:)))
            {
                if message?.messageBody() != nil
                {
                   delegate().smhDidgetStudentPollWithDetails!(optionValue: message!.messageBody() as! NSMutableDictionary)
                    
                }
            }
            break
        case kMeToo?:
            
            if delegate().responds(to: #selector(SSTeacherMessagehandlerDelegate.smhDidgetMeTooValueWithDetails(_:)))
            {
                delegate().smhDidgetMeTooValueWithDetails!(message!.messageBody() as AnyObject)
                
            }
            break
            
            
        case kIVolunteer?:
            
            if delegate().responds(to: #selector(SSTeacherMessagehandlerDelegate.smhDidgetVolunteerValueWithDetails(_:)))
            {
                delegate().smhDidgetVolunteerValueWithDetails!(message!.messageBody() as AnyObject)
                
            }
            break
            
            
            
            
        case kVolunteerVoteSent?:
            
            if delegate().responds(to: #selector(SSTeacherMessagehandlerDelegate.smhDidgetVolunteerValueWithDetails(_:)))
            {
                if message?.messageBody() != nil
                {
                    if ((message?.messageBody() as AnyObject).object(forKey: "newVote") != nil)
                    {
                        if let newVote = (message?.messageBody() as AnyObject).object(forKey: "newVote") as? String
                        {
                            delegate().smhDidgetVoteFromStudentWithStudentId!((message?.messageFrom())!, withVote: newVote)
                        }
                        
                    }
                    
                    
                }
                
                
            }
            break

        case kQueryUnderstood?:
            
            if delegate().responds(to: #selector(SSTeacherMessagehandlerDelegate.smhDidgetUnderstoodMessageWithDetails(_:withStudentId:)))
            {
                delegate().smhDidgetUnderstoodMessageWithDetails!(message!.messageBody() as AnyObject, withStudentId: (message?.messageFrom())!)
                
            }
            break
            
        case kSendPeakView?:
            
            if delegate().responds(to: #selector(SSTeacherMessagehandlerDelegate.smhDidgetPeakViewWithDetails(_:withStudentId:)))
            {
                delegate().smhDidgetPeakViewWithDetails!(message!.messageBody() as AnyObject, withStudentId: (message?.messageFrom())!)
                
            }
            break
            
        case kSendSingleString?:
            
            if delegate().responds(to: #selector(SSTeacherMessagehandlerDelegate.smhDidgetOneStringAnswerWithDetails(_:withStudentId:)))
            {
                delegate().smhDidgetOneStringAnswerWithDetails!(message!.messageBody() as AnyObject, withStudentId: (message?.messageFrom())!)
                
            }
            break
            
        case kDoubtWithDrawn?:
            
            if delegate().responds(to: #selector(SSTeacherMessagehandlerDelegate.smhDidgetQueryWithdrawnWithDetails(_:withStudentId:)))
            {
                if let queryID = message?.messageBody() as? String
                {
                    delegate().smhDidgetQueryWithdrawnWithDetails!(queryID, withStudentId: (message?.messageFrom())!)
                }
                
                
            }
            break
        case kCollaborationOption?:
            
            if delegate().responds(to: #selector(SSTeacherMessagehandlerDelegate.smhDidgetCollaborationSuggestion(_:)))
            {
                delegate().smhDidgetCollaborationSuggestion!(message!.messageBody() as AnyObject)
                
            }
            break
            
        case kTakeOver?:
            if MessageManager.sharedMessageHandler().xmppStream.myJID.resource != senderJid.resource{
                AppDelegate.appState = "TakenOver"
                MessageManager.sharedMessageHandler().disconnect()
            }
            break
        
        case kTakeOverTime?:
            if MessageManager.sharedMessageHandler().xmppStream.myJID.resource != senderJid.resource{
                let senderTime:Int64 = Int64(message?.messageBody() as! String)!
                if retryConnectTime > senderTime{
                    AppDelegate.appState = "TakenOver"
                    MessageManager.sharedMessageHandler().disconnect()
                }
                else{
                    let details:NSMutableDictionary = ["From":MessageManager.sharedMessageHandler().xmppStream.myJID.user,
                                                       "To":senderJid.user,
                                                       "Type":kTakeOverTime,
                                                       "Body":retryConnectTime];
                    let msg = SSMessage()
                    msg.setMsgDetails( details)
                    let xmlBody:String = msg.xmlMessage()
                    MessageManager.sharedMessageHandler().sendMessage(to: senderJid.bare(), withContents: xmlBody)
                }
            }
            break
            
        default:
            break
            
        }
    }
    
    func refreshApp(){
        SSTeacherDataSource.sharedDataSource.refreshApp(success: { (response) in
            
            if let summary = response.object(forKey: "Summary") as? NSArray
            {
                if summary.count > 0
                {
                    let details = summary.firstObject as AnyObject
                    if let currentState = details.object(forKey: "CurrentSessionState") as? Int{
                        
                        let currentSessionId:Int = (summary.value(forKey: "CurrentSessionId") as! NSArray)[0] as! Int
                        let currentSessionState:Int = (summary.value(forKey: "CurrentSessionState") as! NSArray)[0] as! Int
                        TeacherScheduleViewController.currentSessionId = currentSessionId
                        self.joinOrLeaveXMPPSessionRoom(sessionState:String(describing:currentSessionState), roomName:String(describing:currentSessionId))
                        
                        
                    }
                    if let nextState = details.object(forKey: "NextClassSessionState") as? Int{
                        let nextSessionState:Int = (summary.value(forKey: "NextClassSessionState") as! NSArray)[0] as! Int
                        let nextSessionId:Int = (summary.value(forKey: "NextClassSessionId") as! NSArray)[0] as! Int
                        TeacherScheduleViewController.nextSessionId = nextSessionId
                        self.joinOrLeaveXMPPSessionRoom(sessionState:String(describing:nextSessionState), roomName:String(describing:nextSessionId))
                    }
                    
                }
            }
            
            
        }) { (error) in
            NSLog("Refresh API failed, unable to join xmpp rooms")
        }
    }
    
    
     func joinOrLeaveXMPPSessionRoom(sessionState: String, roomName: String){
        if sessionState == kLive || sessionState == kopened || sessionState == kScheduled
        {
            SSTeacherMessageHandler.sharedMessageHandler.createRoomWithRoomName(String(format:"room_%@",roomName), withHistory: "0")
            
            if sessionState == kLive{
                SSTeacherMessageHandler.sharedMessageHandler.createRoomWithRoomName(String(format:"question_%@",roomName), withHistory: "0")
            }
        }
        else
        {
            SSTeacherMessageHandler.sharedMessageHandler.checkAndRemoveJoinedRoomsArrayWithRoomid(String(format:"room_%@",roomName))
        }
        
    }
}



