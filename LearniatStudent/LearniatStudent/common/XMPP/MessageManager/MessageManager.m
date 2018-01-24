#import "MessageManager.h"
#import "LearniatStudent-Swift.h"
#import "DDLog.h"
#import "DDTTYLogger.h"
#import <CFNetwork/CFNetwork.h>
#if DEBUG
static const int ddLogLevel = LOG_LEVEL_VERBOSE;
#else
static const int ddLogLevel = LOG_LEVEL_INFO;
#endif

#define kBaseXMPPURL		@"52.76.85.25"

@interface MessageManager()


@end

static MessageManager *sharedMessageHandler = nil;

@implementation MessageManager

@synthesize xmppStream;
@synthesize xmppRoster;
@synthesize xmppRosterStorage;
@synthesize xmppRoom,xmppReconnect;


#pragma mark - self class Delegate
- (void) setdelegate:(id)delegate
{
    _delgate= delegate;
}
- (id)   delegate
{
    return _delgate;
}



#pragma  mark - custom Functions
+ (MessageManager *) sharedMessageHandler
{
    
    if (sharedMessageHandler == nil)
    {
        sharedMessageHandler = [[super allocWithZone:NULL] init];
    }
    
    return sharedMessageHandler;
}

+ (id)allocWithZone:(NSZone *)zone {
    
    return [self sharedMessageHandler];
}

- (id)copyWithZone:(NSZone *)zone {
    
    return self;
}


#pragma mark - connection setup Functions

/**
 This fuction is used to setup XMPP Stream
 */
- (void)setupStream
{
	
    // Setup xmpp stream
    //
    // The XMPPStream is the base class for all activity.
    // Everything else plugs into the xmppStream, such as modules/extensions and delegates.

	xmppStream = [[XMPPStream alloc] init];
    [xmppStream setHostName:kBaseXMPPURL];
	[xmppStream addDelegate:self delegateQueue:dispatch_get_main_queue()];
    
    
    
//    xmppReconnect = [[XMPPReconnect alloc] init];
//    [xmppReconnect activate:self.xmppStream];
//    [xmppReconnect addDelegate:self delegateQueue:dispatch_get_main_queue()];
//    xmppReconnect.reconnectTimerInterval = 0;
//    xmppReconnect.reconnectDelay = 10 ;
    
	
}

/** 
 This fuction is used to Connect XMPP With userId and Password 
 */
- (BOOL)connectWithUserId:(NSString*)jabberID withPassword:(NSString*)myPassword
{
    
    [self setupStream];
    
    isRegistering=NO;
    
    if (![xmppStream isDisconnected]) {
        return YES;
    }
    
    
    if (jabberID == nil || myPassword == nil) {
        
        return NO;
    }
    
    UIDevice *device = [UIDevice currentDevice];

    
    [xmppStream setMyJID:[XMPPJID jidWithString:jabberID resource:[[device identifierForVendor]UUIDString]]];
    password = myPassword;
    
    NSError *error = nil;
    if (![xmppStream connectWithTimeout:XMPPStreamTimeoutNone error:&error])
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error"
                                                            message:[NSString stringWithFormat:@"Can't connect to server %@", [error localizedDescription]]
                                                           delegate:nil
                                                  cancelButtonTitle:@"Ok" 
                                                  otherButtonTitles:nil];
        [alertView show];
        
        
        return NO;
    }
    
    return YES;
}


- (void) authenticateUserWIthUSerName:(NSString*)userName withPassword:(NSString*)myPassword
{
    
    if ([xmppStream isConnected])
    {
        NSError*error =nil;
        [xmppStream setMyJID:[XMPPJID jidWithString:userName]];
        [xmppStream authenticateWithPassword:myPassword error:&error];
 
    }
    else
    {
        [self connectWithUserId:userName withPassword:myPassword];
    }
   
}


#pragma mark ---Delegate of Connect
/**
 This fuction is called when stream is connected
 */
