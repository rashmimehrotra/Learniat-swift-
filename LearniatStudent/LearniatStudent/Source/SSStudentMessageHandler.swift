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
let kodelAnswerDetails             = "179"
let kMuteStudent                    = "712"
let kGetPeakView                    = "704"
let kQueryUnderstood                 = "1102"
let kSendPeakView                   = "705"



import Foundation

@objc protocol SSStudentMessageHandlerDelegate
{
    optional func smhDidRecieveStreamConnectionsState(state:Bool)
    
    optional  func smhDidReciveAuthenticationState(state:Bool, WithName userName:String)
    
    optional  func smhStreamReconnectingWithDelay(delay:Int32)
    
    optional  func smhDidcreateRoomWithRoomName(roomName:String)
    
    
    
    
    optional  func smhDidgetTimeExtendedWithDetails(Details:AnyObject)
    
    optional  func smhDidGetSeatingChangedWithDetails(details:AnyObject)
    
    optional  func smhDidGetVotingMessageWithDetails(details:AnyObject)
    
    optional func smhdidReceiveQuestionSentMessage(dict: AnyObject)
    
    optional func smhdidReceiveQuestionClearMessage()
    
    optional func smhdidReceiveQuestionFreezMessage()
    
    
    
    
    
    optional func smhdidGetQueryFeedBackFromTeacherWithDetials(details : AnyObject)
    
    optional func smhdidRecieveQueryReviewmessage()
    
    optional func smhdidRecieveQueryOpenedForVotingWithDetails()
    
    optional func smhdidRecieveQueryVolunteeringEnded()
    
    optional func smhDidRecieveQueryAnsweringMessageWithDetails(details:AnyObject)
    
    optional func smhdidRecieveQueryVolunteeringClosedMessageWithDetails(details:AnyObject)
    
    optional func smhDidRecievePollingStartedMessageWithDetails(detials:AnyObject)
   
    optional func smhDidGetPollEndedMessageFromteacher()
    
    optional func smhDidGetGraphSharedWithDetails(details:AnyObject)
    
    optional func smhDidGetTeacherReviewMessage()
    
    optional func smhDidGetFeedbackForAnswerWithDetils(details:AnyObject)
    
    optional func smhDidGetPeakViewMessage()
    
    
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
        MessageManager.sharedMessageHandler().setUpRoom(roomName, withAdminPrivilage: false, withHistoryValue: history)
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
    
    
    
    
    func sendStudentBenchStatus( status:String)
    {
        
        
        if(MessageManager.sharedMessageHandler().xmppStream.isConnected() == true &&  SSStudentDataSource.sharedDataSource.currentTeacherId != nil)
        {
            let studentID           = SSStudentDataSource.sharedDataSource.currentUserId
            let msgType             = kStudentSentBenchState
            let teacherID           = SSStudentDataSource.sharedDataSource.currentTeacherId
            
            
            let messageBody = [kBenchState:status]
            
            
            
            
            let details:NSMutableDictionary = ["From":studentID,
                                               "To":teacherID,
                                               "Type":msgType,
                                               "Body":messageBody];
            
            let msg = SSMessage()
            msg.setMsgDetails( details)
            
            let xmlBody:String = msg.XMLMessage()
            
            MessageManager.sharedMessageHandler().sendMessageTo("\(teacherID)@\(kBaseXMPPURL)", withContents: xmlBody)
        }
    }
    
    func sendAcceptQuestionMessageToTeacherforType()
    {
        
        
        if(MessageManager.sharedMessageHandler().xmppStream.isConnected() == true &&  SSStudentDataSource.sharedDataSource.currentTeacherId != nil)
        {
            let studentID           = SSStudentDataSource.sharedDataSource.currentUserId
            let msgType             = kStudentQnAAccept
            let teacherID           = SSStudentDataSource.sharedDataSource.currentTeacherId
            
            
            let details:NSMutableDictionary = ["From":studentID,
                                               "To":teacherID,
                                               "Type":msgType];
            
            let msg = SSMessage()
            msg.setMsgDetails( details)
            
            let xmlBody:String = msg.XMLMessage()
            
            MessageManager.sharedMessageHandler().sendMessageTo("\(teacherID)@\(kBaseXMPPURL)", withContents: xmlBody)
        }
    }
    
    
    
