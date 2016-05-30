    //
//  PlistDownloder.m
//  Learniat Teacher
//
//  Created by Deepak MK on 16/07/15.
//  Copyright (c) 2015 Mindshift Applications and Solutions Private Ltd. All rights reserved.
//

#import "PlistDownloder.h"

@implementation PlistDownloder

- (NSMutableDictionary*)returnDictonarywithPlistName:(NSString*)plistName WithUrl:(NSURL*)url
{
    NSString *imagePath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:[NSString stringWithFormat:@"/%@",plistName]];
    
    //********  Write File To sandBox ********* //
    
    
    NSData *imageData = [NSData dataWithContentsOfURL:url];
    [imageData writeToFile:imagePath atomically:YES];
    
    
    NSMutableDictionary*  studentsListDetails = [[NSMutableDictionary alloc]initWithContentsOfFile:imagePath];
    
    return studentsListDetails;
}


- (NSMutableDictionary*)returnDictonarywithUrl:(NSURL*)url
{
    NSMutableDictionary*  studentsListDetails = [[NSMutableDictionary alloc]initWithContentsOfURL:url];
    
    return studentsListDetails;
}

@end
