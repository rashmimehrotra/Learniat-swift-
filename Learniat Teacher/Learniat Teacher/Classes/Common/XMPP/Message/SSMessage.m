//
//  SSMessage.m
//  Learniat Teacher
//
//  Copyright (c) 2014 Mindshift applications and solutions Private Ltd. All rights reserved.
//

//

#import "SSMessage.h"
#import "XMLDictionary.h"

@implementation SSMessage

- (id) init {
	
	self = [super init];
	
	if (self != nil) 
	{
		
	}
	return self;
}

- (id) initWithDict:(NSMutableDictionary *) dict {
	
	self = [super init];
	
	if (self != nil) 
	{
		[self setMessageTo:[dict objectForKey:@"To"]];
		[self setMessageFrom:[dict objectForKey:@"From"]];
		[self setMessageType:[dict objectForKey:@"Type"]];
		[self setMessageBody:[dict objectForKey:@"Body"]];
		[self setMsgDetails:dict];
	}
	return self;
}

- (id) initWithXMLString:(NSString *) xmlStr {

	self = [super init];
	
	if (self != nil)
	{
		id dict = [self parseDataWithString:xmlStr];
		
		[self setMessageTo:[dict objectForKey:@"To"]];
		[self setMessageFrom:[dict objectForKey:@"From"]];
		[self setMessageType:[dict objectForKey:@"Type"]];
		[self setMessageBody:[dict objectForKey:@"Body"]];
		[self setMsgDetails:dict];
	}
	
	return self;
}

- (void) setMsgDetails:(NSMutableDictionary *) details {
	
		
	msgDetails = details ;
}

- (NSMutableDictionary *) msgDetail {

	return msgDetails;
}

- (void) setMessageType:(NSString *) type {
	
	
	
	_msgType = type ;
}

- (NSString *) messageType {
	
	return _msgType;
}

- (void) setMessageBody:(id) body {
	
	
	_messageBody = body ;
}

- (id) messageBody {
	
	return _messageBody;
}

- (void) setMessageSequence:(NSString *) seq {
		
	_messageSequence = seq ;
}

- (NSString *) messageSequence {
	
	return _messageSequence;
}

- (void) setMessageFrom:(NSString *) msgFrm {
	
	_messageFrom = msgFrm ;
}

- (NSString *) messageFrom {
	
	return _messageFrom;
}

- (void) setMessageTo:(NSString *) msgTo {
	
	
	
	_messageTo = msgTo ;
}

- (NSString *) messageTo {
	
	return _messageTo;
}

- (NSString *) XMLMessage {
	
	return [self goRecursively:[self msgDetail] forKey:@"Message"];
}

- (NSMutableString *) goRecursively:(NSDictionary *) dict forKey:(NSString *) key {

	NSMutableString *requestString = [[NSMutableString alloc] initWithCapacity:1];
	
	NSArray *keyArray =  [dict allKeys];
	
	int count = (int)[keyArray count];
	
	[requestString appendString:[NSString stringWithFormat:@"<%@>",key]];
	
	for(NSInteger i = 0 ; i < count ; i++)
	{
		NSString *key = [keyArray objectAtIndex:i];
		id value = [dict objectForKey:key];
		
		if([value isKindOfClass:[NSString class]])
		{
			[requestString appendFormat:@"<%@>%@</%@>",key,value, key];
		}
		else if([value isKindOfClass:[NSNumber class]])
		{
			[requestString appendFormat:@"<%@>%@</%@>",key,value, key];
		}		
		else if([value isKindOfClass:[NSDictionary class]])
		{
			[requestString appendString:[self goRecursively:(NSDictionary *)value forKey:key]];
		}
	}
	
	[requestString appendString:[NSString stringWithFormat:@"</%@>",key]];

	return requestString ;	
}

- (void) processMessage {
	
}

- (NSMutableDictionary*)parseDataWithString:(NSString*)parsingString
{
    
    XMLDictionaryParser *xmlDoc = [[XMLDictionaryParser alloc] init];
    xmlDoc.stripEmptyNodes=NO;
    xmlDoc.trimWhiteSpace=NO;
   NSMutableDictionary* parsedDictornary= [[NSMutableDictionary alloc] initWithDictionary:[xmlDoc dictionaryWithString:parsingString]];
    
    [parsedDictornary removeObjectForKey:@"__name"];
    
    return parsedDictornary;
}

@end
