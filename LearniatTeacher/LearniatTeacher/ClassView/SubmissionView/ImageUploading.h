//
//  ImageUploading.h
//  LearniatTeacher
//
//  Created by Deepak MK on 12/04/16.
//  Copyright © 2016 Mindshift. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface ImageUploading : NSObject
{
     id                                 _delegate;
}
- (void) uploadImageWithImage:(UIImage*)image withImageName:(NSString*)imageName withUserId:(NSString*)userId;

- (void) setDelegate:(id)delegate;
- (id)delegate;

- (UIImage*)getImageWithBadgeId:(int)badgeId;

@end
@protocol ImageUploadingDelegate <NSObject>

- (void) ImageUploadedWithName:(NSString*)name;
- (void) ErrorInUploadingWithName:(NSString*)name;

@end