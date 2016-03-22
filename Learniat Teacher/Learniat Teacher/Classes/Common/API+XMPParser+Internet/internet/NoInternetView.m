//
//  NoInternetView.m
//  APIManager
//
//  Created by mindshift_Deepak on 18/11/15.
//  Copyright © 2015 mindShiftApps. All rights reserved.
//

#import "NoInternetView.h"
#import "Reachability.h"
@implementation NoInternetView

- (void) awakeFromNib
{
    [self setBackgroundColor:[UIColor colorWithRed:46.0/255.0 green:88.0/255.0 blue:128.0/255.0 alpha:1.0]];
    [self.backGroundImagVIew setBackgroundColor:[UIColor colorWithRed:36.0/255.0 green:68.0/255.0 blue:99/255.0 alpha:1.0]];
    
}

- (IBAction)onRetryButton:(id)sender
{
    if ([[Reachability sharedReachability] internetConnectionStatus] == NotReachable)
    {
      
    }
    else
    {
        [self removeFromSuperview];
    }
}
@end