    func sendDontKnowMessageToTeacher()
    {
        
        
        if(MessageManager.sharedMessageHandler().xmppStream.isConnected() == true &&  SSStudentDataSource.sharedDataSource.currentTeacherId != nil)
        {
            let studentID           = SSStudentDataSource.sharedDataSource.currentUserId
            let msgType             = kDontKnow
            let teacherID           = SSStudentDataSource.sharedDataSource.currentTeacherId
            
            
            let details:NSMutableDictionary = ["From":studentID,
                                               "To":teacherID,
                                               "Type":msgType];
            
            let msg = SSMessage()
            msg.setMsgDetails( details)
            
            let xmlBody:String = msg.XMLMessage()
            
            MessageManager.sharedMessageHandler().sendMessageTo("\(teacherID)@\(kBaseXMPPURL)", withContents: xmlBody)
        }
    }
    func sendAnswerToQuestionMessageToTeacherWithAnswerString( answerIdString:String)
    {
        
        
        if(MessageManager.sharedMessageHandler().xmppStream.isConnected() == true &&  SSStudentDataSource.sharedDataSource.currentTeacherId != nil)
        {
            let studentID           = SSStudentDataSource.sharedDataSource.currentUserId
            let msgType             = kStudentSendAnswer
            let teacherID           = SSStudentDataSource.sharedDataSource.currentTeacherId
            
            
            let messageBody = ["AnswerString":answerIdString , "StudentId":studentID]
            
            
            
            
            let details:NSMutableDictionary = ["From":studentID,
                                               "To":teacherID,
                                               "Type":msgType,
                                               "Body":messageBody];
            
            let msg = SSMessage()
            msg.setMsgDetails( details)
            
            let xmlBody:String = msg.XMLMessage()
            
            MessageManager.sharedMessageHandler().sendMessageTo("\(teacherID)@\(kBaseXMPPURL)", withContents: xmlBody)
        }
    }
    
    func sendDoubtMessageToTeacherWithQueryId(queryId:String)
    {
        
        
        if(MessageManager.sharedMessageHandler().xmppStream.isConnected() == true &&  SSStudentDataSource.sharedDataSource.currentTeacherId != nil)
        {
            let studentID           = SSStudentDataSource.sharedDataSource.currentUserId
            let msgType             = kStudentDoubtSubmission
            let teacherID           = SSStudentDataSource.sharedDataSource.currentTeacherId
            
            
            let messageBody = queryId
            
            
            
            
            let details:NSMutableDictionary = ["From":studentID,
                                               "To":teacherID,
                                               "Type" :msgType,
                                               "Body":messageBody];
            
            let msg = SSMessage()
            msg.setMsgDetails( details)
            
            let xmlBody:String = msg.XMLMessage()
            
            MessageManager.sharedMessageHandler().sendMessageTo("\(teacherID)@\(kBaseXMPPURL)", withContents: xmlBody)
        }
    }
    
    
    func sendWithDrawMessageToTeacher()
    {
        
        
        if(MessageManager.sharedMessageHandler().xmppStream.isConnected() == true &&  SSStudentDataSource.sharedDataSource.currentTeacherId != nil)
        {
            let studentID           = SSStudentDataSource.sharedDataSource.currentUserId
            let msgType             = kWithDrawSubmission
            let teacherID           = SSStudentDataSource.sharedDataSource.currentTeacherId
            
            
            let details:NSMutableDictionary = ["From":studentID,
                                               "To":teacherID,
                                               "Type":msgType];
            
            let msg = SSMessage()
            msg.setMsgDetails( details)
            
            let xmlBody:String = msg.XMLMessage()
            
            MessageManager.sharedMessageHandler().sendMessageTo("\(teacherID)@\(kBaseXMPPURL)", withContents: xmlBody)
        }
    }
    func sendMeTooMessageToTeacherWithQueryId(queryid:String)
    {
        
        
        if(MessageManager.sharedMessageHandler().xmppStream.isConnected() == true &&  SSStudentDataSource.sharedDataSource.currentTeacherId != nil)
        {
            let studentID           = SSStudentDataSource.sharedDataSource.currentUserId
            let msgType             = kMeToo
            let teacherID           = SSStudentDataSource.sharedDataSource.currentTeacherId
            
            
            let messageBody = ["QueryId":queryid , "StudentId":studentID, "StudentName":SSStudentDataSource.sharedDataSource.currentUserName]
            
            
            
            
            let details:NSMutableDictionary = ["From":studentID,
                                               "To":teacherID,
                                               "Type":msgType,
                                               "Body":messageBody];
            
            let msg = SSMessage()
            msg.setMsgDetails( details)
            
            let xmlBody:String = msg.XMLMessage()
            
            MessageManager.sharedMessageHandler().sendMessageTo("\(teacherID)@\(kBaseXMPPURL)", withContents: xmlBody)
        }
    }
    
