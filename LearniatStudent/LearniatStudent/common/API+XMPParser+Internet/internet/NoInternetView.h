//
//  NoInternetView.h
//  APIManager
//
//  Created by mindshift_Deepak on 18/11/15.
//  Copyright © 2015 mindShiftApps. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NoInternetView : UIView
@property (weak, nonatomic) IBOutlet UIImageView *backGroundImagVIew;

@property (weak, nonatomic) IBOutlet UIButton *mRetryButton;

- (IBAction)onRetryButton:(id)sender;


@end
