//
//  PlistDownloder.h
//  Learniat Teacher
//
//  Created by Deepak MK on 16/07/15.
//  Copyright (c) 2015 Mindshift Applications and Solutions Private Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PlistDownloder : NSObject
- (NSMutableDictionary*)returnDictonarywithPlistName:(NSString*)plistName WithUrl:(NSURL*)url;
- (NSMutableDictionary*)returnDictonarywithUrl:(NSURL*)url;
@end