- (void)xmppStreamDidConnect:(XMPPStream *)sender {
    
    isOpen = YES;
    NSError *error = nil;
    
    NSLog(@"Stream Connected");
    if (!isRegistering)
    {
        if([[self delegate] respondsToSelector:@selector(didGetStreamState:)])
        {
            [[self delegate]didGetStreamState:YES];
        }
        
        [xmppStream authenticateWithPassword:password error:&error];
    }
    else
    {
        [xmppStream registerWithPassword:password error:&error];
    }
    
    
}

/**
 This fuction is called when User is Authenticated
 */
- (void)xmppStreamDidAuthenticate:(XMPPStream *)sender {
    
    
    NSLog(@"Stream Authenticated");
    if([[self delegate] respondsToSelector:@selector(didGetAuthenticationState:)])
    {
        [[self delegate]didGetAuthenticationState:YES];
    }
    AppDelegate* appDelegate = (AppDelegate*)[[UIApplication sharedApplication]delegate];
    
    [appDelegate hideReconnecting];
    
    
    
//    for (int i = 0 ; i< joinedRoomsArray.count; i++)
//    {
//        NSString* roomName = [joinedRoomsArray objectAtIndex:i];
//        [self setUpRoom:roomName WithAdminPrivilage:false withHistoryValue:@"0"];
//        
//    }
    
    
//    if ([xmppStream isAuthenticated]) {
//        NSLog(@"authenticated");
//        xmppvCardStorage = [[XMPPvCardCoreDataStorage alloc] initWithInMemoryStore];
//        xmppvCardTempModule = [[XMPPvCardTempModule alloc] initWithvCardStorage:xmppvCardStorage];
//        [xmppvCardTempModule activate:[self xmppStream]];
//        [xmppvCardTempModule addDelegate:self delegateQueue:dispatch_get_main_queue()];
//        [xmppvCardTempModule fetchvCardTempForJID:[sender myJID] ignoreStorage:YES];
//    }
    
}

- (void)xmppvCardTempModule:(XMPPvCardTempModule *)vCardTempModule didReceivevCardTemp:(XMPPvCardTemp *)vCardTemp forJID:(XMPPJID *)jid{
    
    
//    NSLog(@"Delegate is called");
//    XMPPvCardTemp *vCard = [xmppvCardStorage vCardTempForJID:jid xmppStream:xmppStream];
//    NSLog(@"Stored card: %@",vCard);
//    NSLog(@"%@", vCard.description);
//    NSLog(@"%@", vCard.name);
//    NSLog(@"%@", vCard.emailAddresses);
//    NSLog(@"%@", vCard.formattedName);
//    NSLog(@"%@", vCard.givenName);
//    NSLog(@"%@", vCard.middleName);
    
}

/**
 This fuction is called when User is  not Authenticated
 */
- (void)xmppStream:(XMPPStream *)sender didNotAuthenticate:(NSXMLElement *)error
{

    NSLog(@"Stream Not Authenticated %@", error.stringValue);
    
    if([error.stringValue  isEqual: @"Replaced by new connection"]){
        [self goOnline];
    }
    
    if([[self delegate] respondsToSelector:@selector(didGetAuthenticationState:)])
    {
        if([error.stringValue  isEqual: @"Replaced by new connection"]){
            [[self delegate]didGetAuthenticationState:YES];
        }

        [[self delegate]didGetAuthenticationState:NO];
    }
    

}


#pragma mark - Stream disconnection

/**
 This fuction is used to disconnet user
 */
- (void)disconnect
{
    [self goOffline];
    [xmppStream disconnect];
}

#pragma mark ---Delegate of reconnect
/**
 This fuction is called when XMPP trying to reconnect
 */

