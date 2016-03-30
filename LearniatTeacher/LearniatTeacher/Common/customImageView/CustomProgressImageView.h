//
//  CustomProgressImageView.h
//  Learniat Teacher
//
//  Created by Deepak MK on 08/10/15.
//  Copyright (c) 2015 Mindshift Applications and Solutions Private Ltd. All rights reserved.
//


#define ProgressIndicatorArray                                                                                                                   [[NSArray alloc] initWithObjects:                                                                                                                                             [UIImage imageNamed:@"indicator1.png"],                                                                                              [UIImage imageNamed:@"indicator2.png"],                                                                                              [UIImage imageNamed:@"indicator3.png"],                                                                                              [UIImage imageNamed:@"indicator4.png"],                                                                                              [UIImage imageNamed:@"indicator5.png"],                                                                                              [UIImage imageNamed:@"indicator6.png"],                                                                                              [UIImage imageNamed:@"indicator7.png"],                                                                                              [UIImage imageNamed:@"indicator8.png"],                                                                                              [UIImage imageNamed:@"indicator9.png"],                                                                                              [UIImage imageNamed:@"indicator10.png"],                                                                                              [UIImage imageNamed:@"indicator11.png"],                                                                                              [UIImage imageNamed:@"indicator12.png"],                                                                                           nil]




#import <UIKit/UIKit.h>
#import "UIDownloadBar.h"
#import "LBorderView.h"
#import "ICDMaterialActivityIndicatorView.h"
@interface CustomProgressImageView : UIImageView<NSURLConnectionDataDelegate,UIDownloadBarDelegate>
{
    UIImageView                                 *_progressBarImageView;
    UIDownloadBar                               *bar;
    NSString                                    *savingImagePath;
     id                                         _delgate;
    

}

- (void) setImageWithUrl:(NSString*)Url WithSavingPath:(NSString*)savingPath withPlaceHolderName:(NSString*)imageName withBorderRequired:(BOOL)status withColor:(UIColor*)color;


- (void) setdelegate:(id)delegate;

- (id)   delegate;

@end

@protocol CustomProgressImageViewDelegate <NSObject>

- (void) downloadingCompletedWithImage:(UIImage*)image;

@end
