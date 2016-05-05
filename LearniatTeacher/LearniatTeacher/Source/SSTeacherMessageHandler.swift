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
let kModelAnswerDetails             = "179"
let kMuteStudent                    = "712"




import Foundation

@objc protocol SSTeacherMessagehandlerDelegate
{
    optional func smhDidRecieveStreamConnectionsState(state:Bool)
    
    optional  func smhDidReciveAuthenticationState(state:Bool, WithName userName:String)
    
    optional  func smhStreamReconnectingWithDelay(delay:Int32)
    
    optional  func smhDidcreateRoomWithRoomName(roomName:String)
    
    
    
    
    optional  func smhDidgetStudentBentchStateWithStudentId(studentId:String, withState state:String)
    
    optional  func smhDidgetStudentQuestionAccepetedMessageWithStudentId(StudentId: String)
    
    optional  func smhDidgetStudentAnswerMessageWithStudentId(StudentId: String, withAnswerString answerStrin:String)
    
    optional func smhDidGetstudentSubmissionWithDrawn(StudentId:String)
    
   
    optional func smhDidgetStudentDontKnowMessageRecieved(StudentId:String)
    
    optional func smhDidgetStudentQueryWithDetails(queryId:String)
    
    
    optional func smhDidgetStudentPollWithDetails(optionValue:String)
    
    
}

public class SSTeacherMessageHandler:NSObject,SSTeacherMessagehandlerDelegate,MessageManagerDelegate {
    