- (void)xmppReconnect:(XMPPReconnect *)sender didDetectAccidentalDisconnect:(SCNetworkReachabilityFlags)connectionFlags
{
    AppDelegate* appDelegate = (AppDelegate*)[[UIApplication sharedApplication]delegate];
    
    [appDelegate showReconnectingStream];

    NSLog(@"didDetectAccidentalDisconnect:%u",connectionFlags);
    
    if([[self delegate] respondsToSelector:@selector(didReconnectingWithDelaytime:)])
    {
        [[self delegate] didReconnectingWithDelaytime:xmppReconnect.reconnectDelay];
    }
    
}
- (BOOL)xmppReconnect:(XMPPReconnect *)sender shouldAttemptAutoReconnect:(SCNetworkReachabilityFlags)reachabilityFlags
{
    NSLog(@"shouldAttemptAutoReconnect:%u %f %f",reachabilityFlags,sender.reconnectTimerInterval,xmppReconnect.reconnectDelay);
    
    return YES;
}


#pragma mark ---Delegate of disconnect
/**
 This fuction is called when stream is disConnected
 */
- (void)xmppStreamDidDisconnect:(XMPPStream *)sender withError:(NSError *)error
{
    NSLog(@"Stream Disconnected");
    if([[self delegate] respondsToSelector:@selector(didGetStreamState:)])
    {
        [[self delegate]didGetStreamState:NO];
    }
}


#pragma mark - setting presence

/** 
 This fuction is used change the presence to online 
 */
- (void)goOnline
{
	XMPPPresence *presence = [XMPPPresence presence];
	[xmppStream sendElement:presence];
    [[self delegate]gotOnline];
}

/**
 This fuction is used change the presence to Ofline 
 */
- (void)goOffline
{
	XMPPPresence *presence = [XMPPPresence presenceWithType:@"unavailable"];
	[xmppStream sendElement:presence];
}

/**
 This fuction is used change the presence to Active
 */
- (void)goActive
{
    XMPPPresence *presence = [XMPPPresence presenceWithType:@"active"];
    [xmppStream sendElement:presence];
}

/**
 This fuction is used change the presence to Retry Active
 */
- (void)goRetryActive
{
    XMPPPresence *presence = [XMPPPresence presenceWithType:@"retry-active"];
    [xmppStream sendElement:presence];
}

/**
 This fuction is used change the presence substate
 */
- (void) presenceWithStubState:(NSString*)subState
{
    XMPPPresence *presence = [XMPPPresence presence];// type="available" is implicit
    
    NSXMLElement *status = [NSXMLElement elementWithName:@"status"];
    [status setStringValue:subState];
    [presence addChild:status];
    
    [xmppStream sendElement:presence];
}

/**
 This fuction is called when other user state is changed
 */
- (void)xmppStream:(XMPPStream *)sender didReceivePresence:(XMPPPresence *)presence
{
    DDLogVerbose(@"%@: %@ - %@", THIS_FILE, THIS_METHOD, [presence fromStr]);
    
    
    NSString *presenceType = [presence type];            // online/offline
    NSString *myUsername = [[sender myJID] user];
    XMPPJID *jid = [presence from];
    NSString *presenceFromUser = [[presence from] user];
    NSString* presenceState= [presence status];
    
//    NSLog(@"%@  is %@ state %@",presenceFromUser,presenceType,presenceState);
    
    
   
    
    if (![presenceFromUser isEqualToString:myUsername])
    {
        
        if ([presenceType isEqualToString:@"available"])
        {
            if([[self delegate] respondsToSelector:@selector(didRecievePresence:withUserName:WithSubState:)])
            {
                [[self delegate] didRecievePresence:presenceType withUserName:presenceFromUser WithSubState:presenceState];
            }
            
        }
        
        else if  ([presenceType isEqualToString:@"unavailable"]) {
            
             if([[self delegate] respondsToSelector:@selector(didRecievePresence:withUserName:WithSubState:)])
             {
                 [[self delegate] didRecievePresence:presenceType withUserName:presenceFromUser WithSubState:presenceState];
             }
            
        }
        else if  ([presenceType isEqualToString:@"subscribe"])
        {
            
            [xmppRoster subscribePresenceToUser:[presence from]];
            [self goOnline];
        }
        else if  ([presenceType isEqualToString:@"subscribed"])
        {
            [xmppRoster subscribePresenceToUser:[presence from]];
        }
        
    }
    else{
        if([[self delegate] respondsToSelector:@selector(didRecievePresenceSelf:withUserName:WithSubState:WithSenderJid:)])
        {
            [[self delegate] didRecievePresenceSelf:presenceType withUserName:presenceFromUser WithSubState:presenceState WithSenderJid:jid];

        }

    }
    if (xmppRoom)
    {
        [xmppRoom fetchMembersList];
    }
    
    
}

