//
//  APIManager.m
//  APIManager
//
//  Created by mindshift_Deepak on 17/11/15.
//  Copyright © 2015 mindShiftApps. All rights reserved.
//

#import "APIManager.h"
#import "XMLDictionary.h"
#import "Reachability.h"
#import "NoInternetView.h"
@implementation APIManager

#pragma mark - Delegate
- (id) delegate
{
    
    return _delegate;
}


-(void)downloadDataURL:(NSString *)urlString WithServiceName:(NSString*)serviceName withDelegate:(id)del withRequestType:(eHTTPRequestType)requestType
{

    _delegate = del;
    
    
//    NSLog(@"API recieved %@",urlString);

    currentServiceName=serviceName;
    currentRequestType=requestType;
    currentUrlString=urlString;

    urlString=[self encodeURIComponent:urlString];
    NSMutableURLRequest* actualURLRequest = nil;
       // Create the request.
    actualURLRequest = [[NSMutableURLRequest alloc] init];
	[actualURLRequest setTimeoutInterval:30.0];
    
    switch (requestType)
    {
        case eHTTPGetRequest:
        {
                   
//            urlString= [NSString stringWithFormat:@"%@",kBaseUrl,urlString];
            [actualURLRequest setURL:[NSURL URLWithString:urlString]];
            [actualURLRequest setHTTPMethod:@"GET"];
            
            break;
        }
    }
    
    
  
    

    
    // create the connection with the request
    // and start loading the data
    
   connection=[[NSURLConnection alloc] initWithRequest:actualURLRequest delegate:self startImmediately:YES];
    if( connection )
    {
        receivedData = [[NSMutableData alloc] init];
    }
    else
    {

    }
}

- (void) retrySameApiAgain
{
    [self downloadDataURL:currentUrlString WithServiceName:currentServiceName withDelegate:_delegate withRequestType:currentRequestType];
}

#pragma mark NSURLConnection Delegate Methods

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    // This method is called when the server has determined that it
    // has enough information to create the NSURLResponse object.
    
    // It can be called multiple times, for example in the case of a
    // redirect, so each time we reset the data.
    
    // receivedData is an instance variable declared elsewhere.
    [receivedData setLength:0];
}


- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    // Append the new data to receivedData.
    // receivedData is an instance variable declared elsewhere.
    [receivedData appendData:data];
    NSString*   serverResponseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
    
   
    
    if (!serverResponseString)
    {
        for (int i=0; i<5; i++)
        {
            if (i==0)
            {
                serverResponseString = [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding];
                break;
            }
            else if (i==1)
            {
                serverResponseString = [[NSString alloc] initWithData:data encoding:NSUnicodeStringEncoding];
                break;
            }
            else if (i==2)
            {
                serverResponseString = [[NSString alloc] initWithData:data encoding:NSISOLatin1StringEncoding];
                break;
            }
            else if (i==3)
            {
                serverResponseString = [[NSString alloc] initWithData:data encoding:NSISOLatin2StringEncoding];
                break;
                
            }
            else if (i==4)
            {
                serverResponseString = [[NSString alloc] initWithData:data encoding:NSSymbolStringEncoding];
                break;
            }
        }
    }
    
//     NSLog(@"%@",serverResponseString);
    
    if (fullresposeString==nil)
    {
        fullresposeString=serverResponseString;
    }
    else
    {
        fullresposeString= [fullresposeString stringByAppendingString:serverResponseString];
    }
    
    
}



- (NSMutableDictionary*)parseDataWithString:(NSString*)parsingString
{
    
    XMLDictionaryParser *xmlDoc = [[XMLDictionaryParser alloc] init];
    xmlDoc.stripEmptyNodes=NO;
    xmlDoc.trimWhiteSpace=NO;
     parsedDictornary= [[NSMutableDictionary alloc] initWithDictionary:[xmlDoc dictionaryWithString:parsingString]];
    
    [parsedDictornary removeObjectForKey:@"__name"];
    
    return parsedDictornary;
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
        receivedData = nil;
    
    if([[self delegate] respondsToSelector:@selector(delegateServiceErrorMessage:withServiceName:withErrorCode:)])
    {
        
        [[self delegate] delegateServiceErrorMessage:[NSString stringWithFormat:@"%@",[error localizedDescription]] withServiceName:currentServiceName withErrorCode:[NSString stringWithFormat:@"%ld",(long)error.code]];
        
//        [[self delegate] delegateDidGetServiceErrorMessage:[NSString stringWithFormat:@"%@ %@",[error localizedDescription],[[error userInfo] objectForKey:NSURLErrorFailingURLStringErrorKey]] WithServiewName:currentServiceName WithRetryController:self];
    }
    
    
    
    
    
}
- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    // do something with the data
    // receivedData is declared as a property elsewhere
    if ([receivedData length]>0)
    {
        if ([fullresposeString containsString:@"MySqlError"])
        {
            NSArray* stringArray=[fullresposeString componentsSeparatedByString:@"<Root>"];
            
            if ([stringArray count]>1)
            {
                parsedDictornary= [self parseDataWithString:[NSString stringWithFormat:@"<Root>%@",[stringArray lastObject]]];
            }
            else
            {
                
            }
            
            
        }
        else
        {
            parsedDictornary= [self parseDataWithString:fullresposeString];
            
        }
        
        if([[self delegate] respondsToSelector:@selector(delegateDidGetServiceResponseWithDetails:WIthServiceName:)])
        {
            [[self delegate] delegateDidGetServiceResponseWithDetails:parsedDictornary WIthServiceName:currentServiceName];
        }
        
        
        fullresposeString=nil;
    }
    else
    {
        if([[self delegate] respondsToSelector:@selector(delegateServiceErrorMessage:withServiceName:withErrorCode:)])
        {
            
            [[self delegate] delegateServiceErrorMessage:@"No data found for this API" withServiceName:currentServiceName withErrorCode:@"0"];
            
        }
        
    }
    
    receivedData = nil;
    
    
    
}



#pragma mark -Converting String to URL format
-(NSString *)encodeURIComponent:(NSString *)string
{
    NSString *s = [string stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    return s;
}

#pragma mark - internet connection

@end
