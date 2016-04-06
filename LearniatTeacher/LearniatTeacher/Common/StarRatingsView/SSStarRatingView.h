//
//  SSStarRatingView.h
//  Learniat Teacher
//
//  Created by Amith Kumar on 03/01/14.
//  Copyright (c) 2015 Mindshift Applications and Solutions Private Ltd. All rights reserved.
//
//

#import <UIKit/UIKit.h>

@interface SSStarRatingView : UIView {

   
    BOOL      _canEdit;
    NSInteger _rating;
    id _delegate;
    NSInteger _starSize;
}

- (void) setStarRating:(NSInteger) rating;
- (NSInteger) rating;

- (void) setEditable:(BOOL) editable;

- (void) setDelegate:(id) del;
- (id) delegate;


- (void) setsizeOfStar:(NSInteger) starSize;
- (NSInteger) starSize;


@end


@protocol SSStarRatingViewDelegate <NSObject>

- (void) starRatingDidChange;

@end