#pragma mark - subscription
- (void) sendSubscribeMessageToUser:(NSString*)userID
{
    XMPPJID* jbid=  [XMPPJID jidWithString:userID];
    XMPPPresence *presence = [XMPPPresence presenceWithType:@"subscribe" to:jbid];
    [xmppStream sendElement:presence];
}


#pragma mark - XMPP delegates
/**
 This fuction is called when new IQ is received 
 */
- (BOOL)xmppStream:(XMPPStream *)sender didReceiveIQ:(XMPPIQ *)iq {
	
	return NO;
	
}



#pragma mark - RegistrationFunction

/**
 This fuction is user to retister new user
   if stream is connected the it will directly call registeration function
    otherwise it will connect stream and then call registeration process 
 */

- (void)registerStudentWithUserName:(NSString *)userName withPassword:(NSString *)_password withEmailId:(NSString *)EmailId
{
    
    if (xmppStream==nil)
    {
        [self setupStream];
    }
    
    
    [xmppStream setMyJID:[XMPPJID jidWithString:userName]];
//    NSLog(@"Attempting registration for username %@",xmppStream.myJID.bare);
    password=_password;
    NSError *error = nil;
    BOOL success;
    
    if(![ xmppStream isConnected])
    {
         success = [[self xmppStream] connectWithTimeout:XMPPStreamTimeoutNone error:&error];
        isRegistering=YES;
    }
    else
    {
        success = [[self xmppStream] registerWithPassword:_password error:&error];
    }
    
    if (success)
    {
//        NSLog(@"succeed ");
        isRegistering=YES;
    }
    else
    {
        if([[self delegate] respondsToSelector:@selector(didGetRegistrationState:WithErrorMessage:)])
        {
            [[self delegate]didGetRegistrationState:YES WithErrorMessage:@"Stream not connected"];
        }
    }

}

#pragma mark ---delegates of registrtaion


/**
 This fuction is called when new user is registered 
 */
- (void)xmppStreamDidRegister:(XMPPStream *)sender{
    
    
    
    
    if([[self delegate] respondsToSelector:@selector(didGetRegistrationState:WithErrorMessage:)])
    {
        [[self delegate]didGetRegistrationState:YES WithErrorMessage:@"Registration with XMPP Successful!"];
    }
    
    
}


/**
 This fuction is called when registeration process failed 
 */
- (void)xmppStream:(XMPPStream *)sender didNotRegister:(NSXMLElement *)error{
    
//    DDXMLElement *errorXML = [error elementForName:@"error"];
//    NSString *errorCode  = [[errorXML attributeForName:@"code"] stringValue];
    
//    NSString *regError = [NSString stringWithFormat:@"ERROR :- %@",error.description];
//    
//    
//    if([errorCode isEqualToString:@"409"])
//    {
//        regError=@"Username Already Exists!";
//    }
//    else
//    {
//        regError= @"Server not connected";
//    }
    if([[self delegate] respondsToSelector:@selector(didGetRegistrationState:WithErrorMessage:)])
    {
        [[self delegate]didGetRegistrationState:NO WithErrorMessage:@"Username Already Exists!"];
    }

}



#pragma mark - send  and recieve message
/**
 This fuction is used to send message to other user with contents of body
 */



