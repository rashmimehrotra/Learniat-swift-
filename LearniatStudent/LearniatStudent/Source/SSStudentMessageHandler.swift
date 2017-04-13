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
let kodelAnswerDetails              = "179"
let kMuteStudent                    = "712"
let kGetPeakView                    = "704"
let kQueryUnderstood                = "1102"
let kSendPeakView                   = "705"
let kSendSingleString               = "1101"
let kModelAnswerDetails             = "179"
let kCollaborationCancelled         = "1104"
let kCollaborationStatusChanged     = "1105"




import Foundation

@objc protocol SSStudentMessageHandlerDelegate
{
    @objc optional func smhDidRecieveStreamConnectionsState(_ state:Bool)
    
    @objc optional  func smhDidReciveAuthenticationState(_ state:Bool, WithName userName:String)
    
    @objc optional  func smhStreamReconnectingWithDelay(_ delay:Int32)
    
    @objc optional  func smhDidcreateRoomWithRoomName(_ roomName:String)
    
    
    
    
    @objc optional  func smhDidgetTimeExtendedWithDetails(_ Details:AnyObject)
    
     @objc optional func smhDidGetSessionEndMessageWithDetails(_ details:AnyObject)
    
    @objc optional  func smhDidGetSeatingChangedWithDetails(_ details:AnyObject)
    
    @objc optional  func smhDidGetVotingMessageWithDetails(_ details:AnyObject)
    
    @objc optional func smhdidReceiveQuestionSentMessage(_ dict: AnyObject)
    
    @objc optional func smhdidReceiveQuestionClearMessage()
    
    @objc optional func smhdidReceiveQuestionFreezMessage()
    
    
    
    
    
    @objc optional func smhdidGetQueryFeedBackFromTeacherWithDetials(_ details : AnyObject)
    
    @objc optional func smhdidRecieveQueryReviewmessage()
    
    @objc optional func smhdidRecieveQueryOpenedForVotingWithDetails()
    
    @objc optional func smhdidRecieveQueryVolunteeringEnded()
    
    @objc optional func smhDidRecieveQueryAnsweringMessageWithDetails(_ details:AnyObject)
    
    @objc optional func smhdidRecieveQueryVolunteeringClosedMessageWithDetails(_ details:AnyObject)
    
    @objc optional func smhDidRecievePollingStartedMessageWithDetails(_ detials:AnyObject)
   
    @objc optional func smhDidGetPollEndedMessageFromteacher()
    
    @objc optional func smhDidGetGraphSharedWithDetails(_ details:AnyObject)
    
    @objc optional func smhDidGetTeacherReviewMessage()
    
    @objc optional func smhDidGetFeedbackForAnswerWithDetils(_ details:AnyObject)
    
    @objc optional func smhDidGetPeakViewMessage()
    
    @objc optional func smhdidRecieveModelAnswerMessageWithDetials(_ details:AnyObject)
    
    @objc optional func smhDidRecieveMutemessageWithDetails(_ details:AnyObject)
    
    
    @objc optional func smhDidRecieveCollaborationPingFromTeacher(_ details:AnyObject)
    
    @objc optional func smhDidRecieveSuggestionStatusFromTeacher(_ details:AnyObject)
    
    @objc optional func smhDidRecieveCollaborationEndedFromTeacher()
    
    
}

open class SSStudentMessageHandler:NSObject,SSStudentMessageHandlerDelegate,MessageManagerDelegate {
    
    var _delgate: AnyObject!
    var currentUserName:String!
   
    
   open  static let sharedMessageHandler = SSStudentMessageHandler()
    
    
    
