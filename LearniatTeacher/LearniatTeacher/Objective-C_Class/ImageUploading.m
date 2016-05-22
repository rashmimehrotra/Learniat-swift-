//
//  ImageUploading.m
//  LearniatTeacher
//
//  Created by Deepak MK on 12/04/16.
//  Copyright © 2016 Mindshift. All rights reserved.
//

#import "ImageUploading.h"

#define kUplodingServer     @"http://54.251.104.13/Jupiter/upload_photos.php"

@implementation ImageUploading


- (void) setDelegate:(id)delegate
{
    _delegate=delegate;
}
- (id)delegate
{
    return _delegate;
}

- (void) uploadImageWithImage:(UIImage*)image withImageName:(NSString*)imageName withUserId:(NSString*)userId
{
 
    NSData *img = UIImagePNGRepresentation(image);
    
    NSString *urlString = kUplodingServer;
    
    NSMutableURLRequest *request= [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:urlString]];
    [request setHTTPMethod:@"POST"];
    [request setValue:userId forHTTPHeaderField:@"UserId"];
    
    NSString *boundary = @"---------------------------14737809831466499882746641449";
    
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@",boundary];
    [request addValue:contentType forHTTPHeaderField: @"Content-Type"];
    
    NSMutableData *postbody = [NSMutableData data];
    
    [postbody appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    
    
    [postbody appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"userfile\"; filename=\"%@.png\"\r\n",imageName] dataUsingEncoding:NSUTF8StringEncoding]];
    
    [postbody appendData:[@"Content-Type: application/octet-stream\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    
    [postbody appendData:[NSData dataWithData:img]];
    [postbody appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    
    [request setHTTPBody:postbody];
    
    
    
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                               
                               NSHTTPURLResponse* httpResponse = (NSHTTPURLResponse*)response;
                               
                               if ([httpResponse statusCode] == 200)
                               {
                                   
                                   //nslog(@"%@",data);
                                   [self uploadedWithName:imageName];
                               }
                               else
                               {
                                   [self ErrorInUploadingWithName:imageName];
                               }
                               
                           }];
}





- (void) uploadedWithName:(NSString*)imageName
{
    [[self delegate] ImageUploadedWithName:imageName];
  
}
- (void) ErrorInUploadingWithName:(NSString*)imageName
{
    
    [[self delegate]ErrorInUploadingWithName:imageName];
}

- (UIImage*)getImageWithBadgeId:(int)badgeId
{
    NSString *imagePathString = [NSString stringWithFormat:@"/badges/%d.png",badgeId];
    NSString  *jpgPath = [NSTemporaryDirectory()stringByAppendingPathComponent:imagePathString];
    
    UIImage *img = [UIImage imageWithContentsOfFile:jpgPath];
    
    return img;
}


@end



@implementation NSMutableArray (Shuffle)

- (void)shuffle
{
    NSUInteger count = [self count];
    for (NSUInteger i = 0; i < count; ++i) {
        // Select a random element between i and end of array to swap with.
        NSInteger nElements = count - i;
        NSInteger n = arc4random_uniform((u_int32_t)nElements) + i;
        [self exchangeObjectAtIndex:i withObjectAtIndex:n];
    }
}

@end