//-(void)sendMessageTo:(NSString*)toAdress withContents:(NSString*)messageStr
//{
//    
//    
//    if([messageStr length]> 0)
//    {
//        
//        NSXMLElement *body = [NSXMLElement elementWithName:@"body"];
//        [body setStringValue:messageStr];
//        
//        NSXMLElement *message = [NSXMLElement elementWithName:@"message"];
//        [message addAttributeWithName:@"type" stringValue:@"chat"];
//        [message addAttributeWithName:@"to" stringValue:toAdress];
//        [message addChild:body];
//        
//        [self.xmppStream sendElement:message];
//    }
//}



- (BOOL)sendMessageTo:(NSString*)toAdress withContents:(NSString*)content
{
   
    if([content length]> 0)
    {
        
        NSXMLElement *body = [NSXMLElement elementWithName:@"body"];
        [body setStringValue:content];
        
        NSXMLElement *message = [NSXMLElement elementWithName:@"message"];
        [message addAttributeWithName:@"type" stringValue:@"chat"];
        [message addAttributeWithName:@"to" stringValue:toAdress];
        [message addChild:body];
        
        [self.xmppStream sendElement:message];
    }
    return YES;
}

#pragma mark  recieve message
/**
 This fuction is called when new message arrived
 */

- (void)xmppStream:(XMPPStream *)sender didReceiveMessage:(XMPPMessage *)message
{
    DDLogVerbose(@"%@: %@", THIS_FILE, THIS_METHOD);
    
    // A simple example of inbound message handling.
    if ([message body])
    {
        NSString *body = [[message elementForName:@"body"] stringValue];
        
        if([[self delegate] respondsToSelector:@selector(didReceiveMessageWithBody:WithSenderJid:)])
        {
            [[self delegate] didReceiveMessageWithBody:body WithSenderJid:message.from];
            
        }
        
    }
    
    if ([message subject]){
        NSString *subject = [[message elementForName:@"subject"] stringValue];
        
        if([[self delegate] respondsToSelector:@selector(didReceiveMessageWithSubject:WithSenderJid:)])
        {
            [[self delegate] didReceiveMessageWithSubject:subject WithSenderJid:message.from];
            
        }
    }
}



#pragma mark - create new room

/**
 This fuction is used to setup room with roomId
 */
- (void) setUpRoom:(NSString *)ChatRoomJID WithAdminPrivilage:(BOOL)admin withHistoryValue:(NSString*)value withTeacherJID:(NSString *) teacherJID
{
    
    NSXMLElement*privilage= [NSXMLElement elementWithName:@"x" xmlns:XMPPMUCNamespace];
    if (admin)
    {
        privilage= [NSXMLElement elementWithName:@"x" xmlns:XMPPMUCOwnerNamespace];
    }
    else
    {
        privilage= [NSXMLElement elementWithName:@"x" xmlns:XMPPMUCNamespace];
    }
    if (!ChatRoomJID)
    {
        return;
    }
    
    if (![ChatRoomJID containsString:[NSString stringWithFormat:@"@conference.%@",kBaseXMPPURL]])
    {
        ChatRoomJID = [NSString stringWithFormat:@"%@@conference.%@",ChatRoomJID,kBaseXMPPURL];
    }
    
    // Configure xmppRoom
    XMPPRoomMemoryStorage *roomMemoryStorage = [[XMPPRoomMemoryStorage alloc] init];
    
    XMPPJID *roomJID = [XMPPJID jidWithString:ChatRoomJID];
    
    xmppRoom = [[XMPPRoom alloc] initWithRoomStorage:roomMemoryStorage jid:roomJID dispatchQueue:dispatch_get_main_queue()];
    
    [xmppRoom activate:xmppStream];
    [xmppRoom addDelegate:self delegateQueue:dispatch_get_main_queue()];
    
    NSXMLElement *history = [NSXMLElement elementWithName:@"history"];
    [history addAttributeWithName:@"maxstanzas" stringValue:value];
    [xmppRoom joinRoomUsingNickname:xmppStream.myJID.user    history:history  password:nil withPrivilage:privilage];
    
    
    
    [self performSelector:@selector(ConfigureNewRoom:) withObject:nil afterDelay:4];
    
}

/**
 This fuction is used configure new
 */
