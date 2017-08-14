//
//  JabberClientAppDelegate.h
//  JabberClient
//
//  Created by Deepak MK on 27/11/15.
//  Copyright © 2015 mindShiftApps. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "XMPP.h"
#import <CoreData/CoreData.h>
#import "XMPPFramework.h"
#import "XMPPMessageDeliveryReceipts.h"
#import "XMPPLastActivity.h"
#import "XMPPRosterMemoryStorage.h"
#import "XMPPRoomMemoryStorage.h"
#import "XMPPvCardCoreDataStorage.h"
#import "XMPPvCardTemp.h"
#import "XMPPPing.h"
/**
 message manager class manage all message sequence.
 */
@interface MessageManager : NSObject
{
	
	XMPPStream                                  *xmppStream;
		
	NSString                                    *password;
	
	BOOL                                        isOpen;
	
    BOOL                                        isRegistering;
    
    id                                          _delgate;
    
    XMPPRosterCoreDataStorage					*xmppRosterStorage;
    
    XMPPRoster                                  *xmppRoster;
    
    XMPPvCardCoreDataStorage                    *xmppvCardStorage;

    XMPPvCardTempModule                         *xmppvCardTempModule;
    
    NSMutableArray                              *joinedRoomsArray;


	 
}

+ (MessageManager *) sharedMessageHandler;

/**
 The stream varible for connecting stream
 */

@property (nonatomic, readonly) XMPPStream          *xmppStream;

/**
 XMPPRoster  varible
 */
@property (nonatomic, strong,readonly) XMPPRoster *xmppRoster;

/**
 XMPPRosterCoreDataStorage  varible 
 */
@property (nonatomic, strong,readonly) XMPPRosterCoreDataStorage *xmppRosterStorage;

/**
 XMPPRoom  varible
 */
@property (nonatomic, strong, readonly)  XMPPRoom *xmppRoom;


/**
 XMPPReconnect  varible
 */
@property (nonatomic, readonly) XMPPReconnect *xmppReconnect;


/**
 Setting of delegate
 @param delegate class delegate
 */
- (void) setdelegate:(id)delegate;

/**
 Return of delegate
 */
- (id)   delegate;

/**
 connecting stream of Xmpp server
 */

- (void) setupStream;

/**
 Connect user to Xmpp server
 @param jabberID    login user name
 @param myPassword  login password
 */
- (BOOL)connectWithUserId:(NSString*)jabberID withPassword:(NSString*)myPassword;

/**
 Connect user to Xmpp server
 @param userName    login user name
 @param myPassword  login password
 */
- (void) authenticateUserWIthUSerName:(NSString*)userName withPassword:(NSString*)myPassword;


/**
 disconnect user from Xmpp server
 */
- (void) disconnect;

/**
 changes the presence to online
 */
- (void) goOnline;

/**
 changes the presence to offline
 */
- (void) goOffline;

/**
 changes the presence to active
 */
- (void) goActive;

/**
 changes the presence to retryActive
 */
- (void) goRetryActive;



/**
 Register new user to xmpp server
 @param userName    new user name
 @param _password   new password
 @param EmailId     new email id
 */
- (void)registerStudentWithUserName:(NSString *)userName withPassword:(NSString *)_password withEmailId:(NSString *)EmailId;


/**
 send message to other user with content
 @param toAdress destination address
 @param content  content of message
 */
- (BOOL)sendMessageTo:(NSString*)toAdress withContents:(NSString*)content;



/**
 This method is used for sending subscribe invitation to user
 @param userID destination address
 */
- (void) sendSubscribeMessageToUser:(NSString*)userID;


/**
 This method is used for setting substate of presence
 @param subState substate of user
 */
- (void) presenceWithStubState:(NSString*)subState;


/**
 This method is used to create new room
 @param ChatRoomJID New room name
 */
- (void) setUpRoom:(NSString *)ChatRoomJID WithAdminPrivilage:(BOOL)admin withHistoryValue:(NSString*)value;


/**
 This method is used to destroyRoom
 */
- (void) destroyCreatedRoom;


- (void)destroyRoom:(NSString *)ChatRoomJID;

/**
 This method is used to send message to group
 */
- (BOOL)sendGroupMessageWithBody:(NSString*)_body withRoomId:(NSString*)roomId;


- (BOOL)sendGroupMessageWithSubject:(NSString*)_subject withRoomId:(NSString*)roomId;

- (void) requestAllMesssage;


- (void) editRoomPrevilageWithUser:(NSString*)user;


- (void) removeIfRoomPresentWithRoomId:(NSString*)roomId;


- (void) sendInviteToRoomwithUserId:(NSString*)userId;

@end





/**
 Set of methods to be implemented to act as a restaurant patron
 */
@protocol MessageManagerDelegate <NSObject>

/**
 Methods to be get state of stream
 */
@optional
- (void) didGetStreamState:(BOOL)state;

/**
 Methods to be get state of Authentication
 */

@optional - (void) didGetAuthenticationState:(BOOL)state;

/**
 Methods to be get state of registration
 */

@optional - (void) didGetRegistrationState:(BOOL)state WithErrorMessage:(NSString*)errorMessage;

/**
 Methods to get recieved message
 */

@optional - (void) didReceiveMessageWithBody:(NSString *)body WithSenderJid:(XMPPJID*)senderJid;

/**
 Methods to get presence of other user
 */
@optional - (void) didRecievePresence:(NSString*)state withUserName:(NSString*)userName WithSubState:(NSString*)subState;


/**
 Methods to get presence of other self clone
 */

@optional - (void) didRecievePresenceSelf:(NSString*)state withUserName:(NSString*)userName WithSubState:(NSString*)subState WithSenderJid:(XMPPJID *)senderJid;




/**
 Methods to get event of user joined room
 */
@optional - (void) didCreatedOrJoinedRoomWithCreatedRoomName:(NSString*)_roomName;


@optional - (void) didGetUserJoinedToRoomORLeaveRoomWithName:(NSString*)_userName WithPresence:(NSString*)presence;


@optional - (void) didReconnectingWithDelaytime:(int)delayTime;

@optional
- (void) gotOnline;


@end