    var _delgate: AnyObject!
    var currentUserName:String!
   
    
   public  static let sharedMessageHandler = SSTeacherMessageHandler()
    
    
    
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
    func connectWithUserId(userID:String, andWithPassword password:String, withDelegate delegate:SSTeacherMessagehandlerDelegate)
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
        if delegate().respondsToSelector(#selector(SSTeacherMessagehandlerDelegate.smhDidRecieveStreamConnectionsState(_:)))
        {
            delegate().smhDidRecieveStreamConnectionsState!(state)
        }
        

    }
    public func didGetAuthenticationState(state:Bool)
    {
         if delegate().respondsToSelector(#selector(SSTeacherMessagehandlerDelegate.smhDidReciveAuthenticationState(_:WithName:)))
         {
            delegate().smhDidReciveAuthenticationState!(state, WithName: getCurrentUSerName())
        }
    }
    
    
    public func didReconnectingWithDelaytime(delayTime: Int32) {
        if delegate().respondsToSelector(#selector(SSTeacherMessagehandlerDelegate.smhStreamReconnectingWithDelay(_:)))
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
        if delegate().respondsToSelector(#selector(SSTeacherMessagehandlerDelegate.smhDidcreateRoomWithRoomName(_:)))
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
    func sendAllowVotingToStudents(studentId :String , withValue votingState:String, withSubTopicName subTopicName:String , withSubtopicID subTopicId:String)
    {
        if(MessageManager.sharedMessageHandler().xmppStream.isConnected() == true)
        {
            let userId           = SSTeacherDataSource.sharedDataSource.currentUserId
            let msgType             = kAllowVoiting
            
            
            let messageBody = ["VotingValue":votingState,"SubTopicName":subTopicName, "SubTopicId":subTopicId]
            
            
            
            let details:NSMutableDictionary = ["From":userId,
                "To":studentId,
                "Type":msgType,
                "Body":messageBody];
            
            
            
            let msg = SSMessage()
            msg.setMsgDetails( details)
            
            let xmlBody:String = msg.XMLMessage()
            
            MessageManager.sharedMessageHandler().sendMessageTo("\(studentId)@\(kBaseXMPPURL)", withContents: xmlBody)
        }
    }
    func sendLiveClassRoomName( roomId :String , withQuestionLogId studentId:String, withQuestionType QuestionType:String)
    {
        if(MessageManager.sharedMessageHandler().xmppStream.isConnected() == true)
        {
            let userId           = SSTeacherDataSource.sharedDataSource.currentUserId
            let msgType             = kLiveClassRoomName
            
            
            let messageBody = ["CreatedRoomName":roomId, "QuestionType":QuestionType]
            
            
            
            let details:NSMutableDictionary = ["From":userId,
                "To":studentId,
                "Type":msgType,
                "Body":messageBody];
            
            
            
            let msg = SSMessage()
            msg.setMsgDetails( details)
            
            let xmlBody:String = msg.XMLMessage()
            
            MessageManager.sharedMessageHandler().sendMessageTo("\(studentId)@\(kBaseXMPPURL)", withContents: xmlBody)
        }
    }
    
    
    
    func sendHandRaiseReceivedMessageToStudentWithId(studentId :String)
    {
        if(MessageManager.sharedMessageHandler().xmppStream.isConnected() == true)
        {
            
            
            
            let userId           = SSTeacherDataSource.sharedDataSource.currentUserId
            let msgType             = kTeacherHandRaiseInReview
            
            
            let details:NSMutableDictionary = ["From":userId,
                "To":studentId,
                "Type":msgType];
            
            
            
            let msg = SSMessage()
            msg.setMsgDetails( details)
            
            let xmlBody:String = msg.XMLMessage()
            
           MessageManager.sharedMessageHandler().sendMessageTo("\(studentId)@\(kBaseXMPPURL)", withContents: xmlBody)
        }
    }
    
    
    
    func sendFeedbackToStudentWitId( studentId :String , withassesmentAnswerId assesmentAnswerId:String)
    {
        if(MessageManager.sharedMessageHandler().xmppStream.isConnected() == true)
        {
            let userId           = SSTeacherDataSource.sharedDataSource.currentUserId
            let msgType             = kSendFeedBack
            
            
            let messageBody = ["AssesmentAnswerId":assesmentAnswerId]
            
            
            
            let details:NSMutableDictionary = ["From":userId,
                "To":studentId,
                "Type":msgType,
                "Body":messageBody];
            
            
            
            let msg = SSMessage()
            msg.setMsgDetails( details)
            
            let xmlBody:String = msg.XMLMessage()
            
            MessageManager.sharedMessageHandler().sendMessageTo("\(studentId)@\(kBaseXMPPURL)", withContents: xmlBody)
        }
    }
    
    
    
    
    func sendQueryFeedbackToStudentWitId(studentId :String , withQueryId QueryId:String)
    {
        if(MessageManager.sharedMessageHandler().xmppStream.isConnected() == true)
        {
            let userId    = SSTeacherDataSource.sharedDataSource.currentUserId
            let msgType   = kReplyToQuery
            
            
            let messageBody = ["QueryId":QueryId]
            
            
            
            let details:NSMutableDictionary = ["From":userId,
                "To":studentId,
                "Type":msgType,
                "Body":messageBody];
            
            
            
            let msg = SSMessage()
            msg.setMsgDetails( details)
            
            let xmlBody:String = msg.XMLMessage()
            
            MessageManager.sharedMessageHandler().sendMessageTo("\(studentId)@\(kBaseXMPPURL)", withContents: xmlBody)
        }
    }
    
    
    func sendMuteMessageToStudentWithStudentId(studentId :String , withStatus Status:String)
    {
        if(MessageManager.sharedMessageHandler().xmppStream.isConnected() == true)
        {
            let userId    = SSTeacherDataSource.sharedDataSource.currentUserId
            let msgType   = kMuteStudent
            
            
            let messageBody = ["MUTESTATUS":Status]
            
            
            
            let details:NSMutableDictionary = ["From":userId,
                "To":studentId,
                "Type":msgType,
                "Body":messageBody];
            
            
            
            let msg = SSMessage()
            msg.setMsgDetails( details)
            
            let xmlBody:String = msg.XMLMessage()
            
            MessageManager.sharedMessageHandler().sendMessageTo("\(studentId)@\(kBaseXMPPURL)", withContents: xmlBody)
        }
    }
    
    //MARK: Group   Messages
    func sendExtendedTimetoRoom(roomId:String, withClassName className:String, withStartTime StartTime:String, withDelayTime timeDelay:String)
    {
        if(MessageManager.sharedMessageHandler().xmppStream.isConnected() == true)
        {
            
            
            let _roomId = "room_\(roomId)@conference.\(kBaseXMPPURL)";
            
            let userId           = SSTeacherDataSource.sharedDataSource.currentUserId
            let msgType             = kTimeExtended
            
            
              let messageBody = ["timedelay":timeDelay ,
                                "ClassName":className,
                                "stratTime":StartTime]
            
            
            
            let details:NSMutableDictionary = ["From":userId,
                "To":_roomId,
                "Type":msgType,
                "Body":messageBody];
            
            
            
            let msg = SSMessage()
            msg.setMsgDetails( details)
            
            let xmlBody:String = msg.XMLMessage()
            
            MessageManager.sharedMessageHandler().sendGroupMessageWithBody(xmlBody, withRoomId: _roomId)
        }
    }
    
    
    func sendSeatingChangedtoRoom(_roomId:String, withSeatName seatName:String, withRoomName roomName:String)
    {
        if(MessageManager.sharedMessageHandler().xmppStream.isConnected() == true)
        {
            
            
           let roomId = "room_\(_roomId)@conference.\(kBaseXMPPURL)";
            
            let userId           = SSTeacherDataSource.sharedDataSource.currentUserId
            let msgType             = kSeatingChanged
            
            
            let messageBody = ["state":seatName ,
                "RoomName":roomName]
            
            
            
            let details:NSMutableDictionary = ["From":userId,
                "To":roomId,
                "Type":msgType,
                "Body":messageBody];
            
            
            
            let msg = SSMessage()
            msg.setMsgDetails( details)
            
            let xmlBody:String = msg.XMLMessage()
            
            MessageManager.sharedMessageHandler().sendGroupMessageWithBody(xmlBody, withRoomId: roomId)
        }
    }
    
    
    func sendAllowVotingToRoom(_roomId :String , withValue votingState:String, withSubTopicName subTopicName:String , withSubtopicID subTopicId:String)
    {
        if(MessageManager.sharedMessageHandler().xmppStream.isConnected() == true)
        {
            
            
            let roomId = "room_\(_roomId)@conference.\(kBaseXMPPURL)";
            
            let userId           = SSTeacherDataSource.sharedDataSource.currentUserId
            let msgType             = kAllowVoiting
            
            
            let messageBody = ["VotingValue":votingState,"SubTopicName":subTopicName, "SubTopicId":subTopicId]
            
            
            
            let details:NSMutableDictionary = ["From":userId,
                "To":roomId,
                "Type":msgType,
                "Body":messageBody];
            
            
            
            let msg = SSMessage()
            msg.setMsgDetails( details)
            
            let xmlBody:String = msg.XMLMessage()
            
            MessageManager.sharedMessageHandler().sendGroupMessageWithBody(xmlBody, withRoomId: roomId)
        }
    }
    
    
    func sendQuestionWithRoomName(_roomId :String , withQuestionLogId QuestionLogId:String, withQuestionType QuestionType:String)
    {
        if(MessageManager.sharedMessageHandler().xmppStream.isConnected() == true)
        {
           let roomId = "\(_roomId)@conference.\(kBaseXMPPURL)";
            
            let userId           = SSTeacherDataSource.sharedDataSource.currentUserId
            let msgType             = kTeacherQnASubmitted
            
            
            let messageBody = ["QuestionLogId":QuestionLogId,
                                "QuestionType":QuestionType]
            
            
            
            let details:NSMutableDictionary = ["From":userId,
                "To":roomId,
                "Type":msgType,
                "Body":messageBody];
            
            
            
            let msg = SSMessage()
            msg.setMsgDetails( details)
            
            let xmlBody:String = msg.XMLMessage()
            
            MessageManager.sharedMessageHandler().sendGroupMessageWithBody(xmlBody, withRoomId: roomId)
        }
    }
    
    
    func sendHandRaiseReceivedMessageToRoom(_roomId :String)
    {
        if(MessageManager.sharedMessageHandler().xmppStream.isConnected() == true)
        {
            
            
            let roomId = "room_\(_roomId)@conference.\(kBaseXMPPURL)";
            
            let userId           = SSTeacherDataSource.sharedDataSource.currentUserId
            let msgType             = kTeacherHandRaiseInReview
            
            
            let details:NSMutableDictionary = ["From":userId,
                "To":roomId,
                "Type":msgType];
            
            
            
            let msg = SSMessage()
            msg.setMsgDetails( details)
            
            let xmlBody:String = msg.XMLMessage()
            
            MessageManager.sharedMessageHandler().sendGroupMessageWithBody(xmlBody, withRoomId: roomId)
        }
    }
    
    func freezeQnAMessageToRoom(_roomId :String, withAverageScore averageScore:String, withTotalResponses totalResponse:String)
    {
        if(MessageManager.sharedMessageHandler().xmppStream.isConnected() == true)
        {
            
            
           let roomId = "\(_roomId)@conference.\(kBaseXMPPURL)"
            
            let userId           = SSTeacherDataSource.sharedDataSource.currentUserId
            let msgType             = kTeacherQnAFreeze
            
            
            let messageBody = ["averageScore":averageScore,
                "totalResponces":totalResponse]
            

            
            
            let details:NSMutableDictionary = ["From":userId,
                "To":roomId,
                "Type":msgType,
                "Body":messageBody];
            
            
            
            let msg = SSMessage()
            msg.setMsgDetails( details)
            
            let xmlBody:String = msg.XMLMessage()
            
            MessageManager.sharedMessageHandler().sendGroupMessageWithBody(xmlBody, withRoomId: roomId)
        }
    }
    
    
    func shareGraphtoiPhoneStudentId(_roomId :String, withDetails Details:AnyObject)
    {
        if(MessageManager.sharedMessageHandler().xmppStream.isConnected() == true)
        {
            
            
           let roomId = "\(_roomId)@conference.\(kBaseXMPPURL)"
            
            let userId           = SSTeacherDataSource.sharedDataSource.currentUserId
            let msgType             = kSharegraph
            
            
            let messageBody = ["Details":Details]
            
            
            
            let details:NSMutableDictionary = ["From":userId,
                "To":roomId,
                "Type":msgType,
                "Body":messageBody];
            
            
            
            let msg = SSMessage()
            msg.setMsgDetails( details)
            
            let xmlBody:String = msg.XMLMessage()
            
            MessageManager.sharedMessageHandler().sendGroupMessageWithBody(xmlBody, withRoomId: roomId)
        }
    }
    
    
    func sendClearQuestionMessageWithRoomId(_roomId :String)
    {
        if(MessageManager.sharedMessageHandler().xmppStream.isConnected() == true)
        {
            
            
           let roomId = "\(_roomId)@conference.\(kBaseXMPPURL)";
            
            let userId           = SSTeacherDataSource.sharedDataSource.currentUserId
            let msgType             = kTeacherQnADone
            
            
            let details:NSMutableDictionary = ["From":userId,
                "To":roomId,
                "Type":msgType];
            
            
            
            let msg = SSMessage()
            msg.setMsgDetails( details)
            
            let xmlBody:String = msg.XMLMessage()
            
            MessageManager.sharedMessageHandler().sendGroupMessageWithBody(xmlBody, withRoomId: roomId)
        }
    }
    
    
    
    func sendQueryRecievedMessageToRoom(_roomId :String)
    {
        if(MessageManager.sharedMessageHandler().xmppStream.isConnected() == true)
        {
            
            
          let  roomId = "room_\(_roomId)@conference.\(kBaseXMPPURL)";
            
            let userId           = SSTeacherDataSource.sharedDataSource.currentUserId
            let msgType             = kTeacherReviewDoubt
            
            
            let details:NSMutableDictionary = ["From":userId,
                "To":roomId,
                "Type":msgType];
            
            
            
            let msg = SSMessage()
            msg.setMsgDetails( details)
            
            let xmlBody:String = msg.XMLMessage()
            
            MessageManager.sharedMessageHandler().sendGroupMessageWithBody(xmlBody, withRoomId: roomId)
        }
    }
    
    
    func sendVolunteerVoteStartedMessgeToStudents(_roomId :String)
    {
        if(MessageManager.sharedMessageHandler().xmppStream.isConnected() == true)
        {
            
            
            let roomId = "room_\(_roomId)@conference.\(kBaseXMPPURL)";
            
            let userId           = SSTeacherDataSource.sharedDataSource.currentUserId
            let msgType             = kQueryStartedForVolunteer
            
            
            let details:NSMutableDictionary = ["From":userId,
                "To":roomId,
                "Type":msgType];
            
            
            
            let msg = SSMessage()
            msg.setMsgDetails( details)
            
            let xmlBody:String = msg.XMLMessage()
            
            MessageManager.sharedMessageHandler().sendGroupMessageWithBody(xmlBody, withRoomId: roomId)
        }
    }
    
    
    func sendEndVolunteeringMessagetoStudent(_roomId :String)
    {
        if(MessageManager.sharedMessageHandler().xmppStream.isConnected() == true)
        {
            
            
            let roomId = "room_\(_roomId)@conference.\(kBaseXMPPURL)";
            
            let userId           = SSTeacherDataSource.sharedDataSource.currentUserId
            let msgType             = kEndVolunteeringSession
            
            
            let details:NSMutableDictionary = ["From":userId,
                "To":roomId,
                "Type":msgType];
            
            
            
            let msg = SSMessage()
            msg.setMsgDetails( details)
            
            let xmlBody:String = msg.XMLMessage()
            
            MessageManager.sharedMessageHandler().sendGroupMessageWithBody(xmlBody, withRoomId: roomId)
        }
    }
    
    
    func sendLikertPollMessageToRoom(_roomId :String, withSelectedOption options:String, withQuestionName questionName:String)
    {
        if(MessageManager.sharedMessageHandler().xmppStream.isConnected() == true)
        {
            
            
            let roomId = "room_\(_roomId)@conference.\(kBaseXMPPURL)";
            
            let userId           = SSTeacherDataSource.sharedDataSource.currentUserId
            let msgType             = kSendPollMessageToStudents
            
            let messageBody = ["selectedOptions":options,
                               "questionName":questionName]
            
            let details:NSMutableDictionary = ["From":userId,
                                               "To":roomId,
                                               "Type":msgType,
                                               "Body":messageBody];
            
            
            
            let msg = SSMessage()
            msg.setMsgDetails( details)
            
            let xmlBody:String = msg.XMLMessage()
            
            MessageManager.sharedMessageHandler().sendGroupMessageWithBody(xmlBody, withRoomId: roomId)
        }
    }
    func sendPollStoppedMessageToRoom(_roomId :String)
    {
        if(MessageManager.sharedMessageHandler().xmppStream.isConnected() == true)
        {
            
            
            let roomId = "room_\(_roomId)@conference.\(kBaseXMPPURL)";
            
            let userId           = SSTeacherDataSource.sharedDataSource.currentUserId
            let msgType             = kSendPollStoppedToStudent
            
            
            let details:NSMutableDictionary = ["From":userId,
                                               "To":roomId,
                                               "Type":msgType];
            
            
            
            let msg = SSMessage()
            msg.setMsgDetails( details)
            
            let xmlBody:String = msg.XMLMessage()
            
            MessageManager.sharedMessageHandler().sendGroupMessageWithBody(xmlBody, withRoomId: roomId)
        }
    }
    
    
    func sendModelAnswerToStudentWithRoomId(_roomId :String, withQuestionLogId QuestionLogId:NSString)
    {
        if(MessageManager.sharedMessageHandler().xmppStream.isConnected() == true)
        {
            
            
            let roomId = "room_\(_roomId)@conference.\(kBaseXMPPURL)";
            
            let userId           = SSTeacherDataSource.sharedDataSource.currentUserId
            let msgType             = kModelAnswerDetails
            
            
            let messageBody = ["modelAnserDetails":QuestionLogId]
            

            
            let details:NSMutableDictionary = ["From":userId,
                                               "To":roomId,
                                               "Type":msgType,
                                               "Body":messageBody];

            
            
            
            let msg = SSMessage()
            msg.setMsgDetails( details)
            
            let xmlBody:String = msg.XMLMessage()
            
            MessageManager.sharedMessageHandler().sendGroupMessageWithBody(xmlBody, withRoomId: roomId)
        }
    }
    
    
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
            case kStudentSentBenchState:
                if let studentId = message.messageFrom()
                {
                    if let studentState = message.messageBody().objectForKey("BenchState") as? String
                    {
                        if delegate().respondsToSelector(#selector(SSTeacherMessagehandlerDelegate.smhDidgetStudentBentchStateWithStudentId(_:withState:)))
                        {
                             delegate().smhDidgetStudentBentchStateWithStudentId!(studentId, withState: studentState)
                        }
                    }
                }
                break
            
            
        case kStudentQnAAccept :
            if let studentId = message.messageFrom()
            {
                if delegate().respondsToSelector(#selector(SSTeacherMessagehandlerDelegate.smhDidgetStudentQuestionAccepetedMessageWithStudentId(_:)))
                {
                    delegate().smhDidgetStudentQuestionAccepetedMessageWithStudentId!(studentId)
                }
            }
            break
            
        case kStudentSendAnswer:
           
            if let studentId = message.messageFrom()
            {
                if delegate().respondsToSelector(#selector(SSTeacherMessagehandlerDelegate.smhDidgetStudentAnswerMessageWithStudentId(_:withAnswerString:)))
                {
                    
                    if message.messageBody() != nil
                    {
                        if let AnswerString = message.messageBody().objectForKey("AnswerString") as? String
                        {
                             delegate().smhDidgetStudentAnswerMessageWithStudentId!(studentId, withAnswerString: AnswerString)
                        }
                    }
                }
            }
            break
            
            
            
        case kStudentDoubtSubmission:
            
            if delegate().respondsToSelector(#selector(SSTeacherMessagehandlerDelegate.smhDidgetStudentQueryWithDetails(_:)))
            {
                
                if message.messageBody() != nil
                {
                    delegate().smhDidgetStudentQueryWithDetails!(message.messageBody() as! String)
                }
            }
            break
            
            
        case kDontKnow :
           
            if delegate().respondsToSelector(#selector(SSTeacherMessagehandlerDelegate.smhDidgetStudentDontKnowMessageRecieved(_:)))
            {
                delegate().smhDidgetStudentDontKnowMessageRecieved!(message.messageFrom())
               
            }
            break

            
        case kWithDrawSubmission:
            
            if delegate().respondsToSelector(#selector(SSTeacherMessagehandlerDelegate.smhDidGetstudentSubmissionWithDrawn(_:)))
            {
                delegate().smhDidGetstudentSubmissionWithDrawn!(message.messageFrom())
                
            }
            break
            
        case kSendSelectedPollToTeacher:
            
            if delegate().respondsToSelector(#selector(SSTeacherMessagehandlerDelegate.smhDidgetStudentPollWithDetails(_:)))
            {
                if message.messageBody() != nil
                {
                    if let optionsValue =  message.messageBody().objectForKey("option") as? String
                    {
                        delegate().smhDidgetStudentPollWithDetails!(optionsValue)
                    }
                    
                }
            }
            break
            
            
            
            
            
        default:
            break
            
        }
    }
}