- (void)ConfigureNewRoom:(id)sender
{
    
//    if (xmppStream.isConnected)
    {
        [xmppRoom configureRoomUsingOptions:nil];
        [xmppRoom fetchConfigurationForm];
        [xmppRoom fetchBanList];
        [xmppRoom fetchMembersList];
        [xmppRoom fetchModeratorsList];
    }
   
    
}

/**
 This fuction is called when new room is created
 */
- (void)xmppRoomDidCreate:(XMPPRoom *)sender
{
    DDLogInfo(@"%@: %@", THIS_FILE, THIS_METHOD);
    
    if([[self delegate] respondsToSelector:@selector(didCreateRoom:)])
    {
        [[self delegate] didCreateRoom:sender];
    }
    // I am inviting friends after room is created
    
    
}

/**
 This fuction is called when user joined room
 */
- (void)xmppRoomDidJoin:(XMPPRoom *)sender
{
//    [sender fetchMembersList];
//    [sender fetchConfigurationForm];
//    [self requestAllMesssage];
    
    if (!joinedRoomsArray)
    {
        joinedRoomsArray= [[NSMutableArray alloc] init];
    }
    
    [joinedRoomsArray addObject:sender.myRoomJID.bare];
    
    
    DDLogInfo(@"%@: %@", THIS_FILE, THIS_METHOD);
    if([[self delegate] respondsToSelector:@selector(didCreatedOrJoinedRoomWithCreatedRoomName:)])
    {
        [[self delegate] didCreatedOrJoinedRoomWithCreatedRoomName:sender.myRoomJID.bare];
    }
    
}
- (void) editRoomPrevilageWithUser:(NSString*)user
{
    [xmppRoom editRoomPrivileges:@[[XMPPRoom itemWithAffiliation:@"owner" jid:[XMPPJID jidWithString:user]]]];
}

- (void) editRoomPrevilageWithUser:(NSString*)user withXMPPRoom:(XMPPRoom *)room{
    [room editRoomPrivileges:@[[XMPPRoom itemWithAffiliation:@"owner" jid:[XMPPJID jidWithString:user]]]];
}

- (void)xmppRoom:(XMPPRoom *)sender didFetchMembersList:(NSArray *)items
{
    
}

- (void)xmppRoom:(XMPPRoom *)sender occupantDidJoin:(XMPPJID *)occupantJID withPresence:(XMPPPresence *)presence
{
    if([[self delegate] respondsToSelector:@selector(didGetUserJoinedToRoomORLeaveRoomWithName:WithPresence:)])
    {
//        id details =occupantJID;
//        NSString* string = (NSString*)details;
         [[self delegate] didGetUserJoinedToRoomORLeaveRoomWithName:[occupantJID resource] WithPresence:[presence type]];
    }
   
}
- (void)xmppRoom:(XMPPRoom *)sender occupantDidLeave:(XMPPJID *)occupantJID withPresence:(XMPPPresence *)presence
{
    if([[self delegate] respondsToSelector:@selector(didGetUserJoinedToRoomORLeaveRoomWithName:WithPresence:)])
    {
        [[self delegate] didGetUserJoinedToRoomORLeaveRoomWithName:[occupantJID resource] WithPresence:[presence type]];
    }
}

- (void)xmppRoomDidLeave:(XMPPRoom *)sender
{
    
}

- (void)xmppRoomDidDestroy:(XMPPRoom *)sender
{
//    if([joinedRoomsArray containsObject:sender.roomJID.bare])
//    {
//        [joinedRoomsArray removeObject:sender.roomJID.bare];
//    }
}

- (void) removeIfRoomPresentWithRoomId:(NSString*)roomId
{
    if([joinedRoomsArray containsObject:[NSString stringWithFormat:@"%@@conference.%@",roomId,kBaseXMPPURL]])
    {
        [joinedRoomsArray removeObject:[NSString stringWithFormat:@"%@@conference.%@",roomId,kBaseXMPPURL]];
    }
}

