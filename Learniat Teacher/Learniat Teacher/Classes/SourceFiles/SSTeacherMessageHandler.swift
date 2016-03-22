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

let kMTimeExtended          =   "180"
let kMSeatingChanged        =   "195"
let kMTeacherEndsSession    =   "706"
let kMQuestionLabel         =   "170"
let kMAllowVoiting          =   "173"
let kLiveClassRoomName      =   "723"
let kTeacherQnASubmitted    =   "231"
let kStudentSentBenchState  =   "220"
let kTeacherQnADone         =   "233"
let kStudentSendAnswer      =   "321"
let kDontKnow               =   "710"
let kTeacherQnAFreeze       =   "232"
let kSharegraphToIphone     =   "724"
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




import Foundation

@objc protocol SSTeacherMessageHandlerDelegate
{
    optional func smhDidRecieveStreamConnectionsState(state:Bool)
    
    optional  func smhDidReciveAuthenticationState(state:Bool, WithName userName:String)
    
//    // MARK: - ScheduleScreen Delegates
//    
//    optional func smhDidGetTimeExtendedMessageWithDetails(details:AnyObject)
//    
//    optional func smhDidGetSessionEndMessageWithDetails(details:AnyObject)
//   
//    optional func smhDidGetSeatingChangedWithDetails(details:AnyObject)
//    
//    optional func smhDidGetTopicStateMessageWithDetails(details:AnyObject)
//    
//    optional func smhDidGetTopicAndQuestionMessageWithDetails(details:AnyObject)
//    
//    optional func smhdidRecieveLiveClassRoomInvitationWithRoomName(roomName :String)
//    
//    optional func smhdidReceiveQuestionSentMessage(dict: AnyObject)
//    
//    optional func smhdidReceiveQuestionClearMessage()
//    
//    optional func smhdidReceiveQuestionFreezMessage()
//    
//    optional func smhdidReceiveGraphWithDetails(dict: AnyObject)
//    
//    optional func smhdidReceiveAnswerEvaluatingMessage()
//    
//    optional func smhdidGetAnswerFeedBackFromTeacherWithDetials(details : AnyObject)
//    
//    optional func smhdidGetQueryFeedBackFromTeacherWithDetials(details : AnyObject)
//    
//    optional func smhdidRecieveQueryOpenedForVotingWithDetails()
//    
//    optional func smhdidRecieveQueryVolunteeringEnded()
//    
//    optional func smhdidRecieveStudentAnsweringMessagewithQueryId(details:AnyObject)
//    
//    optional func smhdidRecieveGivemeAnswermessagewithQueryId(details:AnyObject)
//    
//    optional func smhdidRecieveQueryReviewmessage()
//    
//    optional func smhdidRecieveTeacherReplayForVolnteer(details:AnyObject)
//    
//    optional func smhdidRecieveQueryCloseVotingMessageFromTeacher()
//    
//    optional func smhDidGetPollStartedMessageFormTeacherWithDetails(details:AnyObject)
//    
//    optional func smhDidGetPollEndedMessageFromteacher()
//    
//    optional func smhdidRecieveCollabarationQuestionMessageFromTeacherWithCategory(category:AnyObject)
//    
//    optional func smhdidRecieveCollabarationClosedMessage()
//    
//    optional func smhdidRecieveModelAnswerMessageWithDetials(details:AnyObject)
    
    
}

public class SSTeacherMessageHandler:NSObject,SSTeacherMessageHandlerDelegate,MessageManagerDelegate {
    
    var _delgate: AnyObject!
    var currentUserName:String!
   
    var joinedRoomsArray :NSMutableArray = NSMutableArray()
    
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
    func connectWithUserId(userID:String, andWithPassword password:String, withDelegate delegate:SSTeacherMessageHandlerDelegate)
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
        if delegate().respondsToSelector(Selector("smhDidRecieveStreamConnectionsState:"))
        {
            delegate().smhDidRecieveStreamConnectionsState!(state)
        }
        

    }
    public func didGetAuthenticationState(state:Bool)
    {
         if delegate().respondsToSelector(Selector("smhDidReciveAuthenticationState:WithName:"))
         {
            delegate().smhDidReciveAuthenticationState!(state, WithName: getCurrentUSerName())
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
        
        
//        MessageManager.sharedMessageHandler().editRoomPrevilageWithUser(("496@\(kBaseXMPPURL)"))
        
        
        
    }
    
    
    
    func didGetUserJoinedToRoomORLeaveRoomWithName(_userName: String!, withPresence presence: String!)
    {
        
        if joinedRoomsArray.containsObject(_userName)
        {
            joinedRoomsArray.addObject(_userName);
        }
    }
    
    
    
    //MARK: Send  Message
    
    
    
    //MARK: Recieve Message
    public func didReceiveMessageWithBody(body: String!)
    {
        
        let message = SSMessage.init(XMLString: body)
        
        
        if message.messageType() == nil
        {
            return
        }
        
        
        
    }
}