    func sendIVolunteerMessageToTeacher(queryid:String, withvolunteerId volunteerId:String)
    {
        
        
        if(MessageManager.sharedMessageHandler().xmppStream.isConnected() == true &&  SSStudentDataSource.sharedDataSource.currentTeacherId != nil)
        {
            let studentID           = SSStudentDataSource.sharedDataSource.currentUserId
            let msgType             = kIVolunteer
            let teacherID           = SSStudentDataSource.sharedDataSource.currentTeacherId
            
            
            let messageBody = ["QueryId":queryid , "StudentId":studentID, "StudentName":SSStudentDataSource.sharedDataSource.currentUserName , "VolunteerId" : volunteerId]
            
            
            
            let details:NSMutableDictionary = ["From":studentID,
                                               "To":teacherID,
                                               "Type":msgType,
                                               "Body":messageBody];
            
            let msg = SSMessage()
            msg.setMsgDetails( details)
            
            let xmlBody:String = msg.XMLMessage()
            
            MessageManager.sharedMessageHandler().sendMessageTo("\(teacherID)@\(kBaseXMPPURL)", withContents: xmlBody)
        }
    }
    
    func sendQueryLikedAndDislikeMessagetoTeacherwithNewVote(newvote:String)
    {
        
        
        if(MessageManager.sharedMessageHandler().xmppStream.isConnected() == true &&  SSStudentDataSource.sharedDataSource.currentTeacherId != nil)
        {
            let studentID           = SSStudentDataSource.sharedDataSource.currentUserId
            let msgType             = kVolunteerVoteSent
            let teacherID           = SSStudentDataSource.sharedDataSource.currentTeacherId
            
            
            let messageBody = ["newVote":newvote]
            
            
            
            
            let details:NSMutableDictionary = ["From":studentID,
                                               "To":teacherID,
                                               "Type":msgType,
                                               "Body":messageBody];
            
            let msg = SSMessage()
            msg.setMsgDetails( details)
            
            let xmlBody:String = msg.XMLMessage()
            
            MessageManager.sharedMessageHandler().sendMessageTo("\(teacherID)@\(kBaseXMPPURL)", withContents: xmlBody)
        }
    }
    func sendQueryVolunteerVotesMessagetoTeacherwithOldvolde( oldVote:String, withNewVote newvote:String)
    {
        
        
        if(MessageManager.sharedMessageHandler().xmppStream.isConnected() == true &&  SSStudentDataSource.sharedDataSource.currentTeacherId != nil)
        {
            let studentID           = SSStudentDataSource.sharedDataSource.currentUserId
            let msgType             = kVolunteerIVolunteerLikeNDislike
            let teacherID           = SSStudentDataSource.sharedDataSource.currentTeacherId
            
            
            let messageBody = ["oldVote":oldVote , "newVote":newvote]
            
            
            
            
            let details:NSMutableDictionary = ["From":studentID,
                                               "To":teacherID,
                                               "Type":msgType,
                                               "Body":messageBody];
            
            let msg = SSMessage()
            msg.setMsgDetails( details)
            
            let xmlBody:String = msg.XMLMessage()
            
            MessageManager.sharedMessageHandler().sendMessageTo("\(teacherID)@\(kBaseXMPPURL)", withContents: xmlBody)
        }
    }
    
    
    func sendQueryUnderstoodMessageWithQueryID(QueryId:String)
    {
        
        
        if(MessageManager.sharedMessageHandler().xmppStream.isConnected() == true &&  SSStudentDataSource.sharedDataSource.currentTeacherId != nil)
        {
            let studentID           = SSStudentDataSource.sharedDataSource.currentUserId
            let msgType             = kQueryUnderstood
            let teacherID           = SSStudentDataSource.sharedDataSource.currentTeacherId
            
            
            let messageBody = ["QueryId":QueryId]
            
            
            
            
            let details:NSMutableDictionary = ["From":studentID,
                                               "To":teacherID,
                                               "Type":msgType,
                                               "Body":messageBody];
            
            let msg = SSMessage()
            msg.setMsgDetails( details)
            
            let xmlBody:String = msg.XMLMessage()
            
            MessageManager.sharedMessageHandler().sendMessageTo("\(teacherID)@\(kBaseXMPPURL)", withContents: xmlBody)
        }
    }
    func sendPollOptionSelectedWithoptionText(optiontext:String)
    {
        if(MessageManager.sharedMessageHandler().xmppStream.isConnected() == true &&  SSStudentDataSource.sharedDataSource.currentTeacherId != nil)
        {
            let studentID           = SSStudentDataSource.sharedDataSource.currentUserId
            let msgType             = kSendSelectedPollToTeacher
            let teacherID           = SSStudentDataSource.sharedDataSource.currentTeacherId
            
            
            let messageBody = ["option":optiontext]
            
            
            
            
            let details:NSMutableDictionary = ["From":studentID,
                                               "To":teacherID,
                                               "Type":msgType,
                                               "Body":messageBody];
            
            let msg = SSMessage()
            msg.setMsgDetails( details)
            
            let xmlBody:String = msg.XMLMessage()
            
            MessageManager.sharedMessageHandler().sendMessageTo("\(teacherID)@\(kBaseXMPPURL)", withContents: xmlBody)
        }
    }
    func sendPeakViewMessageToTeacherWithImageData(imageData:String)
    {
        if(MessageManager.sharedMessageHandler().xmppStream.isConnected() == true &&  SSStudentDataSource.sharedDataSource.currentTeacherId != nil)
        {
            let studentID           = SSStudentDataSource.sharedDataSource.currentUserId
            let msgType             = kSendPeakView
            let teacherID           = SSStudentDataSource.sharedDataSource.currentTeacherId
            
            
            let messageBody = ["imageData":imageData]
            
            
            
            
            let details:NSMutableDictionary = ["From":studentID,
                                               "To":teacherID,
                                               "Type":msgType,
                                               "Body":messageBody];
            
            let msg = SSMessage()
            msg.setMsgDetails( details)
            
            let xmlBody:String = msg.XMLMessage()
            
            MessageManager.sharedMessageHandler().sendMessageTo("\(teacherID)@\(kBaseXMPPURL)", withContents: xmlBody)
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
        
        
        if message.messageType() == kTimeExtended
        {
            if delegate().respondsToSelector(#selector(SSStudentMessageHandlerDelegate.smhDidgetTimeExtendedWithDetails))
            {
                delegate().smhDidgetTimeExtendedWithDetails!(message.messageBody())
            }
        }
        else if message.messageType() == kSeatingChanged
        {
            if delegate().respondsToSelector(#selector(SSStudentMessageHandlerDelegate.smhDidGetSeatingChangedWithDetails))
            {
                delegate().smhDidGetSeatingChangedWithDetails!(message.messageBody())
            }
        }
        else if message.messageType() == kAllowVoiting
        {
            if delegate().respondsToSelector(#selector(SSStudentMessageHandlerDelegate.smhDidGetVotingMessageWithDetails(_:)))
            {
                if message.messageBody() != nil
                {
                    delegate().smhDidGetVotingMessageWithDetails!(message.messageBody())
                }
                
            }
        }

        else if message.messageType() == kTeacherQnASubmitted
        {
            if delegate().respondsToSelector(#selector(SSStudentMessageHandlerDelegate.smhdidReceiveQuestionSentMessage(_:)))
            {
                if message.messageBody() != nil
                {
                    delegate().smhdidReceiveQuestionSentMessage!(message.messageBody())
                }
                
            }
        }
        else if message.messageType() == kTeacherQnADone
        {
            if delegate().respondsToSelector(#selector(SSStudentMessageHandlerDelegate.smhdidReceiveQuestionClearMessage))
            {
                
                delegate().smhdidReceiveQuestionClearMessage!()
            }
        }
        else if message.messageType() == kTeacherQnAFreeze
        {
            if delegate().respondsToSelector(#selector(SSStudentMessageHandlerDelegate.smhdidReceiveQuestionFreezMessage))
            {
                
                delegate().smhdidReceiveQuestionFreezMessage!()
            }
        }
        else if message.messageType() == kReplyToQuery
        {
            if delegate().respondsToSelector(#selector(SSStudentMessageHandlerDelegate.smhdidGetQueryFeedBackFromTeacherWithDetials(_:)))
            {
                
                if message.messageBody() != nil
                {
                    delegate().smhdidGetQueryFeedBackFromTeacherWithDetials!(message.messageBody())
                }
            }
            
        }
        else if message.messageType() == kTeacherReviewDoubt
        {
            if delegate().respondsToSelector(#selector(SSStudentMessageHandlerDelegate.smhdidRecieveQueryReviewmessage))
            {
                delegate().smhdidRecieveQueryReviewmessage!()
            }
            
        }
        else if message.messageType() == kQueryStartedForVolunteer
        {
            if delegate().respondsToSelector(#selector(SSStudentMessageHandlerDelegate.smhdidRecieveQueryOpenedForVotingWithDetails))
            {
                delegate().smhdidRecieveQueryOpenedForVotingWithDetails!()
            }
            
        }
        else if message.messageType() == kEndVolunteeringSession
        {
            if delegate().respondsToSelector(#selector(SSStudentMessageHandlerDelegate.smhdidRecieveQueryVolunteeringEnded))
            {
                delegate().smhdidRecieveQueryVolunteeringEnded!()
            }
            
        }
        else if message.messageType() == kQueryAnswering
        {
            if delegate().respondsToSelector(#selector(SSStudentMessageHandlerDelegate.smhDidRecieveQueryAnsweringMessageWithDetails(_:)))
            {
                
                if message.messageBody() != nil
                {
                   delegate().smhDidRecieveQueryAnsweringMessageWithDetails!(message.messageBody())
                }
                
                
            }
            
        }
        else if message.messageType() == kQueryCloseVoting
        {
            if delegate().respondsToSelector(#selector(SSStudentMessageHandlerDelegate.smhdidRecieveQueryVolunteeringClosedMessageWithDetails(_:)))
            {
                
                if message.messageBody() != nil
                {
                    delegate().smhdidRecieveQueryVolunteeringClosedMessageWithDetails!(message.messageBody())
                }
                
                
            }
            
        }
        else if message.messageType() == kSendPollMessageToStudents
        {
            if delegate().respondsToSelector(#selector(SSStudentMessageHandlerDelegate.smhDidRecievePollingStartedMessageWithDetails(_:)))
            {
                
                if message.messageBody() != nil
                {
                    delegate().smhDidRecievePollingStartedMessageWithDetails!(message.messageBody())
                }
                
                
            }
            
        }
        else if message.messageType() == kSendPollStoppedToStudent
        {
            if delegate().respondsToSelector(#selector(SSStudentMessageHandlerDelegate.smhDidGetPollEndedMessageFromteacher))
            {
                
                delegate().smhDidGetPollEndedMessageFromteacher!()
            }
        }
        else if message.messageType() == kSharegraph
        {
            if delegate().respondsToSelector(#selector(SSStudentMessageHandlerDelegate.smhDidGetGraphSharedWithDetails(_:)))
            {
                
                if message.messageBody() != nil
                {
                   delegate().smhDidGetGraphSharedWithDetails!(message.messageBody())
                }
            }
        }
        else if message.messageType() == kTeacherHandRaiseInReview
        {
            if delegate().respondsToSelector(#selector(SSStudentMessageHandlerDelegate.smhDidGetTeacherReviewMessage))
            {
                
                delegate().smhDidGetTeacherReviewMessage!()
            }
        }
        else if message.messageType() == kSendFeedBack
        {
            if delegate().respondsToSelector(#selector(SSStudentMessageHandlerDelegate.smhDidGetFeedbackForAnswerWithDetils(_:)))
            {
                if message.messageBody() != nil
                {
                    delegate().smhDidGetFeedbackForAnswerWithDetils!(message.messageBody())
                }
                
            }
        }
        else if message.messageType() == kGetPeakView
        {
            if delegate().respondsToSelector(#selector(SSStudentMessageHandlerDelegate.smhDidGetPeakViewMessage))
            {
                delegate().smhDidGetPeakViewMessage!()
                
            }
        }
    }
}