- (void)xmppRoom:(XMPPRoom *)sender occupantDidUpdate:(XMPPJID *)occupantJID withPresence:(XMPPPresence *)presence
{
    if([[self delegate] respondsToSelector:@selector(didGetUserJoinedToRoomORLeaveRoomWithName:WithPresence:)])
    {
        [[self delegate] didGetUserJoinedToRoomORLeaveRoomWithName:[occupantJID resource] WithPresence:[presence type]];
    }
}

- (void) sendInviteToRoomwithUserId:(NSString*)userId
{
    [xmppRoom inviteUser:[XMPPJID jidWithString:userId] withMessage:@"Greetings!"];
}


- (void) requestAllMesssage
{
    
//    <presence
//    from='hag66@shakespeare.lit/pda'
//    id='n13mt3l'
//    to='coven@chat.shakespeare.lit/thirdwitch'>
//    <x xmlns='http://jabber.org/protocol/muc'>
//    <history since='1970-01-01T00:00:00Z'/>
//    </x>
//    </presence>
//    
//    NSXMLElement *iQ = [NSXMLElement elementWithName:@"presence"];
//    [iQ addAttributeWithName:@"type" stringValue:@"get"];
//    [iQ addAttributeWithName:@"id" stringValue:@"n13mt3l"];
//    
//    NSXMLElement *retrieve = [NSXMLElement elementWithName:@"retrieve"];
//    [retrieve addAttributeWithName:@"xmlns" stringValue:@"urn:xmpp:archive"];
//    [retrieve addAttributeWithName:@"history since" stringValue:@"1970-01-01T00:00:00Z"];
//    
//    NSXMLElement *set = [NSXMLElement elementWithName:@"set"];
//    [set addAttributeWithName:@"xmlns" stringValue:@"http://jabber.org/protocol/muc"];
//    
//    [retrieve addChild:set];
//    [iQ addChild:retrieve];
//    
//    [xmppStream sendElement:iQ];
   
    
    
    
}

- (void)xmppRoom:(XMPPRoom *)sender didFetchConfigurationForm:(NSXMLElement *)configForm
{
    DDLogInfo(@"%@: %@", THIS_FILE, THIS_METHOD);
    
    NSXMLElement *newConfig = [configForm copy];
    NSArray *fields = [newConfig elementsForName:@"field"];
    
    for (NSXMLElement *field in fields)
    {
        NSString *var = [field attributeStringValueForName:@"var"];
        
        // Make Room Persistent
        if ([var isEqualToString:@"muc#roomconfig_persistentroom"])
        {
            
            [field removeChildAtIndex:0];
            [field addChild:[NSXMLElement elementWithName:@"value" stringValue:@"1"]];
        }
        
        if ([var isEqualToString:@"roomconfig_enablelogging"])
        {
            
            [field removeChildAtIndex:0];
            [field addChild:[NSXMLElement elementWithName:@"value" stringValue:@"1"]];
        }
        
        if ([var isEqualToString:@"muc#roomconfig_maxusers"])
        {
            
            [field removeChildAtIndex:0];
            [field addChild:[NSXMLElement elementWithName:@"value" stringValue:@"100"]];
        }
        
        
    }
    //    [sender configureRoomUsingOptions:newConfig];
}

/**
 This fuction is used to destroy created room
 */
- (void) destroyCreatedRoom
{
    [xmppRoom destroyRoom];
    
}


- (BOOL)sendGroupMessageWithBody:(NSString*)_body withRoomId:(NSString*)roomId
{

    if([_body length]> 0)
    {
        
        NSXMLElement *body = [NSXMLElement elementWithName:@"body"];
        [body setStringValue:_body];
        
        NSXMLElement *message = [NSXMLElement elementWithName:@"message"];
        [message addAttributeWithName:@"to" stringValue:roomId];
        [message addAttributeWithName:@"type" stringValue:@"groupchat"];
        [message addChild:body];
        
        [self.xmppStream sendElement:message];
    }
    
    
    
//    [xmppRoom sendMessageWithBody:_body];
    return YES;
}


@end
