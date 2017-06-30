//
//  APIManager.h
//  APIManager
//
//  Created by mindshift_Deepak on 17/11/15.
//  Copyright © 2015 mindShiftApps. All rights reserved.
//

#import <Foundation/Foundation.h>
@protocol APIManagerDelegate;
typedef enum {
    
    eHTTPGetRequest,
//    eHTTPPostRequest,
//    eHTTPMultiPartPostRequest,
//    eHTTPPutRequest,
//    eHTTPDeleteRequest,

}eHTTPRequestType;

@interface APIManager : NSObject<NSXMLParserDelegate>
{
   NSMutableData        *receivedData;
    
    id					 _delegate;
    
    NSString            *currentServiceName;
    
    NSString            *currentUrlString;
    
    eHTTPRequestType    currentRequestType;

    NSURLConnection     *connection;
    
    NSMutableDictionary *parsedDictornary;
    
    NSString            *fullresposeString;
    
    id                  _retruningDelegate;
    
}

-   (id) delegate;

- (id) returingDelegate;

-(void)downloadDataURL:(NSString *)urlString WithServiceName:(NSString*)serviceName withDelegate:(id)del withRequestType:(eHTTPRequestType)requestType withReturningDelegate:(id)returningDelegate;



-(void)downloadJsonWithURL:(NSString *)urlString WithServiceName:(NSString*)serviceName withDelegate:(id)del withRequestType:(eHTTPRequestType)requestType withReturningDelegate:(id)returningDelegate;


- (NSMutableDictionary*)parseDataWithString:(NSString*)parsingString;

- (void) retrySameApiAgain;

@end

@protocol APIManagerDelegate <NSObject>

// @optional - (void) delegateDidGetServiceErrorMessage:(NSString*)message WithServiewName:(NSString*)serviceName WithRetryController:(APIManager*)manager;

@optional - (void)delegateDidGetServiceResponseWithDetails:(NSMutableDictionary*)dict WIthServiceName:(NSString*)serviceName withRetruningDelegate:(id)returningDelegate;


- (void) delegateServiceErrorMessage:(NSString*)message withServiceName:(NSString*)ServiceName withErrorCode:(NSString*)code withRetruningDelegate:(id)returningDelegate;

@end
