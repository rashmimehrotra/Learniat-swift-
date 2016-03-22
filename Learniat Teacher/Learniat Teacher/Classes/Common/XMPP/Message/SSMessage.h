//
//  SSMessage.h
//  Learniat Teacher
//
//  Copyright (c) 2014 Mindshift applications and solutions Private Ltd. All rights reserved.//
//

#import <Foundation/Foundation.h>
#import "Messages.h"

@interface SSMessage : NSObject {

	NSString				  *_msgType;
	NSString			  *_messageFrom;
	NSString				*_messageTo;
	id					   _messageBody;
	NSString		  *_messageSequence;
	NSMutableDictionary		*msgDetails;
}

- (void) setMsgDetails:(NSMutableDictionary *) details;
- (NSMutableDictionary *) msgDetail;

- (void) setMessageType:(NSString *) type;
- (NSString *) messageType;

- (void) setMessageBody:(id) body;
- (id) messageBody;

- (void) setMessageSequence:(NSString *) seq;
- (NSString *) messageSequence;

- (void) setMessageFrom:(NSString *) msgFrm ;
- (NSString *) messageFrom;

- (void) setMessageTo:(NSString *) msgTo;
- (NSString *) messageTo;

- (id) initWithDict:(NSMutableDictionary *) dict;
- (id) initWithXMLString:(NSString *) xmlStr;

- (void) processMessage;
- (NSString *) XMLMessage;

- (NSMutableString *) goRecursively:(NSDictionary *) dict forKey:(NSString *) key;

@end