  let kBaseXMPPURL	=	UserDefaults.standard.object(forKey: k_INI_BaseXMPPURL) as! String
    
    
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
    func connectWithUserId(_ userID:String, andWithPassword password:String, withDelegate delegate:SSStudentMessageHandlerDelegate)
    {
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
    
    
    func performReconnet()
    {
        
        if let password  =  UserDefaults.standard.object(forKey: kPassword) as? String
        {
            MessageManager.sharedMessageHandler().connect(withUserId: "\(SSStudentDataSource.sharedDataSource.currentUserId)@\(kBaseXMPPURL)", withPassword: password)
        }
        
    }
    
    func goOffline()
    {
        MessageManager.sharedMessageHandler().goOffline()
    }
    
   
    
    
    //MARK: ..........Delegate
    open func didGetStreamState(_ state:Bool)
    {
        if delegate().responds(to: #selector(SSStudentMessageHandlerDelegate.smhDidRecieveStreamConnectionsState(_:)))
        {
            delegate().smhDidRecieveStreamConnectionsState!(state)
        }
        

    }
    open func didGetAuthenticationState(_ state:Bool)
    {
         if delegate().responds(to: #selector(SSStudentMessageHandlerDelegate.smhDidReciveAuthenticationState(_:WithName:)))
         {
            delegate().smhDidReciveAuthenticationState!(state, WithName: getCurrentUSerName())
        }
    }
    
    
    open func didReconnecting(withDelaytime delayTime: Int32) {
        if delegate().responds(to: #selector(SSStudentMessageHandlerDelegate.smhStreamReconnectingWithDelay(_:)))
        {
            delegate().smhStreamReconnectingWithDelay!(delayTime)
        }
    }
    
    
    //MARK: Create and join Room
    
    func createRoomWithRoomName(_ roomName: String!, withHistory history:String!)
    {
        MessageManager.sharedMessageHandler().setdelegate(self)
        MessageManager.sharedMessageHandler().setUpRoom(roomName, withAdminPrivilage: false, withHistoryValue: history)
    }
    
    
    
    open func didCreatedOrJoinedRoom(withCreatedRoomName _roomName: String!)
    {
        if delegate().responds(to: #selector(SSStudentMessageHandlerDelegate.smhDidcreateRoomWithRoomName(_:)))
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
    
    
    
    
    func sendStudentBenchStatus( _ status:String)
    {
        
        
        if(MessageManager.sharedMessageHandler().xmppStream.isConnected() == true &&  SSStudentDataSource.sharedDataSource.currentTeacherId != nil)
        {
            let studentID           = SSStudentDataSource.sharedDataSource.currentUserId
            let msgType             = kStudentSentBenchState
            let teacherID           = SSStudentDataSource.sharedDataSource.currentTeacherId
            
            
            let messageBody = [kBenchState:status]
            
            
            
            
            let details:NSMutableDictionary = ["From":studentID!,
                                               "To":teacherID!,
                                               "Type":msgType,
                                               "Body":messageBody];
            
            let msg = SSMessage()
            msg.setMsgDetails( details)
            
            let xmlBody:String = msg.xmlMessage()
            
            MessageManager.sharedMessageHandler().sendMessage(to: "\(teacherID!)@\(kBaseXMPPURL)", withContents: xmlBody)
        }
    }
    
    func sendAcceptQuestionMessageToTeacherforType()
    {
        
        
        if(MessageManager.sharedMessageHandler().xmppStream.isConnected() == true &&  SSStudentDataSource.sharedDataSource.currentTeacherId != nil)
        {
            let studentID           = SSStudentDataSource.sharedDataSource.currentUserId
            let msgType             = kStudentQnAAccept
            let teacherID           = SSStudentDataSource.sharedDataSource.currentTeacherId
            
            
            let details:NSMutableDictionary = ["From":studentID!,
                                               "To":teacherID!,
                                               "Type":msgType];
            
            let msg = SSMessage()
            msg.setMsgDetails( details)
            
            let xmlBody:String = msg.xmlMessage()
            
            MessageManager.sharedMessageHandler().sendMessage(to: "\(teacherID!)@\(kBaseXMPPURL)", withContents: xmlBody)
        }
    }
    
    
    
    func sendDontKnowMessageToTeacher()
    {
        
        
        if(MessageManager.sharedMessageHandler().xmppStream.isConnected() == true &&  SSStudentDataSource.sharedDataSource.currentTeacherId != nil)
        {
            let studentID           = SSStudentDataSource.sharedDataSource.currentUserId
            let msgType             = kDontKnow
            let teacherID           = SSStudentDataSource.sharedDataSource.currentTeacherId
            
            
            let details:NSMutableDictionary = ["From":studentID!,
                                               "To":teacherID!,
                                               "Type":msgType];
            
            let msg = SSMessage()
            msg.setMsgDetails( details)
            
            let xmlBody:String = msg.xmlMessage()
            
            MessageManager.sharedMessageHandler().sendMessage(to: "\(teacherID!)@\(kBaseXMPPURL)", withContents: xmlBody)
        }
    }
    func sendAnswerToQuestionMessageToTeacherWithAnswerString( _ answerIdString:String)
    {
        
        
        if(MessageManager.sharedMessageHandler().xmppStream.isConnected() == true &&  SSStudentDataSource.sharedDataSource.currentTeacherId != nil)
        {
            let studentID           = SSStudentDataSource.sharedDataSource.currentUserId
            let msgType             = kStudentSendAnswer
            let teacherID           = SSStudentDataSource.sharedDataSource.currentTeacherId
            
            
            let messageBody = ["AnswerString":answerIdString , "StudentId":studentID]
            
            
            
            
            let details:NSMutableDictionary = ["From":studentID!,
                                               "To":teacherID!,
                                               "Type":msgType,
                                               "Body":messageBody];
            
            let msg = SSMessage()
            msg.setMsgDetails( details)
            
            let xmlBody:String = msg.xmlMessage()
            
            MessageManager.sharedMessageHandler().sendMessage(to: "\(teacherID!)@\(kBaseXMPPURL)", withContents: xmlBody)
        }
    }
    
    func sendDoubtMessageToTeacherWithQueryId(_ queryId:String)
    {
        
        
        if(MessageManager.sharedMessageHandler().xmppStream.isConnected() == true &&  SSStudentDataSource.sharedDataSource.currentTeacherId != nil)
        {
            let studentID           = SSStudentDataSource.sharedDataSource.currentUserId
            let msgType             = kStudentDoubtSubmission
            let teacherID           = SSStudentDataSource.sharedDataSource.currentTeacherId
            
            
            let messageBody = queryId
            
            
            
            
            let details:NSMutableDictionary = ["From":studentID!,
                                               "To":teacherID!,
                                               "Type" :msgType,
                                               "Body":messageBody];
            
            let msg = SSMessage()
            msg.setMsgDetails( details)
            
            let xmlBody:String = msg.xmlMessage()
            
            MessageManager.sharedMessageHandler().sendMessage(to: "\(teacherID!)@\(kBaseXMPPURL)", withContents: xmlBody)
        }
    }
    
    
    func sendDoubtWithdrwanFromStudentWithQueryId(_ queryId:String)
    {
        
        
        if(MessageManager.sharedMessageHandler().xmppStream.isConnected() == true &&  SSStudentDataSource.sharedDataSource.currentTeacherId != nil)
        {
            let studentID           = SSStudentDataSource.sharedDataSource.currentUserId
            let msgType             = kDoubtWithDrawn
            let teacherID           = SSStudentDataSource.sharedDataSource.currentTeacherId
            
            
            let messageBody = queryId
            
            
            
            
            let details:NSMutableDictionary = ["From":studentID!,
                                               "To":teacherID!,
                                               "Type":msgType,
                                               "Body":messageBody];
            
            let msg = SSMessage()
            msg.setMsgDetails( details)
            
            let xmlBody:String = msg.xmlMessage()
            
            MessageManager.sharedMessageHandler().sendMessage(to: "\(teacherID!)@\(kBaseXMPPURL)", withContents: xmlBody)
        }
    }
    
    
    func sendWithDrawMessageToTeacher()
    {
        
        
        if(MessageManager.sharedMessageHandler().xmppStream.isConnected() == true &&  SSStudentDataSource.sharedDataSource.currentTeacherId != nil)
        {
            let studentID           = SSStudentDataSource.sharedDataSource.currentUserId
            let msgType             = kWithDrawSubmission
            let teacherID           = SSStudentDataSource.sharedDataSource.currentTeacherId
            
            
            let details:NSMutableDictionary = ["From":studentID!,
                                               "To":teacherID!,
                                               "Type":msgType];
            
            let msg = SSMessage()
            msg.setMsgDetails( details)
            
            let xmlBody:String = msg.xmlMessage()
            
            MessageManager.sharedMessageHandler().sendMessage(to: "\(teacherID!)@\(kBaseXMPPURL)", withContents: xmlBody)
        }
    }
    func sendMeTooMessageToTeacherWithQueryId(_ queryid:String)
    {
        
        
        if(MessageManager.sharedMessageHandler().xmppStream.isConnected() == true &&  SSStudentDataSource.sharedDataSource.currentTeacherId != nil)
        {
            let studentID           = SSStudentDataSource.sharedDataSource.currentUserId
            let msgType             = kMeToo
            let teacherID           = SSStudentDataSource.sharedDataSource.currentTeacherId
            
            
            let messageBody = ["QueryId":queryid , "StudentId":studentID, "StudentName":SSStudentDataSource.sharedDataSource.currentUserName]
            
            
            
            
            let details:NSMutableDictionary = ["From":studentID!,
                                               "To":teacherID!,
                                               "Type":msgType,
                                               "Body":messageBody];
            
            let msg = SSMessage()
            msg.setMsgDetails( details)
            
            let xmlBody:String = msg.xmlMessage()
            
            MessageManager.sharedMessageHandler().sendMessage(to: "\(teacherID!)@\(kBaseXMPPURL)", withContents: xmlBody)
        }
    }
    
    func sendIVolunteerMessageToTeacher(_ queryid:String, withvolunteerId volunteerId:String)
    {
        
        
        if(MessageManager.sharedMessageHandler().xmppStream.isConnected() == true &&  SSStudentDataSource.sharedDataSource.currentTeacherId != nil)
        {
            let studentID           = SSStudentDataSource.sharedDataSource.currentUserId
            let msgType             = kIVolunteer
            let teacherID           = SSStudentDataSource.sharedDataSource.currentTeacherId
            
            
            let messageBody = ["QueryId":queryid , "StudentId":studentID, "StudentName":SSStudentDataSource.sharedDataSource.currentUserName , "VolunteerId" : volunteerId]
            
            
            
            let details:NSMutableDictionary = ["From":studentID!,
                                               "To":teacherID!,
                                               "Type":msgType,
                                               "Body":messageBody];
            
            let msg = SSMessage()
            msg.setMsgDetails( details)
            
            let xmlBody:String = msg.xmlMessage()
            
            MessageManager.sharedMessageHandler().sendMessage(to: "\(teacherID!)@\(kBaseXMPPURL)", withContents: xmlBody)
        }
    }
    
    func sendQueryLikedAndDislikeMessagetoTeacherwithNewVote(_ newvote:String)
    {
        
        
        if(MessageManager.sharedMessageHandler().xmppStream.isConnected() == true &&  SSStudentDataSource.sharedDataSource.currentTeacherId != nil)
        {
            let studentID           = SSStudentDataSource.sharedDataSource.currentUserId
            let msgType             = kVolunteerVoteSent
            let teacherID           = SSStudentDataSource.sharedDataSource.currentTeacherId
            
            
            let messageBody = ["newVote":newvote]
            
            
            
            
            let details:NSMutableDictionary = ["From":studentID!,
                                               "To":teacherID!,
                                               "Type":msgType,
                                               "Body":messageBody];
            
            let msg = SSMessage()
            msg.setMsgDetails( details)
            
            let xmlBody:String = msg.xmlMessage()
            
            MessageManager.sharedMessageHandler().sendMessage(to: "\(teacherID!)@\(kBaseXMPPURL)", withContents: xmlBody)
        }
    }
    func sendQueryVolunteerVotesMessagetoTeacherwithOldvolde( _ oldVote:String, withNewVote newvote:String)
    {
        
        
        if(MessageManager.sharedMessageHandler().xmppStream.isConnected() == true &&  SSStudentDataSource.sharedDataSource.currentTeacherId != nil)
        {
            let studentID           = SSStudentDataSource.sharedDataSource.currentUserId
            let msgType             = kVolunteerIVolunteerLikeNDislike
            let teacherID           = SSStudentDataSource.sharedDataSource.currentTeacherId
            
            
            let messageBody = ["oldVote":oldVote , "newVote":newvote]
            
            
            
            
            let details:NSMutableDictionary = ["From":studentID!,
                                               "To":teacherID!,
                                               "Type":msgType,
                                               "Body":messageBody];
            
            let msg = SSMessage()
            msg.setMsgDetails( details)
            
            let xmlBody:String = msg.xmlMessage()
            
            MessageManager.sharedMessageHandler().sendMessage(to: "\(teacherID!)@\(kBaseXMPPURL)", withContents: xmlBody)
        }
    }
    
    
    func sendQueryUnderstoodMessageWithQueryID(_ QueryId:String)
    {
        
        
        if(MessageManager.sharedMessageHandler().xmppStream.isConnected() == true &&  SSStudentDataSource.sharedDataSource.currentTeacherId != nil)
        {
            let studentID           = SSStudentDataSource.sharedDataSource.currentUserId
            let msgType             = kQueryUnderstood
            let teacherID           = SSStudentDataSource.sharedDataSource.currentTeacherId
            
            
            let messageBody = ["QueryId":QueryId]
            
            
            
            
            let details:NSMutableDictionary = ["From":studentID!,
                                               "To":teacherID!,
                                               "Type":msgType,
                                               "Body":messageBody];
            
            let msg = SSMessage()
            msg.setMsgDetails( details)
            
            let xmlBody:String = msg.xmlMessage()
            
            MessageManager.sharedMessageHandler().sendMessage(to: "\(teacherID!)@\(kBaseXMPPURL)", withContents: xmlBody)
        }
    }
    func sendPollOptionSelectedWithoptionText(_ optiontext:String)
    {
        if(MessageManager.sharedMessageHandler().xmppStream.isConnected() == true &&  SSStudentDataSource.sharedDataSource.currentTeacherId != nil)
        {
            let studentID           = SSStudentDataSource.sharedDataSource.currentUserId
            let msgType             = kSendSelectedPollToTeacher
            let teacherID           = SSStudentDataSource.sharedDataSource.currentTeacherId
            
            
            let messageBody = ["option":optiontext,
                               "studentID":studentID]
            
            
            
            
            let details:NSMutableDictionary = ["From":studentID!,
                                               "To":teacherID!,
                                               "Type":msgType,
                                               "Body":messageBody];
            
            let msg = SSMessage()
            msg.setMsgDetails( details)
            
            let xmlBody:String = msg.xmlMessage()
            
            MessageManager.sharedMessageHandler().sendMessage(to: "\(teacherID!)@\(kBaseXMPPURL)", withContents: xmlBody)
        }
    }
    func sendPeakViewMessageToTeacherWithImageData(_ imageData:String)
    {
        if(MessageManager.sharedMessageHandler().xmppStream.isConnected() == true &&  SSStudentDataSource.sharedDataSource.currentTeacherId != nil)
        {
            let studentID           = SSStudentDataSource.sharedDataSource.currentUserId
            let msgType             = kSendPeakView
            let teacherID           = SSStudentDataSource.sharedDataSource.currentTeacherId
            
            
            let messageBody = ["imageData":imageData]
            
            
            
            
            let details:NSMutableDictionary = ["From":studentID!,
                                               "To":teacherID!,
                                               "Type":msgType,
                                               "Body":messageBody];
            
            let msg = SSMessage()
            msg.setMsgDetails( details)
            
            let xmlBody:String = msg.xmlMessage()
            
            MessageManager.sharedMessageHandler().sendMessage(to: "\(teacherID!)@\(kBaseXMPPURL)", withContents: xmlBody)
        }
    }
    
    func sendOneStringAnswerWithAnswer(_ answerString:String)
    {
        if(MessageManager.sharedMessageHandler().xmppStream.isConnected() == true &&  SSStudentDataSource.sharedDataSource.currentTeacherId != nil)
        {
            let studentID           = SSStudentDataSource.sharedDataSource.currentUserId
            let msgType             = kSendSingleString
            let teacherID           = SSStudentDataSource.sharedDataSource.currentTeacherId
            
            
            let messageBody = ["OneStringAnswer":answerString]
            
            
            
            
            let details:NSMutableDictionary = ["From":studentID!,
                                               "To":teacherID!,
                                               "Type":msgType,
                                               "Body":messageBody];
            
            let msg = SSMessage()
            msg.setMsgDetails( details)
            
            let xmlBody:String = msg.xmlMessage()
            
            MessageManager.sharedMessageHandler().sendMessage(to: "\(teacherID!)@\(kBaseXMPPURL)", withContents: xmlBody)
        }
    }
    
    
    
    func sendCollaborationSuggestion(_ suggestion:String, withSuggestionID SuggestionId:String)
    {
        if(MessageManager.sharedMessageHandler().xmppStream.isConnected() == true &&  SSStudentDataSource.sharedDataSource.currentTeacherId != nil)
        {
            let studentID           = SSStudentDataSource.sharedDataSource.currentUserId
            let msgType             = kCollaborationOption
            let teacherID           = SSStudentDataSource.sharedDataSource.currentTeacherId
            
            
            let messageBody = ["suggestion":suggestion,
                               "SuggestionId":SuggestionId,
                               "studentID":studentID,
                               "StudentName":SSStudentDataSource.sharedDataSource.currentUserName]
            
            
            
            
            let details:NSMutableDictionary = ["From":studentID!,
                                               "To":teacherID!,
                                               "Type":msgType,
                                               "Body":messageBody];
            
            let msg = SSMessage()
            msg.setMsgDetails( details)
            
            let xmlBody:String = msg.xmlMessage()
            
            MessageManager.sharedMessageHandler().sendMessage(to: "\(teacherID!)@\(kBaseXMPPURL)", withContents: xmlBody)
        }
    }
    
    
    
    
    //MARK: Recieve Message
    open func didReceiveMessage(withBody body: String!)
    {
        
        let message = SSMessage.init(xmlString: body)
        
        
        if message?.messageType() == nil
        {
            return
        }
        
        
        if message?.messageType() == kTimeExtended
        {
            if delegate().responds(to: #selector(SSStudentMessageHandlerDelegate.smhDidgetTimeExtendedWithDetails))
            {
                delegate().smhDidgetTimeExtendedWithDetails!(message!.messageBody() as AnyObject)
            }
        }
        else if message?.messageType() == kTeacherEndsSession
        {
            if delegate().responds(to: #selector(SSStudentMessageHandlerDelegate.smhDidGetSessionEndMessageWithDetails(_:)))
            {
                delegate().smhDidGetSessionEndMessageWithDetails!(message!.messageBody() as AnyObject)
            }
        }
        else if message?.messageType() == kSeatingChanged
        {
            if delegate().responds(to: #selector(SSStudentMessageHandlerDelegate.smhDidGetSeatingChangedWithDetails))
            {
                delegate().smhDidGetSeatingChangedWithDetails!(message!.messageBody() as AnyObject)
            }
        }
        else if message?.messageType() == kAllowVoiting
        {
            if delegate().responds(to: #selector(SSStudentMessageHandlerDelegate.smhDidGetVotingMessageWithDetails(_:)))
            {
                if message?.messageBody() != nil
                {
                    delegate().smhDidGetVotingMessageWithDetails!(message!.messageBody() as AnyObject)
                }
                
            }
        }

        else if message?.messageType() == kTeacherQnASubmitted
        {
            if delegate().responds(to: #selector(SSStudentMessageHandlerDelegate.smhdidReceiveQuestionSentMessage(_:)))
            {
                if message?.messageBody() != nil
                {
                    delegate().smhdidReceiveQuestionSentMessage!(message!.messageBody() as AnyObject)
                }
                
            }
        }
        else if message?.messageType() == kTeacherQnADone
        {
            if delegate().responds(to: #selector(SSStudentMessageHandlerDelegate.smhdidReceiveQuestionClearMessage))
            {
                
                delegate().smhdidReceiveQuestionClearMessage!()
            }
        }
        else if message?.messageType() == kTeacherQnAFreeze
        {
            if delegate().responds(to: #selector(SSStudentMessageHandlerDelegate.smhdidReceiveQuestionFreezMessage))
            {
                
                delegate().smhdidReceiveQuestionFreezMessage!()
            }
        }
        else if message?.messageType() == kReplyToQuery
        {
            if delegate().responds(to: #selector(SSStudentMessageHandlerDelegate.smhdidGetQueryFeedBackFromTeacherWithDetials(_:)))
            {
                
                if message?.messageBody() != nil
                {
                    delegate().smhdidGetQueryFeedBackFromTeacherWithDetials!(message!.messageBody() as AnyObject)
                }
            }
            
        }
        else if message?.messageType() == kTeacherReviewDoubt
        {
            if delegate().responds(to: #selector(SSStudentMessageHandlerDelegate.smhdidRecieveQueryReviewmessage))
            {
                delegate().smhdidRecieveQueryReviewmessage!()
            }
            
        }
        else if message?.messageType() == kQueryStartedForVolunteer
        {
            if delegate().responds(to: #selector(SSStudentMessageHandlerDelegate.smhdidRecieveQueryOpenedForVotingWithDetails))
            {
                delegate().smhdidRecieveQueryOpenedForVotingWithDetails!()
            }
            
        }
        else if message?.messageType() == kEndVolunteeringSession
        {
            if delegate().responds(to: #selector(SSStudentMessageHandlerDelegate.smhdidRecieveQueryVolunteeringEnded))
            {
                delegate().smhdidRecieveQueryVolunteeringEnded!()
            }
            
        }
        else if message?.messageType() == kQueryAnswering
        {
            if delegate().responds(to: #selector(SSStudentMessageHandlerDelegate.smhDidRecieveQueryAnsweringMessageWithDetails(_:)))
            {
                
                if message?.messageBody() != nil
                {
                   delegate().smhDidRecieveQueryAnsweringMessageWithDetails!(message!.messageBody() as AnyObject)
                }
                
                
            }
            
        }
        else if message?.messageType() == kQueryCloseVoting
        {
            if delegate().responds(to: #selector(SSStudentMessageHandlerDelegate.smhdidRecieveQueryVolunteeringClosedMessageWithDetails(_:)))
            {
                
                if message?.messageBody() != nil
                {
                    delegate().smhdidRecieveQueryVolunteeringClosedMessageWithDetails!(message!.messageBody() as AnyObject)
                }
                
                
            }
            
        }
        else if message?.messageType() == kSendPollMessageToStudents
        {
            if delegate().responds(to: #selector(SSStudentMessageHandlerDelegate.smhDidRecievePollingStartedMessageWithDetails(_:)))
            {
                
                if message?.messageBody() != nil
                {
                    delegate().smhDidRecievePollingStartedMessageWithDetails!(message!.messageBody() as AnyObject)
                }
                
                
            }
            
        }
        else if message?.messageType() == kSendPollStoppedToStudent
        {
            if delegate().responds(to: #selector(SSStudentMessageHandlerDelegate.smhDidGetPollEndedMessageFromteacher))
            {
                
                delegate().smhDidGetPollEndedMessageFromteacher!()
            }
        }
        else if message?.messageType() == kSharegraph
        {
            if delegate().responds(to: #selector(SSStudentMessageHandlerDelegate.smhDidGetGraphSharedWithDetails(_:)))
            {
                
                if message?.messageBody() != nil
                {
                   delegate().smhDidGetGraphSharedWithDetails!(message!.messageBody() as AnyObject)
                }
            }
        }
        else if message?.messageType() == kTeacherHandRaiseInReview
        {
            if delegate().responds(to: #selector(SSStudentMessageHandlerDelegate.smhDidGetTeacherReviewMessage))
            {
                
                delegate().smhDidGetTeacherReviewMessage!()
            }
        }
        else if message?.messageType() == kSendFeedBack
        {
            if delegate().responds(to: #selector(SSStudentMessageHandlerDelegate.smhDidGetFeedbackForAnswerWithDetils(_:)))
            {
                if message?.messageBody() != nil
                {
                    delegate().smhDidGetFeedbackForAnswerWithDetils!(message!.messageBody() as AnyObject)
                }
                
            }
        }
        else if message?.messageType() == kGetPeakView
        {
            if delegate().responds(to: #selector(SSStudentMessageHandlerDelegate.smhDidGetPeakViewMessage))
            {
                delegate().smhDidGetPeakViewMessage!()
                
            }
        }
        else if message?.messageType() == kModelAnswerDetails
        {
            if delegate().responds(to: #selector(SSStudentMessageHandlerDelegate.smhdidRecieveModelAnswerMessageWithDetials(_:)))
            {
                if message?.messageBody() != nil
                {
                    delegate().smhdidRecieveModelAnswerMessageWithDetials!((message!.messageBody() as AnyObject))
                }
            }
        }
        else if message?.messageType() == kMuteStudent
        {
            if delegate().responds(to: #selector(SSStudentMessageHandlerDelegate.smhDidRecieveMutemessageWithDetails(_:)))
            {
                if message?.messageBody() != nil
                {
                    delegate().smhDidRecieveMutemessageWithDetails!((message!.messageBody() as AnyObject))
                }
            }
        }
        else if message?.messageType() == kCollaborationPing
        {
            if delegate().responds(to: #selector(SSStudentMessageHandlerDelegate.smhDidRecieveCollaborationPingFromTeacher(_:)))
            {
                if message?.messageBody() != nil
                {
                    delegate().smhDidRecieveCollaborationPingFromTeacher!((message!.messageBody() as AnyObject))
                }
            }
        }
        else if message?.messageType() == kCollaborationStatusChanged
        {
            if delegate().responds(to: #selector(SSStudentMessageHandlerDelegate.smhDidRecieveSuggestionStatusFromTeacher(_:)))
            {
                if message?.messageBody() != nil
                {
                    delegate().smhDidRecieveSuggestionStatusFromTeacher!((message!.messageBody() as AnyObject))
                }
            }
        }
        else if message?.messageType() == kCollaborationCancelled
        {
            if delegate().responds(to: #selector(SSStudentMessageHandlerDelegate.smhDidRecieveCollaborationEndedFromTeacher))
            {
                delegate().smhDidRecieveCollaborationEndedFromTeacher!()
            }
        }
        
        
        
    }
}



