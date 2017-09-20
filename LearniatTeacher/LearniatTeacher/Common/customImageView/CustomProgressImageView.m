//
//  CustomProgressImageView.m
//  Learniat Teacher
//
//  Created by Deepak MK on 08/10/15.
//  Copyright (c) 2015 Mindshift Applications and Solutions Private Ltd. All rights reserved.
//

#import "CustomProgressImageView.h"
@implementation CustomProgressImageView
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        
        
       
        
    }
    return self;
}
- (void) setImageWithUrl:(NSURL*)Url WithSavingPath:(NSString*)savingPath withPlaceHolderName:(NSString*)imageName withBorderRequired:(BOOL)status withColor:(UIColor*)color
{

    if (!_progressBarImageView)
    {
        _progressBarImageView= [[UIImageView alloc] initWithFrame:CGRectMake((self.frame.size.width-self.frame.size.width/2)/2,(self.frame.size.height-self.frame.size.width/2)/2,self.frame.size.width/2,self.frame.size.width/2)];
        [self addSubview:_progressBarImageView];
        self.contentMode=UIViewContentModeScaleAspectFill;
        _progressBarImageView.animationImages = ProgressIndicatorArray;
        _progressBarImageView.animationDuration = 1;

    }
    
    savingImagePath=savingPath;
    _progressBarImageView.hidden=NO;
    [_progressBarImageView startAnimating];
    self.image=[UIImage imageNamed:imageName];
    
       
    
   if(![[NSFileManager defaultManager] fileExistsAtPath:savingPath])
    {
        
//         NSLog(@"%@",Url);
        if (Url != nil)
        {
            bar= [[UIDownloadBar alloc] initWithURL:Url progressBarFrame:self.frame timeout:120 delegate:self];
        }
        
        
       
    }
    else
    {
        
        [self setImage:[self resizeImage:[UIImage imageWithContentsOfFile:savingPath] imageSize:self.frame.size]];
        _progressBarImageView.hidden=YES;
        [_progressBarImageView stopAnimating];
    }
    
    
  
   
}


#pragma mark - Delegate Methods
- (void)downloadBar:(UIDownloadBar *)downloadBar didFinishWithData:(NSData *)fileData suggestedFilename:(NSString *)filename {
    //	NSLog(@"%@", filename);
    //    NSLog(@"%@",fileData);
    
    UIImage *img=[UIImage imageWithData:fileData];
  
    //store locally data into the resource folder.
    
    if (savingImagePath)
    {
        [fileData writeToFile:savingImagePath atomically:YES];
    }
    [self setImage:[self resizeImage:img imageSize:self.frame.size]];
    [[self delegate] downloadingCompletedWithImage:img];
    [_progressBarImageView setHidden:YES];
    [_progressBarImageView stopAnimating];
}

-(UIImage*)resizeImage:(UIImage *)image imageSize:(CGSize)size
{
    UIGraphicsBeginImageContext(size);
    [image drawInRect:CGRectMake(0,0,size.width,size.height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    //here is the scaled image which has been changed to the size specified
    UIGraphicsEndImageContext();
    return newImage;
    
}




- (void)downloadBar:(UIDownloadBar *)downloadBar didFailWithError:(NSError *)error
{
    [_progressBarImageView setHidden:YES];
    [_progressBarImageView stopAnimating];
}

- (void)downloadBarUpdated:(UIDownloadBar *)downloadBar
{
//    _progressBar.progress=downloadBar.progress/100;
}
- (void) setdelegate:(id)delegate
{
    _delgate= delegate;
}
- (id)   delegate
{
    return _delgate;
}


@end
